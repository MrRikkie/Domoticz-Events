commandArray = {}
-- Variable Slaapkamer EenS
daikin1_ip = '*.*.*.*' -- Slaapkamer EenS
daikin1_mode = 'Daikin Mode'
daikin1_wind = 'Daikin Wind'
daikin1_fanspeed = 'Daikin Ventilatorsnelheid'
daikin1_power = 'Daikin Power'
daikin1_tempoffset = 'Daikin Zet Temperatuur'
daikin1_specialmode = 'Daikin Special Mode'
daikin1_powermode = 'Daikin_Power_Mode'

-- Variable Slaapkamer Mick

daikin_ip2 = '*.*.*.*' -- Slaapkamer Mick

if (devicechanged[daikin1_mode]) or (devicechanged[daikin1_wind]) or (devicechanged[daikin1_fanspeed]) or (devicechanged[daikin1_power]) then
    print ("-- Daikin script started --")
    stemp = otherdevices_svalues[daikin1_tempoffset]
    if (otherdevices[daikin1_power] == 'Off') then
        pow = 0
        mode = 0
    else
        pow = 1
        if (otherdevices[daikin1_mode] == 'Verwarmen') then
            mode = 4
        elseif (otherdevices[daikin1_mode] == 'Koelen') then
            mode = 3
        elseif (otherdevices[daikin1_mode] == 'Auto') then
            mode = 0
        elseif (otherdevices[daikin1_mode] == 'Drogen') then
            mode = 2
        elseif (otherdevices[daikin1_mode] == 'Ventilator') then
            mode = 6
        end
    end
    if (otherdevices[daikin1_fanspeed] == 'Auto') then
        f_rate = 'A'
    elseif (otherdevices[daikin1_fanspeed] == 'Silent') then
        f_rate = 'B'
    elseif (otherdevices[daikin1_fanspeed] == 'l1') then
        f_rate = '3'
    elseif (otherdevices[daikin1_fanspeed] == 'l2') then
        f_rate = '4'
    elseif (otherdevices[daikin1_fanspeed] == 'l3') then
        f_rate = '5'
    elseif (otherdevices[daikin1_fanspeed] == 'l4') then
        f_rate = '6'
    elseif (otherdevices[daikin1_fanspeed] == 'l5') then
        f_rate = '7'
    end
    f_dir = '0'
    if (otherdevices[daikin1_wind] == 'Uit') then
        f_dir = '0'
    end
    if (otherdevices[daikin1_wind] == 'Roteren') then
        f_dir = '1'
    end
    print (" * Build URL")
    cmd = 'curl "http://' .. daikin1_ip .. '/aircon/set_control_info?pow='..pow..'&mode='..mode..'&stemp='..stemp..'&shum=0&f_rate='..f_rate..'&f_dir='..f_dir..'"'
    print (" * Command: "..cmd)
    os.execute(cmd)
end

if (devicechanged[daiking1_specialmode]) then
    print (" * Daikin Special Mode Script started")
     if (otherdevices[daiking1_specialmode] == 'Off') then
            spmode = '0'
            sPowermodegezet = tonumber(uservariables[daiking1_powermode])
		    if (sPowermodegezet~=0) then
		        spmodekind = tonumber(uservariables[daiking1_powermode])
			    print (" * Powermode was " ..spmodekind)
			end

        elseif (otherdevices[daiking1_specialmode] == 'Economic Mode') then
            spmode = '1'
            spmodekind = '2'
			commandArray['Variable:Daikin1_Power_Mode'] = tostring(2)
        elseif (otherdevices[daiking1_specialmode] == 'Power Mode') then
            spmode = '1'
            spmodekind = '1'
            commandArray['Variable:Daikin_Power_Mode'] = tostring(1)
    end
    cmd = 'curl "http://' .. daikin1_ip .. '/aircon/set_special_mode?set_spmode='..spmode..'&spmode_kind='..spmodekind..'"'
    print (" * Command: "..cmd)
    os.execute(cmd)
end
return commandArray
