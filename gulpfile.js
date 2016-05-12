var gulp = require('gulp');

var browserify  = require('browserify');
var del         = require('del');
var imagemin    = require('gulp-imagemin');
var jshint      = require('gulp-jshint');
var sass        = require('gulp-sass');
var sourcemaps  = require('gulp-sourcemaps');
var through2    = require('through2');
var uglify      = require('gulp-uglify');

var paths = {
    js: ['app/Resources/assets/js/**/[!_]*.js'],
    js2: ['app/Resources/assets/js/lib/**/*'],
    images: ['app/Resources/assets/img/**/*'],
    css: ['app/Resources/assets/css/**/*.css'],
    sass: ['app/Resources/assets/scss/**/*.scss'],
    components: ['app/Resources/assets/components', 'node_modules'],
    dest: 'web/assets'
};

// Not all tasks need to use streams
// A gulpfile is just another node program and you can use any package available on npm
gulp.task('clean', function() {
    // You can use multiple globbing patterns as you would with `gulp.src`
    return del([paths.dest + '/css', paths.dest + '/js', paths.dest + '/img', paths.dest + '/fonts']);
});

// Lint Task
gulp.task('lint', function() {
    return gulp.src(paths.js)
        .pipe(jshint())
        .pipe(jshint.reporter('default'));
});

// Compile Our Sass
gulp.task('sass', function() {
    return gulp.src(paths.sass)
        .pipe(sourcemaps.init())
        .pipe(sass({
            includePaths: [].concat(paths.components),
            outputStyle: 'compressed'
        }))
        .pipe(sourcemaps.write('./'))
        .pipe(gulp.dest(paths.dest + '/css'));
});

gulp.task('js', ['lint'], function () {
    var browserified = through2.obj(function(file, enc, next) {
        browserify(file.path)
            .bundle(function(err, res) {
                // assumes file.contents is a Buffer
                file.contents = res;
                next(null, file);
            })
        ;
    });

    return gulp.src(paths.js)
        //.pipe(browserified)
        //.pipe(uglify())
        .pipe(gulp.dest(paths.dest + '/js'));
});

gulp.task('css', function () {
    return gulp.src(paths.css)
        .pipe(gulp.dest(paths.dest + '/css'));
});

gulp.task('js_libs', function () {
    return gulp.src(paths.js2)
        .pipe(gulp.dest(paths.dest + '/js/lib'));
});

// Copy all static images
gulp.task('images', ['clean'], function() {
    return gulp.src(paths.images)
        // Pass in options to the task
        .pipe(imagemin({optimizationLevel: 5}))
        .pipe(gulp.dest(paths.dest + '/img'));
});

// Rerun the task when a file changes
gulp.task('watch', function() {
    gulp.watch(paths.js, ['lint', 'scripts']);
    gulp.watch(paths.images, ['images']);
});

// The default task (called when you run `gulp` from cli)
gulp.task('default', ['lint', 'sass', 'js', 'images', 'js_libs', 'css']);
