sign = require('../utils/sign')

module.exports.handle = (req, res) ->
  query = req.query
  if sign.validate(query.signature, query.timestamp, query.nonce)
    res.send query.echostr
  else
    res.send "ERROR"
