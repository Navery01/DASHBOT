USE DashSRC;

DELIMITER $$

DROP PROCEDURE IF EXISTS Merge_IncompleteEvents;
CREATE PROCEDURE Merge_IncompleteEvents ()
BEGIN

	DROP TABLE IF EXISTS CompletedVoiceEvents;
	CREATE TEMPORARY TABLE CompletedVoiceEvents
	AS (
	SELECT DISTINCT
		  EventID
		, EventType
        , FromChannelName
        , ToChannelName
		, CAST(NULL AS VARCHAR(64)) AS EventDescr
		, CAST(NULL AS VARCHAR(64)) AS EventText
		, CASE 				WHEN EventType IN ('JOIN', 'LEAVE') THEN 'VOICE_MOVE'
										WHEN EventType LIKE 'CHANNEL_MOVE' THEN CAST(NULL AS VARCHAR(64))
										WHEN EventType IN ('UNMUTE', 'MUTE') THEN 'VOICE_MUTE'
										WHEN EventType IN ('UNDEAF', 'DEAF') THEN 'VOICE_DEAF'
										WHEN EventType IN ('STREAM', 'UNSTREAM')  THEN 'STREAM'
						END AS EventCategory
		, EventTimestamp
		, dvce.UserID
		, dvce.GuildID
        , dvce.InsertDate
        , dvce.Updatetime
        , 'Voice' AS EventSource
	FROM DiscordVoiceChannelEvent dvce
	LEFT JOIN DiscordUser du
		ON du.UserID = dvce.UserID
	LEFT JOIN DiscordGuild dg
		ON dvce.GuildID = du.GuildID);

	DROP TABLE IF EXISTS CompletedActivityEvents;
	CREATE TEMPORARY TABLE CompletedActivityEvents
	AS (
	SELECT DISTINCT
		  EventID
		, EventType
		, CAST(NULL AS VARCHAR(64)) AS FromChannelName
        , CAST(NULL AS VARCHAR(64)) AS ToChannelName
		, EventDescr
		, EventText
		, 'RichPresence' AS EventCategory
		, EventTimestamp
		, dvce.UserID
		, dvce.GuildID
        , dvce.InsertDate
        , dvce.Updatetime
        , 'Activity' AS EventSource
	FROM DiscordActivityEvent dvce
	LEFT JOIN DiscordUser du
		ON du.UserID = dvce.UserID
	LEFT JOIN DiscordGuild dg
		ON dvce.GuildID = du.GuildID);



	DROP TABLE IF EXISTS AllEvents;
	CREATE TEMPORARY TABLE AllEvents AS (
	WITH CompletedEventCTE AS(
	SELECT * FROM CompletedVoiceEvents
	UNION 
	SELECT * FROM CompletedActivityEvents)
	SELECT 
		 EventID
		, EventType
		, FromChannelName
        , ToChannelName
		, EventDescr
		, EventText
		, UserID
		, EventTimestamp AS EventStartTime
		, GuildID
        , InsertDate
        , Updatetime
        , EventSource
        , LEAD(EventType) OVER (PARTITION BY UserID, EventCategory ORDER BY EventTimeStamp ASC) AS EventEndType
		, LEAD(EventTimestamp) OVER (PARTITION BY UserID, EventCategory ORDER BY EventTimeStamp ASC) AS EventEndTime
	FROM CompletedEventCTE ve
	);
 
	INSERT INTO DashSRC.DiscordEventHolding
	(EventID,
	EventType,
	FromChannelName,
	ToChannelName,
	EventDescr,
	EventText,
	UserID,
	GuildID,
    SourceTable,
	EventTimestamp,
	InsertDate,
	UpdateTime)
SELECT 
	  EventID
	, EventType
	, FromChannelName
	, ToChannelName
	, EventDescr
	, EventText
	, UserID
	, GuildID
    , EventSource
	, EventStartTime
	, InsertDate
	, Updatetime
    FROM AllEvents 
WHERE EventType IN ('JOIN', 'MUTE', 'DEAF', 'STREAM')
		AND EventEndTime IS NULL;
        
        
DELETE FROM DiscordVoiceChannelEvent
WHERE CONCAT(EventID, UpdateTime) IN 
(SELECT CONCAT(EventID, UpdateTime)
FROM AllEvents
WHERE EventSource = 'Voice'
AND EventType IN ('JOIN', 'MUTE', 'DEAF', 'STREAM')
	AND EventEndTime IS NULL);
    
DELETE FROM DiscordActivityEvent
WHERE CONCAT(EventID, UpdateTime) IN 
(SELECT CONCAT(EventID, UpdateTime)
FROM AllEvents
WHERE EventSource = 'Activity'
AND EventType IN ('JOIN', 'MUTE', 'DEAF', 'STREAM')
	AND EventEndTime IS NULL);
    
END$$



DELIMITER ;









