
path = require "path"
fs = require "fs"

cli = require('cli').enable("version")

watcher = require __dirname + "/lib/watcher"

cli.parse
  port: ['p', 'Listen on this port', "number", 1234]
  host: ['l', 'Listen to a host', 'string', '127.0.0.1']
  version: ['v', 'Show version']


showVersion = ->
  data = JSON.parse fs.readFileSync(__dirname + "/package.json").toString()
  console.log "Current version is #{ data.version }"

exports.run = ->
  cli.main (dirs, options) ->
    if options.version
      showVersion()
    else
      watcher.searchAndWatch dirs, options


