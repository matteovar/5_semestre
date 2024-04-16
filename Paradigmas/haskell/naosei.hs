-------rld------------
rep c 0  = []
rep c n = c : rep c (n-1)



-- rle "aaaaaaaaaaaaaaaaaaa"
-- > [('a',20),('b',9),('a',8)]

rle [] = []
rle (c:xs) = rle_aux xs c 1

rle_aux [] c n =[(c,n)]
rle_aux (a:xs) c n | a==c = rle_aux xs c (n+1)
                   | otherwise = (c,n) : rle_aux xs a 1
