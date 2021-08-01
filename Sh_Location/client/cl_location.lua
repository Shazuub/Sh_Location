local open = false 
local Location = RageUI.CreateMenu('Location', 'Location')

Location.Closed = function()
  open = false
  FreezeEntityPosition(PlayerPedId(), false)
end

OpenMenuLocation = function()
     if open then 
         open = false
         RageUI.Visible(Location, false)
         return
     else
         open = true 
         RageUI.Visible(Location, true)
         CreateThread(function()
         while open do 
          FreezeEntityPosition(PlayerPedId(), true)
            RageUI.IsVisible(Location,function() 

              for k,v in pairs(Config.Location) do
                RageUI.Button(v.label, nil, {}, true , {
                    onSelected = function()
                      local model = GetHashKey(v.car)
                      RequestModel(model)
                      while not HasModelLoaded(model) do Citizen.Wait(10) end
                      local pos = GetEntityCoords(PlayerPedId())
                      local vehicle = CreateVehicle(model, -1030.28, -2732.32, 20.07, 239.0, true, false)
                      SetEntityAsMissionEntity(vehicle, true, true)
                      SetVehicleNumberPlateText(vehicle, "LOCATION")
                      SetVehicleMaxSpeed(vehicle, 23.0)
                      SetVehicleHasBeenOwnedByPlayer(vehicle, 1)
                      Visual.Popup({
                          colors = 140,
                          message = "Attention, les véhicule gratuit on leur moteur bridé",
                      })
                    end
                })
              end

            end)
          Wait(1)
         end
      end)
   end
end      

function SelectSpawnPoint()
  local found = false
  for k,v in pairs(zoneDeSpawn) do
      local clear = ESX.Game.IsSpawnPointClear(v.pos, 5.0)
      if clear and not found then
          found = true
          return v.pos, v.heading
      end
  end
  return false
end

local blips = {                                                           
  {title="Location", colour=47, sprite=178, scale=0.7, id=642, x = -1031.3354, y = -2735.6955, z = 19.514406967163}
}

Citizen.CreateThread(function()
  while true do
      local Waito = false
      for _, info in pairs(blips) do
          local dist = Vdist2(GetEntityCoords(GetPlayerPed(-1)), info.x, info.y, info.z)
          if dist < 3 then
              Waito = true 
              DrawMarker(21, info.x, info.y, info.z+1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.0, 0.2, 255, 188, 0, 255, 0, 0, 2, 1, nil, nil, 0)
              if dist < 2 then 
                  if IsControlJustPressed(0, 51) then
                      RageUI.CloseAll()
                      OpenMenuLocation()
                  end
              end
          end
      end
      if Waito then
          Wait(0)
      else 
          Wait(500)
      end
  end
end)

Citizen.CreateThread(function()
  for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.sprite)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, info.scale)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
  end
end)