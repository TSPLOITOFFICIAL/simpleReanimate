local PLRS = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = PLRS.LocalPlayer
local char = plr.Character
local hum = char:FindFirstChildOfClass("Humanoid")

local children = char:GetChildren()
local descendants = char:GetDescendants()

char.Animate.Disabled = true

if hum.RigType == Enum.HumanoidRigType.R6 then
    R6 = true
end

for i,v in pairs(hum:GetPlayingAnimationTracks()) do
    v:Stop()
end

for i,v in pairs(descendants) do
    if v:IsA("Motor6D") and v.Name ~= "Neck" and v.Name ~= "Waist" then
        v:Destroy()
    end
end

local rig = game:GetObjects("rbxassetid://11984665448")[1] -- dummy model
rig.Parent = char
rig.Name = "Dummy"

rig.HumanoidRootPart.Anchored = false
workspace.CurrentCamera.CameraSubject = rig

rig.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame

function cf(part,rigpart,offset)
    --part.Velocity = Vector3.new(0,30,0)
    part.Velocity = Vector3.new(rig.HumanoidRootPart.CFrame.LookVector.X * 50, rig.HumanoidRootPart.CFrame.LookVector.Y * 5, rig.HumanoidRootPart.CFrame.LookVector.Y * 50)
    if offset then
        part.CFrame = rigpart.CFrame * offset
    else
        part.CFrame = rigpart.CFrame
    end
end

collision = RunService.Stepped:Connect(function()
    for i,v in pairs(children) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
end)

local offsets = {
    HumanoidRootPart={"HumanoidRootPart",CFrame.new(0,0,0)},
    RightUpperArm={"Right Arm",CFrame.new(0,0.45,0)},
    LeftUpperArm={"Left Arm",CFrame.new(0,0.45,0)},
    RightLowerArm={"Right Arm",CFrame.new(0,-0.15,0)},
    LeftLowerArm={"Left Arm",CFrame.new(0,-0.15,0)},
    RightHand={"Right Arm",CFrame.new(0,-0.8,0)},
    LeftHand={"Left Arm",CFrame.new(0,-0.8,0)},
    UpperTorso={"Torso",CFrame.new(0,0.25,0)},
    RightUpperLeg={"Right Leg",CFrame.new(0,0.6,0)},
    LeftUpperLeg={"Left Leg",CFrame.new(0,0.6,0)},
    RightLowerLeg={"Right Leg",CFrame.new(0,-0.15,0)},
    LeftLowerLeg={"Left Leg",CFrame.new(0,-0.15,0)},
    RightFoot={"Right Leg",CFrame.new(0,-0.8,0)},
    LeftFoot={"Left Leg",CFrame.new(0,-0.8,0)}
}

cfLoop = RunService.Heartbeat:Connect(function()
    if not rig then
        cfLoop:Disconnect()
        collision:Disconnect()
    end
    rig.Humanoid.Jump = hum.Jump
    rig.Humanoid:Move(hum.MoveDirection)
    if R6 then
        cf(char["Torso"], rig["Torso"])
        cf(char["Left Arm"], rig["Left Arm"])
        cf(char["Right Arm"], rig["Right Arm"])
        cf(char["Left Leg"], rig["Left Leg"])
        cf(char["Right Leg"], rig["Right Leg"])
    else
        for i,v in pairs(offsets) do
            cf(char[i],rig[v[1]],v[2])
        end
    end
end)

if R6 then
    CAnimate = char.Animate:Clone()
    CAnimate.Parent = rig
    CAnimate.Disabled = false
else
    loadstring(game:HttpGet("https://raw.githubusercontent.com/leapordtank/normalAnimate/main/main.lua"))()
end
