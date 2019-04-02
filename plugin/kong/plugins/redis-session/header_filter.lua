local redis = require "resty.redis"

local _M = {}

function _M.execute(conf, ngx)
  local cookie = require "resty.cookie"

  local ngx_headers = ngx.req.get_headers()
  local ck = cookie:new()
  local session, err = ck:get(conf.session_key)
  ngx.log(ngx.ERR, session)
  if not session then
    ngx.log(ngx.ERR, err)
    return kong.response.exit(500, { message = "session key is required" })
  end

  local red = redis:new()
  red:set_timeout(conf.redis_timeout)
  local ok, err = red:connect(conf.redis_host, conf.redis_port)
  if not ok then
    ngx.log(ngx.ERR, "failed to connect to Redis: ", err)
      return kong.response.exit(500, { message = "server is not ready" })
  end

  if conf.redis_password and conf.redis_password ~= "" then
    local ok, err = red:auth(conf.redis_password)
    if not ok then
      ngx.log(ngx.ERR, "failed to connect to Redis: ", err)
      return kong.response.exit(500, { message = "server is not ready" })
    end
  end

  local cache_key = session
  if string.len(conf.redis_session_prefix) > 0 then
    cache_key = conf.redis_session_prefix .. ":" .. cache_key
  end
  local session_id = red:get(cache_key)
  print(session_id)
  if session_id == ngx.null then
    ngx.log(ngx.ERR, "session id is null")
    return kong.response.exit(500, { message = "session id is required" })
  end
--[[
  local jwt, err = red:hget(cache_key, conf.hash_key)
  if err then
    ngx.log(ngx.ERR, "error while fetching redis key: ", err)
    return
  end

  local authorization_header = ngx.header["Authorization"]
  print(authorization_header)
  if not authorization_header then
    ngx.req.set_header("Authorization", "Bearer " .. jwt)
  end
  ]]
end

return _M