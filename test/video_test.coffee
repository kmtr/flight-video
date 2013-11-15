should = chai.should()

require.config
  baseUrl: '../bower_components/'
  paths:
    target: '../javascript/video'

define ['target'], (Video)->
  describe 'Video', ->
    describe 'default attributes', ->
      defaults = Video.prototype.defaults

      defaultKeys = [
          'autoplay'
          'refreshRate'
          'clipBox'
          'clipCallback'
          'onFailSoHard'
          ]
      it "inclued keys " + defaultKeys, ->
        defaults.should.include.keys defaultKeys

      it 'autoplay = "autoplay"', ->
        defaults.autoplay.should.equal 'autoplay'

      it 'refreshRate = 10', ->
        defaults.refreshRate.should.equal 10

      describe 'clipBox is map', ->
        it 'clipBox.left = 0', ->
          defaults.clipBox.left.should.equal 0
        it 'clipBox.top = 0', ->
          defaults.clipBox.top.should.equal 0
        it 'clipBox.w = 0', ->
          defaults.clipBox.w.should.equal 0
        it 'clipBox.h = 0', ->
          defaults.clipBox.h.should.equal 0

