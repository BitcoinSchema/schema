'use strict'

const strip = require('gulp-strip-css-comments')
const prefix = require('gulp-autoprefixer')
const cssnano = require('gulp-cssnano')
const uglify = require('gulp-uglify')
const concat = require('gulp-concat')
const sass = require('gulp-sass')
const gulp = require('gulp')

const src = {
  css: ['src/sass/styles.scss'],
  js: ['src/js/app.js']
}

const distCss = {
  path: 'docs/vendor/css',
  name: {
    css: 'styles'
  }
}

const distJs = {
  path: 'docs/vendor/js',
  name: {
    js: 'app'
  }
}

const css = () =>
  gulp
    .src(src.css)
    .pipe(sass().on('error', sass.logError))
    .pipe(concat(`${distCss.name.css}.min.css`))
    .pipe(prefix())
    .pipe(strip({ all: true }))
    .pipe(cssnano())
    .pipe(gulp.dest(distCss.path))

const js = () =>
  gulp
    .src(src.js)
    .pipe(concat(`${distJs.name.js}.min.js`))
    .pipe(uglify())
    .pipe(gulp.dest(distJs.path))

const build = gulp.parallel(css, js)

const watch = () => {
  gulp.watch(src.css, css)
  gulp.watch(src.js, js)
}

exports.build = build
exports.css = css
exports.js = js
exports.watch = watch
exports.default = gulp.series(build, watch)
