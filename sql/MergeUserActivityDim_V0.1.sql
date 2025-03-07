

USE DarwinCore;

DELIMITER $$

DROP PROCEDURE IF EXISTS Merge_UserActivityDim;
CREATE PROCEDURE Merge_UserActivityDim()
BEGIN

-- dedup
	DROP TABLE IF EXISTS ActivityEvent_WRK1;
	CREATE temporary TABLE ActivityEvent_WRK1 AS(
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
	DELETE FROM ActivityEvent_WRK1 WHERE RN > 1;

	INSERT INTO UserActivityDim
		(ActivityID, EventType, EventCategory, EventText, EventTimestamp, UpdateTime, StartDate, EndDate, IsCurrent, HashByte)
	SELECT
		  EventID
		, EventDescr
		, EventType
		, EventText
		, EventTimestamp
		, UpdateTime
		, CURRENT_TIMESTAMP()
		, '9999-12-31'
		, 1
		, (MD5(CONCAT(COALESCE(EventID, '$$'),COALESCE(EventDescr, '$$'),COALESCE(EventType, '$$'),COALESCE(EventText, '$$'),COALESCE(EventTimestamp, '$$'))))
	FROM ActivityEvent_WRK1;
END$$

DELIMITER ;