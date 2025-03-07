
USE DarwinCore;

DELIMITER $$

DROP PROCEDURE IF EXISTS Merge_GuildDim;
CREATE PROCEDURE Merge_GuildDim()
BEGIN
	DROP TABLE IF EXISTS GuildDim_WRK1;
	CREATE TEMPORARY TABLE GuildDim_WRK1 AS (SELECT DISTINCT GuildID, GuildName, UpdateTime, MD5(CONCAT(GuildID, GuildName)) AS HashByte FROM DashSRC.DiscordGuild);
    
    DROP TABLE IF EXISTS GuildDim_WRK2;
    CREATE TEMPORARY TABLE GuildDim_WRK2 AS (
		SELECT 
			  s.GuildID
            , s.GuildName
            , s.UpdateTime
            , s.HashByte
            , CASE 	WHEN s.UpdateTime IS NOT NULL AND c.UpdateTime IS NULL THEN 'I'
					WHEN s.UpdateTime IS NOT NULL AND c.UpdateTime IS NOT NULL THEN 'U'
                    WHEN s.UpdateTime IS NULL AND c.UpdateTime IS NOT NULL THEN 'D'
                    WHEN s.UpdateTime IS NULL AND c.UpdateTime IS NULL THEN 'F'
				END AS IDFUFlag
			, CASE 	WHEN s.HashByte = c.HashByte THEN 'U' ELSE 'I'
				END AS HASHFlag
			, c.GuildID AS CR_GuildID
            , c.GuildName AS CR_GuildName
            , c.UpdateTime AS CR_UpdateTime
            , c.HashByte AS CR_HashByte
		FROM GuildDim_WRK1 s 
        LEFT JOIN DarwinCore.GuildDim c
			ON s.GuildID = c.GuildID
        );

	DROP TABLE IF EXISTS GuildDim_WRK3;
	CREATE TEMPORARY TABLE GuildDim_WRK3 AS (
		SELECT 
			  GuildID
			, GuildName
            , UpdateTime
            , HashByte
            , 'I' AS IDFUFlag
            , HASHFlag
		FROM GuildDim_WRK2
        WHERE HASHFlag = 'I'
        AND IDFUFlag IN ('U', 'I')
        UNION
        SELECT
			  CR_GuildID
            , CR_GuildName
            , CR_UpdateTime
            , CR_HashByte
            , IDFUFlag
            , HASHFlag
		FROM GuildDim_WRK2
        WHERE IDFUFlag = 'U'
        AND HASHFlag = 'I'
    );
    DROP TABLE IF EXISTS GuildDim_WRK4;
    CREATE TEMPORARY TABLE GuildDim_WRK4 AS (
    SELECT 
		  GuildID
		, GuildName
        , UpdateTime
        , HashByte
        , IDFUFlag
        , HASHFlag
        , ROW_NUMBER() OVER (PARTITION BY GuildID ORDER BY UpdateTime DESC) AS RecordRank
	FROM GuildDim_WRK3
    );
    
	DROP TABLE IF EXISTS GuildDim_WRK5;
    CREATE TEMPORARY TABLE GuildDim_WRK5 AS (
    SELECT 
		  GuildID
		, GuildName
        , UpdateTime
        , UpdateTime AS StartDate
        , CASE	WHEN RecordRank > 1 THEN DATE_ADD(LEAD(UpdateTime, 1) OVER (PARTITION BY GuildID ORDER BY RecordRank DESC), INTERVAL 1 SECOND) ELSE '9999-12-31' END AS EndDate
        , CASE WHEN RecordRank = 1 THEN 1 ELSE 0 END AS IsCurrent
        , HashByte
        , IDFUFlag
	FROM GuildDim_WRK4
    );
    
-- First, update the existing records
UPDATE DarwinCore.GuildDim TGT
JOIN GuildDim_WRK5 SRC
ON SRC.GuildID = TGT.GuildID AND SRC.UpdateTime = TGT.UpdateTime
SET TGT.IsCurrent = SRC.IsCurrent, TGT.EndDate = SRC.EndDate
WHERE TGT.IsCurrent = SRC.IsCurrent AND SRC.IDFUFlag = 'U';

-- Then, insert new records or update existing ones
INSERT INTO DarwinCore.GuildDim (
    GuildID,
    GuildName,
    UpdateTime,
    StartDate,
    EndDate,
    IsCurrent,
    HashByte
)
SELECT
    SRC.GuildID,
    SRC.GuildName,
    SRC.UpdateTime,
    SRC.StartDate,
    SRC.EndDate,
    SRC.IsCurrent,
    SRC.HashByte
FROM GuildDim_WRK5 SRC
WHERE SRC.IDFUFlag = 'I'
ON DUPLICATE KEY UPDATE
    GuildName = VALUES(GuildName),
    UpdateTime = VALUES(UpdateTime),
    StartDate = VALUES(StartDate),
    EndDate = VALUES(EndDate),
    IsCurrent = VALUES(IsCurrent),
    HashByte = VALUES(HashByte);
END$$

DELIMITER ;