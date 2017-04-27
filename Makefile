all: clean build test

clean:
	rm -f lib/*

build:
	utils/compile-libs.sh

test:
	tests/teststyle.sh
	tests/testunits.sh
