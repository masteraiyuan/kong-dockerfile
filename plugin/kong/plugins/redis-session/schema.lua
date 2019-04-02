local redis = require "resty.redis"

return {
    fields = {
        session_key = { type = "string", default="SESSION" },
        redis_session_prefix = { type = "string", default = "" },
        redis_host = { type = "string" },
        redis_port = { type = "number", default = 6379 },
        redis_password = { type = "string" },
        redis_timeout = { type = "number", default = 2000 },
        hash_key = { type = "string", default="JWT" },
    },
    
    self_check = function(schema, plugin_t, dao, is_updating)
        if not plugin_t.redis_host then
          return false, string.format "You need to specify a Redis host"
        elseif not plugin_t.redis_port then
          return false, string.format "You need to specify a Redis port"
        elseif not plugin_t.redis_timeout then
          return false, string.format "You need to specify a Redis timeout"
        end

        kong.log('before redis new');

        local red = redis:new()
        kong.log('after redis new');
        red:set_timeout(plugin_t.redis_timeout)
        kong.log('after redis set timeout');
        local ok, err = red:connect(plugin_t.redis_host, plugin_t.redis_port)
        if not ok then
          kong.log('redis host err', err);
          return false, string.format "Redis Host unreachable: " .. err
        end

        kong.log('before redis conn pwd');
        if plugin_t.redis_password and plugin_t.redis_password ~= "" then
          local ok, err = red:auth(plugin_t.redis_password)
          if not ok then
              kong.log('redis auth err ', err);
              return false, string.format "Redis Invalid Credentials: " .. err
          end
        end

        return true
    end
    
}