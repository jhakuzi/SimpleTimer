-- SimpleTimer Addon
-- A simple countdown timer with start/pause/reset functionality

local SimpleTimer = {}

-- Timer variables
SimpleTimer.remainingTime = 0
SimpleTimer.totalTime = 0
SimpleTimer.isRunning = false
SimpleTimer.startTime = 0

-- Create the main frame
function SimpleTimer:CreateFrame()
    -- Main frame
    self.frame = CreateFrame("Frame", "SimpleTimerFrame", UIParent, "BasicFrameTemplateWithInset")
    self.frame:SetSize(250, 180)
    self.frame:SetPoint("CENTER")
    self.frame:SetMovable(true)
    self.frame:EnableMouse(true)
    self.frame:RegisterForDrag("LeftButton")
    self.frame:SetScript("OnDragStart", self.frame.StartMoving)
    self.frame:SetScript("OnDragStop", self.frame.StopMovingOrSizing)

    -- Title
    self.frame.title = self.frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    self.frame.title:SetPoint("TOP", 0, -5)
    self.frame.title:SetText("Simple Timer")

    -- Duration input label
    local durationLabel = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    durationLabel:SetPoint("TOPLEFT", 20, -35)
    durationLabel:SetText("Duration (minutes):")

    -- Duration input box
    self.durationInput = CreateFrame("EditBox", nil, self.frame, "InputBoxTemplate")
    self.durationInput:SetSize(60, 20)
    self.durationInput:SetPoint("TOPLEFT", 130, -30)
    self.durationInput:SetAutoFocus(false)
    self.durationInput:SetNumeric(true)
    self.durationInput:SetText("10") -- Default 10 minutes

    -- Timer display
    self.timerDisplay = self.frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    self.timerDisplay:SetPoint("CENTER", 0, 10)
    self.timerDisplay:SetText("00:00")

    -- Start/Pause button
    self.startPauseButton = CreateFrame("Button", nil, self.frame, "GameMenuButtonTemplate")
    self.startPauseButton:SetSize(80, 25)
    self.startPauseButton:SetPoint("BOTTOMLEFT", 20, 20)
    self.startPauseButton:SetText("Start")
    self.startPauseButton:SetScript("OnClick", function() SimpleTimer:ToggleTimer() end)

    -- Reset button
    self.resetButton = CreateFrame("Button", nil, self.frame, "GameMenuButtonTemplate")
    self.resetButton:SetSize(80, 25)
    self.resetButton:SetPoint("BOTTOMRIGHT", -20, 20)
    self.resetButton:SetText("Reset")
    self.resetButton:SetScript("OnClick", function() SimpleTimer:ResetTimer() end)

    -- Hide the frame initially
    self.frame:Hide()
end

-- Format time as MM:SS
function SimpleTimer:FormatTime(seconds)
    local minutes = math.floor(seconds / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d", minutes, secs)
end

-- Update timer display
function SimpleTimer:UpdateDisplay()
    if self.remainingTime > 0 then
        self.timerDisplay:SetText(self:FormatTime(self.remainingTime))
    else
        self.timerDisplay:SetText("00:00")
    end
end

-- Start the timer
function SimpleTimer:StartTimer()
    local duration = tonumber(self.durationInput:GetText())
    if not duration or duration <= 0 then
        print("SimpleTimer: Please enter a valid duration in minutes.")
        return
    end

    self.totalTime = duration * 60 -- Convert to seconds
    self.remainingTime = self.totalTime
    self.startTime = GetTime()
    self.isRunning = true
    self.startPauseButton:SetText("Pause")
    self:UpdateDisplay()
end

-- Pause the timer
function SimpleTimer:PauseTimer()
    if self.isRunning then
        -- Calculate remaining time when paused
        local elapsed = GetTime() - self.startTime
        self.remainingTime = math.max(0, self.remainingTime - elapsed)
        self.isRunning = false
        self.startPauseButton:SetText("Resume")
    end
end

-- Resume the timer
function SimpleTimer:ResumeTimer()
    if not self.isRunning and self.remainingTime > 0 then
        self.startTime = GetTime()
        self.isRunning = true
        self.startPauseButton:SetText("Pause")
    end
end

-- Reset the timer
function SimpleTimer:ResetTimer()
    self.isRunning = false
    self.remainingTime = 0
    self.startTime = 0
    self.startPauseButton:SetText("Start")
    self:UpdateDisplay()
end

-- Toggle timer (start/pause/resume)
function SimpleTimer:ToggleTimer()
    if not self.isRunning then
        if self.remainingTime > 0 then
            self:ResumeTimer()
        else
            self:StartTimer()
        end
    else
        self:PauseTimer()
    end
end

-- Update timer on each frame
function SimpleTimer:OnUpdate()
    if self.isRunning then
        local elapsed = GetTime() - self.startTime
        local newRemaining = math.max(0, self.remainingTime - elapsed)

        if newRemaining ~= self.remainingTime then
            self.remainingTime = newRemaining
            self:UpdateDisplay()

            -- Check if timer finished
            if self.remainingTime <= 0 then
                self:TimerFinished()
            end
        end
    end
end

-- Handle timer completion
function SimpleTimer:TimerFinished()
    self.isRunning = false
    self.startPauseButton:SetText("Start")
    self.timerDisplay:SetText("00:00")

    -- Play sound or show notification
    PlaySound(8960, "Master")

    -- You could add more notification options here
    print("SimpleTimer: Timer finished!")
end

-- Toggle the timer window
function SimpleTimer:ToggleWindow()
    if self.frame:IsShown() then
        self.frame:Hide()
    else
        self.frame:Show()
    end
end

-- Initialize the addon
function SimpleTimer:Initialize()
    self:CreateFrame()

    -- Register slash commands
    SLASH_SIMPLETIMER1 = "/timer"
    SLASH_SIMPLETIMER2 = "/simpletimer"
    SlashCmdList["SIMPLETIMER"] = function() self:ToggleWindow() end

    -- Set up update handler
    self.frame:SetScript("OnUpdate", function() self:OnUpdate() end)

    print("SimpleTimer loaded! Use /timer to toggle the timer window.")
end

-- Event handler
local function OnEvent(self, event, ...)
    if event == "ADDON_LOADED" and ... == "SimpleTimer" then
        SimpleTimer:Initialize()
    end
end

-- Register events
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", OnEvent)