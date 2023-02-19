--
-- logger.lua
--

local logger = { _version = "0.1.0" }

logger.modes = {
  { name = "trace",   color = "\27[34m", depth = 4},
  { name = "debug",   color = "\27[36m", depth = 3},
  { name = "info",    color = "\27[32m", depth = 2},
  { name = "success", color = "\27[35m", depth = 2},
  { name = "warning", color = "\27[33m", depth = 2},
  { name = "error",   color = "\27[31m", depth = 1},
  { name = "fatal",   color = "\27[35m", depth = 0},
}

logger.depth  = 4
logger.output = "console" -- other option is "file"
logger.file   = "log"     -- in case of writing into a file

-- helping functions ---

local _obj_to_string
local _tbl_to_string
local _arg_to_string
local _msg_to_string
local _get_info

_obj_to_string = function(x)
	if type(x) == 'table' then
		return _tbl_to_string(x)
	else
		return tostring(x)
	end
end

_tbl_to_string = function(tbl)
	result = ''
	for k, v in pairs(tbl) do
		result = result .. ', ' .. '[' .. _obj_to_string(k) .. '] = ' ..  _obj_to_string(v)
	end
	result = '{' .. result:sub(3) .. '}'
	return result
end

_arg_to_string = function(...)
	args = {...}
	return _obj_to_string({...})
end

_msg_to_string = function(...)
	args   = {...}
	result = ''
	for _, x in pairs(args) do
		result = result .. ' ' ..  _obj_to_string(x)
	end
	return result
end

_get_info = function(dlevel)
	local dlevel = dlevel or 3
	return debug.getinfo(dlevel, "Sl").short_src .. ":" .. debug.getinfo(dlevel, "Sl").currentline
end


logger._args = _arg_to_string
logger._msg  = _msg_to_string
logger._info = _get_info


-- logger writers --

logger._write_console = function(name, message, info, color)
	print(string.format("%s[%-8s%s]%s %s: %s", color, name, os.date("%H:%M:%S"), "\27[0m", info, message))
end

logger._write_file = function(name, message, info, color, filename)
	fp = io.open(logger.file, "a")
	fp:write(string.format("[%-8s%s] %s: %s\n", name, os.date(), info, message))
	fp:close()
end

logger._write = function(...)
	if logger.output == "console" then
		logger._write_console(...)
	elseif logger.output == "file" then
		logger._write_file(..., logger.file)
	end
end


for _, md in ipairs(logger.modes) do
	logger[md.name] = function(...)
		if md.depth <= logger.depth then
			logger._write(md.name:upper(), logger._msg(...), logger._info(), md.color)
		end
	end
end

-- log-on-call wrapper --
logger.call = {}
for _, md in ipairs(logger.modes) do
	logger.call[md.name] = function(func)
		return (function(...)
			logger._write(md.name:upper(), logger._msg("Registered function call; args = ", logger._args(...)), logger._info(), md.color)
			return func(...)
		end)
	end
end

return logger
