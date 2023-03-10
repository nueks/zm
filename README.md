# zm

this code is from
- https://github.com/mattmc3/zsh_unplugged
- https://github.com/zap-zsh/zap

## Install

add this code to the top of your `.zshrc` file
```
ZM_HOME=${HOME}/.local/share/zm
source ${ZM_HOME}/zm.zsh 2> /dev/null || {
    mkdir -p $(dirname $ZM_HOME)
    git clone https://github.com/nueks/zm $ZM_HOME
    source ${ZM_HOME}/zm.zsh
}
zm.load romkatv/zsh-defer
```



## test command
```shell
$ docker run -it --rm --name zm \
  -v $(pwd)/sample/zshrc:/root/.zshrc \
  zm.env
```

or

```shell
$ docker run -it --rm --name zm \
  -v $(pwd)/sample/zshrc:/root/.zshrc \
  -v $(pwd):/root/.local/share/zm \
  zm.env
```


or

```shell
$ docker run -d --rm --name zm --init \
  -v $(pwd)/sample/zshrc:/root/.zshrc \
  zm.env -c "sleep inf"
```

```shell
$ docker exec -it -w /root zm zsh
```


## loading time
```shell
$ for i in $(seq 1 10); do time zsh -i -c exit; done
```

```shell
$ zm bench
```
