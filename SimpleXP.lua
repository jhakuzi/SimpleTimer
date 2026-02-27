local addonName, SimpleTimer = ...

local GetTime = GetTime
local UnitXP = UnitXP
local UnitXPMax = UnitXPMax

-- XP Tracker state
SimpleTimer.xpRunning = false
SimpleTimer.xpStartTime = 0
SimpleTimer.xpElapsedAtPause = 0
SimpleTimer.xpStartValue = 0
SimpleTimer.xpMaxAtStart = 0
SimpleTimer.xpGained = 0

function SimpleTimer:CreateSimpleXPUI(parent)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetAllPoints()

    -- XP Gained Display
    local gainedLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    gainedLabel:SetPoint("TOP", 0, -10)
    gainedLabel:SetText("XP Gained:")

    self.xpGainedDisplay = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    self.xpGainedDisplay:SetPoint("TOP", 0, -25)
    self.xpGainedDisplay:SetText("0")

    -- XP/hr Display
    local xpPerHourLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    xpPerHourLabel:SetPoint("TOP", 0, -45)
    xpPerHourLabel:SetText("XP/hr:")

    self.xpPerHourDisplay = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    self.xpPerHourDisplay:SetPoint("TOP", 0, -60)
    self.xpPerHourDisplay:SetText("0")
    
    -- Time to level display
    self.xpTimeToLevelDisplay = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    self.xpTimeToLevelDisplay:SetPoint("TOP", 0, -80)
    self.xpTimeToLevelDisplay:SetText("TTL: --:--:--")

    -- Elapsed Time Display
    self.xpElapsedDisplay = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    self.xpElapsedDisplay:SetPoint("TOP", 0, -100)
    self.xpElapsedDisplay:SetText("Elapsed: 00:00:00")

    -- Start/Pause Button
    self.xpStartPauseButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    self.xpStartPauseButton:SetSize(80, 25)
    self.xpStartPauseButton:SetPoint("BOTTOMLEFT", 10, 10)
    self.xpStartPauseButton:SetText("Start")
    self.xpStartPauseButton:SetScript("OnClick", function() SimpleTimer:ToggleXPTracker() end)

    -- Reset Button
    self.xpResetButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    self.xpResetButton:SetSize(80, 25)
    self.xpResetButton:SetPoint("BOTTOMRIGHT", -10, 10)
    self.xpResetButton:SetText("Reset")
    self.xpResetButton:SetScript("OnClick", function() SimpleTimer:ResetXPTracker() end)

    -- Events
    frame:RegisterEvent("PLAYER_XP_UPDATE")
    frame:SetScript("OnEvent", function(self, event, ...)
        if event == "PLAYER_XP_UPDATE" then
            SimpleTimer:OnXPUpdate()
        end
    end)

    return frame
end

function SimpleTimer:ToggleXPTracker()
    if self.xpRunning then
        self:PauseXPTracker()
    else
        self:StartXPTracker()
    end
end

function SimpleTimer:StartXPTracker()
    if not self.xpRunning then
        self.xpStartTime = GetTime()
        self.xpStartValue = UnitXP("player") or 0
        self.xpMaxAtStart = UnitXPMax("player") or 1
        self.xpRunning = true
        self.xpStartPauseButton:SetText("Pause")
        self:SaveVariables()
    end
end

function SimpleTimer:PauseXPTracker()
    if self.xpRunning then
        self.xpElapsedAtPause = self.xpElapsedAtPause + (GetTime() - self.xpStartTime)
        self.xpRunning = false
        self.xpStartPauseButton:SetText("Resume")
        self:SaveVariables()
    end
end

function SimpleTimer:ResetXPTracker()
    self.xpRunning = false
    self.xpStartTime = 0
    self.xpElapsedAtPause = 0
    self.xpStartValue = 0
    self.xpMaxAtStart = 0
    self.xpGained = 0
    self.xpStartPauseButton:SetText("Start")
    self.xpGainedDisplay:SetText("0")
    self.xpPerHourDisplay:SetText("0")
    self.xpTimeToLevelDisplay:SetText("TTL: --:--:--")
    self.xpElapsedDisplay:SetText("Elapsed: 00:00:00")
    self:SaveVariables()
end

function SimpleTimer:OnXPUpdate()
    if self.xpRunning then
        local currentXP = UnitXP("player") or 0
        local maxXP = UnitXPMax("player") or 1
        
        if currentXP < self.xpStartValue or maxXP > self.xpMaxAtStart then
            -- We probably leveled up
            self.xpGained = self.xpGained + (self.xpMaxAtStart - self.xpStartValue) + currentXP
        else
            self.xpGained = self.xpGained + (currentXP - self.xpStartValue)
        end
        
        self.xpStartValue = currentXP
        self.xpMaxAtStart = maxXP
        
        self.xpGainedDisplay:SetText(tostring(self.xpGained))
        -- Save optionally, but skip frequently. Wait till close/pause.
    end
end

function SimpleTimer:FormatElapsedTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

function SimpleTimer:UpdateXPTracker()
    local elapsed = self.xpElapsedAtPause
    if self.xpRunning then
        elapsed = elapsed + (GetTime() - self.xpStartTime)
    end
    
    self.xpElapsedDisplay:SetText("Elapsed: " .. self:FormatElapsedTime(math.floor(elapsed)))
    
    if elapsed > 0 then
        local xpPerHour = math.floor((self.xpGained / elapsed) * 3600)
        self.xpPerHourDisplay:SetText(tostring(xpPerHour))
        
        if xpPerHour > 0 then
            local currentXP = UnitXP("player") or 0
            local maxXP = UnitXPMax("player") or 1
            local xpNeeded = maxXP - currentXP
            if xpNeeded > 0 then
                local secondsToLevel = (xpNeeded / xpPerHour) * 3600
                self.xpTimeToLevelDisplay:SetText("TTL: " .. self:FormatElapsedTime(math.floor(secondsToLevel)))
            else
                self.xpTimeToLevelDisplay:SetText("TTL: 00:00:00")
            end
        else
            self.xpTimeToLevelDisplay:SetText("TTL: --:--:--")
        end
    else
        self.xpPerHourDisplay:SetText("0")
        self.xpTimeToLevelDisplay:SetText("TTL: --:--:--")
    end
end
