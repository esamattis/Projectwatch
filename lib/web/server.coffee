

{exec} = require "child_process"

express = require "express"
nowjs = require("now")

{ addCodeSharingTo } = require "express-share"


app = express.createServer()

everyone = nowjs.initialize app

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
  for name, w of watchers
    ws.push
      name: name
      stdout: w.stdout
      stderr: w.stderr
      stdboth: w.stdboth
      exitstatus: w.exitstatus

  @now.init ws


everyone.now.manualRun = (name) ->
  watcher = watchers[name]
  watcher.onModified "", true

exports.registerWatcher = (watcher) ->
  watchers[watcher.name] = watcher

  watcher.on "stdout", (data) ->
    console.log "SENDING", watcher.name
    everyone.now[watcher.name]?.sendStdout(data)
  watcher.on "stderr", (data) ->
    everyone.now[watcher.name]?.sendStderr(data)
  watcher.on "stdboth", (data) ->
    everyone.now[watcher.name]?.sendStdboth(data)
  watcher.on "start", (data) ->
    everyone.now[watcher.name]?.sendReset()
  watcher.on "end", (exitstatus) ->
    everyone.now[watcher.name]?.sendExitStatus exitstatus


exports.start = (port=8080) ->
  app.listen port
  console.log  "Listening on  http://localhost:#{ port }/"

