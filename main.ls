require! { express, 'body-parser', 'express-session': session, './twitter.ls', './options.json' }

app = express!

#app.enable 'trust proxy'

app.use session do
  resave: false
  save-uninitialized: false
  secret: \databox

app.use express.static 'static'

app.use body-parser.urlencoded extended: false

app.options \/ (req, res) !->
  res.header 'Access-Control-Allow-Origin'  \*
  res.header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS'
  res.header 'Access-Control-Allow-Headers' 'Content-Type, Authorization, Content-Length, X-Requested-With'
  res.header 'Content-Type' 'application/json'
  res.send JSON.stringify options

app.get \/status (req, res) !->
  res.header 'Access-Control-Allow-Origin' \*
  res.send if twitter.is-signed-in! then \active else \standby

app.get '/twitter/connect' twitter.connect

app.get '/twitter/callback' twitter.auth

app.get '/twitter/api/*' (req, res) !->
  err, results <-! twitter.fetch req.params[0], req.body
  if err
    res.write-head 400
    err |> JSON.stringify |> res.end
    return
  res.header 'Access-Control-Allow-Origin' \*
  results |> JSON.stringify |> res.end

app.get '/twitter/is-signed-in' (req, res) !->
  res.header 'Access-Control-Allow-Origin' \*
  res.end '' + twitter.is-signed-in!

app.listen 8080
