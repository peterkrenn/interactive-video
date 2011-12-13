$ ->
  every = (delay, func) -> setInterval(func, delay)

  video = $('#video')[0]
  buffer = $('#buffer')[0].getContext('2d')
  output = $('#output')[0].getContext('2d')
  width = output.canvas.width
  height = output.canvas.height

  every 1000/24, ->
    buffer.drawImage(video, 0, 0)

    image = buffer.getImageData(0, 0, width, height)
    imageData = image.data
    alphaData = buffer.getImageData(0, height, width, height).data

    for index in [0..imageData.length] by 4
      imageData[index + 3] = alphaData[index]

    output.putImageData(image, 0, 0, 0, 0, width, height)
