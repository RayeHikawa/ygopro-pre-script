--X・HERO ワンダー・ドライバー
--Xtra HERO Wonder Driver
--Scripted by Eerie Code
function c100224002.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x8),2,2)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100224002,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,100224002)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c100224002.setcon)
	e1:SetTarget(c100224002.settg)
	e1:SetOperation(c100224002.setop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(c100224002.spcon)
	e3:SetTarget(c100224002.sptg)
	e3:SetOperation(c100224002.spop)
	c:RegisterEffect(e3)
end
function c100224002.setcfilter(c,tp,lg)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x8) and lg:IsContains(c)
end
function c100224002.setcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c100224002.setcfilter,1,nil,tp,lg)
end
function c100224002.setfilter(c)
	return ((c:IsType(TYPE_SPELL) and c:IsSetCard(0x46)) or (c:IsType(TYPE_QUICKPLAY) and c:IsSetCard(0xa5))) and c:IsSSetable()
end
function c100224002.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100224002.setfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c100224002.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c100224002.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsSSetable() then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c100224002.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE)
		or (rp==1-tp and c:IsReason(REASON_DESTROY) and c:GetPreviousControler()==tp)
end
function c100224002.spfilter(c,e,tp)
	return c:IsSetCard(0x8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100224002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100224002.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c100224002.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100224002.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
