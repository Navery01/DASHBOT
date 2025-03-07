
USE DashSRC;
DROP TABLE IF EXISTS DiscordUser;
CREATE TABLE DiscordUser (
	  DiscordUserKey CHAR(32) AS (MD5(CONCAT(UserID, GuildID))) STORED
	, UserID BIGINT NOT NULL
	, GuildID BIGINT
	, UserName VARCHAR(64)
	, DateJoined DATETIME DEFAULT CURRENT_TIMESTAMP()
	, InsertDate DATETIME DEFAULT CURRENT_TIMESTAMP()
	, UpdateTime DATETIME DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP()
);
DROP TABLE IF EXISTS DiscordGuild;
CREATE TABLE DiscordGuild (
	  DiscordGuildKey CHAR(32) AS (MD5(GuildID))
	, GuildID BIGINT NOT NULL
    , GuildName VARCHAR(64)
	, InsertDate DATETIME DEFAULT CURRENT_TIMESTAMP()
	, UpdateTime DATETIME DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP()
);
DROP TABLE IF EXISTS DiscordMessageEvent;
CREATE TABLE DiscordMessageEvent(
	  MessageID BIGINT PRIMARY KEY AUTO_INCREMENT
    , MessageContent VARCHAR(512)
    , ChannelName VARCHAR(64)
    , UserID VARCHAR(64)
    , GuildID BIGINT
    , IsTruncated BIT 
    , IsImage BIT
	, InsertDate DATETIME DEFAULT CURRENT_TIMESTAMP()
	, UpdateTime DATETIME DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP()
);
DROP TABLE IF EXISTS DiscordVoiceChannelEvent;
CREATE TABLE DiscordVoiceChannelEvent (
	  EventID BIGINT PRIMARY KEY AUTO_INCREMENT
	, EventType VARCHAR(32)
    , FromChannelName VARCHAR(64)
    , ToChannelName VARCHAR(64)
    , UserID VARCHAR(64)
    , GuildID BIGINT
    , EventTimestamp DATETIME DEFAULT CURRENT_TIMESTAMP()
	, InsertDate DATETIME DEFAULT CURRENT_TIMESTAMP()
	, UpdateTime DATETIME DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP()
);

DROP TABLE IF EXISTS DiscordActivityEvent;
CREATE TABLE DiscordActivityEvent (
	  EventID BIGINT PRIMARY KEY AUTO_INCREMENT
	, EventType VARCHAR(32)
    , EventDescr VARCHAR(63)
    , EventText VARCHAR(255)
    , UserID VARCHAR(64)
    , GuildID BIGINT
    , EventTimestamp DATETIME DEFAULT CURRENT_TIMESTAMP()
	, InsertDate DATETIME DEFAULT CURRENT_TIMESTAMP()
	, UpdateTime DATETIME DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP()
);

DROP TABLE IF EXISTS DiscordEventHolding;
CREATE TABLE DiscordEventHolding(
	  EventID BIGINT 
	, EventType VARCHAR(32)
	, FromChannelName VARCHAR(64)
    , ToChannelName VARCHAR(64)
    , EventDescr VARCHAR(64)
    , EventText VARCHAR(255)
    , UserID VARCHAR(64)
    , GuildID BIGINT
    , SourceTable VARCHAR(32)
    , EventTimestamp DATETIME DEFAULT CURRENT_TIMESTAMP()
	, InsertDate DATETIME DEFAULT CURRENT_TIMESTAMP()
	, UpdateTime DATETIME DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP()
);



