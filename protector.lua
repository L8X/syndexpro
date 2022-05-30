--IMPORT [var]
local Services = {
    Workspace = GetService(game, "Workspace");
    UserInputService = GetService(game, "UserInputService");
    ReplicatedStorage = GetService(game, "ReplicatedStorage");
    StarterPlayer = GetService(game, "StarterPlayer");
    StarterPack = GetService(game, "StarterPack");
    StarterGui = GetService(game, "StarterGui");
    TeleportService = GetService(game, "TeleportService");
    CoreGui = GetService(game, "CoreGui");
    TweenService = GetService(game, "TweenService");
    HttpService = GetService(game, "HttpService");
    TextService = GetService(game, "TextService");
    MarketplaceService = GetService(game, "MarketplaceService");
    Chat = GetService(game, "Chat");
    Teams = GetService(game, "Teams");
    SoundService = GetService(game, "SoundService");
    Lighting = GetService(game, "Lighting");
    ScriptContext = GetService(game, "ScriptContext");
    Stats = GetService(game, "Stats");
}

setmetatable(Services, {
    __index = function(Table, Property)
        local Ret, Service = pcall(GetService, game, Property);
        if (Ret) then
            Services[Property] = Service
            return Service
        end
        return nil
    end,
    __mode = "v"
});

local GetChildren, GetDescendants = game.GetChildren, game.GetDescendants
local IsA = game.IsA
local FindFirstChild, FindFirstChildOfClass, FindFirstChildWhichIsA, WaitForChild = 
    game.FindFirstChild,
    game.FindFirstChildOfClass,
    game.FindFirstChildWhichIsA,
    game.WaitForChild

local GetPropertyChangedSignal, Changed = 
    game.GetPropertyChangedSignal,
    game.Changed
    
local Destroy, Clone = game.Destroy, game.Clone

local Heartbeat, Stepped, RenderStepped;
do
    local RunService = Services.RunService;
    Heartbeat, Stepped, RenderStepped =
        RunService.Heartbeat,
        RunService.Stepped,
        RunService.RenderStepped
end

local Players = Services.Players
local GetPlayers = Players.GetPlayers

local JSONEncode, JSONDecode, GenerateGUID = 
    Services.HttpService.JSONEncode, 
    Services.HttpService.JSONDecode,
    Services.HttpService.GenerateGUID

local Camera = Services.Workspace.CurrentCamera

local Tfind, sort, concat, pack, unpack;
do
    local table = table
    Tfind, sort, concat, pack, unpack = 
        table.find, 
        table.sort,
        table.concat,
        table.pack,
        table.unpack
end

local lower, upper, Sfind, split, sub, format, len, match, gmatch, gsub, byte;
do
    local string = string
    lower, upper, Sfind, split, sub, format, len, match, gmatch, gsub, byte = 
        string.lower,
        string.upper,
        string.find,
        string.split, 
        string.sub,
        string.format,
        string.len,
        string.match,
        string.gmatch,
        string.gsub,
        string.byte
end

local random, floor, round, abs, atan, cos, sin, rad;
do
    local math = math
    random, floor, round, abs, atan, cos, sin, rad = 
        math.random,
        math.floor,
        math.round,
        math.abs,
        math.atan,
        math.cos,
        math.sin,
        math.rad
end

local InstanceNew = Instance.new
local CFrameNew = CFrame.new
local Vector3New = Vector3.new

local Inverse, toObjectSpace, components
do
    local CalledCFrameNew = CFrameNew();
    Inverse = CalledCFrameNew.Inverse
    toObjectSpace = CalledCFrameNew.toObjectSpace
    components = CalledCFrameNew.components
end

local Connection = game.Loaded
local CWait = Connection.Wait
local CConnect = Connection.Connect

local Disconnect;
do
    local CalledConnection = CConnect(Connection, function() end);
    Disconnect = CalledConnection.Disconnect
end

local __H = InstanceNew("Humanoid");
local UnequipTools = __H.UnequipTools
local ChangeState = __H.ChangeState
local SetStateEnabled = __H.SetStateEnabled
local GetState = __H.GetState
local GetAccessories = __H.GetAccessories

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local Mouse = LocalPlayer.GetMouse(LocalPlayer);

local CThread;
do
    local wrap = coroutine.wrap
    CThread = function(Func, ...)
        if (type(Func) ~= 'function') then
            return nil
        end
        local Varag = ...
        return function()
            local Success, Ret = pcall(wrap(Func, Varag));
            if (Success) then
                return Ret
            end
            if (Debug) then
                warn("[FA Error]: " .. debug.traceback(Ret));
            end
        end
    end
end

local startsWith = function(str, searchString, rawPos)
    local pos = rawPos or 1
    return searchString == "" and true or sub(str, pos, pos) == searchString
end

local trim = function(str)
    return gsub(str, "^%s*(.-)%s*$", "%1");
end

local tbl_concat = function(...)
    local new = {}
    for i, v in next, {...} do
        for i2, v2 in next, v do
            new[i] = v2
        end
    end
    return new
end

local indexOf = function(tbl, val)
    if (type(tbl) == 'table') then
        for i, v in next, tbl do
            if (v == val) then
                return i
            end
        end
    end
end

local forEach = function(tbl, ret)
    for i, v in next, tbl do
        ret(i, v);
    end
end

local filter = function(tbl, ret)
    if (type(tbl) == 'table') then
        local new = {}
        for i, v in next, tbl do
            if (ret(i, v)) then
                new[#new + 1] = v
            end
        end
        return new
    end
end

local map = function(tbl, ret)
    if (type(tbl) == 'table') then
        local new = {}
        for i, v in next, tbl do
            local Value, Key = ret(i, v);
            new[Key or #new + 1] = Value
        end
        return new
    end
end

local deepsearch;
deepsearch = function(tbl, ret)
    if (type(tbl) == 'table') then
        for i, v in next, tbl do
            if (type(v) == 'table') then
                deepsearch(v, ret);
            end
            ret(i, v);
        end
    end
end

local deepsearchset;
deepsearchset = function(tbl, ret, value)
    if (type(tbl) == 'table') then
        local new = {}
        for i, v in next, tbl do
            new[i] = v
            if (type(v) == 'table') then
                new[i] = deepsearchset(v, ret, value);
            end
            if (ret(i, v)) then
                new[i] = value(i, v);
            end
        end
        return new
    end
end

local flat = function(tbl)
    if (type(tbl) == 'table') then
        local new = {}
        deepsearch(tbl, function(i, v)
            if (type(v) ~= 'table') then
                new[#new + 1] = v
            end
        end)
        return new
    end
end

local flatMap = function(tbl, ret)
    if (type(tbl) == 'table') then
        local new = flat(map(tbl, ret));
        return new
    end
end

local shift = function(tbl)
    if (type(tbl) == 'table') then
        local firstVal = tbl[1]
        tbl = pack(unpack(tbl, 2, #tbl));
        tbl.n = nil
        return tbl
    end
end

local keys = function(tbl)
    if (type(tbl) == 'table') then
        local new = {}
        for i, v in next, tbl do
            new[#new + 1] = i	
        end
        return new
    end
end

local function clone(toClone, shallow)
    if (type(toClone) == 'function' and clonefunction) then
        return clonefunction(toClone);
    end
    local new = {}
    for i, v in pairs(toClone) do
        if (type(v) == 'table' and not shallow) then
            v = clone(v);
        end
        new[i] = v
    end
    return new
end

local setthreadidentity = setthreadidentity or syn_context_set or setthreadcontext or (syn and syn.set_thread_identity)
local getthreadidentity = getthreadidentity or syn_context_get or getthreadcontext or (syn and syn.get_thread_identity)
--END IMPORT [var]



local GetCharacter = GetCharacter or function(Plr)
    return Plr and Plr.Character or LocalPlayer.Character
end

local Utils = {}

--IMPORT [extend]
local Stats = Services.Stats
local ContentProvider = Services.ContentProvider

local firetouchinterest, hookfunction, getconnections;
do
    local GEnv = getgenv();
    local touched = {}
    firetouchinterest = GEnv.firetouchinterest or function(part1, part2, toggle)
        if (part1 and part2) then
            if (toggle == 0) then
                touched[1] = part1.CFrame
                part1.CFrame = part2.CFrame
            else
                part1.CFrame = touched[1]
                touched[1] = nil
            end
        end
    end
    local newcclosure = newcclosure or function(f)
        return f
    end

    hookfunction = GEnv.hookfunction or function(func, newfunc, applycclosure)
        if (replaceclosure) then
            replaceclosure(func, newfunc);
            return func
        end
        func = applycclosure and newcclosure or newfunc
        return func
    end

    local CachedConnections = setmetatable({}, {
        __mode = "v"
    });

    getconnections = function(Connection, FromCache, AddOnConnect)
        local getconnections = GEnv.getconnections
        if (not getconnections) then
            return {}
        end
        
        local CachedConnection;
        for i, v in next, CachedConnections do
            if (i == Connection) then
                CachedConnection = v
                break;
            end
        end
        if (CachedConnection and FromCache) then
            return CachedConnection
        end

        local Connections = GEnv.getconnections(Connection);
        CachedConnections[Connection] = Connections
        return Connections
    end
end

local getrawmetatable = getrawmetatable or function()
    return setmetatable({}, {});
end

local getnamecallmethod = getnamecallmethod or function()
    return ""
end

local checkcaller = checkcaller or function()
    return false
end

local Hooks = {
    AntiKick = false,
    AntiTeleport = false,
    NoJumpCooldown = false,
}

local mt = getrawmetatable(game);
local OldMetaMethods = {}
setreadonly(mt, false);
for i, v in next, mt do
    OldMetaMethods[i] = v
end
setreadonly(mt, true);
local MetaMethodHooks = {}

local ProtectInstance, SpoofInstance, SpoofProperty;
local pInstanceCount = 0;
local ProtectedInstances = setmetatable({}, {
    __mode = "v"
});
local FocusedTextBox = nil
do
    local SpoofedInstances = setmetatable({}, {
        __mode = "v"
    });
    local SpoofedProperties = {}
    Hooks.SpoofedProperties = SpoofedProperties

    ProtectInstance = function(Instance_)
        if (not Tfind(ProtectedInstances, Instance_)) then
            ProtectedInstances[#ProtectedInstances + 1] = Instance_
            pInstanceCount += 1 + #Instance_:GetDescendants();
            local dAdded = Instance_.DescendantAdded:Connect(function()
                pInstanceCount += 1
            end);
            local dRemoving = Instance_.DescendantRemoving:Connect(function()
                pInstanceCount = math.max(pInstanceCount - 1, 0);
            end);

            Instance_.Name = sub(gsub(GenerateGUID(Services.HttpService, false), '-', ''), 1, random(25, 30));
        end
    end
    
    getgenv().ProtectInstance = ProtectInstance

    SpoofInstance = function(Instance_, Instance2)
        if (not SpoofedInstances[Instance_]) then
            SpoofedInstances[Instance_] = Instance2 and Instance2 or Clone(Instance_);
        end
    end
    
    getgenv().SpoofInstance = SpoofInstance

    UnSpoofInstance = function(Instance_)
        if (SpoofedInstances[Instance_]) then
            SpoofedInstances[Instance_] = nil
        end
    end
    
    getgenv().UnSpoofInstance = UnSpoofInstance
    
    local ChangedSpoofedProperties = {}
    SpoofProperty = function(Instance_, Property, NoClone)
        if (SpoofedProperties[Instance_]) then
            local SpoofedPropertiesForInstance = SpoofedProperties[Instance_]
            local Properties = map(SpoofedPropertiesForInstance, function(i, v)
                return v.Property
            end)
            if (not Tfind(Properties, Property)) then
                SpoofedProperties[Instance_][#SpoofedPropertiesForInstance + 1] = {
                    SpoofedProperty = SpoofedPropertiesForInstance[1].SpoofedProperty,
                    Property = Property,
                };
            end
        else
            local Cloned;
            if (not NoClone and IsA(Instance_, "Instance") and not Services[tostring(Instance_)] and Instance_.Archivable) then
                local Success, Ret = pcall(Clone, Instance_);
                if (Success) then
                    Cloned = Ret
                end
            end
            SpoofedProperties[Instance_] = {{
                SpoofedProperty = Cloned and Cloned or {[Property]=Instance_[Property]},
                Property = Property,
            }}
            ChangedSpoofedProperties[Instance_] = {}
        end
    end
    
    getgenv().SpoofProperty = SpoofProperty

    local GetAllParents = function(Instance_, NIV)
        if (typeof(Instance_) == "Instance") then
            local Parents = {}
            local Current = NIV or Instance_
            if (NIV) then
                Parents[#Parents + 1] = Current
            end
            repeat
                local Parent = Current.Parent
                Parents[#Parents + 1] = Parent
                Current = Parent
            until not Current
            return Parents
        end
        return {}
    end
    
    getgenv().GetAllParents = GetAllParents

    local Methods = {
        "FindFirstChild",
        "FindFirstChildWhichIsA",
        "FindFirstChildOfClass"
        "IsA"
    }

    local lockedInstances = {};
    setmetatable(lockedInstances, { __mode = "k" });
    local IsDescendantOf = game.IsDescendantOf
    local isProtected = function(instance)
        if (lockedInstances[instance]) then
            return true;
        end

        local good2 = pcall(tostring, instance);
        if (not good2) then
            lockedInstances[instance] = true
            return true;
        end

        for i2 = 1, #ProtectedInstances do
            local pInstance = ProtectedInstances[i2]
            if (pInstance == instance) then
                return true;
            end
        end
        return false;
    end

    local preloadHook = function(...)
        local oldPreload = Hooks.PreloadAsync
        local args = {...};
        local self = args[1]
        local instanceT = args[2]
        if (type(instanceT) == "table" and type(args[3]) == "function") then
            local filteredInstances = {}
            for i, instance in pairs(instanceT) do
                if (instance and typeof(instance) == "Instance") then
                    local indentity = getthreadidentity();
                    setthreadidentity(3); -- doesn't matter as preload async gets all descendants includingg roblox locked instances
                    local instanceDescendants = instance == Services.CoreGui and instance:GetChildren() or instance:GetDescendants();
                    local filteredDescendants = filter(instanceDescendants, function(i2, instance2)
                        return not isProtected(instance2);
                    end);
                    for i2 = 1, #filteredDescendants do
                        local descendant = filteredDescendants[i2]
                        filteredInstances[#filteredInstances + 1] = descendant
                    end
                    setthreadidentity(indentity);
                else
                    filteredInstances[#filteredInstances + 1] = instance
                end
            end
            return oldPreload(self, filteredInstances, args[3]);
        end
        return oldPreload(self, ...);
    end

    MetaMethodHooks.Namecall = function(...)
        local __Namecall = OldMetaMethods.__namecall;
        local Args = {...}
        local self = Args[1]
        local Method = getnamecallmethod() or "";

        if (Method ~= "") then
            local Success, result = pcall(OldMetaMethods.__index, self, Method);
            if (not Success or Success and type(result) ~= "function") then
                return __Namecall(...);
            end
        end

        if (Hooks.AntiKick and lower(Method) == "kick") then
            local Player, Message = self, Args[2]
            if (Hooks.AntiKick and Player == LocalPlayer) then
                local Notify = Utils.Notify
                local Context;
                if (setthreadidentity) then
                    Context = getthreadidentity();
                    setthreadidentity(3);
                end
                if (Notify and Context) then
                    Notify(nil, "Attempt to kick", format("attempt to kick %s", (Message and type(Message) == 'number' or type(Message) == 'string') and ": " .. Message or ""));
                    setthreadidentity(Context);
                end
                return
            end
        end

        if (Hooks.AntiTeleport and Method == "Teleport" or Method == "TeleportToPlaceInstance") then
            local Player, PlaceId = self, Args[2]
            if (Hooks.AntiTeleport and Player == LocalPlayer) then
                local Notify = Utils.Notify
                local Context;
                if (setthreadidentity) then
                    Context = getthreadidentity();
                    setthreadidentity(3);
                end
                if (Notify and Context) then
                    Notify(nil, "Attempt to teleport", format("attempt to teleport to place %s", PlaceId and PlaceId or ""));
                    setthreadidentity(Context);
                end
                return
            end
        end

        if (checkcaller()) then
            return __Namecall(...);
        end

        if (Tfind(Methods, Method)) then
            local ReturnedInstance = __Namecall(...);
            if (Tfind(ProtectedInstances, ReturnedInstance)) then
                return Method == "IsA" and false or nil
            end
        end

        -- ik this is horrible but fates admin v3 has a better way of doing hooks
        if (Method == "children" or Method == "GetChildren" or Method ==  "getChildren" or Method == "GetDescendants" or Method == "getDescendants") then
            return filter(__Namecall(...), function(i, instance)
                return not isProtected(instance);
            end);
        end

        if (self == Services.UserInputService and Method == "GetFocusedTextBox" or Method == "getFocusedTextBox") then
            local focused = __Namecall(...);
            for i = 1, #ProtectedInstances do
                local ProtectedInstance = ProtectedInstances[i]
                local pInstance = not Tfind(ProtectedInstances, focused) or focused.IsDescendantOf(focused, ProtectedInstance);
                if (pInstance) then
                    return nil;
                end
            end
        end

        if (Hooks.NoJumpCooldown and Method == "GetState" or Method == "GetStateEnabled") then
            local State = __Namecall(...);
            if (Method == "GetState" and (State == Enum.HumanoidStateType.Jumping or State == "Jumping")) then
                return Enum.HumanoidStateType.RunningNoPhysics
            end
            if (Method == "GetStateEnabled" and (self == Enum.HumanoidStateType.Jumping or self == "Jumping")) then
                return false
            end
        end

        if (self == ContentProvider and Method == "PreloadAsync" or Method == "preloadAsync") then
            return preloadHook(...);
        end

        return __Namecall(...);
    end

    local AllowedIndexes = {
        "RootPart",
        "Parent"
    }
    local AllowedNewIndexes = {
        "Jump"
    }
    MetaMethodHooks.Index = function(...)
        local __Index = OldMetaMethods.__index;

        if (checkcaller()) then
            return __Index(...);
        end
        local Instance_, Index = ...

        local SanitisedIndex = Index
        if (typeof(Instance_) == 'Instance' and type(Index) == 'string') then
            SanitisedIndex = gsub(sub(Index, 0, 100), "%z.*", "");
        end
        local SpoofedInstance = SpoofedInstances[Instance_]
        local SpoofedPropertiesForInstance = SpoofedProperties[Instance_]

        if (SpoofedInstance) then
            if (Tfind(AllowedIndexes, SanitisedIndex)) then
                return __Index(Instance_, Index);
            end
            return __Index(SpoofedInstance, Index);
        end

        if (SpoofedPropertiesForInstance) then
            for i, SpoofedProperty in next, SpoofedPropertiesForInstance do
                local SanitisedIndex = gsub(SanitisedIndex, "^%l", upper);
                if (SanitisedIndex == SpoofedProperty.Property) then
                    local ClientChangedData = ChangedSpoofedProperties[Instance_][SanitisedIndex]
                    local IndexedSpoofed = __Index(SpoofedProperty.SpoofedProperty, Index);
                    local Indexed = __Index(Instance_, Index);
                    if (ClientChangedData.Caller and ClientChangedData.Value ~= Indexed) then
                        OldMetaMethods.__newindex(SpoofedProperty.SpoofedProperty, Index, Indexed);
                        OldMetaMethods.__newindex(Instance_, Index, ClientChangedData.Value);
                        return Indexed
                    end
                    return IndexedSpoofed
                end
            end
        end

        if (Hooks.NoJumpCooldown and SanitisedIndex == "Jump") then
            if (IsA(Instance_, "Humanoid")) then
                return false
            end
        end

        if (Instance_ == Stats and SanitisedIndex == "InstanceCount" or SanitisedIndex == "instanceCount") then
            return __Index(...) - pInstanceCount;
        end

        if (Instance_ == Stats and SanitisedIndex == "PrimitivesCount" or SanitisedIndex == "primitivesCount") then
            return #filter(game:GetDescendants(), function(i, v)
                return IsA(v, "BasePart");
            end);
        end

        return __Index(...);
    end

    MetaMethodHooks.NewIndex = function(...)
        local __NewIndex = OldMetaMethods.__newindex;
        local __Index = OldMetaMethods.__index;
        local Instance_, Index, Value = ...

        local SpoofedInstance = SpoofedInstances[Instance_]
        local SpoofedPropertiesForInstance = SpoofedProperties[Instance_]

        if (checkcaller()) then
            if (Index == "Parent" and Value) then
                local ProtectedInstance
                for i = 1, #ProtectedInstances do
                    local ProtectedInstance_ = ProtectedInstances[i]
                    if (Instance_ == ProtectedInstance_ or Instance_.IsDescendantOf(Value, ProtectedInstance_)) then
                        ProtectedInstance = true
                    end
                end
                if (ProtectedInstance) then
                    local Parents = GetAllParents(Instance_, Value);
                    for i, v in next, getconnections(Parents[1].ChildAdded, true) do
                        v.Disable(v);
                    end
                    for i = 1, #Parents do
                        local Parent = Parents[i]
                        for i2, v in next, getconnections(Parent.DescendantAdded, true) do
                            v.Disable(v);
                        end
                    end
                    local Ret = __NewIndex(...);
                    for i = 1, #Parents do
                        local Parent = Parents[i]
                        for i2, v in next, getconnections(Parent.DescendantAdded, true) do
                            v.Enable(v);
                        end
                    end
                    for i, v in next, getconnections(Parents[1].ChildAdded, true) do
                        v.Enable(v);
                    end
                    return Ret
                end
            end
            if (SpoofedInstance or SpoofedPropertiesForInstance) then
                if (SpoofedPropertiesForInstance) then
                    ChangedSpoofedProperties[Instance_][Index] = {
                        Caller = true,
                        BeforeValue = Instance_[Index],
                        Value = Value
                    }
                end
                local Connections = tbl_concat(
                    getconnections(GetPropertyChangedSignal(Instance_, SpoofedPropertiesForInstance and SpoofedPropertiesForInstance.Property or Index)),
                    getconnections(Instance_.Changed),
                    getconnections(game.ItemChanged)
                )
                
                if (not next(Connections)) then
                    return __NewIndex(Instance_, Index, Value);
                end
                for i, v in next, Connections do
                    v.Disable(v);
                end
                local Ret = __NewIndex(Instance_, Index, Value);
                for i, v in next, Connections do
                    v.Enable(v);
                end
                return Ret
            end
            return __NewIndex(...);
        end

        local SanitisedIndex = Index
        if (typeof(Instance_) == 'Instance' and type(Index) == 'string') then
            SanitisedIndex = gsub(sub(Index, 0, 100), "%z.*", "");
        end

        if (SpoofedInstance) then
            if (Tfind(AllowedNewIndexes, SanitisedIndex)) then
                return __NewIndex(...);
            end
            return __NewIndex(SpoofedInstance, Index, __Index(SpoofedInstance, Index));
        end

        if (SpoofedPropertiesForInstance) then
            for i, SpoofedProperty in next, SpoofedPropertiesForInstance do
                if (SpoofedProperty.Property == SanitisedIndex and not Tfind(AllowedIndexes, SanitisedIndex)) then
                    ChangedSpoofedProperties[Instance_][SanitisedIndex] = {
                        Caller = false,
                        BeforeValue = Instance_[Index],
                        Value = Value
                    }
                    return __NewIndex(SpoofedProperty.SpoofedProperty, Index, Value);
                end
            end
        end

        return __NewIndex(...);
    end

    local hookmetamethod = hookmetamethod or function(metatable, metamethod, func)
        setreadonly(metatable, false);
        Old = hookfunction(metatable[metamethod], func, true);
        setreadonly(metatable, true);
        return Old
    end

    OldMetaMethods.__index = hookmetamethod(game, "__index", MetaMethodHooks.Index);
    OldMetaMethods.__newindex = hookmetamethod(game, "__newindex", MetaMethodHooks.NewIndex);
    OldMetaMethods.__namecall = hookmetamethod(game, "__namecall", MetaMethodHooks.Namecall);

    Hooks.Destroy = hookfunction(game.Destroy, function(...)
        local instance = ...
        if (checkcaller() and table.find(ProtectedInstances, instance)) then
            pInstanceCount -= 1 + #instance:GetDescendants();
            local Parents = GetAllParents(instance);
            for i, v in next, getconnections(Parents[1].ChildRemoved, true) do
                v.Disable(v);
            end
            for i = 1, #Parents do
                local Parent = Parents[i]
                for i2, v in next, getconnections(Parent.DescendantRemoving, true) do
                    v.Disable(v);
                end
            end
            local destroy = Hooks.Destroy(...);
            for i = 1, #Parents do
                local Parent = Parents[i]
                for i2, v in next, getconnections(Parent.DescendantRemoving, true) do
                    v.Enable(v);
                end
            end
            for i, v in next, getconnections(Parents[1].ChildRemoved, true) do
                v.Enable(v);
            end
            return destroy;
        end
        return Hooks.Destroy(...);
    end);

    Hooks.PreloadAsync = hookfunction(ContentProvider.PreloadAsync, preloadHook);
end

Hooks.OldGetChildren = hookfunction(game.GetChildren, newcclosure(function(...)
    if (not checkcaller()) then
        local Children = Hooks.OldGetChildren(...);
        return filter(Children, function(i, v)
            return not Tfind(ProtectedInstances, v);
        end)
    end
    return Hooks.OldGetChildren(...);
end));

Hooks.OldGetDescendants = hookfunction(game.GetDescendants, newcclosure(function(...)
    if (not checkcaller()) then
        local Descendants = Hooks.OldGetDescendants(...);
        return filter(Descendants, function(i, v)
            local Protected = false
            for i2 = 1, #ProtectedInstances do
                local ProtectedInstance = ProtectedInstances[i2]
                Protected = v and ProtectedInstance == v or v.IsDescendantOf(v, ProtectedInstance)
                if (Protected) then
                    break;
                end
            end
            return not Protected
        end)
    end
    return Hooks.OldGetDescendants(...);
end));

Hooks.FindFirstChild = hookfunction(game.FindFirstChild, newcclosure(function(...)
    if (not checkcaller()) then
        local ReturnedInstance = Hooks.FindFirstChild(...);
        if (ReturnedInstance and Tfind(ProtectedInstances, ReturnedInstance)) then
            return nil
        end
    end
    return Hooks.FindFirstChild(...);
end));
Hooks.FindFirstChildOfClass = hookfunction(game.FindFirstChildOfClass, newcclosure(function(...)
    if (not checkcaller()) then
        local ReturnedInstance = Hooks.FindFirstChildOfClass(...);
        if (ReturnedInstance and Tfind(ProtectedInstances, ReturnedInstance)) then
            return nil
        end
    end
    return Hooks.FindFirstChildOfClass(...);
end));
Hooks.FindFirstChildWhichIsA = hookfunction(game.FindFirstChildWhichIsA, newcclosure(function(...)
    if (not checkcaller()) then
        local ReturnedInstance = Hooks.FindFirstChildWhichIsA(...);
        if (ReturnedInstance and Tfind(ProtectedInstances, ReturnedInstance)) then
            return nil
        end
    end
    return Hooks.FindFirstChildWhichIsA(...);
end));
Hooks.IsA = hookfunction(game.IsA, newcclosure(function(...)
    if (not checkcaller()) then
        local Args = {...}
        local IsACheck = Args[1]
        if (IsACheck) then
            local ProtectedInstance = Tfind(ProtectedInstances, IsACheck);
            if (ProtectedInstance and Args[2]) then
                return false
            end
        end
    end
    return Hooks.IsA(...);
end));

Hooks.OldGetFocusedTextBox = hookfunction(Services.UserInputService.GetFocusedTextBox, newcclosure(function(...)
    if (not checkcaller() and ... == Services.UserInputService) then
        local FocusedTextBox = Hooks.OldGetFocusedTextBox(...);
        local Protected = false
        for i = 1, #ProtectedInstances do
            local ProtectedInstance = ProtectedInstances[i]
            Protected = not Tfind(ProtectedInstances, FocusedTextBox) or FocusedTextBox.IsDescendantOf(FocusedTextBox, ProtectedInstance);
        end
        if (Protected) then
            return nil
        end
    end
    return Hooks.OldGetFocusedTextBox(...);
end));

Hooks.OldKick = hookfunction(LocalPlayer.Kick, newcclosure(function(...)
    local Player, Message = ...
    if (Hooks.AntiKick and Player == LocalPlayer) then
        local Notify = Utils.Notify
        local Context;
        if (setthreadidentity) then
            Context = getthreadidentity();
            setthreadidentity(3);
        end
        if (Notify and Context) then
            Notify(nil, "Attempt to kick", format("attempt to kick %s", (Message and type(Message) == 'number' or type(Message) == 'string') and ": " .. Message or ""));
            setthreadidentity(Context)
        end
        return
    end
    return Hooks.OldKick(...);
end))

Hooks.OldTeleportToPlaceInstance = hookfunction(Services.TeleportService.TeleportToPlaceInstance, newcclosure(function(...)
    local Player, PlaceId = ...
    if (Hooks.AntiTeleport and Player == LocalPlayer) then
        local Notify = Utils.Notify
        local Context;
        if (setthreadidentity) then
            Context = getthreadidentity();
            setthreadidentity(3);
        end
        if (Notify and Context) then
            Notify(nil, "Attempt to teleport", format("attempt to teleport to place %s", PlaceId and PlaceId or ""));
            setthreadidentity(Context)
        end
        return
    end
    return Hooks.OldTeleportToPlaceInstance(...);
end))
Hooks.OldTeleport = hookfunction(Services.TeleportService.Teleport, newcclosure(function(...)
    local Player, PlaceId = ...
    if (Hooks.AntiTeleport and Player == LocalPlayer) then
        local Notify = Utils.Notify
        local Context;
        if (setthreadidentity) then
            Context = getthreadidentity();
            setthreadidentity(3);
        end
        if (Notify and Context) then
            Notify(nil, "Attempt to teleport", format("attempt to teleport to place \"%s\"", PlaceId and PlaceId or ""));
            setthreadidentity(Context);
        end
        return
    end
    return Hooks.OldTeleport(...);
end))

Hooks.GetState = hookfunction(GetState, function(...)
    local Humanoid, State = ..., Hooks.GetState(...);
    local Parent, Character = Humanoid.Parent, LocalPlayer.Character
    if (Hooks.NoJumpCooldown and (State == Enum.HumanoidStateType.Jumping or State == "Jumping") and Parent and Character and Parent == Character) then
        return Enum.HumanoidStateType.RunningNoPhysics
    end
    return State
end)

Hooks.GetStateEnabled = hookfunction(__H.GetStateEnabled, function(...)
    local Humanoid, State = ...
    local Ret = Hooks.GetStateEnabled(...);
    local Parent, Character = Humanoid.Parent, LocalPlayer.Character
    if (Hooks.NoJumpCooldown and (State == Enum.HumanoidStateType.Jumping or State == "Jumping") and Parent and Character and Parent == Character) then
        return false
    end
    return Ret
end)
--END IMPORT [extend]
