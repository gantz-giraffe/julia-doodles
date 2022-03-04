using Images

function imgpart(img,w,h)
    w -= 1
    h -= 1
    x = range(1, stop=size(img,1) - w, step=w)
    y = range(1, stop=size(img,2) - h, step=h)
    [img[i:i+w, j:j+h] for i=x, j =y]
end

function makechunks(img, w, h, d)
    part = imgpart(img, w, h)
    srt = sort(part, by= (x -> (foldl(+, Gray.(x)) / (w * h))) ,dims=d)
    w -= 1
    h -= 1
    x = 1:size(srt,1)-1
    y = 1:size(srt,2)-1
    for i = x, j = y
        indi = (i * w)
        indj = (j * h)
        img[indi:indi + w,indj:indj + h] = srt[i,j]
    end
    img
end


orig = load("e:/code/Julia/julia-doodles/doodles/pixel chunk sort/silly hippo.jpg")

chunky = makechunks(orig,4,4,1)

save("e:/code/Julia/julia-doodles/doodles/pixel chunk sort/silly hippo chunk sort.jpg", chunky)