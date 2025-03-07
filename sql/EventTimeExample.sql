USE DashSRC;


WITH VoiceEvents AS(
SELECT DISTINCT
	  EventID
	, EventType
    , EventTimestamp
    , UserName
FROM DiscordVoiceChannelEvent dvce
LEFT JOIN DiscordUser du
	ON du.UserID = dvce.UserID
LEFT JOIN DiscordGuild dg
	ON dvce.GuildID = du.GuildID
WHERE dg.GuildName LIKE 'Dynasty 8 Executive'
AND EventType LIKE 'JOIN' OR EventType LIKE 'LEAVE'
ORDER BY dvce.UserID, dvce.EventTimestamp DESC)
SELECT 
	ve.UserName
    , EventTimeStamp
    , LEAD(EventTimestamp) OVER (PARTITION BY UserName ORDER BY EventTimeStamp) AS LeaveTime 
    , timestampdiff(SECOND, EventTimeStamp, LEAD(EventTimestamp) OVER (PARTITION BY UserName ORDER BY EventTimeStamp)) Diff
FROM VoiceEvents ve

