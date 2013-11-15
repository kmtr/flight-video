module.exports = (grunt)->
  # directories
  coffeeDir = 'src/coffee/'
  jadeDir = 'src/jade/'
  testDir = 'test/'
  demoDir = 'demo/'
  bower_components = 'bower_components/'

  # grunt init config
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    bower: grunt.file.readJSON 'bower.json'

    # compile coffeescript
    coffee:
      opitions:
        bare: true
      app:
        expand: true
        cwd: coffeeDir
        src: '*.coffee'
        dest: demoDir + 'javascript/'
        ext: '.js'

      test:
        expand: true
        cwd: testDir
        src: '**/*.coffee'
        dest: demoDir + testDir
        ext: '.js'

    # lint coffeescript files
    coffeelint:
      gruntfile:
        src: ['Gruntfile.coffee']
      app:
        src: '<%= coffee.app.cwd %>*'
      test:
        src: '<%= coffee.test.cwd %><%= coffee.test.src %>'

    # compile jade template
    jade:
      demo:
        expand: true
        cwd: 'test/demo_jade'
        src: '**/*.jade'
        dest: demoDir
        ext: '.html'

      specrunner:
        expand: true
        cwd: 'test/spec'
        src: '*.jade'
        dest: demoDir + testDir
        ext: '.html'

    # minify javascript
    uglify:
      app:
        expand: true
        cwd: bower_components
        src: [
          'video.js'
          'requireMain.js'
        ]
        dest: '<%= uglify.app.cwd %>'
        ext: '.js'

    # copy
    copy:
      main:
        expand: true
        cwd: demoDir
        src: ['javascript/video.js']
        dest: 'lib/'

      bower:
        expand: true
        cwd: bower_components
        src: [
          'es5-shim/**/*.min.js'
          'jquery/**/*.min.js'
          'underscore/**/*.min.js'
          'flight/**/*.js'
          'requirejs/require.js'
          'mocha/*.js'
          'mocha/*.css'
          'chai/*.js'
          'eventEmitter/EventEmitter.js'
        ]
        dest: demoDir + bower_components

    connect:
      server:
        options:
          base: demoDir

    watch:
      jade:
        files: '<%= jade.demo.cwd %>' + '<%= jade.demo.src %>'
        tasks: ['jade:demo']

      coffee:
        files: ['src/coffee/**/*.coffee']
        tasks: ['coffeelint:app', 'coffee:app', 'uglify']

      test:
        files: '<%= coffee.test.cwd %><%= coffee.test.src %>'
        tasks: ['coffeelint:test', 'coffee:test']

      specrunner:
        files: ['test/spec/**/*.jade']
        tasks: ['jade:specrunner']

    # clean files
    clean:
      build:
        src: [demoDir]

  # app build task
  grunt.registerTask 'compile', [
    'coffeelint:app', 'coffee:app'
    'uglify','jade'
    ]

  grunt.registerTask 'test', [
    'compile', 'coffeelint:test', 'coffee:test'
    ]

  # default task
  grunt.registerTask 'default', ['compile', 'test', 'uglify', 'copy']

  # demo task
  grunt.registerTask 'demo', ['default', 'connect', 'watch']

  # Load Grunt Plugins
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-coffeelint'
