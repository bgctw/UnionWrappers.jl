using StaticArrays
m = zeros(3, 3, 3);
D = size(m)
E = eltype(m)
S = Tuple{D...}
L = prod(D)
N = length(D)
s = SArray{S,E,N,L}(m)

s = SArray{S}(m)
typeof(s)
