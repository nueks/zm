FROM archlinux
LABEL maintainer "madgray@gmail.com"

RUN pacman -Sy --noconfirm zsh git vim
RUN sed -i 's#/bin/ash#/bin/bash#g' /etc/passwd

ENV SHELL /bin/zsh
WORKDIR /root
USER root

ENTRYPOINT ["/bin/zsh"]
