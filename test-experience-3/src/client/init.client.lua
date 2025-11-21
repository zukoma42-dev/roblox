print("Client bootstrap script running...")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.AddControllers(script.Controllers)

Knit.Start():andThen(function()
	print("Knit Client Started")
end):catch(warn)
