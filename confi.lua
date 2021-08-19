local RemDebugWin = game:GetService("CoreGui").RobloxGui:FindFirstChild("RemoteDebugWindow", true)

if RemDebugWin then
task.spawn(function()
task.synchronize()
for i, label in pairs(RemDebugWin.Parent:GetDescendants()) do
if label:IsA("TextLabel") then
sethiddenproperty(label, "Confidential", true)
end end
for i, box in pairs(RemDebugWin.Parent:GetDescendants()) do
if box:IsA("TextBox") then
sethiddenproperty(box, "Confidential", true)
end end
for i, button in pairs(RemDebugWin.Parent:GetDescendants()) do
if button:IsA("TextButton") then
sethiddenproperty(button, "Confidential", true)
end end
for i, moddy in pairs(RemDebugWin.Parent:GetDescendants()) do
if moddy:IsA("ModuleScript") then
sethiddenproperty(moddy, "Confidential", true)
end end
task.synchronize()
end)
end
