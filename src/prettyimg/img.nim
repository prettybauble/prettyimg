# author: Ethosa
import
  core/color,
  core/exceptions

type
  ImgObj* = object
    w, h: int
    data: seq[ColorObj[float]]
  ImgRef* = ref ImgObj


proc initImg*(w, h: int, background: ColorObj[float] = initColor[float](0, 0, 0, 0)): ImgObj =
  ## Initializes a new image object.
  ##
  ## ### Arguments:
  ## `w` - image width;
  ## `h` - image height;
  ## `background` - background color.
  result = ImgObj(w: w, h: h, data: @[])
  for i in 0..w*h:
    result.data.add(background)


func `data`*(img: ImgObj): seq[ColorObj[float]] {.inline.} = img.data
func `w`*(img: ImgObj): int {.inline.} = img.w
func `h`*(img: ImgObj): int {.inline.} = img.h

func contains*(img: ImgObj, x, y: int): bool {.inline.} =
  x <= img.w and y <= img.h

func `[]`*(img: ImgObj, x, y: int): ColorObj[float] {.inline.} =
  ## Returns pixel at `x`,`y` position.
  if not img.contains(x, y):
    raise newException(
      ImageOutOfBoundsError,
      $x & ", " & $y & " point is out of image bounds."
    )
  img.data[img.w*y + x]

func `[]=`*[T](img: var ImgObj, x, y: int, v: ColorObj[T]) =
  if not img.contains(x, y):
    raise newException(
      ImageOutOfBoundsError,
      $x & ", " & $y & " point is out of image bounds."
    )
  img.data[img.w*y + x] = v.toFloat()


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
