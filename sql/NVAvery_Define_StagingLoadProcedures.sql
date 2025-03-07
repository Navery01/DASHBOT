USE DarwinStaging_Persisted

DELIMITER $$

DROP PROCEDURE IF EXISTS Merge_DiscordGuild;
CREATE PROCEDURE Merge_DiscordGuild()
BEGIN
    INSERT INTO DiscordGuild (DiscordGuildKey, GuildID, GuildName, InsertDate, UpdateTime) 
    SELECT DiscordGuildKey, GuildID, GuildName, InsertDate, UpdateTime 
    FROM DashSRC.DiscordGuild;

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS Merge_DiscordMessageEvent;
CREATE PROCEDURE Merge_DiscordMessageEvent()
BEGIN
    INSERT INTO DiscordMessageEvent (MessageID, MessageContent, ChannelName, UserID, GuildID, IsTruncated, IsImage, InsertDate, UpdateTime) 
    SELECT MessageID, MessageContent, ChannelName, UserID, GuildID, IsTruncated, IsImage, InsertDate, UpdateTime
    FROM DashSRC.DiscordMessageEvent;
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS Merge_DiscordUser;
CREATE PROCEDURE Merge_DiscordUser()
BEGIN
    INSERT INTO DiscordUser (DiscordUserKey, UserID, GuildID, UserName, DateJoined, InsertDate, UpdateTime) 
    SELECT DiscordUserKey, UserID, GuildID, UserName, DateJoined, InsertDate, UpdateTime
    FROM DashSRC.DiscordUser;
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS Merge_DiscordVoiceChannelEvent;
CREATE PROCEDURE Merge_DiscordVoiceChannelEvent()
BEGIN
    INSERT INTO DiscordVoiceChannelEvent (EventID, EventType, FromChannelName, ToChannelName, UserID, GuildID, EventTimestamp, InsertDate, UpdateTime) 
    SELECT EventID, EventType, FromChannelName, ToChannelName, UserID, GuildID, EventTimestamp, InsertDate, UpdateTime
    FROM DashSRC.DiscordVoiceChannelEvent;
    
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS Merge_DiscordActivityEvent;
CREATE PROCEDURE Merge_DiscordActivityEvent()
BEGIN
    INSERT INTO DiscordActivityEvent (EventID, EventType, EventDescr, EventText, UserID, GuildID, EventTimestamp, InsertDate, UpdateTime) 
    SELECT EventID, EventType, EventDescr, EventText, UserID, GuildID, EventTimestamp, InsertDate, UpdateTime
    FROM DashSRC.DiscordActivityEvent;
    
END $$

DELIMITER ;

