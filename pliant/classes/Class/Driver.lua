class 'PliantDriver' is {
	
	connection = nil,
	connected = false,
	
	countRows = 0,
	affectedRows = 0,
	insertID = 0,
	
	mergeBinds = function(self, sql, binds)
		for k, v in pairs(binds) do
			if type(v) == 'number' then
				sql:gsub('?', v, 1) -- Normal number
			elseif type(v) == 'string' then
				sql:gsub('?', self:escape(v), 1) -- Normal string
			elseif type(v) == 'table' and v.__className and v.__className == 'PliantQueryExpression' then
				sql:gsub('?', tostring(v), 1) -- Pliant Expression
			elseif type(v) == 'table' then
				for a, b in pairs(v) do
					if type(v) == 'table' then
						throw ('PliantInvalidBindException', type(v) .. ' is not allowed in an IN() statement')
					end
				end
				
				sql:gsub('?', self.mergeBinds('IN(' .. (string.rep('?, ', #v)):sub(1, -3) .. ')', v)) -- Table passed, lets concat them as an IN(), passing them back through this function!
			else
				throw ('PliantInvalidBindException', type(v) .. ' is an invalid bind type')
			end
		end
	end,
	
	getRowCount = function(self)
		return self.countRows
	end,
	
	getAffectedRows = function(self)
		return self.affectedRows
	end,
	
	getLastInsertID = function(self)
		return self.insertID
	end,
	
	table = function(self, table)
		return new ('PliantQueryBuilder', self):setTable(table)
	end
}