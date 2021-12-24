# author: Ethosa
## Provides writing ICO and CUR files.
import
  ../img/image,
  ../core,
  prettystr,
  png


func toIco*(imgs: seq[ImgObj], kind: IcoKind = ikIco): string =
  ## Converts Image to the ICO file.

  # Header
  result.add(0u16)  # Reserved. Must always be 0.
  result.add(uint16(kind))  # Specifies image type.
  result.add(uint16(imgs.len()))  # Specifies number of images in the file.

  var offset: uint32 = uint32(imgs.len()*16 + 6)  # images count * image directory size + header size.

  # Image directories
  for img in imgs:
    if img.w > 256 or img.h > 256:
      raise newException(IcoError, "image width and height must be in 0..256.")
    result.add(uint8(img.w))
    result.add(uint8(img.h))
    # Specifies number of colors in the color palette.
    # Should be 0 if the image does not use a color palette.
    result.add(0u8)
    result.add(0u8)  # Reserved. Must always be 0.
    case kind
      of ikIco:
        result.add(1u16)  # Specifies color planes. Should be 0 or 1.
        result.add(32u16)  # Specifies bits per pixel.
      of ikCur:
        result.add(0u16)  # Specifies the horizontal coordinates of the hotspot in number of pixels from the left.
        result.add(0u16)  # Specifies the vertical coordinates of the hotspot in number of pixels from the top.
    let imglen = uint32(img.toPng().len())
    result.add(imglen)
    result.add(offset)
    offset += imglen

  for img in imgs:
    result.add(img.toPng())


func toIco*(img: ImgObj, kind: IcoKind = ikIco): string {.inline.} =
  toIco(@[img], kind)


proc saveIco*(img: ImgObj, filename: string,
              kind: IcoKind = ikIco) =
  var f = open(filename, fmWrite)
  f.write(toIco(img, ikIco))
  f.close()
