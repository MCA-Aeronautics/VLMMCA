# Purpose: test the VLM code and make sure it's working

# To include this file:
# include("Box/FLOW-MCA/FLOW-Code/Repositories/personal-projects/VortexLatticeMethod/src/VLM_test.jl)

# Getting the packages ready
revise()
Pkg.develop(PackageSpec(path="/Users/markanderson/Box/FLOW-MCA/FLOW-Code/Repositories/personal-projects/VortexLatticeMethod"))
Pkg.add("PyPlot")
using VortexLatticeMethod
using PyPlot

# Getting the VLM() module
import VortexLatticeMethod.VLM

include("generatePanels.jl")
include("plotPanels.jl")
include("plotLiftDistribution.jl")
include("plotInducedDragDistribution.jl")

# Bertin's Wing Geometry
firstCoordinate  = [0.000, 0.000, 0.000];
secondCoordinate = [0.500, 0.500, 0.000];
thirdCoordinate  = [0.700, 0.500, 0.000];
fourthCoordinate = [0.200, 0.000, 0.000];

# Tail Geometry
offset = [2,0,0]
scale = 0.5
firstCoordinateTail  = [0.000, 0.000, 0.000].*scale + offset
secondCoordinateTail = [0.500, 0.500, 0.000].*scale + offset
thirdCoordinateTail  = [0.700, 0.500, 0.000].*scale + offset
fourthCoordinateTail = [0.200, 0.000, 0.000].*scale + offset

numPanelsSpan = 20
numPanelsChord = 10
numPanels = numPanelsSpan*numPanelsChord*2
wingGeometry = generatePanels(firstCoordinate, secondCoordinate, thirdCoordinate, fourthCoordinate, numPanelsSpan,numPanelsChord)
#tailGeometry = generatePanels(firstCoordinateTail, secondCoordinateTail, thirdCoordinateTail, fourthCoordinateTail, numPanelsSpan)
#geometry = cat(dims = 1, wingGeometry,tailGeometry)
#plotPanels(wingGeometry)

alpha = 4.2 # Degrees
angleOfAttack = alpha*pi/180

sideslipAngle = 0 # Degrees
sideslipAngle = sideslipAngle*pi/180

freestream = zeros(numPanels,3)
for i = 1:numPanels
    freestream[i,:] = 1 .* [cos(angleOfAttack)*cos(sideslipAngle),-sin(sideslipAngle),sin(angleOfAttack)*cos(sideslipAngle)]
end

CL, CD, clift, cdrag, CLSpanLocations = VLM(wingGeometry,freestream);

println("CL = ",CL)
println("CD = ",CD / numPanelsChord) # FIXME: This is a hack to approximate the correct value

# figure()
# scatter(CLSpanLocations,cl,marker = ".")

figure()
plotLiftDistribution(wingGeometry,clift)

# figure()
# plotInducedDragDistribution(wingGeometry,cd)