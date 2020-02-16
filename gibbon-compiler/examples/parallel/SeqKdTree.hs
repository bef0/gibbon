-- -- | It's a 3D tree right now
-- module KdTree where

module Sort where

coord :: Int -> Int -> Int -> Int
coord axis x y =
  if axis == 0
  then x
  else y

getNextAxis_2D :: Int -> Int
getNextAxis_2D i = mod (i + 1) 2

-- It's a for loop.
lesser :: Int -> Int -> Int -> Int -> [(Int, Int)] -> [(Int, Int)] -> [(Int, Int)]
lesser i n axis elt ls acc =
  if i == n
  then acc
  else  let x   = vnth i ls
            rst = lesser (i+1) n axis elt ls acc
            tst = coord axis (x !!! 0) (x !!! 1)
        in if tst < elt
           then vsnoc rst x
           else rst

-- It's a for loop.
greater_eq :: Int -> Int -> Int -> Int -> [(Int, Int)] -> [(Int, Int)] -> [(Int, Int)]
greater_eq i n axis elt ls acc =
  if i == n
  then acc
  else  let x   = vnth i ls
            rst = greater_eq (i+1) n axis elt ls acc
            tst = coord axis (x !!! 0) (x !!! 1)
        in if tst >= elt
           then vsnoc rst x
           else rst

append :: Int -> [(Int, Int)] -> [(Int, Int)] -> [(Int, Int)]
append n ls1 ls2 =
  if n == vlength ls2
  then ls1
  else append (n+1) (vsnoc ls1 (vnth n ls2)) ls2

sort0 :: Int -> [(Int, Int)] -> [(Int, Int)] -> [(Int, Int)]
sort0 axis ls acc =
  let n = vlength ls in
  if n == 0
  then acc
  else if n == 1
  then vsnoc acc (vnth 0 ls)
  else let pivot = vnth (n-1) ls
           elt   = coord axis (pivot !!! 0) (pivot !!! 1)

           acc1 :: [(Int,Int)]
           acc1 = vempty
           ls1  = lesser 0 ((vlength ls) - 1) axis elt ls acc1

           acc2 :: [(Int,Int)]
           acc2 = vempty
           ls2  = sort0 axis ls1 acc2

           acc3 :: [(Int,Int)]
           acc3 = vempty
           ls3  = greater_eq 0 ((vlength ls) - 1) axis elt ls acc3

           acc4 :: [(Int,Int)]
           acc4 = vempty
           ls4  = sort0 axis ls3 acc4

           ls5  = vsnoc ls2 pivot
           ls6  = append 0 ls5 ls4

       in ls6

sort :: Int -> [(Int, Int)] -> [(Int, Int)]
sort axis ls =
    let acc :: [(Int, Int)]
        acc = vempty
    in sort0 axis ls acc

slice0 :: Int -> Int -> [(Int, Int)] -> [(Int, Int)] -> [(Int, Int)]
slice0 i n ls acc =
  if i == n
  then acc
  else  let x = vnth i ls
        in slice0 (i+1) n ls (vsnoc acc x)

slice :: Int -> Int -> [(Int, Int)] -> [(Int, Int)]
slice i n ls =
  let  acc :: [(Int, Int)]
       acc = vempty
  in slice0 i n ls acc

--------------------------------------------------------------------------------
-- The main algorithm

data KdTree  = KdNode Int     -- ^ axis
                      Int     -- ^ x-coord
                      Int     -- ^ y-coord
                      KdTree  -- ^ left
                      KdTree  -- ^ right
             | KdEmpty
  deriving Show

fromList :: [(Int, Int)] -> KdTree
fromList pts = fromListWithAxis 0 pts

fromListWithAxis :: Int -> [(Int, Int)] -> KdTree
fromListWithAxis axis pts =
    if vlength pts == 0
    then KdEmpty
    else
      let sorted_pts = sort axis pts
          len        = vlength pts
          pivot_idx  = div len 2
          pivot      = vnth pivot_idx sorted_pts
          left_pts   = slice 0 pivot_idx sorted_pts
          right_pts  = slice (pivot_idx+1) len sorted_pts
          next_axis  = getNextAxis_2D axis
          left_tr    = fromListWithAxis next_axis left_pts
          right_tr   = fromListWithAxis next_axis right_pts
      in KdNode axis (pivot !!! 0) (pivot !!! 1) left_tr right_tr

sumKdTree :: KdTree -> Int
sumKdTree tr =
  case tr of
    KdEmpty -> 0
    KdNode _ x y left right ->
      let m = coord 0 x y
          n = coord 1 x y
          o = sumKdTree left
          p = sumKdTree right
      in m + n + o + p

--------------------------------------------------------------------------------

mkList0 :: Int -> [(Int, Int)] -> [(Int, Int)]
mkList0 n acc=
  if n == 0
  then acc
  else let i = mod rand 50
           j = mod rand 50
       in mkList0 (n-1) (vsnoc acc (i,j))

mkList :: Int -> [(Int, Int)]
mkList n =
  let acc :: [(Int, Int)]
      acc = vempty
  in mkList0 n acc

sumList0 :: Int -> Int -> [(Int, Int)] -> Int -> Int
sumList0 i n ls acc =
  if i == n
  then acc
  else let p = vnth i ls
       in sumList0 (i+1) n ls (acc + (p !!! 0) + (p !!! 1))

sumList :: [(Int, Int)] -> Int
sumList ls =
  sumList0 0 (vlength ls) ls 0

gibbon_main =
    let n   = sizeParam
        ls  = mkList n
        -- ls2 = iterate (sort 0 ls)
    -- in sumList ls
        tr = iterate (fromList ls)
    in (sumKdTree tr, sumList ls)