local rpo = {}

function rpo.repn(n, func)
	for i=1, n do
		func()
	end
end

function rpo.repsec(n, variable, func)
	task.spawn(function()
		while variable do
			func()
			task.wait(n)
		end
	end)
end

function rpo.adjself(lmn, speed)
	lmn.CFrame = lmn.CFrame + lmn.CFrame.LookVector * speed * task.wait()
end

function rpo.moveto(target, lmn, speed)
	local targ = workspace:FindFirstChild(target) -- example
	local speed = 10

	if target then
		local direction = (targ.Position - lmn.Position).Unit
		lmn.CFrame += direction * speed * task.wait()
	end
end

function rpo.addvar(name, typevar, value)
	local var = Instance.new(typevar)
	var.Value = value
	local par = script.Parent.GlobalVariables
	var.Name = name
	var.Parent = par
end

function rpo.create_physical(
	name:string,
	pos:Vector3,
	siz:Vector3,
	rot:Vector3?,
	shape:string?,
	col:Color3?,
	mtr:EnumItem?,
	par:Instance?)
	
	local part = Instance.new("Part")
	part.Name = name
	part.Position = pos
	part.Size = siz
	part.Orientation = rot or Vector3.new(0, 0, 0)
	if shape then
		if shape == "ball" then
			part.Shape = Enum.PartType.Ball
		elseif shape == "cylinder" then
			part.Shape = Enum.PartType.Cylinder
		elseif shape == "block" then
			part.Shape = Enum.PartType.Block
		end
	end
	if col then
		part.Color = col
	else
		part.Color = BrickColor.new("Medium stone grey")
	end
	if mtr then
		part.Material = mtr
	else
		part.Material = Enum.Material.Plastic
	end
	if par then
		part.Parent = par
	else
		part.Parent = workspace
	end
	return part
end

function rpo.create_blueprint(name:string, pos, par:Instance?)
	local blueprint = game.ReplicatedStorage.Castle.Blueprints:FindFirstChild(name)
	if par == nil then
		par = workspace
	end
	local clone = blueprint:Clone()
	clone.Parent = par
	if clone.ClassName == "Model" then
		clone:SetPrimaryPartCFrame(pos)
	else
		clone.Position = pos
	end
end

function rpo.return_blueprint(name:string)
	local blueprint = game.ReplicatedStorage.Castle.Blueprints:FindFirstChild(name)
	return blueprint
end

function rpo.destroy()
	script.Parent:Destroy()
end

function rpo.replace(from:Instance, name:string, keep_script:Instance?)
	local blueprint = game.ReplicatedStorage.Castle.Blueprints:FindFirstChild(name)
	local parpos = from.Position
	local par = from.Parent
	local clone = blueprint:Clone()
	clone.Parent = par
	if typeof(parpos) == "Vector3" then
		clone:SetPrimaryPartCFrame(CFrame.new(parpos))
	else
		clone:SetPrimaryPartCFrame(parpos)
	end
	if keep_script then
		local kept = keep_script:Clone()
		kept.Parent = clone.PrimaryPart
		kept.Enabled = true
	end
	from:Destroy()
end

function rpo.cardsend(id, player)
	local TeleportService = game:GetService("TeleportService")
	local PLACE_ID = id
	TeleportService:Teleport(PLACE_ID, player)
end

function rpo.addtag(to:Instance, tag:string)
	local cs = game:GetService("CollectionService")
	cs:AddTag(to, tag)
end

function rpo.deletetag(to:Instance, tag:string)
	local cs = game:GetService("CollectionService")
	cs:RemoveTag(to, tag)
end

function rpo.tellall(tag:string, func)
	local cs = game:GetService("CollectionService")
	for _, actor in pairs(cs:GetTagged(tag)) do
		func(actor)
	end
end

function rpo.tellnear(from:Instance, tag:string, func)
	local cs = game:GetService("CollectionService")
	local closest, closestDist = nil, math.huge
	for _, actor in pairs(cs:GetTagged(tag)) do
		local dist = (actor.Position - from.Position).Magnitude
		if dist < closestDist then
			closest, closestDist = actor, dist
		end
	end
	if closest then
		func(closest)
	end
end

function rpo.HandleBackpack(plr, item)
	local bp = item:Clone()
	bp.Parent = plr.Backpack
end

return rpo
