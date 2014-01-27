using System;
using System.Web;
using System.Text;
using System.Web.UI;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Web.UI.WebControls;
using ASPNET.StarterKit.BusinessLogicLayer;
using System.Configuration;

namespace ASPNET.StarterKit.DataAccessLayer {
  public class SQLDataAccess : DataAccess {
    /*** DELEGATE ***/

    private delegate void TGenerateListFromReader<T>(SqlDataReader returnData, ref List<T> tempList);

    /*****************************  BASE CLASS IMPLEMENTATION *****************************/

    /***  CATEGORY ***/
    private const string SP_CATEGORY_CREATE = "aspnet_starterkits_CreateNewCategory";
    private const string SP_CATEGORY_DELETE = "aspnet_starterkits_DeleteCategory";
    private const string SP_CATEGORY_GETALLCATEGORIES = "aspnet_starterkits_GetAllCategories";
    private const string SP_CATEGORY_GETCATEGORYBYPROJECTID = "aspnet_starterkits_GetCategoriesByProjectId";
    private const string SP_CATEGORY_GETCATEGORYBYID = "aspnet_starterkits_GetCategoryById";
    private const string SP_CATEGORY_GETCATEGORYBYNAMEANDPROJECT = "aspnet_starterkits_GetCategoryByNameAndProjectId";
    private const string SP_CATEGORY_GETCATEGORYBYNAME = "aspnet_starterkits_GetCategoriesByUserName";
      private const string SP_CATEGORY_UPDATE = "aspnet_starterkits_UpdateCategories";



    public override int CreateNewCategory(Category newCategory) {
      if (newCategory == null)
        throw (new ArgumentNullException("newCategory"));

      SqlCommand sqlCmd = new SqlCommand();

      AddParamToSQLCmd(sqlCmd, "@ReturnValue", SqlDbType.Int, 0, ParameterDirection.ReturnValue, null);
      AddParamToSQLCmd(sqlCmd, "@CategoryAbbreviation", SqlDbType.NText, 255, ParameterDirection.Input, newCategory.Abbreviation);
      AddParamToSQLCmd(sqlCmd, "@CategoryEstimateDuration", SqlDbType.Decimal, 0, ParameterDirection.Input, newCategory.EstimateDuration);
      AddParamToSQLCmd(sqlCmd, "@CategoryName", SqlDbType.NText, 255, ParameterDirection.Input, newCategory.Name);
      AddParamToSQLCmd(sqlCmd, "@ProjectId", SqlDbType.Int, 0, ParameterDirection.Input, newCategory.ProjectId);

      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_CATEGORY_CREATE);
      ExecuteScalarCmd(sqlCmd);

      return ((int)sqlCmd.Parameters["@ReturnValue"].Value);
    }

    public override bool DeleteCategory(int categoryId) {
      if (categoryId <= DefaultValues.GetCategoryIdMinValue())
        throw (new ArgumentOutOfRangeException("categoryId"));

      SqlCommand sqlCmd = new SqlCommand();

      AddParamToSQLCmd(sqlCmd, "@ReturnValue", SqlDbType.Int, 0, ParameterDirection.ReturnValue, null);
      AddParamToSQLCmd(sqlCmd, "@CategoryIdToDelete", SqlDbType.Int, 0, ParameterDirection.Input, categoryId);

      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_CATEGORY_DELETE);
      ExecuteScalarCmd(sqlCmd);

      int returnValue = (int)sqlCmd.Parameters["@ReturnValue"].Value;
      return (returnValue == 0 ? true : false);
    }

    public override List<Category> GetAllCategories() {
      SqlCommand sqlCmd = new SqlCommand();

      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_CATEGORY_GETALLCATEGORIES);

      List<Category> categoryList = new List<Category>();

      TExecuteReaderCmd<Category>(sqlCmd, TGenerateCategoryListFromReader<Category>, ref categoryList);

      return categoryList;
    }

    public override Category GetCategoryByCategoryId(int Id) {
      if (Id <= DefaultValues.GetCategoryIdMinValue())
        throw (new ArgumentOutOfRangeException("Id"));


      SqlCommand sqlCmd = new SqlCommand();

      AddParamToSQLCmd(sqlCmd, "@CategoryId", SqlDbType.Int, 0, ParameterDirection.Input, Id);

      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_CATEGORY_GETCATEGORYBYID);

      List<Category> categoryList = new List<Category>();

      TExecuteReaderCmd<Category>(sqlCmd, TGenerateCategoryListFromReader<Category>, ref categoryList);

      if (categoryList.Count > 0)
        return categoryList[0];
      else
        return null;

    }


    public override Category GetCategoryByCategoryNameandProjectId(string categoryName, int projectId)
        {
          if (projectId <= DefaultValues.GetProjectIdMinValue())
            throw (new ArgumentOutOfRangeException("Id"));


          SqlCommand sqlCmd = new SqlCommand();

          AddParamToSQLCmd(sqlCmd, "@ProjectId", SqlDbType.Int, 0, ParameterDirection.Input, projectId);
          AddParamToSQLCmd(sqlCmd, "@CategoryName", SqlDbType.NText, 255, ParameterDirection.Input, categoryName);

          SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_CATEGORY_GETCATEGORYBYNAMEANDPROJECT);

          List<Category> categoryList = new List<Category>();

          TExecuteReaderCmd<Category>(sqlCmd, TGenerateCategoryListFromReader<Category>, ref categoryList);

          if (categoryList.Count > 0)
            return categoryList[0];
          else
            return null;

        }



    public override List<Category> GetCategoriesByProjectId(int projectId) {
      if (projectId <= DefaultValues.GetProjectIdMinValue())
        throw (new ArgumentOutOfRangeException("projectId"));


      SqlCommand sqlCmd = new SqlCommand( );

      AddParamToSQLCmd(sqlCmd, "@ProjectId", SqlDbType.Int, 0, ParameterDirection.Input, projectId);

      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_CATEGORY_GETCATEGORYBYPROJECTID);

      List<Category> categoryList = new List<Category>();

      TExecuteReaderCmd<Category>(sqlCmd, TGenerateCategoryListFromReader<Category>, ref categoryList);


      return categoryList;
    }
    public override List<Category> GetCategoriesByUserName(string UserName)
    {
        //if (projectId <= DefaultValues.GetProjectIdMinValue())
        //    throw (new ArgumentOutOfRangeException("projectId"));


        SqlCommand sqlCmd = new SqlCommand();

        AddParamToSQLCmd(sqlCmd, "@UserName", SqlDbType.NVarChar, 0, ParameterDirection.Input, UserName);

        SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_CATEGORY_GETCATEGORYBYNAME);

        List<Category> categoryList = new List<Category>();

        TExecuteReaderCmd<Category>(sqlCmd, TGenerateCategoryListFromReader<Category>, ref categoryList);


        return categoryList;
    }

    public override bool UpdateCategory(Category newCategory) {
      if (newCategory == null)
        throw (new ArgumentNullException("newCategory"));

      if (newCategory.Id <= DefaultValues.GetCategoryIdMinValue())
        throw (new ArgumentOutOfRangeException("newCategory.Id"));

      SqlCommand sqlCmd = new SqlCommand();

      AddParamToSQLCmd(sqlCmd, "@ReturnValue", SqlDbType.Int, 0, ParameterDirection.ReturnValue, null);

      AddParamToSQLCmd(sqlCmd, "@CategoryId", SqlDbType.Int, 0, ParameterDirection.Input, newCategory.Id);
      AddParamToSQLCmd(sqlCmd, "@CategoryAbbreviation", SqlDbType.NText, 255, ParameterDirection.Input, newCategory.Abbreviation);
      AddParamToSQLCmd(sqlCmd, "@CategoryEstimateDuration", SqlDbType.Decimal, 0, ParameterDirection.Input, newCategory.EstimateDuration);
      AddParamToSQLCmd(sqlCmd, "@CategoryName", SqlDbType.NText, 255, ParameterDirection.Input, newCategory.Name);
      AddParamToSQLCmd(sqlCmd, "@ProjectId", SqlDbType.Int, 0, ParameterDirection.Input, newCategory.ProjectId);

      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_CATEGORY_UPDATE);
      ExecuteScalarCmd(sqlCmd);

      int returnValue = (int)sqlCmd.Parameters["@ReturnValue"].Value;
      return (returnValue == 0 ? true : false);
    }


    /***  PROJECT ***/
    private const string SP_PROJECT_ADDUSERTOPROJECT = "aspnet_starterkits_AddUserToProject";
    private const string SP_PROJECT_CREATE = "aspnet_starterkits_CreateNewProject";
    private const string SP_PROJECT_DELETE = "aspnet_starterkits_DeleteProject";
    private const string SP_PROJECT_GETALLPROJECTS = "aspnet_starterkits_GetAllProjects";
    private const string SP_PROJECT_GETALLPROJECTSREPORT = "aspnet_starterkits_GetAllProjectsReport";
    private const string SP_PROJECT_GETAPROJECTBYID = "aspnet_starterkits_GetProjectById";
    private const string SP_PROJECT_GETAPROJECTREPORTBYIDANDDATES = "aspnet_starterkits_GetProjectReportByIdAndDates";
    private const string SP_PROJECT_GETAPROJECTREPORTBYIDANDMONTHANDYEAR = "aspnet_starterkits_GetProjectReportByIdAndMonthAndYear";
    private const string SP_PROJECT_GETAPROJECTSBYMANAGERUSERNAME = "aspnet_starterkits_GetProjectByManagerUserName";
    private const string SP_PROJECT_GETPROJECTSBYYSERNAME = "aspnet_starterkits_GetProjectByUserName";
    private const string SP_PROJECT_GETPROJECTMEMBERS = "aspnet_starterkits_GetProjectMember";
    private const string SP_PROJECT_REMOVEUSERFROMPROJECT = "aspnet_starterkits_RemoveUserFromProject";
    private const string SP_PROJECT_UPDATE = "aspnet_starterkits_UpdateProject";

    private const string SP_PROJECT_GETALLOpenPROJECTS = "aspnet_starterkits_GetAllOpenProjects";
    private const string SP_PROJECT_GETALLClosedPROJECTS = "aspnet_starterkits_GetAllClosedProjects";

    private const string SP_PROJECT_GETAOpenPROJECTSBYMANAGERUSERNAME = "aspnet_starterkits_GetOpenProjectByManagerUserName";

    private const string SP_PROJECT_GETAClosePROJECTSBYMANAGERUSERNAME = "aspnet_starterkits_GetCloseProjectByManagerUserName";


    public override bool AddUserToProject(int projectId, string userName) {
      if (userName == null || userName.Length == 0)
        throw (new ArgumentOutOfRangeException("userName"));

      if (projectId <= 0)
        throw (new ArgumentOutOfRangeException("projectId"));
        
      SqlCommand sqlCmd = new SqlCommand();

      AddParamToSQLCmd(sqlCmd, "@ResultValue", SqlDbType.Int, 0, ParameterDirection.ReturnValue, null);

      AddParamToSQLCmd(sqlCmd, "@MemberUserName", SqlDbType.NText, 255, ParameterDirection.Input, userName);
      AddParamToSQLCmd(sqlCmd, "@ProjectId", SqlDbType.Int, 0, ParameterDirection.Input, projectId);

      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_PROJECT_ADDUSERTOPROJECT);
      ExecuteScalarCmd(sqlCmd);

      int resultValue = (int)sqlCmd.Parameters["@ResultValue"].Value;

      return (resultValue == 0 ? true : false);
    }


    public override int CreateNewProject(Project newProject) {
      if (newProject == null)
        throw (new ArgumentNullException("newProject"));
      SqlCommand sqlCmd = new SqlCommand();
      AddParamToSQLCmd(sqlCmd, "@ReturnValue", SqlDbType.Int, 0, ParameterDirection.ReturnValue, null);
      AddParamToSQLCmd(sqlCmd, "@ProjectCreatorUserName", SqlDbType.NText, 255, ParameterDirection.Input, newProject.CreatorUserName);
      AddParamToSQLCmd(sqlCmd, "@ProjectCompletionDate", SqlDbType.DateTime, 0, ParameterDirection.Input, newProject.CompletionDate);
      AddParamToSQLCmd(sqlCmd, "@ProjectDescription", SqlDbType.NText, 1000, ParameterDirection.Input, newProject.Description);     
      AddParamToSQLCmd(sqlCmd, "@ProjectManagerUserName", SqlDbType.NText, 255, ParameterDirection.Input, newProject.ManagerUserName);
      AddParamToSQLCmd(sqlCmd, "@ProjectName", SqlDbType.NText, 255, ParameterDirection.Input, newProject.Name);
      AddParamToSQLCmd(sqlCmd, "@DevelopmentEstimateDuration", SqlDbType.Decimal, 0, ParameterDirection.Input, newProject.DevelopmentEstimateDuration);
      AddParamToSQLCmd(sqlCmd, "@TestingEstimateDuration", SqlDbType.Decimal, 0, ParameterDirection.Input, newProject.TestingEstimateDuration);
      AddParamToSQLCmd(sqlCmd, "@DesignEstimateDuration", SqlDbType.Decimal, 0, ParameterDirection.Input, newProject.DesignEstimateDuration);
      AddParamToSQLCmd(sqlCmd, "@BAEstimateDuration", SqlDbType.Decimal, 0, ParameterDirection.Input, newProject.BAEstimateDuration);
      AddParamToSQLCmd(sqlCmd, "@ProjectManagementEstimateDuration", SqlDbType.Decimal, 0, ParameterDirection.Input, newProject.ProjectManagementEstimateDuration);
      AddParamToSQLCmd(sqlCmd, "@OtherHours", SqlDbType.Decimal, 0, ParameterDirection.Input, newProject.OtherDuration);
      AddParamToSQLCmd(sqlCmd, "@ProjectEstimateDuration", SqlDbType.Decimal, 0, ParameterDirection.Input, newProject.EstimateDuration);
      AddParamToSQLCmd(sqlCmd, "@IsCompleted", SqlDbType.Bit, 0, ParameterDirection.Input, newProject.IsCompleted);
      AddParamToSQLCmd(sqlCmd, "@ClientName", SqlDbType.VarChar, 0, ParameterDirection.Input, newProject.ClientName);
      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_PROJECT_CREATE);
      ExecuteScalarCmd(sqlCmd);
      return ((int)sqlCmd.Parameters["@ReturnValue"].Value);
    }

    public override bool DeleteProject(int projectID) {
      if (projectID <= 0)
        throw (new ArgumentOutOfRangeException("projectID"));

      SqlCommand sqlCmd = new SqlCommand();

      AddParamToSQLCmd(sqlCmd, "@ReturnValue", SqlDbType.Int, 0, ParameterDirection.ReturnValue, null);

      AddParamToSQLCmd(sqlCmd, "@ProjectIdToDelete", SqlDbType.Int, 0, ParameterDirection.Input, projectID);

      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_PROJECT_DELETE);
      ExecuteScalarCmd(sqlCmd);

      int returnValue = (int)sqlCmd.Parameters["@ReturnValue"].Value;

      return (returnValue == 0 ? true : false);
    }

    public override List<Project> GetAllProjects() {
      SqlCommand sqlCmd = new SqlCommand();

      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_PROJECT_GETALLPROJECTS);

      List<Project> prjList = new List<Project>();

      TExecuteReaderCmd<Project>(sqlCmd, TGenerateProjectListFromReader<Project>, ref prjList);

      return prjList;
    }

    public override List<Project> GetAllOpenProjects()
    {
        SqlCommand sqlCmd = new SqlCommand();

        SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_PROJECT_GETALLOpenPROJECTS);

        List<Project> prjList = new List<Project>();

        TExecuteReaderCmd<Project>(sqlCmd, TGenerateProjectListFromReader<Project>, ref prjList);

        return prjList;
    }


    public override List<Project> GetAllClosedProjects()
    {
        SqlCommand sqlCmd = new SqlCommand();

        SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_PROJECT_GETALLClosedPROJECTS);

        List<Project> prjList = new List<Project>();

        TExecuteReaderCmd<Project>(sqlCmd, TGenerateProjectListFromReader<Project>, ref prjList);

        return prjList;
    }


    public override List<Project> GetAllProjectsReport()
    {
        SqlCommand sqlCmd = new SqlCommand();

        SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_PROJECT_GETALLPROJECTSREPORT);

        List<Project> prjList = new List<Project>();

        TExecuteReaderCmd<Project>(sqlCmd, TGenerateProjectListFromReader<Project>, ref prjList);

        return prjList;
    }

    public override Project GetProjectById(int projectId) {
      if (projectId <= 0)
        throw (new ArgumentOutOfRangeException("projectId"));

      SqlCommand sqlCmd = new SqlCommand();

      AddParamToSQLCmd(sqlCmd, "@ProjectId", SqlDbType.Int, 0, ParameterDirection.Input, projectId);

      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_PROJECT_GETAPROJECTBYID);

      List<Project> prjList = new List<Project>();

      TExecuteReaderCmd<Project>(sqlCmd, TGenerateProjectListFromReader<Project>, ref prjList);

      if (prjList.Count > 0)
        return prjList[0];
      else
        return null;
    }

    public override Project GetProjectReportByIdAndDates(int projectId, DateTime StartDate,DateTime EndDate)
    {
        if (projectId <= 0)
            throw (new ArgumentOutOfRangeException("projectId"));

        SqlCommand sqlCmd = new SqlCommand();

        AddParamToSQLCmd(sqlCmd, "@ProjectId", SqlDbType.Int, 0, ParameterDirection.Input, projectId);
        AddParamToSQLCmd(sqlCmd, "@StartDate", SqlDbType.DateTime, 0, ParameterDirection.Input, StartDate);
        AddParamToSQLCmd(sqlCmd, "@EndDate", SqlDbType.DateTime, 0, ParameterDirection.Input, EndDate);

        SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_PROJECT_GETAPROJECTREPORTBYIDANDDATES);

        List<Project> prjList = new List<Project>();

        TExecuteReaderCmd<Project>(sqlCmd, GenerateProjectListFromReader<Project>, ref prjList);

        if (prjList.Count > 0)
            return prjList[0];
        else
            return null;
    }


    public override Project GetProjectReportByIdAndMonthAndYear(int projectId, int Month, int Year)
    {
        if (projectId <= 0)
            throw (new ArgumentOutOfRangeException("projectId"));

        SqlCommand sqlCmd = new SqlCommand();

        AddParamToSQLCmd(sqlCmd, "@ProjectId", SqlDbType.Int, 0, ParameterDirection.Input, projectId);
        AddParamToSQLCmd(sqlCmd, "@Month", SqlDbType.Int, 0, ParameterDirection.Input, Month);
        AddParamToSQLCmd(sqlCmd, "@year", SqlDbType.Int, 0, ParameterDirection.Input, Year);

        SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_PROJECT_GETAPROJECTREPORTBYIDANDMONTHANDYEAR);

        List<Project> prjList = new List<Project>();

        TExecuteReaderCmd<Project>(sqlCmd, GenerateProjectListFromReader<Project>, ref prjList);

        if (prjList.Count > 0)
            return prjList[0];
        else
            return null;
    }
   

    public override List<Project> GetProjectsByManagerUserName(string userName) {
      if (userName == null || userName.Length == 0)
        throw (new ArgumentOutOfRangeException("userName"));

      SqlCommand sqlCmd = new SqlCommand();

      AddParamToSQLCmd(sqlCmd, "@ProjectManagerUserName", SqlDbType.NText, 256, ParameterDirection.Input, userName);
      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_PROJECT_GETAPROJECTSBYMANAGERUSERNAME);

      List<Project> prjList = new List<Project>();

      TExecuteReaderCmd<Project>(sqlCmd, TGenerateProjectListFromReader<Project>, ref prjList);

      return prjList;


    }

    public override List<Project> GetOpenProjectsByManagerUserName(string userName)
    {
        if (userName == null || userName.Length == 0)
            throw (new ArgumentOutOfRangeException("userName"));

        SqlCommand sqlCmd = new SqlCommand();

        AddParamToSQLCmd(sqlCmd, "@ProjectManagerUserName", SqlDbType.NText, 256, ParameterDirection.Input, userName);
        SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_PROJECT_GETAOpenPROJECTSBYMANAGERUSERNAME);

        List<Project> prjList = new List<Project>();

        TExecuteReaderCmd<Project>(sqlCmd, TGenerateProjectListFromReader<Project>, ref prjList);

        return prjList;


    }

    public override List<Project> GetCloseProjectsByManagerUserName(string userName)
    {
        if (userName == null || userName.Length == 0)
            throw (new ArgumentOutOfRangeException("userName"));

        SqlCommand sqlCmd = new SqlCommand();

        AddParamToSQLCmd(sqlCmd, "@ProjectManagerUserName", SqlDbType.NText, 256, ParameterDirection.Input, userName);
        SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_PROJECT_GETAClosePROJECTSBYMANAGERUSERNAME);

        List<Project> prjList = new List<Project>();

        TExecuteReaderCmd<Project>(sqlCmd, TGenerateProjectListFromReader<Project>, ref prjList);

        return prjList;


    }

    public override List<string> GetProjectMembers(int Id) {
      if (Id <= 0)
        throw (new ArgumentOutOfRangeException("Id"));

      SqlCommand sqlCmd = new SqlCommand();

      AddParamToSQLCmd(sqlCmd, "@ProjectId", SqlDbType.Int, 0, ParameterDirection.Input, Id);

      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_PROJECT_GETPROJECTMEMBERS);

      List<string> userList = new List<string>();

      TExecuteReaderCmd<string>(sqlCmd, TGenerateUsertListFromReaderForMembers<string>, ref userList);

      //TExecuteReaderCmd<string>(sqlCmd, TGenerateUsertListFromReader<string>, ref userList);

      return userList;

    }

    public override List<Project> GetProjectsByUserName(string userName) {
      if (userName == null || userName.Length == 0)
        throw (new ArgumentOutOfRangeException("userName"));

      SqlCommand sqlCmd = new SqlCommand();

      AddParamToSQLCmd(sqlCmd, "@UserName", SqlDbType.NText, 256, ParameterDirection.Input, userName);
      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_PROJECT_GETPROJECTSBYYSERNAME);

      List<Project> prjList = new List<Project>();

      TExecuteReaderCmd<Project>(sqlCmd, TGenerateProjectListFromReader<Project>, ref prjList);

      return prjList;
    
      
//      return (new List<Project>());

    }


    public override bool RemoveUserFromProject(int projectId, string userName) {
      if (String.IsNullOrEmpty(userName))
        throw (new ArgumentOutOfRangeException("userName"));
      if (projectId <= 0)
        throw (new ArgumentOutOfRangeException("projectId"));

      SqlCommand sqlCmd = new SqlCommand();

      AddParamToSQLCmd(sqlCmd, "@ResultValue", SqlDbType.Int, 0, ParameterDirection.ReturnValue, null);
      AddParamToSQLCmd(sqlCmd, "@userName", SqlDbType.NVarChar, 0, ParameterDirection.Input, userName);
      AddParamToSQLCmd(sqlCmd, "@ProjectId", SqlDbType.Int, 0, ParameterDirection.Input, projectId);

      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_PROJECT_REMOVEUSERFROMPROJECT);
      ExecuteScalarCmd(sqlCmd);

      int resultValue = (int)sqlCmd.Parameters["@ResultValue"].Value;

      return (resultValue == 0 ? true : false);
    }

    public override bool UpdateProject(Project projectToUpdate) {
      // validate input
      if (projectToUpdate == null)
        throw (new ArgumentNullException("projectToUpdate"));
      // validate input
      if (projectToUpdate.Id <= 0)
        throw (new ArgumentOutOfRangeException("projectToUpdate"));

      SqlCommand sqlCmd = new SqlCommand();
      // set the type of parameter to add a new project
      AddParamToSQLCmd(sqlCmd, "@ReturnValue", SqlDbType.Int, 0, ParameterDirection.ReturnValue, null);

      AddParamToSQLCmd(sqlCmd, "@ProjectId", SqlDbType.Int, 0, ParameterDirection.Input, projectToUpdate.Id);
      AddParamToSQLCmd(sqlCmd, "@ProjectCompletionDate", SqlDbType.DateTime, 0, ParameterDirection.Input, projectToUpdate.CompletionDate);
      AddParamToSQLCmd(sqlCmd, "@ProjectDescription", SqlDbType.NText, 1000, ParameterDirection.Input, projectToUpdate.Description);
      AddParamToSQLCmd(sqlCmd, "@DevelopmentEstimateDuration", SqlDbType.Decimal, 0, ParameterDirection.Input, projectToUpdate.DevelopmentEstimateDuration);
      AddParamToSQLCmd(sqlCmd, "@TestingEstimateDuration", SqlDbType.Decimal, 0, ParameterDirection.Input, projectToUpdate.TestingEstimateDuration);
      AddParamToSQLCmd(sqlCmd, "@DesignEstimateDuration", SqlDbType.Decimal, 0, ParameterDirection.Input, projectToUpdate.DesignEstimateDuration);
      AddParamToSQLCmd(sqlCmd, "@BAEstimateDuration", SqlDbType.Decimal, 0, ParameterDirection.Input, projectToUpdate.BAEstimateDuration);
      AddParamToSQLCmd(sqlCmd, "@ProjectManagementEstimateDuration", SqlDbType.Decimal, 0, ParameterDirection.Input, projectToUpdate.ProjectManagementEstimateDuration);
      AddParamToSQLCmd(sqlCmd, "@OtherHours", SqlDbType.Decimal, 0, ParameterDirection.Input, projectToUpdate.OtherDuration);
      AddParamToSQLCmd(sqlCmd, "@ProjectEstimateDuration", SqlDbType.Decimal, 1, ParameterDirection.Input, projectToUpdate.EstimateDuration);
      AddParamToSQLCmd(sqlCmd, "@ProjectManagerUserName", SqlDbType.NText, 256, ParameterDirection.Input, projectToUpdate.ManagerUserName);
      AddParamToSQLCmd(sqlCmd, "@ProjectName", SqlDbType.NText, 256, ParameterDirection.Input, projectToUpdate.Name);
      AddParamToSQLCmd(sqlCmd, "@IsCompleted", SqlDbType.Bit, 256, ParameterDirection.Input, projectToUpdate.IsCompleted);
      AddParamToSQLCmd(sqlCmd, "@ClientName", SqlDbType.VarChar, 256, ParameterDirection.Input, projectToUpdate.ClientName);

      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_PROJECT_UPDATE);
      ExecuteScalarCmd(sqlCmd);

      int returnValue = (int)sqlCmd.Parameters["@ReturnValue"].Value;

      return (returnValue == 0 ? true : false);
    }


    /*** TIME ENTRY ***/
    private string SP_TIMEENTRY_CREATE = "aspnet_starterkits_CreateNewTimeEntry";
    private string SP_TIMEENTRY_DELETE = "aspnet_starterkits_DeleteTimeEntry";
    private string SP_TIMEENTRY_GETALLTIMEENTRIES = "aspnet_starterkits_GetAllTimeEntries";
    private string SP_TIMEENTRY_GETALLTIMEENTRIESBYPROJECTID_USER = "aspnet_starterkits_GetAllTimeEntriesByProjectIdandUser";
    private string SP_TIMEENTRY_GETALLTIMEENTRIESBYUSERNAMEANDDATE = "aspnet_starterkits_GetAllTimeEntriesByProjectIdandUserAndDate";
    private string SP_TIMEENTRY_UPDATE = "aspnet_starterkits_UpdateTimeEntry";
    private string SP_TIMEENTRY_GETTIMEENTRYBYID = "aspnet_starterkits_GetTimeEntryById";



    public override int CreateNewTimeEntry(TimeEntry newTimeEntry) {

      if (newTimeEntry == null)
        throw (new ArgumentNullException("newTimeEntry"));


      SqlCommand sqlCmd = new SqlCommand();

      AddParamToSQLCmd(sqlCmd, "@ReturnValue", SqlDbType.Int, 0, ParameterDirection.ReturnValue, null);
      AddParamToSQLCmd(sqlCmd, "@ProjectId", SqlDbType.Int, 0, ParameterDirection.Input, newTimeEntry.ProjectId);
      AddParamToSQLCmd(sqlCmd, "@CategoryId", SqlDbType.Int, 0, ParameterDirection.Input, newTimeEntry.CategoryId);
      AddParamToSQLCmd(sqlCmd, "@TimeEntryCreatorUserName", SqlDbType.NText, 255, ParameterDirection.Input, newTimeEntry.CreatorUserName);
      AddParamToSQLCmd(sqlCmd, "@TimeEntryDescription", SqlDbType.NText, 1000, ParameterDirection.Input, newTimeEntry.Description);
      AddParamToSQLCmd(sqlCmd, "@TimeEntryEstimateDuration", SqlDbType.Decimal, 0, ParameterDirection.Input, newTimeEntry.Duration);
      AddParamToSQLCmd(sqlCmd, "@TimeEntryEnteredDate", SqlDbType.DateTime, 0, ParameterDirection.Input, newTimeEntry.ReportedDate);
      AddParamToSQLCmd(sqlCmd, "@TimeEntryUserName", SqlDbType.NText, 255, ParameterDirection.Input, newTimeEntry.UserName);
        
      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_TIMEENTRY_CREATE);

      ExecuteScalarCmd(sqlCmd);

      return ((int)sqlCmd.Parameters["@ReturnValue"].Value);
    }

    public override bool DeleteTimeEntry(int timeEntryId) {
      if (timeEntryId <= DefaultValues.GetTimeEntryIdMinValue())
        throw (new ArgumentOutOfRangeException("timeEntryId"));

      SqlCommand sqlCmd = new SqlCommand();

      AddParamToSQLCmd(sqlCmd, "@ReturnValue", SqlDbType.Int, 0, ParameterDirection.ReturnValue, null);
      AddParamToSQLCmd(sqlCmd, "@TimeEntryIdToDelete", SqlDbType.Int, 0, ParameterDirection.Input, timeEntryId);

      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_TIMEENTRY_DELETE);
      ExecuteScalarCmd(sqlCmd);

      int returnValue = (int)sqlCmd.Parameters["@ReturnValue"].Value;

      return (returnValue == 0 ? true : false);

    }

    public override List<TimeEntry> GetAllTimeEntries() {

      SqlCommand sqlCmd = new SqlCommand();

      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_TIMEENTRY_GETALLTIMEENTRIES);

      List<TimeEntry> timeEntryList = new List<TimeEntry>();

      TExecuteReaderCmd<TimeEntry>(sqlCmd, TGenerateTimeEntryListFromReader<TimeEntry>, ref timeEntryList);

      return timeEntryList;
    }

    public override List<TimeEntry> GetTimeEntries(int projectId, string userName) {
      if (projectId <= DefaultValues.GetTimeEntryIdMinValue())
        throw (new ArgumentOutOfRangeException("projectId"));

      SqlCommand sqlCmd = new SqlCommand();

      AddParamToSQLCmd(sqlCmd, "@ReturnValue", SqlDbType.Int, 0, ParameterDirection.ReturnValue, null);
      AddParamToSQLCmd(sqlCmd, "@ProjectId", SqlDbType.Int, 0, ParameterDirection.Input, projectId);
      AddParamToSQLCmd(sqlCmd, "@TimeEntryUserName", SqlDbType.NText, 255, ParameterDirection.Input, userName);


      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_TIMEENTRY_GETALLTIMEENTRIESBYPROJECTID_USER);

      List<TimeEntry> timeEntryList = new List<TimeEntry>();

      TExecuteReaderCmd<TimeEntry>(sqlCmd, TGenerateTimeEntryListFromReader<TimeEntry>, ref timeEntryList);

      return timeEntryList;
    }

    public override TimeEntry GetTimeEntryById(int timeEntryId) {
      if (timeEntryId <= 0)
        throw (new ArgumentOutOfRangeException("timeEntryId"));

      SqlCommand sqlCmd = new SqlCommand();

      AddParamToSQLCmd(sqlCmd, "@TimeEntryId", SqlDbType.Int, 0, ParameterDirection.Input, timeEntryId);

      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_TIMEENTRY_GETTIMEENTRYBYID);

      List<TimeEntry> timeEntryList = new List<TimeEntry>();


      TExecuteReaderCmd<TimeEntry>(sqlCmd, TGenerateTimeEntryListFromReader<TimeEntry>, ref timeEntryList);

      if (timeEntryList.Count > 0)
        return timeEntryList[0];
      else
        return null;

    }

    public override List<TimeEntry> GetTimeEntriesByUserNameAndDates(string userName,
                                                                      DateTime startingDate, DateTime endDate) {
      SqlCommand sqlCmd = new SqlCommand();

      AddParamToSQLCmd(sqlCmd, "@ReturnValue", SqlDbType.Int, 0, ParameterDirection.ReturnValue, null);
      AddParamToSQLCmd(sqlCmd, "@EndDate", SqlDbType.DateTime, 0, ParameterDirection.Input, endDate);
      AddParamToSQLCmd(sqlCmd, "@StartingDate", SqlDbType.DateTime, 0, ParameterDirection.Input, startingDate);
      AddParamToSQLCmd(sqlCmd, "@TimeEntryUserName", SqlDbType.NText, 255, ParameterDirection.Input, userName);


      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_TIMEENTRY_GETALLTIMEENTRIESBYUSERNAMEANDDATE);

      List<TimeEntry> timeEntryList = new List<TimeEntry>();

      TExecuteReaderCmd<TimeEntry>(sqlCmd, TGenerateTimeEntryListFromReader<TimeEntry>, ref timeEntryList);

      return timeEntryList;

    }
    public override List<TimeEntry> GetTimeEntriesByUserNameProjectIdAndDates(string userName, string ProjectId,
                                                                   DateTime startingDate, DateTime endDate)
    {
        TimeEntry.totalhours = 0;
        SqlCommand sqlCmd = new SqlCommand();

        AddParamToSQLCmd(sqlCmd, "@ReturnValue", SqlDbType.Int, 0, ParameterDirection.ReturnValue, null);
        AddParamToSQLCmd(sqlCmd, "@ProjectId", SqlDbType.VarChar, 0, ParameterDirection.Input, ProjectId);
        AddParamToSQLCmd(sqlCmd, "@EndDate", SqlDbType.DateTime, 0, ParameterDirection.Input, endDate);
        AddParamToSQLCmd(sqlCmd, "@StartingDate", SqlDbType.DateTime, 0, ParameterDirection.Input, startingDate);
        AddParamToSQLCmd(sqlCmd, "@TimeEntryUserName", SqlDbType.NText, 255, ParameterDirection.Input, userName);


        SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_TIMEENTRY_GETALLTIMEENTRIESBYUSERNAMEANDDATE);

        List<TimeEntry> timeEntryList = new List<TimeEntry>();

        TExecuteReaderCmd<TimeEntry>(sqlCmd, TGenerateTimeEntryListFromReader<TimeEntry>, ref timeEntryList);

        return timeEntryList;

    }

    private string SP_TIMEENTRY_GETALLTIMEENTRIESBYUSERNAMEANDMONTHANDYEAR = "aspnet_starterkits_GetAllTimeEntriesByProjectIdandUserAndMonthAndYear";
    public override List<TimeEntry> GetTimeEntriesByUserNameProjectIdAndMonthAndYear(string userName, string ProjectId,
                                                                int Month, int year)
    {
        TimeEntry.totalhours = 0;
        SqlCommand sqlCmd = new SqlCommand();

        AddParamToSQLCmd(sqlCmd, "@ReturnValue", SqlDbType.Int, 0, ParameterDirection.ReturnValue, null);
        AddParamToSQLCmd(sqlCmd, "@ProjectId", SqlDbType.VarChar, 0, ParameterDirection.Input, ProjectId);
        AddParamToSQLCmd(sqlCmd, "@year", SqlDbType.Int, 0, ParameterDirection.Input, year);
        AddParamToSQLCmd(sqlCmd, "@Month", SqlDbType.Int, 0, ParameterDirection.Input, Month);
        AddParamToSQLCmd(sqlCmd, "@TimeEntryUserName", SqlDbType.NText, 255, ParameterDirection.Input, userName);


        SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_TIMEENTRY_GETALLTIMEENTRIESBYUSERNAMEANDMONTHANDYEAR);

        List<TimeEntry> timeEntryList = new List<TimeEntry>();

        TExecuteReaderCmd<TimeEntry>(sqlCmd, TGenerateTimeEntryListFromReader<TimeEntry>, ref timeEntryList);

        return timeEntryList;

    }
    

    public override bool UpdateTimeEntry(TimeEntry timeEntry) {
      if (timeEntry == null)
        throw (new ArgumentNullException("timeEntry"));


      SqlCommand sqlCmd = new SqlCommand();

      AddParamToSQLCmd(sqlCmd, "@ReturnValue", SqlDbType.Int, 0, ParameterDirection.ReturnValue, null);


      AddParamToSQLCmd(sqlCmd, "@TimeEntryId", SqlDbType.Int, 0, ParameterDirection.Input, timeEntry.Id);
      //AddParamToSQLCmd(sqlCmd, "@CategoryId", SqlDbType.Int, 0, ParameterDirection.Input, timeEntry.CategoryId);
      AddParamToSQLCmd(sqlCmd, "@TimeEntryDescription", SqlDbType.NText, 1000, ParameterDirection.Input, timeEntry.Description);
      AddParamToSQLCmd(sqlCmd, "@TimeEntryEstimateDuration", SqlDbType.Decimal, 1, ParameterDirection.Input, timeEntry.Duration);
      AddParamToSQLCmd(sqlCmd, "@TimeEntryEnteredDate", SqlDbType.DateTime, 0, ParameterDirection.Input, timeEntry.ReportedDate);
      AddParamToSQLCmd(sqlCmd, "@TimeEntryUserName", SqlDbType.NText, 1000, ParameterDirection.Input, timeEntry.UserName);


      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_TIMEENTRY_UPDATE);
      ExecuteScalarCmd(sqlCmd);
      int resultValue = (int)sqlCmd.Parameters["@ReturnValue"].Value;

      return (resultValue == 0 ? true : false);
    }

    /***  USER REPORT ***/
     
    private string SP_TIMEENTRY_GETCATEGORYREPORTBYCATEGORYIDANDDATES = "aspnet_starterkits_GetTimeEntryUserReportByCategoryIdAndDates";
    private string SP_TIMEENTRY_GETCATEGORYREPORTBYCATEGORYIDANDMONTHANDYEAR = "aspnet_starterkits_GetTimeEntryUserReportByCategoryIdAndMonthAndYear";
    private string SP_TIMEENTRY_GETUSERREPORTBYPROJECTIDANDDATES = "aspnet_starterkits_GetTimeEntryUserReportByProjectIdAndDates";
    private string SP_TIMEENTRY_GETUSERREPORTBYCATEGORY = "aspnet_starterkits_GetTimeEntryUserReportByCategoryId";

    public override List<UserReport> GetUserReportsByProjectIdAndDates(int projectId, DateTime StartDate, DateTime EndDate)
    {

      SqlCommand sqlCmd = new SqlCommand();
      AddParamToSQLCmd(sqlCmd, "@ProjectId", SqlDbType.Int, 0, ParameterDirection.Input, projectId);
      AddParamToSQLCmd(sqlCmd, "@StartDate", SqlDbType.DateTime, 0, ParameterDirection.Input, StartDate);
      AddParamToSQLCmd(sqlCmd, "@EndDate", SqlDbType.DateTime, 0, ParameterDirection.Input, EndDate);
      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_TIMEENTRY_GETUSERREPORTBYPROJECTIDANDDATES);

      List<UserReport> userReport = new List<UserReport>();

      TExecuteReaderCmd<UserReport>(sqlCmd, TGenerateUserReportListFromReader<UserReport>, ref userReport);

      return userReport;
    }


    private string SP_TIMEENTRY_GETUSERREPORTBYPROJECTIDANDMONTHANDDATES = "aspnet_starterkits_GetTimeEntryUserReportByProjectIdAndMonthAndYear";
    public override List<UserReport> GetUserReportsByProjectIdAndMonthAndYear(int projectId, Int32 Month, Int32 Year)
    {

        SqlCommand sqlCmd = new SqlCommand();

        AddParamToSQLCmd(sqlCmd, "@ProjectId", SqlDbType.Int, 0, ParameterDirection.Input, projectId);
        AddParamToSQLCmd(sqlCmd, "@Month", SqlDbType.Int, 0, ParameterDirection.Input, Month);
        AddParamToSQLCmd(sqlCmd, "@Year", SqlDbType.Int, 0, ParameterDirection.Input, Year);
        SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_TIMEENTRY_GETUSERREPORTBYPROJECTIDANDMONTHANDDATES);

        List<UserReport> userReport = new List<UserReport>();

        TExecuteReaderCmd<UserReport>(sqlCmd, TGenerateUserReportListFromReader<UserReport>, ref userReport);

        return userReport;
    }


    public override List<UserReport> GetCategoryReportsByCategoryIdAndDates(int CategoryId, DateTime StartDate, DateTime EndDate, string ProjectIds)
    {

        SqlCommand sqlCmd = new SqlCommand();

        AddParamToSQLCmd(sqlCmd, "@CategoryId", SqlDbType.Int, 0, ParameterDirection.Input, CategoryId);
        AddParamToSQLCmd(sqlCmd, "@StartDate", SqlDbType.DateTime, 0, ParameterDirection.Input, StartDate);
        AddParamToSQLCmd(sqlCmd, "@EndDate", SqlDbType.DateTime, 0, ParameterDirection.Input, EndDate);
        AddParamToSQLCmd(sqlCmd, "@ProjectId", SqlDbType.VarChar, 0, ParameterDirection.Input, ProjectIds);
        SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_TIMEENTRY_GETCATEGORYREPORTBYCATEGORYIDANDDATES);

        List<UserReport> userReport = new List<UserReport>();

        TExecuteReaderCmd<UserReport>(sqlCmd, TGenerateUserReportListFromReader<UserReport>, ref userReport);

        return userReport;
    }

    public override List<UserReport> GetCategoryReportsByCategoryIdAndMonthAndYear(int CategoryId, int Month, int year,string ProjectId)
    {

        SqlCommand sqlCmd = new SqlCommand();

        AddParamToSQLCmd(sqlCmd, "@CategoryId", SqlDbType.Int, 0, ParameterDirection.Input, CategoryId);
        AddParamToSQLCmd(sqlCmd, "@Month", SqlDbType.Int, 0, ParameterDirection.Input, Month);
        AddParamToSQLCmd(sqlCmd, "@year", SqlDbType.Int, 0, ParameterDirection.Input, year);
        AddParamToSQLCmd(sqlCmd, "@ProjectId", SqlDbType.VarChar, 0, ParameterDirection.Input, ProjectId);
        SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_TIMEENTRY_GETCATEGORYREPORTBYCATEGORYIDANDMONTHANDYEAR);

        List<UserReport> userReport = new List<UserReport>();

        TExecuteReaderCmd<UserReport>(sqlCmd, TGenerateUserReportListFromReader<UserReport>, ref userReport);

        return userReport;
    }


    public override List<UserReport> GetUserReportsByCategoryId(int categoryId) {

      SqlCommand sqlCmd = new SqlCommand();

      AddParamToSQLCmd(sqlCmd, "@CategoryId", SqlDbType.Int, 0, ParameterDirection.Input, categoryId);

      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_TIMEENTRY_GETUSERREPORTBYCATEGORY);

      List<UserReport> userReport = new List<UserReport>();

      TExecuteReaderCmd<UserReport>(sqlCmd, TGenerateUserReportListFromReader<UserReport>, ref userReport);

      return userReport;
    }

    /***  USER TOTAL DURATION REPORT ***/
    private string SP_TIMEENTRY_GETUSERREPORTBYUSER = "aspnet_starterkits_GetTimeEntryUserReportByUser";

    public override List<UserTotalDurationReport> GetUserReportsByUserName(string userName) {

      SqlCommand sqlCmd = new SqlCommand();

      AddParamToSQLCmd(sqlCmd, "@UserName", SqlDbType.NText, 256, ParameterDirection.Input, userName);

      SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_TIMEENTRY_GETUSERREPORTBYUSER);

      List<UserTotalDurationReport> userReport = new List<UserTotalDurationReport>();

      TExecuteReaderCmd<UserTotalDurationReport>(sqlCmd, TGenerateUserReportListFromReader<UserTotalDurationReport>, ref userReport);
      return userReport;
    }
    private string SP_TIMEENTRY_GETUSERREPORTBYUSERANDDATES = "aspnet_starterkits_GetTimeEntryUserReportByUserAndDates";
    public override List<UserTotalDurationReport> GetUserReportsByUserNameAndDates(string userName,DateTime startDate, DateTime endDate,string ProjectId)
    {

        SqlCommand sqlCmd = new SqlCommand();

        AddParamToSQLCmd(sqlCmd, "@UserName", SqlDbType.NText, 256, ParameterDirection.Input, userName);
        AddParamToSQLCmd(sqlCmd, "@StartingDate", SqlDbType.DateTime, 0, ParameterDirection.Input, startDate);
        AddParamToSQLCmd(sqlCmd, "@EndDate", SqlDbType.DateTime, 0, ParameterDirection.Input, endDate);
        AddParamToSQLCmd(sqlCmd, "@ProjectId", SqlDbType.VarChar, 0, ParameterDirection.Input, ProjectId);
        SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_TIMEENTRY_GETUSERREPORTBYUSERANDDATES);

        List<UserTotalDurationReport> userReport = new List<UserTotalDurationReport>();

        TExecuteReaderCmd<UserTotalDurationReport>(sqlCmd, TGenerateUserReportListFromReader<UserTotalDurationReport>, ref userReport);
        return userReport;
    }

    private string SP_TIMEENTRY_GETUSERREPORTBYUSERANDMONTHANDYEAR = "aspnet_starterkits_GetTimeEntryUserReportByUserAndMonthAndyear";
    public override List<UserTotalDurationReport> GetUserReportsByUserNameAndMonthAndyear(string userName, int Month, int Year, string ProjectId)
    {

        SqlCommand sqlCmd = new SqlCommand();

        AddParamToSQLCmd(sqlCmd, "@UserName", SqlDbType.NText, 256, ParameterDirection.Input, userName);
        AddParamToSQLCmd(sqlCmd, "@Month", SqlDbType.Int, 0, ParameterDirection.Input, Month);
        AddParamToSQLCmd(sqlCmd, "@Year", SqlDbType.Int, 0, ParameterDirection.Input, Year);
        AddParamToSQLCmd(sqlCmd, "@ProjectId", SqlDbType.VarChar, 0, ParameterDirection.Input, ProjectId);
        SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_TIMEENTRY_GETUSERREPORTBYUSERANDMONTHANDYEAR);

        List<UserTotalDurationReport> userReport = new List<UserTotalDurationReport>();

        TExecuteReaderCmd<UserTotalDurationReport>(sqlCmd, TGenerateUserReportListFromReader<UserTotalDurationReport>, ref userReport);
        return userReport;
    }

    private string SP_TIMEENTRY_GETUSERREPORTDATEWISEBYUSERANDDATES = "aspnet_starterkits_GetTimeEntryUserReportDateWiseByUserAndDates";
    public override List<UserTotalDurationReport> GetUserReportsDateWiseByUserNameAndDates(string userName, DateTime startDate, DateTime endDate)
    {

        SqlCommand sqlCmd = new SqlCommand();

        AddParamToSQLCmd(sqlCmd, "@UserName", SqlDbType.NText, 256, ParameterDirection.Input, userName);
        AddParamToSQLCmd(sqlCmd, "@StartingDate", SqlDbType.DateTime, 0, ParameterDirection.Input, startDate);
        AddParamToSQLCmd(sqlCmd, "@EndDate", SqlDbType.DateTime, 0, ParameterDirection.Input, endDate);
        SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_TIMEENTRY_GETUSERREPORTDATEWISEBYUSERANDDATES);

        List<UserTotalDurationReport> userReport = new List<UserTotalDurationReport>();

        TExecuteReaderCmd<UserTotalDurationReport>(sqlCmd, GenerateUserReportListFromReader<UserTotalDurationReport>, ref userReport);
        return userReport;
    }

    private string SP_TIMEENTRY_GETUSERREPORTDATEWISEBYUSERANDMONTHANDYEAR = "aspnet_starterkits_GetTimeEntryUserReportDateWiseByUserAndMonthAndYear";
    public override List<UserTotalDurationReport> GetUserReportsDateWiseByUserNameAndMonthAndYear(string userName, int Month, int year)
    {

        SqlCommand sqlCmd = new SqlCommand();

        AddParamToSQLCmd(sqlCmd, "@UserName", SqlDbType.NText, 256, ParameterDirection.Input, userName);
        AddParamToSQLCmd(sqlCmd, "@Month", SqlDbType.Int, 0, ParameterDirection.Input, Month);
        AddParamToSQLCmd(sqlCmd, "@year", SqlDbType.Int, 0, ParameterDirection.Input, year);
        SetCommandType(sqlCmd, CommandType.StoredProcedure, SP_TIMEENTRY_GETUSERREPORTDATEWISEBYUSERANDMONTHANDYEAR);

        List<UserTotalDurationReport> userReport = new List<UserTotalDurationReport>();

        TExecuteReaderCmd<UserTotalDurationReport>(sqlCmd, GenerateUserReportListFromReader<UserTotalDurationReport>, ref userReport);
        return userReport;
    }


    /*****************************  SQL HELPER METHODS *****************************/
    private void AddParamToSQLCmd(SqlCommand sqlCmd,
                                  string paramId,
                                  SqlDbType sqlType,
                                  int paramSize,
                                  ParameterDirection paramDirection,
                                  object paramvalue) {

      if (sqlCmd == null)
        throw (new ArgumentNullException("sqlCmd"));
      if (paramId == string.Empty)
        throw (new ArgumentOutOfRangeException("paramId"));

      SqlParameter newSqlParam = new SqlParameter();
      newSqlParam.ParameterName = paramId;
      newSqlParam.SqlDbType = sqlType;
      newSqlParam.Direction = paramDirection;

      if (paramSize > 0)
        newSqlParam.Size = paramSize;

      if (paramvalue != null)
        newSqlParam.Value = paramvalue;

      sqlCmd.Parameters.Add(newSqlParam);
    }

    private void ExecuteScalarCmd(SqlCommand sqlCmd)
    {
        if (ConnectionString == string.Empty)
            throw (new ArgumentOutOfRangeException("ConnectionString"));

        if (sqlCmd == null)
            throw (new ArgumentNullException("sqlCmd"));
        try
        {
            using (SqlConnection cn = new SqlConnection(this.ConnectionString))
            {
                sqlCmd.Connection = cn;
                cn.Open();
                sqlCmd.ExecuteScalar();
            }
        }
        catch(Exception ex)
        {
            throw ex;
        }
        
       
    }
    
    private void SetCommandType(SqlCommand sqlCmd, CommandType cmdType, string cmdText) {
      sqlCmd.CommandType = cmdType;
      sqlCmd.CommandText = cmdText;
    }

    private void TExecuteReaderCmd<T>(SqlCommand sqlCmd, TGenerateListFromReader<T> gcfr, ref List<T> List) {
        try
        {
       
              if (ConnectionString == string.Empty)
                throw (new ArgumentOutOfRangeException("ConnectionString"));

              if (sqlCmd == null)
                throw (new ArgumentNullException("sqlCmd"));

              using (SqlConnection cn = new SqlConnection(this.ConnectionString)) {
                sqlCmd.Connection = cn;

                cn.Open();

                gcfr(sqlCmd.ExecuteReader(), ref List);
           }
        }
        catch (Exception ex)
        {

        }
      
    }

    private void ExecuteReaderCmd<T>(SqlCommand sqlCmd, TGenerateListFromReader<T> gcfr, ref List<T> List)
    {
        try
        {

            if (ConnectionString == string.Empty)
                throw (new ArgumentOutOfRangeException("ConnectionString"));

            if (sqlCmd == null)
                throw (new ArgumentNullException("sqlCmd"));

            using (SqlConnection cn = new SqlConnection(this.ConnectionString))
            {
                sqlCmd.Connection = cn;

                cn.Open();

                gcfr(sqlCmd.ExecuteReader(), ref List);
            }
        }
        catch (Exception ex)
        {

        }

    }

    /*****************************  GENARATE List HELPER METHODS  *****************************/

    private void TGenerateProjectListFromReader<T>(SqlDataReader returnData, ref List<Project> prjList) {
        //if (returnData.Read().ToString() == "True")
        //{
            while (returnData.Read())
            {
                decimal actualDuration = 0;
                if (returnData["ProjectActualDuration"] != DBNull.Value)
                    actualDuration = Convert.ToDecimal(returnData["ProjectActualDuration"]);

                Project project = new Project(actualDuration, (string)returnData["ProjectCreatorDisplayName"], (DateTime)returnData["ProjectCompletionDate"], (DateTime)returnData["ProjectCreationDate"], (string)returnData["ProjectDescription"],
                                  (Decimal)returnData["DevelopmentHours"], (Decimal)returnData["TestingHours"], (Decimal)returnData["DesginingHours"], (Decimal)returnData["BAHours"], (Decimal)returnData["ProjectManagementHours"], (Decimal)returnData["othersHours"], (Decimal)returnData["ProjectEstimateDuration"], (int)returnData["ProjectId"], (string)returnData["ProjectManagerDisplayName"], (string)returnData["ProjectName"], (bool)returnData["IsCompleted"], (string)returnData["ClientName"]);
                prjList.Add(project);
            }
        //}
        //else
        //{
        //    Project project = new Project("Select", 0);
        //    prjList.Add(project);
        //}
    }

    private void GenerateProjectListFromReader<T>(SqlDataReader returnData, ref List<Project> prjList)
    {
        while (returnData.Read())
        {
            decimal actualDuration = 0;
            if (returnData["ProjectActualDuration"] != DBNull.Value)
                actualDuration = Convert.ToDecimal(returnData["ProjectActualDuration"]);

            Project project = new Project(actualDuration, (DateTime)returnData["ProjectCompletionDate"],
                                     (Decimal)returnData["ProjectEstimateDuration"], (int)returnData["ProjectId"], (string)returnData["ProjectName"]);
            prjList.Add(project);
        }
    }

    private void TGenerateCategoryListFromReader<T>(SqlDataReader returnData, ref List<Category> categoryList) {
      while (returnData.Read()) {
        decimal actualDuration = 0;
          Category category = new Category((int)returnData["CategoryId"],(string)returnData["Category"]);
          categoryList.Add(category);
      }
    }

    private void TGenerateTimeEntryListFromReader<T>(SqlDataReader returnData, ref List<TimeEntry> timeEntryList) {
        TimeEntry.totalhours = 0;
      while (returnData.Read()) {
          
          TimeEntry timeEntry = new TimeEntry((string)returnData["TimeEntryCreatorDisplayName"], (int)returnData["ProjectId"], (int)returnData["CategoryId"], (DateTime)returnData["TimeEntryCreated"], (string)returnData["TimeEntryDescription"],
                                        (Decimal)returnData["TimeEntryDuration"], (int)returnData["TimeEntryId"], (DateTime)returnData["TimeEntryDate"], (string)returnData["TimeEntryUserName"], (string)returnData["ProjectName"]);
        timeEntryList.Add(timeEntry);
      }
    }

    private void TGenerateUsertListFromReader<T>(SqlDataReader returnData, ref List<string> userList) {
      while (returnData.Read()) {
        string userName = (string)returnData["UserName"];
        userList.Add(userName);
      }
    }
    private void TGenerateUsertListFromReaderForMembers<T>(SqlDataReader returnData, ref List<string> userList)
    {
        if (returnData.HasRows.ToString() == "True")
        {
            while (returnData.Read())
            {
                string userName = (string)returnData["UserName"];
                userList.Add(userName);
            }
        }
        else
        {
            userList.Add("Select");
        }
    }

    private void TGenerateUserReportListFromReader<T>(SqlDataReader returnData, ref List<UserReport> userReportList) {
      while (returnData.Read()) {
          UserReport userReport = new UserReport((decimal)returnData["duration"], (string)returnData["UserName"], (string)returnData["Category"]);
        userReportList.Add(userReport);
      }
    }

    private void TGenerateUserReportListFromReader<T>(SqlDataReader returnData, ref List<UserTotalDurationReport> userReportList) {
      while (returnData.Read()) {
        decimal totalDuration = 0;
        if (returnData["TotalDuration"] != DBNull.Value)
        totalDuration = (decimal)returnData["TotalDuration"];
        UserTotalDurationReport userReport = new UserTotalDurationReport(totalDuration, (string)returnData["UserName"]);
        userReportList.Add(userReport);
      }
    }

    private void GenerateUserReportListFromReader<T>(SqlDataReader returnData, ref List<UserTotalDurationReport> userReportList)
    {
        while (returnData.Read())
        {
            decimal totalDuration = 0;
            if (returnData["TotalDuration"] != DBNull.Value)
                totalDuration = (decimal)returnData["TotalDuration"];
            UserTotalDurationReport userReport = new UserTotalDurationReport(totalDuration, (DateTime)returnData["TimeEntryDate"]);
            userReportList.Add(userReport);
        }
    }


  

  }
}
