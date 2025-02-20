USE DarwinStaging

DELIMITER $$

DROP PROCEDURE IF EXISTS Merge_DiscordGuild;
CREATE PROCEDURE Merge_DiscordGuild()
BEGIN
    TRUNCATE TABLE DiscordGuild;
    
    INSERT INTO DiscordGuild (DiscordGuildKey, GuildID, GuildName, InsertDate, UpdateTime) 
    SELECT DiscordGuildKey, GuildID, GuildName, InsertDate, UpdateTime 
    FROM DashSRC.DiscordGuild
    WHERE UpdateTime > (SELECT MAX(UpdateTime) FROM DiscordGuild);
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS Merge_DiscordMessageEvent;
CREATE PROCEDURE Merge_DiscordMessageEvent()
BEGIN
    TRUNCATE TABLE DiscordMessageEvent;
    
    INSERT INTO DiscordMessageEvent (MessageID, MessageContent, ChannelName, UserID, GuildID, IsTruncated, IsImage, InsertDate, UpdateTime) 
    SELECT MessageID, MessageContent, ChannelName, UserID, GuildID, IsTruncated, IsImage, InsertDate, UpdateTime
    FROM DashSRC.DiscordMessageEvent
    WHERE UpdateTime > (SELECT MAX(UpdateTime) FROM DiscordMessageEvent);
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS Merge_DiscordUser;
CREATE PROCEDURE Merge_DiscordUser()
BEGIN
    TRUNCATE TABLE DiscordUser;
    
    INSERT INTO DiscordUser (DiscordUserKey, UserID, GuildID, UserName, DateJoined, InsertDate, UpdateTime) 
    SELECT DiscordUserKey, UserID, GuildID, UserName, DateJoined, InsertDate, UpdateTime
    FROM DashSRC.DiscordUser
    WHERE UpdateTime > (SELECT MAX(UpdateTime) FROM DiscordUser);
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS Merge_DiscordVoiceChannelEvent;
CREATE PROCEDURE Merge_DiscordVoiceChannelEvent()
BEGIN
    TRUNCATE TABLE DiscordVoiceChannelEvent;
    
    INSERT INTO DiscordVoiceChannelEvent (EventID, EventType, FromChannelName, ToChannelName, UserID, GuildID, EventTimestamp, InsertDate, UpdateTime) 
    SELECT EventID, EventType, FromChannelName, ToChannelName, UserID, GuildID, EventTimestamp, InsertDate, UpdateTime
    FROM DashSRC.DiscordVoiceChannelEvent
    WHERE UpdateTime > (SELECT MAX(UpdateTime) FROM DiscordVoiceChannelEvent);
END $$

DELIMITER ;

