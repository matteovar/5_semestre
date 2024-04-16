# Lab02b - Programação Paralela!

Este é o README para o "Lab02b - Programação Paralela!", desenvolvido em linguagem C. Este documento contém instruções detalhadas sobre como compilar, executar e verificar os resultados do programa entregue.

## Integrantes do grupo
- Felipe Mazzeo Barbosa.
- Matteo Domiciano Varnier.
- Nicolas Fernandes Melnik.

## Como Compilar

Para compilar os programas do laboratório no Linux, siga os passos abaixo:
1. Abra o terminal.
2. Navegue até o diretório do projeto.
3. Para cada programa que deseja compilar, execute o seguinte comando, substituindo [NomeArquivo] pelo respectivo nome do programa: `gcc -o [NomeArquivo].bin [NomeArquivo].c -lpthread`.
4. Por exemplo: você quer compilar o multiplicacaoMatrizes.c, basta executar o comando `gcc -o multiplicacaoMatrizes.bin multiplicacaoMatrizes.c -lpthread`. Assim, é gerado um executável chamado multiplicacaoMatrizes.bin no diretório atual.

## Como Executar

Após compilar o projeto, siga estas etapas para executá-lo:
1. No terminal, certifique-se de estar no diretório onde o executável foi gerado.
2. Execute o seguinte comando: `time taskset -c 0 ./[NomeArquivo].bin`.
3. No comando acima, basta substituir `[NomeArquivo]` pelo nome do arquivo executável gerado pela compilação.
4. No comando utilizamos `time` para que seja possível visualizar o tempo de execução sem afetar o programa em si.
5. No comando, também utilizamos `taskset - c 0`, para especificar quais núcleos estamos utilizando na execução. Esse comando pode ser adaptado da maneira que preferir, mas para essa atividade utilizamos:
- taskset - c 0
- taskset - c 0, 1
- taskset - c 0, 1, 2, 3
- taskset - c 0, 1, 2, 3, 4, 5
- taskset - c 0, 1, 2, 3, 4, 5, 6, 7

## Resultados
Primeiramente, como solictado pelo professor, executamos o comando `cat /proc/cpuinfo` para verificar a configuração do processador utilizado, como é mostrado na imagem a seguir:

<div align="center">
<img src="https://github.com/nicolasmelnik/Laboratorios-Paralela/assets/117850844/c99daa7a-5aaa-4718-b0a7-35b94a2bf08d" width="800px" />
</div>

Construa uma solução paralela e responda às seguintes questões:

1. Qual o tempo de execução serial e paralelo para 1, 2, 4, 6 e 8 processadores? Desenhe um gráfico contendo todos os tempos de execução

<div align="center">
<img src="https://github.com/nicolasmelnik/Laboratorios-Paralela/assets/117850844/f63ed04b-b9a8-4023-bae6-9f0f46d7cfd0" width="800px" />
</div>

<div align="center">
<img src="https://github.com/nicolasmelnik/Laboratorios-Paralela/assets/117850844/e341632e-22a9-470f-a395-2e1b9976adb4"/>
</div>

2. Qual o speedup para 1, 2, 4, 6 e 8 processadores? Desenhe um gráfico mostrando os diferentes valores de speedup.

<div align="center">
<img src="https://github.com/nicolasmelnik/Laboratorios-Paralela/assets/117850844/bc7736b7-bf1f-4adb-b4ee-82eed5ad85b1"/>
</div>

4. Como você acha que poderia melhorar o seu algoritmo para obter maior benefício com o paralelismo?Para provar seu ponto, refaça a solução com essa abordagem e construa um novo gráfico de speedup para 1, 2, 4, 6 e 8 processadores.

Decidimos abordar uma estratégia diferente para se obter o resultado da multiplicação de duas matrizes, ao invés de utilizar uma thread para calcular cada elemento da matriz resultante, decidimos dividir a matriz em blocos, em que cada thread será responsável por realizar os cálculos deste bloco. No código desse laboratório, temos uma matriz 180 x 180 e o tamanho do nosso bloco será 30, ou seja, apenas 6 threads serão responsáveis por calcular os elementos da matriz resultante.

<div align="center">
<img src="https://github.com/nicolasmelnik/Laboratorios-Paralela/assets/117850844/df5504f1-05a1-4a5e-b00c-eb28c599590c" width="800px" />
</div>

<div align="center">
<img src="https://github.com/nicolasmelnik/Laboratorios-Paralela/assets/117850844/028281fb-2a0f-4bd1-a67d-e3317b9cc3f8"/>
</div>
