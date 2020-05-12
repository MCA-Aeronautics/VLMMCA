function Velocity(r1,r2,gammaValue,vortexType)

    if vortexType == "Horseshoe"
        velocity = cross(r1,r2)./(norm(r1)*norm(r2) + dot(r1,r2))
        velocity = velocity .* (1/norm(r1)+1/norm(r2))
        velocity = velocity + cross(r1,[1,0,0])./(norm(r1)-r1[1]).*1/norm(r1)
        velocity = velocity - cross(r2,[1,0,0])./(norm(r2)-r2[1]).*1/norm(r2)

        velocity = velocity * gammaValue / (4*pi)

    end

    if vortexType == "Bound"
        velocity = cross(r1,r2)./(norm(r1)*norm(r2) + dot(r1,r2))
        velocity = velocity .* (1/norm(r1)+1/norm(r2))
        velocity = velocity.*gammaValue./(4 * pi)
    end

    if vortexType == "Semi-Infinite Left"
        velocity = cross(r1,[1,0,0])./(norm(r1) - dot(r1,[1,0,0]))
        velocity = velocity .* (1/norm(r1))
        velocity = velocity.*gammaValue./(4 * pi)
    end

    if vortexType == "Semi-Infinite Right"
        velocity = cross(r2,[1,0,0])./(norm(r2) - dot(r2,[1,0,0]))
        velocity = velocity .* (1/norm(r2))
        velocity = -velocity.*gammaValue./(4 * pi)
    end

    return velocity

end