local table = table
local string = string
local hook = hook
local debug = debug
local math = math
local file = file
local type = type
local pairs = pairs
local pcall = pcall
local error = error
local setmetatable = setmetatable
local print = print
local MsgN = MsgN
local ErrorNoHalt = ErrorNoHalt
local IsValid = IsValid
local rawget = rawget
local rawset = rawset

module('articulate')

local drivers = {}
local connections = {}

function AvailableDrivers()
	return drivers
end

function RegisterDriver(name, className)
	drivers[name] = className
end

function Connection(driver, connectionInfo)
	assert(drivers[driver], driver .. ' must be a registered driver')
	
	try (function()
		return new (drivers[name], unpack(connectionInfo))
	end)
	catch ({
		['ArticulateMissingDriverException'] = function(err)
			
		end,
		['ArticulateConnectionErrorException'] = function(err)
			
		end
	})
end

function QueryBuilder(connection)
	return new ('ArticulateQueryBuilder', connection)
end

function ModelQueryBuilder(connection, model)
	return new ('ArticulateModelQueryBuilder', connection):setModel(model)
end