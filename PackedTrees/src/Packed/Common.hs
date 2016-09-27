-- | 

module Packed.Common where

import Data.Map
    
type Var    = String
type Constr = String

data Value a = VInt Int | VLam (Env a) Var a
             | VProd (Value a) (Value a)
             | VLeft (Value a)
             | VRight (Value a)
             | VPacked Constr [Value a]
  deriving (Read,Show,Eq,Ord)
               
type Env a = Map Var (Value a)

data DDef a = DDef Var [(Constr,[a])]
  deriving (Read,Show,Eq,Ord)
