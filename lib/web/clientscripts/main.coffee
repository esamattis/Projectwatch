
class JQEvenEmitter
  constructor: -> @_jq = jQuery {}

  on: ->                  @_jq.bind.apply @_jq, arguments
  addListener:            JQEvenEmitter::on
  once: ->                @_jq.one.apply @_jq, arguments
  removeListener: ->      @_jq.unbind.apply @_jq, arguments
  removeAllListeners:     JQEvenEmitter::removeListener
  emit: ->                @_jq.trigger.apply @_jq, arguments



class WatcherOuput

  constructor: (@name, @el)  ->
    remote = now[@name] = {}
    remote.sendStdout =  => @pushStdout.apply @, arguments
    remote.sendStderr =  => @pushStderr.apply @, arguments
    remote.reset = => @reset()

  setExitStatus: ->
    @title.css "color", "red"

  pushStdout: (data) ->
    @stdout.text @stdout.text() + data

  pushStderr: (data) ->
    @stderr.text @stderr.text() + data

  reset: ->
    @stdout.text ""
    @stderr.text ""

  render: ->
    @title = @el.append("<h2>#{ @name }</h2>")
    for type in ["stdout", "stderr"]
      id = "#{ type }-#{ @name }"
      @[type] = $("#" + id)
      if @[type].size() is 0
        @["#{ type }Title"] = @el.append("<h3>#{ type }</h3>")
        @[type] = $("<textarea>", id: id).appendTo @el


$ ->
  w = new WatcherOuput "myproj:compass", $("body")
  w.render()

