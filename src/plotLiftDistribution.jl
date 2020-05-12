# Plot the panels so they can be visualized

function plotLiftDistribution(panels,cl)
    
    # Initializing the array
    pointsToPlot = zeros(4*length(panels[:,1]),3)
    
    for i = 1:length(panels[:,1])
        
        pointsToPlot[4*(i-1) + 1,1] = panels[i,1]
        pointsToPlot[4*(i-1) + 1,2] = panels[i,2]
        pointsToPlot[4*(i-1) + 1,3] = panels[i,3]
        pointsToPlot[4*(i-1) + 2,1] = panels[i,4]
        pointsToPlot[4*(i-1) + 2,2] = panels[i,5]
        pointsToPlot[4*(i-1) + 2,3] = panels[i,6]
        pointsToPlot[4*(i-1) + 3,1] = panels[i,7]
        pointsToPlot[4*(i-1) + 3,2] = panels[i,8]
        pointsToPlot[4*(i-1) + 3,3] = panels[i,9]
        pointsToPlot[4*(i-1) + 4,1] = panels[i,10]
        pointsToPlot[4*(i-1) + 4,2] = panels[i,11]
        pointsToPlot[4*(i-1) + 4,3] = panels[i,12]
        
    end

    for i = 1:Int(length(pointsToPlot[:,1])/4)
        
        firstIndex = Int(4*(i-1)+1)
        secondIndex = Int(firstIndex + 3)
        
        # Grayscale colors: color = string(1 - cl[i]/maximum(cl))

        PyPlot.surf(pointsToPlot[firstIndex:secondIndex,1],
             pointsToPlot[firstIndex:secondIndex,2],
             pointsToPlot[firstIndex:secondIndex,3],color = [cl[i]/maximum(cl),1-cl[i]/maximum(cl),1-cl[i]/maximum(cl)]) 
        PyPlot.zlim(-.5,.5)
        
    end
    
end