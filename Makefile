all: clean install build test

clean:
	rm -f bin/*; rm -f lib/*

install:
	git submodule update --init --remote --recursive --quiet

build:
	utils/compile.sh && \
	utils/compile-libs.sh

test: build
	utils/teststyle.sh
	utils/testunits.sh


