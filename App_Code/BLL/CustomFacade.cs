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

/// <summary>
/// Summary description for CustomFacade
/// </summary>
public class CustomFacade
{
	public CustomFacade()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    CustomDAO objCustomDAO = new CustomDAO();

    public List<Project> GetProjectDetails()
    {
      return objCustomDAO.FindProjectDetails();
    }

    public List<Project> GetProjectDetailsByUserDetails(string UserName)
    {
        return objCustomDAO.FindProjectDetailsByUserDetails(UserName);
    }

    public List<Project> GetProjectDetailsByCategoryDetails(string CategoryID)
    {
        return objCustomDAO.FindProjectDetailsByCategoryDetails(CategoryID);
    }

    public string GetRoleDetailsBYUserId(string UserID)
    {
        return objCustomDAO.FindRoleDetailsBYUserId(UserID);
    }
    public List<Project> getProjectDocsDetailsByProjectId(int PrjId)
    {
        return objCustomDAO.FindProjectDocsDetailsByProjectId(PrjId);
    }

    public void saveProjectDocumentsByProjectId(Project objProject)
    {
        objCustomDAO.saveProjectDocumentsByProjectId(objProject);
    }

    public void DeleteProjectDocsDetailsByAutoId(int AutoId)
    {
        objCustomDAO.DeleteProjectDocsDetailsByAutoId(AutoId);
    }

    public List<Project> GetClientDeatils()
    {
        return objCustomDAO.FindClientDeatils();
    }

    
    public List<Project> GetClientReportByIdAndMonthAndYear(int Id, int Month, int Year)
    {
        if (Id <= DefaultValues.GetProjectIdMinValue())
            return (null);
        return (objCustomDAO.GetClientReportByIdAndMonthAndYear(Id, Month, Year));
    }

    public List<UserReport> GetClientWiseUserReportsByProjectIdAndMonthAndYear(int ProjectIds, Int32 Month, Int32 Year)
    {
        List<UserReport> list = new List<UserReport>();
        List<UserReport> tempList = GetUserReportsByProjectIdAndMonthAndYear(ProjectIds, Month, Year);
        foreach (UserReport userReport in tempList)
        {
            list.Add(userReport);
        }
        return list;
    }

    public List<UserReport> GetUserReportsByProjectIdAndMonthAndYear(int projectId, Int32 Month, Int32 Year)
    {
        return (objCustomDAO.GetClientWiseUserReportsByProjectIdAndMonthAndYear(projectId, Month, Year));
    }

    public List<Project> GetProjectByIdsAndDates(int ProjectIds, DateTime StartDate, DateTime EndDate)
    {
       return objCustomDAO.GetProjectReportByIdAndDates(ProjectIds, StartDate, EndDate);      
    }


    public List<Project> GetProjectLeaderDeatils()
    {
        return objCustomDAO.FindProjectLeaderDetails();
    }

    public void SaveUserToTeamLead(string genUserId, string TMLeaderUserId)
    {
        objCustomDAO.SaveUserToTeamLead(genUserId, TMLeaderUserId);
    }

    public List<Project> GetProjectsByUserName(string userName)
    {
        if (String.IsNullOrEmpty(userName))
            return (new List<Project>());
        return (objCustomDAO.GetProjectsByUserName(userName));

    }

    public List<Project> getTeamUserByTeamleader(string TeamLeaderUserName)
    {
        return objCustomDAO.FindTeamUserByTeamleader(TeamLeaderUserName);
    }

    public List<TimeEntry> GetTimeEntriesByUserNameProjectIdAndDates(string userName, string ProjectId, DateTime startingDate, DateTime endDate)
    {
        if (String.IsNullOrEmpty(userName))
            return (new List<TimeEntry>());
        return (objCustomDAO.GetTimeEntriesByUserNameProjectIdAndDates(userName, ProjectId, startingDate, endDate));
    }

    public string getUserIdByUserName(string UserName)
    {
        return objCustomDAO.FindUserIdByUserName(UserName);
    }

    public string getTeamLeadUserIdByUserId(string UserId)
    {
        return objCustomDAO.FindTeamLeadUserIdByUserId(UserId);
    }

    public void saveClientDeatils(int ClientId, string ClientName, string ContactNo, string Address)
    {
        objCustomDAO.saveClientDeatils(ClientId,ClientName,ContactNo,Address);
    }

    public bool FindIsProjectDocumentExists(string fileName, int ProjectId)
    {
        return objCustomDAO.FindIsProjectDocumentExists(fileName, ProjectId);
    }

    public bool IsProjectExists(string ProjectName,int ProjectId)
    {
        return objCustomDAO.FindIsProjectExists(ProjectName,ProjectId);
    }

    public string GetRoleDetailsBYUserName(string UserName)
    {
        return objCustomDAO.FindRoleDetailsBYUserName(UserName);
    }
}
