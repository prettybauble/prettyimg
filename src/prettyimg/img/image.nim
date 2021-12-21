# author: Ethosa
import
  ../core/exceptions,
  prettyclr

type
  ImgObj* = object
    w, h: int
    data: seq[ColorObj]
  ImgRef* = ref ImgObj


{.push inline.}

func initImg*(w, h: int, background: ColorObj = Color(1f, 1, 1)): ImgObj =
  ## Initializes a new image object.
  ##
  ## ### Arguments:
  ## `w` - image width;
  ## `h` - image height;
  ## `background` - background color.
  result = ImgObj(w: w, h: h, data: @[])
  for i in 0..w*h:
    result.data.add(background)

func `data`*(img: ImgObj): seq[ColorObj] = img.data
func `w`*(img: ImgObj): int = img.w
func `h`*(img: ImgObj): int = img.h

func contains*(img: ImgObj, x, y: int): bool =
  x <= img.w and y <= img.h

func contains*(img: ImgObj, xy: tuple[x, y: int]): bool =
  xy[0] <= img.w and xy[1] <= img.h

func `[]`*(img: ImgObj, x, y: int): ColorObj =
  ## Returns pixel at `x`,`y` position.
  if not img.contains(x, y):
    raise newException(
      ImageOutOfBoundsError,
      $x & ", " & $y & " point is out of image bounds."
    )
  img.data[img.w*y + x]

func `[]=`*(img: var ImgObj, x, y: int, v: ColorObj) =
  if not img.contains(x, y):
    raise newException(
      ImageOutOfBoundsError,
      $x & ", " & $y & " point is out of image bounds."
    )
  img.data[img.w*y + x] = v

{.pop.}
