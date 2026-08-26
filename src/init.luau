local Middleware = {}

export type Middleware = typeof(Middleware)

export type MiddlewareFunction = (self: Middleware, context: {[string]: any}, next: () -> any) -> any

Middleware.__index = Middleware

function Middleware.new(): Middleware
	local self = setmetatable({
		_Middleware = {},
	}, Middleware)

	return self
end


function Middleware.Use(self: Middleware, callback: MiddlewareFunction)
	table.insert(self._Middleware, callback)
end

function Middleware.Execute(self: Middleware, context: {[string]: any}, final: (context: {[string]: any}) -> any)
	local index = 0

	local function Next()
		index += 1
		local middleware = self._Middleware[index]

		if middleware then
			return middleware(self, context, Next)
		end

		return final(context)
	end

	return Next()
end

function Middleware.Clear(self: Middleware)
	table.clear(self._Middleware)
end

return Middleware
