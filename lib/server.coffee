express = require('express')
config = require('./config')

app = express()
app.configure =>
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', "jade"
  app.use express.logger('dev')
  app.use express.responseTime()
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.compress()
  app.use app.router
  app.use express.errorHandler,
    dumpExceptions: true
    showStack: true

app.get  '/', (req, res) ->
  require('./controllers/auth').handle(req, res)

app.post '/', (req, res) ->
  require('./controllers/message').handle(req, res)

app.listen(config.port);
console.log "server started @ port: #{config.port}"
