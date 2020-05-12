# Calculates lift, assuming panels are parallelograms
# This section is already generalized to 3 dimensions because the planform area is defined as the area
# projected into the x-y plane as viewed from above the wing

function calculateLift(density,freestream,panels,GammaValues)
    
    Lift = 0; # Initial lift assumed to be zero, then we'll add the differential lift given by each panel
    CL = 0; # Initial lift coefficient assumed to be zero. We'll fix that later
    Cl = zeros(length(panels[:,1])); # Will become our distribution of lift coefficient per panel, ClSpanLocations = zeros(length(panels[:,1])); # Will become our panel center locations
    ClSpanLocations = zeros(length(panels[:,1]))
    Area = 0; # Initial planform area assumed to be zero. We'll fix that later
    
    for i = 1:length(panels[:,1])
       
        deltaY = abs(panels[i,2] - panels[i,5])
        
        Lift = Lift + density*freestream[i]*GammaValues[i]*deltaY;
        
    end
    
    dynamicPressure = 0.5*density*(sum(freestream)/length(freestream))^2
    # We had to take the average freestream velocity so that dynamic pressure would be a scalar
    
    # Finding the total planform area
    for i = 1:length(panels[:,1])
        
        # The area of a parallelogram is equal to its base times its height
        # We will take each deltaY to be our height and use deltaX for our base
        
        deltaY = abs(panels[i,2] - panels[i,5])
        deltaX = abs(panels[i,1] - panels[i,10])
        panelFrontLength = sqrt((panels[i,1] - panels[i,4])^2 + (panels[i,2] - panels[i,5])^2)
        
        incrementalArea = deltaX * deltaY
        
        Area = Area + incrementalArea
        
        # See eqn 7.51 in Bertin's book
        Cl[i] = (density.*freestream[i]*GammaValues[i]*deltaY)/(dynamicPressure * incrementalArea) # if unit span is only in y
        #Cl[i] = (freestream[i]*GammaValues[i]*deltaY)/(dynamicPressure * deltaX * panelFrontLength) # if unit span is along the leading edge
        ClSpanLocations[i] = panels[i,2] + deltaY/2

    end
    
    # Finding the Total Lift Coefficient. We could have added up the Cl values but I'd rather get it in one
    # simple formula with less rounding error
    CL = Lift/(dynamicPressure * Area)
    
    return CL, Cl, ClSpanLocations;
end