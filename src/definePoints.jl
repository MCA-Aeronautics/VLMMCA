# Defining the horseshoe vortices

function definePoints(panels)
    
    coordinates = zeros(length(panels[:,1]),9)
    
    for i = 1:length(panels[:,1])
        currentPanel = panels[i,:]
    
        # To calculate bound vortex x-coordinates:
        # Average of two x-coordinates - 1/4* Difference of the same two x-coordinates
        X1n = (currentPanel[1] + currentPanel[10])/2 - (1/4)*abs(currentPanel[1] - currentPanel[10])
        X2n = (currentPanel[4] + currentPanel[7])/2 - (1/4)*abs(currentPanel[4] - currentPanel[7])
    
        # To calculate bound vortex y-coordinates:
        Y1n = (currentPanel[2] + currentPanel[11])/2 - (1/4)*abs(currentPanel[2] - currentPanel[11])
        Y2n = (currentPanel[5] + currentPanel[8])/2 - (1/4)*abs(currentPanel[5] - currentPanel[8])
    
        # To calculate the bound vortex z-coordinates:
        Z1n = (currentPanel[3] + currentPanel[12])/2 - (1/4)*abs(currentPanel[3] - currentPanel[12])
        Z2n = (currentPanel[6] + currentPanel[9])/2 - (1/4)*abs(currentPanel[6] - currentPanel[9]);
        
        # To calculate control point coordinates:
        # Use the same method as in finding the bound vortex x-coordinates, but this time
        # do both sides of the panel and average their values, giving a point along the axis
        # of the panel.
        # Do the same for the y-coordinate
        Xm = ((currentPanel[1] + currentPanel[10])/2 + (1/4)*abs(currentPanel[1] - currentPanel[10]) + 
            (currentPanel[4] + currentPanel[7])/2 + (1/4)*abs(currentPanel[4] - currentPanel[7]))/2
        Ym = ((currentPanel[2] + currentPanel[11])/2 + (1/4)*abs(currentPanel[2] - currentPanel[11]) + 
            (currentPanel[5] + currentPanel[8])/2 + (1/4)*abs(currentPanel[5] - currentPanel[8]))/2
        Zm = ((currentPanel[3] + currentPanel[12])/2 + (1/4)*abs(currentPanel[3] - currentPanel[12]) + 
            (currentPanel[6] + currentPanel[9])/2 + (1/4)*abs(currentPanel[6] - currentPanel[9]))/2
        
        coordinates[i,:] = [Xm,Ym,Zm,X1n,Y1n,Z1n,X2n,Y2n,Z2n]

    end
    
    coordinates
    
end