local AiIntegration = require(game.ServerScriptService.AiIntegration)  -- Assuming the AiIntegration script is in ServerScriptService

local function mockHttpService()
    local HttpServiceMock = {}
    
    function HttpServiceMock:PostAsync(url, body, contentType, retry, headers)
        -- Mock the response based on the URL requested
        if url == "https://example-ai-service.com/api/health" then
            return '{"status": "ok"}'
        elseif url == "https://example-ai-service.com/api/generate-response" then
            return '{"text": "The best way to find treasure is by exploring hidden caves."}'
        elseif url == "https://example-ai-service.com/api/recommend-action" then
            return '{"action": "Attack the nearest enemy."}'
        else
            return '{"error": "Invalid endpoint."}'
        end
    end
    
    return HttpServiceMock
end

describe("AiIntegration", function()
    local mockHttp = mockHttpService()
    local originalHttpService = game:GetService("HttpService")
    game:GetService("HttpService") = mockHttp  -- Replacing the HttpService with our mock
    
    beforeEach(function()
        -- Reset any state before each test
        AiIntegration:init()
    end)
    
    afterEach(function()
        -- Restore HttpService after each test
        game:GetService("HttpService") = originalHttpService
    end)

    it("should initialize AI Integration successfully", function()
        -- The test here would ensure that the connection to the AI service works.
        local healthCheck = mockHttp:PostAsync("https://example-ai-service.com/api/health", {}, nil, nil, nil)
        assert.equal(healthCheck, '{"status": "ok"}', "Failed to initialize AI service.")
    end)

    it("should return valid NPC response", function()
        local prompt = "What is the best way to find treasure in this game?"
        local npcResponse = AiIntegration:generateNpcResponse(prompt)
        
        assert.is_equal(npcResponse, "The best way to find treasure is by exploring hidden caves.", "NPC response was incorrect.")
    end)

    it("should return default response if no prompt is provided for NPC", function()
        local npcResponse = AiIntegration:generateNpcResponse("")
        
        assert.is_equal(npcResponse, "Invalid prompt provided.", "Empty prompt should return 'Invalid prompt provided.'")
    end)

    it("should recommend a valid action based on game state", function()
        local gameState = {
            playerHealth = 80,
            nearbyEnemies = 3,
            availableResources = {"Health Potion", "Sword"}
        }
        local recommendedAction = AiIntegration:recommendAction(gameState)
        
        assert.is_equal(recommendedAction, "Attack the nearest enemy.", "AI recommendation was incorrect.")
    end)

    it("should return default response if no game state is provided", function()
        local recommendedAction = AiIntegration:recommendAction(nil)
        
        assert.is_equal(recommendedAction, "Invalid game state provided.", "Empty game state should return 'Invalid game state provided.'")
    end)
end)
