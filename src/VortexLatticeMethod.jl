# Purpose: Model a geometry using a Vortex Lattice Method
# Inputs:
#   geometry: an array of panels that represent the geometry
#   angleOfAttack: the geometric angle of attack in radians
#
# Outputs:
#   CL: total lift coefficient
#   CD: total induced drag coefficient
#   cl: sectional lift coefficients
#   cd: sectional induced drag coefficients as calculated in the near field

# code to develop this:
# using Pkg; Pkg.add("Revise"); using Revise;
# Pkg.develop(PackageSpec(path = "/Users/markanderson/Box/FLOW Lab/Modules MCA/VortexLatticeMethod"))
# import VortexLatticeMethod.VLM

# This is the main module
module VortexLatticeMethod

    using Pkg
    Pkg.add("LinearAlgebra")
    using LinearAlgebra

    include("calculateDrag.jl")
    include("calculateInducedDrag.jl")
    include("calculateInducedVelocity.jl")
    include("calculateLift.jl")
    include("createAIC.jl")
    include("defineFreestream.jl")
    include("generatePanels.jl")
    include("Velocity.jl")
    include("definePoints.jl")
    include("VelocityFilament.jl")

    function VLM(panels,
                 angleOfAttack,
                 sideslipAngle = 0,
                 freestream = zeros(length(panels[:,3])),
                 density = 1.225)

        freestream = 1.*[cos(angleOfAttack)*cos(sideslipAngle),-sin(sideslipAngle),sin(angleOfAttack)*cos(sideslipAngle)]

        println("Here!")

        # Preparing the AIC matrix
        AIC,unitNormals = createAIC(panels,"Horseshoe Lattice")

        # Defining the b column vector
        b = zeros(length(unitNormals[:,1]))
        for i = 1:length(b)
            #u = freestream[i].*[cos(angleOfAttack)*cos(sideslipAngle),-sin(sideslipAngle),sin(angleOfAttack)*cos(sideslipAngle)]
            u = freestream
            n = [unitNormals[i,1],unitNormals[i,2],unitNormals[i,3]]
            b[i] = -dot(u,n)
        end
        
        # Solving for the circulations
        GammaValues = AIC\b

        # Calculating the lift
        CL, cl, CLSpanLocations = calculateLift(density,freestream,panels,GammaValues);

        # Calculating the induced drag in the near field
        CDi_near, cd_near, Cd_nearSpanLocations, inducedVelocity = calculateInducedDrag(density,freestream,panels,GammaValues,cl);

        # Calculating the induced drag in the far field
        CDi_far, cd_far, Cd_farSpanLocations = calculateDrag(density,freestream,panels,GammaValues);

        return CL, CDi_near, cl, cd_near, CLSpanLocations, GammaValues

    end

end