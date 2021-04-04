abstract type AbstractDevice end

struct CPU <: AbstractDevice
end

struct GPU <: AbstractDevice
    id::Int
end

GPU() = GPU(1)

is_cuarray(x) = x isa CuArray


# currently GPU's ID is just a placeholder
guess_device(args) = any(is_cuarray, args) ? GPU(1) : CPU()
device_of(A) = A isa CuArray ? GPU(1) : CPU()


"""
Retrieve function compatible with specified device

See also: to_device(device, f)
"""
device_function(device::CPU, f) = f


"""
Convert object to a compatible with the specified device.

For CPU it's usually no-op. For GPU behavior differs between object types:

 * Arrays are converted to CuArrays
 * structs are converted recursively
 * functions are looked up using `device_function()` or transformed using tracer
 * all other objects are returned as is
"""
to_device(device::CPU, x) = x
to_device(device::CPU, f::Function, args) = f
# see also cuda.jl


(device::CPU)(x) = to_device(device, x)
(device::GPU)(x) = to_device(device, x)

to_cpu(A) = A
to_cpu(A::CuArray) = convert(Array, A)
to_cuda(A) = cu(A)
to_cuda(A::CuArray) = A

to_same_device(A, example) = device_of(example)(A)
