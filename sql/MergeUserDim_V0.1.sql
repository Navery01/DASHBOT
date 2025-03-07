
USE DarwinCore;

DELIMITER $$

DROP PROCEDURE IF EXISTS Merge_UserDim;
CREATE PROCEDURE Merge_UserDim()
BEGIN
	DROP TABLE IF EXISTS UserDim_WRK1;
	CREATE TEMPORARY TABLE UserDim_WRK1 AS (SELECT DISTINCT UserID, UserName, UpdateTime, MD5(CONCAT(COALESCE(UserID, '$$'), COALESCE(UserName, '$$'))) AS HashByte FROM DashSRC.DiscordUser);
    
    DROP TABLE IF EXISTS UserDim_WRK2;
    CREATE TEMPORARY TABLE UserDim_WRK2 AS (
		SELECT 
			  s.UserID
            , s.UserName
            , s.UpdateTime
            , s.HashByte
            , CASE 	WHEN s.UpdateTime IS NOT NULL AND c.UpdateTime IS NULL THEN 'I'
					WHEN s.UpdateTime IS NOT NULL AND c.UpdateTime IS NOT NULL THEN 'U'
                    WHEN s.UpdateTime IS NULL AND c.UpdateTime IS NOT NULL THEN 'D'
                    WHEN s.UpdateTime IS NULL AND c.UpdateTime IS NULL THEN 'F'
				END AS IDFUFlag
			, CASE 	WHEN s.HashByte = c.HashByte THEN 'U' ELSE 'I'
				END AS HASHFlag
			, c.UserID AS CR_UserID
            , c.UserName AS CR_UserName
            , c.UpdateTime AS CR_UpdateTime
            , c.HashByte AS CR_HashByte
		FROM UserDim_WRK1 s 
        LEFT JOIN DarwinCore.UserDim c
			ON s.UserID = c.UserID
        );
        
	DROP TABLE IF EXISTS UserDim_WRK3;
	CREATE TEMPORARY TABLE UserDim_WRK3 AS (
		SELECT 
			  UserID
			, UserName
            , UpdateTime
            , HashByte
            , 'I' AS IDFUFlag
            , HASHFlag
		FROM UserDim_WRK2
        WHERE HASHFlag = 'I'
        AND IDFUFlag IN ('U', 'I')
        UNION
        SELECT
			  CR_UserID
            , CR_UserName
            , CR_UpdateTime
            , CR_HashByte
            , IDFUFlag
            , HASHFlag
		FROM UserDim_WRK2
        WHERE IDFUFlag = 'U'
        AND HASHFlag = 'I'
    );
	
    DROP TABLE IF EXISTS UserDim_WRK4;
    CREATE TEMPORARY TABLE UserDim_WRK4 AS (
    SELECT 
		  UserID
		, UserName
        , UpdateTime
        , HashByte
        , IDFUFlag
        , HASHFlag
        , ROW_NUMBER() OVER (PARTITION BY UserID ORDER BY UpdateTime DESC) AS RecordRank
	FROM UserDim_WRK3
    );
    
	DROP TABLE IF EXISTS UserDim_WRK5;
    CREATE TEMPORARY TABLE UserDim_WRK5 AS (
    SELECT 
		  UserID
		, UserName
        , UpdateTime
        , UpdateTime AS StartDate
        , CASE	WHEN RecordRank > 1 THEN DATE_ADD(LEAD(UpdateTime, 1) OVER (PARTITION BY UserID ORDER BY RecordRank DESC), INTERVAL 1 SECOND) ELSE '9999-12-31' END AS EndDate
        , CASE WHEN RecordRank = 1 THEN 1 ELSE 0 END AS IsCurrent
        , HashByte
        , IDFUFlag
	FROM UserDim_WRK4
    );
    

UPDATE DarwinCore.UserDim TGT
JOIN UserDim_WRK5 SRC
ON SRC.UserID = TGT.UserID AND SRC.UpdateTime = TGT.UpdateTime
SET TGT.IsCurrent = SRC.IsCurrent, TGT.EndDate = SRC.EndDate
WHERE TGT.IsCurrent = SRC.IsCurrent AND SRC.IDFUFlag = 'U';


INSERT INTO DarwinCore.UserDim (
    UserID,
    UserName,
    UpdateTime,
    StartDate,
    EndDate,
    IsCurrent,
    HashByte
)
SELECT
    SRC.UserID,
    SRC.UserName,
    SRC.UpdateTime,
    SRC.StartDate,
    SRC.EndDate,
    SRC.IsCurrent,
    SRC.HashByte
FROM UserDim_WRK5 SRC
WHERE SRC.IDFUFlag = 'I'
ON DUPLICATE KEY UPDATE
    UserName = VALUES(UserName),
    UpdateTime = VALUES(UpdateTime),
    StartDate = VALUES(StartDate),
    EndDate = VALUES(EndDate),
    IsCurrent = VALUES(IsCurrent),
    HashByte = VALUES(HashByte);
END$$

DELIMITER ;