
USE DarwinCore;

DELIMITER $$

DROP PROCEDURE IF EXISTS Merge_UserActivityFact;
CREATE PROCEDURE Merge_UserActivityFact()
 BEGIN
	
	DROP TABLE IF EXISTS ActivityEventFact_WRK1;
	CREATE temporary TABLE ActivityEventFact_WRK1 AS(
		SELECT EventID
			, EventType
			, EventDescr
			, EventText
			, UserID
			, EventTimestamp
			, InsertDate
			, UpdateTime
			, ROW_NUMBER() OVER (PARTITION BY EventType, EventDescr, EventText, UserID, EventTimestamp, InsertDate, UpdateTime ORDER BY UpdateTime ) RN
		FROM DashSRC.DiscordActivityEvent e
	) ;
	DELETE FROM ActivityEventFact_WRK1 WHERE RN > 1;


	DROP TABLE IF EXISTS ActivityEventFact_WRK2;
	CREATE temporary TABLE ActivityEventFact_WRK2 AS(
	SELECT 
		e.EventID StartID
        , LEAD(e.EventID) OVER (PARTITION BY UserID, EventType, EventText ORDER BY EventTimestamp) NextEventID
		, e.EventType
		, e.EventDescr
		, e.EventText
        , e.UserID
		, e.EventTimestamp
        , e.UpdateTime
	FROM ActivityEventFact_WRK1 e
	);
    
    DROP TABLE IF EXISTS ActivityEventFact_WRK3;
    CREATE TEMPORARY TABLE ActivityEventFact_WRK3 AS(
		SELECT DISTINCT
			uad.ActivityDimKey ActivityStartDimKey
            , uad2.ActivityDimKey ActivityEndDimKey
            , ud.UserDimKey
			, aef.StartID ActivityID
            , aef.UserID
            , uad.EventTimestamp ActivityStartTime
            , uad2.EventTimeStamp ActivityEndTime
            , TIMESTAMPDIFF(SECOND, uad.EventTimestamp, uad2.EventTimestamp) AS DurationSeconds
            , aef.UpdateTime
            , (MD5(CONCAT(COALESCE(uad.ActivityDimKey, '$$'), COALESCE(uad2.ActivityDimKey, '$$'), COALESCE(uad.EventTimestamp, '$$'), COALESCE(uad2.EventTimeStamp, '$$')))) HashByte
		FROM ActivityEventFact_WRK2 aef
		JOIN UserActivityDim uad 
			ON aef.StartID = uad.ActivityID
			AND uad.IsCurrent = 1
            AND uad.EventType LIKE 'START'
		JOIN UserActivityDim uad2 
			ON aef.NextEventID = uad2.ActivityID
			AND uad.IsCurrent = 1
            AND uad2.EventType LIKE 'END'
		LEFT JOIN UserDim ud
			ON ud.UserID = aef.UserID
            AND ud.IsCurrent = 1
    );


	INSERT INTO DarwinCore.UserActivityFact
		(ActivityStartDimKey,
		ActivityEndDimKey,
		UserDimKey,
		ActivityID,
		UserID,
		ActivityStartTime,
		ActivityEndTime,
		DurationSeconds,
		UpdateTime,
		HashByte)
	SELECT 
		ActivityStartDimKey,
		ActivityEndDimKey,
		UserDimKey,
		ActivityID,
		UserID,
		ActivityStartTime,
		ActivityEndTime,
		DurationSeconds,
		UpdateTime,
		HashByte
	FROM ActivityEventFact_WRK3;

 END$$
 
 DELIMITER ;