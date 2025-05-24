-- Guaranteed Working Fullscreen Garden Loading Screen
local LoadTime = 120 -- 2 minutes in seconds
local GardeningMessages = {
    "Compiling script components... 1%",
    "Loading core modules... 10%",
    "Initializing variables... 20%",
    "Building environment tables... 30%",
    "Verifying script integrity... 40%",
    "Optimizing runtime performance... 50%",
    "Caching frequently used objects... 60%",
    "Preparing event handlers... 70%",
    "Finalizing execution... 80%",
    "Script ready in 5 seconds... 90%",
    "Loading complete! Launching... 100%"
}

-- Wait for player safely
local player = game:GetService("Players").LocalPlayer
while not player do
    task.wait()
    player = game:GetService("Players").LocalPlayer
end

-- Create fullscreen GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FullscreenGardenLoader"
ScreenGui.IgnoreGuiInset = true -- Covers entire screen
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- Parent to CoreGui or PlayerGui with error handling
local success, _ = pcall(function() 
    ScreenGui.Parent = game:GetService("CoreGui") 
end)
if not success then
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Create garden background
local Background = Instance.new("Frame")
Background.Name = "GardenBackground"
Background.Size = UDim2.new(1, 0, 1, 0)
Background.Position = UDim2.new(0, 0, 0, 0)
Background.BackgroundColor3 = Color3.fromRGB(56, 117, 29) -- Grass green
Background.BorderSizePixel = 0
Background.Parent = ScreenGui

-- Add sky
local Sky = Instance.new("Frame")
Sky.Name = "Sky"
Sky.Size = UDim2.new(1, 0, 0.7, 0)
Sky.Position = UDim2.new(0, 0, 0, 0)
Sky.BackgroundColor3 = Color3.fromRGB(135, 206, 235) -- Sky blue
Sky.BorderSizePixel = 0
Sky.ZIndex = 1
Sky.Parent = Background

-- Add sun
local Sun = Instance.new("Frame")
Sun.Name = "Sun"
Sun.Size = UDim2.new(0, 80, 0, 80)
Sun.Position = UDim2.new(0.8, -40, 0.1, -40)
Sun.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
Sun.BorderSizePixel = 0
Sun.ZIndex = 2
Sun.Parent = Sky

-- Make sun circular
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = Sun

-- Loading text
local TextLabel = Instance.new("TextLabel")
TextLabel.Name = "GardenLoadingText"
TextLabel.Size = UDim2.new(0.8, 0, 0, 60)
TextLabel.Position = UDim2.new(0.1, 0, 0.3, -30)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = GardeningMessages[1]
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 28
TextLabel.TextWrapped = true
TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 100, 0)
TextLabel.TextStrokeTransparency = 0.5
TextLabel.ZIndex = 3
TextLabel.Parent = Background

-- Progress bar container (soil)
local ProgressBarContainer = Instance.new("Frame")
ProgressBarContainer.Name = "Soil"
ProgressBarContainer.Size = UDim2.new(0.7, 0, 0, 30)
ProgressBarContainer.Position = UDim2.new(0.15, 0, 0.5, 0)
ProgressBarContainer.BackgroundColor3 = Color3.fromRGB(94, 53, 19) -- Soil brown
ProgressBarContainer.BorderSizePixel = 0
ProgressBarContainer.ZIndex = 3
ProgressBarContainer.Parent = Background

-- Make soil look natural
local SoilCorner = Instance.new("UICorner")
SoilCorner.CornerRadius = UDim.new(0.5, 0)
SoilCorner.Parent = ProgressBarContainer

-- Growing plant progress bar
local ProgressBar = Instance.new("Frame")
ProgressBar.Name = "GrowingPlant"
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(34, 139, 34) -- Plant green
ProgressBar.BorderSizePixel = 0
ProgressBar.ZIndex = 4
ProgressBar.Parent = ProgressBarContainer

-- Round plant corners
local PlantCorner = Instance.new("UICorner")
PlantCorner.CornerRadius = UDim.new(0.5, 0)
PlantCorner.Parent = ProgressBar

-- Percentage with plant emoji
local PercentageText = Instance.new("TextLabel")
PercentageText.Name = "GrowthPercentage"
PercentageText.Size = UDim2.new(1, 0, 0, 40)
PercentageText.Position = UDim2.new(0, 0, 0, 35)
PercentageText.BackgroundTransparency = 1
PercentageText.Text = "🌱 0%"
PercentageText.TextColor3 = Color3.new(1, 1, 1)
PercentageText.Font = Enum.Font.GothamBold
PercentageText.TextSize = 24
PercentageText.TextStrokeColor3 = Color3.fromRGB(0, 100, 0)
PercentageText.TextStrokeTransparency = 0.5
PercentageText.ZIndex = 5
PercentageText.Parent = ProgressBarContainer

-- Animation variables
local startTime = os.clock()
local connection

-- Function to update plant color as it grows
local function getPlantColor(progress)
    local r = 34 + (200 * progress)
    local g = 139 + (100 * (1 - progress))
    local b = 34 + (50 * progress)
    return Color3.fromRGB(math.min(r, 255), math.min(g, 255), math.min(b, 255))
end

-- Main update function
local function updateLoading()
    local currentTime = os.clock()
    local elapsed = currentTime - startTime
    local progress = math.clamp(elapsed / LoadTime, 0, 1)
    
    -- Update progress bar
    ProgressBar.Size = UDim2.new(progress, 0, 1, 0)
    ProgressBar.BackgroundColor3 = getPlantColor(progress)
    
    -- Update plant emoji based on growth stage
    local plantEmoji = "🌱" -- Seedling
    if progress > 0.3 then plantEmoji = "🌿" end -- Sprout
    if progress > 0.6 then plantEmoji = "🌻" end -- Flower
    if progress > 0.9 then plantEmoji = "🌳" end -- Tree
    PercentageText.Text = plantEmoji .. " " .. math.floor(progress * 100) .. "%"
    
    -- Rotate sun slightly
    Sun.Rotation = 10 * math.sin(os.clock())
    
    -- Change message every 5 seconds
    local messageIndex = math.floor(elapsed / 5) % #GardeningMessages + 1
    TextLabel.Text = GardeningMessages[messageIndex]
    
    -- Complete at 100%
    if progress >= 1 then
        TextLabel.Text = "🌸 Your Garden is Complete! 🌸"
        task.wait(2)
        ScreenGui:Destroy()
        connection:Disconnect()
    end
end

-- Start animation
connection = game:GetService("RunService").Heartbeat:Connect(updateLoading)

-- Manual removal function
return function()
    if connection then connection:Disconnect() end
    if ScreenGui then ScreenGui:Destroy() end
end
