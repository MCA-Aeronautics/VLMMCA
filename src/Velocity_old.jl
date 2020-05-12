# Calculating the induced velocity due to a horseshoe vortex

function Velocity(r1,r2)
    
    V = cross(r1,r2)./(norm(r1)*norm(r2) + dot(r1,r2))
    V = V .* (1/norm(r1)+1/norm(r2))
    V = V + cross(r1,[1,0,0])./(norm(r1)-r1[1]).*1/norm(r1)
    V = V - cross(r2,[1,0,0])./(norm(r2)-r2[1]).*1/norm(r2)
    
end