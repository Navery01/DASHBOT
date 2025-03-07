USE DarwinCore;

CREATE VIEW DiscordUserActivity AS (

	SELECT 
		  ud.UserID
		, ud.UserName
        , uad.EventCategory
        , uad.EventText
        , uad.EventTimeStamp AS StartTime
        , uad2.EventTimeStamp AS EndTime
        , uaf.DurationSeconds        
    FROM UserActivityFact uaf
    JOIN UserDim ud
		ON uaf.UserDimKey = ud.UserDimKey
        AND ud.IsCurrent=1
	JOIN UserActivityDim uad
		ON uaf.ActivityStartDimKey  = uad.ActivityDimKey
	JOIN UserActivityDim uad2
		ON uaf.ActivityEndDimKey  = uad2.ActivityDimKey
);