gulp = require 'gulp'
coffee = require 'gulp-coffee'

gulp.task 'default', ->
  gulp.src ['src/coffee/*.coffee']
    .pipe coffee()
    .pipe gulp.dest('js')
