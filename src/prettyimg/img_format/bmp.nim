# author: Ethosa
import
  ../img/image,
  ../core/enums,
  ../core/exceptions,
  prettystr,
  prettyclr,
  strutils


proc fromBmp*(src: string): ImgObj =
  ## Parses the BMP Image from source string.
  if not src.startsWith("BM"):
    raise newException(
      ImageReadError, "Source isn't is BMP Image."
    )
  let
    size = read[uint32](src, 2)
    w = read[int32](src, 18)
    h = read[int32](src, 22)
    depth = read[uint16](src, 28)
    compression = BitmapCompression(read[uint16](src, 30))
  var offset = int(read[uint32](src, 10))

  # Size should be = `src` length
  assert size == uint32(src.len())
  assert compression in [bmBiBITFIELDS, bmBiRGB]

  result = initImg(w, h)

  case depth
  of 32:
    for y in countdown(h-1, 0):
      for x in 0..<w:
        result[x, y] = clr(
          read[uint8](src, offset),
          read[uint8](src, offset + 1),
          read[uint8](src, offset + 2),
          read[uint8](src, offset + 3)
        )
        inc offset, 4
  of 24:
    for y in countdown(h-1, 0):
      for x in 0..<w:
        result[x, y] = clr(
          read[uint8](src, offset + 2),
          read[uint8](src, offset + 1),
          read[uint8](src, offset),
          255
        )
        inc offset, 3
  else:
    raise newException(
      ImageReadError, "supports inly 24 and 32 bit images"
    )


func toBmp*(img: ImgObj, depth: uint16 = 32,
            compression: BitmapCompression = bmBiBITFIELDS): string =
  ## Encodes image to BMP.
  ## https://en.wikipedia.org/wiki/BMP_file_format
  ##
  ## Arguments:
  ## - `depth` - the number of bits per pixel, which is the color depth of the image.
  ##             Typical values are 1, 4, 8, 16, 24 and 32.
  ## - `compression` - the compression method being used.

  result.add("BM")  # signature
  result.add(0u16)  # reserved, 2 bytes
  result.add(0u16)  # reserved, 2 bytes
  result.add(122u32)  # image data offset, 4 bytes (BITMAPINFOHEADER)

  # dib
  result.add(108u32)  # the size of this header, bytes count.
  result.add(int32(img.w))  # image width, 4 bytes
  result.add(int32(img.h))  # image height, 4 bytes
  result.add(1u16)  # the number of color planes (must be 1).
  result.add(depth)  # the number of bits per pixel.
  result.add(uint32(compression))  # the compression method.
  # the image size.
  # This is the size of the raw bitmap data;
  # a dummy 0 can be given for BI_RGB bitmaps.
  result.add(32u32)
  result.add(2835u32)  # the horizontal resolution of the image. (pixel per metre, signed integer).
  result.add(2835u32)  # the vertical resolution of the image. (pixel per metre, signed integer).
  result.add(0u32)  # the number of colors in the color palette, or 0 to default to 2^n.
  result.add(0u32)  # the number of important colors used, or 0 when every color is important; generally ignored.
  result.add(0x000000ffu32)  # red channel.
  result.add(0x0000ff00u32)  # green channel.
  result.add(0x00ff0000u32)  # blue channel.
  result.add(0xff000000u32)  # alpha channel.
  result.add("Win ") # Little-endian.
  for i in 0..<48:
    result.add(0u8) # unused 48 bytes.

  for y in countdown(img.h-1, 0):
    for x in 0..<img.w:
      let clr = img[x, y].rgb255()
      result.add(clr.r)
      result.add(clr.g)
      result.add(clr.b)
      result.add(clr.a)
  result.insert(2, uint32(result.len() + 4))


proc saveBmp*(img: ImgObj, filename: string, depth: uint16 = 32,
              compression: BitmapCompression = bmBiBITFIELDS) =
  ## Saves image as BMP.
  var file = open(filename, fmWrite)
  file.write(toBmp(img, depth, compression))
  file.close()

proc loadBmp*(filename: string): ImgObj =
  ## Loads BMP file.
  var file = open(filename)
  result = fromBmp(file.readAll())
  file.close()
