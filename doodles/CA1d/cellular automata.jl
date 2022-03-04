using Images

bitmask(n,i,j) = map(x -> n & (i << x) != 0, 1:j)
rulemask(x) = bitmask(256,x,8)
statemask(x) = bitmask(8,x,3)

function getrule(x) 
    d = zip(map(statemask, 0:7), rulemask(x))
    Dict(d)
end

function getstate(x,i,cycle=false)
    l = length(x)
    if i == 1
       cycle ? [x[l], x[1], x[2]] : [0, x[1], x[2]]
    elseif i == l
       cycle ? [x[i-1], x[i], x[1]] : [x[i - 1], x[i], 0]
    else
        [x[i-1], x[i], x[i+1]]
    end
end

function getrow(prev,rule,cycle=false)
    states = map(x -> getstate(prev,x,cycle),1:length(prev))
    map(x -> get(rule,x,0), states)
end

function startrow(w)
    odd = isodd(w)
    sizel = odd ? Int((w-1) / 2) : Int(w/2)
    sizer = odd ? sizel : sizel - 2
    padl = zeros(sizel)
    padr = zeros(findmid(w))
    mid = odd ? 1 : [1,1]
    vcat(zeros(sizel),mid,zeros(sizer))
end

startrow(4)

function CAsimple(w,h,rule,cycle=false)
    CArule = getrule(rule)
    prow = map(round, rand(w,1))
    #print(prow)
    o = prow
    for i in 2:h
        prow = getrow(prow,CArule,cycle)
        o = hcat(o,prow)
    end
    #transpose(o)
    o
end

function CAcomplex(w,h,rules,rfun,cycle=false)
    ruleset = rules
    currule = getrule(first(rules))
    prow = map(round, rand(w,1))
    o = prow
    for i in 2:h
        prow = getrow(prow,currule,cycle)
        o = hcat(o,prow)
        ruleset = rfun(ruleset)
        currule = getrule(first(ruleset))
    end
    o
end


CAsimple(11,10,45)

save("E:/code/Julia/catestcomplex.png",CAcomplex(500,400,[79,89],x -> circshift(x,1),true))

save("E:/code/Julia/catest.png",CAsimple(500,400,89),false)

