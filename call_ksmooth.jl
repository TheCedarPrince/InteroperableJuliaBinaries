#=

Note, if you try taking this on, you must generate a small binary off
the ksmooth.jl script and then pass the small binary into the
`LD_PRELOAD` variable when loading Julia like mentioned in the main
instructions.

=# 

ex_wiki = [-2.1,-1.3,-0.4,1.9,5.1,6.2] # This is x and xpts in ksmooth
h_wiki = 2.557346 # This is h in ksmooth
nx = length(ex_wiki)
nxpts = length(ex_wiki)
scale_factor = 1/(nx*h_wiki*sqrt(2*pi))
out = zeros(length(ex_wiki))

# This fails but SHOULD work and give an array of 6 values back
@ccall "julia_ksmooth.so".r_ksmooth(ex_wiki::Ptr{Cdouble}, Ref(length(ex_wiki) |> Csize_t)::Ptr{Csize_t}, ex_wiki::Ptr{Cdouble}, Ref(length(nxpts) |> Csize_t)::Ptr{Csize_t}, Ref(h_wiki)::Ptr{Cdouble}, out::Ptr{Cdouble})::Cint
