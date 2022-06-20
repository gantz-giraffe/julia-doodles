using Luxor, Colors, Dierckx

pnt2vec(a::Point) = [a[1], a[2]]

function pnts2mat(a::Vector{Point})
    reduce(hcat,map(f -> [f[1]; f[2]], a))
end

vec2pnt(a::Vector{Float64}) = Point(a[1], a[2])

function mat2pnts(a::Matrix{Float64})
    [Point(a[1,n],a[2,n]) for n in 1:size(a,2)]
end


function curvetan(sp::ParametricSpline, t::Real; delta= 0.00001)
    t0 = sp(t)
    t1 = sp(t+delta)
    dy = ((t1[2]-t0[2])/delta)
    dx = ((t1[1]-t0[1])/delta)
    p -> [dx*p,dy*p] + t0
end

function curvetanline(fun,len)
    lpnt = fun(-len)
    rpnt = fun(len)
    map(vec2pnt,[lpnt,rpnt])
end

function ParSpiral(t,freq,decay,magnitude,type=:vec)
    scalar = magnitude/(1+(t*decay))
    phase = 2pi*t*freq
    x = sin(phase)*scalar
    y = cos(phase)*scalar
    if (type == :vec)
        [x,y]
    elseif (type == :point)
        Point(x,y)
    end
end

@drawsvg begin
    tar = range(start=0,stop=2,step=0.001)
    pnts= map(p -> ParSpiral(p,33,21,200,:point),tar)
    #poly(mat2pnts(pnts2mat(pnts)),action=:stroke)
    splinspir = ParametricSpline(pnts2mat(pnts),s=0.3)
    splinpnts = map(vec2pnt,map(b -> evaluate(splinspir, b), range(start=0,stop=1,step=0.0005)))
    mytan = curvetan(splinspir,0.07)
    tanpnts = curvetanline(mytan,0.0132)
    line(tanpnts[1],tanpnts[2],action=:stroke)
    circle(vec2pnt(mytan(0.0001)),5,action=:stroke)
    poly(splinpnts,action=:stroke)
    
end
