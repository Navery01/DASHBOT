USE DashSRC;

DROP TABLE IF EXISTS DiscordEventHolding;
CREATE TABLE DiscordEventHolding
AS (SELECT `DiscordVoiceChannelEvent`.`EventID`,
    `DiscordVoiceChannelEvent`.`EventType`,
    CAST(NULL AS VARCHAR(255)) AS EventDescr,
    CAST(NULL AS VARCHAR(255)) AS EventText,
    `DiscordVoiceChannelEvent`.`FromChannelName`,
    `DiscordVoiceChannelEvent`.`ToChannelName`,
    `DiscordVoiceChannelEvent`.`UserID`,
    `DiscordVoiceChannelEvent`.`GuildID`,
    `DiscordVoiceChannelEvent`.`EventTimestamp`,
    `DiscordVoiceChannelEvent`.`InsertDate`,
    `DiscordVoiceChannelEvent`.`UpdateTime`
FROM `DashSRC`.`DiscordVoiceChannelEvent` 
WHERE 1 <> 1
);