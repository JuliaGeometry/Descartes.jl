using Documenter
using Descartes

makedocs(
    sitename = "Descartes",
    format = :html,
    modules = [Descartes],
    authors = "Steve Kelly",

)


deploydocs(
    repo = "github.com/sjkelly/Descartes.jl.git"
)
