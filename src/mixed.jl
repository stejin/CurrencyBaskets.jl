## Promotions and conversions

# Promote to Basket
function Base.promote_rule(
        ::Type{Basket},
        ::Type{B}) where B<:AbstractMonetary
    Basket
end

# Convert to basket
# FIXED: Causes stack overflow because Basket derives from AbstractMonetary
#        Attempts to create Basket from Basket instead of constituents
# Base.convert(::Type{Basket}, m::AbstractMonetary) = Basket((m,))
Base.convert(::Type{Basket}, m::Monetary) = Basket((m,))

# Convert to Monetary
function Base.convert(::Type{T}, b::Basket) where T<:Monetary
    len = length(b)
    if len == 0
        zero(T)
    elseif len == 1
        convert(T, first(b))
    else
        throw(InexactError(:convert, T, b))
    end
end

## Functions that promote
b::AbstractMonetary == c::AbstractMonetary = iszero(-(promote(b, c)...))

b::Basket            + c::AbstractMonetary = +(promote(b, c)...)
b::AbstractMonetary  + c::Basket           = c + b
b::AbstractMonetary  - c::AbstractMonetary = b + (-c)
