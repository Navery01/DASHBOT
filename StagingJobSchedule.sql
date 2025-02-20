SET GLOBAL event_scheduler=ON;

USE DarwinStaging;
DROP EVENT IF EXISTS DarwinStaging;
CREATE EVENT DarwinStaging
  ON SCHEDULE
    EVERY 1 DAY
    STARTS ('2025-02-19 23:59:00')
  DO
    CALL Merge_DiscordGuild();
    CALL Merge_DiscordMessageEvent();
    CALL Merge_DiscordUser();
    CALL Merge_DiscordVoiceChannelEvent();
    INSERT INTO mydb1.StageLog(date) VALUES(CURRENT_TIMESTAMP());