function randomsect(a ::Matrix, ax = "x" ::String)
    s = size(a)
    if (s[1] > 1) && (s[2] > 1)
        if ax == "x"
            r = rand(2:s[1])
            [a[r:s[1], :], a[1:r-1, :]]
        elseif ax == "y"
            r = rand(2:s[2])
            [a[r:s[2], :], a[1:r-1, :]]
        else
            println("ax should be x or y as a string")
        end
    else
        a
    end
end

map(randomsect,randomsect(collect(reshape(1:256,16,16))))