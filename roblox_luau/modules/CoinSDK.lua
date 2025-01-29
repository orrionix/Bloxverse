-- CoinSDK.lua
-- This script provides functionality for managing a virtual coin system and applying character attributes

local CoinSDK = {}
local playerData = {} -- A table to store player coin data (in a real application, use a database or persistent storage)
local HttpService = game:GetService("HttpService") -- Use HttpService to send HTTP requests

-- Initialize a player with a starting balance and character attributes
function CoinSDK:initPlayer(playerId, startingBalance, characterAttributes, walletAddress)
    if not playerId then
        error("Player ID is required.")
    end
    if playerData[playerId] == nil then
        playerData[playerId] = {
            balance = startingBalance or 0,
            transactionHistory = {},
            characterAttributes = characterAttributes or {},
            walletAddress = walletAddress or "" -- Store the wallet address
        }
        print("Initialized player " .. playerId .. " with balance: " .. playerData[playerId].balance)
    else
        print("Player " .. playerId .. " is already initialized.")
    end
end

-- Update or apply character attributes like speed or size
function CoinSDK:updateCharacterAttributes(playerId, attributes)
    if not playerId or not playerData[playerId] then
        error("Invalid player ID.")
    end

    -- Apply the new attributes to the player character
    local character = game.Players:FindFirstChild(playerId) and game.Players[playerId].Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            if attributes.walkSpeed then
                humanoid.WalkSpeed = attributes.walkSpeed
            end
            if attributes.size then
                character:SetPrimaryPartCFrame(character.PrimaryPart.CFrame * CFrame.new(0, attributes.size, 0))
                -- Scaling the character's size
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("MeshPart") then
                        part.Size = part.Size * attributes.size
                    end
                end
            end
        end
    else
        print("Character not found for player " .. playerId)
    end
end

-- Function to send wallet address and character data to the backend
function CoinSDK:sendWalletDataToBackend(playerId)
    local player = playerData[playerId]
    if not player then
        error("Player not found.")
    end

    local walletAddress = player.walletAddress
    if not walletAddress or walletAddress == "" then
        print("No wallet address found for player " .. playerId)
        return
    end

    -- Prepare the data for the HTTP request
    local requestData = {
        wallet_address = walletAddress,
        player_id = playerId,
        balance = player.balance
    }

    local url = "http://localhost:8000/api/update_wallet" -- Replace with your backend URL
    local headers = {
        ["Content-Type"] = "application/json"
    }

    local response
    -- Send the HTTP request to the backend
    pcall(function()
        response = HttpService:PostAsync(url, HttpService:JSONEncode(requestData), Enum.HttpContentType.ApplicationJson, false, headers)
        print("Sent wallet data to backend for player " .. playerId)
    end)

    if response then
        print("Backend response: " .. response)
    end
end

-- Function to spawn or respawn a character with attributes
function CoinSDK:spawnCharacter(playerId)
    if not playerId or not playerData[playerId] then
        error("Invalid player ID.")
    end

    local characterAttributes = playerData[playerId].characterAttributes
    local player = game.Players:FindFirstChild(playerId)
    
    if player then
        local character = player.Character or player:LoadCharacter() -- Load the character if not already loaded
        character:WaitForChild("Humanoid") -- Wait for the humanoid to be ready
        
        -- Apply character attributes
        self:updateCharacterAttributes(playerId, characterAttributes)

        -- Send wallet data to the backend
        self:sendWalletDataToBackend(playerId)

        print("Character for player " .. playerId .. " has been spawned with updated attributes.")
    else
        print("Player not found.")
    end
end

-- Example usage
-- Initialize players with character attributes and wallet address
CoinSDK:initPlayer("Player1", 100, {walkSpeed = 16, size = 1}, "0x123abc456def")  -- Default walk speed, size, and wallet address
CoinSDK:initPlayer("Player2", 200, {walkSpeed = 20, size = 1.5}, "0x789ghi012jkl") -- Faster and larger player with a wallet address

-- Spawn players with their character attributes
CoinSDK:spawnCharacter("Player1") -- Apply attributes and send wallet data for Player1
CoinSDK:spawnCharacter("Player2") -- Apply attributes and send wallet data for Player2

return CoinSDK
