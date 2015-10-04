if GetObjectName(myHero) ~= ("Fizz") then return end


require('Inspired')
require('IOW')



Fizz = Menu("OutLawz | Fizz", "OutLawz | Fizz")
Fizz:SubMenu("C", "Combo")
Fizz.C:Boolean("W", "Use W", true)
Fizz.C:Boolean("E", "Use E", true)
Fizz.C:Boolean("Q", "Use Q", true)
Fizz.C:Boolean("R", "Use R", false)

Fizz:SubMenu("KS", "KillSteal")
Fizz.KS:Boolean("R", "Use R", true)

Fizz:SubMenu("Harass", "Harass")
Fizz.Harass:Boolean("W", "Use W", true)
Fizz.Harass:Boolean("Q", "Use Q", true)
Fizz.Harass:Boolean("E", "Use E", true)


Fizz:SubMenu("JG", "LaneClear")
Fizz.JG:Boolean("E", "Use E", true)
Fizz.JG:Boolean("W", "Use W", true)
Fizz.JG:Boolean("Q", "LastHit with Q", false)


Fizz:SubMenu("Drawings", "Drawings")
Fizz.Drawings:Boolean("Q", "Draw Q", true)
Fizz.Drawings:Boolean("E", "Draw E", true)
Fizz.Drawings:Boolean("R", "Draw R", true)


Fizz:SubMenu("Misc", "Misc")
Fizz.Misc:Boolean("E", "AutoDodge Spells with E")
Fizz.Misc:Boolean("AutoIgnite", "AutoIgnite", false)
Fizz.Misc:Boolean ("AutoLevel", "AutoLevel", true)
Fizz.Misc:List("Autolvltable", "LVL Priority", 1, {"E-W-Q", "E-Q-W", "Q-E-W"})


Fizz:Info("ol", " ")
Fizz:Info("Made By:", "Made By:")
Fizz:Info("out", "OutLawz")


--
OnLoop(function(myHero)

	-- Combo
	if IOW:Mode() == "Combo" then
	local target = GetCurrentTarget()
	local EnPos = GetOrigin(target)
	local RPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),1300,250,1275,120,true,false)
		if CanUseSpell(myHero,_W) == READY and Fizz.C.W:Value()	then
			CastSpell(_W)	
		end	

		if Fizz.C.E:Value() and GoS:ValidTarget(target,GetCastRange(myHero,_E)) and CanUseSpell(myHero, _E) == READY then
            CastSkillShot(_E,EnPos.x,EnPos.y,EnPos.z)
        end	

        if CanUseSpell(myHero, _Q) == READY and Fizz.C.Q:Value() then
			CastTargetSpell(target, _Q)
		end

		if Fizz.C.R:Value() and CanUseSpell(myHero,_R) == READY then
		if GoS:ValidTarget (target, 1255) then
    		CastSkillShot(_R,RPred.PredPos.x, RPred.PredPos.y, RPred.PredPos.z)
        end
    end
end


	-- KS

			local target = GetCurrentTarget()
			local RPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),1300,250,1275,120,true,false)
			if CanUseSpell(myHero,_R) == READY and Fizz.KS.R:Value() then
			if GoS:ValidTarget (target, 1255) and GetCurrentHP(target)+GetMagicShield(target)+GetDmgShield(target) < GoS:CalcDamage(myHero, target, 0, 75 + 125*GetCastLevel(myHero,_R) + GetBonusAP(myHero)) then
    		 CastSkillShot(_R,RPred.PredPos.x, RPred.PredPos.y, RPred.PredPos.z)
        	end
end




	-- Harass
	if IOW:Mode() == "Harass"  then 
	local target = GetCurrentTarget() 

    	if Fizz.Harass.W:Value() and CanUseSpell(myHero,_W) == READY then    
       CastSpell(_W)
  		end
	           
    	if Fizz.Harass.Q:Value() and CanUseSpell(myHero,_Q) == READY then
       CastTargetSpell(target, _Q)
    	end

    	if Fizz.Harass.E:Value() and GoS:ValidTarget (target,GetCastRange(myHero,_E)) and CanUseSpell(myHero,_E) == READY then
       CastSkillShot(_E,EnPos.x,EnPos.y,EnPos.z)
        end
    end

	-- LaneClear
	for _,mob in pairs(GoS:GetAllMinions(MINION_ENEMY)) do
	if IOW:Mode() == "LaneClear" then

	if CanUseSpell(myHero, _W) == READY and Fizz.JG.W:Value() then
		CastSpell(_W)
	end	

	if CanUseSpell(myHero, _E) == READY and Fizz.JG.E:Value() and GoS:ValidTarget(mob, 385) then
		CastTargetSpell(mob, _E)
	end
end
	end



	-- LastHit
	if IOW:Mode() == "LastHit" then
		
	if CanUseSpell(myHero, _Q) and Fizz.JG.Q:Value() and GoS:ValidTarget(mob, 550) and GetCurrentHP(mob) < GoS:CalcDamage(myHero, mob, 0, 5 + 15*GetCastLevel(myHero,_Q) + 0.25*GetBonusAP(myHero) + 0.30*GetBonusAP(myHero)) then
		CastTargetSpell(mob, _Q)
	end
	end





	-- AutoIgnite
	for i,enemy in pairs(GoS:GetEnemyHeroes()) do        
    local ExtraDmg = 0
    if GotBuff(myHero, "itemmagicshankcharge") > 99 then
        ExtraDmg = ExtraDmg + 0.1*GetBonusAP(myHero) + 100
            end
	if Ignite and Fizz.Misc.AutoIgnite:Value() then
    if CanUseSpell(myHero, Ignite) == READY and 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*2.5 and GoS:ValidTarget(enemy, 600) then
         CastTargetSpell(enemy, Ignite)
     end
end
end


	-- AutoLevel
	if Fizz.Misc.AutoLevel:Value() then
	if Fizz.Misc.Autolvltable:Value() == 1 then leveltable = {_E, _W, _Q, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W,}
    elseif Fizz.Misc.Autolvltable:Value() == 2 then leveltable = {_E, _Q, _W, _W, _Q, _R, _W, _W, _W, _Q, _R, _Q, _Q, _Q, _E, _R, _E, _E}
    elseif Fizz.Misc.Autolvltable:Value() == 3 then leveltable = {_Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,}
end
LevelSpell(leveltable[GetLevel(myHero)])
end


	-- Drawings

if Fizz.Drawings.Q:Value() then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,(GetCastRange(myHero,_Q)),3,100,0xffFF0000) end
if Fizz.Drawings.E:Value() then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,(GetCastRange(myHero,_E)),3,100,0xff790101) end
if Fizz.Drawings.R:Value() then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,(GetCastRange(myHero,_R)),3,100,0xff320101) end

end)

PrintChat(string.format("<font color='#FFFFFF'>Fizz Loaded !</font>"))
PrintChat(string.format("<font color='#FFFFFF'>_SpellRange:</font>"))
PrintChat(string.format("<font color='#FF0000'>Q </font> <font color='#000000'>Range</font>"))
PrintChat(string.format("<font color='#BF0202'>W </font> <font color='#000000'>Range</font>"))
PrintChat(string.format("<font color='#790101'>E </font> <font color='#000000'>Range</font>"))
PrintChat(string.format("<font color='#320101'>R </font> <font color='#000000'>Range</font>"))
