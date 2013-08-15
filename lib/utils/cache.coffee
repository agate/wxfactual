require('js-yaml')
async = require('async')
geo = require('./geo')

# username: {
#   timestamp: xxx
#   location: [lat, lng]
#   ready: true | false
#   data: {
#     restaurant: []
#     sports: []
#     hotel: []
#     shopping: []
#   }
# }
GEO_CACHE = {}
EXPIRE_TIME = 5 * 60 * 1000

module.exports.getGeoCache = (username) ->
  if GEO_CACHE[username]
    if (Date.now() - GEO_CACHE[username].timestamp) < EXPIRE_TIME
      return GEO_CACHE[username]
    else
      return null
  else
    return null

module.exports.cacheGeo = (username, location) ->
  GEO_CACHE[username] =
    timestamp: Date.now()
    location: location

  cacheActions =
    restaurant: (callback) ->
      geo.top { type: 'restaurant', location: location }, callback
    sports: (callback) ->
      geo.top { type: 'sports', location: location }, callback
    hotel: (callback) ->
      geo.top { type: 'hotel', location: location }, callback
    shopping: (callback) ->
      geo.top { type: 'shopping', location: location }, callback


  async.parallel cacheActions, (error, results) ->
    for k, v of results
      results[k] = v.map (item) ->
        title = "#{item.name}\n#{item.address}"
        title += ",#{item.address_extended}" if item.address_extended
        title += "\n☎ #{item.tel}" if item.tel

        Title: title
        Description: item.address
        PicUrl: item.picUrl
        Url: item.url

    console.log(error, results)
    GEO_CACHE[username]['data'] = results
    GEO_CACHE[username]['ready'] = true

module.exports.cacheGeo('foobar', [ 31.222626, 121.410896 ])
