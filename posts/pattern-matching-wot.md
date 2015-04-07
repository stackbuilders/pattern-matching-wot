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

```haskell
span :: (a -> Bool) -> [a] -> ([a],[a]) -- Defined in GHC.List
span _ xs@[]       = (xs,xs)
span p xs@(x:xs')
  | p x            = let (ys,zs) = span p xs' in (x:ys,zs)
  | otherwise      = ([],xs)
```

span has a wildcard, as-patterns, regular pattern matching on lists.

span, applied to a predicate p and a list xs, returns a tuple where
first element is longest prefix (possibly empty) of xs of elements
that satisfy p and second element is the remainder of the list.

```haskell
unzip :: [(a,b)] -> ([a],[b]) -- Defined in GHC.List
unzip = foldr (\(a,b) ~(as,bs) -> (a:as,b:bs)) ([],[])
```

unzip has lambdas and lazy patterns.

unzip transforms a list of pairs into a list of first components and a
list of second components.

```haskell
fromMaybe :: a -> Maybe a -> a -- Defined in Data.Maybe
fromMaybe d mx =
  case mx of
    Nothing -> d
    Just x  -> x
```

fromMaybe has pattern matching in case expressions, which is what all
pattern matching is anyway.

the fromMaybe function takes a default value and a Maybe value. If the
Maybe is Nothing, it returns the default value; otherwise, it returns
the value contained in the Maybe.


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

The eight rules can be summarized in that some patterns are
irrefutable and the rest are refutable.

Take, for instance,

```
> (\ ~(x,y) -> 0) undefined
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
with the drop function: Let's consider this definition of drop:

"The pattern-matching rules can have subtle effects on the meaning of
functions." We see that take is more defined with respect to its
second argument, whereas take1 is more defined with respect to its
first. It is difficult to say in this case which definition is better.
Just remember that in certain applications, it may make a difference.

```haskell
drop1 :: Int -> [a] -> [a]
drop1 n xs     | n <= 0 = xs
drop1 _ []              = []
drop1 n (x:xs)          = drop1 (n - 1) xs
```

and this slightly different version (the first two equations have been
reversed):

```haskell
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

