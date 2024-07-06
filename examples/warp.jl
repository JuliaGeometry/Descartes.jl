# https://www.desmos.com/calculator/mcjscmo6fq

using WGLMakie
WGLMakie.activate!(resize_to=:body)
#Plots.plotly()
# Parameters (TODO: make const or propogate through functions for better performance)
p = 2
w0 = 8

w = 2π / (p * w0)

x_vals = range(-10, 10, length=1200)
y_vals = range(-10, 10, length=1200)

"""
TriangleWave function
"""
function f_x(x, period)
    halfperiod = 0.5 * period
    wave = mod(x, period) - halfperiod
    halfperiod - abs(wave)
end

"""
Grid function
"""
# function f(v)
#     minimum(f_x.(v, p))
# end

# z = [f((x, y)) - t / 2 for x in x_vals, y in y_vals]
# heatmap(x_vals, y_vals, z, alpha=0.6)

# function h(v)
#     mr = hypot(v...)
#     mt = atan(v[2], v[1]) / w
#     min(f_x(mr, p), f_x(mt, p))
# end

# z = [h((x, y)) - t / 2 for x in x_vals, y in y_vals]
# heatmap(x_vals, y_vals, z, alpha=0.6)

function j(v)
    1 / (w * hypot(v...))
end

# z = [h((x, y)) / j((x, y)) - t / 2 <= 0 for x in x_vals, y in y_vals]
# heatmap(x_vals, y_vals, z, alpha=0.6)

using ForwardDiff

# function h_g(v)
#     g = ForwardDiff.gradient(h, [v...]) # TODO: make this faster
#     hypot(g...)
# end

# z = [h((x, y)) / h_g((x, y)) - t / 2 for x in x_vals, y in y_vals]
# heatmap(x_vals, y_vals, z, alpha=0.6)

function h_norm(v)
    mr = hypot(v...)
    mt = atan(v[2], v[1]) / w
    min(f_x(mr, p), f_x(mt, p) / j(v))
end

z = [h_norm((x, y)) - t / 2 for x in x_vals, y in y_vals]
heatmap(x_vals, y_vals, z, alpha=0.6)
