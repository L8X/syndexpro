task.spawn(function()
getgenv().Services = setmetatable({},{__index=function(s,r) return game:service(r) end})

getgenv().Protector = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/pamlib/prote.lua/ca01e9b8b3478762370d4a1d1ee65bae6ee881a3/main.lua"))

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

-- < Functions > --
function gethui()
return game:GetService("CoreGui") 
end


getgenv().yeetdex = function yeetdex()
local CoreGui = game:GetService("CoreGui")
local RemoteDebugWindow = CoreGui:FindFirstChild("RemoteDebugWindow", true)
if RemoteDebugWindow then
    RemoteDebugWindow.Parent:Destroy()
end end

-- < Services > --	
local InsertService = Services.InsertService
local CoreGui = gethui()
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


local HTTPService = Services.HttpService
local CoreGui     = gethui()
local ScriptContext = Services.ScriptContext
local RandomObject = CoreGui:FindFirstChildOfClass("ScreenGui")
local RandomObject2 = RandomObject

local Dex = getobjects("rbxassetid://7063643267")[1]
Dex.Name = RandomCharacters(Random_Instance:NextInteger(5,20))
syn.protect_gui(Dex)

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
sethiddenproperty(Dex, "OnTopOfCoreBlur", true)
Load(Dex)
syn.protect_gui(Dex)
Protector():ProtectInstance(RandomObject)
Dex.Parent = RandomObject
Protector():ProtectInstance(Dex)
end)
