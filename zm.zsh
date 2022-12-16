export ZM_HOME=${ZM_HOME:-"$HOME/.local/share/zm"}
export ZM_PLUGIN_DIR="$ZM_HOME/plugins"

_help() {
    cat $ZM_HOME/usage.txt
}

zm.load() {
    plugin=$1
    init=$2
    zm.clone $plugin
    zm.source $plugin $init
}

zm.clone() {
    plugin=$1
    plugindir=$ZM_PLUGIN_DIR/${plugin:t}
    if [[ ! -d $plugindir ]]; then
        echo "Cloning $plugin..."
        git clone -q --depth 1 --recursive --shallow-submodules https://github.com/$plugin $plugindir
    fi
}

zm.source() {
    plugin=$1
    init=$2
    if [[ ! -z init ]]; then
        plugindir=$ZM_PLUGIN_DIR/${plugin:t}
    else
        plugindir=$ZM_PLUGIN_DIR/${plugin:t}/$init
    fi
    initfile=$plugindir/${plugin:t}.plugin.zsh
    if [[ ! -e $initfile ]]; then
        local -a initfiles=($plugindir/*.plugin.{z,}sh(N) $plugindir/*.{z,}sh{-theme,}(N))
        (( $#initfiles )) || { echo >&2 "No init file found '$plugin'." && return }
        ln -sf "${initfiles[1]}" "$initfile"
    fi
    fpath+=$plugindir
    (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
}

_list() {
    echo "Installed Plugins"
    for d in $ZM_PLUGIN_DIR/**/.git; do
        echo " - ${d:h:t}"
    done 2>& /dev/null
}

_update_all() {
	echo "Updating zm..."
	command git -C $ZM_HOME pull --ff --recurse-submodules --depth 1 --rebase --autostash
    for d in $ZM_PLUGIN_DIR/**/.git; do
        echo "Updating ${d:h:t}..."
        command git -C "${d:h}" pull --ff --recurse-submodules --depth 1 --rebase --autostash
    done
}

_compile_all() {
    autoload -U zrecompile
    local f
    for f in $ZM_PLUGIN_DIR/**/*.zsh{,-theme}(N); do
        echo "compile $f"
        zrecompile -pq "$f"
    done
}

_clean_all() {
    rm -rf $ZM_PLUGIN_DIR
}

_bench() {
    for i in $(seq 1 10); do time zsh -i -c exit; done
}

_info() {
    # GIT_DIR="$ZM_DIR/.git"
    git --no-pager -C $ZM_HOME log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -n5
}

typeset -A opts
opts=(
    help "_help"
    list "_list"
    update "_update_all"
    compile "_compile_all"
    clean "_clean_all"
    bench "_bench"
    info "_info"
)

zm() {
    if [[ -z "$opts[$1]" ]]; then
        _help
        return 1
    fi
    opt="${opts[$1]}"
    $opt
}
