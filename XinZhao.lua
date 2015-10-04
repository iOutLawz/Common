if GetObjectName(myHero) ~= ("XinZhao") then return end


require('Inspired')
require('IOW')

xinMenu = Menu("OutLawz | XinZhao", "OutLawz | XinZhao")
xinMenu:SubMenu("C", "Combo")
xinMenu.C:Boolean("R", "Use R", true)
xinMenu.C:Boolean("E", "Use E", true)
xinMenu.C:Boolean("W", "Use W", true)
xinMenu.C:Boolean("Q", "Use Q", true)
xinMenu.C:Key("Combo", "Combo", string.byte(" "))

xinMenu:SubMenu("KS", "KillSteal")
xinMenu.KS:Boolean("E/R", "Use E/R", true)

xinMenu:SubMenu("Item", "Use Items")
xinMenu.Item:Boolean("Youmuus", "Use Youmuu's Ghostblade", true)
xinMenu.Item:Boolean("Blade", "Use Blade Of The Ruined King", true)

xinMenu:SubMenu("JG", "JungleClear/LaneClear")
xinMenu.JG:Boolean("E", "Use E", true)
xinMenu.JG:Boolean("Q", "Use Q", true)
xinMenu.JG:Boolean("W", "Use W", true)

xinMenu:SubMenu("Drawings", "Drawings")
xinMenu.Drawings:Boolean("E", "Draw E", true)
xinMenu.Drawings:Boolean("R", "Draw R", true)


xinMenu:SubMenu("Misc", "Misc")
xinMenu.Misc:Boolean("AutoIgnite", "AutoIgnite", false)
xinMenu.Misc:Boolean ("AutoLevel", "AutoLevel", true)
xinMenu.Misc:List("Autolvltable", "LVL Priority", 1, {"Q-W-E", "E-Q-W", "Q-E-W"})


xinMenu:Info("ol", " ")
xinMenu:Info("MadeBy:", "MadeBy:")
xinMenu:Info("out", "OutLawz")


-- 

OnLoop(function(myHero)



-- COMBO
if IOW:Mode() == "Combo" then
local target = GetCurrentTarget()
	if CanUseSpell(myHero,_R) == READY and xinMenu.C.R:Value() and GoS:ValidTarget(target, 120) then
			CastTargetSpell(target, _R)			
		end

	if CanUseSpell(myHero,_E) == READY and xinMenu.C.E:Value() and GoS:ValidTarget(target, 649) then
			CastTargetSpell(target, _E)
		end
		
	if CanUseSpell(myHero,_W) == READY and xinMenu.C.W:Value() then
			CastSpell(_W)
		end

	if CanUseSpell(myHero,_Q) == READY and xinMenu.C.Q:Value()	then
			CastSpell(_Q)	
		end	

end

for i,enemy in pairs(GoS:GetEnemyHeroes()) do        
        local ExtraDmg = 0
        if GotBuff(myHero, "itemmagicshankcharge") > 99 then
        ExtraDmg = ExtraDmg + 0.1*GetBonusAP(myHero) + 100
            end
if Ignite and xinMenu.Misc.AutoIgnite:Value() then
                  if CanUseSpell(myHero, Ignite) == READY and 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*2.5 and GoS:ValidTarget(enemy, 600) then
                  CastTargetSpell(enemy, Ignite)
                  end
                end
end

-- KS
for i,enemy in pairs(GoS:GetEnemyHeroes()) do
if CanUseSpell(myHero, _R) == READY and CanUseSpell(myHero, _E) == READY and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < GoS:CalcDamage(myHero, enemy, 0, 30 + 40*GetCastLevel(myHero,_E) + 0.60*GetBonusAP(myHero) + 100*GetCastLevel(myHero, _R) + 0.100*GetBonusDmg(myHero) + 0.15*GetCurrentHP(enemy)) and GoS:ValidTarget(enemy, 630) then
		CastTargetSpell(_E, enemy)
		CastTargetSpell(_R, enemy)

end
end

-- Items

if xinMenu.C.Combo:Value() then
local Blade = GetItemSlot(myHero,3153)
local Youmuus = GetItemSlot(myHero,3142)	
		if Blade >= 1 and GoS:ValidTarget(target,GetCastRange(myHero,_R)) and (GetMaxHP(myHero) / GetCurrentHP(myHero)) >= 1.25 and xinMenu.Item.Blade:Value() then 
		if CanUseSpell(myHero,GetItemSlot(myHero,3153)) == READY then
			CastTargetSpell(target,GetItemSlot(myHero,3153))
		end
	end

	if Youmuus >= 1 and GoS:ValidTarget(target,GetCastRange(myHero,_R)) and xinMenu.Item.Youmuus:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,3142)) == READY then
			CastSpell(GetItemSlot(myHero,3142))
		end
	end
	
end


-- JungleClear
for _,mob in pairs(GoS:GetAllMinions(MINION_JUNGLE)) do
if IOW:Mode() == "LaneClear" then
	if CanUseSpell(myHero, _E) == READY and xinMenu.JG.E:Value() and GoS:ValidTarget(mob, 675) then
		CastTargetSpell(mob, _E)
	end
	
	if CanUseSpell(myHero, _Q) == READY and xinMenu.JG.Q:Value() then
		CastSpell(_Q)
	end

	if CanUseSpell(myHero, _W) == READY and xinMenu.JG.Q:Value() then
		CastSpell(_W)
	end
	

end
end



-- AutoLevel

if xinMenu.Misc.AutoLevel:Value() then
	if xinMenu.Misc.Autolvltable:Value() == 1 then leveltable = {_Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,}
   elseif xinMenu.Misc.Autolvltable:Value() == 2 then leveltable = {_E, _Q, _W, _W, _Q, _R, _W, _W, _W, _Q, _R, _Q, _Q, _Q, _E, _R, _E, _E}
   elseif xinMenu.Misc.Autolvltable:Value() == 3 then leveltable = {_Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,}
   end
LevelSpell(leveltable[GetLevel(myHero)])
end



-- Drawings

if xinMenu.Drawings.E:Value() then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,(GetCastRange(myHero,_E)),3,100,0xff790101) end
if xinMenu.Drawings.R:Value() then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,(GetCastRange(myHero,_R)),3,100,0xff320101) end

end)

PrintChat(string.format("<font color='#FFFFFF'>XinZhao Loaded !</font>"))
PrintChat(string.format("<font color='#FFFFFF'>_SpellRange:</font>"))
PrintChat(string.format("<font color='#FF0000'>Q </font> <font color='#000000'>Range</font>"))
PrintChat(string.format("<font color='#BF0202'>W </font> <font color='#000000'>Range</font>"))
PrintChat(string.format("<font color='#790101'>E </font> <font color='#000000'>Range</font>"))
PrintChat(string.format("<font color='#320101'>R </font> <font color='#000000'>Range</font>"))
