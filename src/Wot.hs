module Wot where

map1 :: (a -> b) -> [a] -> [b]
map1 _ []     = []
map1 f (x:xs) = f x : map1 f xs

null1 :: [a] -> Bool
null1 []    = True
null1 (_:_) = False

null2 :: [a] -> Bool
null2 []    = True
null2 _     = False

take1 :: Int -> [a] -> [a]
take1 n _      | n <= 0 = []
take1 _ []              = []
take1 n (x:xs)          = x : take1 (n - 1) xs

take2 :: Int -> [a] -> [a]
take2 _ []              = []
take2 n _      | n <= 0 = []
take2 n (x:xs)          = x : take2 (n - 1) xs

take1' :: Int -> [a] -> [a]
take1' n xs     | n <= 0 = seq xs []
take1' _ []              = []
take1' n (x:xs)          = x : take1' (n - 1) xs

take2' :: Int -> [a] -> [a]
take2' n []              = seq n []
take2' n _      | n <= 0 = []
take2' n (x:xs)          = x : take2' (n - 1) xs

drop1 :: Int -> [a] -> [a]
drop1 n xs     | n <= 0 = xs
drop1 _ []              = []
drop1 n (x:xs)          = drop1 (n - 1) xs

drop2 :: Int -> [a] -> [a]
drop2 _ []              = []
drop2 n xs     | n <= 0 = xs
drop2 n (x:xs)          = drop2 (n - 1) xs

drop2' :: Int -> [a] -> [a]
drop2' n []              = seq n []
drop2' n xs     | n <= 0 = xs
drop2' n (x:xs)          = drop2' (n - 1) xs
