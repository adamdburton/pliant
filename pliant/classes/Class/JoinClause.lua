class 'ArticulateJoinClause' is {

	builder = nil,
	type = nil,
	table = nil,
	clauses = {},
	
	__construct = function(self, builder, type, table)
		self.type = type
		self.builder = builder
		self.table = table
	end,
	
	on = function(self, first, operator, second, boolean)
		table.insert(self.clauses, { first = first, operator = operator, second = second, boolean = boolean or 'and' })
		
		return self
	end,
		
	orOn = function(first, operator, second)
		return self:on(first, operator, second, 'or')
	end,
	
	where = function(first, operator, second, boolean)
		return self:on(first, operator, second, boolean or 'and', true);
	end,
	
	orWhere = function(first, operator, second)
		return self:on(first, operator, second, 'or', true)
	end,
	
	whereNull = function(column, boolean)
		return self:on(column, 'is', new ('ArticulateQueryExpression', 'null'), boolean or 'and', false)
	end

}
