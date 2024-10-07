# Instructions

## Set-Up

Clone this repository to your computer and follow these instructions with Julia from within your copy of the repo.

## Install Julia

Install Julia using [juliaup](https://github.com/JuliaLang/juliaup)

```sh
curl -fsSL https://install.julialang.org | sh -- --yes
```

## Install Julia Nightly 

Install Julia Nightly with the following commands:

```sh
juliaup add nightly
julia +nightly --version
```

> Note: My version as of writing is: `Version 1.12.0-DEV.1314 (2024-10-06)` at commit `ab6df86f77b`

## Generate the Small Binary

With Julia nightly installed, execute the following command which invokes juliac:

```sh
julia +nightly juliac.jl --output-lib simple.so --compile-ccallable --trim simple.jl
```

This should generate a wee little binary called `simple.so`

# Running from Within Julia

## Start-Up

I have found that for some reason, I must invoke Julia as follows or else we get instant segfaults.
Additionally, you must run this from another Julia version -- I tested 1.10.5 and these experiments worked:

```sh
LD_LIBRARY_PATH=. LD_PRELOAD=simple.so julia
```

> Note: You must run the above within this repository or it will not work!

## Executing a Call to the Binary

Here's how to do a simple call to the binary:

```julia-repl
julia> @ccall "simple.so".add_julia(2::Cint, 2::Cint)::Cint
```

Which should return $4$!

# Running from Within R

## Start-Up

I have found that for some reason, I must invoke R as follows or else we get instant segfaults.
Additionally, I tested this on R 4.3.1 and these experiments worked:

```sh
LD_LIBRARY_PATH=. LD_PRELOAD=simple.so R
```

> Note: You must run the above within this repository or it will not work!

## Executing a Call to the Binary

First we load the binary:

```R
dyn.load("simple.so")
```

Then we call the binary function via R's C interface:

```R
res <- .C('add_r', a = as.integer(2), b = as.integer(2), output = c(as.integer(0)))
res$output
```

Which should return $4$!

# Other Thoughts

I am very eager to see how juliac could start becoming the computational backend for a lot of other languages that may depend on C/C++/Fortran sorts of backends in their software packages.
I think there is a very bright future here!

# Challenge Mode

For a hard challenge, see the kernel smoothing script in `ksmooth.jl` that we have been trying to get working to create a kernel smoothing binary. 
We know the Julia implementation is correct for kernel smoothing but the typing isn't quite perfect yet for calling into this binary from Julia yet as it continues to fail (see the `call_ksmooth.jl` for our current invocation).
If you get it working, could you let me know?

# Comments


- Please see a greater discussion here: https://discourse.julialang.org/t/pushing-the-limits-of-small-binary-creation/120989 for more details on juliac

- Special thanks to @terasakisatoshi for their thoughts on juliac as well as their nice test repo and guide as well found here: https://github.com/terasakisatoshi/libcalcpi_juliac (I adapted their tutorial to mine here)

- Thanks to [@jbytecode](https://github.com/jbytecode) for their VERY inspirational juliac blog post here: https://jbytecode.github.io/juliac/

- Thanks to: 

  * [@rkillick](https://github.com/rkillick)

  * [@asinghvi17](https://github.com/asinghvi17)

  * [@aviks](https://github.com/aviks)

  * [@mortenpi](https://github.com/mortenpi)

  * For hacking with me on this for about 5+ hours on this the other night! Was super fun and inspiring! 
