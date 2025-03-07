
USE DarwinCore;

DELIMITER $$

DROP PROCEDURE IF EXISTS Merge_EventDim;
CREATE PROCEDURE Merge_EventDim()
BEGIN

	DROP TABLE IF EXISTS EventDim_WRK1;
	CREATE TEMPORARY TABLE EventDim_WRK1 AS (
		SELECT DISTINCT 
			  UserID
			, GuildID
			, EventID
            , EventType
            , CASE 				WHEN EventType IN ('JOIN', 'LEAVE') THEN 'VOICE_MOVE'
										WHEN EventType LIKE 'CHANNEL_MOVE' THEN CAST(NULL AS VARCHAR(64))
										WHEN EventType IN ('UNMUTE', 'MUTE') THEN 'VOICE_MUTE'
										WHEN EventType IN ('UNDEAF', 'DEAF') THEN 'VOICE_DEAF'
										WHEN EventType IN ('STREAM', 'UNSTREAM')  THEN 'STREAM'
						END AS EventCategory
			, CAST(NULL AS VARCHAR(63) ) AS EventDescr
            , CAST(NULL AS VARCHAR(63) ) AS EventText
            , FromChannelName
            , ToChannelName
            , EventTimestamp
            , UpdateTime
            , MD5(CONCAT(COALESCE(EventID, '$$'), COALESCE(EventType, '$$'), '$$', '$$', COALESCE(FromChannelName, '$$'), COALESCE(ToChannelName, '$$'))) AS HashByte 
            FROM DashSRC.DiscordVoiceChannelEvent
            UNION
			SELECT DISTINCT 
			  UserID
			, GuildID
			, EventID
            , EventType
            , 'RICH_PRESENCE' AS EventCategory
            , EventDescr
            , EventText
            , CAST(NULL AS VARCHAR(63) ) AS FromChannelName
            , CAST(NULL AS VARCHAR(63) ) AS ToChannelName
            , EventTimestamp
            , UpdateTime
            , MD5(CONCAT(COALESCE(EventID, '$$'), COALESCE(EventType, '$$'), COALESCE(EventDescr, '$$'), COALESCE(EventText, '$$'), '$$', '$$')) AS HashByte 
            FROM DashSRC.DiscordActivityEvent
            );
    
		INSERT INTO DarwinCore.EventDim
			(EventID,
			EventType,
            EventCategory,
			EventDescription,
			EventText,
			FromChannelName,
			ToChannelName,
            EventTimeStamp,
			UpdateTime,
			IsCurrent,
			HashByte)
			SELECT DISTINCT
				  EventID
				, EventType
                , EventCategory
                , EventDescr
                , EventText
                , FromChannelName
                , ToChannelName
                , EventTimeStamp
                , UpdateTime
                , 1 AS IsCurrent
                , Hashbyte
			FROM EventDim_WRK1;
                
                
END$$			

DELIMITER ;

