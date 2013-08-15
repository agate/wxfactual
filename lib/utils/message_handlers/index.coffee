handlers =
  event: require('./event')
  location: require('./location')
  text: require('./text')

module.exports.handle = (input, res) ->
  handlers[input.MsgType].handle(input, res)
