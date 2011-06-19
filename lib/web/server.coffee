

{exec} = require "child_process"

express = require "express"
nowjs = require("now")

{ addCodeSharingTo } = require "express-share"
app = express.createServer()
addCodeSharingTo app
everyone = nowjs.initialize app

app.shareUrl "/nowjs/now.js"





i = 1

renderApp = (req, res) ->
  res.render "index.jade", text: "hello jade"
  name = "myproj:compass"

  cmd = exec "slow"

  cmd.stdout.on "data", (data) -> process.stdout.write(data)
  cmd.stdout.on "data", (data) ->
    everyone.now[name].sendStdout(data)



app.get "/", renderApp
app.get "/:name", renderApp


port = 8080

app.listen port
console.log  "Listening on  http://localhost:#{ port }/"
