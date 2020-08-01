local WaterKlepVoortuin = 215
local WaterKlepVoortuinTijd = 30

return 
{
    on = 
    {
        devices = { WaterKlepVoortuin },
        timer = {'every 5 minutes' },
    },
    
    logging = { level = domoticz.LOG_DEBUG }, -- switch to LOG_ERROR when working as expected

    execute = function(dz, item)
        _G.logMarker =  _G.moduleLabel
        
        local WaterKlep1 = dz.devices(WaterKlepVoortuin)
        
        if item.isDevice then
            if item.state == 'On' then
            	item.cancelQueuedCommands()
                item.switchOff().afterMin(WaterKlepVoortuinTijd)
                dz.log('Waterklep voortuin is aan, automatisch uit na ; ' .. tostring(WaterKlepVoortuinTijd) .. ' min',dz.LOG_DEBUG)
            else
                dz.log('Waterklep voortuin uitgezet',dz.LOG_DEBUG)
            end
        else
            dz.log('Waterklep voortuin status is : ' .. WaterKlep1.state .. '. Laatste update was : ' .. WaterKlep1.lastUpdate.secondsAgo .. ' seconden geleden.' ,dz.LOG_DEBUG)
        end
    end
}
