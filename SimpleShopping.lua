local addonName, SimpleTools = ...

-- Localize WoW API for performance
local CreateFrame = CreateFrame
local GetItemInfo = GetItemInfo or C_Item and C_Item.GetItemInfo

-- Create the Shopping List UI
function SimpleTools:CreateSimpleShoppingUI(parent)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetAllPoints()

    -- Title/Status
    local statusText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    statusText:SetPoint("TOP", 0, 0)
    statusText:SetText("Shopping List (Crafting Orders)")

    -- List container
    self.shoppingListContainer = CreateFrame("Frame", nil, frame)
    self.shoppingListContainer:SetPoint("TOPLEFT", 10, -20)
    self.shoppingListContainer:SetPoint("BOTTOMRIGHT", -10, 30)

    -- Reagent lines
    self.shoppingLines = {}
    for i = 1, 8 do
        local line = self.shoppingListContainer:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        if i == 1 then
            line:SetPoint("TOPLEFT", 5, -5)
        else
            line:SetPoint("TOPLEFT", self.shoppingLines[i - 1], "BOTTOMLEFT", 0, -5)
        end
        line:SetJustifyH("LEFT")
        line:SetText("")
        self.shoppingLines[i] = line
    end

    -- Add current order button
    self.shoppingAddButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    self.shoppingAddButton:SetSize(130, 25)
    self.shoppingAddButton:SetPoint("BOTTOMLEFT", 10, 0)
    self.shoppingAddButton:SetText("Add Open Order")
    self.shoppingAddButton:SetScript("OnClick", function() SimpleTools:AddOpenCraftingOrder() end)

    -- Clear button
    self.shoppingClearButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    self.shoppingClearButton:SetSize(80, 25)
    self.shoppingClearButton:SetPoint("BOTTOMRIGHT", -10, 0)
    self.shoppingClearButton:SetText("Clear List")
    self.shoppingClearButton:SetScript("OnClick", function() SimpleTools:ClearShoppingList() end)

    -- Initialize display
    self.shoppingFrame = frame
    frame:SetScript("OnShow", function() SimpleTools:UpdateShoppingDisplay() end)

    return frame
end

function SimpleTools:UpdateShoppingDisplay()
    -- Clear all lines
    for i = 1, #self.shoppingLines do
        self.shoppingLines[i]:SetText("")
    end

    if not self.shoppingList or #self.shoppingList == 0 then
        self.shoppingLines[1]:SetText("List is empty.")
        return
    end

    for i, itemDetail in ipairs(self.shoppingList) do
        if i <= #self.shoppingLines then
            local itemName = itemDetail.name
            if not itemName or itemName:find("^Item ") then
                -- Try to update name if it was missing
                if GetItemInfo then
                    local infoName = GetItemInfo(itemDetail.itemID)
                    if infoName then
                        itemName = infoName
                        itemDetail.name = itemName
                    end
                end
            end
            self.shoppingLines[i]:SetText("- " .. itemDetail.quantity .. "x " .. (itemName or "Unknown Item"))
        end
    end
end

function SimpleTools:ClearShoppingList()
    self.shoppingList = {}
    self:SaveVariables()
    self:UpdateShoppingDisplay()
    print("SimpleTools: Shopping list cleared.")
end

function SimpleTools:AddOpenCraftingOrder()
    -- Check if ProfessionsFrame is open and has an active order
    if not ProfessionsFrame or not ProfessionsFrame.OrdersPage or not ProfessionsFrame.OrdersPage:IsVisible() then
        print("SimpleTools: No crafting order page is currently open.")
        return
    end

    local order = ProfessionsFrame.OrdersPage.OrderView.order
    if not order then
        print("SimpleTools: No crafting order selected.")
        return
    end

    local addedItems = 0
    if order.reagents and type(order.reagents) == "table" then
        for _, reagentInfo in ipairs(order.reagents) do
            -- Enum.CraftingOrderReagentSource.Customer is usually 0
            if reagentInfo.source ~= Enum.CraftingOrderReagentSource.Customer then
                local quantityNeeded = reagentInfo.quantity
                local itemID = reagentInfo.reagent.itemID
                local itemName = "Item " .. tostring(itemID)

                if itemID and GetItemInfo then
                    local infoName = GetItemInfo(itemID)
                    if infoName then
                        itemName = infoName
                    end
                end

                if itemID and quantityNeeded and quantityNeeded > 0 then
                    -- Add to our shopping list, check if it already exists to combine
                    local found = false
                    for _, existing in ipairs(self.shoppingList) do
                        if existing.itemID == itemID then
                            existing.quantity = existing.quantity + quantityNeeded
                            found = true
                            break
                        end
                    end

                    if not found then
                        table.insert(self.shoppingList, {
                            itemID = itemID,
                            name = itemName,
                            quantity = quantityNeeded
                        })
                    end
                    addedItems = addedItems + 1
                end
            end
        end
    else
        print("SimpleTools: Could not read reagents for this order.")
        return
    end

    if addedItems > 0 then
        print("SimpleTools: Added " .. addedItems .. " reagents to shopping list.")
        self:SaveVariables()
        self:UpdateShoppingDisplay()
    else
        print("SimpleTools: Order requires no reagents from you.")
    end
end
