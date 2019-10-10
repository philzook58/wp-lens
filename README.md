# wp-lens


Lens as a computation structure for organizing concolic execution of a weakest precondition verifier. 

That's a mouthful.

Weakest precondition semantics is a way of specifying what is occurring in an imperative language. It transforms post conditions into pre conditions. What does this means?

A very simple predicate on states is given by 
type Pred s = s -> Bool

Now, this doesn't have much deductive power, but I think it demonstrates the principles simply.
We could replace Pred with perhaps an SMT solver expression, or some syntactic language for predicates, for which we'll need to implement things like substitution. Let's not today.

I often think of a state machine as a function taking s -> s. However, this is kind of restrictive. It is possible to have heterogenous transformations s -> s'. Why not? Perhaps we allocated new memory or something. We could model this by assume the memory was always there, but it seems wasteful and perhaps confusing. We need to a priori know everything we will need, which seems like it might break compositionality.

So we can model our language as s -> s'

We're basically modelling our language using primitive functional programming constructs. What we're doing is very similar to some kind of finally-tagless / boehm-bernaducci thing.

We intended to intentionally intepret some Expr or some Stmt type, so we're just cutting out the middleman for simplicity.
