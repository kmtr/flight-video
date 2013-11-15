# Load ext components
define [
  'flight/lib/component'
  ],
# define video component
(defineComponent)->
  initMediaApi = ()->
    window.URL = window.URL or window.webkitURL
    navigator.getUserMedia =
      navigator.getUserMedia or
      navigator.webkitGetUserMedia or
      navigator.mozGetUserMedia or
      navigator.msGetUserMedia

  video = ->
    # set default attributes
    @defaultAttrs
      autoplay: 'autoplay'
      refreshRate: 10
      clipBox: {left: 0, top: 0, w: 0, h: 0}
      clipCallback: (err, imageData)->
      onFailSoHard: ()->

    # initialize
    @after 'initialize', ->
      initMediaApi()
      # set dom node properties
      $video = @$node.find(@attr.videoSelector)
      $video.hide()
      if @attr.autoplay
        $video.attr({autoplay: @attr.autoplay})
      if @attr.src
        $video.attr({src: @attr.src})
      @video = $video.get 0
      @canvas = @$node.find(@attr.canvasSelector).get 0
      @ctx = @canvas.getContext('2d')
      @localMediaStream = null

      _ = @

      @video.addEventListener 'play', (e)->
        if @paused || @ended
          false
        else
          draw(@, _.ctx, 0, 0,  _.canvas.width, _.canvas.height)
      ,false

      draw = (video, ctx, x, y, w, h)->
        ctx.drawImage(video, x, y, w, h)
        cb = _.attr.clipBox
        ctx.rect(cb.left, cb.top, cb.w, cb.h)
        ctx.strokeStyle = cb.strokeStyle
        ctx.lineWidth = cb.lineWidth
        ctx.stroke()
        setTimeout(draw, _.refreshRate, video, ctx, x, y, w, h)


      if not @attr.src
        navigator.getUserMedia(
          {video: true}
          (stream)->
            _.video.src = window.URL.createObjectURL stream
            _.localMediaStream = stream
          @onFailSoHard
        )
      @on 'click', (e)->clip(_.ctx, @attr.clipBox, @attr.clipCallback)

  # export
  defineComponent video

clip = (ctx, clipBox, callback)->
  try
    image = ctx.getImageData(clipBox.left, clipBox.top, clipBox.w, clipBox.h)
    callback(null, image)
  catch error
    callback(error, null)

