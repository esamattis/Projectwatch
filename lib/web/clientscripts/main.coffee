
class JQEvenEmitter
  constructor: -> @_jq = jQuery {}

  on: ->                  @_jq.bind.apply @_jq, arguments
  addListener:            JQEvenEmitter::on
  once: ->                @_jq.one.apply @_jq, arguments
  removeListener: ->      @_jq.unbind.apply @_jq, arguments
  removeAllListeners:     JQEvenEmitter::removeListener
  emit: ->                @_jq.trigger.apply @_jq, arguments



i = 0
class Watcher extends JQEvenEmitter

  constructor: ->
    super
    @i = i += 1
    console.log "building"

    @on "some", => @mymethod()

  mymethod: ->
    console.log "got some #{ @i }"




w = new Watcher
w.emit "some"

w2 = new Watcher
w2.emit "some"
w2.emit "some"
