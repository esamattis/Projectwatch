
path = require "path"
fs = require "fs"
{exec} = require "child_process"

watch = require "watch"
gex = require "gex"
findit = require "findit"
iniparser = require "iniparser"


class Watcher

  constructor: (@name, @cwd, @settings) ->
    @settings.glob ||= "*"
    @settings.watchdir ||= "."

    if @settings.watchdir.substr(0,1) isnt "/"
      @settings.watchdir = path.join(@cwd, @settings.watchdir)

  start: ->

    watch.createMonitor @settings.watchdir, (monitor) =>

      console.log "Found watch '#{ @name }' from directory #{ @settings.watchdir }"

      monitor.on "created", (file) => @onModified(file)
      monitor.on "changed", (file) => @onModified(file)

  onModified: (filepath) ->

    for match in @settings.glob.split(" ")
      if gex(match).on path.basename filepath
        ok = true
        break
    return unless ok

    console.log "#{ filepath } changed on #{ @name }"

    @runCMD()

  runCMD: ->

    cmd = exec @settings.cmd,  cwd: @cwd, (err) =>
      if err
        console.log "Error in #{ @name }"
      else
        console.log "\nRan", @name, "successfully!"

    cmd.stdout.on "data", (data) -> process.stdout.write data
    cmd.stderr.on "data", (data) -> process.stderr.write data


exports.run = ->

  console.log "Searching watch.json files from #{ searchDir }\n"

  dirs = process.argv.splice(2)
  dirs.push process.cwd() unless dirs.length

  for searchDir in dirs
    finder = findit.find(searchDir)
    finder.on "file", (filepath) ->
      if path.basename(filepath) is "projectwatch.cfg"
          iniparser.parse filepath, (err, settingsObs) ->
            throw err if err
            for name, settings of settingsObs
              watcher = new Watcher name, path.dirname(filepath), settings
              watcher.start()
              watcher.runCMD()




