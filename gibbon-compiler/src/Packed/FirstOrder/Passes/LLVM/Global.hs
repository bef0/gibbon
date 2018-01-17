-- | Export C functions

module Packed.FirstOrder.Passes.LLVM.Global where

import qualified LLVM.AST as AST
import qualified LLVM.AST.Global as G
import qualified LLVM.AST.Type as T
import qualified LLVM.AST.AddrSpace as AS
import qualified LLVM.AST.Constant as C

-- | Must be consistent with function defined in lib.c
--
fputs :: G.Global
fputs = G.functionDefaults
        { G.name        = AST.Name "__fputs"
        , G.parameters  = ([G.Parameter ty arg []], False)
        , G.returnType  = T.i64
        }
  where ty  = T.PointerType T.i8 (AS.AddrSpace 0)
        arg = AST.UnName 0

-- | Must be consistent with function defined in lib.c
--
mainFn :: [AST.BasicBlock] -> G.Global
mainFn instrs = G.functionDefaults
       { G.name        = AST.Name "__main_expr"
       , G.parameters  = ([], False)
       , G.returnType  = T.VoidType
       , G.basicBlocks = instrs
       }

-- | Must be consistent with function defined in lib.c
--
printInt :: G.Global
printInt = G.functionDefaults
           { G.name        = AST.Name "__print_int"
           , G.parameters  = ([G.Parameter ty arg []], False)
           , G.returnType  = T.i64
           }
  where ty  = T.i64
        arg = AST.UnName 0

malloc :: G.Global
malloc = G.functionDefaults
         { G.name        = AST.Name "malloc"
         , G.parameters  = ([G.Parameter ty arg []], False)
         , G.returnType  = T.PointerType T.i8 (AS.AddrSpace 0)
         }
  where ty  = T.i64
        arg = AST.UnName 0


globalSizeParam :: G.Global
globalSizeParam = G.globalVariableDefaults
                  { G.name  = AST.Name "global_size_param"
                  , G.type' = T.i64
                  , G.initializer = Just $ C.Int 64 1
                  }

globalItersParam :: G.Global
globalItersParam = G.globalVariableDefaults
                   { G.name  = AST.Name "global_iters_param"
                   , G.type' = T.i64
                   , G.initializer = Just $ C.Int 64 1
                   }

-- | int clock_gettime(clockid_t clk_id, struct timespec *tp);
--
clockGetTime :: G.Global
clockGetTime = G.functionDefaults
               { G.name = AST.Name "clock_gettime"
               , G.parameters = ([ G.Parameter T.i32 arg0 []
                                 , G.Parameter (toPtrTy timespecT) arg1 []]
                                , False)
               , G.returnType = T.i64
               }
  where timespecT = T.NamedTypeReference (AST.Name "struct.timespec")
        arg0      = AST.UnName 0
        arg1      = AST.UnName 1

-- | Must be consistent with function defined in time.h
--
timespecStruct :: AST.Definition
timespecStruct = AST.TypeDefinition (AST.Name "struct.timespec")
                                    (Just $ T.StructureType False [T.i64, T.i64])

-- | Must be consistent with function defined in lib.c
--
difftimespecs :: G.Global
difftimespecs = G.functionDefaults
                { G.name = AST.Name "difftimespecs"
                , G.parameters = ([G.Parameter (toPtrTy timespecT) arg0 []
                                  , G.Parameter (toPtrTy timespecT) arg1 []]
                                 , False)
                , G.returnType = T.double
                }
  where timespecT = T.NamedTypeReference (AST.Name "struct.timespec")
        arg0      = AST.UnName 0
        arg1      = AST.UnName 1

-- | Must be consistent with function defined in lib.c
--
printDiffTime :: G.Global
printDiffTime = G.functionDefaults
                { G.name        = AST.Name "__print_difftime"
                , G.parameters  = ([G.Parameter ty arg []], False)
                , G.returnType  = T.i64
                }
  where ty  = T.double
        arg = AST.UnName 0

-- | Must be consistent with function defined in lib.c
--
printIterDiffTime :: G.Global
printIterDiffTime = G.functionDefaults
                { G.name        = AST.Name "__print_iter_difftime"
                , G.parameters  = ([G.Parameter ty arg []], False)
                , G.returnType  = T.i64
                }
  where ty  = T.double
        arg = AST.UnName 0

saveAllocState :: G.Global
saveAllocState = G.functionDefaults
                 { G.name        = AST.Name "save_alloc_state"
                 , G.parameters  = ([], False)
                 , G.returnType  = T.VoidType
                 }

restoreAllocState :: G.Global
restoreAllocState = G.functionDefaults
                    { G.name        = AST.Name "restore_alloc_state"
                    , G.parameters  = ([], False)
                    , G.returnType  = T.VoidType
                    }

-- TODO(cskksc): refer the structs defined in lib.c instead of redefining them
dictItemUnion :: AST.Definition
dictItemUnion = AST.TypeDefinition (AST.Name "union.dict_item")
                (Just $ T.StructureType False [(toPtrTy T.i64)])

dictItemStruct :: AST.Definition
dictItemStruct = AST.TypeDefinition (AST.Name "struct.dict_item")
                 (Just $ T.StructureType False [toPtrTy $ T.NamedTypeReference (AST.Name "struct.dict_item"),
                                               T.i64,
                                               T.NamedTypeReference $ AST.Name "union.dict_item"])

dictInsertInt :: G.Global
dictInsertInt = G.functionDefaults
                { G.name        = AST.Name "dict_insert_int"
                , G.parameters  = ( [ G.Parameter dictItemTy arg0 []
                                    , G.Parameter T.i64 arg1 [] -- SymTy
                                    , G.Parameter T.i64 arg2 [] -- IntTy
                                    ]
                                  , False)
                , G.returnType  = dictItemTy
                }
  where
    arg0 = AST.UnName 0
    arg1 = AST.UnName 1
    arg2 = AST.UnName 2
    dictItemTy = toPtrTy $ T.NamedTypeReference $ AST.Name "struct.dict_item"

dictLookupInt :: G.Global
dictLookupInt = G.functionDefaults
                { G.name        = AST.Name "dict_lookup_int"
                , G.parameters  = ( [ G.Parameter dictItemTy arg0 []
                                    , G.Parameter T.i64 arg1 [] -- SymTy
                                    ]
                                  , False)
                , G.returnType  = T.i64 -- IntTy
                }
  where
    arg0 = AST.UnName 0
    arg1 = AST.UnName 1
    dictItemTy = toPtrTy $ T.NamedTypeReference $ AST.Name "struct.dict_item"

exit :: G.Global
exit = G.functionDefaults
       { G.name        = AST.Name "exit"
       , G.parameters  = ( [ G.Parameter ty arg [] ], False )
       , G.returnType  = T.VoidType
       }
  where ty  = T.i64
        arg = AST.UnName 0

-- | Convert the type to a pointer type
--
toPtrTy :: T.Type -> T.Type
toPtrTy ty = T.PointerType ty (AS.AddrSpace 0)
