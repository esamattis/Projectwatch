
path = require "path"
fs = require "fs"
{exec} = require "child_process"

watch = require "watch"
gex = require "gex"
findit = require("findit")

# dirs =  process.argv.splice(2)

class Watcher

  constructor: (@dir, @settings) ->

  start: ->

    watch.createMonitor @dir, (monitor) =>
      console.log "Found watch '#{ @settings.name }' from #{ @dir }"
      monitor.on "created", (file) => @onModified(file)
      monitor.on "changed", (file) => @onModified(file)

  onModified: (filepath) ->

    return if not gex(@settings.match).on path.basename filepath

    console.log "#{ filepath } changed on #{ @settings.name }"

    @runCMD()

  runCMD: ->

    cmd = exec @settings.cmd,  cwd: @dir, (err) =>
      if err
        console.log "Error in #{ @settings.name }"
      else
        console.log "\nRan", @settings.name, "successfully!", (new Date) + 2*60*60

    cmd.stdout.on "data", (data) -> process.stdout.write data
    cmd.stderr.on "data", (data) -> process.stderr.write data


exports.run = ->

  searchDir = process.cwd()

  console.log "Searching watch.json files from #{ searchDir }\n"

  watchers = []

  finder = findit.find(searchDir)
  finder.on "file", (filepath) ->
    if path.basename(filepath) is "watch.json"
        fs.readFile filepath, (err, data) =>
          throw err if err
          settings = JSON.parse data
          watcher = new Watcher path.dirname(filepath), settings
          watcher.start()
          watchers.push watcher

  finder.on "end", ->
    console.log "\nInitially running commands"
    for w in watchers
      w.runCMD()


