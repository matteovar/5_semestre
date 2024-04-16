#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define N 180  // Tamanho das matrizes

int A[N][N];
int B[N][N];
int C[N][N];

// Função que será executada por cada thread para calcular um elemento de C
void *multiply(void *arg) {
    int *args = (int *)arg;
    int row = args[0];
    int col = args[1];

    // Inicializa o elemento da matriz C como 0
    C[row][col] = 0;

    // Calcula o elemento C[row][col] como a soma dos produtos correspondentes de A e B
    for (int k = 0; k < N; k++) {
        C[row][col] += A[row][k] * B[k][col];
    }

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

    // Declara uma matriz de threads
    pthread_t threads[N][N];

    // Cria as threads para calcular cada elemento de C
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            // Aloca memória para os argumentos da thread (linha e coluna)
            int *args = (int *)malloc(2 * sizeof(int));
            args[0] = i;
            args[1] = j;

            // Cria a thread chamando a função multiply com os argumentos
            pthread_create(&threads[i][j], NULL, multiply, args);
        }
    }

    // Aguarda as threads terminarem
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            pthread_join(threads[i][j], NULL);
        }
    }
    return 0;
}
