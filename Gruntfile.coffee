'use strict'

module.exports = (grunt) ->
    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'

        watch:
            coffee:
                files: ['Gruntfile.coffee', 'Resources/public/coffee/**/*.coffee']
                tasks: ['coffee']
            test:
                files: ['Resources/test/spec/*.coffee', 'Resources/coffee/*.coffee']
                tasks: ['test']

        coffee:
            compile:
                options:
                    sourceMap: false
                files:
                    'Resources/test/src/ng-router.js': ['Resources/coffee/ng-router.coffee']
                    'Resources/test/spec/ng-router.js': ['Resources/test/spec/ng-router.coffee']
            dist:
                options:
                    sourceMap: false
                files:
                    'Resources/public/ng-router.js': ['Resources/coffee/ng-router.coffee']

        jasmine:
            ng_router:
                src: 'Resources/test/src/*.js'
                options:
                    specs: 'Resources/test/spec/*.js'

    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-jasmine'
    grunt.loadNpmTasks 'grunt-notify'

    grunt.registerTask 'default', ['test']
    grunt.registerTask 'test', ['coffee', 'jasmine']