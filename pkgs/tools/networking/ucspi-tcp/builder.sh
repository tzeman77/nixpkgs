source $stdenv/setup

PATH=$dietlibc/bin:$PATH

tar xzvf $src
cd ucspi-tcp-*
echo $out > conf-home
echo "diet gcc" > conf-cc
echo "diet gcc -s -static" > conf-ld
make
make setup check
