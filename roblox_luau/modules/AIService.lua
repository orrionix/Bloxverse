local HttpService = game:GetService("HttpService")

local AIService = {}

function AIService.GenerateScript(prompt)
    local apiUrl = "https://api.example.com/generate" -- Replace with actual AI API
    local requestData = { prompt = prompt, max_tokens = 300 }
    local jsonRequest = HttpService:JSONEncode(requestData)

    local response = HttpService:PostAsync(apiUrl, jsonRequest, Enum.HttpContentType.ApplicationJson)
    local result = HttpService:JSONDecode(response)

    return result.generated_script
end

return AIService
