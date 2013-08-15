geo = require('../geo')

module.exports.handle = (input, res) ->
  params = { type: input.Content }

  geo.top params, (error, results) ->
    if error
      res.render 'text',
        Content: "Got Error:\n#{error}"

    else
      params =
        ToUserName: inputJson.FromUserName
        FromUserName: inputJson.ToUserName
        Articles: results.map (result) ->
          title = "#{result.name}\n#{result.address}"
          title += ",#{result.address_extended}" if result.address_extended
          title += "\n☎ #{result.tel}" if result.tel

          Title: title
          Description: result.address
          PicUrl: result.picUrl
          Url: result.url
      res.render 'news', params

    console.log(res.body)
    res.end()
