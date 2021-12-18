# author: Ethosa
import
  exceptions,
  strutils,
  re


type
  ColorObj*[T] = object
    r*, g*, b*, a*: T
  ColorRef*[T] = ref ColorObj[T]


let
  HEX_COLOR = re(
    "\\A(#|0x)([0-9a-f]{3,6})\\Z",
    {reStudy, reIgnoreCase}
  )
  RGBA_COLOR = re(
    "\\Argba{0,1}\\s*\\(\\s*(\\d+)\\s*,\\s*(\\d+)\\s*,\\s*(\\d+)\\s*,{0,1}\\s*(\\d*)\\s*\\)\\Z",
    {reStudy, reIgnoreCase}
  )


{.push inline.}

func initColor*: ColorObj[uint8] =
  ## Creates a new uint8 color object.
  ColorObj[uint8](r: 255, g: 255, b: 255, a: 255)

func newColor*: ColorRef[uint8] =
  ## Creates a new uint8 color object.
  ColorRef[uint8](r: 255, g: 255, b: 255, a: 255)


func initColor*[T](r, g, b: T): ColorObj[T] =
  ## Creates a new T color object.
  ColorObj[T](r: r, g: g, b: b, a: default(T))

func newColor*[T](r, g, b: T): ColorRef[T] =
  ## Creates a new T color object.
  ColorRef[T](r: r, g: g, b: b, a: default(T))


func initColor*[T](r, g, b, a: T): ColorObj[T] =
  ## Creates a new T color object.
  ColorObj[T](r: r, g: g, b: b, a: a)

func newColor*[T](r, g, b, a: T): ColorRef[T] =
  ## Creates a new T color object.
  ColorRef[T](r: r, g: g, b: b, a: a)


func Color*: ColorObj[float] =
  initColor[float](0, 0, 0, 0)

func Color*(r, g, b: uint8, a: uint8 = 255u8): ColorObj[uint8] =
  initColor[uint8](r, g, b, a)
func Color*(r, g, b: float, a: float = 1f): ColorObj[float] =
  initColor[float](r, g, b, a)


func parseColor*(src: int): ColorObj[float] =
  ## Parses HEX integer to ColorObj.
  ColorObj[float](
    r: ((src shr 24) and 255) / 255,
    g: ((src shr 16) and 255) / 255,
    b: ((src shr 8) and 255) / 255,
    a: (src and 255) / 255
  )


proc parseColor*(src: string): ColorObj[float] =
  ## Parses color if available.
  ##
  ## `clr` can be HEX string (0xfffe, 0xfefefe, 0xfff, #fff, etc.)
  ## also `clr` can be rgb(255, 100, 100) or rgba(100, 100, 100, 100)
  var matched: array[20, string]

  if match(src, HEX_COLOR, matched):
    return parseColor(parseHexInt(src))

  if match(src, RGBA_COLOR, matched):
    return initColor[float](
      parseInt(matched[0]) / 255,
      parseInt(matched[1]) / 255,
      parseInt(matched[2]) / 255,
      if matched[3] != "": parseInt(matched[3]) / 255 else: 1f,
    )

  raise newException(
    ColorStringParseError, src & " isn't color!"
  )

{.pop.}


func toFloat*[T](color: ColorObj[T] | ColorRef[T]): ColorObj[float] =
  ## Converts color object to float color object.
  if T is SomeInteger:
    initColor[float](
      color.r.float / 255, color.g.float / 255,
      color.b.float / 255, color.a.float / 255)
  elif T is SomeFloat:
    initColor[float](
      color.r.float, color.g.float,
      color.b.float, color.a.float)
  else:
    raise newException(
      ColorValueError, "Color uses only number values."
    )

func toInt*[T](color: ColorObj[T] | ColorRef[T]): ColorObj[uint8] =
  ## Converts color object to float color object.
  if T is SomeInteger:
    initColor[uint8](
      color.r.uint8, color.g.uint8,
      color.b.uint8, color.a.uint8)
  elif T is SomeFloat:
    initColor[uint8](
      (color.r * 255).uint8, (color.g * 255).uint8,
      (color.b * 255).uint8, (color.a * 255).uint8)
  else:
    raise newException(
      ColorValueError, "Color uses only number values."
    )


func interpolate*[T, U](color1: ColorObj[T] | ColorRef[T],
                        color2: ColorObj[U] | ColorRef[U],
                        fraction: float): ColorObj[float] =
  ## Interpolates two colors
  var
    clr1 = color1.toFloat()
    clr2 = color2.toFloat()
  let
    r = (clr2.r - clr1.r) * fraction + clr1.r
    g = (clr2.g - clr1.g) * fraction + clr1.g
    b = (clr2.b - clr1.b) * fraction + clr1.b
    a = (clr2.a - clr1.a) * fraction + clr1.a
  initColor(r, g, b, a)
