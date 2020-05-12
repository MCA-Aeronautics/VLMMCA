function calculateDrag(density,freestream,panels,GammaValues)
    
    d = zeros(length(panels[:,1]),1)
    Cd = zeros(length(panels[:,1]),1)
    CdSpanLocations = zeros(length(panels[:,1]),1)
    Drag = 0
    Area = 0
    dynamicPressure = 0.5*density*(sum(freestream)/length(freestream))^2
    
    for i = 1:length(panels[:,1]) # Iterating through each panel
        
        yi = panels[i,2] # Front "left" corner from leading edge
        yiPlusOne = panels[i,5] # Front "right" corner from leading edge
            
        zi = panels[i,3] # Front "left" corner from leading edge
        ziPlusOne = panels[i,6] # Front "right" corner from leading edge
        
        yiBar = 0.5 * (yiPlusOne + yi)
        ziBar = 0.5 * (ziPlusOne + zi)
        
        jSummation = 0
        
        for j = 1:length(panels[:,1]) # Iterating through the effects of each other panel on the current panel
            
            yj = panels[j,2] # Front "left" corner from leading edge
            yjPlusOne = panels[j,5] # Front "right" corner from leading edge
            
            zj = panels[j,3] # Front "left" corner from leading edge
            zjPlusOne = panels[j,6] # Front "right" corner from leading edge
            
            kij = (ziBar - zj) * (ziPlusOne - zi) + (yiBar - yj) * (yiPlusOne - yi)
            kij = kij/((yiBar - yj)^2 + (ziBar - zj)^2)
            
            kijPlusOne = (ziBar - zjPlusOne) * (ziPlusOne - zi) + (yiBar - yjPlusOne) * (yiPlusOne - yi)
            kijPlusOne = kijPlusOne/((yiBar - yjPlusOne)^2 + (ziBar - zjPlusOne)^2)
            
            jSummation = jSummation + GammaValues[j] * (kij - kijPlusOne)

        end

        iSummation = GammaValues[i] * jSummation # Using the second summation (the one over "i")

        d[i] = iSummation * density / (4*pi) # distribution of drag
        CdSpanLocations[i] = yiBar # for plotting with Cd
        
        Drag = Drag + d[i] # total drag

    end
    
    for i = 1:length(panels[:,1])
        
        # The area of a parallelogram is equal to its base times its height
        # We will take each deltaY to be our height and use deltaX for our base
        
        deltaY = abs(panels[i,2] - panels[i,5])
        deltaX = abs(panels[i,1] - panels[i,10])
        
        incrementalArea = deltaX * deltaY
        
        Area = Area + incrementalArea
        Cd[i] = d[i]/(dynamicPressure * deltaX * deltaY)
        
    end

    CDi_far = Drag/(dynamicPressure * Area)
    
    return CDi_far, Cd, CdSpanLocations
    
end