browserify   = require 'browserify'
gulp         = require 'gulp'
source       = require 'vinyl-source-stream'
bundleLogger = require '../../util/bundleLogger'
handleErrors = require '../../util/handleErrors'
config       = require('../../config').mobile.local.scripts.vendor

gulp.task 'vendorMobileScripts', ->
  bundler = browserify({
    cache: {}, packageCache: {}
    basedir: config.baseDir
    extensions: config.extensions
  })

  bundle = ->
    bundleLogger.start config.outputName

    return bundler
             .bundle()
             .on 'error', handleErrors
             .pipe source(config.outputName)
             .pipe gulp.dest(config.dest)
             .on 'end', ->
               bundleLogger.end config.outputName

  return bundle()
