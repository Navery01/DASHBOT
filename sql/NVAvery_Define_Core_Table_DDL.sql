CREATE DATABASE IF NOT EXISTS DarwinCore;
USE DarwinCore;

-- Dimension Tables
DROP TABLE IF EXISTS UserDim;
CREATE TABLE UserDim (
	UserDimKey BIGINT PRIMARY KEY AUTO_INCREMENT,
    UserID BIGINT,
    UserName VARCHAR(64) NOT NULL,
    RetentionPeriod SMALLINT,
    UpdateTime DATETIME,
    StartDate DATETIME DEFAULT CURRENT_TIMESTAMP(),
    EndDate DATETIME DEFAULT '9999-12-31',
    IsCurrent BOOLEAN DEFAULT TRUE,
    HashByte CHAR(32)
);
DROP TABLE IF EXISTS GuildDim;
CREATE TABLE GuildDim (
	GuildDimKey BIGINT PRIMARY KEY AUTO_INCREMENT,


    RetentionPeriod SMALLINT,
    UpdateTime DATETIME,
    StartDate DATETIME DEFAULT CURRENT_TIMESTAMP(),
    EndDate DATETIME DEFAULT '9999-12-31',
    IsCurrent BOOLEAN DEFAULT TRUE,
    HashByte CHAR(32)
);
DROP TABLE IF EXISTS EventDim;
CREATE TABLE EventDim (
	EventDimKey BIGINT PRIMARY KEY AUTO_INCREMENT,
    EventID BIGINT,
<<<<<<< Updated upstream
    EventType VARCHAR(32),
=======
    EventType VARCHAR(255),
>>>>>>> Stashed changes
    EventCategory VARCHAR(32),
    EventDescription VARCHAR(64),
    EventText VARCHAR(64),
    FromChannelName VARCHAR(64),
    ToChannelName VARCHAR(64),
    EventTimeStamp DATETIME,
    RetentionPeriod SMALLINT,
    UpdateTime DATETIME,
    StartDate DATETIME DEFAULT CURRENT_TIMESTAMP(),
    EndDate DATETIME DEFAULT '9999-12-31',
    IsCurrent BOOLEAN DEFAULT TRUE,
    HashByte CHAR(32)
);
<<<<<<< Updated upstream
=======

DROP TABLE IF EXISTS UserActivityDim;
CREATE TABLE UserActivityDim (
	ActivityDimKey BIGINT PRIMARY KEY AUTO_INCREMENT,
    ActivityID BIGINT,
    EventType VARCHAR(255),
    EventCategory VARCHAR(32),
    EventText VARCHAR(64),
    EventTimeStamp DATETIME,
    RetentionPeriod SMALLINT,
    UpdateTime DATETIME,
    StartDate DATETIME DEFAULT CURRENT_TIMESTAMP(),
    EndDate DATETIME DEFAULT '9999-12-31',
    IsCurrent BOOLEAN DEFAULT TRUE,
    HashByte CHAR(32)
);

>>>>>>> Stashed changes
DROP TABLE IF EXISTS ChatEventDim;
CREATE TABLE ChatEventDim (
	MessageDimKey BIGINT PRIMARY KEY AUTO_INCREMENT,
    MessageID BIGINT ,
    ChannelName VARCHAR(64),
    RetentionPeriod SMALLINT,
    UpdateTime DATETIME,
    StartDate DATETIME DEFAULT CURRENT_TIMESTAMP(),
    EndDate DATETIME DEFAULT '9999-12-31',
    IsCurrent BOOLEAN DEFAULT TRUE,
    HashByte CHAR(32)
);

-- Fact Tables
DROP TABLE IF EXISTS ActivityFact;
CREATE TABLE ActivityFact (
	ActivityFactKey BIGINT PRIMARY KEY AUTO_INCREMENT,
    EventStartDimKey BIGINT,
    EventEndDimKey BIGINT,
    UserDimKey BIGINT,
    GuildDimKey BIGINT,
    EventID BIGINT,
    UserID BIGINT,
    GuildID BIGINT,
    EventStartTime DATETIME,
    EventEndTime DATETIME,
    DurationSeconds INT,
    RetentionPeriod SMALLINT,
    UpdateTime DATETIME,
    HashByte CHAR(32),
    FOREIGN KEY (EventStartDimKey) REFERENCES EventDim(EventDimKey),
    FOREIGN KEY (EventEndDimKey) REFERENCES EventDim(EventDimKey),
    FOREIGN KEY (UserDimKey) REFERENCES UserDim(UserDimKey),
    FOREIGN KEY (GuildDimKey) REFERENCES GuildDim(GuildDimKey)
<<<<<<< Updated upstream
    
=======
);

DROP TABLE IF EXISTS UserActivityFact;
CREATE TABLE UserActivityFact (
	ActivityFactKey BIGINT PRIMARY KEY AUTO_INCREMENT,
    ActivityStartDimKey BIGINT,
    ActivityEndDimKey BIGINT,
    UserDimKey BIGINT,
    ActivityID BIGINT,
    UserID BIGINT,
    ActivityStartTime DATETIME,
    ActivityEndTime DATETIME,
    DurationSeconds INT,
    RetentionPeriod SMALLINT,
    UpdateTime DATETIME,
    HashByte CHAR(32),
    FOREIGN KEY (ActivityStartDimKey) REFERENCES UserActivityDim(ActivityDimKey),
    FOREIGN KEY (ActivityEndDimKey) REFERENCES UserActivityDim(ActivityDimKey),
    FOREIGN KEY (UserDimKey) REFERENCES UserDim(UserDimKey)
>>>>>>> Stashed changes
);
DROP TABLE IF EXISTS ChatActivityFact;
CREATE TABLE ChatActivityFact (
    MessageID BIGINT,
    UserID BIGINT,
    GuildID BIGINT,
    MessageTimestamp DATETIME DEFAULT CURRENT_TIMESTAMP(),
    CharacterCount INT,
	RetentionPeriod SMALLINT,
    UpdateTime DATETIME,
    HashByte CHAR(32)

);