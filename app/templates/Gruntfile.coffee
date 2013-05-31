'use strict'
lrSnippet   = require('grunt-contrib-livereload/lib/utils').livereloadSnippet
folderMount = (connect, dir) -> connect.static(require('path').resolve(dir))

module.exports = (grunt) ->
  # load all grunt tasks
  require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks
  #yeomanConfig = app: 'app', dist: 'dist'
  yeoman = app: 'app', dist: 'dist'

  try
    #yeomanConfig.app = require('./component.json').appPath || yeomanConfig.app
    yeoman.app = require('./bower.json').appPath || yeoman.app
  catch e
    #ignore

  grunt.initConfig
    yeoman: yeoman
    watch:
      coffee:
        files: ['<%%= yeoman.app %>/js/{,*/}*.coffee']
        tasks: ['coffee:dist']
      coffeeTest:
        files: ['test/spec/{,*/}*.coffee']
        tasks: ['coffee:test']
      compass:
        files: ['<%%= yeoman.app %>/sass/{,*/}*.{scss,sass}']
        tasks: ['compass']
      livereload:
        files: [
          '<%%= yeoman.app %>/*.html',
          '{.tmp,<%%= yeoman.app %>}/css/{,*/}*.css',
          '{.tmp,<%%= yeoman.app %>}/js/{,*/}*.js',
          '<%%= yeoman.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
        ]
        tasks: ['livereload']
    connect:
      options:
        port: 9000
        hostname: 'localhost'
      livereload:
        options:
          middleware: (connect) -> [
            lrSnippet,
            folderMount(connect, '.tmp'),
            folderMount(connect, yeoman.app)
          ]
      test:
        options:
          middleware: (connect) -> [
            lrSnippet,
            folderMount(connect, '.tmp'),
            folderMount(connect, 'test')
          ]
    open:
      server:
        path: 'http://<%%= connect.options.hostname %>:<%%= connect.options.port %>'
    clean:
      dist:
        files: [
          dot: true
          src: [
            '.tmp',
            '<%%= yeoman.dist %>/*',
            '!<%%= yeoman.dist %>/.git*',
          ]
        ]
      server: '.tmp'
    jshint:
      options:
        jshintrc: '.jshintrc'
      all: [
        '<%%= yeoman.app %>/js/{,*/}*.js'
      ]
    coffee:
      dist:
        files: [
          expand: true
          cwd: '<%%= yeoman.app %>/js'
          src: '{,*/}*.coffee'
          dest: '.tmp/js'
          ext: '.js'
        ]
      test:
        files: [
          expand: true
          cwd: 'test/spec'
          src: '{,*/}*.coffee'
          dest: '.tmp/js'
          ext: '.js'
        ]
    compass:
      options:
        require: 'zurb-foundation'
        sassDir: '<%%= yeoman.app %>/sass'
        cssDir: '.tmp/css'
        javascriptsDir: '<%%= yeoman.app %>/js'
        fontsDir: '<%%= yeoman.app %>/css/fonts'
        importPath: '<%%= yeoman.app %>/components'
        relativeAssets: true
      dist: {}
      server:
        options:
           debugInfo: true
    concat:
      dist:
        files:
          '<%%= yeoman.dist %>/js/scripts.js': [
            '.tmp/js/{,*/}*.js',
            '<%%= yeoman.app %>/components/foundation/js/vendor/{,*/}*.js'
          ]
          '<%%= yeoman.dist %>/js/foundation.js': [
            '<%%= yeoman.app %>/components/foundation/js/foundation/{,*/}*.js'
          ]
    useminPrepare:
      html: '<%%= yeoman.app %>/index.html'
      options:
        dest: '<%%= yeoman.dist %>'
    usemin:
      html: ['<%%= yeoman.dist %>/{,*/}*.html']
      css: ['<%%= yeoman.dist %>/css/{,*/}*.css']
      options:
        dirs: ['<%%= yeoman.dist %>']
    imagemin:
      dist:
        files: [
          expand: true,
          cwd: '<%%= yeoman.app %>/images'
          src: '{,*/}*.{png,jpg,jpeg}'
          dest: '<%%= yeoman.dist %>/images'
        ]
    cssmin:
      dist:
        files:
          '<%%= yeoman.dist %>/css/app.css': [
            '.tmp/css/{,*/}*.css',
            '<%%= yeoman.app %>/css/{,*/}*.css'
          ]
    htmlmin:
      dist:
        files: [
          expand: true
          cwd: '<%%= yeoman.app %>'
          src: ['*.html', 'views/*.html']
          dest: '<%%= yeoman.dist %>'
        ]
    ngmin:
      dist:
        files: [
          expand: true,
          cwd: '<%%= yeoman.dist %>/js',
          src: '*.js',
          dest: '<%%= yeoman.dist %>/js'
        ]
    uglify:
      dist:
        files:
          '<%%= yeoman.dist %>/js/scripts.js': [
            '<%%= yeoman.dist %>/js/scripts.js'
          ]
    rev:
      dist:
        files:
          src: [
            '<%%= yeoman.dist %>/js/{,*/}*.js',
            '<%%= yeoman.dist %>/css/{,*/}*.css',
            '<%%= yeoman.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}',
            '<%%= yeoman.dist %>/css/fonts/*'
          ]
    copy:
      dist:
        files: [
          expand: true,
          dot: true,
          cwd: '<%%= yeoman.app %>',
          dest: '<%%= yeoman.dist %>',
          src: [
            '*.{ico,txt}',
            '.htaccess',
            'images/{,*/}*.{gif,webp}',
            'css/fonts/*'
          ]
        ]

  grunt.renameTask 'regarde', 'watch'

  grunt.registerTask 'server', [
    'clean:server',
    'coffee:dist',
    'compass:server',
    'livereload-start',
    'connect:livereload',
    'open',
    'watch'
  ]

  grunt.registerTask 'test', [
    'clean:server',
    'coffee',
    'compass',
    'connect:test'
  ]
  

  grunt.registerTask 'build', [
    'clean:dist',
    'jshint',
    'test',
    'coffee',
    'compass:dist',
    'useminPrepare',
    'concat',
    'imagemin',
    'cssmin',
    'htmlmin',
    'copy',
    'ngmin',
    'uglify',
    'rev',
    'usemin'
  ]

  grunt.registerTask 'default', ['build']
