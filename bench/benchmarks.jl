using BenchmarkTools
using Descartes

println("Descartes Benchmarks")

c = Cuboid(3,3,3)


println("Signed Distance Field")
t = @benchmark SignedDistanceField(c)
println(IOContext(stdout, :verbose => true, :compact => false), t)
