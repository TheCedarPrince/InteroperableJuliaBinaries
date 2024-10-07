module JuliaTest

    function ksmooth!(out::Vector{Float64}, x::Vector{Float64}, xpts::Vector{Float64}, h::Float64)
        for i in eachindex(xpts)
            count = 0
            for j in eachindex(x)
              temp = (xpts[i] - x[j]) / h
              count += exp(-temp^2 / 2)
            end
            out[i] = count
        end
        scale_factor = 1/(length(x)*h*sqrt(2*pi))

        out .*= scale_factor
    end

    function _wrap_array(arr::Ptr{NumType}, n::Ptr{Cint}) where NumType
        return unsafe_wrap(Vector, arr, (unsafe_load(n),))
    end

    Base.@ccallable function r_ksmooth(
      x::Ptr{Cdouble},
      nx::Ptr{Csize_t},
      xpts::Ptr{Cdouble},
      nxpts::Ptr{Csize_t},
      h::Ptr{Cdouble},
      out::Ptr{Cdouble},
      )::Cint
      
      # load things from C pointers
      w_x = _wrap_array(x, nx)
      w_xpt = _wrap_array(xpts, nxpts)
      w_h = unsafe_load(h)
      w_out = _wrap_array(out, nxpts)
      # apply ksmooth to Julia vectors
      ksmooth!(w_out, w_x, w_xpts, w_h)
      # print result
      show(Core.stdout, result)
      # return 0 if success, >=1 if error, maybe use code to describe error
      return 0
    end

end 
