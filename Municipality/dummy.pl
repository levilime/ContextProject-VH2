%Definition for beliefs
:- dynamic
	actionlog/4,
	answered_request/2,
	attempttoBuild/1,
	azc_timeout/1,
	building/7,
	function/3,
	functions/1,
	greenId/2,
	havebuiltsomething/0,
	indicator/4,
	indicatorLink/2,
	land/5,
	my_stakeholder_id/1,
	open_request/9,
	request/2,
	requests/1,
	self/1,
	settings/1,
	stakeholder/4,
	stakeholders/1,
	zone/5,
	zone_link/4.

%We have a building if the building list has at least 1 element.
havebuilding :- true.

% Get our current budget
money(Budget) :- my_stakeholder_id(StakeholderID),indicatorLink(StakeholderID,LinkIndicator),
		 member(indicatorWeights(IndicatorID,'Budget Gemeente',_),LinkIndicator),
		 indicator(IndicatorID,Budget,_,_).
% Progress building azc
azc(Result) :- my_stakeholder_id(StakeholderID),indicatorLink(StakeholderID,LinkIndicator),
	    member(indicatorWeights(IndicatorID,'AZC',_),LinkIndicator),
	    indicator(IndicatorID,Progress,Target,_),
	    Result is Target-(Progress*Target0).

% We want a park if we need it
buildPark(ZoneID,MultiPolygon) :- attempttoBuild(MultiPolygon).

% We want a azc if we need it
buildAZC(Land,Floors) :- land(Land,_,MultiPolygon,_,_), attempttoBuild(MultiPolygon).

%Link the actionlogs to the open requests that need to be answered.
actionlogRequestLink(ID, SenderID, ActionID) :- open_request(RequestType, ID, ContentLinkID, SenderID, ActionlogIDs, Price, Multipolygon, AreaSize, AnswerList), 
	member(ActionID, ActionlogIDs).