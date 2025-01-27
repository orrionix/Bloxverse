-- AiIntegration.lua
-- This script integrates AI functionality into a game or application using an AI service

-- Required services or modules
local HttpService = game:GetService("HttpService")
local AiIntegration = {}

-- Configuration for AI service
local AI_API_URL = "https://example-ai-service.com/api"  -- Replace with your actual API endpoint
local API_KEY = "your-api-key"  -- Replace with your actual API key

-- Function to send a request to the AI API
local function sendRequest(endpoint, payload)
    local url = AI_API_URL .. endpoint

    local headers = {
        ["Content-Type"] = "application/json",
        ["Authorization"] = "Bearer " .. API_KEY
    }

    local requestBody = HttpService:JSONEncode(payload)

    local success, response = pcall(function()
        return HttpService:PostAsync(url, requestBody, Enum.HttpContentType.ApplicationJson, false, headers)
    end)

    if success then
        return HttpService:JSONDecode(response)
    else
        warn("AI API Request Failed: " .. tostring(response))
        return nil
    end
end

-- Initialize the AI Integration
function AiIntegration:init()
    print("Initializing AI Integration...")
    -- Optional: Perform any setup or health check for the AI service
    local healthCheck = sendRequest("/health", {})
    if healthCheck and healthCheck.status == "ok" then
        print("AI Service is online.")
    else
        warn("Failed to connect to AI Service.")
    end
end

-- Generate NPC responses using AI
function AiIntegration:generateNpcResponse(prompt)
    if not prompt or prompt == "" then
        return "Invalid prompt provided."
    end

    local payload = {
        prompt = prompt,
        max_tokens = 100  -- Limit response length
    }

    local response = sendRequest("/generate-response", payload)
    if response and response.text then
        print("AI Response: " .. response.text)
        return response.text
    else
        return "Failed to generate response."
    end
end

-- Recommend game actions using AI
function AiIntegration:recommendAction(gameState)
    if not gameState then
        return "Invalid game state provided."
    end

    local payload = {
        state = gameState
    }

    local response = sendRequest("/recommend-action", payload)
    if response and response.action then
        print("Recommended Action: " .. response.action)
        return response.action
    else
        return "Failed to recommend action."
    end
end

-- Example Usage
AiIntegration:init()

-- Example 1: Generate an NPC response
local npcPrompt = "What is the best way to find treasure in this game?"
local npcResponse = AiIntegration:generateNpcResponse(npcPrompt)
print("NPC says: " .. npcResponse)

-- Example 2: Recommend an action based on game state
local gameState = {
    playerHealth = 80,
    nearbyEnemies = 3,
    availableResources = {"Health Potion", "Sword"}
}
local recommendedAction = AiIntegration:recommendAction(gameState)
print("AI suggests: " .. recommendedAction)

return AiIntegration
