-- SpawnCoinCharacterExample.lua
-- This script spawns a character and coins in a game environment and handles coin collection.

-- Define the game world
local GameWorld = {
    characters = {},
    coins = {},
    coinCount = 10,
    characterStartPosition = {x = 0, y = 0},
    coinSpawnRange = {x = 100, y = 100}
}

-- Utility function to generate a random position
local function getRandomPosition(range)
    return {
        x = math.random(-range.x, range.x),
        y = math.random(-range.y, range.y)
    }
end

-- Character class
local Character = {}
Character.__index = Character

function Character:new(name, position)
    local character = setmetatable({}, Character)
    character.name = name
    character.position = position or {x = 0, y = 0}
    character.coinsCollected = 0
    return character
end

function Character:move(newPosition)
    self.position = newPosition
    print(self.name .. " moved to (" .. newPosition.x .. ", " .. newPosition.y .. ")")
end

function Character:collectCoin(coin)
    self.coinsCollected = self.coinsCollected + 1
    print(self.name .. " collected a coin! Total coins: " .. self.coinsCollected)
    coin.collected = true
end

-- Coin class
local Coin = {}
Coin.__index = Coin

function Coin:new(position)
    local coin = setmetatable({}, Coin)
    coin.position = position
    coin.collected = false
    return coin
end

-- Spawn coins in the game world
function GameWorld:spawnCoins()
    for i = 1, self.coinCount do
        local position = getRandomPosition(self.coinSpawnRange)
        local coin = Coin:new(position)
        table.insert(self.coins, coin)
        print("Spawned a coin at (" .. position.x .. ", " .. position.y .. ")")
    end
end

-- Spawn a character in the game world
function GameWorld:spawnCharacter(name)
    local character = Character:new(name, self.characterStartPosition)
    table.insert(self.characters, character)
    print("Spawned character '" .. name .. "' at (" .. self.characterStartPosition.x .. ", " .. self.characterStartPosition.y .. ")")
    return character
end

-- Check for collisions between a character and coins
function GameWorld:checkCollisions(character)
    for _, coin in ipairs(self.coins) do
        if not coin.collected and character.position.x == coin.position.x and character.position.y == coin.position.y then
            character:collectCoin(coin)
        end
    end
end

-- Example usage
GameWorld:spawnCoins()
local player = GameWorld:spawnCharacter("Player1")

-- Simulate character movements
local moves = {
    {x = 10, y = 20},
    {x = -15, y = 30},
    {x = 25, y = -10},
    {x = 0, y = 0}
}

for _, move in ipairs(moves) do
    player:move(move)
    GameWorld:checkCollisions(player)
end

-- Show final coin count
print(player.name .. " collected a total of " .. player.coinsCollected .. " coins!")
