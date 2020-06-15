# VortexLatticeMethod
A Vortex Lattice Method solver works by:

1. Discretizing a surface into flat four-sided panels
2. Superimposing horseshoe vortices on each of those panels
3. Applying a flow-tangency boundary condition
4. Solving a linear system for the vortex strengths needed to maintain the boundary condition on each panel

# Useful Functions

<pre><code>
VLM(panels,freestream,density = 1.225)
</code></pre>

Where:
- panels = an Nx12 array that contains all of the panels. Each panel's coordinates are defined clockwise when viewed from above
- freestream = an Nx3 array that contains a vector for the freestream at each panel's location
- density = ambient fluid density, defaulting to 1.225 kg/m^3

<pre><code>
generatePanels(firstCoordinate, secondCoordinate, thirdCoordinate, fourthCoordinate, numPanelsSpan,numPanelsChord)
</code></pre>
