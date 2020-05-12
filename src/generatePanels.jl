# Coordinates must be defined starting with the point on the leading edge nearest the center of the wing, and then
# proceed clockwise as viewed looking down on the wing.
# The variable "numPanels" is the number of panels on just half of the total wing, or in other words is the number
# of panels across the coordiantes you define.

function generatePanels(firstCoordinate, secondCoordinate, thirdCoordinate, fourthCoordinate, numPanelsSpan, numPanelsChord = 1)
    
    # Initializing the finalPanels array that will be the returned value of this function
    finalPanels = []

    # Breaking the coordinates into chordwise values
    rootXSpacing = (fourthCoordinate[1] - firstCoordinate[1])/numPanelsChord
    tipXSpacing  = (thirdCoordinate[1] - secondCoordinate[1])/numPanelsChord

    rootYSpacing = (fourthCoordinate[2] - firstCoordinate[2])/numPanelsChord
    tipYSpacing  = (thirdCoordinate[2] - secondCoordinate[2])/numPanelsChord

    rootZSpacing = (fourthCoordinate[3] - firstCoordinate[3])/numPanelsChord
    tipZSpacing  = (thirdCoordinate[3] - secondCoordinate[3])/numPanelsChord

    # Creating arrays to store the different coordinate values in
    adjustedFirstCoordinate = zeros(numPanelsChord,3)
    adjustedSecondCoordinate = zeros(numPanelsChord,3)
    adjustedThirdCoordinate = zeros(numPanelsChord,3)
    adjustedFourthCoordinate = zeros(numPanelsChord,3)

    # Assigning the new coordinate values to the arrays to account for chordwise panels
    for i = 1:numPanelsChord

        # We want the first and second coordinates to march toward the trailing edge of the wing
        adjustedFirstCoordinate[i,1] = firstCoordinate[1] + (i-1)*rootXSpacing
        adjustedFirstCoordinate[i,2] = firstCoordinate[2] + (i-1)*rootYSpacing
        adjustedFirstCoordinate[i,3] = firstCoordinate[3] + (i-1)*rootZSpacing

        adjustedSecondCoordinate[i,1] = secondCoordinate[1] + (i-1)*tipXSpacing
        adjustedSecondCoordinate[i,2] = secondCoordinate[2] + (i-1)*tipYSpacing
        adjustedSecondCoordinate[i,3] = secondCoordinate[3] + (i-1)*tipZSpacing

        # We want the third and fourth coordinates to march toward the trailing edge too, but to start closer to the leading edge
        adjustedThirdCoordinate[i,1] = adjustedSecondCoordinate[i,1] + tipXSpacing
        adjustedThirdCoordinate[i,2] = adjustedSecondCoordinate[i,2] + tipYSpacing
        adjustedThirdCoordinate[i,3] = adjustedSecondCoordinate[i,3] + tipZSpacing

        adjustedFourthCoordinate[i,1] = adjustedFirstCoordinate[i,1] + rootXSpacing
        adjustedFourthCoordinate[i,2] = adjustedFirstCoordinate[i,2] + rootYSpacing
        adjustedFourthCoordinate[i,3] = adjustedFirstCoordinate[i,3] + rootZSpacing
        

    end

    # println(adjustedFirstCoordinate)
    # println(adjustedSecondCoordinate)
    # println(adjustedThirdCoordinate)
    # println(adjustedFourthCoordinate)

    # Reassigning the coordinates to work with the old code
    firstCoordinate = adjustedFirstCoordinate
    secondCoordinate = adjustedSecondCoordinate
    thirdCoordinate = adjustedThirdCoordinate
    fourthCoordinate = adjustedFourthCoordinate

    for j = 1:numPanelsChord
        # initializing the final panels array
        panels = zeros(2*numPanelsSpan,13)
        orderedPanels = zeros(2*numPanelsSpan,13)
        
        # Getting the various spacings sorted out
        leadingEdgeXSpacing = (secondCoordinate[j,1] - firstCoordinate[j,1])/numPanelsSpan;
        trailingEdgeXSpacing = (thirdCoordinate[j,1] - fourthCoordinate[j,1])/numPanelsSpan;
        
        leadingEdgeYSpacing = (secondCoordinate[j,2] - firstCoordinate[j,2])/numPanelsSpan;
        trailingEdgeYSpacing = (thirdCoordinate[j,2] - fourthCoordinate[j,2])/numPanelsSpan;
        
        leadingEdgeZSpacing = (secondCoordinate[j,3] - firstCoordinate[j,3])/numPanelsSpan;
        trailingEdgeZSpacing = (thirdCoordinate[j,3] - fourthCoordinate[j,3])/numPanelsSpan;
        
        
        # Defining the x-coordinates on the right side of the wing that the coordinates were given for
        for i = 1:numPanelsSpan
                
            panels[i,1] = firstCoordinate[j,1] + (i-1)*leadingEdgeXSpacing; # Top left corner
            panels[i,4] = panels[i,1] + leadingEdgeXSpacing; # Top right corner
            panels[i,10] = fourthCoordinate[j,1] + (i-1)*trailingEdgeXSpacing; # Bottom left corner
            panels[i,7] = panels[i,10] + trailingEdgeXSpacing; # Bottom left corner

            # Setting a flag to tell us whether this is a trailing edge panel
            if j == numPanelsChord
                panels[i,13] = 1
            end
            
        end
        
        # Defining the y-coordinates on the right side of the wing that the coordinates were given for
        for i = 1:numPanelsSpan
                
            panels[i,2] = firstCoordinate[j,2] + (i-1)*leadingEdgeYSpacing; # Top left corner
            panels[i,5] = panels[i,2] + leadingEdgeYSpacing; # Top right corner
            panels[i,11] = fourthCoordinate[j,2] + (i-1)*trailingEdgeYSpacing; # Bottom left corner
            panels[i,8] = panels[i,11] + trailingEdgeYSpacing; # Bottom left corner

            # Setting a flag to tell us whether this is a trailing edge panel
            if j == numPanelsChord
                panels[i,13] = 1
            end
            
        end
        
        # Defining the z-coordinates on the right side of the wing that the coordinates were given for
        for i = 1:numPanelsSpan
                
            panels[i,3] = firstCoordinate[j,3] + (i-1)*leadingEdgeZSpacing; # Top left corner
            panels[i,6] = panels[i,3] + leadingEdgeZSpacing; # Top right corner
            panels[i,12] = fourthCoordinate[j,3] + (i-1)*trailingEdgeZSpacing; # Bottom left corner
            panels[i,9] = panels[i,12] + trailingEdgeZSpacing; # Bottom left corner

            # Setting a flag to tell us whether this is a trailing edge panel
            if j == numPanelsChord
                panels[i,13] = 1
            end
            
        end
        
        # Defining the symmetric side of wing
        for i = 1:numPanelsSpan
            
            # The wing is assumed to be symmetric about the x-axis, such that the y-values must be negative.
            # In order to maintain consistent orientation of the unit normal to each panel, the order of the
            # coordinates for each panel must be flipped such that the first and second, along with the third
            # and fourth swap places.
            
            # Top Left (swapping first and second, and the y-value becomes negative)
            panels[numPanelsSpan + i,1] = panels[i,4]
            panels[numPanelsSpan + i,2] = -panels[i,5]
            panels[numPanelsSpan + i,3] = panels[i,6]
            
            # Top Right (swapping first and second, and the y-value becomes negative)
            panels[numPanelsSpan + i,4] = panels[i,1]
            panels[numPanelsSpan + i,5] = -panels[i,2]
            panels[numPanelsSpan + i,6] = panels[i,3]
            
            # Bottom Right (swapping first and second, and the y-value becomes negative)
            panels[numPanelsSpan + i,7] = panels[i,10]
            panels[numPanelsSpan + i,8] = -panels[i,11]
            panels[numPanelsSpan + i,9] = panels[i,12]
            
            # Bottom Left (swapping first and second, and the y-value becomes negative)
            panels[numPanelsSpan + i,10] = panels[i,7]
            panels[numPanelsSpan + i,11] = -panels[i,8]
            panels[numPanelsSpan + i,12] = panels[i,9]

            # Setting a flag to tell us whether this is a trailing edge panel
            if j == numPanelsChord
                panels[numPanelsSpan + i,13] = 1
            end
            
        end
        
        # Ordering the panels from most negative Y to most positive Y
        for i = 1:numPanelsSpan

            # Putting the negative Y panels at the front of the array
            orderedPanels[i,:] = panels[end + 1 - i,:]

        end

        for i = 1:numPanelsSpan

            orderedPanels[numPanelsSpan + i,:] = panels[i,:]

        end

        finalPanels = cat(dims=1,finalPanels,orderedPanels)

    end

    return finalPanels
    
end