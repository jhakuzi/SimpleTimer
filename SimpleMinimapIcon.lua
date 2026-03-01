local addonName, SimpleTimer = ...

local minimapButton = CreateFrame("Button", "SimpleTimerMinimapButton", Minimap)
minimapButton:SetSize(31, 31)
minimapButton:SetFrameStrata("MEDIUM")
minimapButton:SetFrameLevel(8)

minimapButton:RegisterForDrag("LeftButton")
minimapButton:RegisterForClicks("AnyUp")

local icon = minimapButton:CreateTexture(nil, "BACKGROUND")
icon:SetTexture("Interface\\Icons\\spell_mage_altertime")
icon:SetSize(21, 21)
icon:SetPoint("CENTER")

local border = minimapButton:CreateTexture(nil, "OVERLAY")
border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
border:SetSize(53, 53)
border:SetPoint("TOPLEFT")

minimapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

local function UpdatePosition()
    if not SimpleTimerDB then return end
    SimpleTimerDB.minimap = SimpleTimerDB.minimap or { minimapPos = 45 }
    local angle = math.rad(SimpleTimerDB.minimap.minimapPos or 45)
    local x = math.cos(angle) * 80
    local y = math.sin(angle) * 80
    
    minimapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

minimapButton:SetScript("OnDragStart", function(self)
    self:LockHighlight()
    self:SetScript("OnUpdate", function(self)
        local cx, cy = GetCursorPosition()
        local left, bottom = Minimap:GetLeft(), Minimap:GetBottom()
        local scale = Minimap:GetEffectiveScale()
        
        local mw, mh = Minimap:GetWidth() * scale, Minimap:GetHeight() * scale
        local mx, my = left * scale, bottom * scale
        local mxC, myC = mx + mw/2, my + mh/2
        
        local dx, dy = cx - mxC, cy - myC
        local angle = math.deg(math.atan2(dy, dx))
        if angle < 0 then angle = angle + 360 end
        
        SimpleTimerDB.minimap = SimpleTimerDB.minimap or {}
        SimpleTimerDB.minimap.minimapPos = angle
        UpdatePosition()
    end)
end)

minimapButton:SetScript("OnDragStop", function(self)
    self:SetScript("OnUpdate", nil)
    self:UnlockHighlight()
end)

minimapButton:SetScript("OnClick", function(self, button)
    if button == "LeftButton" then
        SimpleTimer:ToggleWindow()
    end
end)

minimapButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("SimpleTimer")
    GameTooltip:AddLine("Left-Click to toggle window.", 1, 1, 1)
    GameTooltip:AddLine("Drag to move.", 1, 1, 1)
    GameTooltip:Show()
end)

minimapButton:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

function SimpleTimer:InitializeMinimapIcon()
    UpdatePosition()
end
