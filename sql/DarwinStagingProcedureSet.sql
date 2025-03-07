USE ETL;

DELIMITER $$

DROP PROCEDURE IF EXISTS DarwinStagingProcedureSet;
CREATE PROCEDURE DarwinStagingProcedureSet () 
BEGIN

CALL `DarwinStaging_Persisted`.`Merge_DiscordActivityEvent`();
CALL `DarwinStaging_Persisted`.`Merge_DiscordGuild`();
CALL `DarwinStaging_Persisted`.`Merge_DiscordMessageEvent`();
CALL `DarwinStaging_Persisted`.`Merge_DiscordUser`();
CALL `DarwinStaging_Persisted`.`Merge_DiscordVoiceChannelEvent`();

END$$

DELIMITER ;