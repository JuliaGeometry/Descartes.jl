using Documenter
using Descartes

makedocs(
    sitename = "Descartes",
    format = :html,
    modules = [Descartes]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
