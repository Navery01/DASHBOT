USE ETL;

DELIMITER $$

DROP PROCEDURE IF EXISTS DarwinETLMaster;
CREATE PROCEDURE DarwinETLMaster () 
BEGIN
		CALL `ETL`.`DarwinStagingProcedureSet`();
		CALL `ETL`.`DarwinCoreProcedureSet`();
		CALL `ETL`.`InsertCoreErrorLog`('DarwinETLMaster', 'ETL', 'CALL EVENT', 'N/A', 0.0);
	
END$$

DELIMITER ;

