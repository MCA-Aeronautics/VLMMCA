# VLMMCA (Vortex Lattice Method - MCA)

This code takes wing geometries and freestream flow to calculate the aerodynamic forces on a wing.

A Vortex Lattice Method solver works by:

1. Discretizing a surface into flat four-sided panels
2. Superimposing horseshoe vortices on each of those panels
3. Applying a flow-tangency boundary condition
4. Solving a linear system for the vortex strengths needed to maintain the boundary condition on each panel

# How to run
1. Download the repository
2. The functions are now available for you to use
3. For an example case, type:

<pre><code>
include("src/VLM_Test.jl")
</code></pre>

Note: You must be in the repository directory, and above src/. In other words, you must be in the same directory as Project.toml to run the above code.

4. Feel free to tinker with the VLM_Test.jl file to learn about the program.

# Useful Functions

## VLM()

This is the core solver and is all you need to run the vortex lattice method. The rest are supporting functions.

<pre><code>
CL, CDi_near, cl, cd_near, CLSpanLocations, GammaValues = VLM(panels,freestream,density = 1.225)
</code></pre>

Inputs:
- panels = an Nx12 array that contains all of the panels. Each panel's coordinates are defined clockwise when viewed from above
- freestream = an Nx3 array that contains a vector for the freestream at each panel's location
- density = ambient fluid density, defaulting to 1.225 kg/m^3

Outputs:
- CL = total lift coefficient
- CDi_near = total induced drag coefficient as calculated in the near field
- cl = sectional lift coefficient
- cd_near = sectional induced drag coefficient as calculated in the near field
- CLSpanLocations = the y-coordinate of the center of each panel
- GammaValues = the circulation value at each panel

## generatePanels()
<pre><code>
geometry = generatePanels(firstCoordinate, secondCoordinate, thirdCoordinate, fourthCoordinate, numPanelsSpan,numPanelsChord)
</code></pre>

Inputs:
- first/second/third/fourthCoordinate = the coordinates of the four corners of a given surface, defined clockwise when viewed from above.
- numPanelsSpan = number of panels to include across the span
- numPanelsChord = number of panels to include across the chord
- Note: This function can be used to create arbitrary gemometries, so long as the geometry can be broken up into sections with four corners. The different outputs can be concatonated together using the cat() function.

Outpus:
- geometry = an Nx12 array that contains all of the panels. Each panel's coordinates are defined clockwise when viewed from above

## calculateLift()
<pre><code>
CL, cl, CLSpanLocations = calculateLift(density,freestream,panels,GammaValues)
</code></pre>

Inputs:
- density = ambient fluid density
- freestream = an Nx3 array that contains a vector for the freestream at each panel's location
- panels = an Nx12 array that contains all of the panels. Each panel's coordinates are defined clockwise when viewed from above
- GammaValues = an Nx1 array that contains the local circulation values at each panel

Outputs:
- CL = total lift coefficient
- cl = sectional lift coefficient
- CLSpanLocations = the y-coordinate of the center of each panel

## calculateInducedDrag()
<pre><code>
CDi_near, cd_near, Cd_nearSpanLocations, inducedVelocity = calculateInducedDrag(density,freestream,panels,GammaValues,cl)
</code></pre>

Inputs:
- density = ambient fluid density
- freestream = an Nx3 array that contains a vector for the freestream at each panel's location
- panels = an Nx12 array that contains all of the panels. Each panel's coordinates are defined clockwise when viewed from above
- GammaValues = an Nx1 array that contains the local circulation values at each panel
- cl = an Nx1 array that contains the local (sectional) lift coefficient for each panel

Outpus: 
- CDi_near = the total near-field induced drag coefficient
- cd_near = the near-field induced drag coefficient at each panel
- Cd_nearSpanLocations = the y-coordinates for the center of each panel
- inducedVelocity = the induced velocities at each panel

## calculateDrag()
<pre><code>
CDi_far, cd_far, Cd_farSpanLocations = calculateDrag(density,freestream,panels,GammaValues)
</code></pre>

Inputs:
- density = ambient fluid density
- freestream = an Nx3 array that contains a vector for the freestream at each panel's location
- panels = an Nx12 array that contains all of the panels. Each panel's coordinates are defined clockwise when viewed from above
- GammaValues = an Nx1 array that contains the local circulation values at each panel

Outputs:
- CDi_far = the total far-field induced drag coefficient calculated by using a Trefftz plane analysis
- cd_far = the far-field induced drag coefficient at each panel (little physical relevance)
- Cd_farSpanLocation = the y-coordinates for theh center of each panel
