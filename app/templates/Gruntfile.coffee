'use strict'
lrSnippet   = require('grunt-contrib-livereload/lib/utils').livereloadSnippet
folderMount = (connect, dir) -> connect.static(require('path').resolve(dir))

module.exports = (grunt) ->
  # load all grunt tasks
  require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks
  yeomanConfig =
    app: 'app'
    dist: 'dist'

  try
    yeomanConfig.app = require('./component.json').appPath || yeomanConfig.app
  catch e
    #ignore

  console.log yeomanConfig
  grunt.initConfig
    yeoman: yeomanConfig
    watch:
      coffee:
        files: ['<%= yeoman.app %>/scripts/{,*/}*.coffee']
        tasks: ['coffee:dist']
      coffeeTest:
        files: ['test/spec/{,*/}*.coffee']
        tasks: ['coffee:test']
      compass:
        files: ['<%= yeoman.app %>/styles/{,*/}*.{scss,sass}']
        tasks: ['compass']
      livereload:
        files: [
          '<%= yeoman.app %>/*.html',
          '{.tmp,<%= yeoman.app %>}/styles/{,*/}*.css',
          '{.tmp,<%= yeoman.app %>}/scripts/{,*/}*.js',
          '<%= yeoman.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
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
            folderMount(connect, yeomanConfig.app)
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
        path: 'http://<%= connect.options.hostname %>:<%= connect.options.port %>'
    clean:
      dist:
        files: [
          dot: true
          src: [
            '.tmp',
            '<%= yeoman.dist %>/*',
            '!<%= yeoman.dist %>/.git*',
          ]
        ]
      server: '.tmp'
    jshint:
      options:
        jshintrc: '.jshintrc'
      all: [
        '<%= yeoman.app %>/scripts/{,*/}*.js'
      ]
    coffee:
      dist:
        files: [
          expand: true
          cwd: '<%= yeoman.app %>/scripts'
          src: '{,*/}*.coffee'
          dest: '.tmp/scripts'
          ext: '.js'
        ]
      test:
        files: [
          expand: true
          cwd: '<%= yeoman.app %>/scripts'
          src: '{,*/}*.coffee'
          dest: '.tmp/scripts'
          ext: '.js'
        ]
    compass:
      options:
        require: 'zurb-foundation'
        sassDir: '<%= yeoman.app %>/styles'
        cssDir: '.tmp/styles'
        javascriptsDir: '<%= yeoman.app %>/scripts'
        fontsDir: '<%= yeoman.app %>/styles/fonts'
        importPath: '<%= yeoman.app %>/components'
        relativeAssets: true
      dist:
      server:
        options:
           debugInfo: true
    concat:
      dist:
        files:
          '<%= yeoman.dist %>/scripts/scripts.js': [
            '.tmp/scripts/{,*/}*.js',
            '<%= yeoman.app %>/scripts/{,*/}*.js'
          ]
    useminPrepare:
      html: '<%= yeoman.app %>/index.html'
      options:
        dest: '<%= yeoman.dist %>'
    usemin:
      html: ['<%= yeoman.dist %>/{,*/}*.html']
      css: ['<%= yeoman.dist %>/styles/{,*/}*.css']
      options:
        dirs: ['<%= yeoman.dist %>']
    imagemin:
      dist:
        files: [
          expand: true,
          cwd: '<%= yeoman.app %>/images'
          src: '{,*/}*.{png,jpg,jpeg}'
          dest: '<%= yeoman.dist %>/images'
        ]
    cssmin:
      dist:
        files:
          '<%= yeoman.dist %>/styles/main.css': [
            '.tmp/styles/{,*/}*.css',
            '<%= yeoman.app %>/styles/{,*/}*.css'
          ]
    htmlmin:
      dist:
        options:
        files: [
          expand: true
          cwd: '<%= yeoman.app %>'
          src: ['*.html', 'views/*.html']
          dest: '<%= yeoman.dist %>'
        ]
    cdnify:
      dist:
        html: ['<%= yeoman.dist %>/*.html']
    ngmin:
      dist:
        files: [
          expand: true
          cwd: '<%= yeoman.dist %>/scripts'
          src: '*.js'
          dest: '<%= yeoman.dist %>/scripts'
        ]
    uglify:
      dist:
        files:
          '<%= yeoman.dist %>/scripts/scripts.js': [
            '<%= yeoman.dist %>/scripts/scripts.js'
          ]
    rev:
      dist:
        files:
          src: [
            '<%= yeoman.dist %>/scripts/{,*/}*.js',
            '<%= yeoman.dist %>/styles/{,*/}*.css',
            '<%= yeoman.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}',
            '<%= yeoman.dist %>/styles/fonts/*'
          ]
    copy:
      dist:
        files: [
          expand: true
          dot: true
          cwd: '<%= yeoman.app %>'
          dest: '<%= yeoman.dist %>'
          src: [
            '*.{ico,txt}',
            '.htaccess',
            'components/**/*',
            'images/{,*/}*.{gif,webp}',
            'styles/fonts/*'
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
    'compass:dist',
    'livereload-start',
    'connect',
  ]

  grunt.registerTask 'default', ['build']
