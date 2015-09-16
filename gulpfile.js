var gulp = require('gulp');
var coffee = require('gulp-coffee');

// @NOTE compile coffeescript into javascript
gulp.task('coffee', function () {
    gulp.src('./_coffee/**/*.coffee')
        .pipe(coffee({bare: true}))
        .pipe(gulp.dest('./js/'))
});

// @NOTE watch for changes in coffeescript files
gulp.task('watch', function () {
    gulp.watch('_coffee/**/*.coffee', ['coffee']);
});

// @NOTE default gulp task
gulp.task('default', ['coffee']);
