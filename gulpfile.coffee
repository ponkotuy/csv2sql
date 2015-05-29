gulp = require 'gulp'
coffee = require 'gulp-coffee'
reactify = require 'coffee-reactify'

gulp.task 'default', ->
  gulp.src ['src/coffee/*.coffee']
    .pipe coffee()
    .pipe gulp.dest('js')

gulp.task 'cjsx', ->
  gulp.src ['src/coffee/*.cjsx']
    .pipe reactify()
    .pipe gulp.dest('js/')
