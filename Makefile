all: clean test

clean:
	rm -f lib/*

build:
	utils/compile-libs.sh

test: build
	test/teststyle.sh
	test/testunits.sh
