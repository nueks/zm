# zm


## test command
```shell
$ docker run -it --rm --name zm -w /root \
  -v $(pwd)/sample/zshrc:/root/.zshrc archlinux \
  sh -c "pacman -Sy --noconfirm zsh git vim; exec zsh"
```


or

```shell
$ docker run -d --rm --name zm -w /root \
  -v $(pwd)/sample/zshrc:/root/.zshrc archlinux \
  sh -c "pacman -Sy --noconfirm zsh git vim; sleep inf"
```

```shell
$ docker exec -it -w /root zm zsh
```


## loading time
```shell
$ for i in $(seq 1 10); do time zsh -i -c exit; done
```
