interface 'ArticulateDriverInterface' {
	
	connection = nil,
	connected = false,
	
	affectedRows = 0,
	insertID = 0,
	
	__construct = function(self) end,
	query = function(self, sql, binds, successCallback, errorCallback, blocking) end,
	escape = function(self, str) end,
	
	tableExists = function(self, table) end,
	
	getLastInsertID = function(self) end,
	getAffectedRows = function(self) end,
	getRowCount = function(self) end
	
}