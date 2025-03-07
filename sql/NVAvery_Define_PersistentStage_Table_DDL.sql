
USE DarwinStaging_Persisted;
DROP TABLE IF EXISTS DiscordUser;
CREATE TABLE DiscordUser (
	  DiscordUserKey CHAR(32)
	, UserID BIGINT NOT NULL
	, GuildID BIGINT
	, UserName VARCHAR(64)
	, DateJoined DATETIME DEFAULT CURRENT_TIMESTAMP()
	, InsertDate DATETIME DEFAULT CURRENT_TIMESTAMP()
	, UpdateTime DATETIME DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP()
    , HashByte CHAR(32) AS (MD5(CONCAT(DiscordUserKey, UserID, GuildID, UserName, DateJoined))) 
);
DROP TABLE IF EXISTS DiscordGuild;
CREATE TABLE DiscordGuild (
	  DiscordGuildKey CHAR(32)
	, GuildID BIGINT NOT NULL
    , GuildName VARCHAR(64)
	, InsertDate DATETIME DEFAULT CURRENT_TIMESTAMP()
	, UpdateTime DATETIME DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP()
    , HashByte CHAR(32) AS (MD5(CONCAT(DiscordGuildKey, GuildID, GuildName))) 
);
DROP TABLE IF EXISTS DiscordMessageEvent;
CREATE TABLE DiscordMessageEvent(
	  MessageID BIGINT
    , MessageContent VARCHAR(512)
    , ChannelName VARCHAR(64)
    , UserID VARCHAR(64)
    , GuildID BIGINT
    , IsTruncated BIT 
    , IsImage BIT
	, InsertDate DATETIME DEFAULT CURRENT_TIMESTAMP()
	, UpdateTime DATETIME DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP()
    , HashByte CHAR(32) AS (MD5(CONCAT(MessageContent, ChannelName, UserID, GuildID, IsTruncated, IsImage))) 
);
DROP TABLE IF EXISTS DiscordVoiceChannelEvent;
CREATE TABLE DiscordVoiceChannelEvent (
	  EventID BIGINT
	, EventType VARCHAR(32)
    , FromChannelName VARCHAR(64)
    , ToChannelName VARCHAR(64)
    , UserID VARCHAR(64)
    , GuildID BIGINT
    , EventTimestamp DATETIME DEFAULT CURRENT_TIMESTAMP()
	, InsertDate DATETIME DEFAULT CURRENT_TIMESTAMP()
	, UpdateTime DATETIME DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP()
<<<<<<< Updated upstream:sql/NVAvery_Define_PersistentStage_Table_DDL.sql
=======
<<<<<<< Updated upstream:NVAvery_Define_Stage_Table_DDL.sql
    , HashByte CHAR(32) AS (MD5(CONCAT(EventID, EventType, FromChannelName, ToChannelName, GuildID, EventTimestamp))) 
=======
>>>>>>> Stashed changes:NVAvery_Define_Stage_Table_DDL.sql
    , HashByte CHAR(32) AS (MD5(CONCAT(EventID, EventType, FromChannelName, ToChannelName, UserID, GuildID, EventTimestamp))) 
);

DROP TABLE IF EXISTS DiscordActivityEvent;
CREATE TABLE DiscordActivityEvent (
	  EventID BIGINT
<<<<<<< Updated upstream:sql/NVAvery_Define_PersistentStage_Table_DDL.sql
	, EventType VARCHAR(32)
    , EventDescr VARCHAR(63)
    , EventText VARCHAR(255)
=======
	, EventType VARCHAR(63)
    , EventDescr VARCHAR(63)
    , EventText VARCHAR(63)
>>>>>>> Stashed changes:NVAvery_Define_Stage_Table_DDL.sql
    , UserID VARCHAR(64)
    , GuildID BIGINT
    , EventTimestamp DATETIME DEFAULT CURRENT_TIMESTAMP()
	, InsertDate DATETIME DEFAULT CURRENT_TIMESTAMP()
	, UpdateTime DATETIME DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP()
    , HashByte CHAR(32) AS (MD5(CONCAT(EventID, EventType, EventDescr, EventText, GuildID, UserID, EventTimestamp))) 
<<<<<<< Updated upstream:sql/NVAvery_Define_PersistentStage_Table_DDL.sql
=======
>>>>>>> Stashed changes:sql/NVAvery_Define_PersistentStage_Table_DDL.sql
>>>>>>> Stashed changes:NVAvery_Define_Stage_Table_DDL.sql
);



