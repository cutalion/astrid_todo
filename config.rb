def config(key)
  ENV.fetch(key) { raise "Set the #{key} env variable" }
end

API_SECRET = config('ASTRID_API_SECRET')
APP_ID     = config('ASTRID_APP_ID')

USER       = config('ASTRID_USER')
PASSWORD   = config('ASTRID_PASSWORD')
