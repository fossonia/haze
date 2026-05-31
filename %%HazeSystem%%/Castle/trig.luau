local ctrl = {}

function spe(t, class)
	local an = string.sub(t, 1, 1)
	local vowels = {
		"A", "a",
		"E", "e",
		"I", "i",
		"O", "o",
		"U", "u"
	}
	
	local to = tostring(t)
	if table.find(vowels, an) then
		error("\"" + to + "\"" + " is not an " + class + " instance.")
	else
		error("\"" + to + "\"" + " is not a " + class + " instance.")
	end
end

function ctrl.ifaction(lmn: Instance, act: string, func)
	local wrapper = function(...)
		func(...)
	end
	if act == "click" then
		if lmn.ClassName ~= "ClickDetector" then
			spe(lmn, "ClickDetector")
		else
			lmn.MouseClick:Connect(wrapper)
		end
	elseif act == "input" then
		if lmn.ClassName ~= "TextBox" then
			spe(lmn, "TextBox")
		else
			lmn.FocusLost:Connect(wrapper)
		end
	elseif act == "changed" then
		lmn.Changed:Connect(wrapper)
	elseif act == "collision" then
		if lmn.ClassName ~= "BasePart" then
			spe(lmn, "BasePart")
		else
			lmn.Touched:Connect(wrapper)
		end
	elseif act == "nil" then
		lmn.AncestryChanged:Connect(function(_, newParent)
			if newParent == nil then
				wrapper()
			end
		end)
	else
		error("Unknown act parameter.")
	end
end

function ctrl.varlimit(lmn: string, thresh: number, func)
	lmn = script.Parent.GlobalVariables:WaitForChild(lmn)
	if lmn.ClassName ~= "NumberValue" then
		spe(lmn, "NumberValue")
	else
		lmn:GetPropertyChangedSignal("Value"):Connect(function()
			if lmn.Value >= thresh then
				func()
			end
		end)
	end
end

function ctrl.taginfo(func, mode: boolean, name: string)
	name = name or ""
	if mode == nil then
		mode = true
	end
	local cs = game:GetService("CollectionService")
	if mode then
		cs:GetInstanceAddedSignal("Tag"):Connect(function(obj)
			if name ~= "" then
				if obj.Name == name then
					func(obj)
				end
			else
				func(obj)
			end
		end)
	else
		cs:GetInstanceRemovedSignal("Tag"):Connect(function(obj)
			if name ~= "" then
				if obj.Name == name then
					func(obj)
				end
			else
				func(obj)
			end
		end)
	end
end

function ctrl.rand(weight: number)
	local w = weight / 100
	if math.random() < w then
		return true
	else
		return false
	end
end

return ctrl
