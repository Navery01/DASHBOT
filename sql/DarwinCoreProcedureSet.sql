USE ETL;

DELIMITER $$

DROP PROCEDURE IF EXISTS DarwinCoreProcedureSet;
CREATE PROCEDURE DarwinCoreProcedureSet () 
BEGIN

	CALL `DashSRC`.`Merge_IncompleteEvents`();
<<<<<<< Updated upstream
    
	CALL `DarwinCore`.`Merge_GuildDim`();
	CALL `DarwinCore`.`Merge_UserDim`();
	CALL `DarwinCore`.`Merge_EventDim`();
    CALL `DarwinCore`.`Merge_ActivityFact`();
=======
    CALL `DashSRC`.`Merge_IncompleteActivityEvents`();

	CALL `DarwinCore`.`Merge_GuildDim`();
	CALL `DarwinCore`.`Merge_UserDim`();
	CALL `DarwinCore`.`Merge_EventDim`();
	CALL `DarwinCore`.`Merge_UserActivityDim`();
    CALL `DarwinCore`.`Merge_ActivityFact`();
    CALL DarwinCore.Merge_UserActivityFact();


>>>>>>> Stashed changes
	TRUNCATE TABLE `DashSRC`.`DiscordActivityEvent`;
    TRUNCATE TABLE `DashSRC`.`DiscordGuild`;
    TRUNCATE TABLE `DashSRC`.`DiscordMessageEvent`;
    TRUNCATE TABLE `DashSRC`.`DiscordUser`;
    TRUNCATE TABLE `DashSRC`.`DiscordVoiceChannelEvent`;
    
    CALL `DashSRC`.`ReLoad_IncompleteEvents`();
<<<<<<< Updated upstream
=======
	CALL `DashSRC`.`Reload_IncompleteActivityEvents`();
>>>>>>> Stashed changes


END$$

DELIMITER ;