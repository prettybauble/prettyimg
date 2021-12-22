# author: Ethosa
## Provides basic image processing
import
  image

func crop*(img: ImgObj, x1, y1, x2, y2: int): ImgObj =
  let (w, h) = (x2 - x1, y2 - y1)
  result = initImg(w, h)
  for y in 0..<h:
    for x in 0..<w:
      result[x, y] = img[x + x1, y + y1]

func paste*(img: var ImgObj, dst: ImgObj, x1, y1: int) =
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
