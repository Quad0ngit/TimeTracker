using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using ASPNET.StarterKit.BusinessLogicLayer;
using System.Collections.Generic;
using System.Data.SqlClient;

/// <summary>
/// Summary description for CustomDAO
/// </summary>
public class CustomDAO
{
    string connectionString = ConfigurationManager.ConnectionStrings["aspnet_staterKits_TimeTracker"].ConnectionString;
	public CustomDAO()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public List<Project> FindProjectDetails()
    {
        DataSet objDataSet= new DataSet();
        List<Project> objlstProject = new List<Project>();
        SqlConnection myConnection = new SqlConnection(connectionString);
        SqlCommand cmd = new SqlCommand("aspnet_starterkits_GetAllProjects", myConnection);
        cmd.CommandType = CommandType.StoredProcedure;
        myConnection.Open();
        //SqlParameter custId = cmd.Parameters.AddWithValue("@CustomerId", 10);
        SqlDataAdapter objDataAdapter = new SqlDataAdapter(cmd);
        objDataAdapter.Fill(objDataSet);
        DataRow objDataRow;
        if (objDataSet.Tables[0].Rows.Count>0)
        {
            for (int iterator = 0; iterator < objDataSet.Tables[0].Rows.Count; iterator++)
            {
                objDataRow = objDataSet.Tables[0].Rows[iterator];
                Project newProject = new Project(Convert.ToString(objDataRow["ProjectName"]), Convert.ToInt32(objDataRow["ProjectId"]), Convert.ToString(objDataRow["ClientName"]));
                objlstProject.Add(newProject);
            }
        }
        myConnection.Close();      
        return objlstProject;
    }



    public List<Project> FindProjectDetailsByUserDetails(string UserName)
    {

        DataSet objDataSet = new DataSet();
        List<Project> objlstProject = new List<Project>();
        SqlConnection myConnection = new SqlConnection(connectionString);
        SqlCommand cmd = new SqlCommand("aspnet_starterkits_FindProjectDetailsByUserDetails", myConnection);
        cmd.CommandType = CommandType.StoredProcedure;
        myConnection.Open();
        SqlParameter SqlParamUserName = new SqlParameter("@UserName", UserName);
        SqlParamUserName.Direction = ParameterDirection.Input;
        cmd.Parameters.Add(SqlParamUserName);
        SqlDataAdapter objDataAdapter = new SqlDataAdapter(cmd);
        objDataAdapter.Fill(objDataSet);
        DataRow objDataRow;
        if (objDataSet.Tables[0].Rows.Count > 0)
        {
            for (int iterator = 0; iterator < objDataSet.Tables[0].Rows.Count; iterator++)
            {
                objDataRow = objDataSet.Tables[0].Rows[iterator];
                Project newProject = new Project(Convert.ToString(objDataRow["ProjectName"]), Convert.ToInt32(objDataRow["ProjectId"]), Convert.ToString(objDataRow["ClientName"]));
                objlstProject.Add(newProject);
            }
        }
        myConnection.Close();
        return objlstProject;
    }

    public List<Project> FindProjectDetailsByCategoryDetails(string CategoryID)
    {
        DataSet objDataSet = new DataSet();
        List<Project> objlstProject = new List<Project>();
        SqlConnection myConnection = new SqlConnection(connectionString);
        SqlCommand cmd = new SqlCommand("aspnet_starterkits_FindProjectDetailsByCategoryDetails", myConnection);
        cmd.CommandType = CommandType.StoredProcedure;
        myConnection.Open();
        SqlParameter SqlParamUserName = new SqlParameter("@CategoryID", Convert.ToInt32(CategoryID));
        SqlParamUserName.Direction = ParameterDirection.Input;
        cmd.Parameters.Add(SqlParamUserName);
        SqlDataAdapter objDataAdapter = new SqlDataAdapter(cmd);
        objDataAdapter.Fill(objDataSet);
        DataRow objDataRow;
        if (objDataSet.Tables[0].Rows.Count > 0)
        {
            for (int iterator = 0; iterator < objDataSet.Tables[0].Rows.Count; iterator++)
            {
                objDataRow = objDataSet.Tables[0].Rows[iterator];
                Project newProject = new Project(Convert.ToString(objDataRow["ProjectName"]), Convert.ToInt32(objDataRow["ProjectId"]), Convert.ToString(objDataRow["ClientName"]));
                objlstProject.Add(newProject);
            }
        }
        myConnection.Close();
        return objlstProject;
    }

    public string FindRoleDetailsBYUserId(string UserID)
    {
        DataSet objDataSet = new DataSet();
        string RoleName = "";
        SqlConnection myConnection = new SqlConnection(connectionString);
        SqlCommand cmd = new SqlCommand("Proc_FindRoleDetailsBYUserId", myConnection);
        cmd.CommandType = CommandType.StoredProcedure;
        myConnection.Open();
        SqlParameter SqlParamUserName = new SqlParameter("@UserID", Convert.ToString(UserID));
        SqlParamUserName.Direction = ParameterDirection.Input;
        cmd.Parameters.Add(SqlParamUserName);
        SqlDataAdapter objDataAdapter = new SqlDataAdapter(cmd);
        objDataAdapter.Fill(objDataSet);
        DataRow objDataRow;
        if (objDataSet.Tables[0].Rows.Count > 0)
        {
            for (int iterator = 0; iterator < objDataSet.Tables[0].Rows.Count; iterator++)
            {
                objDataRow = objDataSet.Tables[0].Rows[iterator];
                RoleName = Convert.ToString(objDataRow["RoleName"]);
            }
        }
        myConnection.Close();
        return RoleName;
    }

    public List<Project> FindProjectDocsDetailsByProjectId(int PrjId)
    {
        DataSet objDataSet = new DataSet();
        List<Project> lstPrjDocsDetails = new List<Project>();
        SqlConnection myConnection = new SqlConnection(connectionString);
        SqlCommand cmd = new SqlCommand("Proc_FindProjectDocsDetailsByProjectId", myConnection);
        cmd.CommandType = CommandType.StoredProcedure;
        myConnection.Open();
        SqlParameter SqlParamUserName = new SqlParameter("@ProjectId", Convert.ToString(PrjId));
        SqlParamUserName.Direction = ParameterDirection.Input;
        cmd.Parameters.Add(SqlParamUserName);
        SqlDataAdapter objDataAdapter = new SqlDataAdapter(cmd);
        objDataAdapter.Fill(objDataSet);
        DataRow objDataRow;
        if (objDataSet.Tables[0].Rows.Count > 0)
        {
            for (int iterator = 0; iterator < objDataSet.Tables[0].Rows.Count; iterator++)
            {
                objDataRow = objDataSet.Tables[0].Rows[iterator];
                Project objProject = new Project(Convert.ToInt32(objDataRow["AutoId"]), Convert.ToInt32(objDataRow["ProjectId"]), Convert.ToString(objDataRow["ProjectName"]), Convert.ToDateTime(objDataRow["CreatedOn"]), Convert.ToString(objDataRow["CreatedBY"]), Convert.ToString(objDataRow["DocumentName"]), Convert.ToString(objDataRow["DocumentEncrypetedName"]));
                lstPrjDocsDetails.Add(objProject);
            }
        }
        myConnection.Close();
        return lstPrjDocsDetails;
    }

    public void saveProjectDocumentsByProjectId(Project objProject)
    {
        try
        {
            DataSet objDataSet = new DataSet();
            SqlConnection myConnection = new SqlConnection(connectionString);
            SqlCommand cmd = new SqlCommand("Proc_saveProjectDocumentsByProjectId", myConnection);
            cmd.CommandType = CommandType.StoredProcedure;
            myConnection.Open();

            SqlParameter SqlParamProjectId = new SqlParameter("@ProjectId", Convert.ToString(objProject.ProjectId));
            SqlParamProjectId.Direction = ParameterDirection.Input;
            cmd.Parameters.Add(SqlParamProjectId);

            //SqlParameter SqlParamCreatedOn = new SqlParameter("@CreatedOn", Convert.ToDateTime(objProject.DateCreated));
            //SqlParamCreatedOn.Direction = ParameterDirection.Input;
            //cmd.Parameters.Add(SqlParamCreatedOn);

            SqlParameter SqlParamCreatedUser = new SqlParameter("@CreatedUser", Convert.ToString(objProject.CreatedUser));
            SqlParamCreatedUser.Direction = ParameterDirection.Input;
            cmd.Parameters.Add(SqlParamCreatedUser);

            SqlParameter SqlParamPrjDocName = new SqlParameter("@PrjDocName", Convert.ToString(objProject.PrjDocName));
            SqlParamPrjDocName.Direction = ParameterDirection.Input;
            cmd.Parameters.Add(SqlParamPrjDocName);

            SqlParameter SqlParamPrjEncDocName = new SqlParameter("@PrjEncDocName", Convert.ToString(objProject.PrjEncDocName));
            SqlParamPrjEncDocName.Direction = ParameterDirection.Input;
            cmd.Parameters.Add(SqlParamPrjEncDocName);

            cmd.ExecuteScalar();  
            myConnection.Close();

        }
        catch (Exception)
        {
        }
    }

    public void DeleteProjectDocsDetailsByAutoId(int AutoId)
    {
        DataSet objDataSet = new DataSet();
        SqlConnection myConnection = new SqlConnection(connectionString);
        SqlCommand cmd = new SqlCommand("Proc_DeleteProjectDocsDetailsByAutoId", myConnection);
        cmd.CommandType = CommandType.StoredProcedure;
        myConnection.Open();

        SqlParameter SqlParamProjectId = new SqlParameter("@AutoId", AutoId);
        SqlParamProjectId.Direction = ParameterDirection.Input;
        cmd.Parameters.Add(SqlParamProjectId);

        cmd.ExecuteScalar();
        myConnection.Close();
    }

    public List<Project> FindClientDeatils()
    {
        DataSet objDataSet = new DataSet();
        List<Project> objlstProject = new List<Project>();
        SqlConnection myConnection = new SqlConnection(connectionString);
        SqlCommand cmd = new SqlCommand("aspnet_starterkits_FindClientDeatils", myConnection);
        cmd.CommandType = CommandType.StoredProcedure;
        myConnection.Open();
        //SqlParameter custId = cmd.Parameters.AddWithValue("@CustomerId", 10);
        SqlDataAdapter objDataAdapter = new SqlDataAdapter(cmd);
        objDataAdapter.Fill(objDataSet);
        DataRow objDataRow;
        if (objDataSet.Tables[0].Rows.Count > 0)
        {
            for (int iterator = 0; iterator < objDataSet.Tables[0].Rows.Count; iterator++)
            {
                objDataRow = objDataSet.Tables[0].Rows[iterator];
                Project newProject = new Project(Convert.ToString(objDataRow["ClientName"]), Convert.ToInt32(objDataRow["AutoId"]), Convert.ToString(objDataRow["Address"]), Convert.ToString(objDataRow["ContactNumber"]));
                objlstProject.Add(newProject);
            }
        }
        myConnection.Close();
        return objlstProject;
    }

    public List<Project> GetClientReportByIdAndMonthAndYear(int projectId, int Month, int Year)
    {
        DataSet objDataSet = new DataSet();
        List<Project> objlstProject = new List<Project>();
        if (projectId <= 0)
            throw (new ArgumentOutOfRangeException("projectId"));
        
        SqlConnection myConnection = new SqlConnection(connectionString);
        SqlCommand sqlCmd = new SqlCommand("aspnet_starterkits_GetClientReportByIdAndMonthAndYear", myConnection);
        sqlCmd.CommandType = CommandType.StoredProcedure;
        myConnection.Open();

        SqlParameter SqlParamProjectId = new SqlParameter("@ProjectId", projectId);
        SqlParamProjectId.Direction = ParameterDirection.Input;
        sqlCmd.Parameters.Add(SqlParamProjectId);

        SqlParameter SqlParamMonth = new SqlParameter("@Month", Month);
        SqlParamProjectId.Direction = ParameterDirection.Input;
        sqlCmd.Parameters.Add(SqlParamMonth);

        SqlParameter SqlParamYear = new SqlParameter("@Year", Year);
        SqlParamProjectId.Direction = ParameterDirection.Input;
        sqlCmd.Parameters.Add(SqlParamYear);

        SqlDataAdapter objDataAdapter = new SqlDataAdapter(sqlCmd);
        objDataAdapter.Fill(objDataSet);
        DataRow objDataRow;
        if (objDataSet.Tables[0].Rows.Count > 0)
        {
            for (int iterator = 0; iterator < objDataSet.Tables[0].Rows.Count; iterator++)
            {
                objDataRow = objDataSet.Tables[0].Rows[iterator];
                Project newProject = new Project(Convert.ToDecimal(objDataRow["ProjectActualDuration"]), (DateTime)objDataRow["ProjectCompletionDate"],
                                     (Decimal)objDataRow["ProjectEstimateDuration"], (int)objDataRow["ProjectId"], (string)objDataRow["ProjectName"]);
                objlstProject.Add(newProject);            }
        }
        myConnection.Close();
        return objlstProject;
     
    }

    public List<UserReport> GetClientWiseUserReportsByProjectIdAndMonthAndYear(int projectId, Int32 Month, Int32 Year)
    {
        DataSet objDataSet = new DataSet();
        List<UserReport> objlstUserReport = new List<UserReport>();
        if (projectId <= 0)
            throw (new ArgumentOutOfRangeException("projectId"));

        SqlConnection myConnection = new SqlConnection(connectionString);
        SqlCommand sqlCmd = new SqlCommand("aspnet_starterkits_GetClientWiseUserReportsByProjectIdAndMonthAndYear", myConnection);
        sqlCmd.CommandType = CommandType.StoredProcedure;
        myConnection.Open();

        SqlParameter SqlParamProjectId = new SqlParameter("@ProjectId", projectId);
        SqlParamProjectId.Direction = ParameterDirection.Input;
        sqlCmd.Parameters.Add(SqlParamProjectId);

        SqlParameter SqlParamMonth = new SqlParameter("@Month", Month);
        SqlParamProjectId.Direction = ParameterDirection.Input;
        sqlCmd.Parameters.Add(SqlParamMonth);

        SqlParameter SqlParamYear = new SqlParameter("@Year", Year);
        SqlParamProjectId.Direction = ParameterDirection.Input;
        sqlCmd.Parameters.Add(SqlParamYear);

        SqlDataAdapter objDataAdapter = new SqlDataAdapter(sqlCmd);
        objDataAdapter.Fill(objDataSet);
        DataRow objDataRow;
        if (objDataSet.Tables[0].Rows.Count > 0)
        {
            for (int iterator = 0; iterator < objDataSet.Tables[0].Rows.Count; iterator++)
            {
                objDataRow = objDataSet.Tables[0].Rows[iterator];
                UserReport newUserReport = new UserReport((decimal)objDataRow["duration"], (string)objDataRow["UserName"], (string)objDataRow["Category"]);
                objlstUserReport.Add(newUserReport);
            }
        }
        myConnection.Close();
        return objlstUserReport;
    }

    public List<Project> GetProjectReportByIdAndDates(int projectId, DateTime StartDate, DateTime EndDate)
    {
        DataSet objDataSet = new DataSet();
        List<Project> objlstProject = new List<Project>();
            if (projectId <= 0)
            throw (new ArgumentOutOfRangeException("projectId"));

        SqlConnection myConnection = new SqlConnection(connectionString);
        SqlCommand sqlCmd = new SqlCommand("aspnet_starterkits_GetClientWiseProjectReportByIdAndDates", myConnection);
        sqlCmd.CommandType = CommandType.StoredProcedure;
        myConnection.Open();

        SqlParameter SqlParamProjectId = new SqlParameter("@ProjectId", projectId);
        SqlParamProjectId.Direction = ParameterDirection.Input;
        sqlCmd.Parameters.Add(SqlParamProjectId);

        SqlParameter SqlParamMonth = new SqlParameter("@StartDate", StartDate);
        SqlParamProjectId.Direction = ParameterDirection.Input;
        sqlCmd.Parameters.Add(SqlParamMonth);

        SqlParameter SqlParamYear = new SqlParameter("@EndDate", EndDate);
        SqlParamProjectId.Direction = ParameterDirection.Input;
        sqlCmd.Parameters.Add(SqlParamYear);

        SqlDataAdapter objDataAdapter = new SqlDataAdapter(sqlCmd);
        objDataAdapter.Fill(objDataSet);
        DataRow objDataRow;
        if (objDataSet.Tables[0].Rows.Count > 0)
        {
            for (int iterator = 0; iterator < objDataSet.Tables[0].Rows.Count; iterator++)
            {
                objDataRow = objDataSet.Tables[0].Rows[iterator];
                Project newProject = new Project(Convert.ToDecimal(objDataRow["ProjectActualDuration"]), (DateTime)objDataRow["ProjectCompletionDate"],
                                     (Decimal)objDataRow["ProjectEstimateDuration"], (int)objDataRow["ProjectId"], (string)objDataRow["ProjectName"]);
                objlstProject.Add(newProject);
            }
        }
        myConnection.Close();
        return objlstProject;
    }

    public List<Project> FindProjectLeaderDetails()
    {
        DataSet objDataSet = new DataSet();
        List<Project> objlstProject = new List<Project>();
        SqlConnection myConnection = new SqlConnection(connectionString);
        SqlCommand cmd = new SqlCommand("aspnet_starterkits_FindProjectLeaderDetails", myConnection);
        cmd.CommandType = CommandType.StoredProcedure;
        myConnection.Open();
        //SqlParameter custId = cmd.Parameters.AddWithValue("@CustomerId", 10);
        SqlDataAdapter objDataAdapter = new SqlDataAdapter(cmd);
        objDataAdapter.Fill(objDataSet);
        DataRow objDataRow;
        if (objDataSet.Tables[0].Rows.Count > 0)
        {
            for (int iterator = 0; iterator < objDataSet.Tables[0].Rows.Count; iterator++)
            {
                objDataRow = objDataSet.Tables[0].Rows[iterator];
                Project newProject = new Project(Convert.ToString(objDataRow["UserName"]), Convert.ToString(objDataRow["UserId"]));
                objlstProject.Add(newProject);
            }
        }
        myConnection.Close();
        return objlstProject;
    }



    public void SaveUserToTeamLead(string genUserId, string TMLeaderUserId)
    {
        DataSet objDataSet = new DataSet();
        SqlConnection myConnection = new SqlConnection(connectionString);
        SqlCommand cmd = new SqlCommand("Proc_SaveUserToTeamLead", myConnection);
        cmd.CommandType = CommandType.StoredProcedure;
        myConnection.Open();

        SqlParameter SqlParamProjectId = new SqlParameter("@genUserId", Convert.ToString(genUserId));
        SqlParamProjectId.Direction = ParameterDirection.Input;
        cmd.Parameters.Add(SqlParamProjectId);

        SqlParameter SqlParamPrjEncDocName = new SqlParameter("@TMLeaderUserId", Convert.ToString(TMLeaderUserId));
        SqlParamPrjEncDocName.Direction = ParameterDirection.Input;
        cmd.Parameters.Add(SqlParamPrjEncDocName);

        cmd.ExecuteScalar();
        myConnection.Close();
    }

    public List<Project> GetProjectsByUserName(string userName)
    {
        if (userName == null || userName.Length == 0)
            throw (new ArgumentOutOfRangeException("userName"));

        DataSet objDataSet = new DataSet();
        List<Project> objlstProject = new List<Project>();
       
        SqlConnection myConnection = new SqlConnection(connectionString);
        SqlCommand sqlCmd = new SqlCommand("aspnet_starterkits_GetProjectByUserName", myConnection);
        sqlCmd.CommandType = CommandType.StoredProcedure;
        myConnection.Open();

        SqlParameter SqlParamProjectId = new SqlParameter("@UserName", userName);
        SqlParamProjectId.Direction = ParameterDirection.Input;
        sqlCmd.Parameters.Add(SqlParamProjectId);

        SqlDataAdapter objDataAdapter = new SqlDataAdapter(sqlCmd);
        objDataAdapter.Fill(objDataSet);
        DataRow objDataRow;
        if (objDataSet.Tables[0].Rows.Count > 0)
        {
            for (int iterator = 0; iterator < objDataSet.Tables[0].Rows.Count; iterator++)
            {
                objDataRow = objDataSet.Tables[0].Rows[iterator];
                Project newProject = new Project(Convert.ToDecimal(objDataRow["ProjectActualDuration"]), (DateTime)objDataRow["ProjectCompletionDate"],
                                     (Decimal)objDataRow["ProjectEstimateDuration"], (int)objDataRow["ProjectId"], (string)objDataRow["ProjectName"]);
                objlstProject.Add(newProject);
            }
        }
        myConnection.Close();
        return objlstProject;
    }


    public List<Project> FindTeamUserByTeamleader(string TeamLeaderUserName)
    {
        SqlConnection myConnection = new SqlConnection(connectionString);
        List<Project> objlstProject = new List<Project>();

        try
        {
            if (TeamLeaderUserName == null || TeamLeaderUserName.Length == 0)
                throw (new ArgumentOutOfRangeException("TeamLeaderUserName"));

            DataSet objDataSet = new DataSet();
            SqlCommand sqlCmd = new SqlCommand("aspnet_starterkits_FindTeamUserByTeamleader", myConnection);
            sqlCmd.CommandType = CommandType.StoredProcedure;
            myConnection.Open();

            SqlParameter SqlParamProjectId = new SqlParameter("@TeamLeaderUserName", TeamLeaderUserName);
            SqlParamProjectId.Direction = ParameterDirection.Input;
            sqlCmd.Parameters.Add(SqlParamProjectId);

            SqlDataAdapter objDataAdapter = new SqlDataAdapter(sqlCmd);
            objDataAdapter.Fill(objDataSet);
            DataRow objDataRow;
            if (objDataSet.Tables[0].Rows.Count > 0)
            {
                for (int iterator = 0; iterator < objDataSet.Tables[0].Rows.Count; iterator++)
                {
                    objDataRow = objDataSet.Tables[0].Rows[iterator];
                    Project newProject = new Project(Convert.ToString(objDataRow["UserName"]), Convert.ToString(objDataRow["UserId"]));
                    objlstProject.Add(newProject);
                }
            }
        }
        catch (Exception)
        {
        }
        myConnection.Close();
        return objlstProject;
    }


    public List<TimeEntry> GetTimeEntriesByUserNameProjectIdAndDates(string userName, string ProjectId,DateTime startingDate, DateTime endDate)
    {
        SqlConnection myConnection = new SqlConnection(connectionString);
        List<TimeEntry> timeEntryList = new List<TimeEntry>();
        try
        {

            TimeEntry.totalhours = 0;
            DataSet objDataSet = new DataSet();
            SqlCommand sqlCmd = new SqlCommand("aspnet_starterkits_GetAllTimeEntriesByProjectIdandUserAndDate", myConnection);
            sqlCmd.CommandType = CommandType.StoredProcedure;
            myConnection.Open();

            SqlParameter SqlParamReturnValue = new SqlParameter("@ReturnValue", null);
            SqlParamReturnValue.Direction = ParameterDirection.ReturnValue;
            sqlCmd.Parameters.Add(SqlParamReturnValue);

            SqlParameter SqlParamProjectId = new SqlParameter("@ProjectId", ProjectId);
            SqlParamProjectId.Direction = ParameterDirection.Input;
            sqlCmd.Parameters.Add(SqlParamProjectId);

            SqlParameter SqlParamStartingDate = new SqlParameter("@StartingDate", startingDate);
            SqlParamStartingDate.Direction = ParameterDirection.Input;
            sqlCmd.Parameters.Add(SqlParamStartingDate);
            
            SqlParameter SqlParamEndDate = new SqlParameter("@EndDate", endDate);
            SqlParamEndDate.Direction = ParameterDirection.Input;
            sqlCmd.Parameters.Add(SqlParamEndDate);

            SqlParameter SqlParamTimeEntryUserName = new SqlParameter("@TimeEntryUserName", userName);
            SqlParamTimeEntryUserName.Direction = ParameterDirection.Input;
            sqlCmd.Parameters.Add(SqlParamTimeEntryUserName);
                 
            SqlDataAdapter objDataAdapter = new SqlDataAdapter(sqlCmd);
            objDataAdapter.Fill(objDataSet);
            DataRow objDataRow;

            if (objDataSet.Tables[0].Rows.Count > 0)
            {
                for (int iterator = 0; iterator < objDataSet.Tables[0].Rows.Count; iterator++)
                {
                    objDataRow = objDataSet.Tables[0].Rows[iterator];
                    TimeEntry timeEntry = new TimeEntry((string)objDataRow["TimeEntryCreatorDisplayName"], (int)objDataRow["ProjectId"], (int)objDataRow["CategoryId"], (DateTime)objDataRow["TimeEntryCreated"], (string)objDataRow["TimeEntryDescription"],
                                                            (Decimal)objDataRow["TimeEntryDuration"], (int)objDataRow["TimeEntryId"], (DateTime)objDataRow["TimeEntryDate"], (string)objDataRow["TimeEntryUserName"], (string)objDataRow["ProjectName"]);
                    timeEntryList.Add(timeEntry);
                }
            }
        }
        catch (Exception)
        {
        }
        return timeEntryList;

    }

    public string FindUserIdByUserName(string UserName)
    {
        SqlConnection myConnection = new SqlConnection(connectionString);
        string UserId = "";
        try
        {
            if (UserName == null || UserName.Length == 0)
                throw (new ArgumentOutOfRangeException("UserName"));

            DataSet objDataSet = new DataSet();
            SqlCommand sqlCmd = new SqlCommand("aspnet_starterkits_FindUserIdByUserName", myConnection);
            sqlCmd.CommandType = CommandType.StoredProcedure;
            myConnection.Open();

            SqlParameter SqlParamProjectId = new SqlParameter("@UserName", UserName);
            SqlParamProjectId.Direction = ParameterDirection.Input;
            sqlCmd.Parameters.Add(SqlParamProjectId);

            SqlDataAdapter objDataAdapter = new SqlDataAdapter(sqlCmd);
            objDataAdapter.Fill(objDataSet);
            DataRow objDataRow;
            if (objDataSet.Tables[0].Rows.Count > 0)
            {
                for (int iterator = 0; iterator < objDataSet.Tables[0].Rows.Count; iterator++)
                {
                    objDataRow = objDataSet.Tables[0].Rows[iterator];
                    UserId = Convert.ToString(objDataRow["UserId"]);
                }
            }
            myConnection.Close();            
        }
        catch (Exception)
        {
        }
        return UserId;
    }

    public string FindTeamLeadUserIdByUserId(string UserId)
    {
        SqlConnection myConnection = new SqlConnection(connectionString);
        string TeamLeadUserId = "";
        try
        {
            if (UserId == null || UserId.Length == 0)
                throw (new ArgumentOutOfRangeException("UserId"));

            DataSet objDataSet = new DataSet();
            SqlCommand sqlCmd = new SqlCommand("aspnet_starterkits_FindTeamLeadUserIdByUserId", myConnection);
            sqlCmd.CommandType = CommandType.StoredProcedure;
            myConnection.Open();

            SqlParameter SqlParamProjectId = new SqlParameter("@UserId", UserId);
            SqlParamProjectId.Direction = ParameterDirection.Input;
            sqlCmd.Parameters.Add(SqlParamProjectId);

            SqlDataAdapter objDataAdapter = new SqlDataAdapter(sqlCmd);
            objDataAdapter.Fill(objDataSet);
            DataRow objDataRow;
            if (objDataSet.Tables[0].Rows.Count > 0)
            {
                for (int iterator = 0; iterator < objDataSet.Tables[0].Rows.Count; iterator++)
                {
                    objDataRow = objDataSet.Tables[0].Rows[iterator];
                    TeamLeadUserId = Convert.ToString(objDataRow["TeamLeadId"]);
                }
            }
            myConnection.Close();
        }
        catch (Exception)
        {
        }
        return TeamLeadUserId;
    }

    public void saveClientDeatils(int ClientId, string ClientName, string ContactNo, string Address)
    {
        DataSet objDataSet = new DataSet();
        SqlConnection myConnection = new SqlConnection(connectionString);
        SqlCommand cmd = new SqlCommand("Proc_saveClientDeatils", myConnection);
        cmd.CommandType = CommandType.StoredProcedure;
        myConnection.Open();

        SqlParameter SqlParamClientId = new SqlParameter("@ClientId", ClientId);
        SqlParamClientId.Direction = ParameterDirection.Input;
        cmd.Parameters.Add(SqlParamClientId);

        SqlParameter SqlParamClientName = new SqlParameter("@ClientName", ClientName);
        SqlParamClientName.Direction = ParameterDirection.Input;
        cmd.Parameters.Add(SqlParamClientName);

        SqlParameter SqlParamContactNo = new SqlParameter("@ContactNo", ContactNo);
        SqlParamContactNo.Direction = ParameterDirection.Input;
        cmd.Parameters.Add(SqlParamContactNo);

        SqlParameter SqlParamAddress = new SqlParameter("@Address", Address);
        SqlParamAddress.Direction = ParameterDirection.Input;
        cmd.Parameters.Add(SqlParamAddress);

        cmd.ExecuteScalar();
        myConnection.Close();
    }

    public bool FindIsProjectDocumentExists(string fileName, int ProjectId)
    {

        SqlConnection myConnection = new SqlConnection(connectionString);
        bool IsRecordExists = false;
        try
        {
            if (fileName == null || fileName.Length == 0)
                throw (new ArgumentOutOfRangeException("fileName"));

            DataSet objDataSet = new DataSet();
            SqlCommand sqlCmd = new SqlCommand("aspnet_starterkits_FindIsProjectDocumentExists", myConnection);
            sqlCmd.CommandType = CommandType.StoredProcedure;
            myConnection.Open();

            SqlParameter SqlParamFileName = new SqlParameter("@fileName", fileName);
            SqlParamFileName.Direction = ParameterDirection.Input;
            sqlCmd.Parameters.Add(SqlParamFileName);

            SqlParameter SqlParamProjectId = new SqlParameter("@ProjectId", ProjectId);
            SqlParamProjectId.Direction = ParameterDirection.Input;
            sqlCmd.Parameters.Add(SqlParamProjectId);

            SqlDataAdapter objDataAdapter = new SqlDataAdapter(sqlCmd);
            objDataAdapter.Fill(objDataSet);
            if (objDataSet.Tables[0].Rows.Count > 0)
            {
                IsRecordExists = true;
            }
            myConnection.Close();
        }
        catch (Exception)
        {
        }
        return IsRecordExists;
    }

    public bool FindIsProjectExists(string ProjectName,int ProjectID)
    {
        SqlConnection myConnection = new SqlConnection(connectionString);       
        bool IsRecordExists = false;
        try
        {
            if (ProjectName == null || ProjectName.Length == 0)
                throw (new ArgumentOutOfRangeException("ProjectName"));

            DataSet objDataSet = new DataSet();
            SqlCommand sqlCmd = new SqlCommand("aspnet_starterkits_FindIsProjectExists", myConnection);
            sqlCmd.CommandType = CommandType.StoredProcedure;
            myConnection.Open();

            SqlParameter SqlParamFileName = new SqlParameter("@ProjectName", ProjectName);
            SqlParamFileName.Direction = ParameterDirection.Input;
            sqlCmd.Parameters.Add(SqlParamFileName);

            SqlParameter SqlParamProjectID = new SqlParameter("@ProjectID", ProjectID);
            SqlParamFileName.Direction = ParameterDirection.Input;
            sqlCmd.Parameters.Add(SqlParamProjectID);

            SqlDataAdapter objDataAdapter = new SqlDataAdapter(sqlCmd);
            objDataAdapter.Fill(objDataSet);
            if (objDataSet.Tables[0].Rows.Count > 0)
            {
                IsRecordExists = true;
            }
            myConnection.Close();
        }
        catch (Exception)
        {
        }
        return IsRecordExists;
    }

    public string FindRoleDetailsBYUserName(string UserName)
    {
        DataSet objDataSet = new DataSet();
        string RoleName = "";
        SqlConnection myConnection = new SqlConnection(connectionString);
        SqlCommand cmd = new SqlCommand("Proc_FindRoleDetailsBYUserName", myConnection);
        cmd.CommandType = CommandType.StoredProcedure;
        myConnection.Open();
        SqlParameter SqlParamUserName = new SqlParameter("@UserName", Convert.ToString(UserName));
        SqlParamUserName.Direction = ParameterDirection.Input;
        cmd.Parameters.Add(SqlParamUserName);
        SqlDataAdapter objDataAdapter = new SqlDataAdapter(cmd);
        objDataAdapter.Fill(objDataSet);
        DataRow objDataRow;
        if (objDataSet.Tables[0].Rows.Count > 0)
        {
            for (int iterator = 0; iterator < objDataSet.Tables[0].Rows.Count; iterator++)
            {
                objDataRow = objDataSet.Tables[0].Rows[iterator];

                if (RoleName != "")
                {
                    RoleName = RoleName + "," + Convert.ToString(objDataRow["RoleName"]);
                }
                else
                {
                    RoleName = Convert.ToString(objDataRow["RoleName"]);
                }
            }
        }
        myConnection.Close();
        return RoleName;
    }
}
