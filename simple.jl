module JuliaTest

    Base.@ccallable function add_r(a::Ptr{Csize_t}, b::Ptr{Csize_t}, out::Ptr{Csize_t})::Csize_t
        a = unsafe_load(a)
        b = unsafe_load(b)
        out = unsafe_wrap(Array, out::Ptr{Csize_t}, 1::Int)
        out[1] = a + b
    end

    Base.@ccallable function add_julia(x::Cint, y::Cint)::Cint
        return x + y
    end
end
