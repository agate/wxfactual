geoCache = require('../cache')

module.exports.handle = (input, res) ->
  geoCache.cacheGeo(input.FromUserName, [input.Location_X, input.Location_Y])
  res.render 'text',
    ToUserName:   input.FromUserName
    FromUserName: input.ToUserName
    Content: 'Please select a category...'
