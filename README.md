# Descartes

[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://sjkelly.github.io/Descartes.jl/dev)

[![codecov](https://codecov.io/gh/sjkelly/Descartes.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/sjkelly/Descartes.jl)

Descartes is a research project into the representation of solid geometry. It
is designed to leverage Julia's multiple dispatch and JIT compilation to
create a platform which unifies otherwise disparate geometric representations.
The long term goal is to deliver a geometry kernel suited for the growing
capabilities of digital manufacturing. 

The current focus is on the development of feature parity with OpenSCAD 
and enhanced design with engineering analysis. 
Under the hood Descartes uses a functional representation of geometry, 
inspired by ImplicitCAD, HyperFun, libfive, and several others. 
The syntax is idiomatic julia, but should be familiar to those used to OpenSCAD,

[Examples](https://github.com/sjkelly/Descartes.jl/tree/master/examples)

There are occasional development updates posted [here](https://sjkellyorg.wordpress.com/category/solid-modeling/).

## License
This package is available under the MIT "Expat" License. See [LICENSE.md](./LICENSE.md).
