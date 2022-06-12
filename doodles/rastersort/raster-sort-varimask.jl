using Images

function rastersort(img,dir, mask)
    srt = sort(img, by= (a -> Gray(a)) ,dims=dir)
    x = 1:size(img,1)
    y = 1:size(img,2)
    for i = x, j = y
        imgpix = img[i,j]
        srt[i,j] = mask(imgpix) ? srt[i,j] : imgpix
    end
    srt
end

function rastersort(img,maskx,masky; sortby = a -> Gray(a))
    out = copy(img)
    srtx = sort(img, by= sortby ,dims=1)
    srty = sort(img, by= sortby ,dims=2)
    x = 1:size(img,1)
    y = 1:size(img,2)
    for i = x, j = y
        imgpix = img[i,j]
        sx = srtx[i,j]
        sy = srty[i,j]
        maskxcheck = maskx(imgpix)
        maskycheck = masky(imgpix)
        
        if (maskxcheck && maskycheck)
            out[i,j] = rand([sx,sy])
        elseif (maskxcheck)
            out[i,j] = sx
        elseif (maskycheck)
            out[i,j] = sy
        else 
            out[i,j] = imgpix
        end
    end
    out
end


orig = load("C:/Code/Julia/sillyhippo.jpg")

chunky = rastersort(orig, a -> (blue(a) > 0.51), a -> (red(a) > 0.4))

save("C:/Code/Julia/sillyhipposort.jpg", chunky)
