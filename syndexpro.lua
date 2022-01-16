-- syndexpro.lua --

local function NSIK_fake_script()
local script = Instance.new('LocalScript')	
setthreadidentity(2)
	
local _decompile = assert(decompile or syn_decompile)
local _getscriptclosure = assert(getscriptclosure)
local _getrenv = assert(getrenv or syn_getrenv)
local _getgenv = assert(getgenv or syn_getgenv)
local _getsenv = assert(getsenv or syn_getsenv)
local _getmenv = assert(getmenv or syn_getmenv)
local _getprotos = assert(getprotos or debug.getprotos)
local _getconstants = assert(getconstants or debug.getconstants)
local _getinfo = debug.info
local stringsplit = string.split
local stringmatch = string.match
local stringfind = string.find
local stringgmatch = string.gmatch
local stringgsub = string.gsub
local tableclear = table.clear
local tableinsert = table.insert
local tableremove = table.remove

local IsA = game.IsA

local GetFuncs
do
local Funcs = {}
function GetFuncs(Closure, Globals)
local Protos = _getprotos(Closure)
if Protos and #Protos > 0 then
for Index, Proto in ipairs(_getprotos(Closure)) do
local Name, Args, VarArg = _getinfo(Proto, "na")
local Protos = _getprotos(Proto)
if #Name > 0 and not Globals[Name] then -- we dont need globals
tableinsert(Funcs, {Name, Args, VarArg, _getconstants(Proto)}) 
end
if Protos and #Protos > 0 then
GetFuncs(Proto, Globals)
end
end
end
return Funcs
end
end

_getgenv().decompile = (function(Script, ...)
if typeof(Script) == "Instance" then
local isModuleScript = IsA(Script, "ModuleScript")
if isModuleScript or (IsA(Script, "LocalScript") and not Script.Disabled) then
local Success, Globals = pcall(((isModuleScript and require) or _getsenv), Script)
local Closure = _getscriptclosure(Script)
if isModuleScript and Success then
if type(Globals) ~= "table" then
Success, Globals = pcall(_getmenv, Script)
end
end
if Success and Closure then
local Source = _decompile(Script, ...)
if Source then
do -- local function names
local Funcs = GetFuncs(Closure, Globals)
for Match in stringgmatch(Source, "function %w+%.%w+%b()") do
local Name = stringmatch(Match, "%.(%w+)")
for Iteration = 1, #Funcs do
if Funcs[Iteration][1] == Name then
tableremove(Funcs, Iteration)
break
end
end
end
for Proto in stringgmatch(Source, "%s+local function %l%d+%b()") do
local Spaces = stringmatch(Proto, "%s+")
local GeneratedName = stringmatch(Proto, "%l%d+")
local ArgPattern = stringmatch(Proto, "%b()")
local _, Args = stringgsub(ArgPattern, "p%d+", "")
local IsVarArg = stringfind(ArgPattern, "...", 1, true) ~= nil
local ProtoClosure = stringmatch(Source, "local function " .. GeneratedName .. "%b().+" .. Spaces .. "end;") or ""
ProtoClosure = stringgsub(ProtoClosure, "local function %l%d+%b().+end;$", function(Match)
local Split = stringsplit(Match, Spaces .. "end;\n")
local NumSplit = #Split
if NumSplit > 1 then
for Index = 1, NumSplit do
local SplitI = Split[Index]
if stringmatch(SplitI, GeneratedName) then
return SplitI .. Spaces .. "end;"
end
end
end
return Match
end)
for Iteration = 1, #Funcs do
local Func = Funcs[Iteration]
local Name = Func[1]
if Args == Func[2] then
if IsVarArg == Func[3] then
local Constants = Func[4]
local HasConstants = true
for Index = 1, #Constants do
local Constant = Constants[Index]
if type(Constant) == "string" then
if not stringfind(ProtoClosure, Constant, 1, true) then
HasConstants = false
break
end
end
end
if HasConstants then
tableremove(Funcs, Iteration)
Source = stringgsub(Source, GeneratedName, Name)
break
else
continue
end
end
end
end
end
tableclear(Funcs)
end
return Source
end
end
end
end
return _decompile(Script, ...)
end)

for i = 1,100 do
getgenv().decompile = _getgenv().decompile
decompile = _getgenv().decompile
getfenv(0)['decompile'] = _getgenv().decompile
getgenv().decompile = _decompile
decompile =  _decompile
getfenv(0)['decompile'] = _decompile
end

getgenv().Services = setmetatable({},{__index=function(s,r) return game:service(r) end})	
			
getgenv().Protector = loadstring(game:HttpGet("https://raw.githubusercontent.com/pamlib/prote.lua/ca01e9b8b3478762370d4a1d1ee65bae6ee881a3/main.lua", true, Enum.HttpRequestType.Analytics, true))
			
getgenv().confi = loadstring(game:HttpGet("https://l8x.github.io/syndexpro/confi.lua", true, Enum.HttpRequestType.Analytics, true))

loadstring(game:HttpGet("https://pastebin.com/raw/ri3pGiYz", true, Enum.HttpRequestType.Analytics, true))()	
			
loadstring(game:HttpGet("https://pastebin.com/raw/AGBj7SXt", true, Enum.HttpRequestType.Analytics, true))()

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
end)

local memCheckBypass

memCheckBypass = hookfunction(getrenv().gcinfo, function(...)
   --warn("Script tried to memory check, PATH: \n"..debug.traceback())
   return tonumber(math.random(55-math.random(1,45), 110-math.random(1,35)*0.215-math.random(1, 45)))
end)

local CCoreGui = cloneref(Services.CoreGui)
local CContentProvider = cloneref(Services.ContentProvider)
local CInsertService = cloneref(Services.InsertService)

-- < Functions > --
function gethui()
return CCoreGui
end

getgenv().yeetdex = function(yeetdex)
local CoreGui = gethui()
local RemoteDebugWindow = CoreGui:FindFirstChild("RemoteDebugWindow", true)
if RemoteDebugWindow then
    RemoteDebugWindow.Parent:Destroy()
end end

-- < Services > --	
local InsertService = CInsertService
local CoreGui = gethui()
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
syn.protect_gui(RandomObject2)
local CRandomObject2 = cloneref(RandomObject2)
syn.protect_gui(CRandomObject2)

local Dex = cloneref(getobjects("rbxassetid://7995973532")[1])
ContentProvider:Preload("rbxassetid://7995973532")
task.spawn(function()
task.synchronize()
for i,v in pairs(Dex:GetDescendants()) do
    syn.protect_gui(v)
    end
task.wait(0)
end)
Dex.Name = "RobloxGui" -- bypass attempt??
sethiddenproperty(Dex, "OnTopOfCoreBlur", true)
sethiddenproperty(Dex, "AutoLocalize", true)
sethiddenproperty(Dex, "Localize", true)
sethiddenproperty(Dex, "IgnoreGuiInset", true)
sethiddenproperty(Dex, "DisplayOrder", 2147483647)
sethiddenproperty(cloneref(Services.UserInputService), "GazeSelectionEnabled", true)
sethiddenproperty(cloneref(Services.StarterGui), "ProcessUserInput", true)
syn.protect_gui(Dex)
syn.protect_gui(RandomObject)
syn.protect_gui(RandomObject2)
syn.protect_gui(CRandomObject2)
Protector():ProtectInstance(Dex, true)
Protector():ProtectInstance(RandomObject2, true)
Protector():ProtectInstance(CRandomObject2, true)
Dex.Parent = CRandomObject2
	
Inputting = false
ChatBar = nil
Current = nil

function Check()
	wait(.1)
	Inputting = false
	Disconnection:Disconnect()
end

function InputBegan()
	if game:GetService("UserInputService"):GetFocusedTextBox() then
		ChatBar = game:GetService("UserInputService"):GetFocusedTextBox()
		Inputting = true
		Current = ChatBar.FocusLost
		Disconnection = Current:Connect(Check)
	end
end
InputConnect = game:GetService("UserInputService").InputBegan:Connect(InputBegan)
	
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
