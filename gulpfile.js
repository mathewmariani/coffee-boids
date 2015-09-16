var gulp = require('gulp');
var coffee = require('gulp-coffee');
var uglify = require('gulp-uglify');
var rename = require('gulp-rename');

// @NOTE minify javascript files
gulp.task('compress', function() {
  return gulp.src('./javascript/**/*.js')
    .pipe(uglify())

    // @NOTE add .min.js ending
    .pipe(rename({
        extname: '.min.js'
    }))
    .pipe(gulp.dest('./js'));
});

// @NOTE compile coffeescript into javascript
gulp.task('coffee', function () {
    gulp.src('./_coffee/**/*.coffee')
        .pipe(coffee({bare: true}))
        .pipe(gulp.dest('./javascript/'))
});

// @NOTE watch for changes in coffeescript files
// @NOTE watch for changes in javascript files
gulp.task('watch', function () {
    gulp.watch('_coffee/**/*.coffee', ['coffee']);
});

gulp.task('build', ['coffee', 'compress']);

// @NOTE default gulp task
gulp.task('default', ['watch']);
