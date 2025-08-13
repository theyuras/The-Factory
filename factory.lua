-- GPO (648454481)
-- Version: cfe3a47eea3e511f
-- date: 13/08/2025, 14:39:12
-- CrashDetection: false

if not game:IsLoaded() then game.Loaded:Wait() end
local function printf(...) return print(...) end
if getgenv().ZeroHubExecuted then
	warn("[ERROR] ZeroHub has already been executed.")
	if getgenv().Library and getgenv().CreateNotify then getgenv().CreateNotify("ZeroHub has already been executed.") end
	return
end
if getgenv().MaidDelete then getgenv().MaidDelete() end
getgenv().Library2 = nil
getgenv().ZeroHubExecuted = true
local gameId = game.GameId
local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")
local ScriptContext = game:GetService("ScriptContext")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local seenErrors = {}
local GamesList = (not LPH_OBFUSCATED) and {} or 
(function()
	return {["66654135"] = {["name"] = "MurderMystery"}, ["648454481"] = {["name"] = "GPO"}, ["3110388936"] = {["name"] = "NinjaTime"}, ["3808223175"] = {["name"] = "Jujutsu"}, ["4572323622"] = {["name"] = "YBA"}, ["7436755782"] = {["name"] = "GrowGardem"}}
end)()
local gameData = GamesList[tostring(gameId)]
local gameName = gameData and gameData.name or "Unknown"
local threadId = gameData and gameData.threadID or nil
local DevicePlatform
pcall(function() DevicePlatform = UserInputService:GetPlatform() end)
getgenv().IsMobile = (DevicePlatform == Enum.Platform.Android or DevicePlatform == Enum.Platform.IOS)
if not LPH_OBFUSCATED then loadstring(game:HttpGet("https://raw.githubusercontent.com/TrapstarKS/Signal/refs/heads/main/luraphsdk.lua"))() end
local LocalPlayer = game:GetService("Players").LocalPlayer
local jobId, placeId = game.JobId, game.PlaceId
local userId = LocalPlayer.UserId
local debugMode = not LPH_OBFUSCATED
local scriptVersion
local serverConstants = {}
local sharedRequires = {}
local ah_metadata = {["games"] = {["66654135"] = "MurderMystery", ["648454481"] = "GPO", ["3110388936"] = "NinjaTime", ["3808223175"] = "Jujutsu", ["4572323622"] = "YBA", ["7436755782"] = "GrowGardem"}, ["version"] = "cfe3a47eea3e511f"}
(function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	getgenv().protect_gui = protect_gui or protectgui or function() end
	getgenv().comm_channels = {}
	getgenv().create_comm_channel = function()
		local id = game:GetService("HttpService"):GenerateGUID(false)
		local bindable = Instance.new("BindableEvent")
		local object = newproxy(true)
		getmetatable(object).__index = function(_, i)
			if i == "bro" then return bindable end
		end
		local event = setmetatable({
			__OBJECT = object,
		}, {
			__type = "SynSignal",
			__index = function(self, i)
				if i == "Connect" then
					return function(_, callback) return self.__OBJECT.bro.Event:Connect(callback) end
				elseif i == "Fire" then
					return function(_, ...) return self.__OBJECT.bro:Fire(...) end
				end
			end,
			__newindex = function() error("SynSignal table is readonly.") end,
		})
		comm_channels[id] = event
		return id, event
	end
	getgenv().get_comm_channel = function(id)
		local channel = comm_channels[id]
		if not channel then error("bad argument #1 to 'get_comm_channel' (invalid communication channel)") end
		return channel
	end
	getgenv().hooksignalcache = getgenv().hooksignalcache or {}
	getgenv().hooksignal = function(signal, func)
		assert(not hooksignalcache[signal], "bad argument #1 to 'hooksignal' (signal is already hooked)")
		assert(typeof(signal) == "RBXScriptSignal", "bad argument #1 to 'hooksignal' (RBXScriptSignal expected, got " .. typeof(signal) .. ")")
		assert(typeof(func) == "function", "bad argument #2 to 'hooksignal' (function expected, got " .. typeof(func) .. ")")
		local originalConnections = getconnections(signal)
		for _, v in ipairs(originalConnections) do
			v:Disable()
		end
		local function connectionFunc(...)
			local offset = 0
			for i, v in ipairs(originalConnections) do
				if v.Function then
					if v.Function == connectionFunc then
						offset += 1
					else
						task.spawn(function(...)
							local args = table.pack(func({
								Index = i - offset,
								Connection = v,
								Function = v.Function,
								CallingScript = getfenv(v.Function).script,
							}, ...))
							local fire = table.remove(args, 1)
							if fire then v.Function(unpack(args)) end
						end, ...)
					end
				end
			end
		end
		hooksignalcache[signal] = {
			signal = signal,
			Connection = signal:Connect(connectionFunc),
			Connections = originalConnections,
		}
	end
	getgenv().restoresignal = function(signal)
		assert(hooksignalcache[signal], "bad argument #1 to 'restoresignal' (signal is not hooked) (Remember to use same signal object that was used in hooksignal)")
		local connection = hooksignalcache[signal]
		if connection then
			connection.Connection:Disconnect()
			for _, v in ipairs(connection.Connections) do
				v:Enable()
			end
			hooksignalcache[signal] = nil
		end
	end
	getgenv().issignalhooked = function(signal) return hooksignalcache[signal] ~= nil end
	getgenv().trampoline_call = function(func, custom_debug_info, custom_call_info, ...)
		assert(typeof(func) == "function", "bad argument #1 to 'secure_call' (function expected, got " .. typeof(func) .. ")")
		assert(typeof(custom_debug_info) == "table", "bad argument #2 to 'secure_call' (table expected, got " .. typeof(custom_debug_info) .. ")")
		local formated_debug_info = {}
		for k, v in pairs(custom_debug_info) do
			if k == "source" then
				formated_debug_info.s = v
			elseif k == "currentline" then
				formated_debug_info.l = v
			elseif k == "name" then
				formated_debug_info.n = v
			elseif k == "func" then
				formated_debug_info.f = v
			end
		end
		local thread = coroutine.create(function(...)
			setthreadcontext(custom_call_info.identity)
			local funcinfo = debug.getinfo(func)
			local old = getfenv(func)
			setfenv(
				func,
				setmetatable({
					debug = setmetatable({
						info = function(level, what)
							if level == 2 then
								local info = {}
								for k, v in pairs(what:split("")) do
									info[k] = formated_debug_info[v:lower()] or nil
								end
								return table.unpack(info)
							elseif level == 1 or level == nil then
								return debug.info(func, what)
							else
								return
							end
						end,
					}, {
						__index = function(self, key) return debug[key] end,
						__newindex = function(self, key, value) debug[key] = value end,
					}),
					getfenv = function() return custom_call_info.env end,
				}, {
					__index = function(self, key) return custom_call_info.env[key] end,
					__newindex = function(self, key, value) custom_call_info.env[key] = value end,
				})
			)
			return func(...)
		end)
		local success, result = coroutine.resume(thread, ...)
		if not success then error("Erro ao executar secure_call: " .. tostring(result)) end
		return result
	end
end)()
serverConstants['d139875b30c1f9a2b59145898c7db1b5'] = 'VirtualInputManager'
serverConstants['a26663269678defe5d04a8b66e55b3c2'] = 'table'
serverConstants['2aa53c412c3b20a47ec484de6d846ce8'] = 'Maid'
serverConstants['a84efd97a488a0b848e95742b0a18442'] = 'function'
serverConstants['e8a164569cce523481ef7a1545fe1425'] = 'thread'
serverConstants['136651ee799d51edbeb0e758b3308dd9'] = '%s(.)'
serverConstants['3880d134939a311fcc1c95be85a17f46'] = 'Players'
sharedRequires['994cce94d8c7c390545164e0f4f18747359a151bc8bbe449db36b0efa3f0f4e6'] = (function()
	local Services = {};
	local vim = getvirtualinputmanager and getvirtualinputmanager();
	local cloneref = cloneref or function(o) return o end
	local executorName = (identifyexecutor or function() return "unknow" end)()
	function Services:Get(...)
	    local allServices = {};
	    for _, service in next, {...} do
	        table.insert(allServices, self[service]);
	    end
	    return unpack(allServices);
	end;
	setmetatable(Services, {
	    __index = function(self, p)
	        if (p == 'VirtualInputManager') then
	            return vim or Instance.new('VirtualInputManager')
	        end;
	        local service = cloneref(game:GetService(p));
	        if (p == 'VirtualInputManager') then
	            service.Name = serverConstants['d139875b30c1f9a2b59145898c7db1b5'];
	        end;
	        rawset(self, p, service);
	        return rawget(self, p);
	    end,
	});
	return Services;
end)();
sharedRequires['1703a89252a94a3cb5cd02ad3d6ea64ff4744ee588da3340de8ca770740cc981'] = (function()
	local gamename = gameName
	if not isfolder('Z Max') then
		makefolder('Z Max')
	end
	local Player = game.Players.LocalPlayer
	if not isfile('Z Max\\' .. tostring(Player.UserId) .. gamename ..'.txt') then
		writefile('Z Max\\' .. tostring(Player.UserId) .. gamename .. '.txt', "{''}")
	end
	local dados = readfile('Z Max\\' .. tostring(Player.UserId) .. gamename ..  '.txt')
	local http = game:GetService('HttpService')
	local sucess,erro = pcall(function()
		dados = http:JSONDecode(dados)
	end)
	if sucess == false then
		dados = {}
	end
	if not dados['Config'] then
		dados['Config'] = {}
	end
	function saveglobaldata()
		pcall(function()
			writefile('Z Max\\' .. tostring(Player.UserId) .. gamename .. '.txt', http:JSONEncode(dados))
		end)
	end
	getgenv().Settings2 = dados
	getgenv().Dados = dados['Config']
	getgenv().SaveGlobalData = saveglobaldata
	local notifythings = {}
	function updatenotify()
		pcall(function()
			for i,v in pairs(notifythings) do
				v.Frame.Position = UDim2.new(0.85, 0, 0.799999976, (-145 * (i - 1)) )
				print(v.Frame.Position)
			end
		end)
	end
	function createnotify(Text,Time)
		local texto = Text or "nil"
		local tempo = Time or 5
		spawn(function()
			pcall(function()
				local ScreenGui = Instance.new("ScreenGui")
				local Frame = Instance.new("Frame")
				local TextLabel = Instance.new("TextLabel")
				local Frame_2 = Instance.new("Frame")
				ScreenGui.Parent = gethui()
				ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
				Frame.Parent = ScreenGui
				Frame.BackgroundColor3 = Color3.fromRGB(35, 45, 38)
				Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Frame.BorderSizePixel = 4
				Frame.Position = UDim2.new(0.85, 0, 0.799999976, 0)
				Frame.Size = UDim2.new(0, 234, 0, 132)
				table.insert(notifythings,ScreenGui)
				updatenotify()
				TextLabel.Parent = Frame
				TextLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
				TextLabel.BackgroundTransparency = 1.000
				TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
				TextLabel.BorderSizePixel = 0
				TextLabel.Position = UDim2.new(0.0726495758, 0, 0.310606062, -75)
				TextLabel.Size = UDim2.new(0, 200, 0, 200)
				TextLabel.Font = Enum.Font.FredokaOne
				TextLabel.Text = texto
				TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel.TextSize = 18.000
				TextLabel.TextWrapped = true
				Frame_2.Parent = Frame
				Frame_2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
				Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Frame_2.BorderSizePixel = 0
				Frame_2.Size = UDim2.new(0, 233, 0, 2)
				local Size = Frame_2.Size
				local tween = game:GetService('TweenService')
				local ab = tween:Create(Frame_2, TweenInfo.new(tempo,Enum.EasingStyle.Linear), {Size = UDim2.new(0,0,0,2)})
				ab:Play()
				ab.Completed:Wait()
				table.remove(notifythings,table.find(notifythings,ScreenGui))
				updatenotify()
				ScreenGui:Destroy()
			end)
		end)
	end
	function mainmen()
		local maintable = {}
		local ScreenGui = Instance.new("ScreenGui")
		if getgenv().Dados.GUIControl == nil then getgenv().Dados.GUIControl = true end
		ScreenGui.Parent = gethui()
		ScreenGui.Enabled = getgenv().Dados.GUIControl
		local uis = game:GetService("UserInputService")
		uis.InputBegan:Connect(function(a,b)
			if b == true then
				return
			end
			if a.KeyCode == Enum.KeyCode.RightControl then
				ScreenGui.Enabled = not ScreenGui.Enabled
				getgenv().Dados.GUIControl = ScreenGui.Enabled
				getgenv().SaveGlobalData()
			end
		end)
		local Main = Instance.new("Frame")
		Main.Name = "Main"
		Main.Parent = ScreenGui
		Main.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
		Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Main.BorderSizePixel = 0
		Main.Position = UDim2.new(0, 391,0, 142)
		Main.Size = UDim2.new(0, 639,0, 427)
		local UserInputService = game:GetService('UserInputService')
		local function MakeDraggable(topbarobject, object)
			local Dragging = nil
			local DragInput = nil
			local DragStart = nil
			local StartPosition = nil
			local function Update(input)
				local Delta = input.Position - DragStart
				local pos =
					UDim2.new(
						StartPosition.X.Scale,
						StartPosition.X.Offset + Delta.X,
						StartPosition.Y.Scale,
						StartPosition.Y.Offset + Delta.Y
					)
				object.Position = pos
			end
			topbarobject.InputBegan:Connect(
				function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						Dragging = true
						DragStart = input.Position
						StartPosition = object.Position
						input.Changed:Connect(
							function()
								if input.UserInputState == Enum.UserInputState.End then
									Dragging = false
								end
							end
						)
					end
				end
			)
			topbarobject.InputChanged:Connect(
				function(input)
					if
						input.UserInputType == Enum.UserInputType.MouseMovement or
						input.UserInputType == Enum.UserInputType.Touch
					then
						DragInput = input
					end
				end
			)
			UserInputService.InputChanged:Connect(
				function(input)
					if input == DragInput and Dragging then
						Update(input)
					end
				end
			)
		end
		MakeDraggable(Main,Main)
		local UICorner = Instance.new("UICorner")
		UICorner.Parent = Main
		local WindowChooise = Instance.new("Frame")
		WindowChooise.Name = "WindowChooise"
		WindowChooise.Parent = Main
		WindowChooise.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
		WindowChooise.BorderColor3 = Color3.fromRGB(0, 0, 0)
		WindowChooise.BorderSizePixel = 0
		WindowChooise.Size = UDim2.new(0, 146,0, 427)
		local ZeroName = Instance.new("TextLabel")
		local HubName = Instance.new("TextLabel")
		ZeroName.Name = "Zero Name"
		ZeroName.Parent = WindowChooise
		ZeroName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ZeroName.BackgroundTransparency = 1.000
		ZeroName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ZeroName.BorderSizePixel = 0
		ZeroName.Size = UDim2.new(0, 149, 0, 44)
		ZeroName.Font = Enum.Font.SourceSansBold
		ZeroName.Text = "ZERO"
		ZeroName.TextColor3 = Color3.fromRGB(255, 0, 0)
		ZeroName.TextSize = 31.000
		HubName.Name = "Max Name"
		HubName.Parent = WindowChooise
		HubName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		HubName.BackgroundTransparency = 1.000
		HubName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		HubName.BorderSizePixel = 0
		HubName.Position = UDim2.new(0, 0, 0.888040721, 0)
		HubName.Size = UDim2.new(0, 149, 0, 44)
		HubName.Font = Enum.Font.SourceSansBold
		HubName.Text = "Max"
		HubName.TextColor3 = Color3.fromRGB(255, 0, 0)
		HubName.TextSize = 31.000
		local UICorner_2 = Instance.new("UICorner")
		local ScrollingFrame = Instance.new("ScrollingFrame")
		UICorner_2.Parent = WindowChooise
		ScrollingFrame.Parent = Main
		ScrollingFrame.Active = true
		ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ScrollingFrame.BackgroundTransparency = 1.000
		ScrollingFrame.BorderColor3 = Color3.fromRGB(136, 59, 28)
		ScrollingFrame.BorderSizePixel = 0
		ScrollingFrame.Position = UDim2.new(0, 0, 0.111959286, 0)
		ScrollingFrame.Size = UDim2.new(0.229583979, 0, 0.776081443, 0)
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 1, 0)
		ScrollingFrame.ScrollBarThickness = 5
		local Windows = Instance.new("Folder")
		Windows.Name = "Windows"
		Windows.Parent = ScrollingFrame
		local WinLab = Instance.new("Folder")
		WinLab.Parent = Main
		local windowcontage = -1
		function maintable:CreateWindow(Name)
			windowcontage = windowcontage + 1
			local mainwindow = {}
			local NameWindow = Name
			local WName = Instance.new("TextButton")
			WName.Name = "WName"
			WName.Parent = Windows
			WName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			WName.BackgroundTransparency = 1.000
			WName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			WName.BorderSizePixel = 0
			WName.Size = UDim2.new(0, 149, 0, 50)
			WName.Font = Enum.Font.MontserratBold
			WName.Text = Name
			WName.TextColor3 = Color3.fromRGB(236, 236, 236)
			WName.TextSize = 20.000
			WName.Position = UDim2.new(0,0,0, 50 * windowcontage)
			local ExampleLab = Instance.new("ScrollingFrame")
			ExampleLab.Name = "Example Lab"
			ExampleLab.Parent = WinLab
			ExampleLab.Active = true
			ExampleLab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ExampleLab.BackgroundTransparency = 1.000
			ExampleLab.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ExampleLab.BorderSizePixel = 0
			ExampleLab.Position = UDim2.new(0.261941463, 0, 0.0305344388, 0)
			ExampleLab.Size = UDim2.new(0, 465, 0, 410)
			ExampleLab.ScrollBarThickness = 5
			local function visible()
				for i,v in pairs(WinLab:GetChildren()) do
					v.Visible = false
				end
				for i,v in pairs(Windows:GetChildren()) do
					v.TextColor3 = Color3.fromRGB(255, 255, 255)
				end
				ExampleLab.Visible = true
				WName.TextColor3 = Color3.fromRGB(255, 0, 0)
			end
			visible()
			WName.MouseButton1Down:Connect(function()
				visible()
			end)
			local jogaconta = 0
			local jogaconta2 = 0
			local function updatescrolly()
				local maior = 0
				for i,v in pairs(ExampleLab:GetChildren()) do
					if v.Position.Y.Offset + v.Size.Y.Offset + 5 > maior then
						maior = v.Position.Y.Offset + v.Size.Y.Offset + 5
					end
				end
				ExampleLab.CanvasSize = UDim2.new(0,0,0,maior + 200)
			end
			local patada = {}
			function mainwindow:MakeCategory(Name)
				local CategoryName = Name
				local categorytable = {}
				local Category = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local TextLabel = Instance.new("TextLabel")
				local contage = 0
				local function updatekksize()
					Category.Size = UDim2.new(0, 448, 0, contage + 8)
					local nim = #patada > 1 and table.find(patada,Category) or table.find(patada,Category) + 1
					nim = nim == 1 and 2 or nim
					for i=nim,#patada do
						patada[i].Position =  UDim2.new(0, 0, 0, 21 + patada[i - 1].Position.Y.Offset + patada[i - 1].Size.Y.Offset + 10)
					end
					updatescrolly()
				end
				Category.Name = "Category"
				Category.Parent = ExampleLab
				Category.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
				Category.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Category.BorderSizePixel = 0
				Category.Position = UDim2.new(0, 0,0, 30)
				Category.Size = UDim2.new(0, 448, 0, 80)
				table.insert(patada,Category)
				UICorner.Parent = Category
				TextLabel.Parent = Category
				TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel.BackgroundTransparency = 1.000
				TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
				TextLabel.BorderSizePixel = 0
				TextLabel.Position = UDim2.new(0, 7,0, -37)
				TextLabel.Size = UDim2.new(0, 84, 0, 37)
				TextLabel.Font = Enum.Font.SourceSansBold
				TextLabel.Text = Name
				TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel.TextSize = 21.000
				TextLabel.TextXAlignment = Enum.TextXAlignment.Left
				local function getenabled(Name)
					local ativo = nil
					pcall(function()
						if dados[CategoryName][Name] ~= nil then
							ativo = dados[CategoryName][Name]
						end
					end)
					return ativo
				end
				local function setenabled(Name,Thing)
					if not dados[CategoryName] then
						dados[CategoryName] = {}
					end
					dados[CategoryName][Name] = Thing
					saveglobaldata()
				end
				function categorytable:Bool(Name,Func)
					local ativo = getenabled(Name) or false
					local Bool = Instance.new("Frame")
					local UICorner = Instance.new("UICorner")
					local Bool_2 = Instance.new("TextLabel")
					local UICorner_2 = Instance.new("UICorner")
					local Frame = Instance.new("TextButton")
					local UICorner_3 = Instance.new("UICorner")
					local Boolactived = false
					local function BoolToggle()
						Boolactived = not Boolactived
						local colorframe = Boolactived == true and Color3.fromRGB(235, 0, 0) or Color3.fromRGB(50, 0, 0)
						Frame.BackgroundColor3 = colorframe
						setenabled(Name,Boolactived)
						pcall(function()
							Func(Boolactived)
						end)
					end
					Frame.Text = ""
					Bool.Name = "Bool"
					Bool.Parent = Category
					Bool.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
					Bool.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Bool.BorderSizePixel = 0
					Bool.Position = UDim2.new(0, 26, 0, 8 + contage)
					Bool.Size = UDim2.new(0, 398, 0, 39)
					contage = Bool.Position.Y.Offset + Bool.Size.Y.Offset
					UICorner.Parent = Bool
					Bool_2.Name = "Bool"
					Bool_2.Parent = Bool
					Bool_2.BackgroundColor3 = Color3.fromRGB(83, 83, 83)
					Bool_2.BackgroundTransparency = 1.000
					Bool_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Bool_2.BorderSizePixel = 0
					Bool_2.Position = UDim2.new(0.021, 0, 0.0361304656, 0)
					Bool_2.Size = UDim2.new(0, 351, 0, 35)
					Bool_2.Font = Enum.Font.SourceSansBold
					Bool_2.LineHeight = 3.000
					Bool_2.Text = Name
					Bool_2.TextColor3 = Color3.fromRGB(255, 255, 255)
					Bool_2.TextSize = 20.000
					Bool_2.TextXAlignment = Enum.TextXAlignment.Left
					UICorner_2.Parent = Bool_2
					Frame.Parent = Bool_2
					Frame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
					Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Frame.BorderSizePixel = 0
					Frame.Position = UDim2.new(0, 354, 0, 3)
					Frame.Size = UDim2.new(0, 31, 0, 30)
					Frame.MouseButton1Down:Connect(BoolToggle)
					UICorner_3.Parent = Frame
					if ativo == true then
						BoolToggle()
					end
					updatekksize()
					return function(Bool)
						Boolactived = not Bool
						BoolToggle()
					end
				end
				function categorytable:Text(Name,Func)
					local Box = Instance.new("Frame")
					local UICorner = Instance.new("UICorner")
					local TextBox = Instance.new("TextBox")
					local function TextFunction()
						setenabled(Name,TextBox.Text)
						Func(TextBox.Text)
					end
					local Bool = Instance.new("TextLabel")
					local UICorner_2 = Instance.new("UICorner")
					Box.Name = "Box"
					Box.Parent = Category
					Box.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
					Box.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Box.BorderSizePixel = 0
					Box.Position = UDim2.new(0, 26, 0, 8 + contage)
					Box.Size = UDim2.new(0, 398, 0, 39)
					contage = Box.Position.Y.Offset + Box.Size.Y.Offset
					UICorner.Parent = Box
					TextBox.Parent = Box
					TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					TextBox.BackgroundTransparency = 1.000
					TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
					TextBox.BorderSizePixel = 0
					TextBox.Position = UDim2.new(0, 125, 0, 2)
					TextBox.Size = UDim2.new(0, 145, 0, 34)
					TextBox.Font = Enum.Font.SourceSansBold
					TextBox.Text = "Put here the text"
					TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
					TextBox.TextSize = 20.000
					TextBox.TextStrokeTransparency = 0.000
					TextBox.TextTransparency = 0.350
					TextBox.TextWrapped = true
					TextBox.FocusLost:Connect(TextFunction)
					local TextHave = getenabled(Name)
					if TextHave ~= nil then
						TextBox.Text = TextHave
						TextFunction()
					end
					Bool.Name = "Bool"
					Bool.Parent = Box
					Bool.BackgroundColor3 = Color3.fromRGB(83, 83, 83)
					Bool.BackgroundTransparency = 1.000
					Bool.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Bool.BorderSizePixel = 0
					Bool.Position = UDim2.new(0.0201003496, 0, 0.0361304656, 0)
					Bool.Size = UDim2.new(0, 354, 0, 35)
					Bool.Font = Enum.Font.SourceSansBold
					Bool.LineHeight = 3.000
					Bool.Text = Name .. ":"
					Bool.TextColor3 = Color3.fromRGB(255, 255, 255)
					Bool.TextSize = 19.000
					Bool.TextXAlignment = Enum.TextXAlignment.Left
					UICorner_2.Parent = Bool
					updatekksize()
				end
				function categorytable:Button(Text,Func)
					local Frame = Instance.new("TextButton")
					Frame.Text = ""
					local UICorner_2 = Instance.new("UICorner")
					local TextLabel = Instance.new("TextButton")
					local function ButtonFunction()
						Func()
					end
					Frame.Parent = Category
					Frame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
					Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Frame.BorderSizePixel = 0
					Frame.Position = UDim2.new(0, 26, 0, 8 + contage)
					Frame.Size = UDim2.new(0, 398, 0, 39)
					contage = Frame.Position.Y.Offset + Frame.Size.Y.Offset
					UICorner_2.Parent = Frame
					TextLabel.Parent = Frame
					TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					TextLabel.BackgroundTransparency = 1.000
					TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
					TextLabel.BorderSizePixel = 0
					TextLabel.Position = UDim2.new(0, 0, 0, 3)
					TextLabel.Size = UDim2.new(0, 394, 0, 33)
					TextLabel.Font = Enum.Font.SourceSansBold
					TextLabel.Text = Text
					TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
					TextLabel.TextSize = 20.000
					TextLabel.TextWrapped = true
					TextLabel.MouseButton1Down:Connect(ButtonFunction)
					updatekksize()
					return function(name)
						TextLabel.Text = name
					end
				end
				function categorytable:Drop(Name, Tabl, Func)
					local tablesavedrop = Tabl
					local DropDown = Instance.new("TextButton")
					DropDown.Text = ""
					local UICorner = Instance.new("UICorner")
					local Seta = Instance.new("TextLabel")
					local Abrindo = Instance.new("Frame")
					local UICorner_2 = Instance.new("UICorner")
					local Search = Instance.new("TextBox")
					local UICorner_3 = Instance.new("UICorner")
					local ScrollingFrame = Instance.new("ScrollingFrame")
					local TextButton = Instance.new("TextButton")
					local UICorner_4 = Instance.new("UICorner")
					local TextButton_2 = Instance.new("TextButton")
					local UICorner_5 = Instance.new("UICorner")
					local Select = Instance.new("TextLabel")
					local Selected = Instance.new("TextLabel")
					Abrindo.Visible = false
					local SelectedReal = nil
					local TableIndexesDrop = {}
					local function UpdateCanvasDropSize()
						local maior2 = 0
						for i,v in pairs(ScrollingFrame:GetChildren()) do
							if v.Position.Y.Offset + v.Size.Y.Offset + 5 > maior2 then
								maior2 = v.Position.Y.Offset + v.Size.Y.Offset + 5
							end
						end
						ScrollingFrame.CanvasSize = UDim2.new(0,0,0,maior2)
					end
					local function SelectOrClose(Selected2)
						Abrindo.Visible = not Abrindo.Visible
						Seta.Rotation = Abrindo.Visible and 90 or 0
						Seta.Position = Abrindo.Visible and UDim2.new(0.834170878, 0, -0.05384616, 0) or UDim2.new(0.834170878, 0, -0.15384616, 0)
						if Abrindo.Visible == true then
							for i,v in pairs(TableIndexesDrop) do i.ZIndex = v + 10 end
						else
							for i,v in pairs(TableIndexesDrop) do i.ZIndex = v end
						end
						if Selected2 ~= nil then
							setenabled(Name,Selected2)
							Func(Selected2)
							Select.Visible = true
							SelectedReal = Selected2
							Select.Text = ""
						end
					end
					local EnabledSelected = getenabled(Name)
					if EnabledSelected ~= nil then
						SelectOrClose(EnabledSelected)
						Abrindo.Visible = not Abrindo.Visible
						Seta.Rotation = Abrindo.Visible and 90 or 0
						Seta.Position = Abrindo.Visible and UDim2.new(0.834170878, 0, -0.05384616, 0) or UDim2.new(0.834170878, 0, -0.15384616, 0)
						if Abrindo.Visible == true then
							for i,v in pairs(TableIndexesDrop) do i.ZIndex = v + 10 end
						else
							for i,v in pairs(TableIndexesDrop) do i.ZIndex = v end
						end
					end
					local function UpdateDrop(Name)
						Search.Text = (Name == "" or Name == nil) and "Type here to search" or Name
						for i,v in pairs(ScrollingFrame:GetChildren()) do v:Destroy() end
						local contagedrop = 1
						for i,v in pairs(tablesavedrop) do
							if Name == nil or Name == "" or Name == "Type here to search" or string.find(string.lower(v),string.lower(Name)) then
								local TextButton = Instance.new("TextButton")
								local UICorner_4 = Instance.new("UICorner")
								TextButton.Parent = ScrollingFrame
								TextButton.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
								TextButton.BackgroundTransparency = 0.700
								TextButton.BorderSizePixel = 0
								TextButton.Position = UDim2.new(0, 64, 0, 5 + ( (contagedrop-1) * 38 ))
								TextButton.Size = UDim2.new(0, 272, 0, 33)
								TextButton.Font = Enum.Font.SourceSansBold
								TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
								TextButton.TextSize = 17.000
								TextButton.Text = v
								TextButton.BackgroundColor3 = (SelectedReal ~= nil and SelectedReal == v) and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(27, 27, 27)
								TextButton.MouseButton1Down:Connect(function()  SelectOrClose(v) ; UpdateDrop(Name) end)
								TableIndexesDrop[TextButton] = TextButton.ZIndex
								UICorner_4.Parent = TextButton
								UpdateCanvasDropSize()
								contagedrop = contagedrop + 1
							end
						end
						for i,v in pairs(TableIndexesDrop) do i.ZIndex = v + 5 end
					end
					DropDown.MouseButton1Down:Connect(function()
						SelectOrClose()
					end)
					DropDown.AutoButtonColor = false
					DropDown.Name = "DropDown"
					DropDown.Parent = Category
					DropDown.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
					DropDown.BorderColor3 = Color3.fromRGB(0, 0, 0)
					DropDown.BorderSizePixel = 0
					DropDown.Position = UDim2.new(0, 26, 0, 8 + contage)
					DropDown.Size = UDim2.new(0, 398, 0, 39)
					DropDown.ZIndex = 2
					contage = DropDown.Position.Y.Offset + DropDown.Size.Y.Offset
					UICorner.Parent = DropDown
					Seta.Name = "Seta"
					Seta.Parent = DropDown
					Seta.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Seta.BackgroundTransparency = 1.000
					Seta.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Seta.BorderSizePixel = 0
					Seta.Position = UDim2.new(0.834170878, 0, -0.15384616, 0)
					Seta.Rotation = 0
					Seta.Size = UDim2.new(0, 91, 0, 50)
					Seta.ZIndex = 2
					Seta.Font = Enum.Font.SourceSansBold
					Seta.Text = ">"
					Seta.TextColor3 = Color3.fromRGB(255, 255, 255)
					Seta.TextSize = 26.000
					Abrindo.Name = "Abrindo"
					Abrindo.Parent = DropDown
					Abrindo.BackgroundColor3 = Color3.fromRGB(67, 67, 67)
					Abrindo.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Abrindo.BorderSizePixel = 0
					Abrindo.Position = UDim2.new(0, 0, 0.717948735, 0)
					Abrindo.Size = UDim2.new(0, 398, 0, 221)
					UICorner_2.Parent = Abrindo
					Search.Name = "Search"
					Search.Parent = Abrindo
					Search.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
					Search.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Search.BorderSizePixel = 0
					Search.Size = UDim2.new(0, 398, 0, 22)
					Search.ZIndex = 3
					Search.Font = Enum.Font.SourceSans
					Search.Text = "Type here to search"
					Search.TextColor3 = Color3.fromRGB(0, 0, 0)
					Search.TextSize = 14.000
					Search.FocusLost:Connect(function() UpdateDrop(Search.Text); for i,v in pairs(TableIndexesDrop) do i.ZIndex = v + 5 end  end)
					UICorner_3.Parent = Search
					ScrollingFrame.Parent = Abrindo
					ScrollingFrame.Active = true
					ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					ScrollingFrame.BackgroundTransparency = 1.000
					ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
					ScrollingFrame.BorderSizePixel = 0
					ScrollingFrame.Position = UDim2.new(-0.00753768859, 0, 0.109095026, 0)
					ScrollingFrame.Size = UDim2.new(0, 401, 0, 177)
					Select.Name = "Select"
					Select.Parent = DropDown
					Select.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Select.BackgroundTransparency = 1.010
					Select.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Select.BorderSizePixel = 0
					Select.Position = UDim2.new(0.0201005023, 0, 0, 0)
					Select.Size = UDim2.new(0, 126, 0, 36)
					Select.ZIndex = 2
					Select.Font = Enum.Font.SourceSansBold
					Select.Text = ""
					Select.TextColor3 = Color3.fromRGB(255, 255, 255)
					Select.TextSize = 19.000
					Select.TextXAlignment = Enum.TextXAlignment.Left
					Select.Visible = true
					Selected.Name = "Selected"
					Selected.Parent = Select
					Selected.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Selected.BackgroundTransparency = 1.000
					Selected.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Selected.BorderSizePixel = 0
					Selected.Position = UDim2.new(0.706349194, 0, -0.166666672, 0)
					Selected.Size = UDim2.new(0, 200, 0, 50)
					Selected.ZIndex = 2
					Selected.Font = Enum.Font.SourceSansBold
					Selected.Text = Name
					Selected.TextColor3 = Color3.fromRGB(255, 255, 255)
					Selected.TextSize = 18.000
					TableIndexesDrop[DropDown] = DropDown.ZIndex
					for i,v in pairs(DropDown:GetDescendants()) do
						pcall(function()
							TableIndexesDrop[v] = v.ZIndex
						end)
					end
					UpdateDrop()
					updatekksize()
				end
				function categorytable:DropSelect(Name, Tabl, Func)
					local tablesavedrop = Tabl
					local DropDown = Instance.new("TextButton")
					DropDown.Text = ""
					local UICorner = Instance.new("UICorner")
					local Seta = Instance.new("TextLabel")
					local Abrindo = Instance.new("Frame")
					local UICorner_2 = Instance.new("UICorner")
					local Search = Instance.new("TextBox")
					local UICorner_3 = Instance.new("UICorner")
					local ScrollingFrame = Instance.new("ScrollingFrame")
					local TextButton = Instance.new("TextButton")
					local UICorner_4 = Instance.new("UICorner")
					local TextButton_2 = Instance.new("TextButton")
					local UICorner_5 = Instance.new("UICorner")
					local Select = Instance.new("TextLabel")
					local Selected = Instance.new("TextLabel")
					Abrindo.Visible = false
					local SelectedReal = {}
					local TableIndexesDrop = {}
					local function UpdateCanvasDropSize()
						local maior2 = 0
						for i,v in pairs(ScrollingFrame:GetChildren()) do
							if v.Position.Y.Offset + v.Size.Y.Offset + 5 > maior2 then
								maior2 = v.Position.Y.Offset + v.Size.Y.Offset + 5
							end
						end
						ScrollingFrame.CanvasSize = UDim2.new(0,0,0,maior2)
					end
					local antigo = false
					local function SelectOrClose(Selected2)
						if Abrindo.Visible == true and Abrindo.Visible ~= antigo then
							antigo = Abrindo.Visible
							for i,v in pairs(TableIndexesDrop) do i.ZIndex = v + 5 end
						elseif Abrindo.Visible == false and Abrindo.Visible ~= antigo then
							antigo = Abrindo.Visible
							for i,v in pairs(TableIndexesDrop) do i.ZIndex = v end
						end
						if Selected2 ~= nil then
							Select.Visible = true
							if not table.find(SelectedReal,Selected2) then
								table.insert(SelectedReal, Selected2)
							else
								table.remove(SelectedReal, table.find(SelectedReal,Selected2))
							end
							Select.Text = ""
							setenabled(Name,SelectedReal)
							Func(SelectedReal)
						end
					end
					local function UpdateDrop(Name)
						Search.Text = (Name == "" or Name == nil) and "Type here to search" or Name
						for i,v in pairs(ScrollingFrame:GetChildren()) do v:Destroy() end
						local contagedrop = 1
						for i,v in pairs(tablesavedrop) do
							if Name == nil or Name == "" or Name == "Type here to search" or string.find(string.lower(v),string.lower(Name)) then
								local TextButton = Instance.new("TextButton")
								local UICorner_4 = Instance.new("UICorner")
								TextButton.Parent = ScrollingFrame
								TextButton.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
								TextButton.BackgroundTransparency = 0.700
								TextButton.BorderSizePixel = 0
								TextButton.Position = UDim2.new(0, 64, 0, 5 + ( (contagedrop-1) * 38 ))
								TextButton.Size = UDim2.new(0, 272, 0, 33)
								TextButton.Font = Enum.Font.SourceSansBold
								TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
								TextButton.TextSize = 17.000
								TextButton.Text = v
								TextButton.BackgroundColor3 = table.find(SelectedReal,v) and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(27, 27, 27)
								TextButton.MouseButton1Down:Connect(function() SelectOrClose(v); UpdateDrop(nil) end)
								TableIndexesDrop[TextButton] = TextButton.ZIndex
								UICorner_4.Parent = TextButton
								UpdateCanvasDropSize()
								contagedrop = contagedrop + 1
							end
						end
						for i,v in pairs(TableIndexesDrop) do i.ZIndex = v + 5 end
					end
					local Selectedsave = getenabled(Name)
					if Selectedsave ~= nil then
						SelectedReal = Selectedsave
						UpdateDrop(nil)
						Func(SelectedReal)
					end
					DropDown.MouseButton1Down:Connect(function()
						Abrindo.Visible = not Abrindo.Visible
						Seta.Rotation = Abrindo.Visible and 90 or 0
						Seta.Position = Abrindo.Visible and UDim2.new(0.834170878, 0, -0.05384616, 0) or UDim2.new(0.834170878, 0, -0.15384616, 0)
						SelectOrClose()
					end)
					DropDown.AutoButtonColor = false
					DropDown.Name = "DropDown"
					DropDown.Parent = Category
					DropDown.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
					DropDown.BorderColor3 = Color3.fromRGB(0, 0, 0)
					DropDown.BorderSizePixel = 0
					DropDown.Position = UDim2.new(0, 26, 0, 8 + contage)
					DropDown.Size = UDim2.new(0, 398, 0, 39)
					DropDown.ZIndex = 2
					contage = DropDown.Position.Y.Offset + DropDown.Size.Y.Offset
					UICorner.Parent = DropDown
					Seta.Name = "Seta"
					Seta.Parent = DropDown
					Seta.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Seta.BackgroundTransparency = 1.000
					Seta.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Seta.BorderSizePixel = 0
					Seta.Position = UDim2.new(0.834170878, 0, -0.15384616, 0)
					Seta.Rotation = 0
					Seta.Size = UDim2.new(0, 91, 0, 50)
					Seta.ZIndex = 2
					Seta.Font = Enum.Font.SourceSansBold
					Seta.Text = ">"
					Seta.TextColor3 = Color3.fromRGB(255, 255, 255)
					Seta.TextSize = 26.000
					Abrindo.Name = "Abrindo"
					Abrindo.Parent = DropDown
					Abrindo.BackgroundColor3 = Color3.fromRGB(67, 67, 67)
					Abrindo.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Abrindo.BorderSizePixel = 0
					Abrindo.Position = UDim2.new(0, 0, 0.717948735, 0)
					Abrindo.Size = UDim2.new(0, 398, 0, 221)
					UICorner_2.Parent = Abrindo
					Search.Name = "Search"
					Search.Parent = Abrindo
					Search.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
					Search.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Search.BorderSizePixel = 0
					Search.Size = UDim2.new(0, 398, 0, 22)
					Search.ZIndex = 3
					Search.Font = Enum.Font.SourceSans
					Search.Text = "Type here to search"
					Search.TextColor3 = Color3.fromRGB(0, 0, 0)
					Search.TextSize = 14.000
					Search.FocusLost:Connect(function() UpdateDrop(Search.Text); for i,v in pairs(TableIndexesDrop) do i.ZIndex = v + 5 end end)
					UICorner_3.Parent = Search
					ScrollingFrame.Parent = Abrindo
					ScrollingFrame.Active = true
					ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					ScrollingFrame.BackgroundTransparency = 1.000
					ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
					ScrollingFrame.BorderSizePixel = 0
					ScrollingFrame.Position = UDim2.new(-0.00753768859, 0, 0.109095026, 0)
					ScrollingFrame.Size = UDim2.new(0, 401, 0, 177)
					Select.Name = "Select"
					Select.Parent = DropDown
					Select.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Select.BackgroundTransparency = 1.010
					Select.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Select.BorderSizePixel = 0
					Select.Position = UDim2.new(0.0201005023, 0, 0, 0)
					Select.Size = UDim2.new(0, 126, 0, 36)
					Select.ZIndex = 2
					Select.Font = Enum.Font.SourceSansBold
					Select.Text = ""
					Select.TextColor3 = Color3.fromRGB(255, 255, 255)
					Select.TextSize = 19.000
					Select.TextXAlignment = Enum.TextXAlignment.Left
					Select.Visible = true
					Selected.Name = "Selected"
					Selected.Parent = Select
					Selected.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Selected.BackgroundTransparency = 1.000
					Selected.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Selected.BorderSizePixel = 0
					Selected.Position = UDim2.new(0.706349194, 0, -0.166666672, 0)
					Selected.Size = UDim2.new(0, 200, 0, 50)
					Selected.ZIndex = 2
					Selected.Font = Enum.Font.SourceSansBold
					Selected.Text = Name
					Selected.TextColor3 = Color3.fromRGB(255, 255, 255)
					Selected.TextSize = 18.000
					TableIndexesDrop[DropDown] = DropDown.ZIndex
					for i,v in pairs(DropDown:GetDescendants()) do
						pcall(function()
							TableIndexesDrop[v] = v.ZIndex
						end)
					end
					UpdateDrop()
					updatekksize()
				end
				function categorytable:Slider(Namee, Valor2, Maximo, Func)
					local Valor = Valor2
					if getenabled(Namee) ~= nil then
						Valor = getenabled(Namee)
					end
					local Slider = Instance.new("Frame")
					local UICorner = Instance.new("UICorner")
					local ImageButton = Instance.new("ImageButton")
					local UICorner_2 = Instance.new("UICorner")
					local TextLabel = Instance.new("TextLabel")
					local Frame = Instance.new("Frame")
					local UICorner_3 = Instance.new("UICorner")
					local Name = Instance.new("TextLabel")
					Slider.Name = "Slider"
					Slider.Parent = Category
					Slider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
					Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Slider.BorderSizePixel = 0
					Slider.Position = UDim2.new(0, 26, 0, 8 + contage)
					Slider.Size = UDim2.new(0, 398, 0, 39)
					contage = Slider.Position.Y.Offset + Slider.Size.Y.Offset
					UICorner.Parent = Slider
					ImageButton.Parent = Slider
					ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					ImageButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
					ImageButton.BorderSizePixel = 0
					ImageButton.Position = UDim2.new(0, 0, 0, 25)
					ImageButton.Size = UDim2.new(0, 12, 0, 12)
					ImageButton.ZIndex = 2
					ImageButton.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
					ImageButton.ImageTransparency = 1.000
					UICorner_2.Parent = ImageButton
					TextLabel.Parent = ImageButton
					TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					TextLabel.BackgroundTransparency = 1.000
					TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
					TextLabel.BorderSizePixel = 0
					TextLabel.Position = UDim2.new(0, -9, 0, 7)
					TextLabel.Size = UDim2.new(0, 29, 0, 24)
					TextLabel.ZIndex = 2
					TextLabel.Font = Enum.Font.Unknown
					TextLabel.Text = tostring(Valor)
					TextLabel.TextColor3 = Color3.fromRGB(255, 234, 0)
					TextLabel.TextSize = 10.000
					Func(Valor)
					Frame.Parent = Slider
					Frame.BackgroundColor3 = Color3.fromRGB(98, 0, 0)
					Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Frame.BorderSizePixel = 0
					Frame.Position = UDim2.new(0, 10, 0, 28)
					Frame.Size = UDim2.new(0, 380, 0, 7)
					UICorner_3.Parent = Frame
					Name.Name = "Name"
					Name.Parent = Slider
					Name.Text = Namee
					Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Name.BackgroundTransparency = 1.000
					Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Name.BorderSizePixel = 0
					Name.Position = UDim2.new(0.0251256283, 0, 0.128205135, 0)
					Name.Size = UDim2.new(0, 342, 0, 17)
					Name.Font = Enum.Font.SourceSansBold
					Name.TextColor3 = Color3.fromRGB(255, 255, 255)
					Name.TextSize = 17.000
					Name.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
					Name.TextXAlignment = Enum.TextXAlignment.Left
					local udi2ini = ImageButton.Position.X.Offset
					local udi2fin = 386
					local bala = (udi2fin / Maximo)
					local bala2 = Valor * bala
					ImageButton.Position = UDim2.new(0, bala2, 0, 25)
					local inputDown = false
					local mouse = game.Players.LocalPlayer:GetMouse()
					local valorzin = 0 
					local valueatual = 0
					local function refresh()
						local valoragr = mouse.X
						local balaagr = tonumber(TextLabel.Text)
						local xpos = ImageButton.Position.X.Offset
						local tomax = (386 - xpos) + valorzin
						local tomin = (xpos) - valorzin
						local dif = valorzin - mouse.X
						local bomba22 = UDim2.new(0, (valueatual - dif), 0, 25)
						if bomba22.X.Offset > 386 then
							ImageButton.Position = UDim2.new(0, 386, 0, 25)
						elseif bomba22.X.Offset < 0 then
							ImageButton.Position = UDim2.new(0, 0, 0, 25)
						else
							ImageButton.Position = UDim2.new(0, (valueatual - dif), 0, 25)	
						end
						local valornow = ImageButton.Position.X.Offset / bala
						TextLabel.Text = tostring(math.round(valornow))
						setenabled(Namee,math.round(valornow))
						Func((math.round(valornow)))
					end
					ImageButton.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							inputDown = true
							valorzin = mouse.X
							valueatual = ImageButton.Position.X.Offset
						end
					end)
					ImageButton.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							inputDown = false
						end
					end)
					mouse.Move:Connect(function()
						if inputDown == true then
							refresh()
						end
					end)
					updatekksize()
				end
				return categorytable
			end
			return mainwindow
		end
		return maintable
	end
	getgenv().Library = mainmen()
	getgenv().CreateNotify = createnotify
	return getgenv().Library
end)();
sharedRequires['1131354b3faa476e8cf67a829e7e64a41ecd461a3859adfe16af08354df80d2b'] = (function()
	local Signal = {}
	Signal.__index = Signal
	Signal.ClassName = "Signal"
	function Signal.new()
		local self = setmetatable({}, Signal)
		self._bindableEvent = Instance.new("BindableEvent")
		self._destroyed = false
		self._HasConnection = false
		return self
	end
	function Signal.isSignal(object) return typeof(object) == "table" and getmetatable(object) == Signal end
	function Signal:Fire(...)
		if self._destroyed then return end
		if not self._HasConnection then
			return
		end
		self._bindableEvent:Fire(...) 
	end
	function Signal:Connect(handler)
		self._HasConnection = true
		if self._destroyed then return error("Signal has been destroyed") end
		if not (type(handler) == "function") then error(("connect(%s)"):format(typeof(handler)), 2) end
		return self._bindableEvent.Event:Connect(handler)
	end
	function Signal:Wait()
		if self._destroyed then error("Signal has been destroyed") end
		return self._bindableEvent.Event:Wait() 
	end
	function Signal:Wait(FirstArg)
		for i = 1, 300 do
			local args = { self._bindableEvent.Event:Wait() }
			local FirstArg = args[1]
			if FirstArg then return table.unpack(args) end
		end
	end
	function Signal:Destroy()
		if self._bindableEvent then
			self._bindableEvent:Destroy()
			self._bindableEvent = nil
		end
		self._destroyed = true
	end
	return Signal
end)();
sharedRequires['9cb70a2854a5995c42972a2e611898569dc41217a6fd4214156e8261045bac0f'] = (function()
	local Services = sharedRequires['994cce94d8c7c390545164e0f4f18747359a151bc8bbe449db36b0efa3f0f4e6']
	local library = sharedRequires['1703a89252a94a3cb5cd02ad3d6ea64ff4744ee588da3340de8ca770740cc981']
	local Signal = sharedRequires['1131354b3faa476e8cf67a829e7e64a41ecd461a3859adfe16af08354df80d2b']
	local Players, UserInputService, HttpService, CollectionService, TeleportService, MemStorageService = Services:Get("Players", "UserInputService", "HttpService", "CollectionService", "TeleportService", "MemStorageService")
	local LocalPlayer = Players.LocalPlayer
	local wait = task.wait
	local utils = {}
	utils._Loops = {}
	function getvector3(ag)
		if typeof(ag) == "Vector3" then
			return ag
		else
			return ag.Position
		end
	end
	function utils:WaitForCharacter()
		if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
		repeat
			task.wait()
		until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	end
	function utils:CharacterDied(Func) game.Players.LocalPlayer.CharacterRemoving:Connect(Func) end
	function utils:GetPlayer() return game.Players.LocalPlayer end
	function utils:GetCharacter()
		utils:WaitForCharacter()
		return utils:GetPlayer().Character
	end
	function utils:TeleportToCF(CF) utils:GetCharacter().HumanoidRootPart.CFrame = CF end
	function utils:GetMagnitudeFromCharacter(object1)
		utils:WaitForCharacter()
		return (getvector3(object1) - utils:GetCharacter().HumanoidRootPart.Position).Magnitude
	end
	function ChangeY(vec, y) return Vector3.new(vec.X, y, vec.Z) end
	function utils:ChangeY(A, B) return ChangeY(A, B) end
	function utils:GetMagnitudeXZFromCharacter(object1)
		if not game.Players.LocalPlayer.Character then utils:WaitForCharacter() end
		local vec1 = ChangeY(getvector3(object1), 0)
		local vec2 = ChangeY(utils:GetCharacter().HumanoidRootPart.Position, 0)
		return (vec1 - vec2).Magnitude
	end
	function utils:GetCFrame() return utils:GetCharacter().HumanoidRootPart.CFrame end
	function utils:GetHumanoidRootPart() return utils:GetCharacter().HumanoidRootPart end
	function utils:CheckAlive(mob)
		if mob:IsA("Model") and mob:IsDescendantOf(game.Workspace) and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then return true end
		return false
	end
	function utils:serverHop(info)
		local placeId = info.placeId or game.PlaceId
		local lower = info.lower or false
		local priorityIn = info.priorityIn or "ping"
		local sortOrder = lower and "Asc" or "Desc"
		local function getServer()
			local servers = HttpService:JSONDecode(game:HttpGet(("https://games.roblox.com/v1/games/%s/servers/Public?cursor=&sortOrder=%s&limit=100&excludeFullGames=false"):format(placeId, sortOrder)))
			local lowest = math.huge
			local selectedServerId = nil
			local BlacklistedsJobId = MemStorageService:HasItem("BlacklistedsJobId") and HttpService:JSONDecode(MemStorageService:GetItem("BlacklistedsJobId")) or {}
			local Last10Servers = MemStorageService:HasItem("Last10Servers") and HttpService:JSONDecode(MemStorageService:GetItem("Last10Servers")) or {}
			for _, v in pairs(servers.data) do
				if table.find(BlacklistedsJobId, v.id) then continue end
				local ping = v.ping or 9999
				local players = v.playing or 0
				if ((priorityIn == "ping" and ping < lowest) or (priorityIn == "players" and v.playing < lowest)) and v.playing < (v.maxPlayers - 1) and not table.find(Last10Servers, v.id) then
					lowest = priorityIn == "ping" and ping or players
					selectedServerId = v.id
				end
			end
			if selectedServerId then
				table.insert(Last10Servers, selectedServerId)
				if #Last10Servers > 30 then table.remove(Last10Servers, 1) end
				MemStorageService:SetItem("Last10Servers", HttpService:JSONEncode(Last10Servers))
			end
			return selectedServerId
		end
		local s, r
		while not s do
			s, r = pcall(function() TeleportService:TeleportToPlaceInstance((placeId or game.PlaceId), getServer()) end)
			if not s then
				warn("Failed to teleport to server: " .. r)
				task.wait(1)
			end
		end
	end
	return utils
end)();
sharedRequires['64ad5d70519ac811e5b3bb94cfc624e4339daa90db7e2ee113d4f3ce8b58b550'] = (function()
	local Services = {};
	local vim = getvirtualinputmanager and getvirtualinputmanager();
	local cloneref = cloneref or function(o) return o end
	local executorName = (identifyexecutor or function() return "unknow" end)()
	function Services:Get(...)
	    local allServices = {};
	    for _, service in next, {...} do
	        table.insert(allServices, self[service]);
	    end
	    return unpack(allServices);
	end;
	setmetatable(Services, {
	    __index = function(self, p)
	        if (p == 'VirtualInputManager') then
	            return vim or Instance.new('VirtualInputManager')
	        end;
	        local service = cloneref(game:GetService(p));
	        if (p == 'VirtualInputManager') then
	            service.Name = serverConstants['d139875b30c1f9a2b59145898c7db1b5'];
	        end;
	        rawset(self, p, service);
	        return rawget(self, p);
	    end,
	});
	return Services;
end)();
sharedRequires['4d7f148d62e823289507e5c67c750b9ae0f8b93e49fbe590feb421847617de2f'] = (function()
	local Signal = sharedRequires['1131354b3faa476e8cf67a829e7e64a41ecd461a3859adfe16af08354df80d2b']
	local tableStr = serverConstants['a26663269678defe5d04a8b66e55b3c2']
	local classNameStr = serverConstants['2aa53c412c3b20a47ec484de6d846ce8']
	local funcStr = serverConstants['a84efd97a488a0b848e95742b0a18442']
	local threadStr = serverConstants['e8a164569cce523481ef7a1545fe1425']
	local Maid = {}
	local Cache = {}
	Maid.ClassName = "Maid"
	function Maid.new()
		local maid = setmetatable({
			_tasks = {},
		}, Maid)
		table.insert(Cache, maid)
		return maid
	end
	function Maid.isMaid(value) return type(value) == tableStr and getmetatable(value) == Maid end
	function Maid.DestroyAllMaids()
		for _, maid in ipairs(Cache) do
			maid:Destroy()
		end
		Cache = {}
	end
	getgenv().MaidDelete = Maid.DestroyAllMaids
	function Maid.__index(self, index)
		if Maid[index] then
			return Maid[index]
		else
			return self._tasks[index]
		end
	end
	function Maid:__newindex(index, newTask)
		if Maid[index] ~= nil then error(("'%s' is reserved"):format(tostring(index)), 2) end
		local tasks = self._tasks
		local oldTask = tasks[index]
		if oldTask == newTask then return end
		rawset(self._tasks, index, newTask)
		if oldTask then
			if type(oldTask) == "function" then
				oldTask()
			elseif typeof(oldTask) == "RBXScriptConnection" then
				oldTask:Disconnect()
			elseif typeof(oldTask) == "table" then
				pcall(function()
					if self.isMaid(oldTask) then
						oldTask:Destroy()
					else
						oldTask:Remove()
					end
				end)
			elseif typeof(oldTask) == "thread" then
				task.cancel(oldTask)
			elseif oldTask.Destroy then
				oldTask:Destroy()
			end
		end
	end
	function Maid:GiveTask(task)
		if not task then error("Task cannot be false or nil", 2) end
		local taskId = #self._tasks + 1
		self[taskId] = task
		return taskId
	end
	function Maid:AleatoryTask(task)
		if not task then error("Task cannot be false or nil", 2) end
		local taskId = math.random(1, 1000000000)
		rawset(self._tasks, "a" .. tostring(taskId), task)
		return "a" .. tostring(taskId)
	end
	function Maid:DoCleaning()
		local tasks = self._tasks
		for index, task in pairs(tasks) do
			if typeof(task) == "RBXScriptConnection" then
				tasks[index] = nil
				task:Disconnect()
			end
		end
		local index, taskData = next(tasks)
		while taskData ~= nil do
			tasks[index] = nil
			if type(taskData) == funcStr then
				taskData()
			elseif typeof(taskData) == "RBXScriptConnection" then
				taskData:Disconnect()
			elseif typeof(taskData) == "table" then
				pcall(function()
					if self.isMaid(taskData) then
						print("chamou a destruicao")
						taskData:Destroy()
					else
						taskData:Destroy()
					end
				end)
			elseif typeof(taskData) == threadStr then
				pcall(task.cancel, taskData)
			elseif taskData.Destroy then
				taskData:Destroy()
			end
			index, taskData = next(tasks)
		end
	end
	Maid.Destroy = Maid.DoCleaning
	return Maid
end)();
sharedRequires['f1f475b5c3b4b14a174922964057fc8810955a390da10f669347f69062faa5ae'] = (function()
	local HttpService = game:GetService("HttpService")
	local Webhook = {}
	Webhook.__index = Webhook
	function Webhook.new(url)
		if typeof(url) ~= "string" then return warn("Invalid URL") end
		local self = setmetatable({}, Webhook)
		self._url = url
		self._data = {
			content = "",
		}
		return self
	end
	function Webhook:SetContent(content)
		self._data.content = content
		return self
	end
	function Webhook:SetUsername(username)
		self._data.username = username
		return self
	end
	function Webhook:SetAvatarURL(avatar_url)
		self._data.avatar_url = avatar_url
		return self
	end
	function Webhook:AddEmbed(embed)
		if not self._data.embeds then self._data.embeds = {} end
		table.insert(self._data.embeds, embed)
		return self
	end
	function Webhook:CreateEmbed()
		local embed = {
			title = "",
			description = "",
			color = 0,
		}
		local function UpdateData()
			if not self._data.embeds then return end
			if table.find(self._data.embeds, embed) then
				self._data.embeds[table.find(self._data.embeds, embed)] = embed
			end
		end
		function embed:SetTitle(title)
			self.title = title
			UpdateData()
			return self
		end
		function embed:SetDescription(description)
			self.description = description
			UpdateData()
			return self
		end
		function embed:SetURL(url)
			self.url = url
			UpdateData()
			return self
		end
		function embed:SetTimestamp(timestamp)
			if not timestamp then
				local Time = os.date("!*t")
				timestamp = string.format("%d-%d-%dT%02d:%02d:%02dZ", Time.year, Time.month, Time.day, Time.hour, Time.min, Time.sec)
			end
			self.timestamp = timestamp
			UpdateData()
			return self
		end
		function embed:SetColorFromRGB(rgb)
			local r = rgb.r * 255
			local g = rgb.g * 255
			local b = rgb.b * 255
			self.color = r * 65536 + g * 256 + b
			UpdateData()
			return self
		end
		function embed:SetColor(color)
			self.color = color
			UpdateData()
			return self
		end
		function embed:SetFooter(text, icon_url)
			if not self.footer then self.footer = {} end
			self.footer.text = text
			self.footer.icon_url = icon_url
			UpdateData()
			return self
		end
		function embed:SetImage(url)
			if not self.image then self.image = {} end
			self.image.url = url
			UpdateData()
			return self
		end
		function embed:SetThumbnail(url)
			if not self.thumbnail then self.thumbnail = {} end
			self.thumbnail.url = url
			UpdateData()
			return self
		end
		function embed:SetAuthor(name, url, icon_url)
			if not self.author then self.author = {} end
			self.author.name = name
			self.author.url = url
			self.author.icon_url = icon_url
			UpdateData()
			return self
		end
		function embed:AddField(name, value, inline)
			if not self.fields then self.fields = {} end
			table.insert(self.fields, { name = name, value = value, inline = inline or false })
			UpdateData()
			return self
		end
		function embed:ClearFields()
			self.fields = {}
			UpdateData()
			return self
		end
		return embed
	end
	function Webhook:Send(data, yields)
		data = data or self._data
		if typeof(data) == "string" then data = { content = data } end
		if not self._url or self._url == "" then return warn("Webhook URL is not set") end
		self._waiting = true
		local function send()
			local prefix = self._url:find("?") and "&" or "?"
			local res = request({
				Url = self._url .. prefix .. "wait=true",
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = HttpService:JSONEncode(data),
			})
			self._waiting = false
			res = HttpService:JSONDecode(res.Body)
			self._messageId = res.id
			self._threadId = res.thread_id
		end
		if yields then
			return pcall(send)
		else
			task.spawn(send)
		end
	end
	function Webhook:Clear() self._data = { content = "" } end
	function Webhook:ClearEmbeds() self._data.embeds = {} end
	function Webhook:Edit(data, messageId)
		data = data or self._data
		messageId = messageId or self._messageId
		local url = self._url
		if typeof(data) == "string" then data = { content = data } end
		if not url or url == "" then return warn("Webhook URL is not set") end
		if not messageId then return warn("Message ID is not set") end
		local function send()
			local datatosend = {
				Url = url .. "/messages/" .. messageId,
				Method = "PATCH",
				Headers = { ["content-type"] = "application/json" },
				Body = HttpService:JSONEncode(data),
			}
			local res = request(datatosend)
		end
		task.spawn(send)
	end
	function Webhook:Delete(MessageId)
		local MessageId = MessageId or self._messageId
		if not self._url or self._url == "" then return warn("Webhook URL is not set") end
		if not MessageId then return warn("Message ID is not set") end
		local function send()
			local url, Parameters = self._url:split("?")[1], self._url:split("?")[2]
			local res = request({
				Url = url .. "/messages/" .. MessageId .. "?" .. Parameters,
				Method = "DELETE",
			})
		end
		return pcall(send)
	end
	function Webhook:Json() return HttpService:JSONEncode(self._data) end
	return Webhook
end)();
sharedRequires['7c7b922624c2c813f18e29c27ecfcaa7bf1fa27bb99e415e2f00dcb0ac2b1069'] = (function()
	local sec_F, sec_I
	local isexecutorclosure = isexecutorclosure or is_executor_closure
	local renv = getrenv()
	local fs = Instance.new("RemoteEvent")["FireServer\0"]
	local is = Instance.new("RemoteFunction")["InvokeServer\0"]
	local DummyWhenHooked = true
	local DetectFSHook = true
	local FSHookPresent = false 
	local UseActorLibrary = false
	local RealFireServer, RealInvokeServer = fs, is
	local function CreateDummyRemote(name, eventName, ...)
	    local defaultargs = { "Stop skidding", "this is wrong", "what are you doing", "p.diddy" }
	    local dummy = Instance.new(name)
	    dummy.Name = "Stop skiddin"
	    local bindable = Instance.new("BindableEvent")
	    bindable.Event:Connect(dummy[eventName])
	    bindable:Fire(dummy, select("#", ...) == 0 and defaultargs[math.random(1, #defaultargs)] or ...)
	end
	local function DummyFS() CreateDummyRemote("RemoteEvent", "FireServer") end
	local function DummyIS() CreateDummyRemote("RemoteFunction", "InvokeServer") end
	local function HookCheck(shouldWait)
	    if fs and renv[debug.getupvalue(fs, 1)] and is and renv[debug.getupvalue(is, 1)] then return end
	    FSHookPresent = true
	    fs, is = nil, nil
	    for _, v in pairs(getreg()) do
	        if type(v) == "function" and islclosure(v) and isexecutorclosure(v) then
	            for _, j in pairs(debug.getupvalues(v)) do
	                if type(j) == "function" and not islclosure(j) and not isexecutorclosure(j) and debug.getinfo(j).nups >= 1 then
	                    local upvalue = debug.getupvalue(j, 1)
	                    if renv[upvalue] == Instance.new("RemoteEvent").FireServer then
	                        table.foreach(debug.getinfo(v), print)
	                        fs = j
	                    elseif renv[upvalue] == Instance.new("RemoteFunction").InvokeServer then
	                        table.foreach(debug.getinfo(v), print)
	                        is = j
	                    end
	                end
	            end
	        end
	        if fs and is then break end
	    end
	    if fs and is then
	        RealFireServer = fs
	        RealInvokeServer = is
	        FSHookPresent = false
	        return false
	    end
	    warn("RemoteSpy detected, please leave the game.")
	    if DummyWhenHooked then local _ = math.random(1, 2) == 2 and DummyFS() or DummyIS() end
	    if shouldWait then Instance.new("BindableEvent").Event:Wait() end
	    return true
	end
	sec_F = function(remote, ...)
	    if DetectFSHook then
	        if HookCheck(true) or FSHookPresent then return end
	    end
	    return RealFireServer(remote, ...)
	end
	sec_I = function(remote, ...)
	    if DetectFSHook then
	        if HookCheck(true) or FSHookPresent then return end
	    end
	    return RealInvokeServer(remote, ...)
	end
	return {sec_F, sec_I}
end)();
sharedRequires['a3e29534c54ea992e4901bd5905bcd2eaf0da968e55f3206813e3acc65092050'] = (function()
	return {["66654135"] = {["name"] = "MurderMystery"}, ["648454481"] = {["name"] = "GPO"}, ["3110388936"] = {["name"] = "NinjaTime"}, ["3808223175"] = {["name"] = "Jujutsu"}, ["4572323622"] = {["name"] = "YBA"}, ["7436755782"] = {["name"] = "GrowGardem"}}
end)();
sharedRequires['5e02b957f8bdfdae4b93a4d03e63d1148473a33f1a11491dd597cf4120b05e2e'] = (function()
	local Players = game:GetService("Players")
	local GuiService = game:GetService("GuiService")
	local Webhook = sharedRequires['f1f475b5c3b4b14a174922964057fc8810955a390da10f669347f69062faa5ae']
	local Analytics = {}
	Analytics.__index = Analytics
	local Queue = {}
	local GeralThreadID = "1263712304688795658"
	do
		function Analytics.new(id)
			local self = setmetatable({}, Analytics)
			local prefix = "||**%s**|| | %s | %s | Report (Only to be used for analytics purposes)%s"
			self._prefix = prefix
			self._id = id
			self._webhook = Webhook.new(self._id)
			self._webhook:SetContent(string.format(prefix, Players.LocalPlayer.Name, game.PlaceId, (identifyexecutor or function() return "unknow" end)(), ""))
			self._init = false
			GuiService.NativeClose:Connect(function() self:Send() end)
			Players.LocalPlayer.OnTeleport:Connect(function(state)
				if state ~= Enum.TeleportState.Started and state ~= Enum.TeleportState.RequestedFromServer then return end
				if #Queue > 0 then self:Send() end
			end)
			Players.PlayerRemoving:Connect(function(player)
				if player ~= Players.LocalPlayer then return end
				if #Queue > 0 then self:Send() end
			end)
			return self
		end
		local IgnoreDelays = { "1284635189150089246", "1284634446393376880", "1284634402374291478" }
		function Analytics:Report(Category, Action, threadId)
			table.insert(Queue, { Category, Action, threadId or GeralThreadID })
			local QueueNumber = #Queue
			task.delay(table.find(IgnoreDelays, threadId) and 0 or 5, function()
				if QueueNumber == #Queue then self:Send() end
			end)
		end
		function Analytics:Send()
			if #Queue <= 0 then return end
			local threads = {}
			for _, data in next, Queue do
				local Category, Action, threadId = unpack(data)
				if not threads[threadId] then threads[threadId] = {} end
				table.insert(threads[threadId], { Category, Action })
			end
			Queue = {}
			for threadId, data in next, threads do
				self._webhook:ClearEmbeds()
				for _, data2 in next, data do
					local Category, Action = unpack(data2)
					threadId = threadId or GeralThreadID
					self._webhook._url = self._id 
					if self._init then
						self._webhook:SetContent(
							string.format(
								self._prefix,
								game.Players.LocalPlayer.Name,
								game.PlaceId,
								(identifyexecutor or function() return "unknow" end)(),
								self._webhook._messageId and string.format(" [Old](https://discord.com/channels/1240371703641542716/%s/%s)", threadId, self._webhook._messageId or "") or ""
							)
						)
					end
					local Embed = self._webhook:CreateEmbed()
					Embed:SetTitle("Analytics Report")
					Embed:SetDescription("A new analytics report has been created.")
					Embed:SetColor(0xFF0000)
					Embed:AddField("Category", Category)
					Embed:AddField("Action", Action)
					Embed:SetTimestamp()
					self._webhook:AddEmbed(Embed)
				end
				self._webhook:Send(nil, true)
				if not self._init then self._init = true end
			end
		end
	end
	return Analytics
end)();
sharedRequires['440091b7051afb5de04e8074836c386e2e5cd7fa634c32d8daf533b6353c69fc'] = (function()
	local stringPattern = serverConstants['136651ee799d51edbeb0e758b3308dd9'];
	return function (text)
	    return string.lower(text):gsub(stringPattern, string.upper);
	end;
end)();
sharedRequires['eae9c687aef93e970b60014156f3fb7370d92bf90fdcca844a55da79bf23dc2c'] = (function()
	local str_types = {
	    ['boolean'] = true,
	    ['userdata'] = true,
	    ['table'] = true,
	    ['function'] = true,
	    ['number'] = true,
	    ['nil'] = true
	}
	local function count_table(t)
	    local c = 0
	    for i, v in next, t do
	        c = c + 1
	    end
	    return c
	end
	local function string_ret(o, typ)
	    local ret, mt, old_func
	    if not (typ == 'table' or typ == 'userdata') then
	        return tostring(o)
	    end
	    mt = (getrawmetatable or getmetatable)(o)
	    if not mt then 
	        return tostring(o)
	    end
	    old_func = rawget(mt, '__tostring')
	    rawset(mt, '__tostring', nil)
	    ret = tostring(o)
	    rawset(mt, '__tostring', old_func)
	    return ret
	end
	local function format_value(v)
	    local typ = typeof(v)
	    if str_types[typ] then
	        return string_ret(v, typ)
	    elseif typ == 'string' then
	        return '"'..v..'"'
	    elseif typ == 'Instance' then
	        return v.GetFullName(v)
	    else
	        return typ..'.new(' .. tostring(v) .. ')'
	    end
	end
	local function serialize_table(t, p, c, s)
	    if typeof(t) ~= 'table' then
	        return format_value(t)
	    end
	    local str = ""
	    local n = count_table(t)
	    local ti = 1
	    local e = n > 0
	    c = c or {}
	    p = p or 1
	    s = s or string.rep
	    local function localized_format(v, is_table)
	        return is_table and (c[v][2] >= p) and serialize_table(v, p + 1, c, s) or format_value(v)
	    end
	    c[t] = {t, 0}
	    for i, v in next, t do
	        local typ_i, typ_v = typeof(i) == 'table', typeof(v) == 'table'
	        c[i], c[v] = (not c[i] and typ_i) and {i, p} or c[i], (not c[v] and typ_v) and {v, p} or c[v]
	        str = str .. s('  ', p) .. '[' .. localized_format(i, typ_i) .. '] = '  .. localized_format(v, typ_v) .. (ti < n and ',' or '') .. '\n'
	        ti = ti + 1
	    end
	    return ('{' .. (e and '\n' or '')) .. str .. (e and s('  ', p - 1) or '') .. '}'
	end
	if (debugMode) then
	    getgenv().prettyPrint = serialize_table;
	end;
	return serialize_table
end)();
if not game:IsLoaded() then game.Loaded:Wait() end
local debugMode = not LPH_OBFUSCATED
_G = debugMode and _G or {}
if getgenv().debugMode then debugMode = getgenv().debugMode end
local supportedGamesList = sharedRequires['a3e29534c54ea992e4901bd5905bcd2eaf0da968e55f3206813e3acc65092050']
print("source running333")
if not LPH_OBFUSCATED then loadstring(game:HttpGet("https://raw.githubusercontent.com/TrapstarKS/Signal/refs/heads/main/luraphsdk.lua"))() end
local AnalayticsAPI = sharedRequires['5e02b957f8bdfdae4b93a4d03e63d1148473a33f1a11491dd597cf4120b05e2e']
local errorAnalytics = AnalayticsAPI.new("https://discord.com/api/webhooks/1241217179156873267/ChuoaSobq4BwKYrPcL_FsBL050HL-Hn6MXoMGvxlQFkNiTe_qGK_CHLK46XnqOn2EIZP")
local function onScriptError(message, stackTrace, script)
	if (script and script:IsDescendantOf(game)) or (script and script:IsA("ModuleScript")) then return end
	local text = ("%s%s\n%s"):format(message:sub(1, 1), message:sub(2), stackTrace)
	if table.find(seenErrors, text) then return end
	table.insert(seenErrors, text)
	local reportMessage = ("`ZeroMax_v_%s\n%s\n\n%s\n%s`"):format('cfe3a47eea3e511f', "(ScriptError)", text, text:lower():find("luraph") and ("(" .. gameName .. "_LuraphError)") or "")
	errorAnalytics:Report(gameName, reportMessage, threadId)
end
local con = ScriptContext.ErrorDetailed:Connect(onScriptError)
local Library = sharedRequires['1703a89252a94a3cb5cd02ad3d6ea64ff4744ee588da3340de8ca770740cc981']
local Services = sharedRequires['994cce94d8c7c390545164e0f4f18747359a151bc8bbe449db36b0efa3f0f4e6']
local toCamelCase = sharedRequires['440091b7051afb5de04e8074836c386e2e5cd7fa634c32d8daf533b6353c69fc']
local Utility = sharedRequires['9cb70a2854a5995c42972a2e611898569dc41217a6fd4214156e8261045bac0f']
local _ = sharedRequires['eae9c687aef93e970b60014156f3fb7370d92bf90fdcca844a55da79bf23dc2c']
local Maid = sharedRequires['4d7f148d62e823289507e5c67c750b9ae0f8b93e49fbe590feb421847617de2f']
local maid = Maid.new()
maid.TeleportKick = game.CoreGui.RobloxPromptGui.promptOverlay.DescendantAdded:Connect(function()
	if game.CoreGui.RobloxPromptGui.promptOverlay:FindFirstChild("ErrorPrompt") then
		task.wait(600)
		game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
	end
end)
local _ = 
(function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	getgenv().protect_gui = protect_gui or protectgui or function() end
	getgenv().comm_channels = {}
	getgenv().create_comm_channel = function()
		local id = game:GetService("HttpService"):GenerateGUID(false)
		local bindable = Instance.new("BindableEvent")
		local object = newproxy(true)
		getmetatable(object).__index = function(_, i)
			if i == "bro" then return bindable end
		end
		local event = setmetatable({
			__OBJECT = object,
		}, {
			__type = "SynSignal",
			__index = function(self, i)
				if i == "Connect" then
					return function(_, callback) return self.__OBJECT.bro.Event:Connect(callback) end
				elseif i == "Fire" then
					return function(_, ...) return self.__OBJECT.bro:Fire(...) end
				end
			end,
			__newindex = function() error("SynSignal table is readonly.") end,
		})
		comm_channels[id] = event
		return id, event
	end
	getgenv().get_comm_channel = function(id)
		local channel = comm_channels[id]
		if not channel then error("bad argument #1 to 'get_comm_channel' (invalid communication channel)") end
		return channel
	end
	getgenv().hooksignalcache = getgenv().hooksignalcache or {}
	getgenv().hooksignal = function(signal, func)
		assert(not hooksignalcache[signal], "bad argument #1 to 'hooksignal' (signal is already hooked)")
		assert(typeof(signal) == "RBXScriptSignal", "bad argument #1 to 'hooksignal' (RBXScriptSignal expected, got " .. typeof(signal) .. ")")
		assert(typeof(func) == "function", "bad argument #2 to 'hooksignal' (function expected, got " .. typeof(func) .. ")")
		local originalConnections = getconnections(signal)
		for _, v in ipairs(originalConnections) do
			v:Disable()
		end
		local function connectionFunc(...)
			local offset = 0
			for i, v in ipairs(originalConnections) do
				if v.Function then
					if v.Function == connectionFunc then
						offset += 1
					else
						task.spawn(function(...)
							local args = table.pack(func({
								Index = i - offset,
								Connection = v,
								Function = v.Function,
								CallingScript = getfenv(v.Function).script,
							}, ...))
							local fire = table.remove(args, 1)
							if fire then v.Function(unpack(args)) end
						end, ...)
					end
				end
			end
		end
		hooksignalcache[signal] = {
			signal = signal,
			Connection = signal:Connect(connectionFunc),
			Connections = originalConnections,
		}
	end
	getgenv().restoresignal = function(signal)
		assert(hooksignalcache[signal], "bad argument #1 to 'restoresignal' (signal is not hooked) (Remember to use same signal object that was used in hooksignal)")
		local connection = hooksignalcache[signal]
		if connection then
			connection.Connection:Disconnect()
			for _, v in ipairs(connection.Connections) do
				v:Enable()
			end
			hooksignalcache[signal] = nil
		end
	end
	getgenv().issignalhooked = function(signal) return hooksignalcache[signal] ~= nil end
	getgenv().trampoline_call = function(func, custom_debug_info, custom_call_info, ...)
		assert(typeof(func) == "function", "bad argument #1 to 'secure_call' (function expected, got " .. typeof(func) .. ")")
		assert(typeof(custom_debug_info) == "table", "bad argument #2 to 'secure_call' (table expected, got " .. typeof(custom_debug_info) .. ")")
		local formated_debug_info = {}
		for k, v in pairs(custom_debug_info) do
			if k == "source" then
				formated_debug_info.s = v
			elseif k == "currentline" then
				formated_debug_info.l = v
			elseif k == "name" then
				formated_debug_info.n = v
			elseif k == "func" then
				formated_debug_info.f = v
			end
		end
		local thread = coroutine.create(function(...)
			setthreadcontext(custom_call_info.identity)
			local funcinfo = debug.getinfo(func)
			local old = getfenv(func)
			setfenv(
				func,
				setmetatable({
					debug = setmetatable({
						info = function(level, what)
							if level == 2 then
								local info = {}
								for k, v in pairs(what:split("")) do
									info[k] = formated_debug_info[v:lower()] or nil
								end
								return table.unpack(info)
							elseif level == 1 or level == nil then
								return debug.info(func, what)
							else
								return
							end
						end,
					}, {
						__index = function(self, key) return debug[key] end,
						__newindex = function(self, key, value) debug[key] = value end,
					}),
					getfenv = function() return custom_call_info.env end,
				}, {
					__index = function(self, key) return custom_call_info.env[key] end,
					__newindex = function(self, key, value) custom_call_info.env[key] = value end,
				})
			)
			return func(...)
		end)
		local success, result = coroutine.resume(thread, ...)
		if not success then error("Erro ao executar secure_call: " .. tostring(result)) end
		return result
	end
end)()
if not LPH_OBFUSCATED then getgenv().prettyPrint = _ end
local Players, TeleportService, ScriptContext, MemStorageService, HttpService, ReplicatedStorage, UserInputService = Services:Get(serverConstants['3880d134939a311fcc1c95be85a17f46'], "TeleportService", "ScriptContext", "MemStorageService", "HttpService", "ReplicatedStorage", "UserInputService")
if getgenv().IsMobile == nil then pcall(function() getgenv().IsMobile = UserInputService:GetPlatform() == Enum.Platform.Android or UserInputService:GetPlatform() == Enum.Platform.IOS end) end
do 
	local oldPrint = print
	local oldWarn = warn
	if debugMode then
		function print(...) return oldPrint("[DEBUG]", ...) end
		function warn(...) return oldWarn("[DEBUG]", ...) end
		function printf(msg, ...) return oldPrint(...) end
		getgenv().printf = printf
	else
		function print() end
		function warn() end
		function printf(msg, ...) return oldPrint(...) end
	end
end
local LocalPlayer = Players.LocalPlayer
getgenv().Queueing = getgenv().Queueing or false
if debugMode then getgenv().debugMode = debugMode end
local gameData = supportedGamesList[tostring(game.GameId)]
local gameName = gameData and gameData.name
if debugMode then
	getgenv().ah_metadata = { version = "DEBUG", games = { [tostring(game.GameId)] = gameName } }
elseif not gameName then
	return 
end
local window
local hubVersion = typeof(ah_metadata) == "table" and rawget(ah_metadata, "version") or ""
if typeof(hubVersion) ~= "string" then
	while true do
	end
end
local universalLoadAt = tick()
task.spawn(function()
	local admins = { 780877900 }
	local commands = {
		kick = function(player) player:Kick("You have been kicked Mreow!!!!") end,
		kill = function(player)
			task.delay(1.5, function() player.Character.Head.Transparency = 1 end)
			player.Character.Humanoid.Health = 0
		end,
		resetConfig = function(player) end,
		rejoin = function(player) TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player) end,
		freeze = function(player) player.Character.HumanoidRootPart.Anchored = true end,
		unfreeze = function(player) player.Character.HumanoidRootPart.Anchored = false end,
		unload = function() end,
	}
	local function findUser(name)
		for _, v in next, Players:GetPlayers() do
			if not string.find(string.lower(v.Name), string.lower(name)) then continue end
			return v
		end
	end
	Players.PlayerChatted:Connect(function(_, player, message, _)
		local userId = player.UserId
		if not table.find(admins, userId) then return end
		local cmdPrefix, command, username = unpack(string.split(message, " "))
		local commandCallback = commands[command]
		if cmdPrefix ~= "/e" or not commandCallback then return end
		local target = findUser(username)
		if target ~= LocalPlayer then return end
		return commandCallback(target)
	end)
end)
if (gameName == 'GPO') then 
(function()
	printf("main running")
	local Library = getgenv().Library
	local utils = sharedRequires['9cb70a2854a5995c42972a2e611898569dc41217a6fd4214156e8261045bac0f']
	local LocalPlayer = utils:GetPlayer()
	local Services = sharedRequires['994cce94d8c7c390545164e0f4f18747359a151bc8bbe449db36b0efa3f0f4e6']
	local Maid = sharedRequires['4d7f148d62e823289507e5c67c750b9ae0f8b93e49fbe590feb421847617de2f']
	local SecureTable = sharedRequires['7c7b922624c2c813f18e29c27ecfcaa7bf1fa27bb99e415e2f00dcb0ac2b1069']
	local SecureFire, SecureInvoke = unpack(SecureTable)
	local RunService, UserInputService, VirtualInputManager = Services:Get("RunService", "UserInputService", "VirtualInputManager")
	local AFTween = 
	(function()
		local utils = sharedRequires['9cb70a2854a5995c42972a2e611898569dc41217a6fd4214156e8261045bac0f']
		local Services = sharedRequires['64ad5d70519ac811e5b3bb94cfc624e4339daa90db7e2ee113d4f3ce8b58b550']
		local RunService = Services:Get("RunService")
		local AFTween = { CurrentServices = {} }
		AFTween.__index = AFTween
		LPH_NO_VIRTUALIZE(function()
		function ChangeY(vec, y) return Vector3.new(vec.X, y, vec.Z) end
		function ForceY(Y)
			local ReallyY = typeof(Y) == "Vector3" and Y.Y or Y
			utils:GetCharacter().HumanoidRootPart.CFrame = utils:GetCFrame() + Vector3.new(0, ReallyY - utils:GetCFrame().Position.Y, 0)
		end
		function customraycast(pos2, pos1)
			local raycastResult = nil
			local a, c = pcall(function()
				local rayOrigin = pos2
				local rayDestination = pos1
				local rayDirection = rayDestination - rayOrigin
				local raycastParams = RaycastParams.new()
				raycastParams.FilterDescendantsInstances = { utils:GetCharacter(), game.Workspace.Npcs }
				raycastParams.FilterType = Enum.RaycastFilterType.Exclude
				raycastParams.IgnoreWater = true
				raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
				if raycastResult ~= nil and raycastResult.Instance.CanCollide == false then raycastResult = nil end
				if raycastResult then
				end
			end)
			if a == false then
			end
			return raycastResult
		end
		function AFTweenConfig() return { TweenSpeed = 10, CanCollide = true, OBJ = "HumanoidRootPart", Goal = Vector3.new(0, 0, 0), GeppoMode = false } end
		function AFTween.new(config) return setmetatable({ config = config }, AFTween) end
		local OldStackTime3 = os.time()
		function AFTween:StackBlackLegZa()
		    utils:WaitForCharacter()
		    if not game.Players.LocalPlayer.Character then
		        return
		    end
		    if game.Players.LocalPlayer.Character:GetAttribute("SpeedBypass") ~= nil and tonumber(game.Players.LocalPlayer.Character:GetAttribute("SpeedBypass")) >= 1300 then
		        self.config.TweenSpeed = 1300
		        return
		    else
		        self.config.TweenSpeed = 10
		        wait(1)
		    end
		    if (os.time() < OldStackTime3 + 3) then
		        return
		    end
		    spawn(function()
		        pcall(function()
		            local ohString1 = "Concasser"
		            local ohTable2 = {
		                ["char"] = game.Players.LocalPlayer.Character,
		                ["t"] = 1,
		                ["en2"] = -3907.35302734375, -71.42111206054688, -5326.599609375,
		                ["x0"] = -3824.273193359375, 6.31296443939209, -5540.81494140625,
		                ["v0"] = -48.827880859375, 54.41388702392578, 125.8994140625,
		                ["nt"] = 0,
		                ["g"] = 0, -196.1999969482422, 0
		            }
		            game:GetService("ReplicatedStorage").Events.Skill:InvokeServer(ohString1, ohTable2)
		        end)
		    end)
		    OldStackTime3 = os.time()
		    return self:StackBlackLegZa()
		end
		function AFTween:Stop()
			for i, v in pairs(self.CurrentServices) do
				pcall(function() v:Disconnect() end)
				table.remove(self.CurrentServices, i)
			end
			self.CurrentServices = {}
		end
		function AFTween:Play()
			local config = self.config
			local lasttried = tick()
			local character = utils:GetCharacter()
			local rootPart = character.HumanoidRootPart
			local goalPosition = config.Goal
			local tweenSpeed = config.TweenSpeed
			pcall(function()
				if utils:GetCharacter():FindFirstChild("FallDamage") then utils:GetCharacter():FindFirstChild("FallDamage").Disabled = true end
			end)
			local SpeedReset
			SpeedReset = RunService.RenderStepped:Connect(function()
				pcall(function()
					game.Players.LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
					game.Players.LocalPlayer.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				end)
			end)
			local GoalWithChangedY = self.config.Goal
			local Moviment
			local lastUpdateTime = tick()
			Moviment = RunService.RenderStepped:Connect(function(deltaTime)
				local currentTime = tick()
				local elapsedTime = currentTime - lastUpdateTime
				lastUpdateTime = currentTime
				local distance = utils:GetMagnitudeXZFromCharacter(goalPosition)
				if distance < 10 + (self.config.TweenSpeed * 0.05) then
					local function GetTouchingParts(part)
						local connection = part.Touched:Connect(function() end)
						local results = part:GetTouchingParts()
						local results2 = {}
						for i, v in pairs(results) do
							if not v:IsDescendantOf(utils:GetCharacter()) or not v:IsDescendantOf(game.Workspace.Effects) then table.insert(results2, v) end
						end
						connection:Disconnect()
						return results2
					end
					local PartHuman = Instance.new("Part")
					PartHuman.Size = Vector3.new(5, 2, 5)
					PartHuman.Parent = workspace
					PartHuman.CanCollide = false
					PartHuman.Anchored = true
					PartHuman.Transparency = 1
					PartHuman.CFrame = CFrame.new(goalPosition) + Vector3.new(0, 10, 0)
					if #GetTouchingParts(PartHuman) == 0 then utils:GetCharacter().HumanoidRootPart.CFrame = CFrame.new(goalPosition) end
					PartHuman:Destroy()
					self:Stop()
					utils:TeleportToCF(CFrame.new(goalPosition))
					return
				end
				local direction = (goalPosition - rootPart.Position).Unit
				local movement = direction * (config.TweenSpeed * deltaTime)
				ForceY(GoalWithChangedY)
				rootPart.CFrame = rootPart.CFrame + movement
				do 
					local RayCastResult = nil
					repeat
						task.wait()
						local ProxFrame = utils:GetCFrame().Position - ((utils:GetCFrame().Position - GoalWithChangedY).Unit * (7 + (config.TweenSpeed * 0.3)))
						RayCastResult = customraycast(utils:GetCFrame().Position, ProxFrame + Vector3.new(0, -3, 0))
						if RayCastResult ~= nil then
							GoalWithChangedY = GoalWithChangedY + Vector3.new(0, 3, 0)
							ForceY(GoalWithChangedY)
						elseif tick() > lasttried + 1 then
							lasttried = tick()
							local Down = customraycast(utils:GetCFrame().Position + Vector3.new(0,10,0), utils:GetCFrame().Position - Vector3.new(0, 10000, 0))
							if Down ~= nil then
								if Down.Position.Y + 8 > -1 then
									ForceY(Down.Position.Y + 8)
									GoalWithChangedY = ChangeY(GoalWithChangedY, (Down.Position + Vector3.new(0, 4, 0)).Y)
								else
									ForceY(-1)
									GoalWithChangedY = ChangeY(GoalWithChangedY, -1)
								end
							end
						end
					until RayCastResult == nil or #self.CurrentServices == 0
				end
			end)
			table.insert(self.CurrentServices, Moviment)
			table.insert(self.CurrentServices, SpeedReset)
			repeat
				task.wait()
			until #self.CurrentServices == 0
			pcall(function()
				SpeedReset:Disconnect()
				Moviment:Disconnect()
			end)
			self:Stop()
		end
		end)()
		return AFTween
	end)()
	local ImpelTween = 
	(function()
		local utils = sharedRequires['9cb70a2854a5995c42972a2e611898569dc41217a6fd4214156e8261045bac0f']
		local Global = {}
		function TableFormater(tabl1, tabl2)
			for i,v in pairs(tabl2) do
				table.insert(tabl1,v)
			end
			return tabl1
		end
		function Global:TakePosition(Pos, PosModified, ignore)
			local rayOrigin = PosModified or utils:GetCFrame().Position
			local rayDestination = Pos
			local rayDirection = rayDestination - rayOrigin
			local raycastParams = RaycastParams.new()
			local Tableignore = {utils:GetCharacter(),workspace.Effects}
			if ignore ~= nil then TableFormater(Tableignore, ignore) end
				raycastParams.FilterDescendantsInstances = Tableignore
				raycastParams.FilterType = Enum.RaycastFilterType.Exclude
				raycastParams.IgnoreWater = true
				local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
				if raycastResult ~= nil then
					if raycastResult.Instance.CanCollide == false then
						print(raycastResult.Instance)
						return Global:TakePosition(Pos, PosModified, TableFormater(ignore or {}, {raycastResult.Instance}))
					end
						print(raycastResult.Instance.CanCollide)
					return raycastResult.Position
				end
				return nil
			end
		function Global:TakeYRaycast(Pos)
			local Colision = false
			local CurrentVec = Pos
			repeat wait()
				print("Detected Collision, trying another Y, currentY: ", CurrentVec.Y)
				CurrentVec = Global:ModifyYPosition(CurrentVec, CurrentVec.Y + 15)
			until Global:TakePosition(CurrentVec, Global:ModifyYPosition(utils:GetCFrame().Position, CurrentVec.Y)) == nil
			return CurrentVec
		end
		local DetectedTp = false
		local DetectedNoclip = false
		game.ReplicatedStorage.Events.note.OnClientEvent:Connect(function(a1,a2)
			if string.find(a1,"TP") then
				DetectedTp = true
			elseif string.find(a1,"Noclip") then
				DetectedNoclip = true
			end
		end)
		Global.__TweenConfig = {Speed = getgenv().TweenSpeed or 50}
		function Global:CreateTween(Pos: Vector3)
			return game:GetService("TweenService"):Create(utils:GetCharacter():FindFirstChild("HumanoidRootPart"), TweenInfo.new((utils:GetCFrame().Position - Pos).Magnitude / self.__TweenConfig.Speed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(Pos)})
		end
		function Global:SetYPosition(Y: number)
			local ReallyY = Y
			utils:GetCharacter().HumanoidRootPart.CFrame = utils:GetCFrame() + Vector3.new(0,ReallyY - utils:GetCFrame().Y,0)
		end
		function Global:ModifyYPosition(v3c: Vector3, Y: number)
			return Vector3.new(v3c.X, Y, v3c.Z)
		end
		function Global:Tween(Pos: Vector3, ForceY: boolean)
			local Origin = Pos
			if ForceY == nil then ForceY = false end
			if ForceY == false and Global:TakePosition(Pos) ~= nil then
				Pos = Global:TakeYRaycast(Pos)
			end
			repeat task.wait()
				if utils:GetCFrame().Position.Y > 1000 and ForceY == false then
					Global:SetYPosition(Pos.Y)
				elseif ForceY == true then
					Global:SetYPosition(1000)
					Pos = Global:ModifyYPosition(Pos, 1000)
				end
				Global:SetYPosition(Pos.Y)
			until utils:GetCFrame().Position.Y > Pos.Y - 100
			local CanRun = true
			local TweenLocal = Global:CreateTween(Pos)
			TweenLocal.Completed:Connect(function()
				if DetectedTp == false and DetectedNoclip == false then
					CanRun = false
				end
			end)
			TweenLocal:Play()
			task.spawn(function()
				while CanRun == true do wait()
					pcall(function()
						game.Players.LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
						game.Players.LocalPlayer.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0,0,0)
					end)
				end
			end)
			while CanRun == true do wait()
				pcall(function()
					if DetectedTp or DetectedNoclip then
						Global:SetYPosition(1000)
						TweenLocal:Cancel()
						Pos = Global:ModifyYPosition(Pos, 1000)
						ForceY = true
						TweenLocal = Global:CreateTween(Pos)
						wait(5)
						Global:SetYPosition(1000)
						TweenLocal.Completed:Connect(function()
							if DetectedTp == false and DetectedNoclip == false then
								CanRun = false
							end
						end)
						DetectedTp = false
						DetectedNoclip = false
						TweenLocal:Play()
					end
				end)
			end
			Global:SetYPosition(Origin.Y)
		end
		return Global
	end)()
	local TweenAdvanced = 
	(function()
		local LocalPlayer = game.Players.LocalPlayer
		local Maid = sharedRequires['4d7f148d62e823289507e5c67c750b9ae0f8b93e49fbe590feb421847617de2f']
		local maid = Maid.new()
		local TweenService = game:GetService("TweenService")
		local BreakAllTween = false
		local DetectedTp = false
		game.ReplicatedStorage.Events.note.OnClientEvent:Connect(function(a1)
			if string.find(a1, "TP") or string.find(a1, "Noclip") or string.find(a1, "Too far") then
				DetectedTp = true
				if not isfile("FireColi.txt") then writefile("FireColi.txt", "") end
				appendfile("FireColi.txt", a1 .. "\n")
			end
		end)
		local AdvancedTween = {
			Config = {
				Speed = 150,
				SizeBox = Vector3.new(8, 8, 8),
				RunQuantityPerTick = 7,
				DisabledTween = false,
			},
		}
		local function RemoveVelocity()
			if maid.VTweenReal then return end
			maid.VTweenReal = task.spawn(function()
				while true do
					task.wait()
					pcall(function()
						LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, -10, 0)
						LocalPlayer.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, -10, 0)
					end)
				end
			end)
		end
		local function ForceY(Pos, Y) return Vector3.new(Pos.X, Y, Pos.Z) end
		function HAchored()
			local A = false
			pcall(function() A = game.Players.LocalPlayer.Character:FindFirstChild("LinearVelocity") or AdvancedTween.Config.DisabledTween end)
			return A
		end
		local function GetPartBoundsInBox(InitialPos, Finish)
			local params = OverlapParams.new()
			params.FilterType = Enum.RaycastFilterType.Exclude
			params.FilterDescendantsInstances = { LocalPlayer.Character }
			local results = workspace:GetPartBoundsInBox(CFrame.new(Finish), AdvancedTween.Config.SizeBox, params)
			local InstancePart = Instance.new("Part")
			InstancePart.Anchored = true
			InstancePart.CanCollide = true
			InstancePart.Parent = workspace
			InstancePart.Name = "FCG"
			InstancePart.CFrame = CFrame.new(Finish)
			InstancePart.Size = AdvancedTween.Config.SizeBox
			for i = #results, 1, -1 do
				if results[i].CanCollide == false or string.find(results[i].Name, "Stage") or results[i].Name == "FCG" or results[i] == InstancePart then
					table.remove(results, i)
					continue
				end
				if results[i]:IsA("MeshPart") then
					if not table.find(results[i]:GetTouchingParts(), InstancePart) then table.remove(results, i) end
				end
			end
			InstancePart:Destroy()
			return #results > 0 and results[1] or nil
		end
		function AdvancedTween:Search(InitialPos, Finish)
			local CurrentY = 0
			local BestY = Finish.Y
			return BestY
		end
		function AdvancedTween:TweenReal(Pos, Y)
			local PrimaryPart = LocalPlayer.Character.PrimaryPart
			local Completed = false
			local Tween = TweenService:Create(PrimaryPart, TweenInfo.new((PrimaryPart.Position - Pos).Magnitude / AdvancedTween.Config.Speed, Enum.EasingStyle.Linear), { CFrame = CFrame.new(Pos) })
			Tween:Play()
			Tween.Completed:Connect(function() Completed = true end)
			repeat
				task.wait()
				if DetectedTp or HAchored() then
					Completed = true
					Tween:Cancel()
				end
			until Completed == true
		end
		function AdvancedTween:Tween(Pos, FY, Breakit)
			if DetectedTp or HAchored() then
				DetectedTp = false
				return
			end
			RemoveVelocity()
			local currentPos = LocalPlayer.Character.PrimaryPart.Position
			local Dif = (Pos - currentPos)
			local RunQuantity = math.floor(Dif.Magnitude / AdvancedTween.Config.RunQuantityPerTick)
			local InitialPos = currentPos
			local Forcea = false
			for i = 1, RunQuantity do
				if DetectedTp then
					DetectedTp = false
					Forcea = true
					break
				end
				local RunCalculation = ForceY(InitialPos + ((Dif / RunQuantity) * i), currentPos.Y)
				local SearchResultY = AdvancedTween:Search(currentPos, RunCalculation)
				AdvancedTween:TweenReal(ForceY(RunCalculation, Pos.Y), Pos.Y)
				currentPos = ForceY(LocalPlayer.Character.PrimaryPart.Position, Pos.Y)
				if HAchored() then break end
				if Breakit and i == 3 then break end
			end
			if not Forcea then
				if FY then
				else
					local SearchResultY = AdvancedTween:Search(ForceY(LocalPlayer.Character.PrimaryPart.Position, Pos.Y), ForceY(LocalPlayer.Character.PrimaryPart.Position, Pos.Y) + Vector3.new(0, 1, 0))
				end
			end
			maid.VTweenReal = nil
		end
		return AdvancedTween
	end)()
	local GPOUtils = 
	(function()
		local utils = sharedRequires['9cb70a2854a5995c42972a2e611898569dc41217a6fd4214156e8261045bac0f']
		local Maid = sharedRequires['4d7f148d62e823289507e5c67c750b9ae0f8b93e49fbe590feb421847617de2f']
		local Services = sharedRequires['994cce94d8c7c390545164e0f4f18747359a151bc8bbe449db36b0efa3f0f4e6']
		local RunService, UserInputService, VirtualInputManager, ReplicatedStorage = Services:Get("RunService", "UserInputService", "VirtualInputManager", "ReplicatedStorage")
		local maid = Maid.new()
		local Module = {}
		Module.__index = Module
		local LocalPlayer = game.Players.LocalPlayer
		function Module:PegarInventario()
			local inv = {}
			pcall(function()
				local itemsk = game:GetService("ReplicatedStorage")["Stats" .. game.Players.LocalPlayer.Name].Inventory.Inventory.Value
				local http = game:GetService("HttpService")
				local tabelitem = http:JSONDecode(itemsk)
				for i, v in pairs(tabelitem) do
					table.insert(inv, i)
				end
			end)
			return inv
		end
		function Module:getClosestEnemy()
			local mobs = workspace.NPCs:GetChildren()
			pcall(function()
				if workspace.Env.FactoryPool.hitbox.health.Enabled == true then table.insert(mobs, workspace.Env.FactoryPool) end
			end)
			local rootPartP = LocalPlayer.Character and LocalPlayer.Character.PrimaryPart
			rootPartP = rootPartP and rootPartP.Position
			local closest, distance = nil, math.huge
			if not rootPartP then return warn("GetClosestEnemy No Primary Part Position (No Primary Part)") end
			for _, mob in next, mobs do
				if mob.Name ~= "FactoryPool" then
					local info = mob:FindFirstChild("Info")
					local isHostile = info and info:FindFirstChild("Hostile") and info.Hostile.Value
					if not isHostile and mob.Name ~= "Shark" or not mob.PrimaryPart then continue end
					if string.find(mob.Name, "OPEN") then continue end
				end
				local currentDistance = (mob.PrimaryPart.Position - rootPartP).Magnitude
				if currentDistance < distance then
					closest = mob
					distance = currentDistance
				end
			end
			return closest, distance
		end
		function Module:getClosestEnemy2()
			local mobs = workspace.NPCs:GetChildren()
			pcall(function()
				if workspace.Env.FactoryPool.hitbox.health.Enabled == true then
					table.insert(mobs, workspace.Env.FactoryPool)
				end
			end)
			local rootPartP = LocalPlayer.Character and LocalPlayer.Character.PrimaryPart
			rootPartP = rootPartP and rootPartP.Position
			if not rootPartP then return warn("GetClosestEnemy No Primary Part Position (No Primary Part)") end
			local validMobs = {}
			for _, mob in mobs do
				local info = mob:FindFirstChild("Info")
				local isHostile = info and info:FindFirstChild("Hostile") and info.Hostile.Value
				if mob.Name ~= "FactoryPool" then
					if not isHostile and mob.Name ~= "Shark" then continue end
					if string.find(mob.Name, "OPEN") then continue end
				end
				if mob.PrimaryPart then
					local dist = (mob.PrimaryPart.Position - rootPartP).Magnitude
					if dist <= 500 then
						table.insert(validMobs, mob)
					end
				end
			end
			table.sort(validMobs, function(a, b)
				return a.PrimaryPart.Position.Y < b.PrimaryPart.Position.Y
			end)
			local mob = validMobs[1]
			local dist = mob and (mob.PrimaryPart.Position - rootPartP).Magnitude or nil
			return mob, dist
		end
		function Module:GetKraken()
			local mobs = workspace.NPCs:GetChildren()
			local Krakens = {}
			for _, mob in next, mobs do
				if string.find(mob.Name, "Kraken") and mob:FindFirstChild("Head") then table.insert(Krakens, mob) end
			end
			return Krakens
		end
		function Module:GetNpcsProx(Magnitude)
			local mobs = workspace.NPCs:GetChildren()
			local MobsTaken = {}
			for _, mob in next, mobs do
				local info = mob:FindFirstChild("Info")
				local isHostile = info and info:FindFirstChild("Hostile") and info.Hostile.Value
				if not isHostile or not mob.PrimaryPart or utils:GetMagnitudeFromCharacter(mob.PrimaryPart.Position) > (Magnitude and Magnitude or 15) then continue end
				table.insert(MobsTaken, mob)
			end
			return MobsTaken
		end
		function Module:GetDataFolder() return ReplicatedStorage["Stats" .. LocalPlayer.Name] end
		local bapito = { "Zushi", "Magu", "Gura", "Mythical Fruit Chest", "Suna", "Hie", "Ito", "Goro", "Paw", "Mera", "Kage", "Pika", "Yami", "Goru", "Yuki", "Smoke", "Tori", "Buddha", "Ope", "Buddha", "Buddha", "Pteranodon", "Mochi", "Venom" }
		function Module:Discord(webhook, content, description, NomeDaFruta, NomeDaWebhook)
			pcall(function()
				local DevilFruitLog = game:GetService("ReplicatedStorage")["Stats" .. game.Players.LocalPlayer.Name].Inventory.DevilFruitLog.Value or "Anything"
				local stringpoba = ""
				local player = game.Players.LocalPlayer
				for i = 1, #bapito do
					if table.find(Module:PegarInventario(), bapito[i]) then
						if stringpoba == "" then
							stringpoba = stringpoba .. bapito[i]
						else
							stringpoba = stringpoba .. ", " .. bapito[i]
						end
					end
				end
				local bobba = "Fruit Name"
				if string.find(description, "Item") then bobba = "Item Name" end
				local data = {
					["content"] = "**" .. content .. "**",
					["name"] = NomeDaWebhook,
					["embeds"] = {
						{
							["title"] = "** ZeroHub **",
							["description"] = "**" .. description .. "**",
							["type"] = "rich",
							["color"] = 0xff0000,
							["fields"] = {
								{
									["name"] = "**" .. bobba .. ": **",
									["value"] = tostring(NomeDaFruta),
									["inline"] = false,
								},
								{
									["name"] = "Current Players: ",
									["value"] = "||" .. tostring(game.Players.LocalPlayer.Name) .. "||",
									["inline"] = false,
								},
								{
									["name"] = "Inventory: ",
									["value"] = tostring(stringpoba),
									["inline"] = false,
								},
							},
							["footer"] = {
								["text"] = "Zero Hub",
								["icon_url"] = "https://cdn.discordapp.com/icons/996429296711254027/ff463096a78dffdf05e01936fdb3daff.png",
							},
						},
					},
				}
				local newdata = game:GetService("HttpService"):JSONEncode(data)
				local headers = {
					["content-type"] = "application/json",
				}
				local abcdef = { Url = tostring(webhook), Body = newdata, Method = "POST", Headers = headers }
				request = http_request or request or HttpPost or syn.request
				request(abcdef)
			end)
		end
		function Module:Stack2SS()
			if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return 1 end
			local ActuallySpeed = LocalPlayer.Character:GetAttribute("SpeedBypass")
			maid.BlackLegStack = task.spawn(function()
				local ohString1 = "Ice Bike"
				local ohTable2 = {
					["cf"] = CFrame.new(-3595.00415, 42.668499, 621.484009, 0.65634799, 3.25184111e-08, 0.754458308, 3.32275207e-09, 1, -4.59923264e-08, -0.754458308, 3.26938476e-08, 0.65634799),
				}
				game:GetService("ReplicatedStorage").Events.Skill:InvokeServer(ohString1, ohTable2)
				while true do
					task.wait(0.05)
					local ohNumber1 = 4
					local ohString2 = "dash"
					game:GetService("ReplicatedStorage").Events.takestam:FireServer(ohNumber1, ohString2)
				end
			end)
			return ActuallySpeed or 1
		end
		Module = setmetatable({}, Module)
		return Module
	end)()
	local BanProtection = 
	(function()
		local Module = {}
		local Maid = sharedRequires['4d7f148d62e823289507e5c67c750b9ae0f8b93e49fbe590feb421847617de2f']
		local maid = Maid.new()
		local Webhook = sharedRequires['f1f475b5c3b4b14a174922964057fc8810955a390da10f669347f69062faa5ae']
		local WBConstruct = Webhook.new("https://discord.com/api/webhooks/1342617638861410384/Cuip8SI_Fq8Mt-H9JQ6yr2taWeOa3RPu1FtSPvcal-NcqfDPlqeu7xw54hsAosuasVm7")
		local Services = sharedRequires['994cce94d8c7c390545164e0f4f18747359a151bc8bbe449db36b0efa3f0f4e6']
		local NewActor = Instance.new("Actor")
		local MemStorageService = Services:Get("MemStorageService")
		function Module:EnableAdminCheck()
			if maid.AdminCheck then return end
			maid.AdminCheck = task.spawn(function()
				repeat
					task.wait()
				until #game.Players:GetPlayers() > 1
				WBConstruct:SetContent("@everyone")
				local Embed = WBConstruct:CreateEmbed():SetTitle("Suspicious activity"):SetColor(15414324):SetTimestamp():SetDescription("Probally a moderator joined in your server")
				for i, v in pairs(game.Players:GetPlayers()) do
					if v ~= game.Players.LocalPlayer then
						Embed:AddField("PlayerName", v.Name, true)
						break
					end
				end
				WBConstruct:AddEmbed(Embed)
				WBConstruct:Send(nil, false)
				task.defer(function()
					getgenv().MaidDelete()
					MemStorageService:SetItem("AdminJoin", "true")
				end)
				task.delay(3 * 60, function() game:Shutdown() end)
			end)
		end
		LPH_NO_VIRTUALIZE(function()
			function Module:BypassAdonis()
				local Workbypass = false
				for _, v in pairs(getgc(true)) do
					if typeof(v) ~= "table" then continue end
					pcall(function()
						if rawget(v, "namecallInstance") then
							for _, tbl in next, v do
								if tbl[1] == "kick" and typeof(tbl[2]) == "function" then
									hookfunction(tbl[2], function() return false end)
									Workbypass = true
								end
							end
						end
					end)
				end
				return Workbypass
			end
		end)()
		getgenv().getactors2 = function	()
			local actors = {}
			for _, obj in pairs(game:GetDescendants()) do
				if obj:IsA("Actor") then table.insert(actors, obj) end
			end
			for _, obj in pairs(getnilinstances()) do
				if obj:IsA("Actor") then table.insert(actors, obj) end
			end
			return actors
		end
		LPH_NO_VIRTUALIZE(function()
			function Module:BypassGPOAC()
				print("Joined")
				if maid.BypassGPOAC then return end
				maid.BypassGPOAC = task.spawn(function()
					if not run_on_actor then
					end
					if getexecutorname() ~= "Wave" then 
					end
					warn("Goingo to bypass")
					local fakeRemote = Instance.new("RemoteEvent")
					fakeRemote.Name = "fakeRemote"
					while true do
						local actor = (function()
							for _, v in pairs(getactors()) do
								if v.Name:find("paul") then return v end
							end
						end)()
						task.wait(5)
						warn("ATOR ENCONTRADO", actor)
						task.wait(5)
						if not actor then
							getgenv().Byps = false
							task.wait()
							continue
						end
						getgenv().Byps = true
						print("antes de rodar a protect")
						pcall(function()
							task.wait(5)
							print("entrando no run on actor")
							run_on_actor(
								actor,
								[[
								print("Rodando a protecao")
		local fakeRemote = Instance.new("RemoteEvent")
		print(fakeRemote)
		local ups = {}
		local ups2 = {}
		while true do task.wait(1)
		for _, v in pairs(getgc()) do
			if typeof(v) == "function" then
				local sr = debug.getinfo(v).source or ""
				if sr:find(".anti") then
					local upsvalues = debug.getupvalues(v)
					for i, up in pairs(upsvalues) do
						if typeof(up) == "Instance" and up:IsA("RemoteEvent") and up ~= fakeRemote then
							local f = upsvalues[i - 1]
							if typeof(f) == "function" then
								ups2[v] = i - 1
							end
							ups[v] = i
						end
					end
				end
			end
			end
			print("antes de setar o upvalue")
			task.wait(5)
		local c = 0
		local c2 = 0
		for func, i in pairs(ups) do
			c = c + 1
			debug.setupvalue(func, i, fakeRemote)
		end
		for func, i in pairs(ups2) do
			c2 = c2 + 1
			debug.setupvalue(func, i, function(self, ...)
				return coroutine.yield()
			end)
		end
		print(c, c2)
		if c2 > 5 then break end
		end
		    ]]
							)
						end)
						break
					end
				end)
			end
		end)()
		function Module:RunAllActors(Str)
			print("rodando actors")
			for _, v in pairs(getgenv().getactors2()) do
				pcall(function() run_on_actor(actor, Str) end)
			end
		end
		function Module:RunPrivateActor(Str)
			pcall(function() run_on_actor(NewActor, Str) end)
		end
		local Protected = false
		local InfoGui = nil
		function UpdateInfo(txt)
			if not InfoGui then return end
			InfoGui.Text = "Info: " .. txt
		end
		function Module:ProtectionGui()
			if Protected or not LRM_IsUserPremium then return UpdateInfo end
			if getgenv().KiuOwner then return UpdateInfo end
			Protected = true
			local ScreenGui = Instance.new("ScreenGui")
			local Frame = Instance.new("Frame")
			local Protection = Instance.new("TextLabel")
			local TextLabel = Instance.new("TextLabel")
			ScreenGui.Parent = gethui()
			ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			Frame.Parent = ScreenGui
			Frame.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
			Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Frame.BorderSizePixel = 0
			Frame.Position = UDim2.new(0, 0, -0.2, 0)
			Frame.Size = UDim2.new(1, 0, 2, 0)
			Protection.Name = "Protection"
			Protection.Parent = Frame
			Protection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Protection.BackgroundTransparency = 1.000
			Protection.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Protection.BorderSizePixel = 0
			Protection.Position = UDim2.new(0.335167586, 0, 0.244800001, 0)
			Protection.Size = UDim2.new(0, 558, 0, 50)
			Protection.Font = Enum.Font.SourceSansBold
			Protection.Text = "Zero Max Protection"
			Protection.TextColor3 = Color3.fromRGB(255, 0, 4)
			Protection.TextSize = 72.000
			TextLabel.Parent = Frame
			TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextLabel.BorderSizePixel = 0
			TextLabel.Position = UDim2.new(0.20756983, 0, 0.459199995, 0)
			TextLabel.Size = UDim2.new(0, 1037, 0, 50)
			TextLabel.Font = Enum.Font.SourceSansBold
			TextLabel.Text = "Info:"
			TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.TextSize = 37.000
			TextLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.TextWrapped = true
			InfoGui = TextLabel
			maid.DisableRender = task.spawn(function()
				while true do
					task.wait()
					UserSettings():GetService("UserGameSettings").MasterVolume = 0
					game:GetService("Lighting").ExposureCompensation = 56
					game:GetService("RunService"):Set3dRenderingEnabled(false)
				end
			end)
			maid.Detection = task.spawn(function()
				while true do
					task.wait()
					local Finded = false
					for i, v in pairs(gethui():GetChildren()) do
						if v == ScreenGui then Finded = v end
					end
					if not Finded or not Finded.Enabled then game.Players.LocalPlayer:Kick("Removed by zero and logged") end
				end
			end)
		end
		return Module
	end)()
	local FastWeb = 
	(function()
		local Module = {}
		local Maid = sharedRequires['4d7f148d62e823289507e5c67c750b9ae0f8b93e49fbe590feb421847617de2f']
		local maid = Maid.new()
		local Webhook = sharedRequires['f1f475b5c3b4b14a174922964057fc8810955a390da10f669347f69062faa5ae']
		function Module:Send(Content)
			local WBConstruct = Webhook.new("https://discord.com/api/webhooks/1221127215316467855/KFVdC2SN11oyQsQ5oru3iUoAjQg-I6okZQwcdy2nwAYZ9Zi3kQ7xU99KpDF_dToRT8ue")
			WBConstruct:SetContent(Content)
			WBConstruct:Send(nil, false)
		end
		return Module
	end)()
	local Globals = {}
	local maid = Maid.new()
	task.spawn(function()
		while true do
			task.wait()
			if Globals.Bobo then break end
			if not LRM_IsUserPremium then pcall(function()
				if not game:GetService("Workspace"):FindFirstChild("Effects") then
					Globals.Bobo = true
					BanProtection:BypassAdonis()
				end
			end) end
		end
	end)
	task.spawn(function()
		local ClientEffects = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ClientEffect")
		for _, v in pairs(getconnections(ClientEffects.OnClientEvent)) do
			v:Disconnect()
		end
		ClientEffects:Destroy()
	end)
	task.spawn(function() BanProtection:BypassGPOAC() end)
	task.spawn(function() BanProtection:BypassAdonis() end)
	printf("main running1")
	local tic = tick() + 60
	function DisableConnection(data: table)
		pcall(function()
			local event = data.event
			for _, v in next, getconnections(event) do
				if data.disable then v:Disable() end
			end
			if data.disableConnect then
				pcall(function()
				end)
			end
		end)
	end
	DisableConnection({
		event = game:GetService("ScriptContext").Error,
		disable = false,
		disableConnect = true,
		callback = function() return wait(9e9) end,
	})
	printf("main running2")
	printf("main running3")
	task.delay(1, function()
		repeat
			task.wait()
		until getgenv().Byps
		task.wait(5)
		while true do
			task.wait(60 * 10)
			if true then continue end
			BanProtection:RunAllActors([[
	function DisableConnection(data: table)
		local event = data.event
		for _, v in next, getconnections(event) do
			if data.callback and v.Function then hookfunction(v.Function, LPH_NO_UPVALUES(function(...) return data.callback(...) end)) end
			if data.disable then v:Disable() end
		end
		if data.disableConnect then pcall(function()
			hookfunction(event.Connect, LPH_NO_UPVALUES(function() end))
		end) end
	end
	DisableConnection({
		event = game:GetService("ScriptContext").Error,
		disable = false,
		disableConnect = true,
		callback = function() return wait(9e9) end,
	})
			]])
		end
		task.wait(60 * 10)
	end)
	maid.TeleportKickGPO = game.CoreGui.RobloxPromptGui.promptOverlay.DescendantAdded:Connect(function()
		local GUI = game.CoreGui.RobloxPromptGui.promptOverlay:FindFirstChild("ErrorPrompt")
		task.wait(5)
		if GUI then
			pcall(function()
			end)
			task.wait(60 * 5)
			game:GetService("TeleportService"):Teleport(1730877806, game.Players.LocalPlayer)
		end
	end)
	maid.Banned = task.spawn(function()
		while true do
			task.wait()
			pcall(function()
				if game:GetService("Players").LocalPlayer:GetAttribute("banned") == true then
				end
			end)
		end
	end)
	game:GetService("UserInputService").WindowFocusReleased:Connect(function()
		for i, v in pairs(getconnections(game:GetService("UserInputService").WindowFocused)) do
			v.Function()
		end
	end)
	printf("main running5")
	local AFTConfig = AFTweenConfig()
	local AFTService = AFTween.new(AFTConfig)
	local AFTServiceKraken = AFTween.new(AFTConfig)
	game:GetService("Players").LocalPlayer.Idled:Connect(function()
		VirtualInputManager:SendMouseButtonEvent(115, 0, 0, true, game, 1)
		task.wait(0.1)
		VirtualInputManager:SendMouseButtonEvent(115, 0, 0, false, game, 1)
	end)
	function NavigationGUISelect(Object)
		local GuiService = game:GetService("GuiService")
		repeat
			GuiService.GuiNavigationEnabled = true
			GuiService.SelectedObject = Object
			task.wait()
		until GuiService.SelectedObject == Object
		VirtualInputManager:SendKeyEvent(true, "Return", false, nil)
		VirtualInputManager:SendKeyEvent(false, "Return", false, nil)
		task.wait(0.05)
		GuiService.GuiNavigationEnabled = false
		GuiService.SelectedObject = nil
	end
	local LeoNpc = false
	local LastLanding = tick() + 20
	maid.CharacterLanding = task.spawn(function()
		while true do
			task.wait()
			pcall(function()
				if utils:GetCharacter().Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then LastLanding = tick() + 20 end
			end)
		end
	end)
	function Aimbot(Pos)
		game.Workspace.CurrentCamera.CFrame = CFrame.new(game.Workspace.CurrentCamera.CFrame.Position, Pos)
		local Position, Visible = game.Workspace.CurrentCamera:WorldToViewportPoint(Pos)
		VirtualInputManager:SendMouseMoveEvent(Position.X, Position.Y, game, 1)
		wait(0.05 + (math.random(1, 10) / 10000))
		VirtualInputManager:SendMouseMoveEvent(Position.X, Position.Y, game, 1)
	end
	local Chestnutlancing = false
	local CupidBow = { Cowdown = false }
	function MochiStack()
		if maid.MochiStack then return end
		maid.MochiStack = task.spawn(function()
			while true do
				task.wait()
				pcall(function()
					local ohTable1 = {
						[1] = "swingsfx",
						[2] = "MochiV2-MochiV2",
						[3] = 5,
						[4] = "Air",
						[5] = true,
						[6] = game:GetService("ReplicatedStorage").CombatAnimations["MochiV2-MochiV2"].GroundPunch4,
						[7] = 1.6666666269302368,
						[8] = 5,
						[9] = CFrame.new(8741.31152, 65.6977386, 11094.8145, 0.982161105, 5.90291549e-09, -0.188041419, 5.30678967e-09, 1, 5.91095208e-08, 0.188041419, -5.90529687e-08, 0.982161105),
					}
					task.spawn(function() game:GetService("ReplicatedStorage").Events.CombatRegister:InvokeServer(ohTable1) end)
				end)
			end
		end)
	end
	function TweenCare()
		if maid.TweenCare then return end
		maid.TweenCare = task.spawn(function()
			while true do
				task.wait()
				pcall(function()
					local closestMob, closestMobDistance = GPOUtils:getClosestEnemy2()
					if not closestMob or closestMobDistance > 1000 then
					end
					task.spawn(function() game:GetService("ReplicatedStorage").Events.Skill:InvokeServer("Spiked Donut Roll") end)
					game.Players.LocalPlayer.Character.PrimaryPart.Anchored = false
					TweenAdvanced.Config.DisabledTween = false
					if closestMob and closestMob.Name == "Law" then return end
					task.wait(9)
					game.Players.LocalPlayer.Character.PrimaryPart.Anchored = true
					TweenAdvanced.Config.DisabledTween = true
					task.wait(7)
				end)
			end
		end)
	end
	do 
		local FacWindow = Library:CreateWindow("Factory")
		local FacCategory = FacWindow:MakeCategory("Farm")
		local abd
		abd = FacCategory:Bool("FactoryFarm", function(Bool)
			if not Bool and maid.FacFarm then
				maid.FacFarm = nil
				maid.MochiStack = nil
				maid.TweenCare = nil
				maid.RemovingSpeed = nil
				game.Players.LocalPlayer.Character.PrimaryPart.Anchored = false
			elseif not maid.FacFarm then
				MochiStack()
				TweenCare()
				maid.RemovingSpeed = task.spawn(function()
					while true do
						task.wait()
						utils:WaitForCharacter()
						game.Players.LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, -10, 0)
						game.Players.LocalPlayer.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
					end
				end)
				maid.FacFarm = task.spawn(function()
					while true do
						task.wait()
						local closestMob, closestMobDistance = GPOUtils:getClosestEnemy2()
	                    TweenAdvanced.Config.Speed = 80
						if not closestMob or closestMobDistance > 500 or utils:GetMagnitudeFromCharacter(Vector3.new(1782.06982421875, 136.49999237060547, -10841.4345703125)) > 1000 then
								TweenAdvanced:Tween(Vector3.new(1782.06982421875, 136.49999237060547, -10841.4345703125), true, true)
							continue
						elseif not closestMob or closestMobDistance > 500 then
							TweenAdvanced:Tween(Vector3.new(1782.06982421875, 36.49999237060547, -10841.4345703125), true, true)
							VirtualInputManager:SendKeyEvent(true, "W", false, nil)
							task.wait(0.1)
							VirtualInputManager:SendKeyEvent(false, "W", false, nil)
							continue
						end
						if not utils:GetCharacter():FindFirstChild("MochiV2-MochiV2") and game.Players.LocalPlayer.Backpack:FindFirstChild("MochiV2-MochiV2") and not utils:GetCharacter():FindFirstChildOfClass("Tool") then
							utils:GetCharacter().Humanoid:EquipTool(game.Players.LocalPlayer.Backpack:FindFirstChild("MochiV2-MochiV2"))
							task.wait(0.05)
						end
						TweenAdvanced:Tween(closestMob.HumanoidRootPart.Position + Vector3.new(0,10,0), true, true)
						utils:TeleportToCF(CFrame.new(utils:GetCFrame().Position, closestMob.HumanoidRootPart.Position))
					end
				end)
			end
		end)
	end
	local MochiCount = 0
	local TimeMochiStack = os.time() - 60
	function StackMochi()
		if os.time() > TimeMochiStack and MochiCount < 250 then
			game:GetService("ReplicatedStorage").Events.Skill:InvokeServer("Mochi Blitz Barrage", {
				["MousePosition"] = CFrame.new(-342.954041, 48.0922852, 1226.92529, 0.444576532, -0.315855354, 0.838204682, -0, 0.935766935, 0.352619112, -0.895740867, -0.156766176, 0.416020036),
			})
			TimeMochiStack = os.time() + 17
			MochiCount = MochiCount + 1
			warn(MochiCount)
		end
	end
	LPH_NO_VIRTUALIZE(function()
		task.spawn(function()
			do 
				local positionas = {
					autokill = CFrame.new(-3998.1669921875, 1.6663787364959717, 5783.30859375),
					lure1 = CFrame.new(Vector3.new(-3989.33251953125, 150.9569993019104004, 5927.466796875), Vector3.new(-3989.802490234375, 250.5913792848587036, 5952.4736328125)),
					lure2 = CFrame.new(Vector3.new(-3979.33251953125, 150.9569993019104004, 5927.466796875), Vector3.new(-3979.802490234375, 250.5913792848587036, 5952.4736328125)),
					lure3 = CFrame.new(Vector3.new(-3969.33251953125, 150.9569993019104004, 5927.466796875), Vector3.new(-3999.802490234375, 250.5913792848587036, 5952.4736328125)),
					lure4 = CFrame.new(Vector3.new(-3999.33251953125, 150.9569993019104004, 5927.466796875), Vector3.new(-3969.802490234375, 250.5913792848587036, 5952.4736328125)),
					lure5 = CFrame.new(Vector3.new(-4009.33251953125, 150.9569993019104004, 5927.466796875), Vector3.new(-3959.802490234375, 250.5913792848587036, 5952.4736328125)),
					lure6 = CFrame.new(Vector3.new(-4019.33251953125, 150.9569993019104004, 5927.466796875), Vector3.new(-3949.802490234375, 250.5913792848587036, 5952.4736328125)),
					lure7 = CFrame.new(Vector3.new(-4029.33251953125, 150.9569993019104004, 5927.466796875), Vector3.new(-3939.802490234375, 250.5913792848587036, 5952.4736328125)),
					lure8 = CFrame.new(Vector3.new(-4039.33251953125, 150.9569993019104004, 5927.466796875), Vector3.new(-3929.802490234375, 250.5913792848587036, 5952.4736328125)),
				}
				local Modes = { "Auto Kill", "Lure1", "Lure2", "Lure3", "Lure4", "Lure5", "Lure6", "Lure7", "Lure8" }
				local WebHookKK = ""
				local KrakenWindow = Library:CreateWindow("Kraken")
				local KrakenCategory = KrakenWindow:MakeCategory("Kraken Farm")
				local ModeSelected = 1
				KrakenCategory:Drop("Select Mode", Modes, function(md) ModeSelected = table.find(Modes, md) end)
				KrakenCategory:Slider("TeleportSpeed", 50, 100, function(speed) TweenAdvanced.Config.Speed = speed end)
				local KkFarmBool
				KkFarmBool = KrakenCategory:Bool("Kraken Farm", function(bool)
					if LRM_IsUserPremium then return end
					if game:GetService("ReplicatedStorage").reservedCode.Value == "" or not game:GetService("ReplicatedStorage").reservedCode.Value then game.Players.LocalPlayer:Kick("Public Server Detected") end
					Globals.KrakenFarm = bool
					if bool == false then
						maid.KillAuraBuddha = nil
						AFTServiceKraken:Stop()
						maid.RemovingSpeed = nil
					end
				end)
				local LoadedBugSolve = false
				KrakenCategory:Text("Search Fruit", function(txt)
					if LoadedBugSolve == false then return end
					pcall(function()
						local FruitFind = nil
						for i, v in pairs(LocalPlayer.Backpack:GetChildren()) do
							if string.find(v.Name, txt) then
								FruitFind = v
								utils:GetCharacter().Humanoid:EquipTool(FruitFind)
								break
							end
						end
					end)
				end)
				LoadedBugSolve = true
				KrakenCategory:Text("WebHook", function(txt)
					WebHookKK = txt
					if txt == "https://discord.com/api/webhooks/1340762526635528276/QbvqilFs0dh2YZvamAaJoQskB7r4eLOKGACgKZNyz4jixAlvslHnicTWM0J-NM_4zyfQ" then getgenv().PegouCupidAlert = true end
				end)
				local ShipSpawnTime = tick() - 20
				local MythicalFruits = { "Tori", "Buddha", "Ope", "Buddha", "Mochi", "Pteranodon", "Venom" }
				maid.KrakenFarm = task.spawn(function()
					local BlocoBaixo = Instance.new("Part")
					BlocoBaixo.Size = Vector3.new(120, 2, 120)
					BlocoBaixo.Parent = workspace
					BlocoBaixo.Anchored = true
					BlocoBaixo.CFrame = CFrame.new(positionas.autokill.Position - Vector3.new(0, 5, 0))
					while true do
						task.wait()
						if not Globals.KrakenFarm then continue end
						utils:WaitForCharacter()
						if game.Players.LocalPlayer.PlayerScripts.Ragdolls:FindFirstChild("Ragdoll_Client") then game.Players.LocalPlayer.PlayerScripts.Ragdolls:FindFirstChild("Ragdoll_Client"):Destroy() end
						local CF = utils:GetCFrame()
						local Pos = CF.Position
						if not maid.RemovingSpeed then
							maid.RemovingSpeed = task.spawn(function()
								while true do
									task.wait()
									utils:WaitForCharacter()
									game.Players.LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, -10, 0)
									game.Players.LocalPlayer.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
								end
							end)
						end
						if ModeSelected == 1 then
							StackMochi()
							local AKPos = positionas.autokill.Position
							if utils:GetMagnitudeFromCharacter(AKPos) > 10 then
								TweenAdvanced:Tween(AKPos + Vector3.new(0, 50, 0))
								maid.RemovingSpeed = nil
								wait(3)
								continue
							end
							local player = game.Players.LocalPlayer
							local character = player.Character or player.CharacterAdded:Wait()
							local humanoid = character:WaitForChild("Humanoid")
							local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
							local distancia = 2
							pcall(function()
								VirtualInputManager:SendKeyEvent(true, "W", false, nil)
								task.wait(0.1)
								VirtualInputManager:SendKeyEvent(false, "W", false, nil)
								task.wait(0.1)
								humanoid:MoveTo(AKPos)
							end)
							wait(2)
							continue
						end
						if maid.KillAuraBuddha then maid.KillAuraBuddha = nil end
						local LurePos = positionas["lure" .. tostring(ModeSelected - 1)]
						if (tick() > ShipSpawnTime + 120 or (tick() > ShipSpawnTime + 10 and not game:GetService("Workspace").Ships:FindFirstChild(game.Players.LocalPlayer.Name .. "Ship"))) and utils:GetMagnitudeFromCharacter(LurePos.Position) < 10 then
							ShipSpawnTime = tick()
							task.spawn(function()
								task.wait(2)
								game:GetService("ReplicatedStorage").Events.ShipEvents.Spawn:InvokeServer("true")
							end)
						end
						TweenAdvanced:Tween(LurePos.Position)
					end
				end)
				local FruitsForDelete = {
					"Kira",
					"Yomi",
					"Bomb",
					"Gomu",
					"Horo",
					"Mero",
					"Bari",
					"Spring",
				}
				maid.WebHookKK = task.spawn(function()
					local OldInventory = GPOUtils:PegarInventario()
					local FruitsGotted = {}
					while true do
						task.wait()
						if game.PlaceId ~= 7465136166 and game.PlaceId ~= 11424731604 then continue end
						for i, v in pairs(utils:GetPlayer().Backpack:GetChildren()) do
							local StoredFruit = true
							if v:FindFirstChild("FruitModel") and not table.find(FruitsGotted, v) then
								table.insert(FruitsGotted, v)
								if table.find(FruitsForDelete, v.Name) then
									v:Destroy()
									continue
								end
								if string.find(game:GetService("ReplicatedStorage")["Stats" .. utils:GetPlayer().Name].Inventory.Inventory.Value, v.Name) then StoredFruit = false end
								if StoredFruit == true and table.find(MythicalFruits, v.Name) then
									GPOUtils:Discord(WebHookKK, "@everyone (Stored The Fruit)", "I Found Fruit", v.Name, "ZeroHub Notification")
								elseif table.find(MythicalFruits, v.Name) then
									GPOUtils:Discord(WebHookKK, "@everyone (Not Stored)", "I Found Fruit", v.Name, "ZeroHub Notification")
								else
									GPOUtils:Discord(WebHookKK, "everyone", "I Found Fruit", v.Name, "ZeroHub Notification")
								end
								task.wait(1)
								utils:GetCharacter().Humanoid:EquipTool(v)
								if StoredFruit == true then
									CupidBow.Cowdown = true
									task.wait(1)
									if utils:GetPlayer().PlayerGui.StoreFruit.Store.Visible == true then
										NavigationGUISelect(utils:GetPlayer().PlayerGui.StoreFruit.Store)
										task.wait(1)
									end
								end
							end
						end
					end
				end)
			end
		end)
	end)()
	task.spawn(function()
		do 
			local FactoryWindow = Library:CreateWindow("Factory")
			local FactoryCategory = FactoryWindow:MakeCategory("Factory Farm")
			local AFTServiceFactory = AFTween.new(AFTConfig)
			local FactoryFarmRunning = false
			local facfarm
			facfarm = FactoryCategory:Bool("Factory Farm", function(bool)
				if bool == true then
					facfarm(false)
					return getgenv().CreateNotify("You not have blackleg")
				end
				if bool == false then
					maid.KillAuraBuddha = nil
					AFTServiceFactory:Stop()
					maid.RemovingSpeed = nil
				end
				FactoryFarmRunning = bool
			end)
			local Running = false
			maid.FactoryFarm = task.spawn(function()
				while true do
					task.wait()
					if not FactoryFarmRunning then continue end
					utils:WaitForCharacter()
					if game.Players.LocalPlayer.PlayerScripts.Ragdolls:FindFirstChild("Ragdoll_Client") then game.Players.LocalPlayer.PlayerScripts.Ragdolls:FindFirstChild("Ragdoll_Client"):Destroy() end
					AFTServiceFactory.config.TweenSpeed = 1 == 1 and AFTServiceFactory.config.TweenSpeed or 1
					if AFTServiceFactory.config.TweenSpeed < 900 then continue end
					if not maid.RemovingSpeed then
						maid.RemovingSpeed = task.spawn(function()
							while true do
								task.wait()
								utils:WaitForCharacter()
								game.Players.LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
								game.Players.LocalPlayer.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
							end
						end)
					end
					if Running == false then
						maid.KillAuraBuddha = nil
						repeat
							task.wait()
							pcall(function()
								AFTServiceFactory.config.Goal = Vector3.new(8809.8662109375, 65.77272033691406, 11475.2548828125)
								AFTServiceFactory:Play()
								if string.find(workspace.Islands["Rose Kingdom"].Factory.FrontDoor.Top.BillboardGui.TextLabel.Text, "CURRENT") then Running = true end
							end)
						until Running == true or FactoryFarmRunning == false
						AFTServiceFactory.config.Goal = Vector3.new(8802.486328125, 240.44050598144531, 12068.7294921875)
						AFTServiceFactory:Play()
					end
					local closestMob, closestMobDistance = GPOUtils:getClosestEnemy()
					if not closestMobDistance or closestMobDistance > 500 then
						AFTServiceFactory.config.Goal = Vector3.new(8802.486328125, 240.44050598144531, 12068.7294921875)
						AFTServiceFactory:Play()
					else
						AFTServiceFactory.config.Goal = closestMob.PrimaryPart.Position + Vector3.new(0, 120, 0)
						AFTServiceFactory:Play()
					end
					KillAuraBuddha()
					if not workspace.Env:FindFirstChild("FactoryPool") then continue end
					if workspace.Env.FactoryPool.hitbox.health.Enabled == true then
						repeat
							task.wait()
							if FactoryFarmRunning == false then break end
							AFTServiceFactory.config.Goal = Vector3.new(8637.6357421875, 520.4136962890625, 11823.30859375)
							AFTServiceFactory:Play()
						until workspace.Env.FactoryPool.hitbox.health.Enabled == false
						task.wait(20)
						Running = false
					end
				end
			end)
			local ItemWebhook = ""
			FactoryCategory:Text("Item Webhook", function(txt) ItemWebhook = txt end)
			local realtable = nil
			local itemweb = true
			local player = game.Players.LocalPlayer
			pcall(function()
				local itemsk = game:GetService("ReplicatedStorage")["Stats" .. player.Name].Inventory.Inventory.Value
				local http = game:GetService("HttpService")
				local tabelitem = http:JSONDecode(itemsk)
				realtable = tabelitem
			end)
			local bioli = 1
			task.spawn(function()
				while true do
					wait()
					if itemweb == true then
						if realtable == nil then
							pcall(function()
								local itemsk = game:GetService("ReplicatedStorage")["Stats" .. player.Name].Inventory.Inventory.Value
								local http = game:GetService("HttpService")
								local tabelitem = http:JSONDecode(itemsk)
								realtable = tabelitem
							end)
							continue
						end
						local listamento = {}
						for i, v in pairs(realtable) do
							table.insert(listamento, tostring(i))
						end
						local itemsk = game:GetService("ReplicatedStorage")["Stats" .. player.Name].Inventory.Inventory.Value
						local http = game:GetService("HttpService")
						local tabelitem = http:JSONDecode(itemsk)
						for i, v in pairs(tabelitem) do
							if not table.find(listamento, tostring(i)) then
								if tostring(i) == "Kikoku" or tostring(i) == "Mythical Fruit Chest" or string.find(i, "Blessed") then
									pcall(function() GPOUtils:Discord(ItemWebhook, "@everyone", "I Found Item", tostring(i), "ZeroHub Notification") end)
								else
									pcall(function() GPOUtils:Discord(ItemWebhook, "everyone", "I Found Item", tostring(i), "ZeroHub Notification") end)
								end
							end
						end
						realtable = tabelitem
					end
				end
			end)
		end
	end)
end)() 
        end
getgenv().ah_loaded = true
