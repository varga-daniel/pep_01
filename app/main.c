#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <string.h>

#include <stopper.h>

int main(int argc, char const *argv[])
{
    stopperOMP sw;

    const char *word = argv[1];
    const int threads = atoi(argv[2]);
    const char *file = argv[3];

    int count = 0;
    const int word_length = strlen(word);

    omp_lock_t lock;
    omp_init_lock(&lock);

    if (strstr(word, " ") != NULL)
    {
        return 1;
    }

    if (word_length > 10)
    {
        return 2;
    }

    startSOMP(&sw);

    char *buffer = 0;
    long length;
    FILE *f = fopen(file, "rb");

    if (f)
    {
        fseek(f, 0, SEEK_END);
        length = ftell(f);
        fseek(f, 0, SEEK_SET);

        buffer = malloc(length + 1);

        if (buffer)
        {
            fread(buffer, 1, length, f);
        }

        fclose(f);
        buffer[length] = '\0';
    }

    if (buffer)
    {
#pragma omp parallel for num_threads(threads) shared(count)
        for (long i = 0; i < (length - word_length); i += word_length / 2)
        {
            char searched[word_length];
            memcpy(searched, &buffer[i], word_length);

            // printf("%s | %s | %s\n", searched, word, strstr(searched, word));

            if (strstr(searched, word) != NULL)
            {
                omp_set_lock(&lock);
                ++count;
                omp_unset_lock(&lock);
            }
        }
    }

    omp_destroy_lock(&lock);

    stopSOMP(&sw);

    tprintfOMP(&sw, "%d\n", length);
    return 0;
}