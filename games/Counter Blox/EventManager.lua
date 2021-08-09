local Status = workspace.Status
local DamageLogs = game.Players.LocalPlayer.DamageLogs

local Events = {
    HitEvent = Instance.new('BindableEvent'),
    KillEvent = Instance.new('BindableEvent'),
    RoundStart = Instance.new('BindableEvent'),
    RoundEnd = Instance.new('BindableEvent'),
}

local DamageLogData = {}


function handleHitEvent(player)
    local PlayerDamageLogs = DamageLogs[player.Name]
    print('Total:', PlayerDamageLogs.DMG.Value)
    
    if DamageLogData[player.Name] and DamageLogData[player.Name].Damage then
        local damageTaken = PlayerDamageLogs.DMG.Value - DamageLogData[player.Name].Damage
        print(player.Name, 'took', damageTaken) 
        
        DamageLogData[player.Name].Damage = DamageLogData[player.Name].Damage + damageTaken
    else
        DamageLogData[player.Name] = {}
        DamageLogData[player.Name].Damage = PlayerDamageLogs.DMG.Value 
    end
end

function handleKillEvent(player)
    local PlayerDamageLogs = DamageLogs:WaitForChild(player.Name)
    
    if PlayerDamageLogs.DMG.Value >= 100 then
        print('Killed', player.Name)
        KillEvent:Fire()
    end
end

function handleRoundStartEvent()
    if not Status.Preparation.Value and not Status.RoundOver.Value then
        table.clear(DamageLogData)
        Events.RoundStart:Fire() 
    end
end

function handleRoundEndEvent()
    if Status.RoundOver.Value then
        Events.RoundEnd:Fire() 
    end
end

Status.Preparation:GetPropertyChangedSignal('Value'):Connect(handleRoundStartEvent)
Status.RoundOver:GetPropertyChangedSignal('Value'):Connect(handleRoundEndEvent)


local mt = getrawmetatable(game)
setreadonly(mt, false)
local namecall = mt.__namecall

mt.__namecall = function(self,...)
	local args = {...}

	if tostring(getnamecallmethod()) == 'FireServer' and tostring(self) == 'HitPart' then
		spawn(function()
		    if game.Players:GetPlayerFromCharacter(args[1].Parent) then
		        print('Possible HitEvent')
		        --[[spawn(function()
		            handleHitEvent(game.Players:GetPlayerFromCharacter(args[1].Parent))  
		        end)
		        
		        spawn(function()
		            handleKillEvent(game.Players:GetPlayerFromCharacter(args[1].Parent)) 
		        end)]]
		    end
		end)
	end
	return namecall(self,...)
end

setreadonly(mt, true)

return Events;
