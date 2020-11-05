--E.M.R.
--
--Script by 龙骑
function c101103078.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c101103078.cost)
	e1:SetTarget(c101103078.target)
	e1:SetOperation(c101103078.operation)
	c:RegisterEffect(e1)
end
function c101103078.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		e:SetLabel(100)
		return true
	end
end
function c101103078.costfilter(c,tp)
	return c:IsRace(RACE_MACHINE) and (c:IsControler(tp) or c:IsFaceup()) and c:GetTextAttack()>=1000
		and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c101103078.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c101103078.costfilter,1,nil,tp)
	end
	local g=Duel.SelectReleaseGroup(tp,c101103078.costfilter,1,1,nil,tp)
	local atk=g:GetFirst():GetTextAttack()
	Duel.Release(g,REASON_COST)
	local ct=math.floor(atk/1000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c101103078.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
