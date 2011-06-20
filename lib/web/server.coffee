

{exec} = require "child_process"

express = require "express"
nowjs = require("now")

{ addCodeSharingTo } = require "express-share"


app = express.createServer()

everyone = nowjs.initialize app,
  socketio:
    log: ->

app.set "views", __dirname + "/views"
console.log "DIR", __dirname

app.use express.static(__dirname + "/public")
app.set "clientscripts", __dirname + "/clientscripts"
addCodeSharingTo app
app.shareUrl "/nowjs/now.js"


watchers = {}

renderApp = (req, res) ->
  res.render "index.jade"


app.get "/", renderApp
app.get "/:name", renderApp

everyone.on "connect", ->
  ws = []
  for id, w of watchers
    ws.push
      id: id
      name: w.name
      stdout: w.stdout
      stderr: w.stderr
      stdboth: w.stdboth
      exitstatus: w.exitstatus
      cmd: w.settings.cmd
      cfgfile: "#{ w.settings.watchdir }/projectwatch.cfg"

  @now.init ws


everyone.now.manualRun = (id) ->
  watcher = watchers[id]
  watcher.onModified "", true

exports.registerWatcher = (watcher) ->


  console.log "registering", watcher.id
  watchers[watcher.id] = watcher

  watcher.on "stdout", (data) ->
    everyone.now[watcher.id]?.sendStdout(data)
  watcher.on "stderr", (data) ->
    everyone.now[watcher.id]?.sendStderr(data)
  watcher.on "stdboth", (data) ->
    everyone.now[watcher.id]?.sendStdboth(data)
  watcher.on "start", (data) ->
    everyone.now[watcher.id]?.sendReset()
  watcher.on "end", (exitstatus) ->
    everyone.now[watcher.id]?.sendExitStatus exitstatus


exports.start = (port=8080) ->
  app.listen port
  console.log  "Listening on  http://localhost:#{ port }/"

