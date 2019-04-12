#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

#include <stopper.h>


int main(int argc, char const *argv[])
{
    //stopperOMP sw;

    char *word = argv[1];
    int threads = atoi(argv[2]);

    printf("A keresett szó: %s\nA szálak száma: %d\n", word, threads);

    //startSOMP(&sw);
    //stopSOMP(&sw);   

    //tprintfOMP(&sw, " ");
    return 0;
}