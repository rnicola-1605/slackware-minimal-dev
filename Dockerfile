from vbatts/slackware:14.2

RUN mkdir -p /var/lib/slackpkg && \
    touch /var/lib/slackpkg/current

RUN slackpkg update gpg
RUN slackpkg -batch=on -default_answer=y update
RUN slackpkg -batch=on -default_answer=y install aaa_glibc-solibs aaa_libraries
RUN slackpkg -batch=on -default_answer=y removepkg glibc-solibs aaa_elflibs
RUN slackpkg -batch=on -default_answer=y upgrade slackpkg
RUN slackpkg -batch=on -default_answer=O new-config
RUN sed -i '/^http/s/https:\/\/mirrors\.slackware\.com\/slackware\/slackware64-14\.2/http:\/\/mirrors\.us\.kernel\.org\/slackware\/slackware64-14.2/' /etc/slackpkg/mirrors
RUN slackpkg -batch=on -default_answer=y update
RUN slackpkg -batch=on -default_answer=y upgrade pkgtools
RUN slackpkg -batch=on -default_answer=y upgrade-all

# openssl is already installed in the default image, perl depends on e2fsprogs!
RUN slackpkg -batch=on -default_answer=y install e2fsprogs libtasn1 nettle perl p11-kit ca-certificates
RUN update-ca-certificates -f

# Dependencias
RUN slackpkg -batch=on -default_answer=y install curl dcron && \
    slackpkg -batch=on -default_answer=y install vim sasl rsync-* glibc-2.33  && \
    slackpkg -batch=on -default_answer=y install automake gcc pkg-config binutils && \
    slackpkg -batch=on -default_answer=y install libffi gettext-tools intltool  && \
    slackpkg -batch=on -default_answer=y install gmp libsodium openssl-solibs && \
    slackpkg -batch=on -default_answer=y install kernel-headers m4 libmpc pcre libxslt && \
    slackpkg -batch=on -default_answer=y install guile gc tk-8.6.5 pygtk-2.24 tcl-8.6.5 && \
    slackpkg -batch=on -default_answer=y install tclx-8.4.1 expat-2.2.8 readline-6.3 libxml2-2.9.5

# # Dependencias
RUN slackpkg -batch=on -default_answer=y install zlib && \
    slackpkg -batch=on -default_answer=y install lzlib && \
    slackpkg -batch=on -default_answer=y install make && \
    slackpkg -batch=on -default_answer=y install cmake && \
    slackpkg -batch=on -default_answer=y install gccmakedep && \
    slackpkg -batch=on -default_answer=y install tmux && \
    slackpkg -batch=on -default_answer=y install git && \
    slackpkg -batch=on -default_answer=y install libtool && \
    slackpkg -batch=on -default_answer=y install autoconf && \
    slackpkg -batch=on -default_answer=y install autoconf-archive && \
    slackpkg -batch=on -default_answer=y install python && \
    slackpkg -batch=on -default_answer=y install python-pip


# Dependencias
RUN mkdir -p /pacotes && cd /pacotes && \
    wget -r -nd --no-parent http://ftp.slackware-brasil.com.br/slackware64-14.2/slackware64/a/ && \
    upgradepkg --install-new $(ls | grep .txz$) && rm -r /pacotes

# Dependencias
RUN mkdir -p /pacotes && cd /pacotes && \
    wget -r -nd --no-parent http://ftp.slackware-brasil.com.br/slackware64-14.2/slackware64/ap/ && \
    rm -f joe-* && \
    rm -f jed-0.99* && \
    upgradepkg --install-new $(ls | grep .txz$) && rm -r /pacotes

# Dependencias
RUN mkdir -p /pacotes && cd /pacotes && \
    wget -r -nd --no-parent http://ftp.slackware-brasil.com.br/slackware64-14.2/slackware64/d/ && \
    rm -f ruby-2.2.5* && \
    rm -f subversion-* && \
    rm -f python3-3.* && \
    upgradepkg --install-new $(ls | grep .txz$) && rm -r /pacotes

# Dependencias
RUN mkdir -p /pacotes && cd /pacotes && \
    wget -r -nd --no-parent http://ftp.slackware-brasil.com.br/slackware64-14.2/slackware64/l/ && \
    rm -f tango-ico* && \
    rm -f gnome-themes* && \
    rm -f gsettings-desktop-* && \
    rm -f shared-desktop* && \
    rm -f sound-theme-fre* && \
    upgradepkg --install-new $(ls | grep .txz$) && rm -r /pacotes

# Dependencias
RUN mkdir -p /pacotes && cd /pacotes && \
    wget -r -nd --no-parent http://ftp.slackware-brasil.com.br/slackware64-14.2/slackware64/t/ && \
    upgradepkg --install-new $(ls | grep .txz$) && rm -r /pacotes

# Dependencias do X
RUN mkdir -p /pacotes && cd /pacotes && \
    wget -r -nd --no-parent http://ftp.slackware-brasil.com.br/slackware64-14.2/slackware64/x/ && \
    upgradepkg --install-new $(ls | grep .txz$) && rm -r /pacotes

# Atualiza os pacotes do S.O
RUN slackpkg -batch=on -default_answer=y update
RUN slackpkg -batch=on -default_answer=y upgrade-all

# Instala SBo e o Python 3.
RUN mkdir -p /tmp/install && cd /tmp/install && \
       wget -c https://pink-mist.github.io/sbotools/downloads/sbotools-2.7-noarch-1_SBo.tgz && \
       installpkg sbotools-2.7-noarch-1_SBo.tgz && \
       mkdir -p /tmp/SBo && sbosnap fetch && \
       sboinstall -r python3 && sboclean -wd

