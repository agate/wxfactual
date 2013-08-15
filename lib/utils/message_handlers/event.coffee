geoCache = require ('../cache')

module.exports.handle = (input, res) ->
  if input.Event == 'CLICK'
    switch input.EventKey
      when 'V1_GEO_RESTAURANT'
        renderResponse res, input, 'restaurant'
      when 'V1_GEO_SPORTS'
        renderResponse res, input, 'sports'
      when 'V1_GEO_HOTEL'
        renderResponse res, input, 'hotel'
      when 'V1_GEO_SHOPPING'
        renderResponse res, input, 'shopping'
      when 'V1_HELP'
        res.render 'text',
          ToUserName:   input.FromUserName
          FromUserName: input.ToUserName
          Content: 'Send your position to us and select the type in the menu we will tell you the POI around you.'
      when 'V1_ABOUT'
        res.render 'text',
          ToUserName:   input.FromUserName
          FromUserName: input.ToUserName
          Content: 'Factual Hackathon Project @ 2013'
      else

renderResponse = (res, input, category) ->
  userCache = geoCache.getGeoCache(input.FromUserName)
  if userCache and userCache.ready
    res.render 'news',
      ToUserName:   input.FromUserName
      FromUserName: input.ToUserName
      Articles:     userCache.data[category]
  else if userCache and !userCache.ready
    console.log(userCache)
    res.render 'text',
      ToUserName:   input.FromUserName
      FromUserName: input.ToUserName
      Content: "We are finding #{category} for you..."
  else
    res.render 'text',
      ToUserName:   input.FromUserName
      FromUserName: input.ToUserName
      Content: 'Please send me your location...'
