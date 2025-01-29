local EventActions = {}
EventActions.__index = EventActions

-- Constructor for creating a new EventActions instance
function EventActions.new()
    local self = setmetatable({}, EventActions)
    self.actions = {}
    return self
end

-- Register a new action for a specific event
function EventActions:registerAction(eventName, actionFunction)
    if not self.actions[eventName] then
        self.actions[eventName] = {}
    end
    table.insert(self.actions[eventName], actionFunction)
end

-- Trigger an event and execute all associated actions
function EventActions:triggerEvent(eventName, ...)
    if self.actions[eventName] then
        for _, action in ipairs(self.actions[eventName]) do
            action(...)
        end
    end
end

-- Example of attaching default actions
function EventActions:attachDefaultActions(character)
    self:registerAction("Jump", function()
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.Jump = true
        end
    end)
    
    self:registerAction("Dance", function()
        if character and character:FindFirstChild("Humanoid") then
            print(character.Name .. " is dancing!")
        end
    end)
end

return EventActions
