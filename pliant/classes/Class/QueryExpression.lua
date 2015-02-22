class 'ArticulateQueryExpression' is {
	
	value = nil,
	
	__construct = function(self, value)
		self.value = value
	end,
	
	__tostring = function(self)
		return tostring(self.value)
	end
	
}