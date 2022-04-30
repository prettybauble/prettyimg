# author: Ethosa
## Provides basic image processing
import
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


func shear(angle: float, x, y: int): tuple[x, y: int] =
  let tg = tan(angle/2)
  var
    new_x = round(float(x) - float(y)*tg)
    new_y = float(y)
  
  new_y = round(new_x*sin(angle) + new_y)
  new_x = round(new_x - new_y*tg)
  
  (int(new_x), int(new_y))


proc rotate*(img: ImgObj, degree: float): ImgObj =
  ## Rotates the image by `degree`.
  let
    angle = degToRad(degree)
    cosine = cos(angle)
    sine = sin(angle)
    (width, height) = (float(img.w), float(img.h))
    (new_width, new_height) = (round(abs(width*cosine) + abs(height*sine)),
                               round(abs(height*cosine) + abs(width*sine)))
    original_center = (int(round(height / 2)), int(round(width / 2)))
    new_center = (int(round(new_width / 2)), int(round(new_height / 2)))
  echo original_center
  echo new_center

  result = initImg(int(new_width), int(new_height))
  for y in 0..<img.h:
    for x in 0..<img.w:
      let
        y1 = img.w-1 - y - original_center[1]
        x1 = img.h-1 - x - original_center[0]
      var
        (new_x, new_y) = shear(angle, x1, y1)
      new_x = new_center[0] - new_x
      new_y = new_center[1] - new_y
      if new_x > 0 and new_x < result.w and new_y > 0 and new_y < result.h:
        result[new_x, new_y] = img[x, y]
