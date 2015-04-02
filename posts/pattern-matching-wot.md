# Pattern Matching: Wot's... Uh the Deal?

> The patch will not be noticeable if the pattern is skilfully matched.

--- Idabelle McGlauflin, Handicraft for Girls

Even though pattern matching is done all the time when programming in
Haskell, I think there is a lack of explanation of pattern matching in
books and tutorials. Something beyond from left to right, from top to
bottom is usually not included in anything other than the Haskell
report or the gentle introduction.

- What are all the types of patterns for pattern matching?
- What are the possible results of pattern matching?

- Also, what are the rules of pattern matchings? The semantics.

One more thing that is very interesting is that thinking of the
results of pattern matching against undefined or bottom (so, in a way,
thinking on whether a function is strict or nonstrict) is a very
useful way to think of pattern matching. Thinking in terms of
undefined really helps in really understanding how pattern matching
works.

As a summary of the different kinds of pattern matching, let's
consider three functions, all from the standard libraries:

```
span :: (a -> Bool) -> [a] -> ([a],[a]) -- Defined in GHC.List
span _ xs@[]       = (xs,xs)
span p xs@(x:xs')
  | p x            = let (ys,zs) = span p xs' in (x:ys,zs)
  | otherwise      = ([],xs)
```

span has a wildcard, as-patterns, regular pattern matching on lists.

```
unzip :: [(a,b)] -> ([a],[b]) -- Defined in GHC.List
unzip = foldr (\(a,b) ~(as,bs) -> (a:as,b:bs)) ([],[])
```

unzip has lambdas and lazy patterns.

```
fromMaybe :: a -> Maybe a -> a -- Defined in Data.Maybe
fromMaybe d mx =
  case mx of
    Nothing -> d
    Just x  -> x
```

fromMaybe has pattern matching in case expressions, which is what all
pattern matching is anyway.

Now, the basics of pattern matching are very simple. We pattern match
against values and proceed from left to right, from top to bottom, and
pattern matching may fail, succeed, or diverge (that is, undefined).

Additionally, pattern matching (at least informally) has eight rules
which are kind of summarized in saying that a pattern is either
refutable or irrefutable.

Basically, matching a variable var, a lazy pattern ~apat or a wildcard
against a value v always succeeds, irrefutable. Matching irrefutable
patterns is nonstrict, so the match succeeds even against undefined.
The interesting case is the lazy pattern, which binds the free
variables in apat to v if pattern matching would otherwise succeed, or
to undefined otherwise.

Difference between newtype and data.

Matching a numeric, character, or string literal succeeds if v == k.

And matching an as pattern var@apat against v, if apat against v.

So, patterns can be irrefutable or refutable. Matching an irrefutable
pattern is nonstrict, matching a refutable one is strict.

Take, for instance,

```
> (\ ~(x,y) -> 0) ⊥
0
```

Since there's a lazy pattern, pattern matching ~(x,y) against
undefined suceeds. Since pattern matching (x,y) against undefined
would diverge, then x and y are bound to undefined, but not evaluated.
We're not using neither x or y, so pattern matching never happens, and
the result is 0.

```
> (\  (x,y) -> 0) undefined
undefined
```

On the other hand, attempting to pattern match (x,y) against undefined
diverges and hence the whole computation diverges, so the result is
undefined.

A very interesting example is

```
> (\  (x:xs) -> x:x:xs) undefined
undefined
```

```
> (\ ~(x:xs) -> x:x:xs) undefined
undefined:undefined:undefined
```

Also, in the gentle introduction the authors discuss two slightly
different versions of the take function to show how subtle changes
with pattern matching yield different functions. Let's do the same
with the drop function:

```
drop1 :: Int -> [a] -> [a]
drop1 n xs     | n <= 0 = xs
drop1 _ []              = []
drop1 n (x:xs)          = drop1 (n - 1) xs
```

```
drop2 :: Int -> [a] -> [a]
drop2 _ []              = []
drop2 n xs     | n <= 0 = xs
drop2 n (x:xs)          = drop2 (n - 1) xs
```

```
> drop1 undefined []
undefined
> drop2 undefined []
[]
```

```
> drop1 0 undefined
undefined
> drop2 0 undefined
undefined
```

