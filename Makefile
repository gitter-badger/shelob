all: clean test

clean:
	rm -f lib/*

build:
	utils/compile-libs.sh

test: build
	utils/teststyle.sh
	utils/testunits.sh
