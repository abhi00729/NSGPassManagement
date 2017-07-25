

IF EXISTS(SELECT 1 FROM sys.views (NOLOCK) WHERE name = 'CivilianPassDetailView')
BEGIN
    DROP VIEW dbo.CivilianPassDetailView
END
GO

CREATE VIEW dbo.CivilianPassDetailView
AS
SELECT
	NP.NSGPassID,
	IssueDate,
	ExpiryDate,
	FirstName + ' ' + LastName AS FullName,
	GuardianName,
	BirthDate,
	CPD.ContractorName,
	CPD.Designation,
	NP.PassHolderAddress + ' ' + CC.CityName + ' ' + CS.StateName AS PassHolderAddress,
	NP.PassHolderPhoto
FROM dbo.NSGPass (NOLOCK) NP
INNER JOIN dbo.CoreCity (NOLOCK) CC ON CC.CityID = NP.CityID
INNER JOIN dbo.CoreState (NOLOCK) CS ON CS.StateID = NP.StateID
INNER JOIN dbo.CivilianPassDetail (NOLOCK) CPD ON CPD.NSGPassID = NP.NSGPassID
GO


IF EXISTS(SELECT 1 FROM sys.views (NOLOCK) WHERE name = 'GuestDependentPassDetailView')
BEGIN
    DROP VIEW dbo.GuestDependentPassDetailView
END
GO

CREATE VIEW dbo.GuestDependentPassDetailView
AS
SELECT
	NP.NSGPassID,
	IssueDate,
	ExpiryDate,
	FirstName + ' ' + LastName AS FullName,
	CR.Relationship,
	BirthDate,
	GDPD.IdentificationMark,
	GDPD.RelativeOf,
	GDPD.NSGEmployeeCode,
	CR2.RankName,
	CU.UnitName,
	NP.PassHolderPhoto
FROM dbo.NSGPass (NOLOCK) NP
INNER JOIN dbo.GuestDependantPassDetail (NOLOCK) GDPD ON GDPD.NSGPassID = NP.NSGPassID
INNER JOIN dbo.CoreRelationship (NOLOCK) CR ON CR.RelationshipID = GDPD.RelationshipID
INNER JOIN dbo.CoreRank (NOLOCK) CR2 ON CR2.RankID = GDPD.RankID
INNER JOIN dbo.CoreUnit (NOLOCK) CU ON CU.UnitID = GDPD.UnitID
GO

IF EXISTS(SELECT 1 FROM sys.views (NOLOCK) WHERE name = 'NSGPersonalVehiclePassView')
BEGIN
    DROP VIEW dbo.NSGPersonalVehiclePassView
END
GO

CREATE VIEW dbo.NSGPersonalVehiclePassView
AS
SELECT
	NP.NSGPassID,
	IssueDate,
	ExpiryDate,
	FirstName + ' ' + LastName AS FullName,
	VPD.NSGEmployeeCode,
	CR2.RankName,
	CU.UnitName,
	VPD.RegistrationNumber,
	VPD.VehicleType,
	VPD.VehicleMake,
	NP.PassHolderPhoto
FROM dbo.NSGPass (NOLOCK) NP
INNER JOIN dbo.VehiclePassDetail (NOLOCK) VPD ON VPD.NSGPassID = NP.NSGPassID
INNER JOIN dbo.CoreRank (NOLOCK) CR2 ON CR2.RankID = VPD.RankID
INNER JOIN dbo.CoreUnit (NOLOCK) CU ON CU.UnitID = VPD.UnitID
GO

IF EXISTS(SELECT 1 FROM sys.views (NOLOCK) WHERE name = 'CivilianVehiclePassView')
BEGIN
    DROP VIEW dbo.CivilianVehiclePassView
END
GO

CREATE VIEW dbo.CivilianVehiclePassView
AS
SELECT
	NP.NSGPassID,
	IssueDate,
	ExpiryDate,
	FirstName + ' ' + LastName AS FullName,
	VPD.RegistrationNumber,
	VPD.VehicleType,
	VPD.VehicleMake,
	Designation,
	NP.PassHolderPhoto
FROM dbo.NSGPass (NOLOCK) NP
INNER JOIN dbo.VehiclePassDetail (NOLOCK) VPD ON VPD.NSGPassID = NP.NSGPassID
GO

IF EXISTS(SELECT 1 FROM sys.views (NOLOCK) WHERE name = 'OutlivingPassView')
BEGIN
    DROP VIEW dbo.OutlivingPassView
END
GO
CREATE VIEW dbo.OutlivingPassView
AS
SELECT
	NP.NSGPassID,
	IssueDate,
	ExpiryDate,
	FirstName + ' ' + LastName AS FullName,
	OPD.NSGEmployeeCode,
	CR2.RankName,
	CU.UnitName,
	OPD.BloodGroup,
	OPD.IdentificationMark,
	NP.PassHolderAddress + ' ' + CC.CityName + ' ' + CS.StateName AS PassHolderAddress,
	NP.PassHolderPhoto
FROM dbo.NSGPass (NOLOCK) NP
INNER JOIN dbo.CoreCity (NOLOCK) CC ON CC.CityID = NP.CityID
INNER JOIN dbo.CoreState (NOLOCK) CS ON CS.StateID = NP.StateID
INNER JOIN dbo.OutlivingPassDetail (NOLOCK) OPD ON OPD.NSGPassID = NP.NSGPassID
INNER JOIN dbo.CoreRank (NOLOCK) CR2 ON CR2.RankID = OPD.RankID
INNER JOIN dbo.CoreUnit (NOLOCK) CU ON CU.UnitID = OPD.UnitID
GO
