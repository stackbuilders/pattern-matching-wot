module Wot where

import Prelude hiding (foldr,fromMaybe,isNothing,map,not,span,unzip3)

newtype N = N  Bool
data    D = D !Bool

-- data Bool = False | True

not :: Bool -> Bool
not False = True
not True  = False

-- data Maybe a = Nothing | Just a

isNothing :: Maybe a -> Bool
isNothing Nothing = True
isNothing _       = False

-- data [] a = [] | a : [a]

map :: (a -> b) -> [a] -> [b]
map _ []     = []
map f (x:xs) = f x : map f xs

-- |
--
-- >>> span1 (< 3) [1,2,3,4,1,2,3,4]
-- ([1,2],[3,4,1,2,3,4])
-- >>> span1 (< 9) [1,2,3]
-- ([1,2,3],[])
-- >>> span1 (< 0) [1,2,3]
-- ([],[1,2,3])

span :: (a -> Bool) -> [a] -> ([a],[a])
span _ xs@[]       = (xs,xs)
span p xs@(x:xs')
  | p x            = let (ys,zs) = span p xs' in (x:ys,zs)
  | otherwise      = ([],xs)

foldr :: (a -> b -> b) -> b -> [a] -> b
foldr _ n []     = n
foldr c n (x:xs) = c x (foldr c n xs)

-- http://stackoverflow.com/a/18287894/2102854

unzip1 :: [(a,b)] -> ([a],[b])
unzip1 = foldr (\(a,b) ~(as,bs) -> (a:as,b:bs)) ([],[])

unzip2 :: [(a,b)] -> ([a],[b])
unzip2 = foldr (\(a,b)  (as,bs) -> (a:as,b:bs)) ([],[])

unzip3 :: [(a,b)] -> ([a],[b])
unzip3 []          = ([],[])
unzip3 ((a,b):abs) = (a:as,b:bs) where (as,bs) = unzip3 abs

fromMaybe :: a -> Maybe a -> a
fromMaybe d mx =
  case mx of
    Nothing -> d
    Just x  -> x

-- undefined :: a
-- undefined = undefined

-- |
--
-- >>> const1 False
-- 1
-- >>> const1 True
-- 1
-- >>> const1 undefined
-- 1
-- >>> const1 (1/0)
-- 1

const1 :: a -> Int
const1 x = 1

-- |
--
-- >>> map1 undefined []
-- []
-- >>> map1 _ undefined
-- *** Exception: Prelude.undefined

map1 :: (a -> b) -> [a] -> [b]
map1 _ []     = []
map1 f (x:xs) = f x : map1 f xs

-- |
--
-- >>> map1 undefined []
-- []
-- >>> map1 _ undefined
-- *** Exception: Prelude.undefined

map2 :: (a -> b) -> [a] -> [b]
map2 f (x:xs) = f x : map2 f xs
map2 _ []     = []

-- |
--
-- >>> null1 undefined
-- *** Exception: Prelude.undefined

null1 :: [a] -> Bool
null1 []    = True
null1 (_:_) = False

-- |
--
-- >>> null2 undefined
-- *** Exception: Prelude.undefined

null2 :: [a] -> Bool
null2 []    = True
null2 _     = False

-- |
--
-- >>> null3 undefined
-- *** Exception: Prelude.undefined

null3 :: [a] -> Bool
null3 (_:_) = False
null3 []    = True

-- |
--
-- 'take1' is strict in its first argument:
--
-- >>> take1 undefined []
-- *** Exception: Prelude.undefined
--
-- 'take1' is non-strict in its second argument:
--
-- >>> take1 0 undefined
-- []

take1 :: Int -> [a] -> [a]
take1 n _      | n <= 0 = []
take1 _ []              = []
take1 n (x:xs)          = x : take1 (n - 1) xs

-- |
--
-- >>> take2 undefined []
-- []
-- >>> take2 0 undefined
-- *** Exception: Prelude.undefined

take2 :: Int -> [a] -> [a]
take2 _ []              = []
take2 n _      | n <= 0 = []
take2 n (x:xs)          = x : take2 (n - 1) xs

-- |
--
-- >>> take1' undefined []
-- *** Exception: Prelude.undefined
-- >>> take1' 0 undefined
-- *** Exception: Prelude.undefined

take1' :: Int -> [a] -> [a]
take1' n xs     | n <= 0 = seq xs []
take1' _ []              = []
take1' n (x:xs)          = x : take1' (n - 1) xs

-- |
--
-- >>> take2' undefined []
-- *** Exception: Prelude.undefined
-- >>> take2' 0 undefined
-- *** Exception: Prelude.undefined

take2' :: Int -> [a] -> [a]
take2' n []              = seq n []
take2' n _      | n <= 0 = []
take2' n (x:xs)          = x : take2' (n - 1) xs

-- |
--
-- >>> drop1 undefined []
-- *** Exception: Prelude.undefined
-- >>> drop1 0 undefined
-- *** Exception: Prelude.undefined

drop1 :: Int -> [a] -> [a]
drop1 n xs     | n <= 0 = xs
drop1 _ []              = []
drop1 n (x:xs)          = drop1 (n - 1) xs

-- |
--
-- >>> drop2 undefined []
-- []
-- >>> drop2 0 undefined
-- *** Exception: Prelude.undefined

drop2 :: Int -> [a] -> [a]
drop2 _ []              = []
drop2 n xs     | n <= 0 = xs
drop2 n (x:xs)          = drop2 (n - 1) xs

-- |
--
-- >>> drop2' undefined []
-- *** Exception: Prelude.undefined
-- >>> drop2' 0 undefined
-- *** Exception: Prelude.undefined

drop2' :: Int -> [a] -> [a]
drop2' n []              = seq n []
drop2' n xs     | n <= 0 = xs
drop2' n (x:xs)          = drop2' (n - 1) xs
