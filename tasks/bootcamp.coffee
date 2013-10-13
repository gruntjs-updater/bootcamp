'use strict'

bootcamp = require '../dist/bootcamp.coffee'
colors = require 'colors'

module.exports = (grunt) ->

  grunt.registerMultiTask 'bootcamp', 'Jasmine-style BDD testing written in Sass for Sass.', ->

    showChecklist = (checklist) ->
      list = checklist + ''
      list = list.replace(/✔/g, '✔'.green)
      list = list.replace(/✗/g, '✗'.red)
      grunt.log.writeln list

    @files.forEach (f) ->
      f.src.filter (filepath) ->

        unless grunt.file.exists filepath
          grunt.log.warn 'Source file "' + filepath + '" not found.'
          return false

        else
          tests = bootcamp.test filepath

          if tests.incomplete
            grunt.fail.warn tests.error
            return true

          else if tests.passed

            if tests.tests == 0
              grunt.log.writeln tests.stats
              grunt.log.warn 'Your tests probably haven\'t been properly set up.\nTake a look at https://github.com/tctcl/bootcamp/wiki/setup'
              return true

            else
              showChecklist tests.checklist
              grunt.log.success tests.stats
              return true

          else
            showChecklist tests.checklist
            grunt.fail.warn tests.stats
            return false