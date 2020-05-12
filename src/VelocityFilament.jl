function VelocityFilament(r1,r2,gamma,type)

    if type == "Bound"

        V = cross(r1,r2)./(norm(r1)*norm(r2) + dot(r1,r2))
        V = V .* (1/norm(r1)+1/norm(r2))
        V = V.*gamma./(4 * pi)

    elseif type == "Left"

        V = cross(r1,[1,0,0])./(norm(r1) - dot(r1,[1,0,0]))
        V = V .* (1/norm(r1))
        V = V.*gamma./(4 * pi)

    elseif type == "Right"
        #println("r2 = ", r2)
        V = cross(r2,[1,0,0])./(norm(r2) - dot(r2,[1,0,0]))
        V = V .* (1/norm(r2))
        V = -V.*gamma./(4 * pi)

    end

    return V

end