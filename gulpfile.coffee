gulp = require 'gulp'
coffee = require 'gulp-coffee'
cjsx = require 'gulp-cjsx'
plumber = require 'gulp-plumber'

gulp.task 'default', ['watch', 'cjsx', 'coffee']

gulp.task 'watch', ->
  gulp.watch ['src/coffee/*.coffee'], ['coffee']
  gulp.watch ['src/coffee/*.cjsx'], ['cjsx']

gulp.task 'cjsx', ->
  gulp.src ['src/coffee/*.cjsx']
    .pipe plumber()
    .pipe cjsx()
    .pipe gulp.dest('js/')

gulp.task 'coffee', ->
  gulp.src ['src/coffee/*.coffee']
    .pipe plumber()
    .pipe coffee()
    .pipe gulp.dest('js/')
