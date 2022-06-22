-- ONLY FOR USE ON SYNAPSE X --

if syn and type(syn) ~= "table" then
game:Shutdown()
end

if not syn then
game:Shutdown()
end

if syn and type(syn) == "table" then

-- < Functions > --

local cloneref = cloneref or function(ref)
return ref
end

local CoreGui = cloneref(game:GetService("CoreGui"))
local RemoteDebugWindow = CoreGui:FindFirstChild("RemoteDebugWindow", true)
if RemoteDebugWindow then
    RemoteDebugWindow.Parent:Destroy()
end

-- < Services > --	
local CoreGui = cloneref(game:GetService("CoreGui"))
local InsertService = cloneref(game:GetService("InsertService"))
-- < Aliases > --
local table_insert = table.insert
local table_foreach = table.foreach
local string_char = string.char
local getobjects = function(a)
    local Objects = {}
    if a then
        local b = InsertService:LoadLocalAsset(a)
        if b then 
            pcall(table_insert, Objects, b) 
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

local Dex = cloneref(getobjects("rbxassetid://7995973532")[1])
local SecureContainer = gethiddengui and cloneref(gethiddengui()) or gethui and cloneref(gethui()) or cloneref(CoreGui:FindFirstChildOfClass("ScreenGui") or CoreGui:FindFirstChildOfClass("Folder"))

if syn and type(syn) == "table" and syn.protect_gui then
syn.protect_gui(Dex)
syn.protect_gui(SecureContainer)
for i, v in pairs(Dex:GetDescendants()) do
syn.protect_gui(v)
end
end

if syn and type(syn) == "table" and syn.secure_gui then
syn.secure_gui(Dex)
syn.secure_gui(SecureContainer)
for i, v in pairs(Dex:GetDescendants()) do
syn.secure_gui(v)
end
end

Dex.Name = RandomCharacters(20)

Dex.Parent = SecureContainer

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
		pcall(setmetatable, Fenv, FenvMt)
		pcall(setfenv, Func, Fenv)
		return Func
	end
	local function LoadScripts(_, Script)
		if Script:IsA("LocalScript") or Script:IsA("ModuleScript") then
			task.spawn(function()
                            GiveOwnGlobals(loadstring(Script.Source,"="..Script:GetFullName()), Script)()
			end)
		end
		pcall(table_foreach, Script:GetChildren(), LoadScripts)
	end
pcall(LoadScripts, nil, Obj)
end
pcall(Load, Dex)

end
