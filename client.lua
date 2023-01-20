screenWidth, screenHeight = guiGetScreenSize()
local components = {}
local _x,_y = guiGetScreenSize()

function isInBox( x, y, xmin, xmax, ymin, ymax )
	return x >= xmin and x <= xmax and y >= ymin and y <= ymax
end

function isActive()
	return "1"
end

renderTimers = {}
function createRender(id, func)
    if not isTimer(renderTimers[id]) then
        renderTimers[id] = setTimer(func, 5, 0)
    end
end

function destroyRender(id)
    if isTimer(renderTimers[id]) then
        killTimer(renderTimers[id])
        renderTimers[id] = nil
        collectgarbage("collect")
    end
end


function isInSlot(dX, dY, dSZ, dM)
	if isCursorShowing() then
		local cX ,cY = getCursorPosition()
		cX,cY = cX*_x , cY*_y
	    if(cX >= dX and cX <= dX+dSZ and cY >= dY and cY <= dY+dM) then
	        return true, cX, cY
	    else
	        return false
	    end
	end
end

function fpsFunction( command, limit ) 
  if limit and tonumber(limit) and tonumber(limit) >= 25 and tonumber(limit) <=100 then 
  	limit = tonumber(limit)
    if setFPSLimit ( limit ) then 
    	outputChatBox("FPS limitini "..limit.." olarak ayarladın.")
    end
else
	outputChatBox("Kullanım: /"..command.." [25 - 100] - FPS'ini limitletir.")
  end
end 
addCommandHandler ( "fpslimit", fpsFunction )

local screenW, screenH = guiGetScreenSize()
local fP = (screenW / 1920) + 0.3
local startX, startY = screenW - 355 * fP, 0
local sx, sy = guiGetScreenSize()
local browser = createBrowser(sx, sy, true, true)
local speedoBrowser = createBrowser(sx, sy, true, true)
local pool = {}
local hudState = false

addEventHandler("onClientBrowserCreated", browser, 
	function()
		guiSetInputMode("no_binds_when_editing")

		loadBrowserURL(browser, "http://mta/cr_hudui/html/index.html")
		--loadBrowserURL(speedoBrowser, "http://mta/local/html/speedo.html")
	    
	    removeEventHandler("onClientBrowserDocumentReady", browser, initHudComponents)
	    addEventHandler("onClientBrowserDocumentReady", browser, initHudComponents)
	    for index, value in ipairs(components) do
			setPlayerHudComponentVisible(value, true)
		end
	end
)

addEventHandler("onClientPlayerWeaponSwitch", localPlayer, function(prevSlot, newSlot)
	local gun = getPedWeapon(localPlayer)
	javascript("weapon("..gun..");")
end)

addEventHandler("onClientElementDataChange", root, function(dataName, oldValue)
	if source ~= localPlayer then return end

	if dataName == "loggedin" then
		if (getElementData(localPlayer, "loggedin") == 1) then
		loadBrowserURL(browser, "http://mta/cr_hudui/html/index.html")
			
	    	removeEventHandler("onClientBrowserDocumentReady", browser, initHudComponents)
	   		addEventHandler("onClientBrowserDocumentReady", browser, initHudComponents)
	   		for index, value in ipairs(components) do
				setPlayerHudComponentVisible(value, true)
			end
	   	else
	   		hudState = false
	   		for index, value in ipairs(components) do
				setPlayerHudComponentVisible(value, false)
			end
	   	end

    elseif dataName == "hoursplayed" and getElementData(localPlayer, "loggedin") == 1 then
        hoursplayed = getElementData(localPlayer, "hoursplayed") or 0
        javascript("hoursplayed("..hoursplayed..");")

    elseif dataName == "hunger" and getElementData(localPlayer, "loggedin") == 1 then
        food = getElementData(localPlayer, dataName) or 0
        javascript("hunger("..food..");")
    elseif dataName == "thirst" and getElementData(localPlayer, "loggedin") == 1 then
        thirst = getElementData(localPlayer, dataName) or 0
        javascript("thirst("..thirst..");")
    elseif dataName == "money" and getElementData(localPlayer, "loggedin") == 1 then
        money = getElementData(localPlayer, dataName) or 0
        javascript("money("..money..");")	
    elseif dataName == "sleep" and getElementData(localPlayer, "loggedin") == 1 then
        sleep = getElementData(localPlayer, "sleep") or 100
        javascript("sleep("..sleep..");")			
	end
end)

function updateBars ()
	hp = getElementHealth(localPlayer)
	javascript("changeHP("..hp..");")	
	armor = getPedArmor(localPlayer)
	javascript("changeArmor("..armor..");")
    if armor > 0 then
	javascript("document.getElementById('armorbar').style.visibility = 'visible';")
	javascript("document.getElementById('armor').style.visibility = 'visible';")
	else
	javascript("document.getElementById('armorbar').style.visibility = 'hidden';")
	javascript("document.getElementById('armor').style.visibility = 'hidden';")
	end	
end


function javascript(js)
    if not inited then
        table.insert(pool, js)
    else
       	executeBrowserJavascript(browser, js)
    end
end

function initHudComponents(url)
	hudState = true
    inited = true
    

	hp = getElementHealth(localPlayer)
	armor = getPedArmor(localPlayer)
	
    food = getElementData(localPlayer, "hunger") or 0
    drink = getElementData(localPlayer, "thirst") or 0
    money = getElementData(localPlayer, "money") or 0
    hoursplayed = getElementData(localPlayer, "hoursplayed") or 0
    speed = exports.cr_global:getVehicleVelocity(getPedOccupiedVehicle(localPlayer), getLocalPlayer())
	sleep = getElementData(localPlayer, "sleep") or 100
    javascript("hunger("..food..");")
    javascript("thirst("..drink..");")
    javascript("hoursplayed("..hoursplayed..");")
    javascript("sleep("..sleep..");")
    javascript("money("..money..");")
	javascript("changeHP("..hp..");")
	javascript("changeArmor("..armor..");")
	
	
	if armor > 0 then
	javascript("document.getElementById('armorbar').style.visibility = 'visible';")
	javascript("document.getElementById('armor').style.visibility = 'visible';")
	else
	javascript("document.getElementById('armorbar').style.visibility = 'hidden';")
	javascript("document.getElementById('armor').style.visibility = 'hidden';")
	end
    --javascript("setProgressSpeed("..speed..",'.progress-speed');");
    createRender ( "updateBars", updateBars )
    for index, value in ipairs(pool) do
    	executeBrowserJavascript(browser, value)
    end
    pool = {}
    
    createRender("renderHud", renderHud)
end


function renderHud()
	if (getElementData(localPlayer, "loggedin") == 0) then return end


	if hudState and (getElementData(localPlayer, "loggedin") == 1) then
		dxDrawImage(0, 0, sx, sy, browser)

		dxDrawImage(0, 0, sx, sy, speedoBrowser)
	end
end
function RemoveHEXColorCode( s )
    return s:gsub( '#%x%x%x%x%x%x', '' ) or s
end


function sendJS(functionName, ...)
	if (not speedoBrowser) then
		outputDebugString("Browser is not loaded yet, can't send JS.")
		return false
	end

	local js = functionName.."("

	local argCount = #arg
	for i, v in ipairs(arg) do
		local argType = type(v)
		if (argType == "string") then
			js = js.."'"..addslashes(v).."'"
		elseif (argType == "boolean") then
			if (v) then js = js.."true" else js = js.."false" end
		elseif (argType == "nil") then
			js = js.."undefined"
		elseif (argType == "table") then
			--
		elseif (argType == "number") then
			js = js..v
		elseif (argType == "function") then
			js = js.."'"..addslashes(tostring(v)).."'"
		elseif (argType == "userdata") then
			js = js.."'"..addslashes(tostring(v)).."'"
		else
			outputDebugString("Unknown type: "..type(v))
		end

		argCount = argCount - 1
		if (argCount ~= 0) then
			js = js..","
		end
	end
	js = js .. ");"

	executeBrowserJavascript(speedoBrowser, js)
end

-- Backslash-escape special characters:
function addslashes(s)
	local s = string.gsub(s, "(['\"\\])", "\\%1")
	s = string.gsub(s, "\n", "")
	return (string.gsub(s, "%z", "\\0"))
end

function velocity()
speedx, speedy, speedz = getElementVelocity ( getLocalPlayer() )

-- use pythagorean theorem to get actual velocity
-- raising something to the exponent of 0.5 is the same thing as taking a square root.
actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5) -- can be: math.sqrt(speedx^2 + speedy^2 + speedz^2)

-- multiply by 50 to obtain the speed in metres per second
mps = actualspeed * 50

-- other useful conversions
-- kilometres per hour
kmh = actualspeed * 180
-- miles per hour
mph = actualspeed * 111.847

-- report the results.
setElementData(localPlayer, "speed", kmh)
end