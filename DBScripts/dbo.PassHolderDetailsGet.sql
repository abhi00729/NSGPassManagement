USE NSGPassManagement
GO


IF EXISTS(SELECT 1 FROM sys.procedures (NOLOCK) WHERE name = 'PassHolderDetailsGet')
BEGIN
	DROP PROCEDURE dbo.PassHolderDetailsGet
END
GO

CREATE PROCEDURE dbo.PassHolderDetailsGet
(
	@IssueDate DATETIME = NULL,
	@ExpiryDate DATETIME = NULL,
	@PassID BIGINT = NULL,
	@PersonName VARCHAR(500) = NULL,
	@PassTypeID INT = NULL,
	@VehicleNumber VARCHAR(20) = NULL
)
AS
/*
exec dbo.PassHolderDetailsGet null, null, null, null, null, null
*/
BEGIN
	SET NOCOUNT ON
    
	SET @PersonName = '%' + ISNULL(@PersonName, '') + '%'
	
	IF(@ExpiryDate IS NOT NULL)
	BEGIN
		SET @ExpiryDate = DATEADD(SECOND, -1, CAST(CAST(@ExpiryDate + 1 AS DATE) AS DATETIME))
	END

	IF(LTRIM(@VehicleNumber) = '')
	BEGIN
		SET @VehicleNumber = NULL
	END

	SELECT
		NP.NSGPassID,
		NP.FirstName,
		NP.LastName,
		NP.IssueDate,
		NP.ExpiryDate,
		CPT.PassTypeName,
		CC.CityName,
		CS.StateName,
		ISNULL(VPD.RegistrationNumber, '') AS VehicleNumber, 
		CUREN.FirstName + ' ' + CUREN.LastName AS EntryBy
	FROM dbo.NSGPass (NOLOCK) NP
	INNER JOIN dbo.CorePassType (NOLOCK) CPT
		ON NP.PassTypeID = CPT.PassTypeID
	INNER JOIN dbo.CoreState (NOLOCK) CS
		ON CS.StateID = NP.StateID
	INNER JOIN dbo.CoreUser (NOLOCK) CUREN
		ON CUREN.CoreUserID = NP.EntryUserID
	LEFT JOIN dbo.CoreUser (NOLOCK) CUREX
		ON CUREX.CoreUserID = NP.UpdateUserID
	LEFT JOIN dbo.CoreCity (NOLOCK) CC 
		ON cc.CityID = NP.CityID
	LEFT JOIN dbo.VehiclePassDetail (NOLOCK) VPD
		ON VPD.NSGPassID = NP.NSGPassID
		AND VPD.RegistrationNumber LIKE '%' + ISNULL(@VehicleNumber, '') + '%'
	WHERE (NP.IssueDate >= @IssueDate OR @IssueDate IS NULL)
		AND (NP.ExpiryDate <= @ExpiryDate OR @ExpiryDate IS NULL)
		AND (NP.NSGPassID = @PassID OR @PassID IS NULL)
		AND (NP.FirstName LIKE @PersonName OR NP.LastName LIKE @PersonName)
		AND (NP.PassTypeID = @PassTypeID OR @PassTypeID IS NULL)
		AND (@VehicleNumber IS NULL OR VPD.NSGPassID = NP.NSGPassID)
	ORDER BY NP.NSGPassID DESC

	SET NOCOUNT OFF
END
GO

