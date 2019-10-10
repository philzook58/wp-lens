{-# LANGUAGE NoImplicitPrelude, GeneralizedNewtypeDeriving #-}
module Lib
    ( someFunc
    ) where
import Control.Category
import Prelude hiding (id, (.))
someFunc :: IO ()
someFunc = putStrLn "someFunc"

{-
class Imp k where
    skip :: k s s
    seq  :: k s s' -> k  
    abort :: k s s'
    ite   ::
-}

type Lens' a b = a -> (b, b -> a)
set l s a = let (_, f) = l s in f a


newtype Stmt s s' = Stmt (s -> s') deriving Category
type Expr s a = s -> a
type Var s a = Lens' s a
skip :: Category k => k s s   
skip = id

-- assign :: Var s a -> Expr s a -> Stmt s s
-- assign v e = Stmt $ \s -> set v s (e s)






type Pred a = a -> Bool
newtype WPLens s s' = WPLens (s -> (s', Pred s' -> Pred s))
instance Category WPLens where
    id = WPLens $ \x -> (x, id)
    (WPLens f) . (WPLens g) =  WPLens $ \s -> let (s', j) = g s in
                                              let (s'', j') = f s' in
                                              (s'', j . j')

simp_prog :: Category k => k s s                                             
simp_prog = skip .
            skip .
            skip

sequence :: WPLens s s' -> WPLens s' s'' -> WPLens s s''
sequence = flip (.)
assign :: Var s a -> Expr s a -> WPLens s s
assign v e = WPLens $ \s -> (set v s (e s), \p -> \s -> p (set v s (e s)))

--if then else
ite :: Expr s Bool -> WPLens s s' -> WPLens s s' -> WPLens s s'
ite e (WPLens stmt1) (WPLens stmt2) = WPLens $ \s -> 
                                   if (e s) 
                                   then let (s', wp) = stmt1 s in
                                        (s', \post -> \s -> (e s) && (wp post s))
                                   else let (s', wp) = stmt2 s in
                                            (s', \post -> \s -> (not (e s)) && (wp post s))

assert :: Pred s -> WPLens s s
assert p = WPLens $ \s -> (s, \post -> let pre s = (post s) && (p s) in pre)
{-
while :: Expr s Bool -> WPLens s s -> WPLens s s
while e stmt = \s -> if e s then let (s' , wp) = (while e stmt) s in
                                 (s', \post -> let pre s'' = (post s'') && (wp post s'') in pre)
                                 )
                            else (s, \p -> p))

             -}               