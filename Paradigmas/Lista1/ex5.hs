import System.Win32 (xBUTTON1)
totk _ []= []
totk k xs = sum (take k xs) : totk k (drop k xs) 
    