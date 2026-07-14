local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Ensure LocalPlayer is fully loaded
local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
    task.wait(0.1)
    LocalPlayer = Players.LocalPlayer
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KrutoiDalbaepHub"
ScreenGui.ResetOnSpawn = false -- Prevents GUI from disappearing on death

local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FlingBtn = Instance.new("TextButton")
local NoclipBtn = Instance.new("TextButton")
local SpeedBtn = Instance.new("TextButton")
local TargetBox = Instance.new("TextBox")
local TargetFlingBtn = Instance.new("TextButton")

-- Safe Parenting Fallback System (100% works on Delta)
local function parentGui()
    local successHui, hui = pcall(function() return gethui() end)
    if successHui and hui then
        ScreenGui.Parent = hui
        return
    end

    local successCore, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if successCore and coreGui then
        ScreenGui.Parent = coreGui
        return
    end

    local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
    if playerGui then
        ScreenGui.Parent = playerGui
    end
end

parentGui()

-- Main Frame Setup (Height adjusted to 240)
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -120)
MainFrame.Size = UDim2.new(0, 200, 0, 240)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true

-- Title Label Setup
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "krutoi_dalbaep hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.BorderSizePixel = 0

-- Fling Button Setup (Height 35)
FlingBtn.Parent = MainFrame
FlingBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
FlingBtn.Position = UDim2.new(0.1, 0, 0, 40)
FlingBtn.Size = UDim2.new(0.8, 0, 0, 35)
FlingBtn.Font = Enum.Font.SourceSansBold
FlingBtn.Text = "FLING: OFF"
FlingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingBtn.TextSize = 18
FlingBtn.BorderSizePixel = 0

-- Noclip Button Setup (Height 35)
NoclipBtn.Parent = MainFrame
NoclipBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
NoclipBtn.Position = UDim2.new(0.1, 0, 0, 80)
NoclipBtn.Size = UDim2.new(0.8, 0, 0, 35)
NoclipBtn.Font = Enum.Font.SourceSansBold
NoclipBtn.Text = "NOCLIP: OFF"
NoclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipBtn.TextSize = 18
NoclipBtn.BorderSizePixel = 0

-- Speed Button Setup (Height 35)
SpeedBtn.Parent = MainFrame
SpeedBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
SpeedBtn.Position = UDim2.new(0.1, 0, 0, 120)
SpeedBtn.Size = UDim2.new(0.8, 0, 0, 35)
SpeedBtn.Font = Enum.Font.SourceSansBold
SpeedBtn.Text = "SPEED: OFF"
SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBtn.TextSize = 18
SpeedBtn.BorderSizePixel = 0

-- Target TextBox Setup
TargetBox.Parent = MainFrame
TargetBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TargetBox.Position = UDim2.new(0.1, 0, 0, 160)
TargetBox.Size = UDim2.new(0.8, 0, 0, 30)
TargetBox.Font = Enum.Font.SourceSans
TargetBox.Text = ""
TargetBox.PlaceholderText = "Target Username"
TargetBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
TargetBox.TextSize = 14
TargetBox.BorderSizePixel = 0

-- Target Fling Button Setup (Height 35)
TargetFlingBtn.Parent = MainFrame
TargetFlingBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
TargetFlingBtn.Position = UDim2.new(0.1, 0, 0, 195)
TargetFlingBtn.Size = UDim2.new(0.8, 0, 0, 35)
TargetFlingBtn.Font = Enum.Font.SourceSansBold
TargetFlingBtn.Text = "KILL TARGET: OFF"
TargetFlingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetFlingBtn.TextSize = 18
TargetFlingBtn.BorderSizePixel = 0

-- Universal Dragging Logic (Supports Mobile and PC)
local dragging, dragInput, dragStart, startPos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- FE Fling Logic
local flinging = false
local flingLoop = nil

local function toggleFling()
    flinging = not flinging
    
    if flinging then
        FlingBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        FlingBtn.Text = "FLING: ON"
        
        flingLoop = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            local myRoot = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            
            if myRoot and hum then
                local targetFound = false
                
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local targetRoot = player.Character.HumanoidRootPart
                        local dist = (myRoot.Position - targetRoot.Position).Magnitude
                        
                        if dist < 6 then
                            targetFound = true
                            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                            
                            myRoot.RotVelocity = Vector3.new(99999, 99999, 99999)
                            myRoot.Velocity = (targetRoot.Position - myRoot.Position).Unit * 35
                            break
                        end
                    end
                end
                
                if not targetFound then
                    myRoot.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end)
    else
        FlingBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        FlingBtn.Text = "FLING: OFF"
        
        if flingLoop then
            flingLoop:Disconnect()
            flingLoop = nil
        end
        
        local char = LocalPlayer.Character
        local myRoot = char and char:FindFirstChild("HumanoidRootPart")
        if myRoot then
            myRoot.RotVelocity = Vector3.new(0, 0, 0)
        end
    end
end

FlingBtn.MouseButton1Click:Connect(toggleFling)

-- Noclip Logic
local noclipping = false
local noclipLoop = nil

local function toggleNoclip()
    noclipping = not noclipping
    
    if noclipping then
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        NoclipBtn.Text = "NOCLIP: ON"
        
        noclipLoop = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        NoclipBtn.Text = "NOCLIP: OFF"
        
        if noclipLoop then
            noclipLoop:Disconnect()
            noclipLoop = nil
        end
    end
end

NoclipBtn.MouseButton1Click:Connect(toggleNoclip)

-- Speed Logic
local speeding = false
local speedLoop = nil
local normalSpeed = 16
local fastSpeed = 35 -- Adjusted speed to prevent self-damage in NDS

local function toggleSpeed()
    speeding = not speeding
    
    if speeding then
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        SpeedBtn.Text = "SPEED: ON"
        
        speedLoop = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = fastSpeed
            end
        end)
    else
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        SpeedBtn.Text = "SPEED: OFF"
        
        if speedLoop then
            speedLoop:Disconnect()
            speedLoop = nil
        end
        
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = normalSpeed
        end
    end
end

SpeedBtn.MouseButton1Click:Connect(toggleSpeed)

-- Target Finder Helper Function
local function getPlayer(name)
    name = name:lower()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and (p.Name:lower():sub(1, #name) == name or p.DisplayName:lower():sub(1, #name) == name) then
            return p
        end
    end
    return nil
end

-- Target Kill Logic
local targetKilling = false

local function startTargetKill()
    if targetKilling then return end
    
    local targetName = TargetBox.Text
    if targetName == "" then return end
    
    local target = getPlayer(targetName)
    if not target then
        TargetFlingBtn.Text = "NOT FOUND"
        task.wait(1.5)
        TargetFlingBtn.Text = "KILL TARGET: OFF"
        return
    end
    
    local char = LocalPlayer.Character
    local myRoot = char and char:FindFirstChild("HumanoidRootPart")
    local myHum = char and char:FindFirstChildOfClass("Humanoid")
    
    if not myRoot or not myHum then
        TargetFlingBtn.Text = "NO CHARACTER"
        task.wait(1.5)
        TargetFlingBtn.Text = "KILL TARGET: OFF"
        return
    end
    
    targetKilling = true
    TargetFlingBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    TargetFlingBtn.Text = "KILLING..."
    
    local origCFrame = myRoot.CFrame
    
    -- Temp Noclip to avoid getting stuck
    local tempNoclip = RunService.Stepped:Connect(function()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
    
    -- Body Movers for powerful spinning physics
    local bgv = Instance.new("BodyAngularVelocity")
    bgv.MaxTorque = Vector3.new(1, 1, 1) * 999999999
    bgv.AngularVelocity = Vector3.new(0, 999999999, 0)
    bgv.Parent = myRoot
    
    local bf = Instance.new("BodyForce")
    bf.Force = Vector3.new(0, 9999, 0)
    bf.Parent = myRoot
    
    -- Teleport and Fling loop
    local targetChar = target.Character
    local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
    
    while target and target.Character == targetChar and targetRoot and targetHum and targetHum.Health > 0 do
        myHum:ChangeState(Enum.HumanoidStateType.GettingUp)
        myRoot.CFrame = targetRoot.CFrame
        myRoot.Velocity = Vector3.new(9999, 9999, 9999)
        task.wait(0.01)
    end
    
    -- Cleaning up physics
    bgv:Destroy()
    bf:Destroy()
    tempNoclip:Disconnect()
    
    myRoot.Velocity = Vector3.new(0, 0, 0)
    myRoot.RotVelocity = Vector3.new(0, 0, 0)
    
    -- Wait a bit and return to starting position
    task.wait(0.1)
    myRoot.CFrame = origCFrame
    
    targetKilling = false
    TargetFlingBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    TargetFlingBtn.Text = "KILL TARGET: OFF"
end

TargetFlingBtn.MouseButton1Click:Connect(startTargetKill)
