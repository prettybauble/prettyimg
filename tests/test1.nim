import
  prettyimg,
  unittest


suite "Image":
  var image: ImgObj

  test "init image object":
    image = initImg(1024, 1024, Color(0.2, 0.3, 0.4))

  test "save to BMP file":
    image.saveBMP("asd.bmp")

  test "fromBMP func":
    var
      encoded = image.toBmp()
      img = fromBmp(encoded)
    img.saveBmp("encoded.bmp")

  test "loadBMP and save it":
    var img = loadBmp("assets/sample.bmp")
    img.saveBMP("sample.bmp")

  test "crop & paste image and save it":
    var
      img = loadBmp("assets/sample_sd.bmp")
      cropped = crop(img, 0, 0, 360, 360)
    cropped.saveBmp("cropped.bmp")
    img.paste(cropped, 256, 0)
    img.saveBmp("pasted.bmp")

  test "other":
    assert (0, 0) in image  # image.contains(x, y)
