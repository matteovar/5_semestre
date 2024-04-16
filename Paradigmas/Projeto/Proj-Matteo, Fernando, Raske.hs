--Grupo
-- Matteo Domiciano Varnier - 10390247
-- Daniel Reis Raske - 10223349
-- Fernando Pegoraro Bilia - 10402097

-- Importando funções necessárias do módulo Data.Char e Data.List
import Data.Char (isLower, isDigit, digitToInt)
import Data.List (find)
-- Definindo um tipo para representar a posição de uma peça no tabuleiro
type Posicao = (Int, Int)
-- Função para dividir uma string usando os caracteres especificados como delimitadores
split :: [Char] -> String -> [String]
split _ [] = [""]
split delimiters (c:cs)
   | c `elem` delimiters = "" : rest
   | otherwise = (c : head rest) : tail rest
 where
   rest = split delimiters cs
-- Função para localizar as peças no tabuleiro a partir da configuração fornecida
localizarPecas :: String -> [(Posicao, Char)]
localizarPecas config = concatMap posicaoPorLinha (zip [1..] (split ['[', ']', ','] config))
-- Função auxiliar para obter as posições das peças em uma linha
posicaoPorLinha :: (Int, String) -> [(Posicao, Char)]
posicaoPorLinha (linha, pecas) = posicaoPorColuna linha 1 pecas
-- Função auxiliar para obter as posições das peças em uma coluna
posicaoPorColuna :: Int -> Int -> String -> [(Posicao, Char)]
posicaoPorColuna linha coluna [] = []
posicaoPorColuna linha coluna (peca:pecas)
    | isDigit peca = posicaoPorColuna linha (coluna + digitToInt peca) pecas
    | peca == ' '  = posicaoPorColuna linha (coluna + 1) pecas
    | otherwise    = ((linha, coluna), peca) : posicaoPorColuna linha (coluna + 1) pecas
-- Função para verificar o movimento horizontal da torre
movimentoDireita :: Posicao -> Bool -> [(Posicao, Char)] -> Bool
movimentoDireita (x, y) direita pecas
    | y < 1 || y > 8 = False
    | otherwise = case findRookAt (x, if direita then y + 1 else y - 1) pecas of
        Just _ -> True
        Nothing -> movimentoDireita (x, if direita then y + 1 else y - 1) direita pecas
  where
    -- Função auxiliar para encontrar a torre em uma posição específica
    findRookAt :: Posicao -> [(Posicao, Char)] -> Maybe (Posicao, Char)
    findRookAt pos pecas = find (\p -> fst p == pos && snd p == 'R') pecas
-- Função para verificar o movimento vertical da torre
movimentoVertical :: Posicao -> Bool -> [(Posicao, Char)] -> Bool
movimentoVertical (x, y) cima pecas
    | x < 1 || x > 8 = False
    | otherwise = case findRookAt (if cima then x - 1 else x + 1, y) pecas of
        Just _ -> True
        Nothing -> movimentoVertical (if cima then x - 1 else x + 1, y) cima pecas
  where
    -- Função auxiliar para encontrar a torre em uma posição específica
    findRookAt :: Posicao -> [(Posicao, Char)] -> Maybe (Posicao, Char)
    findRookAt pos pecas = find (\p -> fst p == pos && snd p == 'R') pecas
-- Função para verificar o movimento diagonal da torre
movimentoDiagonal :: Posicao -> Bool -> Bool -> [(Posicao, Char)] -> Bool
movimentoDiagonal (x, y) direita cima pecas
    | x < 1 || x > 8 || y < 1 || y > 8 = False
    | otherwise = case findRookAt (if cima then x - 1 else x + 1, if direita then y + 1 else y - 1) pecas of
        Just _ -> True
        Nothing -> movimentoDiagonal (if cima then x - 1 else x + 1, if direita then y + 1 else y - 1) direita cima pecas
  where
    -- Função auxiliar para encontrar a torre em uma posição específica
    findRookAt :: Posicao -> [(Posicao, Char)] -> Maybe (Posicao, Char)
    findRookAt pos pecas = find (\p -> fst p == pos && snd p == 'R') pecas
-- Função para verificar o movimento do cavalo
movimentoCavalo :: Posicao -> Bool -> Int -> Bool -> [(Posicao, Char)] -> Bool
movimentoCavalo (x, y) direita cima final pecas
    | x < 1 || x > 8 || y < 1 || y > 8 = False
    | otherwise = any (\p -> fst p == novaPosicao && snd p == 'R') pecas
  where
    -- Calculando a nova posição do cavalo
    novaPosicao = case cima of
        0 -> if direita then (if final then x - 1 else x + 1, y + 2)
                        else (if final then x - 1 else x + 1, y - 2)
        1 -> (x - 2, if final then y + 1 else y - 1)
        2 -> (x + 2, if final then y + 1 else y - 1)
        _ -> (x, y) -- caso padrão, não altera a posição
-- Função para testar os movimentos diagonais da torre
testarMovimentosDiagonais :: Posicao -> [(Posicao, Char)] -> (Bool, Bool, Bool, Bool)
testarMovimentosDiagonais pos pecas =
    ( movimentoDiagonal pos True True pecas,
      movimentoDiagonal pos True False pecas,
      movimentoDiagonal pos False True pecas,
      movimentoDiagonal pos False False pecas )
-- Função para testar os movimentos laterais da torre
testarMovimentosLaterais :: Posicao -> [(Posicao, Char)] -> (Bool, Bool, Bool, Bool)
testarMovimentosLaterais pos pecas =
    (movimentoDireita pos True pecas,
     movimentoDireita pos False pecas,
     movimentoVertical pos True pecas,
     movimentoVertical pos False pecas)
-- Função para verificar movimentos válidos para todas as peças
funcaoTorre :: Posicao -> [(Posicao, Char)] -> Bool
funcaoTorre pos pecas =
    any (\(f, dir) -> f pos dir pecas) movimentocheck
  where
    -- Lista de funções de movimento e direções
    movimentocheck :: [(Posicao -> Bool -> [(Posicao, Char)] -> Bool, Bool)]
    movimentocheck = [(movimentoDireita, True),
                 (movimentoDireita, False),
                 (movimentoVertical, True),
                 (movimentoVertical, False)]
-- Função para verificar movimentos válidos para o cavalo
funcaoCavalo :: Posicao -> [(Posicao, Char)] -> Bool
funcaoCavalo pos pecas =
    any (\(direcao, cima, final) -> movimentoCavalo pos direcao cima final pecas) cavaloMoves
  where
    -- Lista de movimentos possíveis do cavalo
    cavaloMoves :: [(Bool, Int, Bool)]
    cavaloMoves = [(True, 0, True), (True, 0, False),
                  (False, 0, True), (False, 0, False),
                  (False, 2, True), (False, 2, False),
                  (False, 1, True), (False, 1, False)]
-- Função para verificar movimentos válidos para o bispo
funcaoBispo :: Posicao -> [(Posicao, Char)] -> Bool
funcaoBispo pos pecas =
    any (\(direcao, sentido) -> movimentoDiagonal pos direcao sentido pecas) directions
  where
    -- Lista de direções possíveis para o bispo
    directions :: [(Bool, Bool)]
    directions = [(True, True), (True, False), (False, True), (False, False)]
-- Função para verificar movimentos válidos para a rainha
funcaoRainha :: Posicao -> [(Posicao, Char)] -> Bool
funcaoRainha pos pecas =
    let (diagonalDireita_Cima, diagonalDireita_Baixo, diagonalEsquerda_Cima, diagonalEsquerda_Baixo) = testarMovimentosDiagonais pos pecas
        (direita, esquerda, cima, baixo) = testarMovimentosLaterais pos pecas
    in  diagonalDireita_Cima || diagonalDireita_Baixo || diagonalEsquerda_Cima || diagonalEsquerda_Baixo
        || direita || esquerda || cima || baixo
-- Função para verificar movimentos válidos para o peão
funcaoPiao :: Posicao -> [(Posicao, Char)] -> Bool
funcaoPiao (x, y) pecas =
    not (x < 1 || x > 8 || y < 1 || y > 8) &&
    (hasRookAt (x + 1, y - 1) pecas || hasRookAt (x + 1, y + 1) pecas)
  where
    -- Função auxiliar para verificar se há um peão na posição especificada
    hasRookAt :: Posicao -> [(Posicao, Char)] -> Bool
    hasRookAt pos pecas = 
        case find ((== pos) . fst) pecas of
            Just (_, 'R') -> True
            _ -> False
-- Função para chamar a função correspondente a uma peça específica
chamarFuncao :: (Posicao, Char) -> [(Posicao, Char)]  -> Bool
chamarFuncao (pos, c) pecas = case c of
    't' -> funcaoTorre pos pecas
    'c' -> funcaoCavalo pos pecas
    'b' -> funcaoBispo pos pecas
    'd' -> funcaoRainha pos pecas
    'p' -> funcaoPiao pos pecas
    _   -> False
-- Função principal que lê a configuração do tabuleiro e verifica se algum movimento é válido
main :: IO ()
main = do
    putStrLn "Coloque a Funcao"
    config <- getLine
    let posicoes = localizarPecas config
        resultado = any (\p -> chamarFuncao p posicoes) posicoes
    putStrLn (if resultado 
                then "True" 
                else "False")