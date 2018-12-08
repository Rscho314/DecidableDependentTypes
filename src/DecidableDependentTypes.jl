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

#Types (just synonyms for now)
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

#Not sure if functions or for-syntax functions
#Fig. 4
function add_τ(stx::stx_ob, τ::Ty)
    return add_stx_prop(stx, τ) #$ or not $?
end

function get_τ(stx::stx_ob)
    return stx.τ  # equivalent of (get-syntax-prop e τ) fig. 4
end

function compute_τ(stx::stx_ob)
    return get_τ(local_expand(stx))  # stx_ob or stx_ob.e?
end

function erase_τ(stx::stx_ob)
    return local_expand(stx)
end

function comp_and_erase_τ(stx::stx_ob)
    return local_expand(stx), get_τ(stx)
end

function τ_eq(τ1::Ty, τ2::Ty)
    return stx_eq(τ1, τ2)
end

function τ_imply(_, _)
    return error("no runtime types")
end

function comp_and_erase_τ_ctx(stx, (x, τ))
    return "TODO"
end

#MACROS for sure
macro τ_impl(τ_in, τ_out)
    return τ_imply(τ_in, τ_out)
end

"""
macro checked_λ((x, τ_in::Ty), stx::stx_ob)
    x_bar, e_bar, τ_out = comp_and_erase_τ_ctx(e, (x, τ_in))
    return add_τ((λ_bar(x_bar), e_bar),
                    @τ_impl(τ_in, τ_out))
end
"""
macro checked_appv0(args...)
    return args[1]
end

macro checked_appv1(args...)
    return args[1]
end

end # module
