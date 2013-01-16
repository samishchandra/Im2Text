function tc = processIm2ColorTexture(im, textonNodes, colorNodes)


textonim = uint16(getTextonImage(im, textonNodes));

if(size(im,3)==3)
   colorim = uint16(getColorImage(im, colorNodes));
else
   colorim = [];
end

%save(outname, 'textonim', 'colorim');
tc.textonim = textonim;
tc.colorim = colorim;
