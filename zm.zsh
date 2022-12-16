# forked from 
# - https://github.com/mattmc3/zsh_unplugged
# - https://github.com/zap-zsh/zap
#
# add 'zm.load romkatv/zsh-defer' first for faster plugin loading
#
# example for ohmyzsh
# zm.clone ohmyzsh/ohmyzsh
# zm.source ohmyzsh/ohmyzsh/plugins/magic-enter
# zm.source ohmyzsh/ohmyzsh/plugins/history-substring-search
export ZM_DIR="$HOME/.local/share/zm"
export ZM_PLUGIN_DIR="$ZM_DIR/plugins"

_help() {
    cat <<-EOF
zm [COMMANDS]

COMMANDS:
    help        help
    list        list plugins
    update      update plugins
    compile     compile plugins
    clean       clean plugins
    info        git logs for zm
EOF
}

zm.load() {
    plugin=$1
    zm.clone $plugin
    plugindir=$ZM_PLUGIN_DIR/${plugin:t}
    initfile=$plugindir/${plugin:t}.plugin.zsh

    if [[ ! -e $initfile ]]; then
        local -a initfiles=($plugindir/*.plugin.{z,}sh(N) $plugindir/*.{z,}sh{-theme,}(N))
        (( $#initfiles )) || { echo >&2 "No init file found '$plugin'." && return }
        ln -sf "${initfiles[1]}" "$initfile"
    fi
    fpath+=$plugindir
    (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
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
    echo "zm.source"
    plugin=$1
    echo "plugin: $plugin"
    plugindir=$ZM_PLUGIN_DIR/${plugin}
    echo "plugin dir: $plugindir"
    initfile=$plugindir/${plugin:t}.plugin.zsh
    echo "initfile: $initfile"
    if [[ ! -e $initfile ]]; then
        local -a initfiles=($plugindir/*.plugin.{z,}sh(N) $plugindir/*.{z,}sh{-theme,}(N))
        (( $#initfiles )) || { echo >&2 "No init file found '$plugin'." && return }
        ln -sf "${initfiles[1]}" "$initfile"
    else:
        echo "not found $initfile"

    fi
    fpath+=$plugindir
    (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
}

_list() {
    echo "Installed Plugins"
    for d in $ZM_PLUGIN_DIR/*/.git; do        
        echo " - ${d:h:t}"
    done 2>& /dev/null
}

_update_all() {
    for d in $ZM_PLUGIN_DIR/*/.git; do
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

_info() {
    # GIT_DIR="$ZM_DIR/.git"
    git --no-pager -C $ZM_DIR log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
}

typeset -A opts
opts=(
    help "_help"
    list "_list"
    update "_update_all"
    compile "_compile_all"
    clean "_clean_all"
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