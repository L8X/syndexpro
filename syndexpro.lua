task.spawn(function()
task.synchronize()
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

if is_syn == false then
spawn(function()
game:GetService("ScriptContext").ScriptsDisabled = false
game:GetService("ScriptContext"):SetTimeout(9e9)
    repeat while true do error("This will run on Synapse only, dickwad") end until nil
end)
end


if hookfunction and getrenv then
spawn(function()
local memCheckBypass

memCheckBypass = hookfunction(getrenv().gcinfo, function(...)
   --warn("Script tried to memory check, PATH: \n"..debug.traceback())
   return tonumber(math.random(55-math.random(1,45), 110-math.random(1,35)*0.215-math.random(1, 45)))
end)
end)
end


loadstring = getgenv().loadstring

loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/L8X/syndexpro/main/loader.lua', true))()
 task.synchronize()
end)
