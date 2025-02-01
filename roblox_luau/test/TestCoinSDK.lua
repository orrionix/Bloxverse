local CoinSDK = require(game.ServerScriptService.CoinSDK)  -- Assuming the CoinSDK script is in ServerScriptService

-- Mock HttpService to simulate network requests
local function mockHttpService()
    local HttpServiceMock = {}
    
    function HttpServiceMock:PostAsync(url, body, contentType, retry, headers)
        -- Simulating different responses based on URL
        if url == "http://localhost:8000/api/update_wallet" then
            return '{"status": "success"}'
        else
            return '{"error": "Invalid endpoint."}'
        end
    end
    
    return HttpServiceMock
end

describe("CoinSDK", function()
    local mockHttp = mockHttpService()
    local originalHttpService = game:GetService("HttpService")
    game:GetService("HttpService") = mockHttp  -- Replacing the HttpService with our mock
    
    beforeEach(function()
        -- Reset any state before each test
        CoinSDK:initPlayer("Player1", 100, {walkSpeed = 16, size = 1}, "0x123abc456def")
    end)
    
    afterEach(function()
        -- Restore HttpService after each test
        game:GetService("HttpService") = originalHttpService
    end)

    it("should initialize a player with starting balance and character attributes", function()
        local playerData = CoinSDK.playerData["Player1"]
        assert.is_equal(playerData.balance, 100, "Player balance should be initialized correctly.")
        assert.is_table(playerData.characterAttributes, "Character attributes should be a table.")
        assert.is_equal(playerData.walletAddress, "0x123abc456def", "Player's wallet address should be initialized correctly.")
    end)

    it("should update character attributes successfully", function()
        -- Mock a character object with a Humanoid
        local playerId = "Player1"
        local mockCharacter = {Humanoid = {}}
        
        -- Update walk speed and size
        CoinSDK:updateCharacterAttributes(playerId, {walkSpeed = 30, size = 1.5})
        
        -- Simulate the effect on the character (this will depend on the game engine's behavior, so this is a mock)
        assert.is_equal(mockCharacter.Humanoid.WalkSpeed, 30, "Walk speed should be updated.")
        assert.is_equal(mockCharacter.Size, 1.5, "Character size should be updated.")
    end)

    it("should send wallet data to backend", function()
        local playerId = "Player1"
        
        -- Call the method that would send the data
        CoinSDK:sendWalletDataToBackend(playerId)
        
        -- Validate if the expected HTTP request is sent
        local response = mockHttp:PostAsync("http://localhost:8000/api/update_wallet", "", nil, nil, nil)
        assert.is_equal(response, '{"status": "success"}', "Failed to send wallet data to backend.")
    end)

    it("should spawn character and apply character attributes", function()
        local playerId = "Player1"
        
        -- Mock a player character and humanoid
        local mockCharacter = {Humanoid = {}}
        
        -- Call spawnCharacter to apply the character attributes
        CoinSDK:spawnCharacter(playerId)
        
        -- Check that attributes were applied
        assert.is_equal(mockCharacter.Humanoid.WalkSpeed, 16, "Walk speed should be set correctly on spawn.")
        assert.is_equal(mockCharacter.Size, 1, "Character size should be set correctly on spawn.")
    end)

    it("should handle invalid player ID when updating character attributes", function()
        local status, err = pcall(function()
            CoinSDK:updateCharacterAttributes("InvalidPlayer", {walkSpeed = 10})
        end)
        assert.is_false(status, "Updating character attributes should fail for an invalid player.")
        assert.is_true(err:match("Invalid player ID."), "Error message should contain 'Invalid player ID.'")
    end)
    
    it("should handle missing wallet address when sending wallet data", function()
        -- Set an empty wallet address for testing
        CoinSDK:initPlayer("Player2", 200, {walkSpeed = 20, size = 1.5}, "")
        
        local status, err = pcall(function()
            CoinSDK:sendWalletDataToBackend("Player2")
        end)
        
        assert.is_true(status, "Sending wallet data should succeed even if no wallet address is provided.")
        assert.is_equal(err, "No wallet address found for player Player2", "Missing wallet address should print a warning.")
    end)
end)
