#include <stdio.h>
#include <stdbool.h>
#include <string.h>

#define BOARD_SIZE 8

// Função para verificar se a posição está dentro do tabuleiro
bool dentroTabuleiro(int x, int y) {
    return x >= 0 && x < BOARD_SIZE && y >= 0 && y < BOARD_SIZE;
}

// Função para verificar se o rei está em xeque
bool reiEmXeque(char tabuleiro[BOARD_SIZE][BOARD_SIZE]) {
    int dx[] = {1, 1, 1, 0, 0, -1, -1, -1};
    int dy[] = {1, 0, -1, 1, -1, 1, 0, -1};

    // Encontra a posição do rei branco
    int reiX = -1, reiY = -1;
    for (int i = 0; i < BOARD_SIZE; i++) {
        for (int j = 0; j < BOARD_SIZE; j++) {
            if (tabuleiro[i][j] == 'K') {
                reiX = i;
                reiY = j;
                break;
            }
        }
    }

    if (reiX == -1 || reiY == -1) {
        // Se não encontrou o rei branco, algo está errado
        return false;
    }

    // Verifica se alguma peça preta está atacando o rei
    for (int i = 0; i < 8; i++) {
        int newX = reiX + dx[i];
        int newY = reiY + dy[i];

        if (dentroTabuleiro(newX, newY) && tabuleiro[newX][newY] >= 'a' && tabuleiro[newX][newY] <= 'z') {
            return true;
        }
    }

    return false;
}

int main() {
    char tabuleiro[BOARD_SIZE][BOARD_SIZE] = {
        "tcbdrbct",
        "pppppppp",
        "8",
        "8",
        "8",
        "8",
        "PPPPPPPP",
        "TCBDRBCT"
    };

    bool xeque = reiEmXeque(tabuleiro);

    if (xeque) {
        printf("O rei branco está em xeque!\n");
    } else {
        printf("O rei branco não está em xeque.\n");
    }

    return 0;
}
