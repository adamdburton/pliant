pcall(require, 'mysqloo')
pcall(require, 'tmysql4')

class 'MySQLArticulateDriver' extends 'ArticulateDriver' implements 'ArticulateDriverInterface' is {
	
	__construct = function(self, hostname, username, password, database, port, socketPath)
		
		port = port or 3306
		
		if mysqloo then
			
			local dbConnection = mysqloo.connect(hostname, username, password, database, port)
			
			function dbConnection.onConnected()
				self.connection = dbConnection
				self.connected = true
			end
			
			function dbConnection.onConnectionFailed(db, dbError)
				throw ('ArticulateConnectionError', dbError)
			end
			
			dbConnection:connect()
			dbConnection:wait()
			
		elseif tmysql
			
			local dbConnection, dbError = tmysql.initialize(hostname, username, password, databas, port, socketPath)
			
			if dbConnection then
				self.connection = dbConnection
				self.connected = true
			elseif dbError then
				throw ('ArticulateConnectionErrorException', dbError)
			end
			
		end
		
	end,
	
	query = function(self, sql, binds, successCallback, errorCallback, blocking)
		
		assert(self.connected, 'Database is not connected')
		
		sql = self:mergeBinds(sql, binds)
		local instance = self
		
		if mysqloo then
			
			local query = self.connection:query(sql)
			
			function query:onSuccess(data)
				instance.countRows = #data
				instance.affectedRows = query:affectedRows()
				instance.insertID = query:lastInsert()
				
				if successCallback then
					successCallback(data)
				end
			end
			
			function query:onError(err)
				if errorCallback then
					errorCallback(err)
				else
					throw ('ArticulateQueryErrorException', err)
				end
			end
	
			query:start()
			
			if blocking then
				query:wait()
			end
			
		else
			
			
			
		end
		
	end,
	
	escape = function(self, str)
		return (mysqloo and self.connection:escape(str)) or (tmysql and tmysql.escape(str)) -- Use escape function from database lib instead of the built in one
	end,
	
	tableExists = function(self, table)
		local data = self:query('SHOW TABLES LIKE ?', { table }, nil, nil, true)
		
		return #data == 1
	end
	
}

articulate.RegisterDriver('mysql', 'MySQLArticulateDriver')