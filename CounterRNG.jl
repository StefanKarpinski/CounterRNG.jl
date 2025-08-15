struct CounterRNG
    seed::NTuple{2,UInt64}
end

# https://zimbry.blogspot.com/2011/09/better-bit-mixing-improving-on.html
# Mix01 and Mix13 added together

using SIMD

function sample(seed::Vec{2,UInt64}, k::UInt64)
    x = seed + k
    x ⊻= x >> Vec(31, 30)
    x *= Vec(0x7fb5d329728ea185, 0xbf58476d1ce4e5b9)
    x ⊻= x >> Vec(27, 27)
    x *= Vec(0x81dadef4bc2dd44d, 0x94d049bb133111eb)
    x ⊻= x >> Vec(33, 31)
    sum(x)
end

sample(rng::CounterRNG, k::Integer) =
    @inline sample(Vec(rng.seed), k % UInt64)
