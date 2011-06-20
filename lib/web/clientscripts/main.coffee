
class JQEvenEmitter
  constructor: -> @_jq = jQuery {}

  on: ->                  @_jq.bind.apply @_jq, arguments
  addListener:            JQEvenEmitter::on
  once: ->                @_jq.one.apply @_jq, arguments
  removeListener: ->      @_jq.unbind.apply @_jq, arguments
  removeAllListeners:     JQEvenEmitter::removeListener
  emit: ->                @_jq.trigger.apply @_jq, arguments


class WatcherRemote extends JQEvenEmitter

  constructor: (options) ->
    super
    @status = "ok"
    @id = options.id
    @name = options.name

    @lastUpdated = (new Date()).getTime()
    @on "update", => @lastUpdated = (new Date()).getTime()

    @active = false
    @update options

    remote = now[@id] = {}

    remote.sendStdout = (data) =>
      @stdout += data
      @emit "update"
    remote.sendStderr = (data) =>
      @stderr += data
      @emit "update"
    remote.sendStdboth = (data) =>
      @stdboth += data
      @emit "update"

    remote.sendReset = =>
      @reset()
      @emit "update"

    remote.sendExitStatus = (exitstatus) =>
      # Emits update
      console.log "Got exitstatus from server", exitstatus
      @setStatus exitstatus


  setStatus: (exitstatus) ->
      # Blueprint classes
      if exitstatus is 0
        @status = "success"
      else
        @status = "error"
      @emit "update"

  reset: ->
    @stdout = ""
    @stderr = ""
    @stdboth = ""

  update: (data) ->
    @stdout = data.stdout
    @stderr = data.stderr
    @stdboth = data.stdboth
    # This will emit update
    @setStatus data.exitstatus

class WatcherView

  constructor: (settings)  ->
    @model = settings.model
    @el = settings.el

    @template = Handlebars.compile $("#watcher").html()

    @model.on "update", =>
      @render()

    setInterval =>
      diff = (new Date).getTime() - @model.lastUpdated
      diff /= 1000
      timer = @el.find(".timer")
      if diff < 60 * 60
        timer.text " Last updated #{ Math.round diff } seconds ago"
      else
        timer.text ""
    , 1000

  render: ->
    @el.html @template @model

    @button = new RerunButton
      el: @el.find("button")
      watcher: @

  show: ->
    @model.active = true
    @render()
    @el.get(0).scrollIntoView(true)
  hide: ->
    @model.active = false
    @render()




class WatcherManager

  constructor: ->
    @notifies = new Notifies el: $("title")
    @watchers = {}

  createWatcher: (options) ->
    if not @watchers[options.id]?
      model = new WatcherRemote options
      w = @watchers[options.id] = new WatcherView
        model: model
        el: $("<div>").appendTo("body")
      @notifies.add model
    else
      w = @watchers[options.id]
      w.model.update options

    w.render()


class RerunButton

  constructor: (ops) ->
    @el = ops.el
    @watcher = ops.watcher
    @el.click =>
      now.manualRun @watcher.model.id
      false


class Notifies

  constructor: (ops) ->
    @el = ops.el
    @models = []

  add: (model) ->
    @models.push model
    model.on "update", => @setNotify()

  setNotify: ->
    for model in @models
      if model.status is "error"
        @el.text "ERROR - Projectwatch"
        return
    @el.text "OK - Projectwatch"

manager = new WatcherManager


now.init = (watchers, cb) ->
  $ ->
    for w in watchers
      manager.createWatcher w

    activateWatcherByHash = ->
      id = window.location.hash.substring(1)
      for k, w of manager.watchers

        if w.model.id is id
          w.show()
        else
          w.hide()

    $(window).bind "hashchange", activateWatcherByHash
    activateWatcherByHash()






