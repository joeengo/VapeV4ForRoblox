local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or getgenv().request or request
local getasset = getsynasset or getcustomasset
function getAllPlaceIds() 
    local tableT = {}
    local pages = game:GetService("AssetService"):GetGamePlacesAsync()
    while true do
         for _,place in pairs(pages:GetCurrentPage()) do
              print("Name: " .. place.Name)
              print("PlaceId: " .. tostring(place.PlaceId))
              table.insert(tableT, place.PlaceId)
         end
         if pages.IsFinished then
              break
         end
         pages:AdvanceToNextPageAsync()
    end
    return tableT
end


makefolder("vape")
makefolder("vape/CustomModules")

checkpublicrepo = function(id)
    if isfile("vape/CustomModules/"..id..".vape") then
        return readfile("vape/CustomModules/"..id..".vape")
    end
	local suc, req = pcall(function() return requestfunc({
		Url = "https://raw.githubusercontent.com/joeengo/VapeV4ForRoblox/main/CustomModules/"..id..".vape",
		Method = "GET"
	}) end)
	if req.StatusCode == 200 then
		return req.Body
	end
	return nil
end

for _, placeid in pairs(getAllPlaceIds()) do
    local publicrepo = checkpublicrepo(placeid)
    if publicrepo then
        if not isfile("vape/CustomModules/"..tostring(placeid)..".vape") then
            writefile("vape/CustomModules/"..tostring(placeid)..".vape", "loadstring(game:HttpGet('https://raw.githubusercontent.com/joeengo/VapeV4ForRoblox/main/CustomModules/"..placeid..".vape'))()")
        end
    end
end
loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/NewMainScript.lua", true))()
