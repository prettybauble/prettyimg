import
  prettyimg,
  unittest


suite "Colors":
  test "create color":
    let color = initColor[uint8](100, 255, 100)
    echo color

  test "interpolate":
    var
      clr1 = initColor[uint8](255, 100, 100)
      clr2 = initColor[float](0.3, 1, 0.3)
    echo interpolate(clr1, clr2, 0.5)

  test "color to float":
    echo initColor[uint8](255, 100, 100).toFloat()
    echo initColor[int64](1, 100, 200).toFloat()

  test "color to integer":
    echo initColor[float](0.3, 0.1, 1f, 0.9).toInt()
    echo initColor[float](1, 1, 0, 0.5).toInt()


suite "Image":
  var image: ImgObj

  test "init image object":
    image = initImg(1024, 1024, Color(0.2, 0.3, 0.4))

  test "save to BMP file":
    image.saveBMP("asd.bmp")

  test "fromBMP func":
    var
      encoded = image.toBMP()
      img = fromBMP(encoded)
    img.saveBMP("encoded.bmp")

  test "loadBMP and save it":
    var img = loadBMP("assets/sample.bmp")
    img.saveBMP("sample.bmp")

  test "crop & paste image and save it":
    var
      img = loadBMP("assets/sample_sd.bmp")
      cropped = crop(img, 0, 0, 360, 360)
    cropped.saveBMP("cropped.bmp")
    img.paste(cropped, 256, 0)
    img.saveBMP("pasted.bmp")
