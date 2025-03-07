USE DashSRC;
DELIMITER $$

DROP PROCEDURE IF EXISTS Merge_IncompleteActivityEvents;
CREATE PROCEDURE Merge_IncompleteActivityEvents()
BEGIN
-- DEDUP
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

-- Deduplicate then load the stage table with clean data
	TRUNCATE TABLE DashSRC.DiscordActivityEvent;
    
    INSERT INTO DashSRC.DiscordActivityEvent (EventID, EventType, EventDescr, EventText, UserID, EventTimestamp, InsertDate, UpdateTime)
    SELECT EventID
			, EventType
			, EventDescr
			, EventText
			, UserID
			, EventTimestamp
			, InsertDate
			, UpdateTime
		FROM ActivityEvent_WRK1;

DROP TABLE IF EXISTS ActivityEvent_WRK2;
CREATE temporary TABLE ActivityEvent_WRK2 AS(
SELECT 
	e.EventID StartID
    , e.EventType StartType
    , e.EventDescr StartDes
    , e.EventText StartTxt
	, LEAD(e.EventDescr) OVER (PARTITION BY UserID, EventType, EventText ORDER BY EventTimestamp) NextEventDes
	, LEAD(e.EventText) OVER (PARTITION BY UserID, EventType, EventText ORDER BY EventTimestamp) NextEvent
    , e.EventTimestamp StartTime
    , LEAD(e.EventTimestamp) OVER (PARTITION BY UserID, EventType, EventText ORDER BY EventTimestamp) EndTime
FROM ActivityEvent_WRK1 e
);

INSERT INTO DiscordActivityHolding
( EventID, EventType, EventDescr, EventText, UserID, EventTimestamp, InsertDate, UpdateTime)
SELECT 
	EventID
    , EventType
    , EventDescr
    , EventText
    , UserID
    , EventTimestamp
    , InsertDate
    , UpdateTime
FROM ActivityEvent_WRK1
WHERE EventID NOT IN (SELECT StartID FROM ActivityEvent_WRK2 
WHERE StartDes = 'START' 
AND NextEventDes = 'END')
AND EventDescr LIKE 'START';
END$$

DELIMITER ;

    
    