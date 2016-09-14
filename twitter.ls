require! { flutter: Flutter }

access-token = null
secret = null

flutter = new Flutter do
  consumer-key:    \5aO0dzpWHz4tviFq68qjsyHkG
  consumer-secret: \lq6gr6n0Z8QsdeNfzw0mWam5lzckBIHTuLXrK47zDwATT83mPq
  # TODO: Remove as this might not always be supported
  login-callback: "http://#{process.env.DATABOX_IP}:8080/databox-twitter-driver/callback"
  cache: false

  auth-callback: (req, res, next) !->
    # Authentication failed, req.error contains details
    return if req.error

    access-token := req.session.oauth-access-token
    secret := req.session.oauth-access-token-secret

    # Store to file here

    res.redirect \/close

export flutter.connect
export flutter.auth

export fetch = (url, data, callback) -> flutter.API.fetch url, data, access-token, secret, callback

export is-signed-in = -> access-token? and secret?
