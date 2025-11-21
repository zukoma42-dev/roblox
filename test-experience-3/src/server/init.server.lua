print("Server bootstrap script running...")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.AddServices(script.Services)

Knit.Start():andThen(function()
	print("Knit Server Started")
end):catch(warn)
