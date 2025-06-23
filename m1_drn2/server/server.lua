ESX = exports['es_extended']:getSharedObject()


ESX.RegisterServerCallback('drone:getPlayerInfo', function(source, cb, targetId)
  local xPlayer = ESX.GetPlayerFromId(targetId)
  if xPlayer then
    cb({
      name = xPlayer.getName(),
      dob  = xPlayer.get('dob'),
      job  = xPlayer.job.label
    })
  else
    cb(nil)
  end
end)

local lastTase = {}

RegisterNetEvent('m1_drn:serverRequestTase', function(targetNetId)
  local src = source
  local now = os.time()
  local xSource = ESX.GetPlayerFromId(src)

  if not xSource or xSource.job.name ~= 'police' then
    TriggerClientEvent('m1_drn:clientNotify', src, 'You do not have permission to use the taser.')
    return
  end

  if lastTase[src] and now - lastTase[src] < 10 then
    TriggerClientEvent('m1_drn:clientNotify', src, 'Taser recharging, please wait.')
    return
  end

  lastTase[src] = now

  TriggerClientEvent('m1_drn:clientApplyTase', -1, targetNetId)
end)


RegisterNetEvent('m1_drn:serverDroneDropped', function(netId)
  TriggerClientEvent('m1_drn:clientDroneDropped', -1, netId)
end)

RegisterNetEvent('m1_drn:serverDronePickedUp', function(netId)
  TriggerClientEvent('m1_drn:clientDroneRemoved', -1, netId)
end)

ESX.RegisterServerCallback('m1_drn:getPlayerInfo', function(source, cb, targetId)
  local xPlayer = ESX.GetPlayerFromId(targetId)
  if xPlayer then
    cb({
      name = xPlayer.getName(),
      dob  = xPlayer.get('dob'),
      job  = xPlayer.job.label
    })
  else
    cb(nil)
  end
end)

RegisterNetEvent('drone:saveSnapshot')
AddEventHandler('drone:saveSnapshot', function(imgBase64, coords)
  local src = source
  local time = os.time()
  local filename = string.format("evidence/%d_%d.png", time, src)
  local data = imgBase64:gsub("data:image/png;base64,", "")
  local file = io.open(filename, "wb")
  if file then
    file:write(tonumber64 and data or DecodeBase64(data))
    file:close()
    print(("[drone] Saved snapshot for %d to %s"):format(src, filename))
  end
end)

