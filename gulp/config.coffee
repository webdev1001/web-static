src   = './app'
build  = './build'
dist = './dist'

module.exports = {
  dist: {
    scripts: {
      baseDir: src
      extensions: ['.coffee', '.js.jsx.coffee']
      entries: './scripts/bundle.coffee'
      dest: dist + '/scripts/'
      outputName: 'bundle.js'
    }
    styles: {
      src: src + '/stylesheets/main.less'
      dest: dist + '/stylesheets'
      outputName: 'main.css'
    }
  }
  vendor: {
    baseDir: './app/bower_components'
    dest: build + '/scripts'
    outputName: 'vendor.js'
    extensions: ['.coffee']
  }
  client: {
    entries: src + '/scripts/main.coffee'
    dest: build + '/scripts'
    outputName: 'client.js'
    extensions: ['.coffee', '.js.jsx.coffee']
  }
  browserSync: {
    port: 9000
    server: {
      baseDir: [build, src]
    }
    files: [
      build + '/**',
      '!' + build + '/**.map'
    ]
  }
  html: {
    src: src + '/*.html'
    dest: build
  }
  less: {
    src: src + '/stylesheets/main.less'
    dest: build + '/stylesheets'
    outputName: 'main.css'
  }
  minifyJS: {
    src: dist + '/scripts/bundle.js'
    dest: dist + '/scripts'
    outputName: 'bundle.min.js'
  }
  minifyCSS: {
    src: dist + '/stylesheets/main.css'
    dest: dist + '/stylesheets'
    outputName: 'main.min.css'
  }
  clean: {
    dest: build
  }
}