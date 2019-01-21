module HS_One where

import Prelude hiding ( Maybe(..), Either (..), succ, not)

data Maybe z = Nothing | Just z
  deriving Show

pureMaybe :: a -> Maybe a
pureMaybe x = Just x

fmapMaybe :: (a -> b) -> Maybe a -> Maybe b
fmapMaybe f mb =
  case mb of
    Nothing -> Nothing
    Just x  -> Just (f x)

data Either a b = Left a | Right b
  deriving Show

pureEither :: b -> Either a b
pureEither x = Right x

id1 :: a -> a
id1 x = x

foo1 :: a -> b -> b
foo1 x y = y

bar :: a -> b -> a
bar x y = foo1 y x

baz :: Int -> Int -> Int
baz x y = x + y

succ :: Int -> Int
succ x = x + 1

minus :: Int -> Int
minus x = x - 1

not :: Bool -> Bool
not b = if b then False else True

dot :: (b -> c) -> (a -> b) -> a -> c
dot f g x = f (g x)

ap :: (a -> b) -> a -> b
ap f x = f x

test_rec :: (a -> b) -> Int -> Int
test_rec f n = if n == 0
           then n
           else test_rec f (n-1)

gibbon_main =
       let
         -- id :: a -> a
         id2 x = x

         -- foo :: a -> b -> b
         -- foo2 x y = y

         x :: Maybe Int
         x = Nothing

         w :: Either Int Int
         w = pureEither 20

         v :: Int
         v = dot succ succ 10

         u :: Bool
         u = ap not True

         t :: Int
         t = test_rec succ v

         test = (id1 10, id1 True, id2 11, id2 False, foo1 1 2, x, w,
                 v, u, t)
       in test

main :: IO ()
main = print gibbon_main

{-

ScopedTyVars needs the forall.

goo =
      let foo :: forall a b. (a,b) -> b
          foo arg = let y :: b
                        y = snd arg
                    in y
      in 10

-}
