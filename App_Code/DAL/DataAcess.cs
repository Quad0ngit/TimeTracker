using System;
using System.Configuration;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using ASPNET.StarterKit.BusinessLogicLayer;

namespace ASPNET.StarterKit.DataAccessLayer {
  public abstract class DataAccess {
    /*** PROPERTIES ***/
    protected string ConnectionString {
      get {
        if (ConfigurationManager.ConnectionStrings["aspnet_staterKits_TimeTracker"] == null)
          throw (new NullReferenceException("ConnectionString configuration is missing from you web.config. It should contain  <connectionStrings> <add key=\"aspnet_staterKits_TimeTracker\" value=\"Server=(local);Integrated Security=True;Database=Issue_Tracker\" </connectionStrings>"));

        string connectionString = ConfigurationManager.ConnectionStrings["aspnet_staterKits_TimeTracker"].ConnectionString;

        if (String.IsNullOrEmpty(connectionString))
          throw (new NullReferenceException("ConnectionString configuration is missing from you web.config. It should contain  <connectionStrings> <add key=\"aspnet_staterKits_TimeTracker\" value=\"Server=(local);Integrated Security=True;Database=Issue_Tracker\" </connectionStrings>"));
        else
          return (connectionString);
      }
    }

    /*** METHODS  ***/

    //Category
    public abstract int CreateNewCategory(Category newCategory);
    public abstract bool DeleteCategory(int categoryId);
    public abstract List<Category> GetAllCategories();
    public abstract Category GetCategoryByCategoryId(int Id);
    public abstract List<Category> GetCategoriesByProjectId(int projectId);
    public abstract List<Category> GetCategoriesByUserName(string UserName);
    public abstract Category GetCategoryByCategoryNameandProjectId(string categoryName, int projectId);
    public abstract bool UpdateCategory(Category newCategory);

    //TimeEntry
    public abstract int CreateNewTimeEntry(TimeEntry newTimeEntry);
    public abstract bool DeleteTimeEntry(int timeEntryId);
    public abstract List<TimeEntry> GetAllTimeEntries();
    public abstract List<TimeEntry> GetTimeEntries(int projectId, string userName);
    public abstract TimeEntry GetTimeEntryById(int timeEntryId);
    public abstract List<TimeEntry> GetTimeEntriesByUserNameAndDates(string userName,
                                                                     DateTime startingDate, DateTime endDate);
    public abstract List<TimeEntry> GetTimeEntriesByUserNameProjectIdAndDates(string userName, string projectId,
                                                                   DateTime startingDate, DateTime endDate);
    public abstract List<TimeEntry> GetTimeEntriesByUserNameProjectIdAndMonthAndYear(string userName, string projectId,
                                                              int Month, int Year);
    public abstract bool UpdateTimeEntry(TimeEntry timeEntry);

    // Project
    public abstract bool AddUserToProject(int projectId, string userName);
    public abstract int CreateNewProject(Project newProject);
    public abstract bool DeleteProject(int projectID);
    public abstract List<Project> GetAllProjects();
    public abstract List<Project> GetAllProjectsReport();
    public abstract Project GetProjectById(int projectId);
    public abstract Project GetProjectReportByIdAndDates(int projectId, DateTime StartDate, DateTime EndDate);
    public abstract Project GetProjectReportByIdAndMonthAndYear(int projectId, int Month, int Year);
    public abstract List<Project> GetOpenProjectsByManagerUserName(string userName);
    public abstract List<Project> GetCloseProjectsByManagerUserName(string userName);
    public abstract List<Project> GetProjectsByManagerUserName(string userName);
    public abstract List<string> GetProjectMembers(int Id);
    public abstract List<Project> GetProjectsByUserName(string userName);
    public abstract bool RemoveUserFromProject(int projectId, string userName);
    public abstract bool UpdateProject(Project projectToUpdate);

    //User report
    public abstract List<UserReport> GetCategoryReportsByCategoryIdAndDates(int CategoryId, DateTime StartDate, DateTime EndDate, string ProjectIds);
    public abstract List<UserReport> GetCategoryReportsByCategoryIdAndMonthAndYear(int CategoryId, int Month, int Year,string ProjectId);
    public abstract List<UserReport> GetUserReportsByProjectIdAndDates(int projectId ,DateTime StartDate, DateTime EndDate);
    public abstract List<UserReport> GetUserReportsByCategoryId(int categoryId);
    public abstract List<UserReport> GetUserReportsByProjectIdAndMonthAndYear(int projectId, Int32 Month, Int32 Year);

    // UserTotalDurationReport
    public abstract List<UserTotalDurationReport> GetUserReportsByUserName(string userName);
    public abstract List<UserTotalDurationReport> GetUserReportsByUserNameAndDates(string userName,DateTime startingDate,DateTime endDates,string ProjectId);
    public abstract List<UserTotalDurationReport> GetUserReportsByUserNameAndMonthAndyear(string userName, int Month, int Year,string ProjectId);
    public abstract List<UserTotalDurationReport> GetUserReportsDateWiseByUserNameAndDates(string userName, DateTime startingDate, DateTime endDates);
    public abstract List<UserTotalDurationReport> GetUserReportsDateWiseByUserNameAndMonthAndYear(string userName,int  Month,int Year);

    public abstract List<Project> GetAllOpenProjects();

    public abstract List<Project> GetAllClosedProjects();
  }
}

