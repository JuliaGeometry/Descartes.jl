# Descartes v0.0.1 "Concept2"

The mission of Descartes is to unify geometric representations for
solid modeling. Concept2 is the second major iteration of Descartes that
will hopefully take a larger step towards general usefulness. Before we
outline the features and goals for Concept2, we should give a state of
Descartes.

To date:
    * 3 parts taken from design to mesh for 3D printing
    * Functional representations implemented with multiple dispatch.
    * Mesh output with Marching Tetrahedra (via Meshing.jl)
    * OpenSCAD-like syntax
    * Affine Object transforms
    * Shelling operations

Progress has been good, and the first iteration has been very insightful
and lead to more directed developments in our larger ecosystem. The primary
goal of this first iteration was to generate Meshes from CSG descriptions.

The next step is to begin development so Descartes can be competative with
OpenSCAD in both features and performance. Below will outline the general
steps and insights gained towards this direction.

## Trees

Trees are good. Descartes currently implements CSG trees. In a broader context,
we will eventually create "feature trees" so operations steps are transparent.
The current design was developed around distance fields. A glaring issue
is the trees are mutable. For example applying a `Transform` to a
`CSGUnion` will immediately modify the homogenous frame transforms (forward
and inverse) in the children objects. While this is great for computational
efficiency it makes introsepction difficult.

### Hashing


## Specialization

When to specialize? If we keep using the type parameters as the feature trees
we are going to have huge amounts of code gen. What we want is a wrapper
type that will specialize for each top level primitive. For example the primitive
get hashed and wrapped up into an immutable with some hash of the contents so
that a generated function can be constructed. So our concern is similarity of
the tree structure.

### Level1 - Structure

Strucutre is considered, and code is generates for specific configurations.

### Level2 - Values

Values are considered, and we can avoid re-computing things (such as a Mesh).


## Conclusion

The rough TODO:
    * Make all primitives and operations immutable.
    * Enable hashing with above and implement model caching
    * 
