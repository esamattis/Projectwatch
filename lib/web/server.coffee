

express = require "express"
nowjs = require("now")

{ addCodeSharingTo } = require "express-share"
app = express.createServer()
addCodeSharingTo app
everyone = nowjs.initialize app

app.shareUrl "/nowjs/now.js"

app.exec ->
  now.renderOutput = (watcher) ->
    console.log "got", watcher.name
    textarea = $("##{ watcher.name }")
    if textarea.size() is 0
      textarea = $("<textarea>", id: "foo").appendTo("body")







setTimeout ->
  everyone.now.renderOutput name: "myproj:compass"
,
  2000


renderApp = (req, res) ->
  res.render "index.jade", text: "hello jade"


app.get "/", renderApp
app.get "/:name", renderApp


port = 8080

app.listen port
console.log  "Listening on  http://localhost:#{ port }/"
