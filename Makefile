all: clean build test

clean:
	rm -f lib/*

build:
	utils/compile-libs.sh

test:
	test/teststyle.sh
	test/testunits.sh
