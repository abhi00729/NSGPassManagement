
IF NOT EXISTS(SELECT 1 FROM sys.databases (NOLOCK) WHERE name = 'NSGPassManagement')
BEGIN
	CREATE DATABASE NSGPassManagement
END
GO

USE NSGPassManagement
GO

IF NOT EXISTS(SELECT 1 FROM sys.tables (NOLOCK) WHERE name = 'CoreUser')
BEGIN
	CREATE TABLE dbo.CoreUser
	(
		CoreUserID INT IDENTITY NOT NULL PRIMARY KEY CLUSTERED,
		UserName VARCHAR(100) NOT NULL,
		UserPassword VARCHAR(100) NOT NULL,
		EmployeeID VARCHAR(100) NULL,
		FirstName VARCHAR(250) NULL,
		LastName VARCHAR(250) NULL,
		IsActive BIT NOT NULL CONSTRAINT DF_CoreUser_IsActive DEFAULT(1),
		EntryUserID INT NOT NULL,
		EntryDate DATETIME NOT NULL CONSTRAINT DF_CoreUser_EntryDate DEFAULT(GETDATE()),
		UpdateUserID INT NULL,
		UpdateDate DATETIME NULL
	)
END


IF NOT EXISTS(SELECT 1 FROM sys.tables (NOLOCK) WHERE name = 'CoreIdentityType')
BEGIN
	CREATE TABLE dbo.CoreIdentityType
	(
		IdentityTypeID INT IDENTITY NOT NULL PRIMARY KEY CLUSTERED,
		IdentityType VARCHAR(250) NOT NULL,
		IsActive BIT NOT NULL CONSTRAINT DF_IdentityType_IsActive DEFAULT(1),
		EntryUserID INT NOT NULL CONSTRAINT FK_IdentityType_EntryUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		EntryDate DATETIME NOT NULL CONSTRAINT DF_IdentityType_EntryDate DEFAULT(GETDATE()),
		UpdateUserID INT NULL CONSTRAINT FK_IdentityType_UpdateUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		UpdateDate DATETIME NULL
	)
END


IF NOT EXISTS(SELECT NAME FROM sys.tables WHERE name = 'CoreState')
BEGIN
	CREATE TABLE dbo.CoreState
	(
		StateID INT IDENTITY(1,1) PRIMARY KEY,
		StateName NVARCHAR(100),
		EntryUserID INT NOT NULL CONSTRAINT FK_CoreState_EntryUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		EntryDate DATETIME NOT NULL CONSTRAINT DF_CoreState_EntryDate DEFAULT(GETDATE()),
		UpdateUserID INT NULL CONSTRAINT FK_CoreState_UpdateUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		UpdateDate DATETIME NULL
	)
END


IF NOT EXISTS(SELECT NAME FROM sys.tables WHERE name = 'CoreCity')
BEGIN
	CREATE TABLE dbo.CoreCity
	(
		CityID BIGINT IDENTITY(1,1) PRIMARY KEY,
		StateID INT NOT NULL CONSTRAINT FK_CoreCity_StateID_CoreState_StateID FOREIGN KEY REFERENCES dbo.CoreState(StateID),
		CityName NVARCHAR(100),
		EntryUserID INT NOT NULL CONSTRAINT FK_CoreCity_EntryUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		EntryDate DATETIME NOT NULL CONSTRAINT DF_CoreCity_EntryDate DEFAULT(GETDATE()),
		UpdateUserID INT NULL CONSTRAINT FK_CoreCity_UpdateUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		UpdateDate DATETIME NULL
	)
END


IF NOT EXISTS(SELECT NAME FROM sys.tables WHERE name ='CoreRelationship')
BEGIN
	CREATE TABLE dbo.CoreRelationship
	(
		RelationshipID INT IDENTITY NOT NULL PRIMARY KEY,
		Relationship VARCHAR(100),
		EntryUserID INT NOT NULL CONSTRAINT FK_CoreRelationship_EntryUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		EntryDate DATETIME NOT NULL CONSTRAINT DF_CoreRelationship_EntryDate DEFAULT(GETDATE()),
		UpdateUserID INT NULL CONSTRAINT FK_CoreRelationship_UpdateUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		UpdateDate DATETIME NULL
	)
END


IF NOT EXISTS(SELECT NAME FROM sys.tables WHERE name = 'CoreRank')
BEGIN
	CREATE TABLE dbo.CoreRank
	(
		RankID INT IDENTITY NOT NULL PRIMARY KEY,
		RankName VARCHAR(100),
		IsActive BIT NOT NULL CONSTRAINT DF_CoreRank_IsActive DEFAULT(1),
		EntryUserID INT NOT NULL CONSTRAINT FK_CoreRank_EntryUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		EntryDate DATETIME NOT NULL CONSTRAINT DF_CoreRank_EntryDate DEFAULT(GETDATE()),
		UpdateUserID INT NULL CONSTRAINT FK_CoreRank_UpdateUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		UpdateDate DATETIME NULL
	)
END


IF NOT EXISTS(SELECT NAME FROM sys.tables WHERE name = 'CoreUnit')
BEGIN
	CREATE TABLE dbo.CoreUnit
	(
		UnitID INT IDENTITY NOT NULL PRIMARY KEY,
		UnitName VARCHAR(100),
		IsActive BIT NOT NULL CONSTRAINT DF_CoreUnit_IsActive DEFAULT(1),
		EntryUserID INT NOT NULL CONSTRAINT FK_CoreUnit_EntryUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		EntryDate DATETIME NOT NULL CONSTRAINT DF_CoreUnit_EntryDate DEFAULT(GETDATE()),
		UpdateUserID INT NULL CONSTRAINT FK_CoreUnit_UpdateUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		UpdateDate DATETIME NULL
	)
END


IF NOT EXISTS(SELECT NAME FROM sys.tables WHERE name = 'CorePassType')
BEGIN
	CREATE TABLE dbo.CorePassType
	(
		PassTypeID INT IDENTITY NOT NULL PRIMARY KEY,
		PassTypeName VARCHAR(100),
		PassColor VARCHAR(100),
		IsActive BIT NOT NULL CONSTRAINT DF_CorePassType_IsActive DEFAULT(1),
		EntryUserID INT NOT NULL CONSTRAINT FK_CorePassType_EntryUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		EntryDate DATETIME NOT NULL CONSTRAINT DF_CorePassType_EntryDate DEFAULT(GETDATE()),
		UpdateUserID INT NULL CONSTRAINT FK_CorePassType_UpdateUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		UpdateDate DATETIME NULL
	)
END


IF NOT EXISTS(SELECT NAME FROM sys.tables WHERE name = 'CoreQuarterType')
BEGIN
	CREATE TABLE dbo.CoreQuarterType
	(
		QuarterTypeID INT IDENTITY NOT NULL PRIMARY KEY,
		QuarterTypeName VARCHAR(100),
		MaxQuarterNumber INT NOT NULL,
		IsActive BIT NOT NULL CONSTRAINT DF_CoreQuarterType_IsActive DEFAULT(1),
		EntryUserID INT NOT NULL CONSTRAINT FK_CoreQuarterType_EntryUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		EntryDate DATETIME NOT NULL CONSTRAINT DF_CoreQuarterType_EntryDate DEFAULT(GETDATE()),
		UpdateUserID INT NULL CONSTRAINT FK_CoreQuarterType_UpdateUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		UpdateDate DATETIME NULL
	)
END


IF NOT EXISTS(SELECT 1 FROM sys.tables (NOLOCK) WHERE name = 'NSGEmployee')
BEGIN
	CREATE TABLE dbo.NSGEmployee
	(
		NSGEmployeeID BIGINT IDENTITY NOT NULL PRIMARY KEY CLUSTERED,
		NSGEmployeeCode VARCHAR(250) NOT NULL,
		FirstName VARCHAR(250) NOT NULL,
		LastName VARCHAR(250) NULL,
		Gender VARCHAR(10) NOT NULL,
		RankID INT NULL CONSTRAINT FK_NSGEmployee_RankID_CoreRank_RankID FOREIGN KEY REFERENCES dbo.CoreRank(RankID),
		UnitID INT NULL CONSTRAINT FK_NSGEmployee_UnitID_CoreUnit_UnitID FOREIGN KEY REFERENCES dbo.CoreUnit(UnitID),
		QuarterTypeID INT NULL CONSTRAINT FK_NSGEmployee_QuarterTypeID_CoreQuarterType_QuarterTypeID FOREIGN KEY REFERENCES dbo.CoreQuarterType(QuarterTypeID),
		QuarterNumber INT NULL,
		IsActive BIT NOT NULL CONSTRAINT DF_NSGEmployee_IsActive DEFAULT(1),
		EntryUserID INT NOT NULL CONSTRAINT FK_NSGEmployee_EntryUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		EntryDate DATETIME NOT NULL CONSTRAINT DF_NSGEmployee_EntryDate DEFAULT(GETDATE()),
		UpdateUserID INT NULL CONSTRAINT FK_NSGEmployee_UpdateUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		UpdateDate DATETIME NULL
	)
END


IF NOT EXISTS(SELECT 1 FROM sys.tables (NOLOCK) WHERE name = 'NSGPass')
BEGIN
	CREATE TABLE dbo.NSGPass
	(
		NSGPassID BIGINT IDENTITY NOT NULL PRIMARY KEY CLUSTERED,
		MachineID VARCHAR(250) NOT NULL,
		PassTypeID INT NOT NULL CONSTRAINT FK_NSGPass_PassTypeID_CorePassType_PassTypeID FOREIGN KEY REFERENCES dbo.CorePassType(PassTypeID),
		FirstName VARCHAR(250) NOT NULL,
		LastName VARCHAR(250) NULL,
		BirthDate DATETIME NULL,
		Gender VARCHAR(10) NOT NULL,
		MobileNo VARCHAR(15) NULL,
		GuardianName VARCHAR(500) NULL,
		IssueDate DATETIME NOT NULL,
		ExpiryDate DATETIME NULL,
		PassHolderAddress VARCHAR(500) NULL,
		CityID BIGINT NULL CONSTRAINT FK_NSGPass_CityID_CoreCity_CityID FOREIGN KEY REFERENCES dbo.CoreCity(CityID),
		StateID INT NULL CONSTRAINT FK_NSGPass_StateID_CoreState_StateID FOREIGN KEY REFERENCES dbo.CoreState(StateID),
		PassHolderPhoto IMAGE NULL,
		EntryUserID INT NOT NULL CONSTRAINT FK_NSGPass_EntryUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		EntryDate DATETIME NOT NULL CONSTRAINT DF_NSGPass_EntryDate DEFAULT(GETDATE()),
		UpdateUserID INT NULL CONSTRAINT FK_NSGPass_UpdateUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		UpdateDate DATETIME NULL
	)
END

IF NOT EXISTS(SELECT 1 FROM sys.tables (NOLOCK) WHERE name = 'CivilianPassDetail')
BEGIN
	CREATE TABLE dbo.CivilianPassDetail
	(
		CivilianPassDetailID BIGINT IDENTITY NOT NULL PRIMARY KEY CLUSTERED,
		NSGPassID BIGINT NOT NULL CONSTRAINT FK_CivilianPassDetail_NSGPassID_NSGPass_NSGPassID FOREIGN KEY REFERENCES dbo.NSGPass(NSGPassID),
		Designation VARCHAR(100) NOT NULL,
		ContractorName VARCHAR(100) NOT NULL,
		EntryUserID INT NOT NULL CONSTRAINT FK_CivilianPassDetail_EntryUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		EntryDate DATETIME NOT NULL CONSTRAINT DF_CivilianPassDetail_EntryDate DEFAULT(GETDATE()),
		UpdateUserID INT NULL CONSTRAINT FK_CivilianPassDetail_UpdateUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		UpdateDate DATETIME NULL
	)
END

IF NOT EXISTS(SELECT 1 FROM sys.tables (NOLOCK) WHERE name = 'GuestDependantPassDetail')
BEGIN
	CREATE TABLE dbo.GuestDependantPassDetail
	(
		GuestDependantPassDetailID BIGINT IDENTITY NOT NULL PRIMARY KEY CLUSTERED,
		NSGPassID BIGINT NOT NULL CONSTRAINT FK_GuestDependantPassDetail_NSGPassID_NSGPass_NSGPassID FOREIGN KEY REFERENCES dbo.NSGPass(NSGPassID),
		IdentificationMark VARCHAR(100) NOT NULL,
		Height NUMERIC(10,2) NOT NULL,
		RelativeOf VARCHAR(100) NOT NULL,
		NSGEmployeeCode VARCHAR(250) NOT NULL,
		RankID INT NULL CONSTRAINT FK_GuestDependantPassDetail_RankID_CoreRank_RankID FOREIGN KEY REFERENCES dbo.CoreRank(RankID),
		UnitID INT NULL CONSTRAINT FK_GuestDependantPassDetail_UnitID_CoreUnit_UnitID FOREIGN KEY REFERENCES dbo.CoreUnit(UnitID),
		RelationshipID INT NOT NULL CONSTRAINT FK_GuestDependantPassDetail_RelationshipID_CoreRelationship_RelationshipID FOREIGN KEY REFERENCES dbo.CoreRelationship(RelationshipID),
		EntryUserID INT NOT NULL CONSTRAINT FK_GuestDependantPassDetail_EntryUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		EntryDate DATETIME NOT NULL CONSTRAINT DF_GuestDependantPassDetail_EntryDate DEFAULT(GETDATE()),
		UpdateUserID INT NULL CONSTRAINT FK_GuestDependantPassDetail_UpdateUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		UpdateDate DATETIME NULL
	)
END

IF NOT EXISTS(SELECT 1 FROM sys.tables (NOLOCK) WHERE name = 'OutlivingPassDetail')
BEGIN
	CREATE TABLE dbo.OutlivingPassDetail
	(
		OutlivingPassDetailID BIGINT IDENTITY NOT NULL PRIMARY KEY CLUSTERED,
		NSGPassID BIGINT NOT NULL CONSTRAINT FK_OutlivingPassDetail_NSGPassID_NSGPass_NSGPassID FOREIGN KEY REFERENCES dbo.NSGPass(NSGPassID),
		IdentificationMark VARCHAR(100) NOT NULL,		
		BloodGroup VARCHAR(10) NOT NULL,
		NSGEmployeeCode VARCHAR(250) NOT NULL,
		RankID INT NULL CONSTRAINT FK_OutlivingPassDetail_RankID_CoreRank_RankID FOREIGN KEY REFERENCES dbo.CoreRank(RankID),
		UnitID INT NULL CONSTRAINT FK_OutlivingPassDetail_UnitID_CoreUnit_UnitID FOREIGN KEY REFERENCES dbo.CoreUnit(UnitID),
		EntryUserID INT NOT NULL CONSTRAINT FK_OutlivingPassDetail_EntryUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		EntryDate DATETIME NOT NULL CONSTRAINT DF_OutlivingPassDetail_EntryDate DEFAULT(GETDATE()),
		UpdateUserID INT NULL CONSTRAINT FK_OutlivingPassDetail_UpdateUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		UpdateDate DATETIME NULL
	)
END

IF NOT EXISTS(SELECT 1 FROM sys.tables (NOLOCK) WHERE name = 'VehiclePassDetail')
BEGIN
	CREATE TABLE dbo.VehiclePassDetail
	(
		VehiclePassDetailID BIGINT IDENTITY NOT NULL PRIMARY KEY CLUSTERED,
		NSGPassID BIGINT NOT NULL CONSTRAINT FK_VehiclePassDetail_NSGPassID_NSGPass_NSGPassID FOREIGN KEY REFERENCES dbo.NSGPass(NSGPassID),
		RegistrationNumber VARCHAR(20) NOT NULL,		
		VehicleType VARCHAR(10) NOT NULL,
		VehicleMake VARCHAR(10) NOT NULL,
		Designation VARCHAR(100) NULL,
		NSGEmployeeCode VARCHAR(250) NULL,
		RankID INT NULL CONSTRAINT FK_VehiclePassDetail_RankID_CoreRank_RankID FOREIGN KEY REFERENCES dbo.CoreRank(RankID),
		UnitID INT NULL CONSTRAINT FK_VehiclePassDetail_UnitID_CoreUnit_UnitID FOREIGN KEY REFERENCES dbo.CoreUnit(UnitID),
		EntryUserID INT NOT NULL CONSTRAINT FK_VehiclePassDetail_EntryUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		EntryDate DATETIME NOT NULL CONSTRAINT DF_VehiclePassDetail_EntryDate DEFAULT(GETDATE()),
		UpdateUserID INT NULL CONSTRAINT FK_VehiclePassDetail_UpdateUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		UpdateDate DATETIME NULL
	)
END


IF NOT EXISTS(SELECT 1 FROM sys.tables (NOLOCK) WHERE name = 'PassDocument')
BEGIN
	CREATE TABLE dbo.PassDocument
	(
		PassDocumentID BIGINT IDENTITY NOT NULL PRIMARY KEY CLUSTERED,
		NSGPassID BIGINT NOT NULL CONSTRAINT FK_PassDocument_NSGPassID_NSGPass_NSGPassID FOREIGN KEY REFERENCES dbo.NSGPass(NSGPassID),
		DocumentName VARCHAR(20) NOT NULL,
		DocumentPhoto IMAGE NULL,
		EntryUserID INT NOT NULL CONSTRAINT FK_PassDocument_EntryUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		EntryDate DATETIME NOT NULL CONSTRAINT DF_PassDocument_EntryDate DEFAULT(GETDATE()),
		UpdateUserID INT NULL CONSTRAINT FK_PassDocument_UpdateUserID_CoreUser_CoreUserID FOREIGN KEY REFERENCES dbo.CoreUser(CoreUserID),
		UpdateDate DATETIME NULL
	)
END


IF NOT EXISTS(SELECT 1 FROM sys.tables WHERE NAME = 'ErrorLog')
BEGIN
	CREATE TABLE dbo.ErrorLog
	(
		ErrorLogID INT IDENTITY(1,1) PRIMARY KEY,
		SPName VARCHAR(500),
		ErrorNumber INT,
		ErrorSeverity INT,
		ErrorState INT,
		ErrorMessage NVARCHAR(4000),
		ErrorTime DATETIME DEFAULT GETDATE()
	)
END
GO



IF NOT EXISTS(SELECT 1 FROM dbo.CoreUser (NOLOCK) CU WHERE CU.UserName = 'NSGAdmin')
BEGIN
	INSERT INTO dbo.CoreUser(UserName, UserPassword, EmployeeID, FirstName, LastName, EntryUserID)
	VALUES ('NSGAdmin', 'nsg@2016', '1', 'System', 'Administrator', 1)
END

IF NOT EXISTS(SELECT 1 FROM dbo.CoreRank (NOLOCK) CR WHERE CR.RankName = 'R 1')
BEGIN
	INSERT INTO dbo.CoreRank (RankName, EntryUserID)
	VALUES ('R 1', 1), ('R 2', 1), ('AC 1', 1), ('AC 2', 1), ('AC 3', 1), ('Team Commander', 1), ('Squadron Commander', 1), ('Group Commander', 1), ('DIG', 1), ('IG', 1), ('DG', 1), ('OTHERS', 1)
END

IF NOT EXISTS(SELECT 1 FROM dbo.CoreUnit (NOLOCK) CU WHERE CU.UnitName = 'FHQ')
BEGIN
	INSERT INTO dbo.CoreUnit (UnitName, EntryUserID)
	VALUES ('FHQ', 1), ('Comm. Grp.', 1), ('KV', 1), ('SWS', 1), ('51 SAG', 1), ('11 SRG', 1), ('12 SRG', 1), ('13 SRG', 1), ('TC', 1), ('ESG', 1), ('Logistics Grp.', 1),
		('R & R Sqn.', 1), ('TN Sqn.', 1), ('Ordn. Sqn.', 1), ('Supply Sqn.', 1), ('Station HQ', 1), ('CH', 1), ('NSG Primary School', 1), ('Const. Grp.', 1)
END

IF NOT EXISTS(SELECT 1 FROM dbo.CoreQuarterType (NOLOCK) CQT WHERE CQT.QuarterTypeName = 'Type-1')
BEGIN
	INSERT INTO dbo.CoreQuarterType (QuarterTypeName, MaxQuarterNumber, EntryUserID)
	VALUES ('Type-1', 46, 1), ('Type-2', 1020, 1), ('Type-2 New', 329, 1), ('Type-3', 426, 1), ('Type-3 New', 115, 1), ('Type-4', 117, 1), ('Type-4 New', 31, 1), ('Type-4 New Spl', 14, 1), ('Type-5', 70, 1), ('Type-6', 4, 1), ('DU', 387, 1), ('KV', 20, 1)
END

IF NOT EXISTS(SELECT 1 FROM dbo.CoreIdentityType (NOLOCK) CIT WHERE CIT.IdentityType = 'PAN Card')
BEGIN
	INSERT INTO dbo.CoreIdentityType(IdentityType, EntryUserID)
	VALUES  ( 'PAN Card', 1), ('Passport', 1), ('Driving License', 1), ('Voter ID', 1), ('Aadhar Card', 1), ('Govt. Emp. ID', 1), ('Others', 1)
END

IF NOT EXISTS(SELECT 1 FROM dbo.CoreRelationship (NOLOCK) CR WHERE CR.Relationship = 'Brother')
BEGIN
	INSERT INTO dbo.CoreRelationship (Relationship, EntryUserID)
	VALUES ('Brother', 1), ('Sister', 1), ('Mother', 1), ('Father', 1), ('Wife', 1), ('Husband', 1), ('Daughter', 1), ('Son', 1), ('Uncle', 1), ('Aunty', 1), ('Friend', 1)
END


IF NOT EXISTS(SELECT 1 FROM dbo.CorePassType (NOLOCK) CPT WHERE CPT.PassTypeName = 'Civilian Labour Pass')
BEGIN
	INSERT INTO dbo.CorePassType(PassTypeName, PassColor, EntryUserID)
	VALUES  ( 'Civilian Labour Pass', 'LightGreen', 1), ('Civilian Regular Pass', 'Pink', 1), ('Dependent Pass', 'White', 1), ('Guest Pass', 'LightBlue', 1), ('NSG Personal Vehicle Pass', 'DarkGreen', 1), ('Civilian Vehicle Pass', 'Red', 1), ('Outliving Pass', 'DarkBlue', 1)
END

--IF NOT EXISTS(SELECT 1 FROM dbo.CoreCity (NOLOCK))
--BEGIN
--	DECLARE @ID INT,
--			@state VARCHAR(500),
--			@stateId INT,
--			@city VARCHAR(500),
--			@cityId INT
	
--	SELECT TOP 1 @ID = ID, @state = StateName, @city = CityName FROM IndianStatesAndCities WHERE Used = 0
	
--	WHILE(@ID IS NOT NULL)
--	BEGIN
--		SELECT @stateId = CS.StateID FROM dbo.CoreState (NOLOCK) CS WHERE CS.StateName = @state

--		IF(@stateId IS NULL)
--		BEGIN
--			INSERT INTO dbo.CoreState(StateName, EntryUserID)
--			VALUES  ( @state, 1)
--			SELECT @stateId = CS.StateID FROM dbo.CoreState (NOLOCK) CS WHERE CS.StateName = @state
--		END
    
--		SELECT @cityId = CC.CityID FROM dbo.CoreCity (NOLOCK) CC WHERE CC.StateID = @stateId AND CC.CityName = @city

--		IF(@cityId IS NULL)
--		BEGIN
--			INSERT INTO dbo.CoreCity(StateID, CityName, EntryUserID)
--			VALUES (@stateId, @city, 1)
--		END

--		UPDATE IndianStatesAndCities SET Used = 1 WHERE ID = @ID

--		SELECT @ID = NULL, @state = NULL, @stateId = NULL, @city = NULL, @cityId = NULL

--		SELECT TOP 1 @ID = ID, @state = StateName, @city = CityName FROM IndianStatesAndCities WHERE Used = 0
--	END
--END



