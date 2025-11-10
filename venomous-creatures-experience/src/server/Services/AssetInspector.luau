-- アセット構造を確認するサービス
-- このファイルはServerScriptService.Server.Servicesに配置されます

local ServerStorage = game:GetService("ServerStorage")

local AssetInspector = {}

-- アセットの構造を詳細に出力
function AssetInspector:inspectModel(modelName: string)
	local model = ServerStorage:FindFirstChild(modelName)
	
	if not model then
		warn("Model not found:", modelName)
		return
	end
	
	print("=== Asset Inspection: " .. modelName .. " ===")
	print("Model Type:", model.ClassName)
	
	-- すべての子要素を確認
	local function inspectInstance(instance: Instance, indent: number)
		local prefix = string.rep("  ", indent)
		local info = prefix .. instance.Name .. " (" .. instance.ClassName .. ")"
		
		-- BasePartの場合、詳細情報を追加
		if instance:IsA("BasePart") then
			info = info .. string.format(" - Position: %s, Size: %s, Anchored: %s", 
				tostring(instance.Position), 
				tostring(instance.Size),
				tostring(instance.Anchored))
		end
		
		-- Motor6D、Weld、WeldConstraintの場合
		if instance:IsA("Motor6D") or instance:IsA("Weld") or instance:IsA("WeldConstraint") then
			info = info .. " - CONNECTION FOUND!"
		end
		
		print(info)
		
		-- 子要素を再帰的に確認
		for _, child in ipairs(instance:GetChildren()) do
			inspectInstance(child, indent + 1)
		end
	end
	
	inspectInstance(model, 0)
	
	-- BasePartの一覧
	local baseParts = {}
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BasePart") then
			table.insert(baseParts, descendant)
		end
	end
	
	print("\n=== BasePart Summary ===")
	print("Total BaseParts:", #baseParts)
	for i, part in ipairs(baseParts) do
		print(string.format("  %d. %s at %s", i, part.Name, tostring(part.Position)))
	end
	
	-- 接続の確認
	local connections = {}
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("Motor6D") or descendant:IsA("Weld") or descendant:IsA("WeldConstraint") then
			table.insert(connections, descendant)
		end
	end
	
	if #connections > 0 then
		print("\n=== WARNING: Connections Found ===")
		for i, conn in ipairs(connections) do
			print(string.format("  %d. %s (%s)", i, conn.Name, conn.ClassName))
		end
		print("These connections should be removed for proper transformation!")
	else
		print("\n=== No connections found (Good!) ===")
	end
	
	print("=== End of Inspection ===\n")
end

-- すべてのモデルを確認
function AssetInspector:inspectAllModels()
	print("=== Inspecting all models in ServerStorage ===")
	for _, child in ipairs(ServerStorage:GetChildren()) do
		if child:IsA("Model") or child:IsA("BasePart") then
			self:inspectModel(child.Name)
		end
	end
end

return AssetInspector

