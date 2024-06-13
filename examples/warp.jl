# https://www.desmos.com/calculator/mcjscmo6fq

using WGLMakie
#Plots.plotly()
# Parameters (TODO: make const or propogate through functions for better performance)
p = 1
t = 0.5
w0 = 8

w = 2π / (p * w0)

x_vals = range(-10, 10, length=1200)
y_vals = range(-10, 10, length=1200)

"""
TriangleWave function
"""
function f_x(x)
    abs(mod(-2 * p * x, p))
end

"""
Grid function
"""
function f(v)
    minimum(f_x.(v))
end

z = [f((x, y)) - t/2 < 0 for x in x_vals, y in y_vals]
heatmap(x_vals, y_vals, z, alpha=0.6)

function h(v)
    mr = hypot(v...)
    mt = atan(v[2], v[1])*w
    min(f_x(mr), f_x(mt))
end

z = [h((x, y)) - t/2 <= 0 for x in x_vals, y in y_vals]
heatmap(x_vals, y_vals, z, alpha=0.6)

function j(v)
    w / hypot(v...)
end

z = [h((x, y))/j((x,y)) - t/2 <= 0 for x in x_vals, y in y_vals]
heatmap(x_vals, y_vals, z, alpha=0.6, title="Grid Function", xlabel="x", ylabel="y", legend=false, aspect_ratio=:equal)

using ForwardDiff

function h_g(v)
    g = ForwardDiff.gradient(h, [v...]) # TODO: make this faster
    hypot(g...)
end

z = [h((x, y))/h_g((x,y)) - t/2 <= 0 for x in x_vals, y in y_vals]
heatmap(x_vals, y_vals, z, alpha=0.6, title="Grid Function", xlabel="x", ylabel="y", legend=false, aspect_ratio=:equal)

function h_norm(v)
    mr = hypot(v...)
    mt = atan(v[2], v[1])*w
    min(f_x(mr), f_x(mt)/j(v))
end

z = [h_norm((x, y)) - t/2 <= 0 for x in x_vals, y in y_vals]
heatmap(x_vals, y_vals, z, alpha=0.6)
