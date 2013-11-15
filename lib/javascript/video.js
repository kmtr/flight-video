(function() {
  var clip;

  define(['flight/lib/component'], function(defineComponent) {
    var initMediaApi, video;
    initMediaApi = function() {
      window.URL = window.URL || window.webkitURL;
      return navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia;
    };
    video = function() {
      this.defaultAttrs({
        autoplay: 'autoplay',
        refreshRate: 10,
        clipBox: {
          left: 0,
          top: 0,
          w: 0,
          h: 0
        },
        clipCallback: function(err, imageData) {},
        onFailSoHard: function() {}
      });
      return this.after('initialize', function() {
        var $video, draw, _;
        initMediaApi();
        $video = this.$node.find(this.attr.videoSelector);
        $video.hide();
        if (this.attr.autoplay) {
          $video.attr({
            autoplay: this.attr.autoplay
          });
        }
        if (this.attr.src) {
          $video.attr({
            src: this.attr.src
          });
        }
        this.video = $video.get(0);
        this.canvas = this.$node.find(this.attr.canvasSelector).get(0);
        this.ctx = this.canvas.getContext('2d');
        this.localMediaStream = null;
        _ = this;
        this.video.addEventListener('play', function(e) {
          if (this.paused || this.ended) {
            return false;
          } else {
            return draw(this, _.ctx, 0, 0, _.canvas.width, _.canvas.height);
          }
        }, false);
        draw = function(video, ctx, x, y, w, h) {
          var cb;
          ctx.drawImage(video, x, y, w, h);
          cb = _.attr.clipBox;
          ctx.rect(cb.left, cb.top, cb.w, cb.h);
          ctx.strokeStyle = cb.strokeStyle;
          ctx.lineWidth = cb.lineWidth;
          ctx.stroke();
          return setTimeout(draw, _.refreshRate, video, ctx, x, y, w, h);
        };
        if (!this.attr.src) {
          navigator.getUserMedia({
            video: true
          }, function(stream) {
            _.video.src = window.URL.createObjectURL(stream);
            return _.localMediaStream = stream;
          }, this.onFailSoHard);
        }
        return this.on('click', function(e) {
          return clip(_.ctx, this.attr.clipBox, this.attr.clipCallback);
        });
      });
    };
    return defineComponent(video);
  });

  clip = function(ctx, clipBox, callback) {
    var error, image;
    try {
      image = ctx.getImageData(clipBox.left, clipBox.top, clipBox.w, clipBox.h);
      return callback(null, image);
    } catch (_error) {
      error = _error;
      return callback(error, null);
    }
  };

}).call(this);
