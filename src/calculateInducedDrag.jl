# Calculates induced drag, assuming panels are parallelograms
# This section is already generalized to 3 dimensions because the planform area is defined as the area
# projected into the x-y plane as viewed from above the wing

function calculateInducedDrag(density,freestream,panels,GammaValues,CLn)
    
    CDi_near = 0; # Initial induced drag coefficient assumed to be zero. We'll fix that later
    Cd = zeros(length(panels[:,1])); # Will become our distribution of induced drag coefficient per panel
    CdnSpanLocation = zeros(length(panels[:,1])); # Will become our panel center locations
    Area = 0; # Initial planform area assumed to be zero. We'll fix that later
    inducedVelocity = zeros(length(panels[:,1])); # Will become our induced velocity at each panel control point
    inducedAlpha = zeros(length(panels[:,1])); # Will store induced Angle of Attack Information
    boundVortexCenters = zeros(length(panels[:,1]),3); # Will store the center of each bound vortex
    dynamicPressure = 0.5*density*(sum(freestream)/length(freestream))^2;
    
    ##############################
    # Center of the bound vortex

    inducedVelocity = calculateInducedVelocity(panels,GammaValues,"quarter chord") 

    #integrate over the lifting line
    for i = 1:length(inducedVelocity)

        deltaY = abs(panels[i,2] - panels[i,5])
        deltaX = abs(panels[i,1] - panels[i,10])

        Cd[i] = -(density * inducedVelocity[i] * GammaValues[i] * deltaY) ./ (dynamicPressure * deltaX * deltaY)

        CdnSpanLocation[i] = panels[i,2] + deltaY/2

        CDi_near = CDi_near + Cd[i]*deltaY # multiply by deltaY because Cd[i] is the induced drag per unit span
        # Does this mean that it should be deltaY/span?
        # See Bertin's Book, Eqn 5.23 on page 218

    end
    
    return CDi_near, Cd, CdnSpanLocation, inducedVelocity

end