module Imp where

type Stmt s s' = s -> s' 
type Lens' a b = a -> (b, b -> a)
set l s a = let (_, f) = l s in f a

type Expr s a = s -> a
type Var s a = Lens' s a

skip :: Stmt s s
skip = id

sequence :: Stmt s s' -> Stmt s' s'' -> Stmt s s''
sequence = flip (.)

assign :: Var s a -> Expr s a -> Stmt s s
assign v e = \s -> set v s (e s)

(===) :: Var s a -> Expr s a -> Stmt s s
v === e = assign v e

ite :: Expr s Bool -> Stmt s s' -> Stmt s s' -> Stmt s s'
ite e stmt1 stmt2 = \s -> if (e s) then stmt1 s else stmt2 s

while :: Expr s Bool -> Stmt s s -> Stmt s s
while e stmt = \s -> if (e s) then ((while e stmt) (stmt s)) else s

assert :: Expr s Bool -> Stmt s s  
assert e = \s -> if (e s) then s else undefined 

abort :: Stmt s s'  
abort = const undefined
