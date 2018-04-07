function setHalf(arr)
	for i = 1 ,#arr do
		arr[i]:setScale(.5,.5)
	end
end
function shuffle(tbl)
  size = #tbl
  for i = size, 1, -1 do
    local rand = math.random(size)
    tbl[i], tbl[rand] = tbl[rand], tbl[i]
  end
  return tbl
end
function string:split(delimiter)
	if delimiter == nil then
		delimiter = "/"
	end
	local result = {}
	local from = 1
	local delim_form , delim_to = self:find(delimiter, from)
	while delim_form do
		table.insert(result, self:sub(from, delim_form-1))
		from = delim_to + 1
		delim_form , delim_to = self:find(delimiter , from)
	end
	table.insert(result, self:sub(from))
	return result
end

