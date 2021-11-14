local is_syn = nil

if not syn then
  if not syn.protect_gui then
    if not hookmetamethod then
      is_syn = false
      end
    end
end

if syn then
  if syn.protect_gui then
    if hookmetamethod then
      is_syn = true
      end
    end
end

task.spawn(function()
if is_syn == false then
while wait() do
spawn(function()
game:GetService("ScriptContext").ScriptsDisabled = false
 game:GetService("ScriptContext"):SetTimeout(9e9)
    repeat while true do error("This will run on Synapse only, dickwad") end until nil
        end)
end
    end
end)

   
if hookfunction and getrenv then
spawn(function()
local memCheckBypass

memCheckBypass = hookfunction(getrenv().gcinfo, function(...)
   --warn("Script tried to memory check, PATH: \n"..debug.traceback())
   return tonumber(math.random(55-math.random(1,45), 110-math.random(1,35)*0.215-math.random(1, 45)))
end)
end)
end

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

newls(game:HttpGetAsync('https://raw.githubusercontent.com/L8X/syndexpro/main/loader.lua'))()
end
coroutine.wrap(NSIK_fake_script)()
end)
