trok2 [] = []
trok2 [x] = [x]
trok2(x:y:xs) = y : x : trok2 xs