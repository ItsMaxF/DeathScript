------ MADE BY MAX F. ------
--FOR JUSTICE COMMUNITY RP--
----------------------------


--1) detect when ped died
--2) detect when command is triggered
--3) calculate remaining time
--4) declare a Revive//Respawn Allow variable for respawn function
--5) call an external function to avoid conflicting


--------------------------------------------------------------------
------------------CODE STARTS FROM UNDER THIS LINE------------------
--------------------------------------------------------------------
--VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV--


--------------------------------------------------
----------------STOPS AUTO RESPAWN----------------
--------------------------------------------------

AddEventHandler('onClientMapStart', function()
	exports.spawnmanager:spawnPlayer()
	Citizen.Wait(3000)
	exports.spawnmanager:setAutoSpawn(false)
end)



--------------------------------------------------
----------------REGISTERING EVENTS----------------
--------------------------------------------------

RegisterNetEvent("DeathScript:Revive")
RegisterNetEvent("DeathScript:Respawn")
RegisterNetEvent("DeathScript:AdminRevive")
RegisterNetEvent("DeathScript:AdminRespawn")
RegisterNetEvent("DeathScript:SetReviveTime")
RegisterNetEvent("DeathScript:SetRespawnTime")
RegisterNetEvent("DeathScript:Toggle")



--------------------------------------------------
----------------DEFINING VARIABLES----------------
--------------------------------------------------

OriginalReviveTime = 240
OriginalRespawnTime = 120

ReviveTime = 240
RespawnTime = 120

ReviveAllowed = false
RespawnAllowed = false

DeathTime = nil

DeathScriptToggle = true

respawnCount = 0
spawnPoints = {}


--------------------------------------------------
--------------------Death Loop--------------------
--------------------------------------------------

Citizen.CreateThread(function()
    
    function createSpawnPoint(x1,x2,y1,y2,z,heading)
		local xValue = math.random(x1,x2) + 0.0001
		local yValue = math.random(y1,y2) + 0.0001

		local newObject = {
			x = xValue,
			y = yValue,
			z = z + 0.0001,
			heading = heading + 0.0001
		}
		table.insert(spawnPoints,newObject)
	end

	createSpawnPoint(-448, -448, -340, -329, 35.5, 0)    -- Mount Zonah
	createSpawnPoint(372, 375, -596, -594, 30.0, 0)      -- Pillbox Hill
	createSpawnPoint(335, 340, -1400, -1390, 34.0, 0)    -- Central Los Santos
	createSpawnPoint(1850, 1854, 3700, 3704, 35.0, 0)    -- Sandy Shores
	createSpawnPoint(-247, -245, 6328, 6332, 33.5, 0)    -- Paleto

    while true do
        Citizen.Wait(5000)
        local ped = GetPlayerPed( -1 )

        if DeathScriptToggle then

            if IsEntityDead( ped ) then

                DeathTime = GetGameTimer()

                SetPlayerInvincible( ped, true )
				SetEntityHealth( ped, 1 )
				
				local reviveMessage = nil
				local respawnMessage = nil

				if ReviveTime > 0 then
					ReviveTime = ReviveTime - 5
					reviveMessage = '~r~Revive in ' .. ReviveTime .. ' seconds'
				else
					ReviveAllowed = true
					reviveMessage = '~g~Revive available | /revive'
				end

				if RespawnTime > 0 then
					RespawnTime = RespawnTime - 5
					respawnMessage = '~r~Respawn in ' .. RespawnTime .. ' seconds'
				else 
					RespawnAllowed = true
					respawnMessage = '~g~Respawn available | /respawn'
				end

				ShowNotification(  respawnMessage .. '\n' .. reviveMessage )

				AddEventHandler("DeathScript:Revive", function( src )
					if IsEntityDead( ped ) then
						if ReviveAllowed then
							revivePed( ped )
							resetTimers()
						else
							ShowNotification("~r~" .. ReviveTime .. ' seconds remaining until revive!')
						end
					else
						ShowNotification("~g~You're alive!")
					end
				end)

				AddEventHandler("DeathScript:Respawn", function( src )
					if IsEntityDead( ped ) then
						if RespawnAllowed then
							respawnPed( ped, spawnPoints[math.random(1,#spawnPoints)] )
							resetTimers()
						else
							ShowNotification("~r~" .. RespawnTime .. ' seconds remaining until respawn!')
						end
					else
						ShowNotification("~g~You're alive!")
					end
				end)
            end
		else 
			respawnPed( ped )
		end
	end
end)


--------------------------------------------------
-----------------EVENT  HANDLERS------------------
--------------------------------------------------

AddEventHandler('DeathScript:Toggle', function( src )
	DeathScriptToggle = not DeathScriptToggle
	if (DeathScriptToggle) then
		ShowNotification("~b~DeathScript was enabled")
	else
		ShowNotification("~r~DeathScript was disabled")
	end
end)

AddEventHandler('DeathScript:SetReviveTime', function( src, time )
	local newTime = tonumber( time )
	if newTime then
		OriginalReviveTime = newTime
		ShowNotification("~B~ Revive time has been set to " .. newTime)
	else
		ShowNotification("~r~Invalid time entered")
	end
end)

AddEventHandler('DeathScript:SetRespawnTime', function( src, time )
	local newTime = tonumber( time )
	if newTime then
		OriginalRespawnTime = newTime
		ShowNotification("~B~ Respawn time has been set to " .. newTime)
	else
		ShowNotification("~r~Invalid time entered")
	end
end)

AddEventHandler('DeathScript:AdminRevive', function( src, time )
	local newTime = tonumber( time )
	if newTime then
		OriginalRespawnTime = newTime
		ShowNotification("~B~ Respawn time has been set to " .. newTime)
	else
		ShowNotification("~r~Invalid time entered")
	end
end)

AddEventHandler('DeathScript:AdminRespawn', function( src, time )
	local newTime = tonumber( time )
	if newTime then
		OriginalRespawnTime = newTime
		ShowNotification("~B~ Respawn time has been set to " .. newTime)
	else
		ShowNotification("~r~Invalid time entered")
	end
end)


--------------------------------------------------
--------------------FUNCTIONS---------------------
--------------------------------------------------

function resetTimers()
	ReviveTime = OriginalReviveTime
	RespawnTime = OriginalRespawnTime
	ReviveAllowed = false
	RespawnAllowed = false
end
