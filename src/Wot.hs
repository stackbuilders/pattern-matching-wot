module Wot where

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
