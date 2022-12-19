if not CLIENT then return end
local showHud = true
local startHp, oldHp, newHp = 0, -1, -1
local startAr, oldAr, newAr = 0, -1, -1
local animTime = 0.3

surface.CreateFont("AHudFont", {
    font = "Arial",
    size = 18,
    weight = 500,
    antialias = true,
    additive = false
})

hook.Add("HUDShouldDraw", "HideDRPHud", function(name)
    if name == "DarkRP_LocalPlayerHUD" then return false end
end)

concommand.Add("togglehud", function()
    showHud = not showHud
end)

hook.Add("HUDPaint", "ahud", function()
    if showHud == false then return end
    if !IsValid(LocalPlayer()) then return end

    local sw = ScrW()
    local sh = ScrH()

    local w, h = 300, 100
    local x = 10
    local y = sh - h - 10

    local health = LocalPlayer():Health()
    local maxHealth = LocalPlayer():GetMaxHealth()
    local armor = LocalPlayer():Armor()
    local maxArmor = LocalPlayer():GetMaxArmor()

    if ( oldhp == -1 and newhp == -1 ) then
		oldhp = health
		newhp = health
	end

    if ( oldAr == -1 and newAr == -1 ) then
        oldAr = armor
        newAr = armor
    end

    local smoothHP = Lerp( ( SysTime() - startHp ) / animTime, oldHp, newHp )
    local smoothAR = Lerp( ( SysTime() - startAr ) / animTime, oldAr, newAr )

    if newHp ~= health then
		if ( smoothHP ~= health ) then
			newHp = smoothHP
		end

		oldHp = newHp
		startHp = SysTime()
		newHp = health
	end

    if newAr ~= armor then
        if ( smoothAR ~= armor ) then
            newAr = smoothAR
        end

        oldAr = newAr
        startAr = SysTime()
        newAr = armor
    end

    local health_color = Color(255, 55, 45)
    local armor_color = Color(55, 45, 255)

    draw.RoundedBox(0, x, y, w, h, Color(24, 24, 32, 200))
    draw.RoundedBox(0, x + 1, y + 1, w - 2, h - 2, Color(24, 24, 32, 200))

    -- Health Bar
    local health_bar_w = w - 20
    local health_bar_h = 20
    local health_bar_x = x + 10
    local health_bar_y = y + h - health_bar_h - 5

    draw.RoundedBox(0, health_bar_x, health_bar_y, health_bar_w, health_bar_h, Color(24, 24, 32, 200))

    draw.RoundedBox(0, health_bar_x + 1, health_bar_y + 1, math.Clamp(smoothHP , 0, maxHealth ) / maxHealth * health_bar_w - 2, health_bar_h - 2, health_color)

    -- Armor Bar
    local armor_bar_w = w - 20
    local armor_bar_h = 20
    local armor_bar_x = x + 10
    local armor_bar_y = y + h - armor_bar_h - 5 - health_bar_h - 5

    draw.RoundedBox(0, armor_bar_x, armor_bar_y, armor_bar_w, armor_bar_h, Color(24, 24, 32, 200))

    draw.RoundedBox(0, armor_bar_x + 1, armor_bar_y + 1, math.Clamp(smoothAR , 0, maxArmor ) / maxArmor * armor_bar_w - 2, armor_bar_h - 2, armor_color)

    -- Health Text
    local health_text_x = health_bar_x + health_bar_w / 2
    local health_text_y = y + h - health_bar_h + 5

    draw.SimpleText(health.." HP", "AHudFont", health_text_x, health_text_y, Color(255, 255, 255, 255), 1, 1)

    -- Armor Text
    local armor_text_x = armor_bar_x + armor_bar_w / 2
    local armor_text_y = y + h - armor_bar_h - 5 - health_bar_h + 5

    draw.SimpleText(armor.." AP", "AHudFont", armor_text_x, armor_text_y, Color(255, 255, 255, 255), 1, 1)

    -- Name Text
    local name_text_x = x + 10
    local name_text_y = y + 5

    local name = LocalPlayer():Nick()
    if string.len(name) > 20 then
        name = string.sub(name, 1, 20).."..."
    end

    draw.SimpleText(name, "AHudFont", name_text_x, name_text_y, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

    -- Money Text
    local money_text_x = x + 10
    local money_text_y = name_text_y + 20

    draw.SimpleText(DarkRP.formatMoney(LocalPlayer():getDarkRPVar("money")).." (+"..DarkRP.formatMoney(LocalPlayer():getDarkRPVar("salary"))..")", "AHudFont", money_text_x, money_text_y, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

    if isnumber(LocalPlayer():GetUTimeSessionTime()) then
        local txtSession = "Session: "..timeToStr(LocalPlayer():GetUTimeSessionTime())
        local txtTotal = "Total: "..timeToStr(LocalPlayer():GetUTimeTotalTime())

        -- UTime Box
        utime_box_w = math.max((select(1, surface.GetTextSize(txtSession) )), (select(1, surface.GetTextSize(txtTotal) ))) + 25
        local utime_box_h = (select(2, surface.GetTextSize(txtSession) )) + (select(2, surface.GetTextSize(txtTotal) )) + 8
        local utime_box_x = x + w + 15
        local utime_box_y = y + h - utime_box_h

        draw.RoundedBox(0, utime_box_x, utime_box_y, utime_box_w, utime_box_h, Color(24, 24, 32, 200))
        draw.RoundedBox(0, utime_box_x + 1, utime_box_y + 1, utime_box_w - 2, utime_box_h - 2, Color(24, 24, 32, 200))

        -- UTime Color Bar
        local utime_color_bar_w = utime_box_w
        local utime_color_bar_h = 2
        local utime_color_bar_x = utime_box_x
        local utime_color_bar_y = utime_box_y + utime_box_h - utime_color_bar_h

        draw.RoundedBox(0, utime_color_bar_x, utime_color_bar_y, utime_color_bar_w, utime_color_bar_h, Color(113, 184, 251, 255))

        -- UTime Text
        local utime_text_x = utime_box_x + (25 / 2)
        local utime_text_y = y + h - utime_box_h + (8 / 2)

        draw.SimpleText(txtSession, "AHudFont", utime_text_x, utime_text_y, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(txtTotal, "AHudFont", utime_text_x, utime_text_y + (utime_box_h / 2 - 4), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    -- Job Box
    local job_box_w = select(1, surface.GetTextSize(LocalPlayer():getDarkRPVar("job")) ) + 45
    local job_box_h = select(2, surface.GetTextSize(LocalPlayer():getDarkRPVar("job")) ) + 8
    local job_box_x
    if isnumber(LocalPlayer():GetUTimeSessionTime()) then
        job_box_x = x + w + 15 + utime_box_w + 15
    else
        job_box_x = x + w + 15
    end
    local job_box_y = y + h - job_box_h

    draw.RoundedBox(0, job_box_x, job_box_y, job_box_w, job_box_h, Color(24, 24, 32, 200))
    draw.RoundedBox(0, job_box_x + 1, job_box_y + 1, job_box_w - 2, job_box_h - 2, Color(24, 24, 32, 200))

    -- Job Color Bar
    local job_color_w = job_box_w
    local job_color_h = 2
    local job_color_x = job_box_x
    local job_color_y = job_box_y + job_box_h - job_color_h

    draw.RoundedBox(0, job_color_x, job_color_y, job_color_w, job_color_h, team.GetColor(LocalPlayer():Team()))

    -- Job Text
    local job_text_x = job_box_x + (45 / 2)
    local job_text_y = y + h - job_box_h + (8 / 2)

    draw.SimpleText(LocalPlayer():getDarkRPVar("job"), "AHudFont", job_text_x, job_text_y, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end)

function timeToStr( time )
	local tmp = time
	local s = tmp % 60
	tmp = math.floor( tmp / 60 )
	local m = tmp % 60
	tmp = math.floor( tmp / 60 )
	local h = tmp % 24
	tmp = math.floor( tmp / 24 )
	local d = tmp % 7

	return string.format( "%id %02ih %02im %02is", d, h, m, s )
end