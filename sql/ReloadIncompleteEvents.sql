USE DashSRC;

DELIMITER $$

DROP PROCEDURE IF EXISTS ReLoad_IncompleteEvents;
CREATE PROCEDURE ReLoad_IncompleteEvents () 
BEGIN
<<<<<<< Updated upstream

	INSERT INTO DashSRC.DiscordActivityEvent
		(EventID,
		EventType,
		EventDescr,
		EventText,
		UserID,
		GuildID,
		EventTimestamp,
		InsertDate,
		UpdateTime)
	SELECT EventID,
		EventType,
		EventDescr,
		EventText,
		UserID,
		GuildID,
		EventTimestamp,
		InsertDate,
		UpdateTime
	FROM DashSRC.DiscordEventHolding
    WHERE SourceTable LIKE 'Activity';
=======
>>>>>>> Stashed changes
    
	INSERT INTO DashSRC.DiscordVoiceChannelEvent
		(EventID,
		EventType,
		FromChannelName,
		ToChannelName,
		UserID,
		GuildID,
		EventTimestamp,
		InsertDate,
		UpdateTime)
	SELECT EventID,
		EventType,
		FromChannelName,
		ToChannelName,
		UserID,
		GuildID,
		EventTimestamp,
		InsertDate,
		UpdateTime
	FROM DashSRC.DiscordEventHolding
    WHERE SourceTable LIKE 'Voice';


	TRUNCATE TABLE DiscordEventHolding;

END$$

DELIMITER ;