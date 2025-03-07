CREATE SCHEMA IF NOT EXISTS ETL;
USE ETL;

CREATE TABLE LogCore(
LogID BIGINT PRIMARY KEY AUTO_INCREMENT,
ProcedureName VARCHAR(63),
ProcedureSchema VARCHAR(63),
Action VARCHAR(255),
Message VARCHAR(255),
Duration FLOAT,
ErrorTimeStamp DATETIME DEFAULT CURRENT_TIMESTAMP()
);

DELIMITER $$

CREATE PROCEDURE InsertCoreErrorLog(
ProcedureName VARCHAR(63),
ProcedureSchema VARCHAR(63),
Action VARCHAR(255),
Message VARCHAR(255),
Duration FLOAT
)
BEGIN
	INSERT INTO LogCore (ProcedureName, ProcedureSchema, Action, Message, Duration) VALUES (ProcedureName, ProcedureSchema, Action, Message, Duration);
END$$

DELIMITER ;
