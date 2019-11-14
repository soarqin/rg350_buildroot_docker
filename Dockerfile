FROM centos:7 as dev

RUN yum update -y && yum install -y autoconf automake bc bison bzip2 flex fontconfig freetype gcc-c++ git glibc-devel glibc-devel.i686 java-1.8.0-openjdk-devel libgcc.i686 libstdc++.i686 m4 make mercurial patch perl-ExtUtils-MakeMaker rsync squashfs-tools subversion unzip wget which && yum clean all

FROM dev as builder
RUN git clone https://github.com/tonyjih/RG350_buildroot /src/buildroot
COPY rg350_defconfig /src/buildroot/configs/
WORKDIR /src/buildroot
RUN make rg350_defconfig && make

FROM dev
WORKDIR /root
ENV PATH="/opt/gcw0-toolchain/usr/bin:$PATH"
COPY --from=builder /opt/gcw0-toolchain /opt/gcw0-toolchain
CMD ["/usr/bin/bash"]
