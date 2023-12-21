/*
 * Bibliografia
 * @see https://github.com/browserslist/browserslist
 * */

const path = require('path');
const ROOT = __dirname;
const nameTheme = 'bulma';
//const Fiber 	= require('fibers');

module.exports = function(grunt) {
    require('jit-grunt')(grunt);
    //'use strict';
    /* Configuracion general de las tareas*/
    grunt.initConfig({
        /*views directory*/
        views: 'views',
        /*sources css*/
        src_css: 'public/css',
        /*sources javascript*/
        src_js: 'public/js',
        /*el directorio del tema*/
        theme: 'themes/' + nameTheme,

        /*
         * directorios a limpiar
         *
         * @see https://github.com/gruntjs/grunt-contrib-clean
         * */
        clean: [
            '<%=src_css%>/<%=theme%>/app.min.css'
        ],

        /*
         * Compilar sass
         *
         * @see https://github.com/laurenhamel/grunt-dart-sass
         * */
        'dart-sass': {
            target: {
                options: {
                    sourceMap: false,
                    //outputStyle: 'compressed',
                    //fiber: Fiber,
                    noCache: true
                },
                files: [{
                    expand: true,
                    cwd: '<%=src_css%>/<%=theme%>',
                    src: ['**/**/**/**/*.sass'],
                    dest: '<%=src_css%>/<%=theme%>',
                    ext: '.css'
                }]
            }
        },
        /*
         * Compilar less
         *
         * @see https://github.com/gruntjs/grunt-contrib-less
         * */
        less: {
            options: {
                plugins: [
                    //new (require('less-plugin-autoprefix'))({
                    //browsers: ["last 2 versions"]
                    //})
                    //,new (require('less-plugin-clean-css'))
                ]
            },
            files: {
                expand: true,
                cwd: '<%=src_css%>/<%=theme%>',
                src: ['**/**/**/**/*.less'],
                dest: '<%=src_css%>/<%=theme%>',
                ext: ".css"
            }
        },
        /*
         * Comprimir los js
         *
         * @see https://github.com/gruntjs/grunt-contrib-uglify
         * */
        uglify: {
            options: {
                mangle: true,
                compress: {
                    drop_console: false
                }
            },
            js: {
                files: [{
                    expand: true,
                    cwd: '<%=src_js%>/<%=theme%>',
                    src: ['**/**/**/**/**/*.min.js'],
                    dest: '<%=src_js%>/<%=theme%>'
                }]
            }
        },
        /*
         * Browserify hacer todo esto compatible con el browser
         *
         * @see https://github.com/jmreidy/grunt-browserify
         * 
         * Solucionado problema de destino vacio con postBundleCB
         * @see https://github.com/jmreidy/grunt-browserify/issues/350
         * 
         * */
        browserify: {
            development: {
                options: {
                    //extensions: ['.src.js'], //@FIXME , esto no furula
                    browserifyOptions: {
                        debug: false
                    },
                    transform: [
                        ["babelify", {
                            "presets": ["@babel/preset-env"]
                        }]
                    ],
                    plugin: [
                        [
                            "factor-bundle", {
                                outputs: [
                                    '<%=src_js%>/<%=theme%>/private/dash/main.min.js',

                                    '<%=src_js%>/<%=theme%>/private/catalogue/main.min.js',
                                    '<%=src_js%>/<%=theme%>/private/catalogue/form.min.js',

                                    '<%=src_js%>/<%=theme%>/private/clients/main.min.js',
                                    '<%=src_js%>/<%=theme%>/private/clients/form.min.js',
                                ]
                            }
                        ]
                        //,["minifyify", { map: false }]
                    ],
                    // @see https://github.com/jmreidy/grunt-browserify/issues/350
                    postBundleCB: (err, src, next) => {
                        setTimeout(() => {
                            next(err, src);
                        }, 500);
                    }
                },
                src: [
                    '<%=src_js%>/<%=theme%>/private/dash/main.src.js',

                    '<%=src_js%>/<%=theme%>/private/catalogue/main.src.js',
                    '<%=src_js%>/<%=theme%>/private/catalogue/form.src.js',

                    '<%=src_js%>/<%=theme%>/private/clients/main.src.js',
                    '<%=src_js%>/<%=theme%>/private/clients/form.src.js',
                ],
                dest: '<%=src_js%>/<%=theme%>/app.min.js'
            },
            production: {
                options: {
                    browserifyOptions: {
                        debug: false
                    },
                    transform: [
                        ["babelify", {
                            "presets": ["@babel/preset-env"]
                        }]
                    ],
                    plugin: [
                        [
                            "factor-bundle", {
                                outputs: [
                                    '<%=src_js%>/<%=theme%>/private/dash/main.min.js',

                                    '<%=src_js%>/<%=theme%>/private/catalogue/main.min.js',
                                    '<%=src_js%>/<%=theme%>/private/catalogue/form.min.js',

                                    '<%=src_js%>/<%=theme%>/private/clients/main.min.js',
                                    '<%=src_js%>/<%=theme%>/private/clients/form.min.js',
                                ]
                            }
                        ]
                        //,["minifyify", { map: false }]
                    ],
                    // @see https://github.com/jmreidy/grunt-browserify/issues/350
                    postBundleCB: (err, src, next) => {
                        setTimeout(() => {
                            next(err, src);
                        }, 500);
                    }
                },
                src: [
                    '<%=src_js%>/<%=theme%>/private/dash/main.src.js',

                    '<%=src_js%>/<%=theme%>/private/catalogue/main.src.js',
                    '<%=src_js%>/<%=theme%>/private/catalogue/form.src.js',

                    '<%=src_js%>/<%=theme%>/private/clients/main.src.js',
                    '<%=src_js%>/<%=theme%>/private/clients/form.src.js',
                ],
                dest: '<%=src_js%>/<%=theme%>/app.min.js'
            },
        },

        /*
         * watch para monitorizar los cambios
         *
         * @see https://github.com/gruntjs/grunt-contrib-watch
         * Solucionado problema de lentitud con spawn: false
         * */
        watch: {
            'browserify': {
                files: ['<%=src_js%>/<%=theme%>/**/**/**/**/*.src.js'],
                tasks: ['browserify:development'],
                options: {
                    livereload: {
                        host: '127.0.0.1',
                        port: 35729,
                    },
                    spawn: false
                }
            },
            'dart-sass': {
                files: [
					'<%=src_css%>/<%=theme%>/**/**/**/**/*.sass'
                ],
                //tasks: ['clean' , 'dart-sass', 'purifycss'],
                tasks: ['dart-sass'],
                options: {
                    livereload: {
                        host: '127.0.0.1',
                        port: 35729,
                    },
                    spawn: false
                }
            },
            'less': {
                files: ['<%=src_css%>/<%=theme%>/**/**/**/**/*.less'],
                //tasks: ['clean' ,'less', 'purifycss'],
                tasks: ['less'],
                options: {
                    livereload: {
                        host: '127.0.0.1',
                        port: 35729,
                    },
                    spawn: false
                }
            },
            'views': {
                files: ['<%=views%>/<%=theme%>/**/*.html'],
                options: {
                    livereload: {
                        host: '127.0.0.1',
                        port: 35729,
                    },
                    spawn: false
                }
            }
        },
        /*
         * post proceso de los css
         *
         * @see https://github.com/nDmitry/grunt-postcss
         * 
         * */
        postcss: {
            options: {
                map: false,
                processors: [
                    require('autoprefixer') //Añadir los prefijos 
                    //,require('postcss-clean') //Minimizar y limpiar los css
                ]
            },
            dist: {
                src: '<%=src_css%>/<%=theme%>/**/**/**/**/*.css'
            }
        },
        /*
         * purifycss , optimiza los css
         *
         * @see https://github.com/purifycss/grunt-purifycss
         * 
         * */
        purifycss: {
            options: {
                minify: false,
                whitelist: [
                    '*:not*',
                ]
            },
            target: {
                src: [
                    '<%=views%>/<%=theme%>/**/**/*.html',
                    '<%=src_js%>/<%=theme%>/**/**/**/**/*.min.js'
                ],
                css: [
                    '<%=src_css%>/<%=theme%>/common/bulma.css',
                    '<%=src_css%>/<%=theme%>/common/fontawesome.css',
                ],
                dest: '<%=src_css%>/<%=theme%>/app.min.css'
            }
        }
    });
    /* loadNpmTasks carga todas las tareas */
    /*cargo browserify*/
    grunt.loadNpmTasks('grunt-browserify');
    /*cargo uglify */
    grunt.loadNpmTasks('grunt-contrib-uglify');
    /*cargo cssmin  */
    //grunt.loadNpmTasks('grunt-contrib-cssmin');
    /*cargo dart-sass   */
    grunt.loadNpmTasks('grunt-dart-sass');
    /*cargo less   */
    grunt.loadNpmTasks('grunt-contrib-less');
    /*cargo watch*/
    grunt.loadNpmTasks('grunt-contrib-watch');
    /*Cargo el watch*/
    //grunt.loadNpmTasks('grunt-este-watch');
    /*cargo clean*/
    grunt.loadNpmTasks('grunt-contrib-clean');
    /*cargo purifycss*/
    grunt.loadNpmTasks('grunt-purifycss');
    /*cargo postcss*/
    grunt.loadNpmTasks('grunt-postcss');
    /*el builder  <grunt build> */
    //grunt.registerTask('build', ['browserify:production', 'clean', 'dart-sass', 'less', 'postcss', 'purifycss', 'uglify']);
    grunt.registerTask('build', ['browserify:production', 'clean', 'dart-sass', 'less', 'purifycss', 'postcss', 'uglify']);
    //grunt.registerTask('build', ['clean', 'dart-sass', 'less', 'postcss', 'purifycss', 'uglify']);
    /*el watcher  <grunt monitor>*/
    //    grunt.registerTask('monitor', ['browserify:development', 'clean', 'dart-sass', 'less', 'postcss', 'purifycss','watch']);
    grunt.registerTask('monitor', ['browserify:development', 'dart-sass', 'less', 'purifycss', 'watch']);
    //grunt.registerTask('monitor', ['clean', 'dart-sass', 'less', 'postcss', 'purifycss','watch']);
};
