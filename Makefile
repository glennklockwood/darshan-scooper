.PHONY: all

all: ior/src/ior darshan-3.1.6/install

ior/src/ior: ior/Makefile darshan-3.1.6/install
	(export PE_PKGCONFIG_LIBS="darshan-runtime:$(PE_PKGCONFIG_LIBS)"; \
	export PKG_CONFIG_PATH="$(PWD)/darshan-3.1.6/install/lib/pkgconfig:$(PKG_CONFIG_PATH)"; \
	export LD_LIBRARY_PATH="$(PWD)/darshan-3.1.6/install/lib:$(LD_LIBRARY_PATH)"; \
	export PATH="$(PWD)/darshan-3.1.6/install/bin:$(PATH)"; \
	cd ior && make)

ior/Makefile: ior/configure
	cd ior && ./configure --without-gpfs

ior/configure: ior/configure.ac
	cd ior && autoreconf -ivf

darshan-3.1.6/install/lib/libdarshan.a: darshan-3.1.6/darshan-runtime/Makefile
	cd darshan-3.1.6/darshan-runtime && make && make install

darshan-3.1.6/darshan-runtime/Makefile: darshan-3.1.6/darshan-runtime/Makefile.in
	cd darshan-3.1.6/darshan-runtime && ./configure --prefix=$(PWD)/darshan-3.1.6/install --with-log-path-by-env=DARSHAN_OUTPUT_DIR,SLURM_SUBMIT_DIR,PWD --with-jobid-env=SLURM_JOBID --disable-cuserid --with-mem-align=8 --enable-mmap-logs CC=cc

darshan-3.1.6/darshan-runtime/Makefile.in: darshan-3.1.6.tar.gz
	tar zxf $?

darshan-3.1.6.tar.gz: 
	wget ftp://ftp.mcs.anl.gov/pub/darshan/releases/darshan-3.1.6.tar.gz
