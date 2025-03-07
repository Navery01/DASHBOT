USE DarwinCore;
DROP VIEW IF EXISTS GuildVoiceActivity;
CREATE VIEW GuildVoiceActivity AS (
	SELECT DISTINCT
		  gd.GuildName
        , gd.GuildID  
		, ud.UserName
        , ud.UserID
        , ed.EventCategory
        , ed.EventType AS StartingEvent
        , ed2.EventType AS EndingEvent
        , af.DurationSeconds
        , af.EventStartTime
        , af.EventEndTime
    FROM ActivityFact af
    JOIN EventDim ed
		ON af.EventStartDimKey = ed.EventDimKey
        AND ed.EventType IN ('JOIN', 'STREAM', 'MUTE', 'DEAF')
	JOIN EventDim ed2
		ON af.EventEndDimKey = ed2.EventDimKey
	JOIN UserDim ud
		ON ud.UserDimKey = af.UserDimKey AND ud.IsCurrent=1
	JOIN GuildDim gd
		ON gd.GuildDimKey = af.GuildDimKey AND gd.IsCurrent=1
	ORDER BY EventStartTime DESC

);