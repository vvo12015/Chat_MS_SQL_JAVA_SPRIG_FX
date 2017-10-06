PRINT N'Create Chat...';
GO
CREATE SCHEMA [Chat]
	AUTHORIZATION [dbo];
GO
PRINT N'Create table Chat.Users...';
GO
	CREATE TABLE [Chat].[Users](
		[userID] INT IDENTITY(1,1) NOT NULL,
		[userLogin] VARCHAR(15) NOT NULL,
		[userName] VARCHAR(80) NOT NULL,
		[userPassword] VARCHAR(50) NOT NULL,
		[userReferenceID] INT,
		[userCreationUser] datetime
	);
GO
PRINT N'Create table Chat.Roles...';
GO
	CREATE TABLE [Chat].[Roles](
		[roleID] INT IDENTITY(1, 1) NOT NULL,
		[roleName] VARCHAR(80) NOT NULL,
	);
GO
PRINT N'Create table Chat.User_role...';
GO
	CREATE TABLE [Chat].[UserRole](
		[userID] INT NOT NULL,
		[roleID] INT NOT NULL,
	);
GO
PRINT N'Create table Chat.Groups...';
GO
	CREATE TABLE [Chat].[Groups](
		[groupID] INT IDENTITY(1, 1) NOT NULL,
		[groupName] VARCHAR(80) NOT NULL,
		[groupReference] INT
	);
GO
PRINT N'Create table Chat.Group_User...';
GO
	CREATE TABLE [Chat].[GroupUser](
		[groupID] INT NOT NULL,
		[userID] INT NOT NULL,
	);
GO
PRINT N'Create table Chat.Messages...';
GO
	CREATE TABLE [Chat].[Messages](
		[MessageID] INT IDENTITY(1, 1) NOT NULL,
		[to] INT NOT NULL,
		[from] INT NOT NULL,
		[date] datetime NOT NULL,
		[text] VARCHAR(max),
	);
GO
PRINT N'Create table Chat.Reference...';
GO
	CREATE TABLE [Chat].[Reference](
		[ReferenceID] INT IDENTITY(1, 1) NOT NULL,
		[ReferenceLink] VARCHAR(max),
	);
GO
PRINT N'Create table Chat.MsgReference...';
GO
	CREATE TABLE [Chat].[MsgReference](
		[ReferenceID] INT IDENTITY(1, 1) NOT NULL,
		[MessageID] INT,
	);
GO
PRINT N'Creating PRIMARY KEY for table Users'
GO
	ALTER TABLE [Chat].[Users]
		ADD CONSTRAINT [PK_USER_USERID] PRIMARY KEY CLUSTERED([userID] ASC)  WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
GO
PRINT N'Creating PRIMARY KEY for table Roles'
GO
	ALTER TABLE [Chat].[Roles]
		ADD CONSTRAINT [PK_ROLES_ROLEID] PRIMARY KEY CLUSTERED ([roleID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
GO
PRINT N'Creating Chat.FK_User_role_userID...';  
GO  
ALTER TABLE [Chat].[UserRole]  
    ADD CONSTRAINT [FK_USERROLE_USER_USERID] FOREIGN KEY ([userID]) REFERENCES [Chat].[User] ([userID]) ON DELETE NO ACTION ON UPDATE NO ACTION;  
GO  
PRINT N'Creating Chat.FK_User_role_roleID...';  
GO  
ALTER TABLE [Chat].[UserRole]  
    ADD CONSTRAINT [FK_USERROLE_ROLE_ROLEID] FOREIGN KEY ([roleID]) REFERENCES [Chat].[Role] ([roleID]) ON DELETE NO ACTION ON UPDATE NO ACTION;  
GO
PRINT N'Creating PRIMARY KEY for table Groups'
GO
	ALTER TABLE [Chat].[Groups]
		ADD CONSTRAINT [PK_GROUPS_GROUPID] PRIMARY KEY CLUSTERED ([groupID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
GO
PRINT N'Creating Chat.FK_GroupUser_userID...';  
GO  
ALTER TABLE [Chat].[GroupUser]  
    ADD CONSTRAINT [FK_GROUPUSER_USER_USERID] FOREIGN KEY ([userID]) REFERENCES [Chat].[User] ([userID]) ON DELETE NO ACTION ON UPDATE NO ACTION;  
GO  
PRINT N'Creating Chat.FK_GroupUser_groupID...';  
GO  
ALTER TABLE [Chat].[GroupUser]  
    ADD CONSTRAINT [FK_GROUPUSER_GROUP_GROUPID] FOREIGN KEY ([groupID]) REFERENCES [Chat].[Group] ([groupID]) ON DELETE NO ACTION ON UPDATE NO ACTION;  
GO

PRINT N'Creating PRIMARY KEY for table Messages...'
GO
	ALTER TABLE [Chat].[Messages]
		ADD CONSTRAINT [PK_MESSAGE_MESSAGEID] PRIMARY KEY CLUSTERED([messageID] ASC)  WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
GO
PRINT N'Creating PRIMARY KEY for table Reference...'
GO
	ALTER TABLE [Chat].[Reference]
		ADD CONSTRAINT [PK_REFERENCE_REFERENCEID] PRIMARY KEY CLUSTERED([referenceID] ASC)  WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
GO
PRINT N'Creating Chat.FK_MsgReference_messageID...';  
GO  
ALTER TABLE [Chat].[MsgReference]  
    ADD CONSTRAINT [FK_MSGREFERENCE_MESSAGE_MESSAGEID] FOREIGN KEY ([messageID]) REFERENCES [Chat].[Messages] ([messageID]) ON DELETE NO ACTION ON UPDATE NO ACTION;  
GO  
PRINT N'Creating Chat.FK_MsgReference_referenceID...';  
GO  
ALTER TABLE [Chat].[MsgReference]  
    ADD CONSTRAINT [FK_MSGREFERENCE_REFERENCE_REFERENCEID] FOREIGN KEY ([referenceID]) REFERENCES [Chat].[Reference] ([referenceID]) ON DELETE NO ACTION ON UPDATE NO ACTION;  
GO
PRINT N'Creating procedure uspNewUser...';  
GO 
CREATE PROCEDURE [Chat].[uspNewUser]  
	@UserLogin VARCHAR(15),
	@UserName VARCHAR(80),
	@UserPassword VARCHAR(50),
	@UserReferenceLink VARCHAR(MAX)
AS  
BEGIN  
DECLARE @UserReferenceID INT  
BEGIN TRANSACTION  
	INSERT INTO [Chat].[Reference] ([ReferenceLink])   
     VALUES (@UserReferenceLink)  
	SELECT @UserReferenceID = SCOPE_IDENTITY(); 
     
	 INSERT INTO [Chat].[Users] ([userLogin], [userName], [userPassword], [userReferenceID])   
     VALUES (@UserLogin, @UserName, @UserPassword, @UserReferenceID)
COMMIT TRANSACTION  
END  
GO  
PRINT N'Creating procedure uspNewRole...';  
GO 
CREATE PROCEDURE [Chat].[uspNewRole]  
@RoleName NVARCHAR (80)  
AS  
BEGIN  
INSERT INTO [Chat].[Roles] ([roleName]) VALUES (@RoleName);  
SELECT SCOPE_IDENTITY()  
END  
GO  
PRINT N'Creating procedure uspNewRecordUserRole...';  
GO 
CREATE PROCEDURE [Chat].[uspNewRecordUserRole]  
@RoleID INT,  
@UserID INT
AS  
BEGIN  
INSERT INTO [Chat].[UserRole] ([userID], [roleID]) VALUES (@UserID, @RoleID);  
SELECT SCOPE_IDENTITY()  
END  
GO  
--Процедура, яка назначає ролі для декількох користувачів
PRINT N'Creating procedure uspNewGroup...';  
GO 
CREATE PROCEDURE [Chat].[uspNewGroup]  
@GroupName NVARCHAR (80),  
@GroupReferenceLink VARCHAR(MAX)
AS  
BEGIN
DECLARE @GroupReferenceID INT 
INSERT INTO [Chat].[Reference] ([ReferenceLink])   
    VALUES (@GroupReferenceLink)  
	SELECT @GroupReferenceID = SCOPE_IDENTITY();   
INSERT INTO [Chat].[Groups] ([groupName], [groupReference]) VALUES (@GroupName, @GroupReferenceID);  
SELECT SCOPE_IDENTITY()  
END  
GO  
PRINT N'Creating procedure uspNewRecordGroupUser...';  
GO 
PRINT N'Creating Sales.uspFillOrder...';  
GO  
CREATE PROCEDURE [Sales].[uspFillOrder]  
@OrderID INT, @FilledDate DATETIME  
AS  
BEGIN  
DECLARE @Delta INT, @CustomerID INT  
BEGIN TRANSACTION  
    SELECT @Delta = [Amount], @CustomerID = [CustomerID]  
     FROM [Sales].[Orders] WHERE [OrderID] = @OrderID;  

UPDATE [Sales].[Orders]  
   SET [Status] = 'F',  
       [FilledDate] = @FilledDate  
WHERE [OrderID] = @OrderID;  

UPDATE [Sales].[Customer]  
   SET  
   YTDSales = YTDSales - @Delta  
    WHERE [CustomerID] = @CustomerID  
COMMIT TRANSACTION  
END  
GO  
PRINT N'Creating Sales.uspNewCustomer...';  
GO  
CREATE PROCEDURE [Sales].[uspNewCustomer]  
@CustomerName NVARCHAR (40)  
AS  
BEGIN  
INSERT INTO [Sales].[Customer] (CustomerName) VALUES (@CustomerName);  
SELECT SCOPE_IDENTITY()  
END  
GO  
PRINT N'Creating Sales.uspPlaceNewOrder...';  
GO  
CREATE PROCEDURE [Sales].[uspPlaceNewOrder]  
@CustomerID INT, @Amount INT, @OrderDate DATETIME, @Status CHAR (1)='O'  
AS  
BEGIN  
DECLARE @RC INT  
BEGIN TRANSACTION  
INSERT INTO [Sales].[Orders] (CustomerID, OrderDate, FilledDate, Status, Amount)   
     VALUES (@CustomerID, @OrderDate, NULL, @Status, @Amount)  
SELECT @RC = SCOPE_IDENTITY();  
UPDATE [Sales].[Customer]  
   SET  
   YTDOrders = YTDOrders + @Amount  
    WHERE [CustomerID] = @CustomerID  
COMMIT TRANSACTION  
RETURN @RC  
END  
GO  
CREATE PROCEDURE [Sales].[uspShowOrderDetails]  
@CustomerID INT=0  
AS  
BEGIN  
SELECT [C].[CustomerName], CONVERT(date, [O].[OrderDate]), CONVERT(date, [O].[FilledDate]), [O].[Status], [O].[Amount]  
  FROM [Sales].[Customer] AS C  
  INNER JOIN [Sales].[Orders] AS O  
     ON [O].[CustomerID] = [C].[CustomerID]  
  WHERE [C].[CustomerID] = @CustomerID  
END  
GO  