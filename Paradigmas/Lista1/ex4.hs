del_rep []     = []
del_rep [a]    = [a]
del_rep (x:xs) = x: del_rep(filter(/=x)xs)