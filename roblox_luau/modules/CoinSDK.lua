-- CoinSDK.lua
-- This script provides functionality for managing a virtual coin system

local CoinSDK = {}
local playerData = {} -- A table to store player coin data (in a real application, use a database or persistent storage)

-- Initialize a player with a starting balance
function CoinSDK:initPlayer(playerId, startingBalance)
    if not playerId then
        error("Player ID is required.")
    end
    if playerData[playerId] == nil then
        playerData[playerId] = {
            balance = startingBalance or 0,
            transactionHistory = {}
        }
        print("Initialized player " .. playerId .. " with balance: " .. playerData[playerId].balance)
    else
        print("Player " .. playerId .. " is already initialized.")
    end
end

-- Get the balance of a player
function CoinSDK:getBalance(playerId)
    if not playerId or not playerData[playerId] then
        error("Invalid player ID.")
    end
    return playerData[playerId].balance
end

-- Add coins to a player's account
function CoinSDK:addCoins(playerId, amount, reason)
    if not playerId or not playerData[playerId] then
        error("Invalid player ID.")
    end
    if amount <= 0 then
        error("Amount must be greater than zero.")
    end

    playerData[playerId].balance = playerData[playerId].balance + amount
    table.insert(playerData[playerId].transactionHistory, {
        type = "credit",
        amount = amount,
        reason = reason or "No reason provided",
        timestamp = os.time()
    })
    print("Added " .. amount .. " coins to player " .. playerId .. ". New balance: " .. playerData[playerId].balance)
end

-- Deduct coins from a player's account
function CoinSDK:deductCoins(playerId, amount, reason)
    if not playerId or not playerData[playerId] then
        error("Invalid player ID.")
    end
    if amount <= 0 then
        error("Amount must be greater than zero.")
    end
    if playerData[playerId].balance < amount then
        error("Insufficient balance for player " .. playerId)
    end

    playerData[playerId].balance = playerData[playerId].balance - amount
    table.insert(playerData[playerId].transactionHistory, {
        type = "debit",
        amount = amount,
        reason = reason or "No reason provided",
        timestamp = os.time()
    })
    print("Deducted " .. amount .. " coins from player " .. playerId .. ". New balance: " .. playerData[playerId].balance)
end

-- Get a player's transaction history
function CoinSDK:getTransactionHistory(playerId)
    if not playerId or not playerData[playerId] then
        error("Invalid player ID.")
    end
    return playerData[playerId].transactionHistory
end

-- Example usage
-- Initialize players
CoinSDK:initPlayer("Player1", 100)
CoinSDK:initPlayer("Player2", 200)

-- Add coins
CoinSDK:addCoins("Player1", 50, "Daily reward")
CoinSDK:addCoins("Player2", 100, "Level up bonus")

-- Deduct coins
CoinSDK:deductCoins("Player1", 30, "Purchase item")
CoinSDK:deductCoins("Player2", 50, "Entry fee")

-- Get balances
print("Player1 Balance: " .. CoinSDK:getBalance("Player1"))
print("Player2 Balance: " .. CoinSDK:getBalance("Player2"))

-- Get transaction history
local player1History = CoinSDK:getTransactionHistory("Player1")
print("Player1 Transaction History:")
for _, transaction in ipairs(player1History) do
    print(transaction.type .. ": " .. transaction.amount .. " (" .. transaction.reason .. ") at " .. os.date("%Y-%m-%d %H:%M:%S", transaction.timestamp))
end

return CoinSDK
