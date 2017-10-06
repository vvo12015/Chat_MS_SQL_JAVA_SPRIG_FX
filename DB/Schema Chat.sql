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
	CREATE TABLE [Chat].[User_role](
		[userID] INT NOT NULL,
		[roleID] INT NOT NULL,
	);
GO
PRINT N'Create table Chat.Groups...';
GO
	CREATE TABLE [Chat].[Groups](
		[groupID] INT IDENTITY(1, 1) NOT NULL,
		[name] VARCHAR(80) NOT NULL,
		[groupReference] INT
	);
GO
PRINT N'Create table Chat.Group_User...';
GO
	CREATE TABLE [Chat].[Group_User](
		[groupID] INT NOT NULL,
		[userID] INT NOT NULL,
	);
GO
PRINT N'Create table Chat.Chat...';
GO
	CREATE TABLE [Chat].[Messages](
		[MessageID] INT NOT NULL,
		[to] INT NOT NULL,
		[from] INT NOT NULL,
		[date] datetime NOT NULL,
		[text] VARCHAR(max),
	);
GO
PRINT N'Create table Chat.Msg_Reference...';
GO
	CREATE TABLE [Chat].[Msg_Reference](
		[MsgReferenceID] INT IDENTITY(1, 1) NOT NULL,
		[MsgReferenceMsgID] INT NOT NULL,
		[MsgReferenceLink] VARCHAR(max),
	);
GO
PRINT N'Creating CONSTRAINTS for table Users'
GO
PRINT N'Creating PRIMARY KEY for table Users'
GO
	ALTER TABLE [Users]
		ADD CONSTRAINT [PK_USER_USERID] PRIMARY KEY CLUSTERED([userID] ASC) ;
GO
PRINT N'Creating DEFAULT value datitime'
GO
	ALTER TABLE [Users]
		ADD CONSTRAINT [PK_USER_USERID] PRIMARY KEY 
GO