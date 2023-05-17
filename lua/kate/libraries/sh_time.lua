TIME_SECOND = 1
TIME_MINUTE = TIME_SECOND * 60
TIME_HOUR = TIME_MINUTE * 60
TIME_DAY = TIME_HOUR * 24
TIME_WEEK = TIME_DAY * 7
TIME_MONTH = TIME_DAY * (365.2425 / 12)
TIME_YEAR = TIME_DAY * 365.2425

local function plural(a, n)
	return n == 1 and a or a .. "s"
end

--[[
	From seconds
]]

function kate.ConvertTime(num, limit)
	num = tonumber(num)
	if num == 0 or num == nil then
		return "∞"
	end

	local ret = {}
	while not limit or limit ~= 0 do
		local templimit = limit or 0
		if num >= TIME_YEAR or templimit <= -7 then
			local c = math.floor(num / TIME_YEAR)
			ret[#ret + 1] = c .. " " .. plural("year", c)
			num = num - TIME_YEAR * c
		elseif num >= TIME_MONTH or templimit <= -6 then
			local c = math.floor(num / TIME_MONTH)
			ret[#ret + 1] = c .. " " .. plural("month", c)
			num = num - TIME_MONTH * c
		elseif num >= TIME_WEEK or templimit <= -5 then
			local c = math.floor(num / TIME_WEEK)
			ret[#ret + 1] = c .. " " .. plural("week", c)
			num = num - TIME_WEEK * c
		elseif num >= TIME_DAY or templimit <= -4 then
			local c = math.floor(num / TIME_DAY)
			ret[#ret + 1] = c .. " " .. plural("day", c)
			num = num - TIME_DAY * c
		elseif num >= TIME_HOUR or templimit <= -3 then
			local c = math.floor(num / TIME_HOUR)
			ret[#ret + 1] = c .. " " .. plural("hour", c)
			num = num - TIME_HOUR * c
		elseif num >= TIME_MINUTE or templimit <= -2 then
			local c = math.floor(num / TIME_MINUTE)
			ret[#ret + 1] = c .. " " .. plural("minute", c)
			num = num - TIME_MINUTE * c
		elseif num >= TIME_SECOND or templimit <= -1 then
			local c = math.floor(num / TIME_SECOND)
			ret[#ret + 1] = c .. " " .. plural("second", c)
			num = num - TIME_SECOND * c
		else
			break
		end

		if limit then
			if limit > 0 then
				limit = limit - 1
			else
				limit = limit + 1
			end
		end
	end

	local str = ""
	for i = 1, #ret do
		if i == 1 then
			str = str .. ret[i]
		elseif i == #ret then
			str = str .. " and " .. ret[i]
		else
			str = str .. ", " .. ret[i]
		end
	end

	return str
end

--[[
	To seconds
]]

local units = {
	s = TIME_SECOND,
	mi = TIME_MINUTE,
	h = TIME_HOUR,
	d = TIME_DAY,
	w = TIME_WEEK,
	mo = TIME_MONTH,
	y = TIME_YEAR
}

function kate.FormatTime(time)
	time = tostring(time):lower()
	if time == "0" then
		return true, 0
	end

	local s = 0
	for u, t in time:gmatch("(%d+)(%a+)") do
		if units[t] then
			s = s + u * units[t]
		else
			return false
		end
	end

	if s == 0 then
		return false
	end

	return true, s
end