USE DarwinCore;

DELIMITER $$

DROP PROCEDURE IF EXISTS Merge_ActivityFact;
CREATE PROCEDURE Merge_ActivityFact ()
BEGIN
		
        DROP TABLE IF EXISTS ActivityFact_Staging;
		CREATE TEMPORARY TABLE ActivityFact_Staging AS (
		SELECT DISTINCT 
			  EventID
			, UserID
			, GuildID
            , UpdateTime
            FROM DashSRC.DiscordVoiceChannelEvent);
           
           DROP TABLE IF EXISTS ActivityFact_FactStage;
           CREATE TEMPORARY TABLE ActivityFact_FactStage AS(
			SELECT
				  ed.EventDimKey AS EventStartDimKey
                , LEAD(ed.EventDimKey) OVER (PARTITION BY afs.UserID, afs.GuildID, ed.EventCategory ORDER BY ed.EventTimeStamp ASC) AS EventEndDimKey
                , ud.UserDimKey
                , gd.GuildDimKey
				, afs.EventID
                , afs.UserID
                , afs.GuildID
                , ed.EventTimeStamp AS EventStartTime
                , LEAD(ed.EventTimeStamp) OVER (PARTITION BY afs.UserID, afs.GuildID, ed.EventCategory ORDER BY ed.EventTimeStamp ASC) AS EventEndTime
                , afs.UpdateTime
			FROM ActivityFact_Staging afs
            JOIN EventDim ed
				ON ed.EventID = afs.EventID AND ed.UpdateTime = afs.UpdateTime
			JOIN UserDim ud
				ON ud.UserID = afs.UserID AND ud.IsCurrent = 1
			JOIN GuildDim gd
				ON gd.GuildID = afs.GuildID AND gd.IsCurrent = 1
           );
           
           INSERT INTO ActivityFact (EventStartDimKey
                , EventEndDimKey
                , UserDimKey
                , GuildDimKey
				, EventID
                , UserID
                , GuildID
                , EventStartTime
                , EventEndTime
                , DurationSeconds
                , UpdateTime
                , HashByte)
			SELECT
				  afs.EventStartDimKey
                , afs.EventEndDimKey
                , afs.UserDimKey
                , afs.GuildDimKey
				, afs.EventID
                , afs.UserID
                , afs.GuildID
                , afs.EventStartTime
                , afs.EventEndTime
                , TIMESTAMPDIFF(SECOND, afs.EventStartTime, afs.EventEndTime)
                , afs.UpdateTime
                , (MD5(CONCAT(COALESCE(afs.EventStartDimKey, '$$'), COALESCE(afs.EventEndDimKey, '$$'), COALESCE(afs.UserDimKey, '$$'), COALESCE(afs.GuildDimKey, '$$')))) AS HashByte
			FROM ActivityFact_FactStage afs
            JOIN EventDim ed
				ON afs.EventStartDimKey = ed.EventDimKey
                AND ed.EventType IN ('JOIN', 'STREAM', 'MUTE', 'DEAF')
			JOIN EventDim ed2 
				ON afs.EventEndDimKey = ed2.EventDimKey
 				AND ed2.EventType IN ('LEAVE', 'UNSTREAM', 'UNMUTE', 'UNDEAF'); 

END$$

DELIMITER ;