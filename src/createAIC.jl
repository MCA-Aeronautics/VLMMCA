function createAIC(panels,latticeType)
    
    coordinates = definePoints(panels)
    Xm = coordinates[:,1]
    Ym = coordinates[:,2]
    Zm = coordinates[:,3]
    X1n = coordinates[:,4]
    Y1n = coordinates[:,5]
    Z1n = coordinates[:,6]
    X2n = coordinates[:,7]
    Y2n = coordinates[:,8]
    Z2n = coordinates[:,9]
    unitNormals = zeros(length(panels[:,1]),3)


    AIC = zeros(length(panels[:,1]),length(panels[:,1])) # Initializing our Aerodynamic Influence Coefficients Matrix

    if latticeType == "Horseshoe Lattice"
        
        for i = 1:length(panels[:,1]) # Control Points
        
            # Creating two vectors that are known to lie in the plane of the panel
            panelVector1 = [Xm[i]-X1n[i],Ym[i]-Y1n[i],Zm[i]-Z1n[i]];
            panelVector2 = [Xm[i]-X2n[i],Ym[i]-Y2n[i],Zm[i]-Z2n[i]];
            
            # Crossing those two vectors to find a vector that is known to be normal to the panel
            # The first term is panelVector2 because that is what gives a vector in the positive direction
            normalDirection = cross(panelVector2,panelVector1);
            
            # Normalizing that vector to create the unit normal
            unitNormals[i,:] = normalDirection./norm(normalDirection);
            unitNormals[i,1] = -unitNormals[i,1] # FIXME: I shouldn't have to do this manually to get the x-component in the right direction
            #println(unitNormals[i,:])

            for j = 1:length(panels[:,1]) # Influence of each panel on control point "i"

                r1 = [Xm[i],Ym[i],Zm[i]] - [X1n[j],Y1n[j],Z1n[j]];
                r2 = [Xm[i],Ym[i],Zm[i]] - [X2n[j],Y2n[j],Z2n[j]];

                AIC[i,j] = dot(Velocity(r1,r2,1,"Horseshoe"),unitNormals[i,:]);
        
            end
        
        end

    end

    if latticeType == "Ring Lattice"

        for i = 1:length(panels[:,1]) # Control Points

            # We need to find the center of each panel and make that the control point
            X = (panels[i,1] + panels[i,4] + panels[i,7] + panels[i,10]) / 4
            Y = (panels[i,2] + panels[i,5] + panels[i,8] + panels[i,11]) / 4
            Z = (panels[i,3] + panels[i,6] + panels[i,9] + panels[i,12]) / 4
        
            # Creating two vectors that are known to lie in the plane of the panel
            panelVector1 = [Xm[i]-X1n[i],Ym[i]-Y1n[i],Zm[i]-Z1n[i]];
            panelVector2 = [Xm[i]-X2n[i],Ym[i]-Y2n[i],Zm[i]-Z2n[i]];
            
            # Crossing those two vectors to find a vector that is known to be normal to the panel
            # The first term is panelVector2 because that is what gives a vector in the positive direction
            normalDirection = cross(panelVector2,panelVector1);
            
            # Normalizing that vector to create the unit normal
            unitNormals[i,:] = normalDirection./norm(normalDirection);
            unitNormals[i,1] = -unitNormals[i,1] # FIXME: I shouldn't have to do this manually to get the x-component in the right direction
            #println(unitNormals[i,:])

            for j = 1:length(panels[:,1]) # Influence of each panel on control point "i"

                # Front vortex
                r1 = [X,Y,Z] - [panels[j,1],panels[j,2],panels[j,3]];
                r2 = [X,Y,Z] - [panels[j,4],panels[j,5],panels[j,6]];
                velocity = Velocity(r1,r2,1,"Bound")

                # Right vortex
                r1 = [X,Y,Z] - [panels[j,4],panels[j,5],panels[j,6]];
                r2 = [X,Y,Z] - [panels[j,7],panels[j,8],panels[j,9]];
                velocity = velocity .+ Velocity(r1,r2,1,"Bound")

                # Rear vortex
                r1 = [X,Y,Z] - [panels[j,7],panels[j,8],panels[j,9]];
                r2 = [X,Y,Z] - [panels[j,10],panels[j,11],panels[j,12]];
                velocity = velocity .+ Velocity(r1,r2,1,"Bound")

                # Left vortex
                r1 = [X,Y,Z] - [panels[j,10],panels[j,11],panels[j,12]];
                r2 = [X,Y,Z] - [panels[j,1],panels[j,2],panels[j,3]];
                velocity = velocity .+ Velocity(r1,r2,1,"Bound")

                # Adding a trailing horseshoe
                if panels[j,13] == 1 # check the trailing edge flag

                    # clear the current velocity, we want a horseshoe vortex, not a ring
                    velocity = [0,0,0]

                    # Use the trailing edge of the panel to define a horseshoe vortex that trails off the wing
                    r1 = [Xm[i],Ym[i],Zm[i]] - [X1n[j],Y1n[j],Z1n[j]];
                    r2 = [Xm[i],Ym[i],Zm[i]] - [X2n[j],Y2n[j],Z2n[j]];
                    velocity = velocity .+ Velocity(r1,r2,1,"Horseshoe")

                end

                AIC[i,j] = dot(velocity,unitNormals[i,:]);

            end
        
        end

    end
    
    # In the AIC, each row represents a control point and each 
    # column is the influence of a different panel on that 
    # control point

    return AIC, unitNormals
    
end