--mergesort---------
msort []= []
msort [a] = [a]
msort lst = merge (msort l1) (msort l2)
    where 
        dupla = split lst
        l1 = pri dupla 
        l2 = seg dupla 
--------Split------
split [] = ([],[])
split [a] = ([a],[])
split lst = spli lst [] []

spli [] l1 l2 = (l1, l2)
spli [a] l1 l2 = ((a:l1),l2)
spli (a:(b:xs)) l1 l2 = spli xs (a:l1) (b:l2)

pri(a,_) = a
seg(_,a) = a
--merge----
merge [] lst = lst
merge lst [] = lst
merge (a:xs) (b:ys)
    | a < b = a : merge xs (b:ys)
    | otherwise = b : merge (a:xs) ys