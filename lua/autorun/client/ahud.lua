local showHud = true

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
    local sw = ScrW()
    local sh = ScrH()

    local w, h = 300, 100
    local x = 10
    local y = sh - h - 10

    local health = LocalPlayer():Health()
    local armor = LocalPlayer():Armor()

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

    local health_bar_percent = (health > 100 and 100 or health) / 100
    local health_bar_w_percent = health_bar_w * health_bar_percent

    draw.RoundedBox(0, health_bar_x + 1, health_bar_y + 1, health_bar_w_percent, health_bar_h - 2, health_color)

    -- Armor Bar
    local armor_bar_w = w - 20
    local armor_bar_h = 20
    local armor_bar_x = x + 10
    local armor_bar_y = y + h - armor_bar_h - 5 - health_bar_h - 5

    draw.RoundedBox(0, armor_bar_x, armor_bar_y, armor_bar_w, armor_bar_h, Color(24, 24, 32, 200))

    local armor_bar_percent = (armor > 100 and 100 or armor) / 100
    local armor_bar_w_percent = armor_bar_w * armor_bar_percent

    draw.RoundedBox(0, armor_bar_x + 1, armor_bar_y + 1, armor_bar_w_percent, armor_bar_h - 2, armor_color)

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

    if LocalPlayer():SteamID64() == "76561198145522438" then
        draw.SimpleText("❤ Cutie ❤", "AHudFont", name_text_x, name_text_y, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    else
        draw.SimpleText(LocalPlayer():Nick(), "AHudFont", name_text_x, name_text_y, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    -- Money Text
    local money_text_x = x + 10
    local money_text_y = name_text_y + 20

    draw.SimpleText(DarkRP.formatMoney(LocalPlayer():getDarkRPVar("money")).." (+"..DarkRP.formatMoney(LocalPlayer():getDarkRPVar("salary"))..")", "AHudFont", money_text_x, money_text_y, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

    -- Job Text
    local job_text_x = x + w - 10
    local job_text_y = name_text_y

    draw.SimpleText(LocalPlayer():getDarkRPVar("job"), "AHudFont", job_text_x, job_text_y, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

    surface.SetFont( "AHudFont" )

    -- Job Color Bar
    local job_color_bar_w = select(1, surface.GetTextSize(LocalPlayer():getDarkRPVar("job")) ) + 6
    local job_color_bar_h = 2
    local job_color_bar_x = job_text_x - job_color_bar_w + 3
    local job_color_bar_y = name_text_y + 18

    local job_color = team.GetColor(LocalPlayer():Team())

    draw.RoundedBox(0, job_color_bar_x, job_color_bar_y, job_color_bar_w, job_color_bar_h, job_color)
end)