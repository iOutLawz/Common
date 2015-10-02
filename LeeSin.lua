if GetObjectName(myHero) ~= ("LeeSin") then return end

-- Menus
lee = Menu ("OutLawz | LeeSin", "OutLawz | Lee Sin")
lee:SubMenu("C", "Combo")
lee.C:Boolean("Q", "Use Q", true)
lee.C:Boolean("W", "Use W", true)
lee.C:Boolean("E", "Use E", true)
lee.C:Boolean("R", "Use R", true)
lee.C:Info("OI", "Uncheck the 'R' if")
lee.C:Info("Tchau", "using the KillSteal c:")

lee:SubMenu("KS", "KillSteal")
lee.KS:Boolean("R", "Use Q/R", false)
lee.KS:Boolean("R", "Use Q/E", false)
lee.KS:Info("ol", "you can leave the")
lee.KS:Info("olb", "two activated ^^")


lee:SubMenu("CL", "LaneClear")
lee.CL:Boolean("E", "Use E", true)
lee.CL:Boolean("W", "Use W", true)

lee:SubMenu("Misc", "Misc")
lee.Misc:Boolean("AutoIgnite", "AutoIgnite", false)
lee.Misc:Boolean("AutoLevel", "AutoLevel", false)
lee.Misc:List("Autolvltable", "LVL Priority", 1, {"Q-E-W", "E-Q-W", "Q-W-E"})

lee:SubMenu("JungleSteal", "Steal Dragon/Baron")
lee.JungleSteal:Boolean("JG", "Enable", true)


lee:SubMenu("Drawings", "Drawings")
lee.Drawings:Boolean("Q", "Draw Q", true)
lee.Drawings:Boolean("W", "Draw W", true)
lee.Drawings:Boolean("E", "Draw E", false)
lee.Drawings:Boolean("R", "Draw R", true)

lee:Info("ol", " ")
lee:Info("MadeBy:", "MadeBy:")
lee:Info("out", "OutLawz")
-- -- - -- - - - - --- - -  - -- -- - - - - - - - --- - -- 


OnLoop(function(myHero)
-- Combo
if IOW:Mode() == "Combo" then
local target = GetCurrentTarget()
	local QPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),1800,250,1100,60,true,false)

    if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and GoS:ValidTarget(target, GetCastRange(myHero,_Q)) and lee.C.Q:Value() then
        CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
	end
	
	if CanUseSpell(myHero,_E) == READY and lee.C.E:Value() then
		CastSpell(_E)
	end

	if CanUseSpell(myHero,_W) == READY and lee.C.W:Value() and (GetCurrentHP(myHero)/GetMaxHP(myHero))<0.3 then
		CastTargetSpell(myHero, _E)
	end
	
	if CanUseSpell(myHero,_R) == READY and lee.C.R:Value() then
		CastTargetSpell(target, _R)
	end

end


-- KS
local ExtraDmg = 0
		if GotBuff(myHero, "itemmagicshankcharge") > 99 then
	        ExtraDmg = ExtraDmg + 0.1*GetBonusAP(myHero) + 100
		end

		local target = GetCurrentTarget()	
		local QPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),1800,250,1100,60,true,false)
for i,enemy in pairs(GoS:GetEnemyHeroes()) do
if CanUseSpell(myHero,_Q) and QPred.HitChance == 1 and GoS:ValidTarget(target, GetCastRange(myHero,_Q)) and CanUseSpell(myHero,_R) and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < GoS:CalcDamage(myHero, enemy, 0, 20 + 30*GetCastLevel(myHero,_Q) + 0.90*GetBonusDmg(myHero) + 200*GetCastLevel(myHero,_R) + 0.200*GetBonusDmg(myHero) + ExtraDmg) and GoS:ValidTarget(enemy, 850) and lee.KS.R:Value() then 
				CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
				CastTargetSpell(enemy, _R)
elseif CanUseSpell(myHero,_Q) and QPred.HitChance == 1 and GoS:ValidTarget(target, GetCastRange(myHero,_Q))and CanUseSpell(myHero,_E) and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < GoS:CalcDamage(myHero, enemy, 0, 20 + 30*GetCastLevel(myHero,_Q) + 0.90*GetBonusDmg(myHero) + 25 + 35*GetCastLevel(myHero,_E) + 0.100*GetBonusAP(myHero) + ExtraDmg) and GoS:ValidTarget(enemy, 900) then 
				CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
				CastSpell(_E)	
			end
				
end



--JungleClear
if IOW:Mode() == "LaneClear" then
	if CanUseSpell(myHero, _E) == READY and lee.CL.E:Value() then
		CastSpell(_E)
	end

	if CanUseSpell(myHero, _W) == READY and lee.CL.W:Value() then
		CastSpell(_W)
	end
end



-- Misc
for i,enemy in pairs(GoS:GetEnemyHeroes()) do        
        local ExtraDmg = 0
        if GotBuff(myHero, "itemmagicshankcharge") > 99 then
        ExtraDmg = ExtraDmg + 0.1*GetBonusAP(myHero) + 100
            end
if Ignite and lee.Misc.AutoIgnite:Value() then
                  if CanUseSpell(myHero, Ignite) == READY and 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*2.5 and GoS:ValidTarget(enemy, 600) then
                  CastTargetSpell(enemy, Ignite)
                  end
                end
end



if lee.Misc.AutoLevel:Value() then
	if lee.Misc.Autolvltable:Value() == 1 then leveltable = {_Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,}
   elseif lee.Misc.Autolvltable:Value() == 2 then leveltable = {_E, _Q, _W, _W, _Q, _R, _W, _W, _W, _Q, _R, _Q, _Q, _Q, _E, _R, _E, _E}
   elseif lee.Misc.Autolvltable:Value() == 3 then leveltable = {_Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W,}
   end
LevelSpell(leveltable[GetLevel(myHero)])
end



for i,bigmobs in pairs(GoS:GetAllMinions(MINION_JUNGLE)) do

		local Damage = 20 + 30*GetCastLevel(myHero,_Q)
		local BigMobPos = GetOrigin(bigmobs)



			if GotBuff(myHero, "itemmagicshankcharge") > 99 then
				
			end	

			if GoS:ValidTarget(bigmobs, GetCastRange(myHero,_Q)) and GoS:GetDistance(bigmobs) < GetCastRange(myHero,_Q) then 
				local QPred = GetPredictionForPlayer(GoS:myHeroPos(),bigmobs,GetMoveSpeed(bigmobs),1800,250,1100,60,true,false)
				if CanUseSpell(myHero, _Q) == READY and  GoS:CalcDamage(myHero, bigmobs, 0, Damage) > GetCurrentHP(bigmobs) and GetObjectName(bigmobs) == "SRU_Baron" and lee.JungleSteal.JG:Value() then
					CastSkillShot(_Q,BigMobPos.x,BigMobPos.y,BigMobPos.z)
				elseif CanUseSpell(myHero, _Q) == READY and  GoS:CalcDamage(myHero, bigmobs, 0, Damage) > GetCurrentHP(bigmobs) and GetObjectName(bigmobs) == "SRU_Dragon" and lee.JungleSteal.JG:Value() then
					CastSkillShot(_Q,BigMobPos.x,BigMobPos.y,BigMobPos.z)
				end
			end
	end





if lee.Drawings.Q:Value() then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,(GetCastRange(myHero,_Q)),3,100,0xff010000) end
if lee.Drawings.E:Value() then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,(GetCastRange(myHero,_E)),3,100,0xff010000) end
if lee.Drawings.W:Value() then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,(GetCastRange(myHero,_W)),3,100,0xff010000) end
if lee.Drawings.R:Value() then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,(GetCastRange(myHero,_R)),3,100,0xff010000) end

end)

PrintChat("For a 100% operation, download the WardJump made by ilovesona in the forum.")
PrintChat("LeeSin Loaded !")
PrintChat("MadeBy: OutLawz")





