--Redesigned By TS#3462
local deltas = {
	vector2(-1, -1),
	vector2(-1, 0),
	vector2(-1, 1),
	vector2(0, -1),
	vector2(1, -1),
	vector2(1, 0),
	vector2(1, 1),
	vector2(0, 1),
}
local bitShift = 2
local zoneRadius = 128

function GetGridChunk(x)
	return math.floor((x + 8192) / zoneRadius)
end

function GetGridBase(x)
	return (x * zoneRadius) - 8192
end

function GetChunkId(v)
	return v.x << bitShift | v.y
end

function GetMaxChunkId()
	return zoneRadius << bitShift
end

function GetCurrentChunk(pos)
	local chunk = vector2(GetGridChunk(pos.x), GetGridChunk(pos.y)) --Redesigned By TS#3462
	local chunkId = GetChunkId(chunk)

	return chunkId
end

function GetNearbyChunks(pos)
    local nearbyChunksList = {}
	local nearbyChunks = {}
	
    for i = 1, #deltas do 
        local chunkSize = pos.xy + (deltas[i] * 20) 
        local chunk = vector2(GetGridChunk(chunkSize.x), GetGridChunk(chunkSize.y)) 
        local chunkId = GetChunkId(chunk) 

		if not nearbyChunksList[chunkId] then		
			nearbyChunks[#nearbyChunks + 1] = chunkId
			nearbyChunksList[chunkId] = true
		end
    end

    return nearbyChunks
end
--Redesigned By TS#3462