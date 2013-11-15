path = '../javascript/'
componentName = 'video'
require.config
  baseUrl: 'bower_components/'
  paths:
    video: path + componentName

define [
  'video'
  ],
  (Video)->
    Video.attachTo '#viewer',
      videoSelector: componentName,
      canvasSelector: 'canvas'
      clipBox:
        left: 120, top: 50, w: 50, h: 50
        strokeStyle: '#777'
        lineWidth: 0.05
      clipCallback: sendImage


sendImage = (err, imageData)->
  canvas = document.createElement('canvas')
  canvas.getContext("2d").putImageData(imageData, 0, 0)
  $('img').attr('src', canvas.toDataURL())
