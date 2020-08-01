return {
	active = true,

	on = {
		timer 			= {'every minute'},
		httpResponses 	= {'DataFromAirco'}
	},

	execute = function(domoticz, item)
	    domoticz.log('-- Daikin1_GetValues --')
	    -- Variable Slaapkamer EenS
        local daikin1_ip = '10.10.0.48' -- Slaapkamer EenS
        local daikin1_mode = 'Daikin Mode'
        local daikin1_wind = 'Daikin Wind'
        local daikin1_fanspeed = 'Daikin Ventilatorsnelheid'
        local daikin1_power = 'Daikin Power'
        local daikin1_tempoffset = 'Daikin Zet Temperatuur'
        local daikin1_specialmode = 'Daikin Special Mode'
        local daikin1_powermode = 'Daikin_Power_Mode'

        if item.isTimer then
		
			domoticz.openURL({
				url = 'http://'.. daikin1_ip ..'/aircon/get_control_info',
				callback = 'DataFromAirco',
			})
			
        elseif (item.isHTTPResponse) then
			if item.ok then -- self.statusCode >= 200 and self.statusCode <= 299
				domoticz.log(' * Succesful connection')
				domoticz.log(item.data)
				local response = item.data
				local firstSplit = domoticz.utils.stringSplit(response,',') -- split the response string on comma -> one assignment per row
                local results = {}
                for _, row in ipairs(firstSplit) do
                	local hTable = domoticz.utils.stringSplit(row,'=') -- split every row into a helper table containing a key and a value
                 	local key = hTable[1]
                	local value = tonumber(hTable[2]) or hTable[2] -- store value as number when possible. If not store as string 
                	results[key] = value 
                end	

                	domoticz.log(' * pow = '.. results.pow)
                	domoticz.log(' * mode = '..results.mode)
                	domoticz.log(' * stemp = '..results.stemp)
                	domoticz.log(' * rate = '..results.f_rate)
                	domoticz.log(' * f_dir= '..results.f_dir)
                	
--                	domoticz.devices('Temp Setpoint (airco serre)').updateSetPoint(results.stemp)
--                	if (results.pow == 1) then domoticz.devices('Power (airco serre)').switchOn() end
--                	if (results.pow == 0) then domoticz.devices('Power (airco serre)').switchOff() end                	
--                	if (results.mode == 0) or (results.mode == 1) or (results.mode == 7) then domoticz.devices('Mode (airco serre)').switchSelector('AUTO')
--                	elseif (results.mode == 2) then domoticz.devices('Mode (airco serre)').switchSelector('DEHUMDIFICATOR')
--                	elseif (results.mode == 3) then domoticz.devices('Mode (airco serre)').switchSelector('COLD')
--                    elseif (results.mode == 4) then domoticz.devices('Mode (airco serre)').switchSelector('HOT')
--                	elseif (results.mode == 6) then domoticz.devices('Mode (airco serre)').switchSelector('FAN')
--    	            end
--                	if (results.f_rate == 'A') then domoticz.devices('Ventilation (airco serre)').switchSelector('AUTO')
--                	elseif (results.f_rate == 'B') then domoticz.devices('Ventilation (airco serre)').switchSelector('Silence')
--                	elseif (results.f_rate == 3) then domoticz.devices('Ventilation (airco serre)').switchSelector('Lev 1')
--                	elseif (results.f_rate == 4) then domoticz.devices('Ventilation (airco serre)').switchSelector('Lev 2')
--                	elseif (results.f_rate == 5) then domoticz.devices('Ventilation (airco serre)').switchSelector('Lev 3')
--                	elseif (results.f_rate == 6) then domoticz.devices('Ventilation (airco serre)').switchSelector('Lev 4')
--                	elseif (results.f_rate == 7) then domoticz.devices('Ventilation (airco serre)').switchSelector('Lev 5')
--                	end
--                	if (results.f_dir == 0) then domoticz.devices('Winds (airco serre)').switchSelector('Stopped')
--                	elseif (results.f_dir == 1) then domoticz.devices('Winds (airco serre)').switchSelector('Vert')
--                	elseif (results.f_dir == 2) then domoticz.devices('Winds (airco serre)').switchSelector('Horiz')
--                	elseif (results.f_dir == 3) then domoticz.devices('Winds (airco serre)').switchSelector('Both')
--                    end

			else
				domoticz.notify('Unsuccesful connection airco settings')
			end
        end
	end
}
