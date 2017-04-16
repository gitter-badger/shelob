clean:
	rm -f shelob; rm -rf lib/*

install:
	git submodule update --init --remote --recursive --quiet
	bpkg getdeps

build:
	utils/compile.sh && \
	utils/compile-libs.sh

test:
	utils/test.sh


