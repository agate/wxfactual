MessageHandler = require('../utils/message_handlers')
xmlParser = require('xml2js')

collapseArrayInJson = (input) ->
  for key, value of input
    input[key] = value[0]

  return input

module.exports.handle = (req, res) ->
  data = ''

  req.setEncoding('UTF-8')

  req.on 'data', (chunk) ->
    data += chunk

  req.on 'end', ->
    console.log("------------ POST @ #{new Date()} ------------")
    console.log(data)
    console.log("------------------------------------------------------------------------")

    xmlParser.parseString data, (error, result) ->
      input = collapseArrayInJson(result['xml'])
      MessageHandler.handle input, res
