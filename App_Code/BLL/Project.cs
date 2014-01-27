using System;
using System.Collections;
using ASPNET.StarterKit.DataAccessLayer;
using System.Collections.Generic;

namespace ASPNET.StarterKit.BusinessLogicLayer {
  public class Project {
    /*** FIELD PRIVATE ***/
    private decimal _ActualDuration;
    private string _CreatorUserName;
    private DateTime _CompletionDate;
    private DateTime _DateCreated;
    private string _Description;
    private decimal _DevelopmentEstimateDuration;
    private decimal _TestingEstimateDuration;
    private decimal _DesignEstimateDuration;
    private decimal _BAEstimateDuration;
    private decimal _ProjectManagementEstimateDuration;
    private decimal _OtherDuration;
    private decimal _EstimateDuration;
    private int _Id;
    private string _ManagerUserName;
    private string _Name;
    private bool _IsCompleted;
    private int _ProjectId;
    private DateTime _CreatedOn;
    private string _PrjDocName;
    private string _PrjEncDocName;
    private string _CreatedUser;
    private int _AutoId;
    private string _ClientName;
    private string _UserId;
    private string _ContactNo;
    private string _Address;



    /*** CONSTRUCTOR ***/

    public Project(string name, int PorjectId, string Addressss, string ContactNooo)
    {
        _Name = name.Trim();
        _Id = PorjectId;
        _Address = Addressss;
        _ContactNo = ContactNooo;
    }

    public string Address
    {
        get { return _Address; }
        set { _Address = value; }
    }

    public string ContactNo
    {
        get { return _ContactNo; }
        set { _ContactNo = value; }
    }

    public string UserId
    {
        get { return _UserId; }
        set { _UserId = value; }
    }

    public string ClientName
    {
        get { return _ClientName; }
        set { _ClientName = value; }
    }

    public int AutoId
    {
        get { return _AutoId; }
        set { _AutoId = value; }
    }
    public string CreatedUser
    {
        get { return _CreatedUser; }
        set { _CreatedUser = value; }
    }
    public string PrjEncDocName
    {
        get { return _PrjEncDocName; }
        set { _PrjEncDocName = value; }
    }

    public string PrjDocName
    {
        get { return _PrjDocName; }
        set { _PrjDocName = value; }
    }
    public DateTime CreatedOn
    {
        get { return _CreatedOn; }
        set { _CreatedOn = value; }
    }

    public int ProjectId
    {
        get { return _ProjectId; }
        set { _ProjectId = value; }
    }
    public Project(string name, int PorjectId)
    {
        _Name = name.Trim();
        _Id = PorjectId;      
    }

    public Project(string name, string UserIId)
    {
        _Name = name.Trim();
        _UserId = UserIId;
    }

    public Project(string name,int PorjectId,string ClientNamee)
    {
        _Name = name;
        _Id = PorjectId;
        _ClientName = ClientNamee;
    }
    public Project(string creatorUsername, string managerUserName, string name)
      : this(DefaultValues.GetDurationMinValue(), creatorUsername, DefaultValues.GetDateTimeMinValue(), DefaultValues.GetDateTimeMinValue(), string.Empty, DefaultValues.GetProjectDurationMinValue(), DefaultValues.GetProjectIdMinValue(), managerUserName, name) {
    }

    public Project(string creatorUsername, string description, int id, string managerUserName, string name)
      : this(DefaultValues.GetDurationMinValue(), creatorUsername, DefaultValues.GetDateTimeMinValue(), DefaultValues.GetDateTimeMinValue(), string.Empty, DefaultValues.GetProjectDurationMinValue(), DefaultValues.GetProjectIdMinValue(), managerUserName, name) {
    }

    public Project(decimal actualDuration, string creatorUserName, DateTime completionDate, DateTime dateCreated, string description, decimal estimateDuration, int id, string managerUserName, string name)
    {
      // Validate Mandatory Fields//
      if (String.IsNullOrEmpty(creatorUserName))
        throw (new NullReferenceException("creatorUsername"));

      if (String.IsNullOrEmpty(managerUserName))
        throw (new NullReferenceException("managerUserName"));

      if (String.IsNullOrEmpty(name))
        throw (new NullReferenceException("name"));


      _ActualDuration = actualDuration;
      _CreatorUserName = creatorUserName;
      _CompletionDate = completionDate;
      _DateCreated = dateCreated;
      _Description = description;
      _EstimateDuration = estimateDuration;
      _Id = id;
      _ManagerUserName = managerUserName;
      _Name = name;
    }

    public Project(decimal actualDuration, string creatorUserName, DateTime completionDate, DateTime dateCreated, string description, decimal DevelopmentHours, decimal TestingHours, decimal DesginingHours, decimal BAHours, decimal ProjectManagementHours, decimal othersHours, decimal estimateDuration, int id, string managerUserName, string name, bool IsCompleted, string ClientNamee)
    {
        // Validate Mandatory Fields//
        if (String.IsNullOrEmpty(creatorUserName))
            throw (new NullReferenceException("creatorUsername"));

        if (String.IsNullOrEmpty(managerUserName))
            throw (new NullReferenceException("managerUserName"));

        if (String.IsNullOrEmpty(name))
            throw (new NullReferenceException("name"));


        _ActualDuration = actualDuration;
        _CreatorUserName = creatorUserName;
        _CompletionDate = completionDate;
        _DateCreated = dateCreated;
        _Description = description;
        _DevelopmentEstimateDuration = DevelopmentHours;
        _TestingEstimateDuration = TestingHours;
        _DesignEstimateDuration = DesginingHours;
        _BAEstimateDuration = BAHours;
        _ProjectManagementEstimateDuration = ProjectManagementHours;
        _OtherDuration = othersHours;
        _EstimateDuration = estimateDuration;
        _Id = id;
        _ManagerUserName = managerUserName;
        _Name = name;
        _IsCompleted = IsCompleted;
        if (ClientNamee != "")
        {
            _ClientName = ClientNamee;
        }
        else
        {
            _ClientName = "0";
        }

      
    }

    public Project(int AutoIId,int ProjectId, string ProjectName, DateTime CreatedOn, string UserName, string DocumentName, string DocumentEncrypetedName)
    {
        _ProjectId = ProjectId;
        _Name = ProjectName;
        _DateCreated = CreatedOn;
        _CreatedUser = UserName;
        _PrjDocName = DocumentName;
        _PrjEncDocName = DocumentEncrypetedName;
        _AutoId = AutoIId;
    }

    public Project(decimal actualDuration, DateTime completionDate, decimal estimateDuration, int id,string name)
    {
        // Validate Mandatory Fields//

        if (String.IsNullOrEmpty(name))
            throw (new NullReferenceException("name"));
       

        
        _ActualDuration = actualDuration;
        
        _CompletionDate = completionDate;
        
        _EstimateDuration = estimateDuration;
        _Id = id;
        
        _Name = name;
    }
    /*** PROPERTIES ***/
    public decimal ActualDuration {
      get { return _ActualDuration; }
    }

    public string CreatorUserName {
      get {
        if (String.IsNullOrEmpty(_CreatorUserName))
          return string.Empty;
        else
          return _CreatorUserName;
      }
    }

    public bool IsCompleted
    {
        get { return _IsCompleted; }
        set { _IsCompleted = value; }
    }

    public DateTime CompletionDate {
      get { return _CompletionDate; }
      set { _CompletionDate = value; }
    }

    public DateTime DateCreated {
      get { return _DateCreated; }
    }

    public string Description {
      get {
        if (String.IsNullOrEmpty(_Description))
          return string.Empty;
        else
          return _Description;
      }
      set { _Description = value; }
    }

    public decimal DevelopmentEstimateDuration
    {
        get { return _DevelopmentEstimateDuration; }
        set { _DevelopmentEstimateDuration = value; }
    }

    public decimal TestingEstimateDuration
    {
        get { return _TestingEstimateDuration; }
        set { _TestingEstimateDuration = value; }
    }

    public decimal DesignEstimateDuration
    {
        get { return _DesignEstimateDuration; }
        set { _DesignEstimateDuration = value; }
    }

    public decimal BAEstimateDuration
    {
        get { return _BAEstimateDuration; }
        set { _BAEstimateDuration = value; }
    }

    public decimal ProjectManagementEstimateDuration
    {
        get { return _ProjectManagementEstimateDuration; }
        set { _ProjectManagementEstimateDuration = value; }
    }
    public decimal OtherDuration
    {
        get { return _OtherDuration; }
        set { _OtherDuration = value; }
    }

    public decimal EstimateDuration {
      get { return _EstimateDuration; }
      set { _EstimateDuration = value; }
    }

    public int Id {
      get { return _Id; }
    }

    public string ManagerUserName {
      get {
        if (String.IsNullOrEmpty(_ManagerUserName))
          return string.Empty;
        else
          return _ManagerUserName;
      }
      set { _ManagerUserName = value; }
    }

    public string Name {
      get {
        if (String.IsNullOrEmpty(_Name))
          return string.Empty;
        else
          return _Name;
      }
      set { _Name = value; }
    }

    /*** METHODS  ***/
    public bool Delete() {
      if (this.Id > DefaultValues.GetProjectIdMinValue()) {
        DataAccess DALLayer = DataAccessHelper.GetDataAccess();
        return DALLayer.DeleteProject(this.Id);
      }
      else
        return false;
    }

    public bool Save() {
      DataAccess DALLayer = DataAccessHelper.GetDataAccess();
      if (Id <= DefaultValues.GetProjectIdMinValue()) {
        int TempId = DALLayer.CreateNewProject(this);
        if (TempId > DefaultValues.GetProjectIdMinValue()) {
          _Id = TempId;
          return true;
        }
        else
          return false;
      }
      else
        return (DALLayer.UpdateProject(this));
    }

    /*** METHOD STATIC ***/
    public static bool AddUserToProject(int projectId, string userName) {

      if (projectId <= DefaultValues.GetProjectIdMinValue())
        throw (new ArgumentOutOfRangeException("projectId"));

      if (String.IsNullOrEmpty(userName))
        throw (new NullReferenceException("userName"));


      DataAccess DALLayer = DataAccessHelper.GetDataAccess();
      return (DALLayer.AddUserToProject(projectId, userName));
    }

    public static bool DeleteProject(int Id) {
      if (Id <= DefaultValues.GetProjectIdMinValue())
        throw (new ArgumentOutOfRangeException("Id"));

      DataAccess DALLayer = DataAccessHelper.GetDataAccess();
      return (DALLayer.DeleteProject(Id));
    }

    public static List<Project> GetAllProjects() {
      DataAccess DALLayer = DataAccessHelper.GetDataAccess();
      return (DALLayer.GetAllProjects());
    }

    public static List<Project> GetAllOpenProjects(string sortParameter)
    {
        DataAccess DALLayer = DataAccessHelper.GetDataAccess();
        List<Project> projectList = DALLayer.GetAllOpenProjects();

        if (!String.IsNullOrEmpty(sortParameter))
            projectList.Sort(new ProjectComparer(sortParameter));
        return (projectList);
    }

    public static List<Project> GetAllClosedProjects(string sortParameter)
    {
        DataAccess DALLayer = DataAccessHelper.GetDataAccess();
        List<Project> projectList = DALLayer.GetAllClosedProjects();
        if (!String.IsNullOrEmpty(sortParameter))
            projectList.Sort(new ProjectComparer(sortParameter));
        return (projectList);
    }


    public static List<Project> GetAllProjectsReport()
    {
        DataAccess DALLayer = DataAccessHelper.GetDataAccess();
        return (DALLayer.GetAllProjectsReport());
    }

    public static List<Project> GetAllProjects(string sortParameter) {
      DataAccess DALLayer = DataAccessHelper.GetDataAccess();
      List<Project> projectList = DALLayer.GetAllProjects();

      if (!String.IsNullOrEmpty(sortParameter))
        projectList.Sort(new ProjectComparer(sortParameter));

      return (projectList);
    }
    public static Project GetProjectById(int Id)
    {
        if (Id <= DefaultValues.GetProjectIdMinValue())
            return (null);

        DataAccess DALLayer = DataAccessHelper.GetDataAccess();
        return (DALLayer.GetProjectById(Id));
    }

    public static Project GetProjectReportByIdAndDates(int Id, DateTime StartDate, DateTime EndDate)
    {
      if (Id <= DefaultValues.GetProjectIdMinValue())
        return (null);

      DataAccess DALLayer = DataAccessHelper.GetDataAccess();
      return (DALLayer.GetProjectReportByIdAndDates(Id, StartDate, EndDate));
    }


    public static List<Project> GetProjectByIdsAndDates(string ProjectIds, DateTime StartDate, DateTime EndDate)
    {

      if (String.IsNullOrEmpty(ProjectIds))
        return (new List<Project>());

      char[] separator = new char[] { ',' };
      string[] substrings = ProjectIds.Split(separator);
      List<Project> list = new List<Project>();

      foreach (string str in substrings) {
        if (!string.IsNullOrEmpty(str)) {
          int id = Convert.ToInt32(str);
          list.Add(Project.GetProjectReportByIdAndDates(id,StartDate ,EndDate));
        }
      }
      return list;
    }






    public static Project GetProjectReportByIdAndMonthAndYear(int Id, int Month, int Year)
    {
        if (Id <= DefaultValues.GetProjectIdMinValue())
            return (null);

        DataAccess DALLayer = DataAccessHelper.GetDataAccess();
        return (DALLayer.GetProjectReportByIdAndMonthAndYear(Id, Month, Year));
    }


    public static List<Project> GetProjectReportByIdsAndMonthAndYear(string ProjectIds, int Month, int Year)
    {

        if (String.IsNullOrEmpty(ProjectIds))
            return (new List<Project>());

        char[] separator = new char[] { ',' };
        string[] substrings = ProjectIds.Split(separator);
        List<Project> list = new List<Project>();

        foreach (string str in substrings)
        {
            if (!string.IsNullOrEmpty(str))
            {
                int id = Convert.ToInt32(str);
                list.Add(Project.GetProjectReportByIdAndMonthAndYear(id, Month, Year));
            }
        }
        return list;
    }


    public static List<Project> GetOpenProjectsByManagerUserName(string sortParameter, string userName)
    {
        if (String.IsNullOrEmpty(userName))
            return (new List<Project>());

        DataAccess DALLayer = DataAccessHelper.GetDataAccess();
        List<Project> prjColl = DALLayer.GetOpenProjectsByManagerUserName(userName);
        if (String.IsNullOrEmpty(sortParameter))
            prjColl.Sort(new ProjectComparer(sortParameter));

        return prjColl;
    }
    public static List<Project> GetCloseProjectsByManagerUserName(string sortParameter, string userName)
    {
        if (String.IsNullOrEmpty(userName))
            return (new List<Project>());

        DataAccess DALLayer = DataAccessHelper.GetDataAccess();
        List<Project> prjColl = DALLayer.GetCloseProjectsByManagerUserName(userName);
        if (String.IsNullOrEmpty(sortParameter))
            prjColl.Sort(new ProjectComparer(sortParameter));

        return prjColl;
    }






    public static List<Project> GetProjectsByManagerUserName(string sortParameter, string userName) {
      if (String.IsNullOrEmpty(userName))
        return (new List<Project>());

      DataAccess DALLayer = DataAccessHelper.GetDataAccess();
      List<Project> prjColl = DALLayer.GetProjectsByManagerUserName(userName);
      if (String.IsNullOrEmpty(sortParameter))
        prjColl.Sort(new ProjectComparer(sortParameter));

      return prjColl;
    }

    public static List<string> GetProjectMembers(int Id) {
      if (Id <= DefaultValues.GetProjectIdMinValue())
        return (new List<string>());

      DataAccess DALLayer = DataAccessHelper.GetDataAccess();
      return (DALLayer.GetProjectMembers(Id));
    }

    public static List<string> GetProjectMembers(string userNames) {
      if (String.IsNullOrEmpty(userNames))
        return (new List<string>());

      char[] separator = new char[] { ',' };
      string[] substrings = userNames.Split(separator);
      List<string> list = new List<string>();

      foreach (string str in substrings) {
        if (!string.IsNullOrEmpty(str)) {
          int Id = Convert.ToInt32(str);
          List<string> tempList = Project.GetProjectMembers(Id);
          foreach (string userName in tempList) {
            if (!list.Contains(userName)) {
              list.Add(userName);
            }
          }
        }
      }
      return list;
    }

    public static List<Project> GetProjectsByUserName(string userName) {
      if (String.IsNullOrEmpty(userName))
        return (new List<Project>());

      DataAccess DALLayer = DataAccessHelper.GetDataAccess();
      return (DALLayer.GetProjectsByUserName(userName));

    }

    public static bool RemoveUserFromProject(int projectId, string userName) {

      if (projectId <= DefaultValues.GetProjectIdMinValue())
        throw (new ArgumentOutOfRangeException("projectId"));

      if (String.IsNullOrEmpty(userName))
        throw (new NullReferenceException("userName"));


      DataAccess DALLayer = DataAccessHelper.GetDataAccess();
      return (DALLayer.RemoveUserFromProject(projectId, userName));
    }
  }
}
