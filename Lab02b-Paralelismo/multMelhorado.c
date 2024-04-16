#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define N 180      // Tamanho das matrizes
#define BLOCK_SIZE 30  // Tamanho do bloco

int A[N][N];
int B[N][N];
int C[N][N];

// Função que será executada por cada thread para calcular um bloco de C
void *multiply(void *arg) {
    int *blockArgs = (int *)arg;
    int startRow = blockArgs[0];
    int endRow = blockArgs[1];

    // Calcula os elementos do bloco de C
    for (int i = startRow; i < endRow; i++) {
        for (int j = 0; j < N; j++) {
            C[i][j] = 0; // Inicializa o elemento da matriz C como 0
            for (int k = 0; k < N; k++) {
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }

    // Libera a memória alocada para os argumentos do bloco
    free(blockArgs);

    // Encerra a thread
    pthread_exit(NULL);
}

int main() {
    int valor = 1;

    // Inicializando as matrizes A e B
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            A[i][j] = valor;
            B[i][j] = valor;
            valor++;
        }
    }

    // Declara um array de threads
    pthread_t threads[N / BLOCK_SIZE];

    // Cria as threads para calcular cada bloco de C
    for (int i = 0; i < N; i += BLOCK_SIZE) {
        // Aloca memória para os argumentos do bloco
        int *blockArgs = (int *)malloc(2 * sizeof(int));
        blockArgs[0] = i;
        blockArgs[1] = i + BLOCK_SIZE;

        // Cria a thread chamando a função multiply com os argumentos
        pthread_create(&threads[i / BLOCK_SIZE], NULL, multiply, blockArgs);
    }

    // Aguarda as threads terminarem
    for (int i = 0; i < N / BLOCK_SIZE; i++) {
        pthread_join(threads[i], NULL);
    }

    return 0;
}
