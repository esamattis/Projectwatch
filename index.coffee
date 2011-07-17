
path = require "path"
fs = require "fs"

cli = require 'cli'

watcher = require __dirname + "/lib/watcher"

cli.parse
  port: ['p', 'Listen on this port', "number", 1234]
  host: ['l', 'Listen to a host', 'string', '127.0.0.1']
  version: ['v', 'Show version']


showVersion = ->
  package = JSON.parse fs.readFileSync(__dirname + "/package.json").toString()
  console.log """
  Projectwatch v#{ package.version }

  #{ package.description }

  Homepage: #{ package.homepage }
  Bugs: #{ package.bugs.web }
  """

exports.run = ->
  cli.main (dirs, options) ->
    if options.version
      showVersion()
    else
      watcher.searchAndWatch dirs, options


