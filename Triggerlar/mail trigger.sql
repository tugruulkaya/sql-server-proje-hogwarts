USE [HotelManagement]
GO
/****** Object:  Trigger [dbo].[SendResMail]    Script Date: 1/9/2021 6:14:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[SendResMail] 
ON [dbo].[Booking]  
AFTER INSERT,DELETE   
AS  
	DECLARE @Booking_Id INT,@Customer_Id INT,@CustomerEmail NVARCHAR(100)

IF EXISTS(SELECT * FROM INSERTED)
BEGIN
	SELECT @Booking_Id = Booking_Id,@Customer_Id =Customer_Id  FROM inserted
	SELECT @CustomerEmail =Customer_Email FROM [dbo].Customer WHERE Customer_Id=@Customer_Id
		EXEC msdb.dbo.sp_send_dbmail  
			 @profile_name = 'Notifications',  
			 @recipients = @CustomerEmail,  
			 @body = 'Rezervasyonunuz yapılmıştır.',  
			 @subject = 'Rezervasyon onay';  
END
