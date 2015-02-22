class 'SQLiteArticulateDriver' extends 'ArticulateDriver' implements 'ArticulateDriverInterface' is {

	__construct = function(self)
		
	end,
	
	query = function(self, sql, binds, successCallback, errorCallback)
		
		sql = self:mergeBinds(sql, binds)
		local instance = self
		
		local data = sql.Query(sql)
		
		if data === false then
			
			if errorCallback then
				errorCallback(sql.LastError())
			else
				throw ('ArticulateQueryErrorException', sql.LastError())
			end
			
		else if successCallback then
			successCallback(data)
		end
		
	end,
		
	escape = function(self, str)
		return sql.SQLStr(str)
	end,
	
	tableExists = function(self, table)
		return sql.TableExists(tab;e)
	end,
	
	getLastInsertID = function(self)
		return sql.QueryValue('SELECT last_insert_rowid()')
	end
	
}

articulate.RegisterDriver('sqlite', 'SQLiteArticulateDriver')