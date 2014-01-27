
-- ================================================              
-- Author:  Sravan              
-- Create date: 25 July 12              
-- Version : 1.0                
-- Description: SP to get all states and country            
-- ================================================              
ALTER PROCEDURE [dbo].Proc_Admin_FindAllCenterByLocationId     
@LocationId Int          
AS              
BEGIN              
 SELECT Config_TMCenter.CenterId,Center,Lkp_Cities.CityId,CityName,Config_TMLocation.LocationId,      
   Config_TMLocation.Location,      
  Lkp_States.[StateId]              
       ,dbo.fn_Titlecase([StateName]) AS [StateName]           
    ,[dbo].[Lkp_Countries].[CountryId]          
    ,dbo.fn_Titlecase([dbo].[Lkp_Countries].[CountryName]) AS [CountryName]           
 FROM Config_TMCenter         
  INNER JOIN  Trans_TMCenterXCountry ON Trans_TMCenterXCountry.CenterId=Config_TMCenter.CenterId        
 INNER JOIN  Lkp_States ON Lkp_States.StateId=Trans_TMCenterXCountry.StateId        
 INNER JOIN  Lkp_Cities ON Lkp_Cities.CityId=Trans_TMCenterXCountry.CityId        
  INNER JOIN  Config_TMLocation ON Config_TMLocation.LocationId=Trans_TMCenterXCountry.LocationId        
INNER JOIN [dbo].Lkp_Countries         
  ON [dbo].[Lkp_States].[CountryId] = [dbo].[Lkp_Countries].[CountryId]          
 WHERE Config_TMCenter.IsActive = 1              
 AND Config_TMCenter.IsDeleted= 0  AND Trans_TMCenterXCountry.CityId=@LocationId           
 ORDER BY Center              
          
END 

--**************************************************


CREATE PROCEDURE [dbo].[Proc_Admin_GetHospitalDeatilsByLocationsAndCenterIdForTelemedicine]              
@CityId int ,
@StateId int ,
@CenterId int          
AS                
BEGIN                
 SET NOCOUNT ON;              
   SELECT DISTINCT ([HospitalInfo].[HospitalId])              
         ,dbo.fn_TitleCase([HospitalInfo].[HospitalName]) As [HospitalName]                
   FROM [dbo].[HospitalInfo] WITH(NOLOCK) 
   INNER JOIN Trans_TMCenterXCountry ON Trans_TMCenterXCountry.CityId=HospitalInfo.CityId
   AND Trans_TMCenterXCountry.CountryId=HospitalInfo.CountryId AND Trans_TMCenterXCountry.StateId=HospitalInfo.StateId   
   where Trans_TMCenterXCountry.[CityId] = @CityId     
   AND Trans_TMCenterXCountry.StateId = @StateId AND Trans_TMCenterXCountry.CenterId = @CenterId     
   AND [HospitalInfo].IsActive=1 AND [HospitalInfo].IsDeleted=0  
   AND [HospitalInfo].IsTeleMedicine=1         
END    

--*****************************************************


-- =============================================        
-- Author:  Gautam        
-- Create date: 18 June 12        
-- Version : 1.0          
-- Description: SP to save state        
-- =============================================        
ALTER PROCEDURE [dbo].[Proc_Admin_SaveCenter]        
@CountryId int,      
@stateId int,      
@cityId int,        
@CreatedBy int,        
@CreatedIp varchar(50),  
@CenterName varchar(50)       
        
AS        
BEGIN         
    DECLARE @CenterId int    
    SET @CenterId=0    
      INSERT INTO [dbo].Config_TMCenter        
           (Center        
     ,IsActive        
     ,IsDeleted        
           ,CreatedBy        
           ,CreatedOn        
           ,CreatedIp)        
     VALUES        
           (@CenterName    
           ,1        
           ,0        
           ,@CreatedBy        
           ,GETDATE()        
           ,@CreatedIp)       
               
       SET @CenterId = (select @@IDENTITY)    
      INSERT INTO [dbo].Trans_TMCenterXCountry    
           (CenterId  
           ,[CountryId]    
           ,[StateId]    
           ,[CityId]    
           ,[CreatedOn]    
           ,[CreatedBy]    
           )    
     VALUES    
           (@CenterId  
           ,@CountryId    
           ,@stateId    
           ,@cityId    
           ,GETDATE()    
           ,@CreatedBy    
           )    
END 


--*****************************************************
    
-- ================================================              
-- Author:  Sravan              
-- Create date: 25 July 12              
-- Version : 1.0                
-- Description: SP to get all states and country            
-- ================================================              
ALTER PROCEDURE [dbo].Proc_Admin_GetAllCenterAndStatesAndCountriesfroTccCenter             
AS              
BEGIN              
 SELECT Config_TMCenter.CenterId,Center,Lkp_Cities.CityId,CityName,
  Lkp_States.[StateId]              
       ,dbo.fn_Titlecase([StateName]) AS [StateName]           
    ,[dbo].[Lkp_Countries].[CountryId]          
    ,dbo.fn_Titlecase([dbo].[Lkp_Countries].[CountryName]) AS [CountryName]           
 FROM Config_TMCenter         
  INNER JOIN  Trans_TMCenterXCountry ON Trans_TMCenterXCountry.CenterId=Config_TMCenter.CenterId        
 INNER JOIN  Lkp_States ON Lkp_States.StateId=Trans_TMCenterXCountry.StateId        
 INNER JOIN  Lkp_Cities ON Lkp_Cities.CityId=Trans_TMCenterXCountry.CityId        
 INNER JOIN [dbo].Lkp_Countries         
  ON [dbo].[Lkp_States].[CountryId] = [dbo].[Lkp_Countries].[CountryId]          
 WHERE Config_TMCenter.IsActive = 1              
 AND Config_TMCenter.IsDeleted= 0              
 ORDER BY Center              
          
END 

--************************************************
  ALTER TABLE [TMUsersAppointmentsInfo]
ADD [CenterId] INT

--**********************************************


  
ALTER PROCEDURE Proc_SaveTMUsersAppointments                 
@PatientName varchar(500),                    
@MobileNumber varchar(20),                    
@EmailId varchar(200),                    
@PatientMode varchar(5000),                    
@Speciality int,                    
@TMSpecialityRemarks varchar(5000),                    
@Doctor int,              
@TMDoctorRemarks varchar(5000),                    
@AppointmentDate varchar(50),                    
@SlotTime varchar(50),              
@TMRemarks varchar(5000),                      
@CreatedBy int,             
@CreatedIP varchar(50),                   
@AppointmentTypeId Int,            
 @UHID Varchar(50),                  
@HealthcheckId Int ,            
@HospitalId int,              
@isPrevRegistered int,            
@HealthCheckRemarks  varchar(500),          
@SalutationId int,          
@Age int,          
@Gender int,    
@PatientId INT,  
@UAID Varchar(200), 
@CenterId INT                 
AS BEGIN                    
                
--Declaring Variables                        
DECLARE @ApptDate DateTime                 
                
SELECT @ApptDate = CONVERT(DATETIME, @AppointmentDate, 103)                 
                
INSERT INTO [TMUsersAppointmentsInfo]            
([PatientName],             
[MobileNumber],             
[EmailId],             
[PatientMode],             
[Speciality],            
[TMSpecialityRemarks],             
[Doctor],             
[TMDoctorRemarks],             
[AppointmentDate],             
[SlotTime],                 
[TMRemarks],             
[CreatedBy],            
[CreatedIP],             
[AppointmentTypeId],            
[UHID],            
[HealthcheckId],            
[HospitalId],            
IsPrevRegistered,            
HealthCheckRemarks,          
SalutationId,          
Age,          
Gender,    
PatientId,  
UAID,
CenterId          
)                   
 VALUES(            
 @PatientName,             
 @MobileNumber,             
 @EmailId,             
 @PatientMode,             
 @Speciality,             
 @TMSpecialityRemarks,            
 @Doctor,             
 @TMDoctorRemarks,             
 @ApptDate,             
 @SlotTime,            
  @TMRemarks,             
  @CreatedBy,             
  @CreatedIP,                
  @AppointmentTypeId,             
  @UHID,            
  @HealthcheckId,            
  @HospitalId,            
  @isPrevRegistered,            
  @HealthCheckRemarks,          
  @SalutationId,          
  @Age,           
  @Gender,    
  @PatientId,  
  @UAID ,
  @CenterId           
  )    
 select @@IDENTITY  
             
END 

--*************************************************


  
  
  -- =====================================================================================================                                    
-- Author:  <Sairam.T>                                    
-- Create date: <21-06-2012>                                    
-- Version : 1.0                                     
-- Description: <This procedure is used to Get Appointment By AppointmentType,Status,FromDate,ToDate and PatientId>                                    
-- =====================================================================================================                                    
ALTER PROCEDURE [dbo].[Proc_Appointments_GetTMAppointmentsByFromDateToDateandPatientId] --5,'09/05/2013','31/07/2013',200458                                  
@StatusId INT,  
@FromDate varchar(50),                                    
@ToDate varchar(50),                                    
@PatientId int                                    
AS                                    
BEGIN             
 --Declaring Variables                                    
 DECLARE @FDate as datetime                      
 DECLARE @TDate as datetime                      
 --Assigining Values                      
 SELECT @FDate = dbo.FormatDateTime(CONVERT(datetime,@FromDate,103),'MM/DD/YYYY')                      
 SELECT @TDate = dbo.FormatDateTime(CONVERT(datetime,@ToDate,103),'MM/DD/YYYY')          
   
 IF @StatusId = 1                                    
 BEGIN    
  SELECT [dbo].[TMUsersAppointmentsInfo].[TMAppointmentId],ISNULL(Config_TMCenter.CenterId,0) AS CenterId ,ISNULL(Config_TMCenter.Center,'') AS Center,   
  ISNULL([dbo].fn_IsDateExpired(ConfirmedAppointmentDate,ConfirmedSlotTime),0) As IsdateExpired,     
  isnull([dbo].[TMUsersAppointmentsInfo].[UAID],'') AS UAID ,                       
  [dbo].[TMUsersAppointmentsInfo].[PatientName],                      
  [dbo].[TMUsersAppointmentsInfo].[MobileNumber],                      
  [dbo].[TMUsersAppointmentsInfo].[EmailId],                      
  [dbo].[TMUsersAppointmentsInfo].[PatientMode],                      
  [dbo].[TMUsersAppointmentsInfo].[Speciality],                      
  [dbo].[TMUsersAppointmentsInfo].[TMSpecialityRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[Doctor],                      
  [dbo].[TMUsersAppointmentsInfo].[TMDoctorRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[SlotTime],                      
  [dbo].[TMUsersAppointmentsInfo].[TMRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[ConfirmStatus],                      
  [dbo].[TMUsersAppointmentsInfo].[VisitStatus],                      
  [dbo].[TMUsersAppointmentsInfo].[CancelledStatus],                      
  [dbo].[TMUsersAppointmentsInfo].[CreatedBy],                      
  isnull([dbo].[TMUsersAppointmentsInfo].[HuserRemarks],'') As [HuserRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[AppointmentTypeId],                      
  [dbo].[TMUsersAppointmentsInfo].[UHID],                      
  [dbo].[TMUsersAppointmentsInfo].[HealthcheckId],                      
  [dbo].[TMUsersAppointmentsInfo].[HospitalId],                      
  dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[CreatedOn],103),'DD/MM/YYYY') As [BookedDate],                                                    
  dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[AppointmentDate],103),'DD/MM/YYYY') AS [AppointmentDate],                                                      
  isnull(dbo.fn_titlecase([Lkp_SpecialitiesInfo].[Speciality]),'') AS [SpecialityName],                                  
  isnull(dbo.fn_titlecase([DocDetails].[FirstName] +' '+ [DocDetails].[LastName]),'')AS [DoctorName],                      
  dbo.fn_titlecase([HospitalInfo].[HospitalName]) AS [HospitalName],                       
  dbo.fn_titlecase([dbo].[UserInfo].[FirstName] +' '+ [dbo].[UserInfo].[LastName]) As [BookedBy],                                                    
  dbo.fn_IsDateExpired([dbo].[TMUsersAppointmentsInfo].[AppointmentDate], [dbo].[TMUsersAppointmentsInfo].[SlotTime]) As IsdateExpired,              
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityId],'0') AS [ConfirmedSpecialityId],              
  isnull(dbo.fn_titlecase([ConfirmSpecialitiesInfo].[Speciality]),'') AS [ConfirmedSpecialityName],               
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityRemarks],'') As [ConfirmedSpecialityRemarks],               
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorId],'0') AS [ConfirmedDoctorId],              
  isnull(dbo.fn_titlecase([ConfirmedDocDetails].[FirstName] +' '+ [ConfirmedDocDetails].[LastName]),'')AS [ConfirmedDoctorName],               
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorRemarks],'') As [ConfirmedDoctorRemarks],               
  isnull(dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[ConfirmedAppointmentDate],103),'DD/MM/YYYY'),'') AS [ConfirmedAppointmentDate],                
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSlotTime],'') AS [ConfirmedSlotTime],            
  isnull([dbo].[TMUsersAppointmentsInfo].[SalutationId],'0') AS [SalutationId],            
  isnull([dbo].[Lkp_Salutation].[Salutation],'') AS [Salutation],            
  isnull([dbo].[TMUsersAppointmentsInfo].[Age],'0') AS [Age],            
  isnull([dbo].[TMUsersAppointmentsInfo].[Gender],'0') AS [Gender],          
  isnull(convert(char(8),[dbo].[TMUsersAppointmentsInfo].[CreatedOn], 108),'') AS [BookedTime] ,  
  isnull([dbo].Lkp_Cities.CityName,'0') AS [CityName]           
  FROM [dbo].[TMUsersAppointmentsInfo] WITH (NOLOCK)                                                       
  LEFT JOIN [dbo].[HospitalInfo] WITH (NOLOCK) ON [dbo].[HospitalInfo].[HospitalId] = [dbo].[TMUsersAppointmentsInfo].[HospitalId]                                                    
  LEFT JOIN [dbo].[Lkp_Salutation] WITH (NOLOCK) ON [dbo].[Lkp_Salutation].[SalutationId] = [dbo].[TMUsersAppointmentsInfo].[SalutationId]            
  LEFT JOIN [dbo].[Lkp_SpecialitiesInfo] WITH (NOLOCK) ON [dbo].[Lkp_SpecialitiesInfo].[SpecialityId] = [dbo].[TMUsersAppointmentsInfo].[Speciality]               
  LEFT JOIN [dbo].[Lkp_SpecialitiesInfo] As ConfirmSpecialitiesInfo WITH (NOLOCK) ON [ConfirmSpecialitiesInfo].[SpecialityId] = [dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityId]                                                  
  LEFT JOIN [dbo].[UserInfo] As  DocDetails WITH (NOLOCK) ON [DocDetails].[UserId] = [dbo].[TMUsersAppointmentsInfo].[Doctor]                 
  LEFT JOIN [dbo].[UserInfo] As  ConfirmedDocDetails WITH (NOLOCK) ON [ConfirmedDocDetails].[UserId] = [dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorId]                     
  LEFT JOIN [dbo].[UserInfo] WITH (NOLOCK) ON [dbo].[UserInfo].[UserId] = [dbo].[TMUsersAppointmentsInfo].[CreatedBy]                       
  LEFT JOIN [dbo].[Config_HealthCheckInfo] ON [dbo].[Config_HealthCheckInfo].[HealthCheckId] = [dbo].[TMUsersAppointmentsInfo].[HealthcheckId]   
  LEFT JOIN [dbo].Config_TMCenter ON [dbo].Config_TMCenter.CenterId = [dbo].[TMUsersAppointmentsInfo].CenterId   
  INNER JOIN Lkp_Cities On Lkp_Cities.CityId=[HospitalInfo].CityId  
  WHERE [AppointmentDate] BETWEEN @FDate AND @TDate AND ConfirmStatus=1  AND                                    
  VisitStatus = 1 AND (IsCancelled = 0 OR IsCancelled IS NULL) AND (CancelledStatus = 0 OR CancelledStatus IS NULL) AND [PatientId] = @PatientId        
  ORDER BY [dbo].TMUsersAppointmentsInfo.[AppointmentDate] DESC  
 END                                  
-- Cancelled                                    
 ELSE IF @StatusId = 2                                    
 BEGIN   
  SELECT [dbo].[TMUsersAppointmentsInfo].[TMAppointmentId],ISNULL(Config_TMCenter.CenterId,0) AS CenterId ,ISNULL(Config_TMCenter.Center,'') AS Center,   
  ISNULL([dbo].fn_IsDateExpired(ConfirmedAppointmentDate,ConfirmedSlotTime),0) As IsdateExpired,     
  isnull([dbo].[TMUsersAppointmentsInfo].[UAID],'') AS UAID ,                       
  [dbo].[TMUsersAppointmentsInfo].[PatientName],                      
  [dbo].[TMUsersAppointmentsInfo].[MobileNumber],                      
  [dbo].[TMUsersAppointmentsInfo].[EmailId],                      
  [dbo].[TMUsersAppointmentsInfo].[PatientMode],                      
  [dbo].[TMUsersAppointmentsInfo].[Speciality],                      
  [dbo].[TMUsersAppointmentsInfo].[TMSpecialityRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[Doctor],                      
  [dbo].[TMUsersAppointmentsInfo].[TMDoctorRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[SlotTime],                      
  [dbo].[TMUsersAppointmentsInfo].[TMRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[ConfirmStatus],                      
  [dbo].[TMUsersAppointmentsInfo].[VisitStatus],                      
  [dbo].[TMUsersAppointmentsInfo].[CancelledStatus],                      
  [dbo].[TMUsersAppointmentsInfo].[CreatedBy],                      
  isnull([dbo].[TMUsersAppointmentsInfo].[HuserRemarks],'') As [HuserRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[AppointmentTypeId],                      
  [dbo].[TMUsersAppointmentsInfo].[UHID],                      
  [dbo].[TMUsersAppointmentsInfo].[HealthcheckId],                      
  [dbo].[TMUsersAppointmentsInfo].[HospitalId],                      
  dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[CreatedOn],103),'DD/MM/YYYY') As [BookedDate],                                                    
  dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[AppointmentDate],103),'DD/MM/YYYY') AS [AppointmentDate],                                                      
  isnull(dbo.fn_titlecase([Lkp_SpecialitiesInfo].[Speciality]),'') AS [SpecialityName],                                  
  isnull(dbo.fn_titlecase([DocDetails].[FirstName] +' '+ [DocDetails].[LastName]),'')AS [DoctorName],                      
  dbo.fn_titlecase([HospitalInfo].[HospitalName]) AS [HospitalName],                       
  dbo.fn_titlecase([dbo].[UserInfo].[FirstName] +' '+ [dbo].[UserInfo].[LastName]) As [BookedBy],                                                    
  dbo.fn_IsDateExpired([dbo].[TMUsersAppointmentsInfo].[AppointmentDate], [dbo].[TMUsersAppointmentsInfo].[SlotTime]) As IsdateExpired,              
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityId],'0') AS [ConfirmedSpecialityId],              
  isnull(dbo.fn_titlecase([ConfirmSpecialitiesInfo].[Speciality]),'') AS [ConfirmedSpecialityName],               
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityRemarks],'') As [ConfirmedSpecialityRemarks],               
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorId],'0') AS [ConfirmedDoctorId],              
  isnull(dbo.fn_titlecase([ConfirmedDocDetails].[FirstName] +' '+ [ConfirmedDocDetails].[LastName]),'')AS [ConfirmedDoctorName],               
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorRemarks],'') As [ConfirmedDoctorRemarks],               
  isnull(dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[ConfirmedAppointmentDate],103),'DD/MM/YYYY'),'') AS [ConfirmedAppointmentDate],                
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSlotTime],'') AS [ConfirmedSlotTime],            
  isnull([dbo].[TMUsersAppointmentsInfo].[SalutationId],'0') AS [SalutationId],            
  isnull([dbo].[Lkp_Salutation].[Salutation],'') AS [Salutation],            
  isnull([dbo].[TMUsersAppointmentsInfo].[Age],'0') AS [Age],            
  isnull([dbo].[TMUsersAppointmentsInfo].[Gender],'0') AS [Gender],          
  isnull(convert(char(8),[dbo].[TMUsersAppointmentsInfo].[CreatedOn], 108),'') AS [BookedTime] ,  
  isnull([dbo].Lkp_Cities.CityName,'0') AS [CityName]           
  FROM [dbo].[TMUsersAppointmentsInfo] WITH (NOLOCK)                                                       
  LEFT JOIN [dbo].[HospitalInfo] WITH (NOLOCK) ON [dbo].[HospitalInfo].[HospitalId] = [dbo].[TMUsersAppointmentsInfo].[HospitalId]                                                    
  LEFT JOIN [dbo].[Lkp_Salutation] WITH (NOLOCK) ON [dbo].[Lkp_Salutation].[SalutationId] = [dbo].[TMUsersAppointmentsInfo].[SalutationId]            
  LEFT JOIN [dbo].[Lkp_SpecialitiesInfo] WITH (NOLOCK) ON [dbo].[Lkp_SpecialitiesInfo].[SpecialityId] = [dbo].[TMUsersAppointmentsInfo].[Speciality]               
  LEFT JOIN [dbo].[Lkp_SpecialitiesInfo] As ConfirmSpecialitiesInfo WITH (NOLOCK) ON [ConfirmSpecialitiesInfo].[SpecialityId] = [dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityId]                                                  
  LEFT JOIN [dbo].[UserInfo] As  DocDetails WITH (NOLOCK) ON [DocDetails].[UserId] = [dbo].[TMUsersAppointmentsInfo].[Doctor]                 
  LEFT JOIN [dbo].[UserInfo] As  ConfirmedDocDetails WITH (NOLOCK) ON [ConfirmedDocDetails].[UserId] = [dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorId]                     
  LEFT JOIN [dbo].[UserInfo] WITH (NOLOCK) ON [dbo].[UserInfo].[UserId] = [dbo].[TMUsersAppointmentsInfo].[CreatedBy]                       
  LEFT JOIN [dbo].[Config_HealthCheckInfo] ON [dbo].[Config_HealthCheckInfo].[HealthCheckId] = [dbo].[TMUsersAppointmentsInfo].[HealthcheckId]   
  LEFT JOIN [dbo].Config_TMCenter ON [dbo].Config_TMCenter.CenterId = [dbo].[TMUsersAppointmentsInfo].CenterId
  INNER JOIN Lkp_Cities On Lkp_Cities.CityId=[HospitalInfo].CityId  
  WHERE [AppointmentDate] BETWEEN @FDate AND @TDate AND ConfirmStatus=1 AND                                    
  ([IsCancelled] = 1 OR CancelledStatus = 1 ) AND ( [VisitStatus] = 0 OR [VisitStatus] IS NULL) AND [PatientId] = @PatientId                                    
  ORDER BY [dbo].TMUsersAppointmentsInfo.[AppointmentDate] DESC  
 END   
--Not Visited                                    
 ELSE IF @StatusId = 3                                    
 BEGIN   
  SELECT [dbo].[TMUsersAppointmentsInfo].[TMAppointmentId],ISNULL(Config_TMCenter.CenterId,0) AS CenterId ,ISNULL(Config_TMCenter.Center,'') AS Center,   
  ISNULL([dbo].fn_IsDateExpired(ConfirmedAppointmentDate,ConfirmedSlotTime),0) As IsdateExpired,     
  isnull([dbo].[TMUsersAppointmentsInfo].[UAID],'') AS UAID ,                       
  [dbo].[TMUsersAppointmentsInfo].[PatientName],                      
  [dbo].[TMUsersAppointmentsInfo].[MobileNumber],                      
  [dbo].[TMUsersAppointmentsInfo].[EmailId],                      
  [dbo].[TMUsersAppointmentsInfo].[PatientMode],                      
  [dbo].[TMUsersAppointmentsInfo].[Speciality],                      
  [dbo].[TMUsersAppointmentsInfo].[TMSpecialityRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[Doctor],                      
  [dbo].[TMUsersAppointmentsInfo].[TMDoctorRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[SlotTime],                      
  [dbo].[TMUsersAppointmentsInfo].[TMRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[ConfirmStatus],                      
  [dbo].[TMUsersAppointmentsInfo].[VisitStatus],                      
  [dbo].[TMUsersAppointmentsInfo].[CancelledStatus],                      
  [dbo].[TMUsersAppointmentsInfo].[CreatedBy],                      
  isnull([dbo].[TMUsersAppointmentsInfo].[HuserRemarks],'') As [HuserRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[AppointmentTypeId],                      
  [dbo].[TMUsersAppointmentsInfo].[UHID],                      
  [dbo].[TMUsersAppointmentsInfo].[HealthcheckId],                      
  [dbo].[TMUsersAppointmentsInfo].[HospitalId],                      
  dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[CreatedOn],103),'DD/MM/YYYY') As [BookedDate],                                                    
  dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[AppointmentDate],103),'DD/MM/YYYY') AS [AppointmentDate],                                                      
  isnull(dbo.fn_titlecase([Lkp_SpecialitiesInfo].[Speciality]),'') AS [SpecialityName],                                  
  isnull(dbo.fn_titlecase([DocDetails].[FirstName] +' '+ [DocDetails].[LastName]),'')AS [DoctorName],                      
  dbo.fn_titlecase([HospitalInfo].[HospitalName]) AS [HospitalName],                       
  dbo.fn_titlecase([dbo].[UserInfo].[FirstName] +' '+ [dbo].[UserInfo].[LastName]) As [BookedBy],                                                    
  dbo.fn_IsDateExpired([dbo].[TMUsersAppointmentsInfo].[AppointmentDate], [dbo].[TMUsersAppointmentsInfo].[SlotTime]) As IsdateExpired,              
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityId],'0') AS [ConfirmedSpecialityId],              
  isnull(dbo.fn_titlecase([ConfirmSpecialitiesInfo].[Speciality]),'') AS [ConfirmedSpecialityName],               
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityRemarks],'') As [ConfirmedSpecialityRemarks],               
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorId],'0') AS [ConfirmedDoctorId],              
  isnull(dbo.fn_titlecase([ConfirmedDocDetails].[FirstName] +' '+ [ConfirmedDocDetails].[LastName]),'')AS [ConfirmedDoctorName],               
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorRemarks],'') As [ConfirmedDoctorRemarks],               
  isnull(dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[ConfirmedAppointmentDate],103),'DD/MM/YYYY'),'') AS [ConfirmedAppointmentDate],                
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSlotTime],'') AS [ConfirmedSlotTime],            
  isnull([dbo].[TMUsersAppointmentsInfo].[SalutationId],'0') AS [SalutationId],            
  isnull([dbo].[Lkp_Salutation].[Salutation],'') AS [Salutation],            
  isnull([dbo].[TMUsersAppointmentsInfo].[Age],'0') AS [Age],            
  isnull([dbo].[TMUsersAppointmentsInfo].[Gender],'0') AS [Gender],          
  isnull(convert(char(8),[dbo].[TMUsersAppointmentsInfo].[CreatedOn], 108),'') AS [BookedTime] ,  
  isnull([dbo].Lkp_Cities.CityName,'0') AS [CityName]          
  FROM [dbo].[TMUsersAppointmentsInfo] WITH (NOLOCK)                                                       
  LEFT JOIN [dbo].[HospitalInfo] WITH (NOLOCK) ON [dbo].[HospitalInfo].[HospitalId] = [dbo].[TMUsersAppointmentsInfo].[HospitalId]                                                    
  LEFT JOIN [dbo].[Lkp_Salutation] WITH (NOLOCK) ON [dbo].[Lkp_Salutation].[SalutationId] = [dbo].[TMUsersAppointmentsInfo].[SalutationId]            
  LEFT JOIN [dbo].[Lkp_SpecialitiesInfo] WITH (NOLOCK) ON [dbo].[Lkp_SpecialitiesInfo].[SpecialityId] = [dbo].[TMUsersAppointmentsInfo].[Speciality]               
  LEFT JOIN [dbo].[Lkp_SpecialitiesInfo] As ConfirmSpecialitiesInfo WITH (NOLOCK) ON [ConfirmSpecialitiesInfo].[SpecialityId] = [dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityId]                                                  
  LEFT JOIN [dbo].[UserInfo] As  DocDetails WITH (NOLOCK) ON [DocDetails].[UserId] = [dbo].[TMUsersAppointmentsInfo].[Doctor]                 
  LEFT JOIN [dbo].[UserInfo] As  ConfirmedDocDetails WITH (NOLOCK) ON [ConfirmedDocDetails].[UserId] = [dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorId]                     
  LEFT JOIN [dbo].[UserInfo] WITH (NOLOCK) ON [dbo].[UserInfo].[UserId] = [dbo].[TMUsersAppointmentsInfo].[CreatedBy]                       
  LEFT JOIN [dbo].[Config_HealthCheckInfo] ON [dbo].[Config_HealthCheckInfo].[HealthCheckId] = [dbo].[TMUsersAppointmentsInfo].[HealthcheckId]   
  LEFT JOIN [dbo].Config_TMCenter ON [dbo].Config_TMCenter.CenterId = [dbo].[TMUsersAppointmentsInfo].CenterId
  INNER JOIN Lkp_Cities On Lkp_Cities.CityId=[HospitalInfo].CityId  
  WHERE [AppointmentDate] BETWEEN @FDate AND @TDate AND ConfirmStatus=1  AND                                    
     [VisitStatus] = 0 AND ([IsCancelled] = 0 OR [IsCancelled] IS NULL)  AND (CancelledStatus = 0 OR CancelledStatus IS NULL)  AND [PatientId] = @PatientId         
     AND [AppointmentDate] < getdate()      
     ORDER BY [dbo].TMUsersAppointmentsInfo.[AppointmentDate] DESC   
 END  
--Scheduled                                    
 ELSE IF @StatusId = 4                                    
 BEGIN   
  SELECT [dbo].[TMUsersAppointmentsInfo].[TMAppointmentId],ISNULL(Config_TMCenter.CenterId,0) AS CenterId ,ISNULL(Config_TMCenter.Center,'') AS Center,   
  ISNULL([dbo].fn_IsDateExpired(ConfirmedAppointmentDate,ConfirmedSlotTime),0) As IsdateExpired,     
  isnull([dbo].[TMUsersAppointmentsInfo].[UAID],'') AS UAID ,                       
  [dbo].[TMUsersAppointmentsInfo].[PatientName],                      
  [dbo].[TMUsersAppointmentsInfo].[MobileNumber],                      
  [dbo].[TMUsersAppointmentsInfo].[EmailId],                      
  [dbo].[TMUsersAppointmentsInfo].[PatientMode],                      
  [dbo].[TMUsersAppointmentsInfo].[Speciality],                      
  [dbo].[TMUsersAppointmentsInfo].[TMSpecialityRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[Doctor],                      
  [dbo].[TMUsersAppointmentsInfo].[TMDoctorRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[SlotTime],                      
  [dbo].[TMUsersAppointmentsInfo].[TMRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[ConfirmStatus],                      
  [dbo].[TMUsersAppointmentsInfo].[VisitStatus],                      
  [dbo].[TMUsersAppointmentsInfo].[CancelledStatus],                      
  [dbo].[TMUsersAppointmentsInfo].[CreatedBy],                      
  isnull([dbo].[TMUsersAppointmentsInfo].[HuserRemarks],'') As [HuserRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[AppointmentTypeId],                      
  [dbo].[TMUsersAppointmentsInfo].[UHID],                      
  [dbo].[TMUsersAppointmentsInfo].[HealthcheckId],                      
  [dbo].[TMUsersAppointmentsInfo].[HospitalId],                      
  dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[CreatedOn],103),'DD/MM/YYYY') As [BookedDate],                                                    
  dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[AppointmentDate],103),'DD/MM/YYYY') AS [AppointmentDate],                                                      
  isnull(dbo.fn_titlecase([Lkp_SpecialitiesInfo].[Speciality]),'') AS [SpecialityName],                                  
  isnull(dbo.fn_titlecase([DocDetails].[FirstName] +' '+ [DocDetails].[LastName]),'')AS [DoctorName],                      
  dbo.fn_titlecase([HospitalInfo].[HospitalName]) AS [HospitalName],                       
  dbo.fn_titlecase([dbo].[UserInfo].[FirstName] +' '+ [dbo].[UserInfo].[LastName]) As [BookedBy],                                                    
  dbo.fn_IsDateExpired([dbo].[TMUsersAppointmentsInfo].[AppointmentDate], [dbo].[TMUsersAppointmentsInfo].[SlotTime]) As IsdateExpired,              
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityId],'0') AS [ConfirmedSpecialityId],              
  isnull(dbo.fn_titlecase([ConfirmSpecialitiesInfo].[Speciality]),'') AS [ConfirmedSpecialityName],               
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityRemarks],'') As [ConfirmedSpecialityRemarks],               
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorId],'0') AS [ConfirmedDoctorId],              
  isnull(dbo.fn_titlecase([ConfirmedDocDetails].[FirstName] +' '+ [ConfirmedDocDetails].[LastName]),'')AS [ConfirmedDoctorName],               
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorRemarks],'') As [ConfirmedDoctorRemarks],               
  isnull(dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[ConfirmedAppointmentDate],103),'DD/MM/YYYY'),'') AS [ConfirmedAppointmentDate],                
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSlotTime],'') AS [ConfirmedSlotTime],            
  isnull([dbo].[TMUsersAppointmentsInfo].[SalutationId],'0') AS [SalutationId],            
  isnull([dbo].[Lkp_Salutation].[Salutation],'') AS [Salutation],            
  isnull([dbo].[TMUsersAppointmentsInfo].[Age],'0') AS [Age],            
  isnull([dbo].[TMUsersAppointmentsInfo].[Gender],'0') AS [Gender],          
  isnull(convert(char(8),[dbo].[TMUsersAppointmentsInfo].[CreatedOn], 108),'') AS [BookedTime],   
  isnull([dbo].Lkp_Cities.CityName,'0') AS [CityName]            
  FROM [dbo].[TMUsersAppointmentsInfo] WITH (NOLOCK)                                                       
  LEFT JOIN [dbo].[HospitalInfo] WITH (NOLOCK) ON [dbo].[HospitalInfo].[HospitalId] = [dbo].[TMUsersAppointmentsInfo].[HospitalId]                                                    
  LEFT JOIN [dbo].[Lkp_Salutation] WITH (NOLOCK) ON [dbo].[Lkp_Salutation].[SalutationId] = [dbo].[TMUsersAppointmentsInfo].[SalutationId]            
  LEFT JOIN [dbo].[Lkp_SpecialitiesInfo] WITH (NOLOCK) ON [dbo].[Lkp_SpecialitiesInfo].[SpecialityId] = [dbo].[TMUsersAppointmentsInfo].[Speciality]               
  LEFT JOIN [dbo].[Lkp_SpecialitiesInfo] As ConfirmSpecialitiesInfo WITH (NOLOCK) ON [ConfirmSpecialitiesInfo].[SpecialityId] = [dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityId]                                                  
  LEFT JOIN [dbo].[UserInfo] As  DocDetails WITH (NOLOCK) ON [DocDetails].[UserId] = [dbo].[TMUsersAppointmentsInfo].[Doctor]                 
  LEFT JOIN [dbo].[UserInfo] As  ConfirmedDocDetails WITH (NOLOCK) ON [ConfirmedDocDetails].[UserId] = [dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorId]                     
  LEFT JOIN [dbo].[UserInfo] WITH (NOLOCK) ON [dbo].[UserInfo].[UserId] = [dbo].[TMUsersAppointmentsInfo].[CreatedBy]                       
  LEFT JOIN [dbo].[Config_HealthCheckInfo] ON [dbo].[Config_HealthCheckInfo].[HealthCheckId] = [dbo].[TMUsersAppointmentsInfo].[HealthcheckId]   
  LEFT JOIN [dbo].Config_TMCenter ON [dbo].Config_TMCenter.CenterId = [dbo].[TMUsersAppointmentsInfo].CenterId
  INNER JOIN Lkp_Cities On Lkp_Cities.CityId=[HospitalInfo].CityId  
  WHERE [AppointmentDate] BETWEEN @FDate AND @TDate AND ConfirmStatus=1  AND                                    
  ([VisitStatus] IS NULL ) AND ([IsCancelled] = 0 OR [IsCancelled] IS NULL) AND   
  (CancelledStatus = 0 OR CancelledStatus IS NULL) AND   
  [PatientId] = @PatientId         
  ORDER BY [dbo].TMUsersAppointmentsInfo.[AppointmentDate] DESC  
 END  
--Need to Be Confirm or Not Confimed                    
 ELSE IF @StatusId = 5       
 BEGIN    
  SELECT [dbo].[TMUsersAppointmentsInfo].[TMAppointmentId],ISNULL(Config_TMCenter.CenterId,0) AS CenterId ,ISNULL(Config_TMCenter.Center,'') AS Center,   
  ISNULL([dbo].fn_IsDateExpired(ConfirmedAppointmentDate,ConfirmedSlotTime),0) As IsdateExpired,     
  isnull([dbo].[TMUsersAppointmentsInfo].[UAID],'') AS UAID ,                       
  [dbo].[TMUsersAppointmentsInfo].[PatientName],                      
  [dbo].[TMUsersAppointmentsInfo].[MobileNumber],                      
  [dbo].[TMUsersAppointmentsInfo].[EmailId],                      
  [dbo].[TMUsersAppointmentsInfo].[PatientMode],                      
  [dbo].[TMUsersAppointmentsInfo].[Speciality],                      
  [dbo].[TMUsersAppointmentsInfo].[TMSpecialityRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[Doctor],                      
  [dbo].[TMUsersAppointmentsInfo].[TMDoctorRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[SlotTime],                      
  [dbo].[TMUsersAppointmentsInfo].[TMRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[ConfirmStatus],                      
  [dbo].[TMUsersAppointmentsInfo].[VisitStatus],                      
  [dbo].[TMUsersAppointmentsInfo].[CancelledStatus],                      
  [dbo].[TMUsersAppointmentsInfo].[CreatedBy],                      
  isnull([dbo].[TMUsersAppointmentsInfo].[HuserRemarks],'') As [HuserRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[AppointmentTypeId],                      
  [dbo].[TMUsersAppointmentsInfo].[UHID],                      
  [dbo].[TMUsersAppointmentsInfo].[HealthcheckId],                      
  [dbo].[TMUsersAppointmentsInfo].[HospitalId],                      
  dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[CreatedOn],103),'DD/MM/YYYY') As [BookedDate],                                                    
  dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[AppointmentDate],103),'DD/MM/YYYY') AS [AppointmentDate],                                                      
  isnull(dbo.fn_titlecase([Lkp_SpecialitiesInfo].[Speciality]),'') AS [SpecialityName],                                  
  isnull(dbo.fn_titlecase([DocDetails].[FirstName] +' '+ [DocDetails].[LastName]),'')AS [DoctorName],                      
  dbo.fn_titlecase([HospitalInfo].[HospitalName]) AS [HospitalName],                       
  dbo.fn_titlecase([dbo].[UserInfo].[FirstName] +' '+ [dbo].[UserInfo].[LastName]) As [BookedBy],                                  
  dbo.fn_IsDateExpired([dbo].[TMUsersAppointmentsInfo].[AppointmentDate], [dbo].[TMUsersAppointmentsInfo].[SlotTime]) As IsdateExpired,              
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityId],'0') AS [ConfirmedSpecialityId],              
  isnull(dbo.fn_titlecase([ConfirmSpecialitiesInfo].[Speciality]),'') AS [ConfirmedSpecialityName],               
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityRemarks],'') As [ConfirmedSpecialityRemarks],               
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorId],'0') AS [ConfirmedDoctorId],              
  isnull(dbo.fn_titlecase([ConfirmedDocDetails].[FirstName] +' '+ [ConfirmedDocDetails].[LastName]),'')AS [ConfirmedDoctorName],               
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorRemarks],'') As [ConfirmedDoctorRemarks],               
  isnull(dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[ConfirmedAppointmentDate],103),'DD/MM/YYYY'),'') AS [ConfirmedAppointmentDate],                
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSlotTime],'') AS [ConfirmedSlotTime],            
  isnull([dbo].[TMUsersAppointmentsInfo].[SalutationId],'0') AS [SalutationId],            
  isnull([dbo].[Lkp_Salutation].[Salutation],'') AS [Salutation],            
  isnull([dbo].[TMUsersAppointmentsInfo].[Age],'0') AS [Age],            
  isnull([dbo].[TMUsersAppointmentsInfo].[Gender],'0') AS [Gender],          
  isnull(convert(char(8),[dbo].[TMUsersAppointmentsInfo].[CreatedOn], 108),'') AS [BookedTime] ,  
  isnull([dbo].Lkp_Cities.CityName,'0') AS [CityName]           
  FROM [dbo].[TMUsersAppointmentsInfo] WITH (NOLOCK)                                                       
  LEFT JOIN [dbo].[HospitalInfo] WITH (NOLOCK) ON [dbo].[HospitalInfo].[HospitalId] = [dbo].[TMUsersAppointmentsInfo].[HospitalId]                                                    
  LEFT JOIN [dbo].[Lkp_Salutation] WITH (NOLOCK) ON [dbo].[Lkp_Salutation].[SalutationId] = [dbo].[TMUsersAppointmentsInfo].[SalutationId]            
  LEFT JOIN [dbo].[Lkp_SpecialitiesInfo] WITH (NOLOCK) ON [dbo].[Lkp_SpecialitiesInfo].[SpecialityId] = [dbo].[TMUsersAppointmentsInfo].[Speciality]               
  LEFT JOIN [dbo].[Lkp_SpecialitiesInfo] As ConfirmSpecialitiesInfo WITH (NOLOCK) ON [ConfirmSpecialitiesInfo].[SpecialityId] = [dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityId]                                                  
  LEFT JOIN [dbo].[UserInfo] As  DocDetails WITH (NOLOCK) ON [DocDetails].[UserId] = [dbo].[TMUsersAppointmentsInfo].[Doctor]                 
  LEFT JOIN [dbo].[UserInfo] As  ConfirmedDocDetails WITH (NOLOCK) ON [ConfirmedDocDetails].[UserId] = [dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorId]                     
  LEFT JOIN [dbo].[UserInfo] WITH (NOLOCK) ON [dbo].[UserInfo].[UserId] = [dbo].[TMUsersAppointmentsInfo].[CreatedBy]                       
  LEFT JOIN [dbo].[Config_HealthCheckInfo] ON [dbo].[Config_HealthCheckInfo].[HealthCheckId] = [dbo].[TMUsersAppointmentsInfo].[HealthcheckId]   
  LEFT JOIN [dbo].Config_TMCenter ON [dbo].Config_TMCenter.CenterId = [dbo].[TMUsersAppointmentsInfo].CenterId
  INNER JOIN Lkp_Cities On Lkp_Cities.CityId=[HospitalInfo].CityId  
  WHERE [AppointmentDate] BETWEEN @FDate AND @TDate AND  (ConfirmStatus= 0 OR ConfirmStatus IS NULL)  AND                                    
  ([VisitStatus] = 0 OR [VisitStatus] IS NULL ) AND ([IsCancelled] = 0 OR [IsCancelled] IS NULL) AND   
  (CancelledStatus = 0 OR CancelledStatus IS NULL) AND  
  [PatientId] = @PatientId         
  ORDER BY [dbo].TMUsersAppointmentsInfo.[AppointmentDate] DESC   
 END   
--Need to Be Confirm or Not Confimed                    
 ELSE IF @StatusId = 6                                    
 BEGIN   
  SELECT [dbo].[TMUsersAppointmentsInfo].[TMAppointmentId], ISNULL(Config_TMCenter.CenterId,0) AS CenterId ,ISNULL(Config_TMCenter.Center,'') AS Center,  
  ISNULL([dbo].fn_IsDateExpired(ConfirmedAppointmentDate,ConfirmedSlotTime),0) As IsdateExpired,     
  isnull([dbo].[TMUsersAppointmentsInfo].[UAID],'') AS UAID ,                       
  [dbo].[TMUsersAppointmentsInfo].[PatientName],                      
  [dbo].[TMUsersAppointmentsInfo].[MobileNumber],                      
  [dbo].[TMUsersAppointmentsInfo].[EmailId],                      
  [dbo].[TMUsersAppointmentsInfo].[PatientMode],                      
  [dbo].[TMUsersAppointmentsInfo].[Speciality],                      
  [dbo].[TMUsersAppointmentsInfo].[TMSpecialityRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[Doctor],                      
  [dbo].[TMUsersAppointmentsInfo].[TMDoctorRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[SlotTime],                      
  [dbo].[TMUsersAppointmentsInfo].[TMRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[ConfirmStatus],                      
  [dbo].[TMUsersAppointmentsInfo].[VisitStatus],                      
  [dbo].[TMUsersAppointmentsInfo].[CancelledStatus],                      
  [dbo].[TMUsersAppointmentsInfo].[CreatedBy],                      
  isnull([dbo].[TMUsersAppointmentsInfo].[HuserRemarks],'') As [HuserRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[AppointmentTypeId],                      
  [dbo].[TMUsersAppointmentsInfo].[UHID],                      
  [dbo].[TMUsersAppointmentsInfo].[HealthcheckId],                      
  [dbo].[TMUsersAppointmentsInfo].[HospitalId],                      
  dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[CreatedOn],103),'DD/MM/YYYY') As [BookedDate],                                                    
  dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[AppointmentDate],103),'DD/MM/YYYY') AS [AppointmentDate],                                                      
  isnull(dbo.fn_titlecase([Lkp_SpecialitiesInfo].[Speciality]),'') AS [SpecialityName],                                  
  isnull(dbo.fn_titlecase([DocDetails].[FirstName] +' '+ [DocDetails].[LastName]),'')AS [DoctorName],                      
  dbo.fn_titlecase([HospitalInfo].[HospitalName]) AS [HospitalName],                       
  dbo.fn_titlecase([dbo].[UserInfo].[FirstName] +' '+ [dbo].[UserInfo].[LastName]) As [BookedBy],                                                    
  dbo.fn_IsDateExpired([dbo].[TMUsersAppointmentsInfo].[AppointmentDate], [dbo].[TMUsersAppointmentsInfo].[SlotTime]) As IsdateExpired,              
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityId],'0') AS [ConfirmedSpecialityId],              
  isnull(dbo.fn_titlecase([ConfirmSpecialitiesInfo].[Speciality]),'') AS [ConfirmedSpecialityName],               
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityRemarks],'') As [ConfirmedSpecialityRemarks],               
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorId],'0') AS [ConfirmedDoctorId],              
  isnull(dbo.fn_titlecase([ConfirmedDocDetails].[FirstName] +' '+ [ConfirmedDocDetails].[LastName]),'')AS [ConfirmedDoctorName],               
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorRemarks],'') As [ConfirmedDoctorRemarks],               
  isnull(dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[ConfirmedAppointmentDate],103),'DD/MM/YYYY'),'') AS [ConfirmedAppointmentDate],                
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSlotTime],'') AS [ConfirmedSlotTime],            
  isnull([dbo].[TMUsersAppointmentsInfo].[SalutationId],'0') AS [SalutationId],            
  isnull([dbo].[Lkp_Salutation].[Salutation],'') AS [Salutation],            
  isnull([dbo].[TMUsersAppointmentsInfo].[Age],'0') AS [Age],            
  isnull([dbo].[TMUsersAppointmentsInfo].[Gender],'0') AS [Gender],          
  isnull(convert(char(8),[dbo].[TMUsersAppointmentsInfo].[CreatedOn], 108),'') AS [BookedTime] ,  
  isnull([dbo].Lkp_Cities.CityName,'0') AS [CityName]            
  FROM [dbo].[TMUsersAppointmentsInfo] WITH (NOLOCK)                                                       
  LEFT JOIN [dbo].[HospitalInfo] WITH (NOLOCK) ON [dbo].[HospitalInfo].[HospitalId] = [dbo].[TMUsersAppointmentsInfo].[HospitalId]                  
  LEFT JOIN [dbo].[Lkp_Salutation] WITH (NOLOCK) ON [dbo].[Lkp_Salutation].[SalutationId] = [dbo].[TMUsersAppointmentsInfo].[SalutationId]            
  LEFT JOIN [dbo].[Lkp_SpecialitiesInfo] WITH (NOLOCK) ON [dbo].[Lkp_SpecialitiesInfo].[SpecialityId] = [dbo].[TMUsersAppointmentsInfo].[Speciality]               
  LEFT JOIN [dbo].[Lkp_SpecialitiesInfo] As ConfirmSpecialitiesInfo WITH (NOLOCK) ON [ConfirmSpecialitiesInfo].[SpecialityId] = [dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityId]                                                  
  LEFT JOIN [dbo].[UserInfo] As  DocDetails WITH (NOLOCK) ON [DocDetails].[UserId] = [dbo].[TMUsersAppointmentsInfo].[Doctor]                 
  LEFT JOIN [dbo].[UserInfo] As  ConfirmedDocDetails WITH (NOLOCK) ON [ConfirmedDocDetails].[UserId] = [dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorId]                     
  LEFT JOIN [dbo].[UserInfo] WITH (NOLOCK) ON [dbo].[UserInfo].[UserId] = [dbo].[TMUsersAppointmentsInfo].[CreatedBy]                       
  LEFT JOIN [dbo].[Config_HealthCheckInfo] ON [dbo].[Config_HealthCheckInfo].[HealthCheckId] = [dbo].[TMUsersAppointmentsInfo].[HealthcheckId]   
  LEFT JOIN [dbo].Config_TMCenter ON [dbo].Config_TMCenter.CenterId = [dbo].[TMUsersAppointmentsInfo].CenterId
  INNER JOIN Lkp_Cities On Lkp_Cities.CityId=[HospitalInfo].CityId  
  WHERE [AppointmentDate] BETWEEN @FDate AND @TDate AND  (ConfirmStatus= 0 OR ConfirmStatus IS NULL)  AND                                    
  ([IsCancelled] = 1 OR ConfirmStatus =1 ) AND ( [VisitStatus] = 0 OR [VisitStatus] IS NULL) AND [PatientId] = @PatientId         
  ORDER BY [dbo].TMUsersAppointmentsInfo.[AppointmentDate] DESC  
 END  
   
 ELSE                                     
 BEGIN     
  SELECT [dbo].[TMUsersAppointmentsInfo].[TMAppointmentId],ISNULL(Config_TMCenter.CenterId,0) AS CenterId ,ISNULL(Config_TMCenter.Center,'') AS Center,   
  ISNULL([dbo].fn_IsDateExpired(ConfirmedAppointmentDate,ConfirmedSlotTime),0) As IsdateExpired,     
  isnull([dbo].[TMUsersAppointmentsInfo].[UAID],'') AS UAID ,                       
  [dbo].[TMUsersAppointmentsInfo].[PatientName],                      
  [dbo].[TMUsersAppointmentsInfo].[MobileNumber],                      
  [dbo].[TMUsersAppointmentsInfo].[EmailId],                      
  [dbo].[TMUsersAppointmentsInfo].[PatientMode],                      
  [dbo].[TMUsersAppointmentsInfo].[Speciality],                      
  [dbo].[TMUsersAppointmentsInfo].[TMSpecialityRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[Doctor],                      
  [dbo].[TMUsersAppointmentsInfo].[TMDoctorRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[SlotTime],                      
  [dbo].[TMUsersAppointmentsInfo].[TMRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[ConfirmStatus],                      
  [dbo].[TMUsersAppointmentsInfo].[VisitStatus],                      
  [dbo].[TMUsersAppointmentsInfo].[CancelledStatus],                      
  [dbo].[TMUsersAppointmentsInfo].[CreatedBy],                      
  isnull([dbo].[TMUsersAppointmentsInfo].[HuserRemarks],'') As [HuserRemarks],                      
  [dbo].[TMUsersAppointmentsInfo].[AppointmentTypeId],                      
  [dbo].[TMUsersAppointmentsInfo].[UHID],                      
  [dbo].[TMUsersAppointmentsInfo].[HealthcheckId],                      
  [dbo].[TMUsersAppointmentsInfo].[HospitalId],                      
  dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[CreatedOn],103),'DD/MM/YYYY') As [BookedDate],                                                    
  dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[AppointmentDate],103),'DD/MM/YYYY') AS [AppointmentDate],                                                      
  isnull(dbo.fn_titlecase([Lkp_SpecialitiesInfo].[Speciality]),'') AS [SpecialityName],                                  
  isnull(dbo.fn_titlecase([DocDetails].[FirstName] +' '+ [DocDetails].[LastName]),'')AS [DoctorName],                      
  dbo.fn_titlecase([HospitalInfo].[HospitalName]) AS [HospitalName],                       
  dbo.fn_titlecase([dbo].[UserInfo].[FirstName] +' '+ [dbo].[UserInfo].[LastName]) As [BookedBy],                                                    
  dbo.fn_IsDateExpired([dbo].[TMUsersAppointmentsInfo].[AppointmentDate], [dbo].[TMUsersAppointmentsInfo].[SlotTime]) As IsdateExpired,              
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityId],'0') AS [ConfirmedSpecialityId],              
  isnull(dbo.fn_titlecase([ConfirmSpecialitiesInfo].[Speciality]),'') AS [ConfirmedSpecialityName],               
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityRemarks],'') As [ConfirmedSpecialityRemarks],               
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorId],'0') AS [ConfirmedDoctorId],              
  isnull(dbo.fn_titlecase([ConfirmedDocDetails].[FirstName] +' '+ [ConfirmedDocDetails].[LastName]),'')AS [ConfirmedDoctorName],               
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorRemarks],'') As [ConfirmedDoctorRemarks],               
  isnull(dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[ConfirmedAppointmentDate],103),'DD/MM/YYYY'),'') AS [ConfirmedAppointmentDate],                
  isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSlotTime],'') AS [ConfirmedSlotTime],            
  isnull([dbo].[TMUsersAppointmentsInfo].[SalutationId],'0') AS [SalutationId],            
  isnull([dbo].[Lkp_Salutation].[Salutation],'') AS [Salutation],            
  isnull([dbo].[TMUsersAppointmentsInfo].[Age],'0') AS [Age],            
  isnull([dbo].[TMUsersAppointmentsInfo].[Gender],'0') AS [Gender],          
  isnull(convert(char(8),[dbo].[TMUsersAppointmentsInfo].[CreatedOn], 108),'') AS [BookedTime] ,  
  isnull([dbo].Lkp_Cities.CityName,'0') AS [CityName]           
  FROM [dbo].[TMUsersAppointmentsInfo] WITH (NOLOCK)                                                       
  LEFT JOIN [dbo].[HospitalInfo] WITH (NOLOCK) ON [dbo].[HospitalInfo].[HospitalId] = [dbo].[TMUsersAppointmentsInfo].[HospitalId]                                                    
  LEFT JOIN [dbo].[Lkp_Salutation] WITH (NOLOCK) ON [dbo].[Lkp_Salutation].[SalutationId] = [dbo].[TMUsersAppointmentsInfo].[SalutationId]            
  LEFT JOIN [dbo].[Lkp_SpecialitiesInfo] WITH (NOLOCK) ON [dbo].[Lkp_SpecialitiesInfo].[SpecialityId] = [dbo].[TMUsersAppointmentsInfo].[Speciality]               
  LEFT JOIN [dbo].[Lkp_SpecialitiesInfo] As ConfirmSpecialitiesInfo WITH (NOLOCK) ON [ConfirmSpecialitiesInfo].[SpecialityId] = [dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityId]                                                  
  LEFT JOIN [dbo].[UserInfo] As  DocDetails WITH (NOLOCK) ON [DocDetails].[UserId] = [dbo].[TMUsersAppointmentsInfo].[Doctor]                 
  LEFT JOIN [dbo].[UserInfo] As  ConfirmedDocDetails WITH (NOLOCK) ON [ConfirmedDocDetails].[UserId] = [dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorId]                     
  LEFT JOIN [dbo].[UserInfo] WITH (NOLOCK) ON [dbo].[UserInfo].[UserId] = [dbo].[TMUsersAppointmentsInfo].[CreatedBy]                       
  LEFT JOIN [dbo].[Config_HealthCheckInfo] ON [dbo].[Config_HealthCheckInfo].[HealthCheckId] = [dbo].[TMUsersAppointmentsInfo].[HealthcheckId]   
  LEFT JOIN [dbo].Config_TMCenter ON [dbo].Config_TMCenter.CenterId = [dbo].[TMUsersAppointmentsInfo].CenterId
  INNER JOIN Lkp_Cities On Lkp_Cities.CityId=[HospitalInfo].CityId  
  WHERE [AppointmentDate] BETWEEN @FDate AND @TDate  AND [PatientId] = @PatientId         
  ORDER BY [dbo].TMUsersAppointmentsInfo.[AppointmentDate] DESC  
 END  
END

--*********************************************************************************

             
ALTER PROCEDURE Proc_GetTMUsersAppointments --1,2,'31/07/2013','07/08/2013',0,1,2                               
@HospitalId int,                                                                
@DateType int,                                                                
@FromDate varchar(100),                                                                
@ToDate varchar(100),                                                      
@BookedBy int,                                
@AppointmentTypeId int,  
@status int                                                                
AS                                                                
BEGIN                                                                
SET NOCOUNT ON                                                                
                                                                
DECLARE @SqlStr AS varchar(max)                                       
                                
--Assigning default vaues                                                                                
 SET @SqlStr=''                                                                       
                                                                
--Checking For Appointment Type                                                                 
                                  
IF @AppointmentTypeId = 1                                
BEGIN                                                                
SET @SqlStr=@SqlStr+ 'SELECT [dbo].[TMUsersAppointmentsInfo].[TMAppointmentId],[dbo].[TMUsersAppointmentsInfo].[PatientId],ISNULL(Config_TMCenter.CenterId,0) AS CenterId ,ISNULL(Config_TMCenter.Center,'''') AS Center,              
ISNULL([dbo].fn_IsDateExpired(ConfirmedAppointmentDate,ConfirmedSlotTime),0) As IsdateExpired,               
isnull([dbo].[TMUsersAppointmentsInfo].[UAID],'''') AS UAID ,                                 
[dbo].[TMUsersAppointmentsInfo].[PatientName],                                
[dbo].[TMUsersAppointmentsInfo].[MobileNumber],                                
[dbo].[TMUsersAppointmentsInfo].[EmailId],                                
[dbo].[TMUsersAppointmentsInfo].[PatientMode],                                
[dbo].[TMUsersAppointmentsInfo].[Speciality],                                
[dbo].[TMUsersAppointmentsInfo].[TMSpecialityRemarks],                                
[dbo].[TMUsersAppointmentsInfo].[Doctor],                                
[dbo].[TMUsersAppointmentsInfo].[TMDoctorRemarks],                                
[dbo].[TMUsersAppointmentsInfo].[SlotTime],                                
[dbo].[TMUsersAppointmentsInfo].[TMRemarks],                                
[dbo].[TMUsersAppointmentsInfo].[ConfirmStatus],                                
[dbo].[TMUsersAppointmentsInfo].[VisitStatus],                                
[dbo].[TMUsersAppointmentsInfo].[CancelledStatus],                                
[dbo].[TMUsersAppointmentsInfo].[CreatedBy],                                
isnull([dbo].[TMUsersAppointmentsInfo].[HuserRemarks],'''') As [HuserRemarks],                                
[dbo].[TMUsersAppointmentsInfo].[AppointmentTypeId],                                
[dbo].[TMUsersAppointmentsInfo].[UHID],                                
[dbo].[TMUsersAppointmentsInfo].[HealthcheckId],                                
[dbo].[TMUsersAppointmentsInfo].[HospitalId],                                
dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[CreatedOn],103),''DD/MM/YYYY'') As [BookedDate],                                                              
dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[AppointmentDate],103),''DD/MM/YYYY'') AS [AppointmentDate],                                                                
isnull(dbo.fn_titlecase([Lkp_SpecialitiesInfo].[Speciality]),'''') AS [SpecialityName],                                            
isnull(dbo.fn_titlecase([DocDetails].[FirstName] +'' ''+ [DocDetails].[LastName]),'''')AS [DoctorName],                                
dbo.fn_titlecase([HospitalInfo].[HospitalName]) AS [HospitalName],                                 
dbo.fn_titlecase([dbo].[UserInfo].[FirstName] +'' ''+ isnull([dbo].[UserInfo].[LastName],'''')) As [BookedBy],          
dbo.fn_IsDateExpired([dbo].[TMUsersAppointmentsInfo].[AppointmentDate], [dbo].[TMUsersAppointmentsInfo].[SlotTime]) As IsdateExpired,                        
isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityId],''0'') AS [ConfirmedSpecialityId],                        
isnull(dbo.fn_titlecase([ConfirmSpecialitiesInfo].[Speciality]),'''') AS [ConfirmedSpecialityName],                         
isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityRemarks],'''') As [ConfirmedSpecialityRemarks],                         
isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorId],''0'') AS [ConfirmedDoctorId],                        
isnull(dbo.fn_titlecase([ConfirmedDocDetails].[FirstName] +'' ''+ [ConfirmedDocDetails].[LastName]),'''')AS [ConfirmedDoctorName],                         
isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorRemarks],'''') As [ConfirmedDoctorRemarks],                         
isnull(dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[ConfirmedAppointmentDate],103),''DD/MM/YYYY''),'''') AS [ConfirmedAppointmentDate],                          
isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSlotTime],'''') AS [ConfirmedSlotTime],                      
isnull([dbo].[TMUsersAppointmentsInfo].[SalutationId],''0'') AS [SalutationId],                      
isnull([dbo].[Lkp_Salutation].[Salutation],'''') AS [Salutation],                      
isnull([dbo].[TMUsersAppointmentsInfo].[Age],''0'') AS [Age],                      
isnull([dbo].[TMUsersAppointmentsInfo].[Gender],''0'') AS [Gender],                    
isnull(convert(char(8),[dbo].[TMUsersAppointmentsInfo].[CreatedOn], 108),'''') AS [BookedTime]                      
FROM [dbo].[TMUsersAppointmentsInfo] WITH (NOLOCK)                                                                 
LEFT JOIN [dbo].[HospitalInfo] WITH (NOLOCK) ON [dbo].[HospitalInfo].[HospitalId] = [dbo].[TMUsersAppointmentsInfo].[HospitalId]                                                              
LEFT JOIN [dbo].[Lkp_Salutation] WITH (NOLOCK) ON [dbo].[Lkp_Salutation].[SalutationId] = [dbo].[TMUsersAppointmentsInfo].[SalutationId]                      
LEFT JOIN [dbo].[Lkp_SpecialitiesInfo] WITH (NOLOCK) ON [dbo].[Lkp_SpecialitiesInfo].[SpecialityId] = [dbo].[TMUsersAppointmentsInfo].[Speciality]                         
LEFT JOIN [dbo].[Lkp_SpecialitiesInfo] As ConfirmSpecialitiesInfo WITH (NOLOCK) ON [ConfirmSpecialitiesInfo].[SpecialityId] = [dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityId]                                                            
LEFT JOIN [dbo].[UserInfo] As  DocDetails WITH (NOLOCK) ON [DocDetails].[UserId] = [dbo].[TMUsersAppointmentsInfo].[Doctor]                           
LEFT JOIN [dbo].[UserInfo] As  ConfirmedDocDetails WITH (NOLOCK) ON [ConfirmedDocDetails].[UserId] = [dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorId]                               
LEFT JOIN [dbo].[UserInfo] WITH (NOLOCK) ON [dbo].[UserInfo].[UserId] = [dbo].[TMUsersAppointmentsInfo].[CreatedBy]                                 
LEFT JOIN [dbo].[Config_HealthCheckInfo] ON [dbo].[Config_HealthCheckInfo].[HealthCheckId] = [dbo].[TMUsersAppointmentsInfo].[HealthcheckId]
LEFT JOIN [dbo].Config_TMCenter ON [dbo].Config_TMCenter.CenterId = [dbo].[TMUsersAppointmentsInfo].CenterId'                                                                
IF(@DateType='1')                                                                                  
BEGIN                                    
SET  @ToDate=dateadd(day,1,CONVERT(datetime,@ToDate ,103))                                        
                                                              
--SET @SqlStr=@SqlStr+ 'Where [dbo].TMUsersAppointmentsInfo.[BookedDate] BETWEEN '''+ dbo.FormatDateTime(CONVERT(datetime, @FromDate, 103),'MM/DD/YYYY')+''''                                                           
--SET @SqlStr=@SqlStr+ 'AND '''+ dbo.FormatDateTime(CONVERT(datetime, @ToDate, 103),'MM/DD/YYYY')+''''                                                              
SET @SqlStr=@SqlStr+ ' Where convert(datetime,[TMUsersAppointmentsInfo].[CreatedOn],103) >='''+ dbo.FormatDateTime(CONVERT(datetime, @FromDate, 103),'MM/DD/YYYY')+''''                                                              
SET @SqlStr=@SqlStr+ 'AND  convert(datetime,[TMUsersAppointmentsInfo].[CreatedOn],103) < '''+ dbo.FormatDateTime(CONVERT(datetime, @ToDate, 103),'MM/DD/YYYY')+''' AND (IsCancelled is null OR IsCancelled =0) '                                               
  
    
     
         
                           
END                                                                                  
IF(@DateType='2')                                                                      
BEGIN                                                               
SET @SqlStr=@SqlStr+ ' Where [dbo].TMUsersAppointmentsInfo.[AppointmentDate] BETWEEN '''+ dbo.FormatDateTime(CONVERT(datetime, @FromDate, 103),'MM/DD/YYYY')+''''                                                               
set @SqlStr=@SqlStr+ ' AND '''+ dbo.FormatDateTime(CONVERT(datetime, @ToDate, 103),'MM/DD/YYYY')+''' AND (IsCancelled is null OR IsCancelled =0) '                                                              
END                                             
                                                            
--IF(@DoctorId<>0)                                                                                
--BEGIN                                                                                  
-- SET @SqlStr=@SqlStr+' AND ([dbo].[TMUsersAppointmentsInfo].[Doctor] = '+CAST(@DoctorId As Varchar)+')'                                                                                  
--END                                                          
                      
IF(@HospitalId<>0)                                                                                  
BEGIN                                                                                  
 SET @SqlStr=@SqlStr+' AND ([dbo].[TMUsersAppointmentsInfo].[HospitalId]='+CAST(@HospitalId As Varchar) +')'                                                      
END                                                         
                                                              
--IF(@SpecialityId<>0)                                                                
-- BEGIN                                                                
--  SET @SqlStr=@SqlStr+' AND ([dbo].[TMUsersAppointmentsInfo].[Speciality]='+CAST(@SpecialityId As Varchar)+')'                                                                
-- END                                                          
                                                            
 --Patient Name                                                      
 IF(@BookedBy <>0)                                                      
 BEGIN                               
 SET @SqlStr = @SqlStr + 'AND ([dbo].[TMUsersAppointmentsInfo].[CreatedBy] ='+CAST(@BookedBy As Varchar) +')'                                                       
 END                                 
                                 
 IF @AppointmentTypeId <> 0                                                         
 BEGIN                                                      
 SET @SqlStr = @SqlStr + 'AND ([dbo].[TMUsersAppointmentsInfo].[AppointmentTypeId] ='+CAST(@AppointmentTypeId As Varchar) +')'                                                       
 END   
     
 -- Confirmed  
 IF @status = 1                                                         
 BEGIN                                                      
 SET @SqlStr = @SqlStr + 'AND CancelledStatus is null and ConfirmStatus = 1 and VisitStatus is null'                                                       
 END    
 -- Not Confirmed  
 ELSE IF @status = 2                                                         
 BEGIN                                            
 SET @SqlStr = @SqlStr + 'AND CancelledStatus is null and ConfirmStatus is null and VisitStatus is null '                                                       
 END   
 -- Visited  
 ELSE IF @status = 3                                                        
 BEGIN                                                      
 SET @SqlStr = @SqlStr + 'AND CancelledStatus is null and ConfirmStatus = 1 and VisitStatus = 1'                                                       
 END   
 -- Not Visited  
 ELSE IF @status = 4                                                         
 BEGIN                                                      
 SET @SqlStr = @SqlStr + 'AND CancelledStatus is null and ConfirmStatus = 1 and VisitStatus = 0'                                                       
 END    
 -- Cancelled  
 ELSE IF @status = 5                                                        
 BEGIN                                                      
 SET @SqlStr = @SqlStr + 'AND CancelledStatus = 1 and ConfirmStatus = 1 and VisitStatus is null  '                                                       
 END    
 SET @SqlStr=@SqlStr+ ' ORDER BY [dbo].TMUsersAppointmentsInfo.[AppointmentDate] DESC'                                                            
END                                
ELSE IF @AppointmentTypeId = 3                                
BEGIN                                
SET @SqlStr=@SqlStr+ 'SELECT [dbo].[TMUsersAppointmentsInfo].[TMAppointmentId], [dbo].[TMUsersAppointmentsInfo].[PatientId],ISNULL(Config_TMCenter.CenterId,0) AS CenterId ,ISNULL(Config_TMCenter.Center,'''') AS Center,               
ISNULL([dbo].fn_IsDateExpired(ConfirmedAppointmentDate,ConfirmedSlotTime),0) As IsdateExpired,                  
isnull([dbo].[TMUsersAppointmentsInfo].[UAID],'''') AS UAID ,                    
[dbo].[TMUsersAppointmentsInfo].[PatientName],                                
[dbo].[TMUsersAppointmentsInfo].[MobileNumber],                                
[dbo].[TMUsersAppointmentsInfo].[EmailId],                                
[dbo].[TMUsersAppointmentsInfo].[PatientMode],                                
[dbo].[TMUsersAppointmentsInfo].[SlotTime],                                
[dbo].[TMUsersAppointmentsInfo].[TMRemarks],                                
[dbo].[TMUsersAppointmentsInfo].[ConfirmStatus],                                
[dbo].[TMUsersAppointmentsInfo].[VisitStatus],                                
[dbo].[TMUsersAppointmentsInfo].[CancelledStatus],                                
[dbo].[TMUsersAppointmentsInfo].[CreatedBy],                                
isnull([dbo].[TMUsersAppointmentsInfo].[HuserRemarks],'''') As [HuserRemarks],                                
[dbo].[TMUsersAppointmentsInfo].[AppointmentTypeId],                                
[dbo].[TMUsersAppointmentsInfo].[UHID],                                
[dbo].[TMUsersAppointmentsInfo].[HealthcheckId],                                
[dbo].[TMUsersAppointmentsInfo].[HospitalId],                                
dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[CreatedOn],103),''DD/MM/YYYY'') As [BookedDate],                                                              
dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[AppointmentDate],103),''DD/MM/YYYY'') AS [AppointmentDate],                                                                
dbo.fn_titlecase([HospitalInfo].[HospitalName]) AS [HospitalName],                                 
isnull(dbo.fn_titlecase([Config_HealthCheckInfo].[HealthCheckName]),'''') AS [HealthCheckName],                              
isnull([TMUsersAppointmentsInfo].[HealthCheckRemarks],'''') AS [HealthCheckRemarks],                                   
dbo.fn_titlecase([dbo].[UserInfo].[FirstName] +'' ''+ isnull([dbo].[UserInfo].[LastName],'''')) As [BookedBy],         
dbo.fn_IsDateExpired([dbo].[TMUsersAppointmentsInfo].[AppointmentDate], [dbo].[TMUsersAppointmentsInfo].[SlotTime]) As IsdateExpired,                        
isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedHealthCheckId],''0'') AS [ConfirmedHealthCheckId],                        
isnull(dbo.fn_titlecase([ConfirmedHealthCheckInfo].[HealthCheckName]),'''') AS [ConfirmedHealthCheckName],                         
isnull([TMUsersAppointmentsInfo].[ConfirmedHealthCheckRemarks],'''') AS [ConfirmedHealthCheckRemarks],                             
isnull(dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[ConfirmedAppointmentDate],103),''DD/MM/YYYY''),'''') AS [ConfirmedAppointmentDate],                          
isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSlotTime],'''') AS [ConfirmedSlotTime],                      
isnull([dbo].[TMUsersAppointmentsInfo].[SalutationId],''0'') AS [SalutationId],                      
isnull([dbo].[Lkp_Salutation].[Salutation],'''') AS [Salutation],                      
isnull([dbo].[TMUsersAppointmentsInfo].[Age],''0'') AS [Age],                      
isnull([dbo].[TMUsersAppointmentsInfo].[Gender],''0'') AS [Gender],                    
isnull(convert(char(8),[dbo].[TMUsersAppointmentsInfo].[CreatedOn], 108),'''') AS [BookedTime]                      
FROM [dbo].[TMUsersAppointmentsInfo] WITH (NOLOCK)                                                                 
LEFT JOIN [dbo].[HospitalInfo] WITH (NOLOCK) ON [dbo].[HospitalInfo].[HospitalId] = [dbo].[TMUsersAppointmentsInfo].[HospitalId]                                                              
LEFT JOIN [dbo].[Lkp_Salutation] WITH (NOLOCK) ON [dbo].[Lkp_Salutation].[SalutationId] = [dbo].[TMUsersAppointmentsInfo].[SalutationId]                      
LEFT JOIN [dbo].[UserInfo] WITH (NOLOCK) ON [dbo].[UserInfo].[UserId] = [dbo].[TMUsersAppointmentsInfo].[CreatedBy]                                 
LEFT JOIN [dbo].[Config_HealthCheckInfo] ON [dbo].[Config_HealthCheckInfo].[HealthCheckId] = [dbo].[TMUsersAppointmentsInfo].[HealthcheckId]                         
LEFT JOIN [dbo].[Config_HealthCheckInfo] As ConfirmedHealthCheckInfo ON [ConfirmedHealthCheckInfo].[HealthCheckId] = [dbo].[TMUsersAppointmentsInfo].[ConfirmedHealthcheckId]
LEFT JOIN [dbo].Config_TMCenter ON [dbo].Config_TMCenter.CenterId = [dbo].[TMUsersAppointmentsInfo].CenterId'                                  
IF(@DateType='1')                                                                                  
BEGIN                                                               
SET  @ToDate=dateadd(day,1,CONVERT(datetime,@ToDate ,103))                       
SET @SqlStr=@SqlStr+ ' Where convert(datetime,[TMUsersAppointmentsInfo].[CreatedOn],103) >='''+ dbo.FormatDateTime(CONVERT(datetime, @FromDate, 103),'MM/DD/YYYY')+''''                                                              
SET @SqlStr=@SqlStr+ ' AND  convert(datetime,[TMUsersAppointmentsInfo].[CreatedOn],103) < '''+ dbo.FormatDateTime(CONVERT(datetime, @ToDate, 103),'MM/DD/YYYY')+''' AND (IsCancelled is null OR IsCancelled =0) '                                             
  
    
      
         
                            
END                                                                                  
IF(@DateType='2')                                                                      
BEGIN                                                               
SET @SqlStr=@SqlStr+ ' Where [dbo].TMUsersAppointmentsInfo.[AppointmentDate] BETWEEN '''+ dbo.FormatDateTime(CONVERT(datetime, @FromDate, 103),'MM/DD/YYYY')+''''                                                               
set @SqlStr=@SqlStr+ ' AND '''+ dbo.FormatDateTime(CONVERT(datetime, @ToDate, 103),'MM/DD/YYYY')+''' AND (IsCancelled is null OR IsCancelled =0) '                                                              
END                                                             
                                                                        
IF(@HospitalId<>0)                                                                                  
BEGIN                                                     
 SET @SqlStr=@SqlStr+' AND ([dbo].[TMUsersAppointmentsInfo].[HospitalId]='+CAST(@HospitalId As Varchar) +')'                                                                  
END                                                         
                                                              
--Patient Name                                                      
 IF(@BookedBy <>0)                                                      
 BEGIN                                         SET @SqlStr = @SqlStr + 'AND ([dbo].[TMUsersAppointmentsInfo].[CreatedBy] ='+CAST(@BookedBy As Varchar) +')'                                                       
 END                                 
                                 
 IF @AppointmentTypeId <> 0                                                         
 BEGIN                                                      
 SET @SqlStr = @SqlStr + 'AND ([dbo].[TMUsersAppointmentsInfo].[AppointmentTypeId] ='+CAST(@AppointmentTypeId As Varchar) +')'                                                       
 END                                 
                                        
 SET @SqlStr=@SqlStr+ ' ORDER BY [dbo].TMUsersAppointmentsInfo.[AppointmentDate] DESC'                                  
END                      
ELSE IF @AppointmentTypeId = 4                               
BEGIN                                                                
SET @SqlStr=@SqlStr+ 'SELECT [dbo].[TMUsersAppointmentsInfo].[TMAppointmentId], [dbo].[TMUsersAppointmentsInfo].[PatientId],ISNULL(Config_TMCenter.CenterId,0) AS CenterId ,ISNULL(Config_TMCenter.Center,'''') AS Center,           
ISNULL([dbo].fn_IsDateExpired(ConfirmedAppointmentDate,ConfirmedSlotTime),0) As IsdateExpired,                 
isnull([dbo].[TMUsersAppointmentsInfo].[UAID],'''') AS UAID ,                                 
[dbo].[TMUsersAppointmentsInfo].[PatientName],                                
[dbo].[TMUsersAppointmentsInfo].[MobileNumber],                                
[dbo].[TMUsersAppointmentsInfo].[EmailId],                                
[dbo].[TMUsersAppointmentsInfo].[PatientMode],                                
[dbo].[TMUsersAppointmentsInfo].[Speciality],                                
[dbo].[TMUsersAppointmentsInfo].[TMSpecialityRemarks],                                
[dbo].[TMUsersAppointmentsInfo].[Doctor],                                
[dbo].[TMUsersAppointmentsInfo].[TMDoctorRemarks],                                
[dbo].[TMUsersAppointmentsInfo].[SlotTime],                                
[dbo].[TMUsersAppointmentsInfo].[TMRemarks],                                
[dbo].[TMUsersAppointmentsInfo].[ConfirmStatus],                                
[dbo].[TMUsersAppointmentsInfo].[VisitStatus],                                
[dbo].[TMUsersAppointmentsInfo].[CancelledStatus],                                
[dbo].[TMUsersAppointmentsInfo].[CreatedBy],                
isnull([dbo].[TMUsersAppointmentsInfo].[HuserRemarks],'''') As [HuserRemarks],                                
[dbo].[TMUsersAppointmentsInfo].[AppointmentTypeId],                                
[dbo].[TMUsersAppointmentsInfo].[UHID],                                
[dbo].[TMUsersAppointmentsInfo].[HealthcheckId],                                
[dbo].[TMUsersAppointmentsInfo].[HospitalId],                                
dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[CreatedOn],103),''DD/MM/YYYY'') As [BookedDate],                                                              
dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[AppointmentDate],103),''DD/MM/YYYY'') AS [AppointmentDate],                                                                
isnull(dbo.fn_titlecase([Lkp_SpecialitiesInfo].[Speciality]),'''') AS [SpecialityName],                                            
isnull(dbo.fn_titlecase([DocDetails].[FirstName] +'' ''+ [DocDetails].[LastName]),'''')AS [DoctorName],                                
dbo.fn_titlecase([HospitalInfo].[HospitalName]) AS [HospitalName],                                 
dbo.fn_titlecase([dbo].[UserInfo].[FirstName] +'' ''+ isnull([dbo].[UserInfo].[LastName],'''')) As [BookedBy],       
dbo.fn_IsDateExpired([dbo].[TMUsersAppointmentsInfo].[AppointmentDate], [dbo].[TMUsersAppointmentsInfo].[SlotTime]) As IsdateExpired,                        
isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityId],''0'') AS [ConfirmedSpecialityId],                        
isnull(dbo.fn_titlecase([ConfirmSpecialitiesInfo].[Speciality]),'''') AS [ConfirmedSpecialityName],                         
isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityRemarks],'''') As [ConfirmedSpecialityRemarks],                         
isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorId],''0'') AS [ConfirmedDoctorId],                        
isnull(dbo.fn_titlecase([ConfirmedDocDetails].[FirstName] +'' ''+ [ConfirmedDocDetails].[LastName]),'''')AS [ConfirmedDoctorName],                         
isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorRemarks],'''') As [ConfirmedDoctorRemarks],                         
isnull(dbo.FormatDateTime(CONVERT(datetime,[dbo].[TMUsersAppointmentsInfo].[ConfirmedAppointmentDate],103),''DD/MM/YYYY''),'''') AS [ConfirmedAppointmentDate],                          
isnull([dbo].[TMUsersAppointmentsInfo].[ConfirmedSlotTime],'''') AS [ConfirmedSlotTime],                      
isnull([dbo].[TMUsersAppointmentsInfo].[SalutationId],''0'') AS [SalutationId],                      
isnull([dbo].[Lkp_Salutation].[Salutation],'''') AS [Salutation],                      
isnull([dbo].[TMUsersAppointmentsInfo].[Age],''0'') AS [Age],                      
isnull([dbo].[TMUsersAppointmentsInfo].[Gender],''0'') AS [Gender],                    
isnull(convert(char(8),[dbo].[TMUsersAppointmentsInfo].[CreatedOn], 108),'''') AS [BookedTime]                    
FROM [dbo].[TMUsersAppointmentsInfo] WITH (NOLOCK)                                                                 
LEFT JOIN [dbo].[HospitalInfo] WITH (NOLOCK) ON [dbo].[HospitalInfo].[HospitalId] = [dbo].[TMUsersAppointmentsInfo].[HospitalId]                                                           
LEFT JOIN [dbo].[Lkp_Salutation] WITH (NOLOCK) ON [dbo].[Lkp_Salutation].[SalutationId] = [dbo].[TMUsersAppointmentsInfo].[SalutationId]                      
LEFT JOIN [dbo].[Lkp_SpecialitiesInfo] WITH (NOLOCK) ON [dbo].[Lkp_SpecialitiesInfo].[SpecialityId] = [dbo].[TMUsersAppointmentsInfo].[Speciality]                         
LEFT JOIN [dbo].[Lkp_SpecialitiesInfo] As ConfirmSpecialitiesInfo WITH (NOLOCK) ON [ConfirmSpecialitiesInfo].[SpecialityId] = [dbo].[TMUsersAppointmentsInfo].[ConfirmedSpecialityId]                                                           
LEFT JOIN [dbo].[UserInfo] As  DocDetails WITH (NOLOCK) ON [DocDetails].[UserId] = [dbo].[TMUsersAppointmentsInfo].[Doctor]                           
LEFT JOIN [dbo].[UserInfo] As  ConfirmedDocDetails WITH (NOLOCK) ON [ConfirmedDocDetails].[UserId] = [dbo].[TMUsersAppointmentsInfo].[ConfirmedDoctorId]                               
LEFT JOIN [dbo].[UserInfo] WITH (NOLOCK) ON [dbo].[UserInfo].[UserId] = [dbo].[TMUsersAppointmentsInfo].[CreatedBy]                                 
LEFT JOIN [dbo].[Config_HealthCheckInfo] ON [dbo].[Config_HealthCheckInfo].[HealthCheckId] = [dbo].[TMUsersAppointmentsInfo].[HealthcheckId]
LEFT JOIN [dbo].Config_TMCenter ON [dbo].Config_TMCenter.CenterId = [dbo].[TMUsersAppointmentsInfo].CenterId'                                                                
IF(@DateType='1')                                                                                  
BEGIN                                    
SET  @ToDate=dateadd(day,1,CONVERT(datetime,@ToDate ,103))                                        
                                                              
--SET @SqlStr=@SqlStr+ 'Where [dbo].TMUsersAppointmentsInfo.[BookedDate] BETWEEN '''+ dbo.FormatDateTime(CONVERT(datetime, @FromDate, 103),'MM/DD/YYYY')+''''                                                           
--SET @SqlStr=@SqlStr+ 'AND '''+ dbo.FormatDateTime(CONVERT(datetime, @ToDate, 103),'MM/DD/YYYY')+''''                                                              
SET @SqlStr=@SqlStr+ ' Where convert(datetime,[TMUsersAppointmentsInfo].[CreatedOn],103) >='''+ dbo.FormatDateTime(CONVERT(datetime, @FromDate, 103),'MM/DD/YYYY')+''''                                        
SET @SqlStr=@SqlStr+ ' AND  convert(datetime,[TMUsersAppointmentsInfo].[CreatedOn],103) < '''+ dbo.FormatDateTime(CONVERT(datetime, @ToDate, 103),'MM/DD/YYYY')+''' AND (IsCancelled is null OR IsCancelled =0) '                                              
  
   
      
         
                            
END                                                                                  
IF(@DateType='2')                                                                      
BEGIN                                                               
SET @SqlStr=@SqlStr+ ' Where [dbo].TMUsersAppointmentsInfo.[AppointmentDate] BETWEEN '''+ dbo.FormatDateTime(CONVERT(datetime, @FromDate, 103),'MM/DD/YYYY')+''''                                                               
set @SqlStr=@SqlStr+ ' AND '''+ dbo.FormatDateTime(CONVERT(datetime, @ToDate, 103),'MM/DD/YYYY')+''' AND (IsCancelled is null OR IsCancelled =0) '                                                              
END                                                             
                                                            
--IF(@DoctorId<>0)                                                                                
--BEGIN                                                                                  
-- SET @SqlStr=@SqlStr+' AND ([dbo].[TMUsersAppointmentsInfo].[Doctor] = '+CAST(@DoctorId As Varchar)+')'                                                                                  
--END                                                          
                                                                              
IF(@HospitalId<>0)                        
BEGIN                                                                                  
 SET @SqlStr=@SqlStr+' AND ([dbo].[TMUsersAppointmentsInfo].[HospitalId]='+CAST(@HospitalId As Varchar) +')'                                                      
END                                                         
                                 
--IF(@SpecialityId<>0)                                                                
-- BEGIN                                                                
--  SET @SqlStr=@SqlStr+' AND ([dbo].[TMUsersAppointmentsInfo].[Speciality]='+CAST(@SpecialityId As Varchar)+')'                                                                
-- END                     
                                                            
 --Patient Name                                                      
 IF(@BookedBy <>0)                                                      
 BEGIN                               
 SET @SqlStr = @SqlStr + 'AND ([dbo].[TMUsersAppointmentsInfo].[CreatedBy] ='+CAST(@BookedBy As Varchar) +')'                                                       
 END                                 
                                 
 IF @AppointmentTypeId <> 0                                                         
 BEGIN                                                      
 SET @SqlStr = @SqlStr + 'AND ([dbo].[TMUsersAppointmentsInfo].[AppointmentTypeId] ='+CAST(@AppointmentTypeId As Varchar) +')'                                                       
 END                                 
                                                          
 SET @SqlStr=@SqlStr+ ' ORDER BY [dbo].TMUsersAppointmentsInfo.[AppointmentDate] DESC'                                                            
END                                             
PRINT @SqlStr                                                     
EXEC (@SqlStr)                                                                
END 

--*****************************************


-- ================================================                
-- Author:  Sravan                
-- Create date: 25 July 12                
-- Version : 1.0                  
-- Description: SP to get all states and country              
-- ================================================                
ALTER PROCEDURE [dbo].Proc_Admin_FindAllCenterByLocationId       
@LocationId Int            
AS                
BEGIN                
 SELECT Config_TMCenter.CenterId,Center,Lkp_Cities.CityId,CityName,isnull(Trans_TMCenterXCountry.LocationId,0) AS LocationId,        
  ISNULL(Trans_TMCenterXCountry.LocationId,'') AS Location ,        
  Lkp_States.[StateId]                
       ,dbo.fn_Titlecase([StateName]) AS [StateName]             
    ,[dbo].[Lkp_Countries].[CountryId]            
    ,dbo.fn_Titlecase([dbo].[Lkp_Countries].[CountryName]) AS [CountryName]             
 FROM Config_TMCenter           
  INNER JOIN  Trans_TMCenterXCountry ON Trans_TMCenterXCountry.CenterId=Config_TMCenter.CenterId          
 INNER JOIN  Lkp_States ON Lkp_States.StateId=Trans_TMCenterXCountry.StateId          
 INNER JOIN  Lkp_Cities ON Lkp_Cities.CityId=Trans_TMCenterXCountry.CityId          
  --INNER JOIN  Config_TMLocation ON Config_TMLocation.LocationId=Trans_TMCenterXCountry.LocationId          
INNER JOIN [dbo].Lkp_Countries           
  ON [dbo].[Lkp_States].[CountryId] = [dbo].[Lkp_Countries].[CountryId]            
 WHERE Config_TMCenter.IsActive = 1                
 AND Config_TMCenter.IsDeleted= 0  AND Trans_TMCenterXCountry.CityId=@LocationId             
 ORDER BY Center                
            
END 

--******************************************************


-- ================================================              
-- Author:  Sravan              
-- Create date: 25 July 12              
-- Version : 1.0                
-- Description: SP to get all states and country            
-- ================================================              
ALTER PROCEDURE [dbo].Proc_Admin_AllCenterAndStatesAndCountries-- 1  
@hospitalId INT              
AS              
BEGIN              
 SELECT Config_TMCenter.CenterId,Center,Lkp_Cities.CityId,CityName,ISNULL(Trans_TMCenterXCountry.LocationId,0) AS LocationId,      
   ISNULL(Trans_TMCenterXCountry.LocationId,'') AS Location,      
  Lkp_States.[StateId]              
       ,dbo.fn_Titlecase([StateName]) AS [StateName]           
    ,[dbo].[Lkp_Countries].[CountryId]          
    ,dbo.fn_Titlecase([dbo].[Lkp_Countries].[CountryName]) AS [CountryName]           
 FROM Config_TMCenter         
  INNER JOIN  Trans_TMCenterXCountry ON Trans_TMCenterXCountry.CenterId=Config_TMCenter.CenterId        
 INNER JOIN  Lkp_States ON Lkp_States.StateId=Trans_TMCenterXCountry.StateId        
 INNER JOIN  Lkp_Cities ON Lkp_Cities.CityId=Trans_TMCenterXCountry.CityId        
 -- INNER JOIN  Config_TMLocation ON Config_TMLocation.LocationId=Trans_TMCenterXCountry.LocationId        
INNER JOIN [dbo].Lkp_Countries         
  ON [dbo].[Lkp_States].[CountryId] = [dbo].[Lkp_Countries].[CountryId]    
  INNER JOIN [HospitalInfo] ON [HospitalInfo].CityId= Trans_TMCenterXCountry.CityId  
 WHERE Config_TMCenter.IsActive = 1              
 AND Config_TMCenter.IsDeleted= 0              
 AND [HospitalInfo].[HospitalId]=@hospitalId   
 ORDER BY Center              
          
END 

--**************************************************************

      
-- ================================================                
-- Author:  Sravan                
-- Create date: 25 July 12                
-- Version : 1.0                  
-- Description: SP to get all states and country              
-- ================================================                
CREATE PROCEDURE [dbo].Proc_Admin_GetAllCenterAndStatesAndCountriesfroTccCenterByHospitalId 
@hospitalId int              
AS                
BEGIN                
 SELECT Config_TMCenter.CenterId,Center,Lkp_Cities.CityId,CityName,  
  Lkp_States.[StateId]                
       ,dbo.fn_Titlecase([StateName]) AS [StateName]             
    ,[dbo].[Lkp_Countries].[CountryId]            
    ,dbo.fn_Titlecase([dbo].[Lkp_Countries].[CountryName]) AS [CountryName]             
 FROM Config_TMCenter           
  INNER JOIN  Trans_TMCenterXCountry ON Trans_TMCenterXCountry.CenterId=Config_TMCenter.CenterId          
 INNER JOIN  Lkp_States ON Lkp_States.StateId=Trans_TMCenterXCountry.StateId          
 INNER JOIN  Lkp_Cities ON Lkp_Cities.CityId=Trans_TMCenterXCountry.CityId          
 INNER JOIN [dbo].Lkp_Countries           
  ON [dbo].[Lkp_States].[CountryId] = [dbo].[Lkp_Countries].[CountryId]  
  INNER JOIN HospitalInfo ON HospitalInfo.CountryId= [Lkp_Countries].[CountryId] 
  AND Lkp_States.StateId=HospitalInfo.StateId AND Trans_TMCenterXCountry.CityId=HospitalInfo.CityId 
 WHERE Config_TMCenter.IsActive = 1                
 AND Config_TMCenter.IsDeleted= 0 AND HospitalInfo.HospitalId=@hospitalId              
 ORDER BY Center                
            
END 

--********************************************************


     
-- ================================================                
-- Author:  Sravan                
-- Create date: 25 July 12                
-- Version : 1.0                  
-- Description: SP to get all states and country              
-- ================================================                
ALTER PROCEDURE [dbo].Proc_Admin_FindAllCenterByLocationId       
@LocationId Int            
AS                
BEGIN                
 SELECT Config_TMCenter.CenterId,Center,Lkp_Cities.CityId,CityName,ISNULL(Trans_TMCenterXCountry.LocationId,0) AS LocationId,        
   ISNULL(Trans_TMCenterXCountry.LocationId,'') AS Location,        
     Lkp_States.[StateId]                
       ,dbo.fn_Titlecase([StateName]) AS [StateName]             
    ,[dbo].[Lkp_Countries].[CountryId]            
    ,dbo.fn_Titlecase([dbo].[Lkp_Countries].[CountryName]) AS [CountryName]             
 FROM Config_TMCenter           
  INNER JOIN  Trans_TMCenterXCountry ON Trans_TMCenterXCountry.CenterId=Config_TMCenter.CenterId          
 INNER JOIN  Lkp_States ON Lkp_States.StateId=Trans_TMCenterXCountry.StateId          
 INNER JOIN  Lkp_Cities ON Lkp_Cities.CityId=Trans_TMCenterXCountry.CityId          
  --INNER JOIN  Config_TMLocation ON Config_TMLocation.LocationId=Trans_TMCenterXCountry.LocationId          
INNER JOIN [dbo].Lkp_Countries           
  ON [dbo].[Lkp_States].[CountryId] = [dbo].[Lkp_Countries].[CountryId]            
 WHERE Config_TMCenter.IsActive = 1                
 AND Config_TMCenter.IsDeleted= 0  AND Trans_TMCenterXCountry.CityId=@LocationId             
 ORDER BY Center                
            
END 
