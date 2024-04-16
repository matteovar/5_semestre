-- Função que totaliza a cada 3 elementos da lista
tot3 [] = [] -- Lista vazia retorna lista vazia
tot3 xs = map sum (divide_lista 3 xs)
 
divide_lista n [] = [] -- Função auxiliar para dividir a lista em grupos de 3
divide_lista n ys = take n ys : divide_lista n (drop n ys)
