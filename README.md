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

# Comments

- Please see a greater discussion here: 
