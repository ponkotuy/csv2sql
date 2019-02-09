gulp = require 'gulp'
coffee = require 'gulp-coffee'
cjsx = require 'gulp-cjsx'
plumber = require 'gulp-plumber'

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

gulp.task 'js', ->
  gulp.src ['src/js/*.js']
    .pipe gulp.dest('js/')

gulp.task 'compile', gulp.series(gulp.parallel('cjsx', 'coffee', 'js'))

gulp.task 'watch', gulp.series 'compile', ->
  gulp.watch('src/coffee/*.coffee', gulp.task('coffee'))
  gulp.watch('src/coffee/*.cjsx', gulp.task('cjsx'))
  gulp.watch('src/js/*.js', gulp.task('js'))

gulp.task 'default', gulp.series('watch')
