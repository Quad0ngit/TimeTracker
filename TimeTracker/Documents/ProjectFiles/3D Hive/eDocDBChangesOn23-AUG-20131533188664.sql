   
CREATE PROCEDURE Proc_GetTMUsersAppointmentsForTccUser-- 0,2,'28/07/2013','31/08/2013',209411,1,0                                  
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
DECLARE @CenterId INT                                           
                                    
--Assigning default vaues                                                                                    
 SET @SqlStr=''  
 SET @CenterId = 0    
 SET @CenterId= (SELECT centerid from Trans_CenterXTCCUsers where UserId=@BookedBy  )                                                                              
                                                                    
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
   
 IF (@CenterId<>0)  
 BEGIN  
 SET @SqlStr = @SqlStr + 'AND ([dbo].[TMUsersAppointmentsInfo].[CenterId] ='+CAST(@CenterId As Varchar) +')'                                                           
 END  
 ELSE  
 BEGIN                                                                   
  --Patient Name                                                          
  IF(@BookedBy <>0)                                                          
  BEGIN                                   
  SET @SqlStr = @SqlStr + 'AND ([dbo].[TMUsersAppointmentsInfo].[CreatedBy] ='+CAST(@BookedBy As Varchar) +')'                                                           
  END    
 END                                   
                                     
 IF @AppointmentTypeId <> 0                                                             
 BEGIN                                                          
 SET @SqlStr = @SqlStr + 'AND ([dbo].[TMUsersAppointmentsInfo].[AppointmentTypeId] ='+CAST(@AppointmentTypeId As Varchar) +')'                                                           
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
 BEGIN                                          
  SET @SqlStr = @SqlStr + 'AND ([dbo].[TMUsersAppointmentsInfo].[CreatedBy] ='+CAST(@BookedBy As Varchar) +')'                                                           
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
  

-------------------------------------------------------------------------------------------------------------------------------------------------------------------  

  
          
              
CREATE PROCEDURE Proc_InsertTMUsersAppointments                         
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
@IsUHIDExists int,     
@IsEmailExists int,                    
@IsMobileExists int    
AS BEGIN                          
                      
--Declaring Variables                              
DECLARE @ApptDate DateTime                       
DECLARE @UserId int    
DECLARE @PatientIId int    
DECLARE @CenterId INT   
    
SET @UserId = 0      
SET @PatientIId = 0   
SET @CenterId = 0        
    
       
 SET @CenterId= (SELECT centerid from Trans_CenterXTCCUsers where UserId=@CreatedBy  )                     
SELECT @ApptDate = CONVERT(DATETIME, @AppointmentDate, 103)                       
                      
 IF(@IsEmailExists = 1 AND @IsMobileExists =1)                      
 BEGIN                      
  SET @UserId = (SELECT UserId FROM UserInfo WHERE Email = @EmailId AND IsActive=1 AND Isdeleted = 0)                      
 END                      
 ELSE                      
 BEGIN                      
  IF @IsEmailExists = 1                      
  BEGIN                      
   SET @UserId = (SELECT UserId FROM UserInfo WHERE Email = @EmailId AND IsActive=1 AND Isdeleted = 0)                      
  END                       
  ELSE IF @IsMobileExists = 1                      
  BEGIN                      
   SET @UserId = (SELECT UserId FROM UserInfo WHERE MobileNumber= @MobileNumber AND IsActive=1 AND Isdeleted = 0)                      
  END              
  ELSE IF @IsUHIDExists = 1                      
  BEGIN                      
   SET @UserId = (SELECT RefUserId FROM PatientDetails WHERE UHID= @UHID)                      
  END                      
 END                      
    
 IF @UserId != 0     
 BEGIN    
 SET @PatientIId = (SELECT PatientId FROM PatientDetails WHERE RefUserId= @UserId AND RelationType=1)    
 END    
     
 IF @PatientIId  != 0     
    BEGIN                
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
   @PatientIId,      
   @UAID,  
   @CenterId                
   )          
 END    
 ELSE    
 BEGIN    
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
 UAID ,  
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
   @UAID,  
   @CenterId                
   )    
     
 END    
     
  --select @@IDENTITY     
 END    

-------------------------------------------------------------------------------------------------------------------------------------------------------------------  

  
    
-- =============================================                              
-- Author:  <Pardhu>                              
-- Create date: <20-June-2012>                              
-- Description: <Get Doctor Details By CityId,Speciality and Hospital>                              
-- =============================================                            
CREATE PROCEDURE [dbo].[Proc_User_GetDoctorsDetailsByCityIdAndHospitalIdAndSpecialityIdForTelemedicine]--12,1,263                         
@CityId int,                          
@HospitalId int,                          
@SpecialityId int                          
AS                          
BEGIN                          
DECLARE @SSQL varchar(max)                           
SET @SSQL = ''                          
   SET @SSQL = @SSQL+ ' SELECT  [DoctorDetails].[AutoId]                    
   ,[DoctorDetails].[UserId]                    
         ,[DoctorDetails].[Qualification]                        
         ,[DoctorDetails].[Gender]                        
         ,[DoctorDetails].[LocationId]                        
         ,[DoctorDetails].[PhotoUrl]                        
         ,[DoctorDetails].[Languages]                        
         ,[DoctorDetails].[RegistrationNo]                        
         ,[DoctorDetails].[Experience]                        
         ,[DoctorDetails].[Achievements]                        
         ,[DoctorDetails].[Publications]                        
         ,[DoctorDetails].[ProfessionalMemberships]                        
         ,[UserInfo].[Email]                        
         ,[UserInfo].[Password]                        
         ,[UserInfo].[Salutation]                        
         ,dbo.fn_TitleCase([UserInfo].[FirstName]) AS FirstName                       
         ,dbo.fn_TitleCase([UserInfo].[LastName]) AS LastName                       
         ,[UserInfo].[PhoneNumber]                        
         ,[UserInfo].[MobileNumber]                        
         ,[UserInfo].[DateOfBirth]                        
         ,[Lkp_Countries].[CountryId]                      
         ,[Lkp_Countries].[CountryName]          
   ,(SELECT StateId FROM fn_GetStatesCitiesByDoctorId([DoctorDetails].[UserId])) AS StateId                    
   ,(SELECT StateName FROM fn_GetStatesCitiesByDoctorId([DoctorDetails].[UserId])) AS StateName                    
   ,(SELECT CityId FROM fn_GetStatesCitiesByDoctorId([DoctorDetails].[UserId])) AS CityId                    
   ,(SELECT CityName FROM fn_GetStatesCitiesByDoctorId([DoctorDetails].[UserId])) AS CityName                          
         --,[Lkp_States].[StateId]                        
         --,[Lkp_States].[StateName]                       
         --,[Lkp_Cities].[CityId]                        
         --,dbo.fn_TitleCase([Lkp_Cities].[CityName]) AS CityName                        
         ,[UserInfo].[Address]                        
         ,[UserInfo].[Pincode]                        
         ,[UserInfo].[UserType]                      
         ,[Lkp_SpecialitiesInfo].[SpecialityId]                      
         ,dbo.fn_TitleCase([Lkp_SpecialitiesInfo].[Speciality]) AS Speciality                      
         ,(SELECT HospitalId FROM fn_GetHospitalsByDoctorId([DoctorDetails].[UserId])) AS HospitalId                
   ,(SELECT HospitalName FROM fn_GetHospitalsByDoctorIdForTeleMeedicine([DoctorDetails].[UserId])) AS HospitalName                 
         ,[UserInfo].[IsActive]                        
         ,[UserInfo].[IsDeleted]'                       
 SET @SSQL = @SSQL+ ' FROM [dbo].[UserInfo] WITH(NOLOCK)'                          
                          
SET @SSQL = @SSQL+ 'INNER JOIN [dbo].[DoctorDetails] ON [DoctorDetails].[UserId] = [UserInfo].[UserId]'                    
                  
SET @SSQL = @SSQL+ 'INNER JOIN [dbo].[Trans_HospitalXDoctors] ON [Trans_HospitalXDoctors].[DoctorId] = [UserInfo].[UserId]'                  
                       
SET @SSQL = @SSQL+ 'INNER JOIN [dbo].[HospitalInfo] ON [HospitalInfo].[HospitalId] = [Trans_HospitalXDoctors].[HospitalId]'      
                      
SET @SSQL = @SSQL+ 'INNER JOIN [dbo].[Lkp_Countries] ON [Lkp_Countries].[CountryId] = [HospitalInfo].[CountryId]'                      
                          
SET @SSQL = @SSQL+ 'INNER JOIN [dbo].[Trans_DoctorsXSpecialities] ON [Trans_DoctorsXSpecialities].[DoctorId] = [UserInfo].[UserId]'                          
                          
SET @SSQL = @SSQL+ 'INNER JOIN [dbo].[Lkp_SpecialitiesInfo] ON [Lkp_SpecialitiesInfo].[SpecialityId] = [Trans_DoctorsXSpecialities].[SpecialityId]'                          
                  
SET @SSQL = @SSQL+ 'INNER JOIN VGet_HospitalID_DoctorID_For_TMConsultationSlots ON [VGet_HospitalID_DoctorID_For_TMConsultationSlots].[DoctorId]=[dbo].[DoctorDetails].[UserId]'                   
                  
SET @SSQL = @SSQL+ 'AND [VGet_HospitalID_DoctorID_For_TMConsultationSlots].[HospitalId]=[Trans_HospitalXDoctors].[HospitalId]'                   
                  
SET @SSQL = @SSQL+ 'WHERE [UserInfo].[IsActive] = 1 AND [Trans_HospitalXDoctors].[IsActive] = 1 AND [UserInfo].[IsDeleted] = 0 AND [HospitalInfo].IsActive = 1 AND [HospitalInfo].[IsDeleted] = 0'                       
                          
SET @SSQL = @SSQL+ 'AND HospitalInfo.IsTeleMedicine=1 AND [DoctorDetails].IsTeleDoctor=1 AND [HospitalInfo].[CityId] = +cast([HospitalInfo].CityId AS varchar(50)) '                     
                          
if(@HospitalId > 0)                          
BEGIN                          
SET @SSQL = @SSQL+ ' And [Trans_HospitalXDoctors].[HospitalId] =' +cast(@HospitalId AS varchar(50))                     
END                          
                          
if(@SpecialityId > 0)                          
BEGIN                          
SET @SSQL = @SSQL+ ' And [Trans_DoctorsXSpecialities].[specialityid] =' +cast(@SpecialityId AS varchar(50))                    
END                  
                  
SET @SSQL = @SSQL+ 'GROUP BY [DoctorDetails].[AutoId]                  
      ,[DoctorDetails].[UserId]                    
      ,[DoctorDetails].[Qualification]                        
      ,[DoctorDetails].[Gender]                        
      ,[DoctorDetails].[LocationId]                        
      ,[DoctorDetails].[PhotoUrl]                        
      ,[DoctorDetails].[Languages]                        
      ,[DoctorDetails].[RegistrationNo]                        
      ,[DoctorDetails].[Experience]                        
      ,[DoctorDetails].[Achievements]                        
      ,[DoctorDetails].[Publications]                        
      ,[DoctorDetails].[ProfessionalMemberships]                        
      ,[UserInfo].[Email]                        
      ,[UserInfo].[Password]                        
      ,[UserInfo].[Salutation]                        
      ,[UserInfo].[FirstName]                        
      ,[UserInfo].[LastName]                         
      ,[UserInfo].[PhoneNumber]                        
      ,[UserInfo].[MobileNumber]                        
      ,[UserInfo].[DateOfBirth]                        
      ,[Lkp_Countries].[CountryId]                      
      ,[Lkp_Countries].[CountryName]                      
      --,[Lkp_States].[StateId]                        
      --,[Lkp_States].[StateName]                       
      --,[Lkp_Cities].[CityId]                        
      --,[Lkp_Cities].[CityName]                        
      ,[UserInfo].[Address]                        
      ,[UserInfo].[Pincode]                        
      ,[UserInfo].[UserType]                      
      ,[Lkp_SpecialitiesInfo].[SpecialityId]                      
      ,[Lkp_SpecialitiesInfo].[Speciality]                 
      ,[UserInfo].[IsActive]                        
      ,[UserInfo].[IsDeleted]'                  
                  
SET @SSQL = @SSQL+ 'ORDER BY [DoctorDetails].[UserId],[UserInfo].[FirstName]'                  
print @SSQL         
EXEC (@SSQL)                          
END   

-------------------------------------------------------------------------------------------------------------------------------------------------------------------  

CREATE PROCEDURE [dbo].[Proc_Admin_GetTelemedicineHospitalDeatils]                 
             
AS                    
BEGIN                    
 SET NOCOUNT ON;                  
   SELECT DISTINCT ([HospitalInfo].[HospitalId])                  
         ,dbo.fn_TitleCase([HospitalInfo].[HospitalName]) As [HospitalName]                    
   FROM [dbo].[HospitalInfo] WITH(NOLOCK)             
   WHERE [HospitalInfo].IsActive=1 AND [HospitalInfo].IsDeleted=0      
   AND [HospitalInfo].IsTeleMedicine=1             
END 

-------------------------------------------------------------------------------------------------------------------------------------------------------------------  

   
     
-- ================================================                  
-- Author:  Sravan                  
-- Create date: 25 July 12                  
-- Version : 1.0                    
-- Description: SP to get all states and country                
-- ================================================                  
CREATE PROCEDURE [dbo].Proc_Admin_AllCenterAndStatesAndCountries-- 1      
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
  --INNER JOIN [HospitalInfo] ON [HospitalInfo].CityId= Trans_TMCenterXCountry.CityId      
 WHERE Config_TMCenter.IsActive = 1                  
 AND Config_TMCenter.IsDeleted= 0                  
 --AND [HospitalInfo].[HospitalId]=@hospitalId       
 ORDER BY Center                  
              
END   

-------------------------------------------------------------------------------------------------------------------------------------------------------------------  

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
  --INNER JOIN HospitalInfo ON HospitalInfo.CountryId= [Lkp_Countries].[CountryId]     
  --AND Lkp_States.StateId=HospitalInfo.StateId AND Trans_TMCenterXCountry.CityId=HospitalInfo.CityId     
 WHERE Config_TMCenter.IsActive = 1                    
 AND Config_TMCenter.IsDeleted= 0 --AND HospitalInfo.HospitalId=@hospitalId                  
 ORDER BY Center                    
                
END 

-------------------------------------------------------------------------------------------------------------------------------------------------------------------  
  
CREATE PROCEDURE Proc_GetTMUsersAppointments --1,2,'31/07/2013','07/08/2013',0,1,2                                 
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

-------------------------------------------------------------------------------------------------------------------------------------------------------------------  

  
    
  -- =====================================================================================================                                      
-- Author:  <Sairam.T>                                      
-- Create date: <21-06-2012>                                      
-- Version : 1.0                                       
-- Description: <This procedure is used to Get Appointment By AppointmentType,Status,FromDate,ToDate and PatientId>                                      
-- =====================================================================================================                                      
CREATE PROCEDURE [dbo].[Proc_Appointments_GetTMAppointmentsByFromDateToDateandPatientId] --5,'09/05/2013','31/07/2013',200458                                    
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

-------------------------------------------------------------------------------------------------------------------------------------------------------------------  

  
       
-- ================================================                  
-- Author:  Sravan                  
-- Create date: 25 July 12                  
-- Version : 1.0                    
-- Description: SP to get all states and country                
-- ================================================                  
CREATE PROCEDURE [dbo].Proc_Admin_FindAllCenterByLocationId         
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

-------------------------------------------------------------------------------------------------------------------------------------------------------------------  


    
ALTER PROCEDURE Proc_UpdateTMAppointmentDetailsByTMAppointmentId                    
@AppointmentId int,                    
@AppointmentTypeId int,                    
@SpecialtyId int,                    
@DoctorId int,                    
@SpecialtyRemarks varchar(max),                    
@DoctorRemarks varchar(max),                    
@SlotTime varchar(100),                    
@HuserRemarks varchar(max),                    
@HealthCheckId int,                    
@HealthCheckRemarks varchar(max),                    
@ModifiedBy int,                    
@ModifiedIP varchar(100),                  
@IsEmailExists int,                  
@IsMobileExists int,              
@Password varchar(100),              
@AppointmentDate varchar(50),          
@IsUHIDExists int,    
@SlotID int                
AS                    
BEGIN                    
--Declare Variables                        
DECLARE @PatientName varchar(500)                 
DECLARE @EmailId varchar(200)              
DECLARE @MobileNumber varchar(200)              
DECLARE @UHID varchar(100)              
DECLARE @IsPrevRegistered int              
DECLARE @UserId int                 
DECLARE @ApppDate  datetime                
DECLARE @SalutationId int         
DECLARE @Gender varchar(100)          
DECLARE @Salutation varchar(100)   
DECLARE @PatientId varchar(100)    
  
SET @PatientId=0        
              
SET @ApppDate = CONVERT(DATETIME, @AppointmentDate, 103)                     
                        
SET @UserId = 0                        
                      
--Assign Values                        
SELECT @PatientName = PatientName,@EmailId =  EmailId, @MobileNumber = MobileNumber, @UHID = UHID, @IsPrevRegistered = IsPrevRegistered,        
   @SalutationId= [SalutationId], @Gender=[Gender]         
FROM [dbo].[TMUsersAppointmentsInfo] WHERE TMAppointmentId = @AppointmentId                      
                    
IF(@SalutationId = 1)        
BEGIN         
SET @Salutation='Mr.'        
        
END        
ELSE IF(@SalutationId = 2)        
BEGIN         
SET @Salutation='Mrs.'        
END          
ELSE IF(@SalutationId = 3)        
BEGIN         
SET @Salutation='Ms.'        
END           
ELSE IF(@SalutationId = 4)        
BEGIN         
SET @Salutation='Dr.'        
END           
ELSE IF(@SalutationId = 5)        
BEGIN         
SET @Salutation='Baby'        
END           
                    
IF((@IsEmailExists = 0 OR @IsEmailExists =-1) AND (@IsMobileExists = 0 OR @IsMobileExists = -1)AND (@IsUHIDExists = 0 OR @IsUHIDExists = -1))                    
BEGIN                    
INSERT INTO UserInfo(Email,FirstName,[Password],MobileNumber,UserType,IsActive,IsDeleted,CreatedBy,CreatedIP)                        
VALUES(@EmailId,@PatientName,@Password,@MobileNumber,4,1,0,@ModifiedBy,@ModifiedIP)                        
                        
SET @UserId = (SELECT @@IDENTITY)                          
                        
INSERT INTO PatientDetails(RefUserId,RelationType,FirstName,Email,UHID,MobileNumber,CreatedBy,CreatedIP,[Salutation],[Gender])                        
VALUES(@UserId,1,@PatientName,@EmailId,@UHID,@MobileNumber,@ModifiedBy,@ModifiedIP,@Salutation,@Gender)                        
                    
INSERT INTO UserXRoles(UserId,RoleId)Values(@UserId,4)     
  
SET @PatientId = (SELECT top 1 PatientId FROM PatientDetails where RefUserId=@UserId AND RelationType=1)                  
END                     
                    
ELSE                    
BEGIN                    
 IF(@IsEmailExists = 1 AND @IsMobileExists =1)                    
 BEGIN                    
  SET @UserId = (SELECT TOP 1 UserId FROM UserInfo WHERE Email = @EmailId AND IsActive=1 AND Isdeleted = 0)                    
 END                    
 ELSE                    
 BEGIN                    
  IF @IsEmailExists = 1                    
  BEGIN                    
   SET @UserId = (SELECT top 1 UserId FROM UserInfo WHERE Email = @EmailId AND IsActive=1 AND Isdeleted = 0)                    
  END                     
  ELSE IF @IsMobileExists = 1                    
  BEGIN                    
   SET @UserId = (SELECT top 1 UserId FROM UserInfo WHERE MobileNumber= @MobileNumber AND IsActive=1 AND Isdeleted = 0)                    
  END            
  ELSE IF @IsUHIDExists = 1                    
  BEGIN                    
   SET @UserId = (SELECT top 1 RefUserId FROM PatientDetails WHERE UHID= @UHID)                    
  END                    
 END                    
END                    
IF @AppointmentTypeId = 1 OR @AppointmentTypeId = 4                    
 BEGIN   
 IF @PatientId!= 0  
 BEGIN           
   UPDATE [dbo].[TMUsersAppointmentsInfo] SET                     
   ConfirmedSpecialityId = @SpecialtyId,                    
   ConfirmedDoctorId = @DoctorId,                    
   ConfirmedSpecialityRemarks = @SpecialtyRemarks,                    
   ConfirmedDoctorRemarks = @DoctorRemarks,               
   ConfirmedAppointmentDate = @ApppDate,                   
   ConfirmedSlotTime = @slotTime,      
   ConfirmedSlotTimeID=@SlotID,                  
   HuserRemarks = @HuserRemarks,                    
   ModifiedBy = @ModifiedBy,                    
   ModifiedIP = @ModifiedIP,                    
   ModifiedOn = GETDATE(),                  
   ConfirmStatus=1,  
   PatientId=@PatientId                    
   WHERE TMAppointmentId = @AppointmentId    
 END  
 ELSE  
 BEGIN  
  UPDATE [dbo].[TMUsersAppointmentsInfo] SET                     
   ConfirmedSpecialityId = @SpecialtyId,                    
   ConfirmedDoctorId = @DoctorId,                    
   ConfirmedSpecialityRemarks = @SpecialtyRemarks,                    
   ConfirmedDoctorRemarks = @DoctorRemarks,               
   ConfirmedAppointmentDate = @ApppDate,                   
   ConfirmedSlotTime = @slotTime,      
   ConfirmedSlotTimeID=@SlotID,                  
   HuserRemarks = @HuserRemarks,                    
   ModifiedBy = @ModifiedBy,                    
   ModifiedIP = @ModifiedIP,                    
   ModifiedOn = GETDATE(),                  
   ConfirmStatus=1                   
   WHERE TMAppointmentId = @AppointmentId    
 END                  
 END                    
 ELSE IF @AppointmentTypeId = 3                    
 BEGIN    
 IF @PatientId!= 0  
 BEGIN                    
   UPDATE [dbo].[TMUsersAppointmentsInfo] SET                     
   ConfirmedHealthCheckId = @HealthCheckId,                    
   ConfirmedHealthCheckRemarks = @HealthCheckRemarks,              
   ConfirmedAppointmentDate = @ApppDate,                    
   ConfirmedSlotTime = @slotTime,      
   ConfirmedSlotTimeID=@SlotID,                   
   HuserRemarks = @HuserRemarks,                    
   ModifiedBy = @ModifiedBy,                    
   ModifiedIP = @ModifiedIP,                    
   ModifiedOn = GETDATE() ,                  
   ConfirmStatus=1 ,  
   PatientId=@PatientId                       
  WHERE TMAppointmentId = @AppointmentId       
 END    
 ELSE  
 BEGIN  
    UPDATE [dbo].[TMUsersAppointmentsInfo] SET                     
   ConfirmedHealthCheckId = @HealthCheckId,                    
   ConfirmedHealthCheckRemarks = @HealthCheckRemarks,              
   ConfirmedAppointmentDate = @ApppDate,                    
   ConfirmedSlotTime = @slotTime,      
   ConfirmedSlotTimeID=@SlotID,                   
   HuserRemarks = @HuserRemarks,                    
   ModifiedBy = @ModifiedBy,                    
   ModifiedIP = @ModifiedIP,                    
   ModifiedOn = GETDATE() ,                  
   ConfirmStatus=1                      
  WHERE TMAppointmentId = @AppointmentId    
 END             
 END                    
 SELECT @UserId                   
END     
  
  
  