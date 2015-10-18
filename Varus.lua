if GetObjectName(myHero) ~= ("Varus") then return end
require('Inspired')
require('IOW')

-- Combo
Varus = Menu("OutLawz | Varus", "OutLawz | Varus")
Varus:SubMenu("C", "Combo")
Varus.C:Boolean("Q", "Use Q", false)
Varus.C:Boolean("QKS", "Use Q when target is killable", true)
Varus.C:Boolean("E", "Use E", true)
Varus.C:Boolean("Ignite", "Use Ignite on Combo", true)
Varus.C:Slider("R", "Use R X Enemies", 1, 0, 5, 1)

-- Harass
Varus:SubMenu("HS", "Harass")
Varus.HS:Boolean("Q", "Use Q", true)
Varus.HS:Boolean("E", "Use E", true)
Varus.HS:Slider("Mana", "Min Mana %", 40, 1, 100, 1)

-- Misc and Drawings
Varus:SubMenu("Drawings", "Drawings")
Varus.Drawings:Boolean("Q", "Draw Q", true)
Varus.Drawings:Boolean("E", "Draw E", true)
Varus.Drawings:Boolean("R", "Draw R", true)

Varus:SubMenu("Misc", "Misc")
Varus.Misc:Boolean("AutoIgnite", "AutoIgnite (KS)", false)
Varus.Misc:Boolean ("AutoLevel", "AutoLevel", true)
Varus.Misc:List("Autolvltable", "LVL Priority", 1, {"Q-E-W", "E-Q-W", "E-W-Q"})

Varus:Info("ol", " ")
Varus:Info("Made By:", "Made By:")
Varus:Info("out", "OutLawz")


-- Send me a 'I Love You <3'
OnLoop(function(myHero)

	if IOW:Mode() == "Combo" then
	local target = GetCurrentTarget()
	local EnPos = GetOrigin(target)
	local RPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),1200,250,1100,120,false,false)
		if CanUseSpell(myHero,_R) == READY and Varus.C.R:Value() and GoS:ValidTarget(target,GetCastRange(myHero,_R)) then
			if GoS:EnemiesAround(GetOrigin(enemy), 150) == Varus.C.R:Value() then
			CastSkillShot(_R,RPred.PredPos.x, RPred.PredPos.y, RPred.PredPos.z)
        	end
    	end

    	if CanUseSpell(myHero,_E) == READY and GoS:ValidTarget(target,GetCastRange(myHero,_E)) and Varus.C.E:Value() then
    		CastSkillShot(_E,EnPos.x,EnPos.y,EnPos.z)
        end	

        for i,enemy in pairs(GoS:GetEnemyHeroes()) do        
    	local ExtraDmg = 0
    	if GotBuff(myHero, "itemmagicshankcharge") > 99 then
        ExtraDmg = ExtraDmg + 0.1*GetBonusAP(myHero) + 100
        end
		if Ignite and Varus.C.Ignite:Value() then
    	if CanUseSpell(myHero, Ignite) == READY and 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*0.3 and GoS:ValidTarget(enemy, 600) then
         CastTargetSpell(enemy, Ignite)
     	end
		end
		end

		if CanUseSpell(myHero,_Q) == READY and GoS:ValidTarget(target,GetCastRange(myHero,_Q)) and Varus.C.Q:Value() then
			CastSkillShot(_Q,EnPos.x,EnPos.y,EnPos.z)
		end

		if CanUseSpell(myHero,_Q) == READY and GoS:ValidTarget(target,GetCastRange(myHero,_Q)) then
			if Varus.C.QKS:Value() and GetCurrentHP(target)+GetMagicShield(target)+GetDmgShield(target) < GoS:CalcDamage(myHero, target, 0, 0 + 37*GetCastLevel(myHero,_Q) + GetBonusDmg(myHero)) then
			CastSkillShot(_Q,EnPos.x,EnPos.y,EnPos.z)
		end
		end		

	end	


-- Harass
if IOW:Mode() == "Harass"  then 
	local target = GetCurrentTarget() 
	local EnPos = GetOrigin(target)

	if CanUseSpell(myHero,_Q) == READY and Varus.HS.Q:Value() and GetCurrentMana(myHero)/GetMaxMana(myHero) >= Varus.HS.Mana:Value() and GoS:ValidTarget(target,GetCastRange(myHero,_Q)) then
		CastSkillShot(_Q,EnPos.x,EnPos.y,EnPos.z)
	end

	if CanUseSpell(myHero,_E) == READY and Varus.HS.E:Value() and GetCurrentMana(myHero)/GetMaxMana(myHero) >= Varus.HS.Mana:Value() and GoS:ValidTarget(target,GetCastRange(myHero,_E)) then
    	CastSkillShot(_E,EnPos.x,EnPos.y,EnPos.z)
    end	
end



-- Misc

	-- AutoIgnite
	for i,enemy in pairs(GoS:GetEnemyHeroes()) do        
    local ExtraDmg = 0
    if GotBuff(myHero, "itemmagicshankcharge") > 99 then
        ExtraDmg = ExtraDmg + 0.1*GetBonusAP(myHero) + 100
            end
	if Ignite and Varus.Misc.AutoIgnite:Value() then
    if CanUseSpell(myHero, Ignite) == READY and 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*2.5 and GoS:ValidTarget(enemy, 600) then
         CastTargetSpell(enemy, Ignite)
     end
end
end


	-- AutoLevel
	if Varus.Misc.AutoLevel:Value() then
	if Varus.Misc.Autolvltable:Value() == 1 then leveltable = {_Q, _W, _E, _Q, _Q, _R, _E, _Q, _E, _Q, _R, _E, _E, _W, _W, _R, _W, _W,}
    elseif Varus.Misc.Autolvltable:Value() == 2 then leveltable = {_E, _Q, _W, _W, _Q, _R, _W, _W, _W, _Q, _R, _Q, _Q, _Q, _E, _R, _E, _E}
    elseif Varus.Misc.Autolvltable:Value() == 3 then leveltable = {_E, _W, _Q, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,}
end
LevelSpell(leveltable[GetLevel(myHero)])
end


	-- Drawings

if Varus.Drawings.Q:Value() then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,(GetCastRange(myHero,_Q)),3,100,0xffFF0000) end
if Varus.Drawings.E:Value() then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,(GetCastRange(myHero,_E)),3,100,0xff790101) end
if Varus.Drawings.R:Value() then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,(GetCastRange(myHero,_R)),3,100,0xff320101) end

end)

PrintChat(string.format("<font color='#FF0000'>Varus Loaded !</font>"))
PrintChat(string.format("<font color='#FF0000'>_SpellRange:</font>"))
PrintChat(string.format("<font color='#FF0000'>Q </font> <font color='#000000'>Range</font>"))
PrintChat(string.format("<font color='#BF0202'>W </font> <font color='#000000'>Range</font>"))
PrintChat(string.format("<font color='#790101'>E </font> <font color='#000000'>Range</font>"))
PrintChat(string.format("<font color='#320101'>R </font> <font color='#000000'>Range</font>"))


 -- Report any errors -- 
