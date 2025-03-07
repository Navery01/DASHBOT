DELIMITER $$
DROP PROCEDURE IF EXISTS Reload_IncompleteActivityEvents;
CREATE PROCEDURE Reload_IncompleteActivityEvents()
BEGIN

	INSERT INTO DashSRC.DiscordActivityEvent
		(EventID,
		EventType,
		EventDescr,
		EventText,
		UserID,
		EventTimestamp,
		InsertDate,
		UpdateTime)
	SELECT EventID,
		EventType,
		EventDescr,
		EventText,
		UserID,
		EventTimestamp,
		InsertDate,
		UpdateTime
	FROM DashSRC.DiscordActivityHolding;
    
	TRUNCATE TABLE DiscordActivityHolding;

END$$
DELIMITER ;
