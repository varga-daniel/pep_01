#!/bin/bash

# ==============
# HASZNÁLAT:
#   ./adat_generalas.sh

# Töröljük a data/ mappát, ha kell.
if [ -d "data" ]; 
then
    rm -R data/
    echo "data/ mappa törölve."
fi
mkdir data/
echo "data/ mappa létrehozva."

for i in $(seq -w 010000 10000 500000)
do
    echo -e "\033[1;33m$i\033[0m bekezdés generálása..."
    ./lorem_ipsum_gen.pl $i >> data/$i.txt &
done

wait

echo -e "\033[1;32mMinden szöveg legenerálva!\033[0m"