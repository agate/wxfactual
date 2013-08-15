config = require('../config')

crypto = require('crypto')
shasum = crypto.createHash('sha1')

module.exports.validate = (signature, timestamp, nonce) ->
  strings = [ config.token, timestamp, nonce ].sort()
  preEncodeStr = strings.join('')
  shasum.update(preEncodeStr, 'utf8');

  shasum.digest('hex') == signature
