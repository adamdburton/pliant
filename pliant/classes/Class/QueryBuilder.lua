class 'ArticulateQueryBuilder' is {
	
	connection = nil,
	
	table = '',
	type = 'SELECT',
	
	selects = {},
	joins = {},
	wheres = {},
	orderBys = {},
	groupBys = {},
	
	__construct = function(self, connection)
		self.connection = connection
	end,
		
	setTable = function(self, table)
		self.table = table
		
		return self
	end,
	
	select = function(self, ...)
		self.type = 'SELECT'
		
		for k, v in pairs({ ... }) do
			table.insert(self.selects, v)
		end
	end,
	
	with = function(self, ...)
		
		
		return self	
	end,
	
	join = function(self, table, one, operator, two, type, where)
		if type(one) == 'function' then
			local join = new ('ArticulateJoinClause', self, type, table)
			one(join)
			
			table.insert(self.joins, join)
		else
			local join = new ('ArticulateJoinClause', self, type, table)
			join:on(one, operator, two, 'and', where)
			
			table.insert(self.joins, join)
		end
	end,
	
	where = function(self, column, operator, value, boolean)
		if not boolean then boolean = 'and' end
		
		if type(column) == 'function' then
			local query = self.model:newQuery()
			
			column(query)
		else
			table.insert(self.wheres, { columns = column, operator = operator, value = value, boolean = boolean })
		end
		
		return self
	end,
	
	get = function()
		local sql = self.type
		
		local compacts = { 'selects', 'joins', 'wheres', 'orderBys', 'groupBys' }
		
		for _, t in pairs(compacts) do
			for _, v in pairs(self[t]) do
				sql = sql .. ' ' .. tostring(v)
			end
		end
		
		return self.connection:query(sql, binds)
	end,
	
	count = function(self, column)
		self.selects = {} -- Reset selects, we only want the aggregate
		
		return self:select('COUNT(' .. tostring(column or '*') .. ') AS aggregate'):get():first().aggregate
	end,
	
	sum = function(self, column)
		self.selects = {}
		
		return self:select('SUM(' .. tostring(column or '*') .. ') AS aggregate'):get():first().aggregate
	end,
	
	average = function(self, column)
		self.selects = {}
		
		return self:select('AVERAGE(' .. tostring(column or '*') .. ') AS aggregate'):get():first().aggregate
	end,

	max = function(self, column)
		self.selects = {}
	
		return self:select('MAX(' .. tostring(column or '*') .. ') AS aggregate'):get():first().aggregate
	end,

	min = function(self, column)
		self.selects = {}
	
		return self:select('MIN(' .. tostring(column or '*') .. ') AS aggregate'):get():first().aggregate
	end
}