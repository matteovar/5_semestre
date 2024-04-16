delk2  _  []                 = []
delk2 k xs                 = aux k xs
    where
        aux _ [] = []
        aux 1 (_:xs) = aux k xs
        aux n (x:xs) = x : aux (n-1) xs