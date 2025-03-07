USE ETL;

DELIMITER $$

DROP PROCEDURE IF EXISTS DarwinCoreProcedureSet;
CREATE PROCEDURE DarwinCoreProcedureSet () 
BEGIN

	CALL `DashSRC`.`Merge_IncompleteEvents`();
    
	CALL `DarwinCore`.`Merge_GuildDim`();
	CALL `DarwinCore`.`Merge_UserDim`();
	CALL `DarwinCore`.`Merge_EventDim`();
    CALL `DarwinCore`.`Merge_ActivityFact`();
	TRUNCATE TABLE `DashSRC`.`DiscordActivityEvent`;
    TRUNCATE TABLE `DashSRC`.`DiscordGuild`;
    TRUNCATE TABLE `DashSRC`.`DiscordMessageEvent`;
    TRUNCATE TABLE `DashSRC`.`DiscordUser`;
    TRUNCATE TABLE `DashSRC`.`DiscordVoiceChannelEvent`;
    
    CALL `DashSRC`.`ReLoad_IncompleteEvents`();


END$$

DELIMITER ;