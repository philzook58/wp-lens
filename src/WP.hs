module WP where


type Lens' a b = a -> (b, b -> a)
set l s a = let (_, f) = l s in f a

type Expr s a = s -> a
type Var s a = Lens' s a
type Pred s = s -> Bool
type Stmt s s' = Pred s' -> Pred s 

skip :: Stmt s s
skip = \post -> let pre = post in pre -- if

sequence :: Stmt s s' -> Stmt s' s'' -> Stmt s s''
sequence = (.)

assign :: Var s a -> Expr s a -> Stmt s s
assign v e = \post -> let pre s = post (set v s (e s)) in pre

(===) :: Var s a -> Expr s a -> Stmt s s
v === e = assign v e

ite :: Expr s Bool -> Stmt s s' -> Stmt s s' -> Stmt s s'
ite e stmt1 stmt2 = \post -> let pre s = if (e s) then (stmt1 post) s else (stmt2 post) s in pre

abort :: Stmt s s'  
abort = \post -> const False

assert :: Expr s Bool -> Stmt s s  
assert e = \post -> let pre s = (e s) && (post s) in pre

{-
-- tougher. Needs loop invariant
while :: Expr s Bool -> Stmt s s -> Stmt s s
while e stmt = \post -> let pre s = if (e s) then ((while e stmt) (stmt post)) s else  in pre
-}
