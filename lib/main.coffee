
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

    @rerun = false
    @running = false

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


    # Oh we are already running. Just request restart for this change.
    if @running
      @rerun = true
    else
      @runCMD()


    console.log "Change on '#{ filepath }' running '#{ @name }'!"

  runCMD: ->

    @running = true
    cmd = exec @settings.cmd,  cwd: @cwd, (err) =>
      @running = false

      if err
        console.log "Error in '#{ @name }'"

      if @rerun
        # There has been a change(s) during this run. Let's rerun it.
        console.log "Rerunning '#{ @name }'"
        @rerun = false
        @runCMD()
      else
        console.log "\nRan", @name, "successfully!", (new Date) + 2*60*60

    cmd.stdout.on "data", (data) -> process.stdout.write data
    cmd.stderr.on "data", (data) -> process.stderr.write data


exports.run = ->


  dirs = process.argv.splice(2)
  dirs.push process.cwd() unless dirs.length
  watchers = {}

  console.log "Searching projectwatch.cfg files from #{ dirs }\n"

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
              watchers[name] = watcher




