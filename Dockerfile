FROM archlinux

RUN curl -s "https://www.archlinux.org/mirrorlist/?country=DE&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirror && \
    pacman -Syu --noconfirm xfce4 tigervnc xorg vim wget bc && \
    reflector --country Germany --latest 200 --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist && \
    wget -O /usr/local/bin/dumb-init \
      https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64

COPY ./vnc-config/ /root/.vnc/
COPY ./start.sh /entrypoint

RUN chmod +x /root/.vnc/xstartup && \
    chmod +x /entrypoint && \
    chmod +x /usr/local/bin/dumb-init

ENV DISPLAY :1

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]

CMD ["/entrypoint"]
