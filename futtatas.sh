#!/bin/bash

# ==============
# HASZNÁLAT:
#   Legalább egynél több paraméterrel kell meghívni.
#   A paraméterként megadott számokat beilleszti a programmeghívásba,
#   mint szálszám.
#   Így pl. a "./futtatas.sh 1 2 4 8" lefuttatja a programot 1 szálon,
#   2 szálon, 4 szálon, és 8 szálon, és azok eredményét menti le, és
#   rajzolja ki.

# A keresett szó.
word="lorem"

# Megnézzük, hogy vannak-e paraméterek.
if [ $# -eq 0 ]; then
    echo "Nem adott meg paramétereket a szkriptnek!"
    echo "Adjon meg egynél több paramétert, ahol a paraméterek megadják, hogy hány szálon futtassa a szkript a programot."
    echo -e "Például, \033[1;33m./futtatas.sh 1 2 4 8\033[0m lefuttatja a programot 1, 2, 4 és 8 szálon."
    exit 1
fi

# Ellenőrizzük, hogy minden paraméter szám-e.
re='^[0-9]+$'
for var in "$@"
do
    if ! [[ $var =~ $re ]]; 
    then
        echo -e "\033[1;31mHiba:\033[0m $var nem egy szám." >&2
        exit 1
    fi

    # És hogy nagyobb-e, mint nulla.
    if [ $var -eq 0 ];
    then
        echo -e "\033[1;31mHiba:\033[0m $var nulla. Nulla szálon nem lehet programot futtatni!" >&2
        exit 1
    fi
done

# Töröljük ki az előző futtatások eredményeit, ha vannak.
if [ -d "results" ]; 
then
    rm -R results/
    echo "results/ mappa törölve."
fi
mkdir results/
echo "results/ mappa létrehozva."

# Ha eddig nem létezett, csináljunk egy data/ mappát.
if [ ! -d "data" ]; 
then
    mkdir data/
    echo "data/ mappa létrehozva."
fi

# Töröljük a build/ mappát, ha kell, és indítsuk onnan a CMake-et.
if [ -d "build" ]; 
then
    rm -R build/
    echo "build/ mappa törölve."
fi
mkdir build/
echo "build/ mappa létrehozva."

cd build/
cmake ..

make clean
make

cd ..

# Futtassuk le a programot.
# Ezt nyilván módosítani kell később, ez csak egy példa rész.
for file in data/*.txt
do
    for threads in "$@"
    do
        echo -e "Keressük a \033[1;34m$word\033[0m szót \033[1;33m$threads\033[0m szálon a \033[1;33m$file\033[0m fájlban..."
        ./build/bin/leszamlal $word $threads $file >> results/$threads.dat
    done
done

echo -e "\033[1;32mAdatgyűjtés kész!\033[0m"

# Legeneráljuk az Rscriptet.
# TODO.

#Rscirpt valami.R

echo -e "\033[1;32mGráf legenerálva!\033[0m"