using Luxor,LinearAlgebra,Images


function namesave(n)
    string(n,time_ns(),".png")
end

function sharpen(m,rad,amt)
   temp = imfilter(m,Kernel.gaussian(rad))
   return(m + (m - temp) * amt)
end



begin

Drawing(500,500,:png)
    origin()
    background("black")
    setcolor("white")
    for x in 1:7
        
        r= Point(rand((-50,50)),rand((-50,50)))
        
        circle(r,rand((10,50)),:stroke)
    end
    mat = image_as_matrix()
    img = RGB.(mat) 
    finish()
   preview()
end

#img=RGB.(mat)
begin
    for x in 1:10
        global img = sharpen(img,x,0.5)
    end
    img
end


save(namesave("E:/code/Julia/reactdiffuseinc"),map(clamp01nan,img))

