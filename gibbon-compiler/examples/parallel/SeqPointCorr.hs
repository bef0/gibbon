module SeqPointCorr where

import KdTree

-- measure :: [(Float, Float, Float)] -> Int -> Int
-- measure pts n =
--     let radius  = intToFloat n
--         i       = rand
--         j       = (mod i n) - 1
--         probe   = vnth j pts
--         tr      = fromList pts
--     in countCorr probe radius tr


gibbon_main =
    let pts :: Vector (Float, Float, Float)
        pts = readArrayFile ()
        n   = sizeParam
        radius  = intToFloat n
        i       = rand
        j       = (mod i n) - 1
        probe   = nth pts j
        tr      = fromList_seq pts
    in iterate (countCorr_seq probe radius tr)