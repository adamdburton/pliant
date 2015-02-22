class 'ArticulateDriver' is {
	
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
			elseif type(v) == 'table' and v.__className and v.__className == 'ArticulateExpression' then
				sql:gsub('?', tostring(v), 1) -- Articulate Expression
			elseif type(v) == 'table' then
				sql:gsub('?', self.mergeBinds('IN(' .. (string.rep('?, ', #v)):sub(1, -3) .. ')', v)) -- Table passed, lets concat them as an IN(), passing them back through this function!
			else
				throw ('ArticulateInvalidBindException', type(v) .. ' is an invalid bind type')
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
	end
}