jsdom = require('jsdom')
async = require('async')
Factual = require('factual-api')
config = require('../config')

DEFAULT_IMG = "http://www-personal.umich.edu/~bcoppola/students/no-img.jpg"
USER_AGNET = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1588.0 Safari/537.36"
CATEGORY_IDS =
  restaurant: [ 342..344 ].concat([ 346..368 ]).concat([ 457, 458 ])
  sports: [ 372..414 ]
  hotel: [ 432..438 ]
  shopping: [ 169, 171, 141, 138 ]

CN_LNG_RANGE = [ 73, 136 ]
US_LNG_RANGE = [ -130, -70 ]

factual = new Factual(config.factual.key, config.factual.secret)

# params:
#   type:
#     restaurant | sports | hotel | shopping
#   location:
#     [ lat, lng ]
module.exports.top = (params, callback) ->
  if CATEGORY_IDS[params.type]
    queries =
      limit: 5
      filters:
        category_ids:
          $includes_any: CATEGORY_IDS[params.type]
      geo:
        $circle:
          $center: params.location || [ 31.222626, 121.410896 ]
          $meters: 500

    factual.get '/t/places', queries, (error, result) ->
      if error
        callback(error, [])

      else
        async.map result.data, populateUrl, (error, data) ->
          data = data.filter (item) ->
            return !!item.url
          data = data.slice(0,3)
          callback(null, if error then [] else data)
  else
    callback('TYPE INCORRECT', [])

populateUrl = (data, callback) ->
  if data.longitude < CN_LNG_RANGE[1] && data.longitude > CN_LNG_RANGE[0]
    crosswalkUrl = '/t/4uZ1Jz'
  else
    crosswalkUrl = '/t/crosswalk'

  fetchUrl crosswalkUrl, data.factual_id, (error, url) ->
    data.url = url
    callback(error, data)

fetchUrl = (crosswalkUrl, factualId, callback) ->
  queries =
    filters:
      factual_id: factualId

  factual.get crosswalkUrl, queries, (error, result) ->
    if error
      callback error

    else
      crosswalk = result.data[0];
      crosswalk = if crosswalk then crosswalk.url else null

      callback error, crosswalk
