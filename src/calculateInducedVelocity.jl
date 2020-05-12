function calculateInducedVelocity(panels,GammaValues,location)
    
    boundVortexCenters = zeros(length(panels[:,1]),3); # Will store the center of each bound vortex
    inducedVelocity = zeros(length(panels[:,1])); # Will become our induced velocity at each panel control point

    coordinates = definePoints(panels);
    Xm = coordinates[:,1]
    Ym = coordinates[:,2]
    Zm = coordinates[:,3]
    X1n = coordinates[:,4]
    Y1n = coordinates[:,5]
    Z1n = coordinates[:,6]
    X2n = coordinates[:,7]
    Y2n = coordinates[:,8]
    Z2n = coordinates[:,9]
    controlPoints = coordinates[:,1:3];

    # Calclulating the center of each bound vortex
    for i = 1:length(panels[:,1])

        deltaX = panels[i,4] - panels[i,1]
        deltaY = panels[i,5] - panels[i,2]
        deltaZ = panels[i,6] - panels[i,3]

        boundVortexCenters[i,1:3] = [X1n[i] + deltaX/2, Y1n[i] + deltaY/2, Z1n[i] + deltaZ/2]

    end

    #figure()
    #plotPanels(panels)
    #scatter3D(boundVortexCenters[:,1],boundVortexCenters[:,2],boundVortexCenters[:,3],color = "black")

    ###############################
    # At the center of the bound vortex
    if location == "quarter chord"
        # Calculating the induced velocities
        for i = 1:length(panels[:,1])
            currentPoint = boundVortexCenters[i,1:3]

            for j = 1:length(panels[:,1]) # Each horseshoe vortex associated with a panel
            
                r1 = currentPoint - [X1n[j],Y1n[j],Zm[j]];
                r2 = currentPoint - [X2n[j],Y2n[j],Zm[j]];

                if j != i
                    inducedVelocity[i] = inducedVelocity[i] + Velocity(r1,r2,GammaValues[j],"Horseshoe")[3]; # Only uses the z-component of the induced velocity
                elseif j == i # ignore the bound vortex
                    LeftFilament =  Velocity(r1,r2,GammaValues[j],"Semi-Infinite Left")[3]; # Semi-infinite filament starting at  the lower y-value of the bound vortex
                    RightFilament = Velocity(r1,r2,GammaValues[j],"Semi-Infinite Right")[3]; # Semi-infinite filament starting at  the upper y-value of the bound vortex
                    inducedVelocity[i] = inducedVelocity[i] + LeftFilament + RightFilament
                end

            end

        end
    end


    # ###############################

    # ###############################
    # # At the control point at 3/4 chord

    # if location == "three quarter chord"
    #     # Calclulating the induced velocities
    #     for i = 1:length(controlPoints[:,1]) # Number of panels
        
    #     currentPoint = [Xm[i],Ym[i],Zm[i]]
    #     # println("Current Point: ",currentPoint)
    #         for j = 1:length(panels[:,1]) # Each horseshoe vortex associated with a panel
                
    #             r1 = currentPoint - [X1n[j],Y1n[j],Zm[j]];
    #             r2 = currentPoint - [X2n[j],Y2n[j],Zm[j]];
            
    #             inducedVelocity[i] = inducedVelocity[i] + Velocity(r1,r2)[3] * GammaValues[j] / (4*pi); # Only uses the z-component of the induced velocity
                
    #         end
    #     end 
    # end

    # ###############################

    # ###############################
    # # Center of the leading edge

    # # Calclulating the induced velocities
    # # for i = 1:length(controlPoints[:,1]) # Number of panels
    
    # #     currentPoint = [(panels[i,1] + panels[i,4])/2,(panels[i,2] + panels[i,5])/2,(panels[i,3] + panels[i,6])/2]
    # #     # println("Current Point: ",currentPoint)
    # #     for j = 1:length(panels[:,1]) # Each horseshoe vortex associated with a panel
            
    # #         r1 = currentPoint - [X1n[j],Y1n[j],Zm[j]];
    # #         r2 = currentPoint - [X2n[j],Y2n[j],Zm[j]];

    # #         inducedVelocity[i] = inducedVelocity[i] + Velocity(r1,r2)[3] * GammaValues[i] / (4*pi); # Only uses the z-component of the induced velocity
            
    # #     end
    # # end

    # ###############################

    return inducedVelocity

end