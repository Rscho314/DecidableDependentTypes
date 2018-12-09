module DecidableDependentTypes

"""
TODO
----

Simply-typed λ calculus
-----------------------

τ ::= τ → τ
e ::= x | λx:τ.e | e e
Γ ::= x:τ, ... (types, terms)

         x:τ ϵ Γ
(T-VAR) ---------
        Γ ⊢ x : τ

          Γ, x:τ₁ ⊢ e : τ₂
(T-ABS) ---------------------
        Γ ⊢ λx:τ₁.e : τ₁ → τ₂

        Γ ⊢ e₁ : τ₁ → τ₂    Γ ⊢ e₂ : τ₁
(T-APP) -------------------------------
                 Γ ⊢ e₁e₂ : τ₂

(erase) er(x)=x, er(λx:τ.e)=λx.er(e), er(e e')=er(e)er(e')
"""

export stx_ob

#Types (just type synonyms for now)
const Ex = Expr
const Ty = Symbol

"""Ugly hack for struct comparison.
Tests syntactic (and therefore type) equality.
TODO: find better solution
Structs are ≂ if their fields are =="""
@generated function ≂(x, y)
    if !isempty(fieldnames(x)) && x == y
        mapreduce(n -> :(x.$n == y.$n), (a,b)->:($a && $b), fieldnames(x))
    else
        :(x == y)
    end
end

# The syntax object
struct stx_ob
    e::Ex
    τ::Ty
end

#BOOL lang
# (bool->lit arg:boolean)
macro bool_to_lit(a)
    eval(a) ? (x -> x) : (x -> !x)
end
#DecidableDependentTypes.@bool_to_lit(:false)
#DecidableDependentTypes.@bool_to_lit(false)

#(λ (x y) (and #t ((bool->lit #f) x) ((bool->lit #f) y)))
macro make_clause(xs, bools, res)
    lits = map((x -> @eval @bool_to_lit $x), bools.args)
    clause_elements = map.(lits, xs.args)
    and_res = all(push!(clause_elements, res))
    return and_res
end
#DecidableDependentTypes.@make_clause((false, false), (false, false), true)
#DecidableDependentTypes.@make_clause((true, false), (true, false), false)
#DecidableDependentTypes.@make_clause((false, true), (false, true), true)
#DecidableDependentTypes.@make_clause((true, true), (true, true), true)

"""
xs : Tuple{Vararg{Bool}}
tbl : Tuple{Tuple{Vararg{Bool}}, Tuple{Vararg{Bool}}}
TODO: learn how to specify those types in the macro args.
"""
macro truth_table(xs, vars, r)
    clauses = []
    for i=1:length(vars.args)
        push!(clauses, @eval @make_clause($xs, $(vars.args[i]), $(r.args[i])))
    end
    return any(clauses)
end
#DecidableDependentTypes.@truth_table((false, true),((true, false), (false, true), (false, false)), (false, true, false))

function subset(x, y)
    @eval @truth_table(
        ($x, $y),
        ((false, false),
         (true, false),
         (false, true),
         (true, true)),
        (true, false, true, true))
end
#DecidableDependentTypes.subset(true, false)
#DecidableDependentTypes.subset(true, true)
#DecidableDependentTypes.subset(false, false)
#DecidableDependentTypes.subset(false, true)

end # module
