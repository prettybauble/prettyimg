# author: Ethosa
## Provides basic image processing
import
  prettyclr,
  image,
  math


func crop*(img: ImgObj, x1, y1, x2, y2: int): ImgObj =
  ## Crops image in rect(x1, y1, x2, y2)
  let (w, h) = (x2 - x1, y2 - y1)
  result = initImg(w, h)
  for y in 0..<h:
    for x in 0..<w:
      result[x, y] = img[x + x1, y + y1]


func paste*(img: var ImgObj, dst: ImgObj, x1, y1: int) =
  ## Pastes the image at x1,y1 position
  for y in 0..<dst.h:
    for x in 0..<dst.w:
      if img.contains(x+x1, y+y1):
        img[x+x1, y+y1] = dst[x, y]


func rotated90*(img: ImgObj): ImgObj =
  ## Rotates image by 90 degrees.
  result = initImg(img.h, img.w)
  for y in 0..<img.h:
    for x in 0..<img.w:
      result[y, x] = img[x, y]


proc rotate*(img: ImgObj, degree: float): ImgObj =
  ## Rotates the image by `degree`.
  # Detect ortho
  let degree_i = degree.int()
  if degree_i mod 90 == 0:
    result = img
    let d = degree_i mod 360
    for i in 1..(d div 90):
      result = result.rotated90()
    return result

  let
    rads = degToRad(degree)
    mx = (img.w/2)+1f
    my = (img.h/2)+1f
    width = (round((img.w.float()-mx)*cos(rads) + (img.h.float()-my)*sin(rads)) + mx).int()
    height = (round((img.w.float()-mx)*sin(rads) + (img.h.float()-my)*cos(rads)) + my).int()
    midx = ceil((width+1)/2)
    midy = ceil((height+1)/2)

  echo width
  echo height

  result = initImg(width, height, clr(0f, 0f, 0f, 0f))
  var to_rotate = initImg(width, height, clr(0f, 0f, 0f, 0f))
  to_rotate.paste(img, (width/2 - img.w/2).int(), (height/2 - img.h/2).int())

  for y in 0..<height:
    for x in 0..<width:
      let
        x1 = (round((x.float()-midx)*cos(rads) + (y.float()-midy)*sin(rads)) + midx).int()
        y1 = (round(-(x.float()-midx)*sin(rads) + (y.float()-midy)*cos(rads)) + midy).int()

      if (x1 >= 0 and y1 >= 0 and x1 < width and y1 < height):
        result[x, y] = to_rotate[x1, y1]
