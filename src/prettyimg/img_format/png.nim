# author: Ethosa
import
  ../img/image,
  ../core,
  prettystr,
  zippy/crc,
  zippy


func chunk*(kind: PngChunkKind, data: string): string =
  ## Returns Chunk
  result.add(uint32(data.len()).swap())
  result.add($kind)
  result.add(data)
  result.add(crc32($kind & data).swap())


proc toPng*(img: var ImgObj, channels: int = 4): string =
  ## Converts the Image object to PNG.
  ## https://en.wikipedia.org/wiki/Portable_Network_Graphics
  var rgba = img.rgba
  let data = cast[ptr UncheckedArray[uint8]](addr rgba[0])
  var idat = newString(img.w * img.h * channels + img.h)

  # File header
  result.add("\x89\x50\x4E\x47\x0D\x0A\x1A\x0A")

  # IHDR  (13 bytes total)
  var ihdr: string
  ihdr.add(uint32(img.w).swap())
  ihdr.add(uint32(img.h).swap())
  ihdr.add(8u8)  # bit depth (1 byte, values 1, 2, 4, 8, or 16)
  ihdr.add(6u8)  # color type (1 byte, values 0, 2, 3, 4, or 6)
  ihdr.add(0u8)  # compression method (1 byte, value 0)
  ihdr.add(0u8)  # filter method (1 byte, value 0)
  ihdr.add(0u8)  # interlace method (1 byte, values 0 "no interlace" or 1 "Adam7 interlace")
  result.add(chunk(pcIHDR, ihdr))

  # IDAT
  # shift by img.h bytes
  for y in 0..<img.h:
    let pos = y*img.w*channels
    idat[pos + y] = char(3)
    for x in 0..<img.w*channels:
      let
        dataPos = pos + x
        filteredPos = pos + y + 1 + x
      var left, up: int
      if x - channels >= 0:
        left = int(data[dataPos - channels])
      if y - 1 >= 0:
        up = int(data[(y - 1)*img.w*channels + x])
      let avg = uint8((left + up) div 2)
      idat[filteredPos] = char(data[dataPos] - avg)

  result.add(chunk(pcIDAT, compress(idat, BestSpeed, dfZlib)))
  result.add(chunk(pcIEND, ""))


proc savePng*(img: var ImgObj, filename: string) =
  ## Saves Image as PNG file.
  var f = open(filename, fmWrite)
  f.write(img.toPng())
  f.close()
