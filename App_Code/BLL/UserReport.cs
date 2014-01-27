
using System;
using System.Collections.Generic;
using ASPNET.StarterKit.DataAccessLayer;

namespace ASPNET.StarterKit.BusinessLogicLayer {
  public class UserReport {
    /*** FIELD PRIVATE ***/
    private decimal _ActualDuration;
    private int _CategoryId;
    private string _UserName;
    private int _ProjectId;
    private string _Category;

    /*** CONSTRUCTOR ***/
    public UserReport(decimal actualDuration, int categoryId, string userName) {

      if (categoryId <= DefaultValues.GetCategoryIdMinValue())
        throw (new ArgumentOutOfRangeException("categoryId"));

      if (String.IsNullOrEmpty(userName))
        throw (new NullReferenceException("userName"));


      _ActualDuration = actualDuration;
      _CategoryId = categoryId;
      _UserName = userName;
    }

    /*** CONSTRUCTOR ***/
    public UserReport(decimal actualDuration, string userName)
    {
        if (String.IsNullOrEmpty(userName))
            throw (new NullReferenceException("userName"));
        _ActualDuration = actualDuration;
        _UserName = userName;
    }

    public UserReport(decimal actualDuration, string userName, string Category)
    {
        if (String.IsNullOrEmpty(userName))
            throw (new NullReferenceException("userName"));
        _ActualDuration = actualDuration;
        _UserName = userName;
        _Category = Category;
    }

    //public UserReport(decimal actualDuration, int ProjectId, string userName)
    //{

    //    if (ProjectId <= DefaultValues.GetCategoryIdMinValue())
    //        throw (new ArgumentOutOfRangeException("ProjectId"));

    //    if (String.IsNullOrEmpty(userName))
    //        throw (new NullReferenceException("userName"));


    //    _ActualDuration = actualDuration;
    //    _ProjectId = ProjectId;
    //    _UserName = userName;
    //}
    /*** PROPERTIES ***/
    public decimal ActualDuration {
      get { return _ActualDuration; }
    }

    public string Category
    {
        get { return _Category; }
        set { _Category = value; }
    }

    public int ProjectId
    {
        get { return ProjectId; }
    }

    public int CategoryId
    {
        get { return _CategoryId; }
    }
    public string UserName {
      get {
        if (String.IsNullOrEmpty(_UserName))
          return string.Empty;
        else
          return _UserName;
      }
    }

    /*** METHOD STATIC ***/
    public static List<UserReport> GetUserReportsByCategoryId(int CategoryId) {
      if (CategoryId <= DefaultValues.GetCategoryIdMinValue())
        return (new List<UserReport>());

      DataAccess DALLayer = DataAccessHelper.GetDataAccess();
      return (DALLayer.GetUserReportsByCategoryId(CategoryId));
    }

    public static List<UserReport> GetUserReportsByProjectIdAndDates(int projectId, DateTime StartDate, DateTime EndDate)
    {
      if (projectId <= DefaultValues.GetProjectIdMinValue())
        return (new List<UserReport>());

      DataAccess DALLayer = DataAccessHelper.GetDataAccess();
      return (DALLayer.GetUserReportsByProjectIdAndDates(projectId, StartDate, EndDate));
    }

    public static List<UserReport> GetUserReportsByProjectIdsAndDates(string ProjectIds, DateTime StartDate, DateTime EndDate)
    {
      if (String.IsNullOrEmpty(ProjectIds))
        return (new List<UserReport>());

      char[] separator = new char[] { ',' };
      string[] substrings = ProjectIds.Split(separator);
      List<UserReport> list = new List<UserReport>();

      foreach (string str in substrings) {
        if (!string.IsNullOrEmpty(str)) {
          int id = Convert.ToInt32(str);
          List<UserReport> tempList = UserReport.GetUserReportsByProjectIdAndDates(id,StartDate ,EndDate);
          foreach (UserReport userReport in tempList) {
            list.Add(userReport);
          }
        }
      }
      return list;
    }

    public static List<UserReport> GetUserReportsByProjectIdAndMonthAndYear(int projectId, Int32 Month, Int32 Year)
    {
        //if (projectId <= DefaultValues.GetProjectIdMinValue())
        //    return (new List<UserReport>());

        DataAccess DALLayer = DataAccessHelper.GetDataAccess();
        return (DALLayer.GetUserReportsByProjectIdAndMonthAndYear(projectId, Month, Year));
    }



    public static List<UserReport> GetUserReportsByProjectIdsAndMonthAndYear(string ProjectIds, Int32 Month, Int32 Year)
    {
        if (String.IsNullOrEmpty(ProjectIds))
            return (new List<UserReport>());
       
        if (ProjectIds != null && ProjectIds != "" && ProjectIds != "0")
        {
            ProjectIds = ProjectIds.Trim().Substring(0, ProjectIds.Length - 1);
        }
        char[] separator = new char[] { ',' };
        string[] substrings = ProjectIds.Split(separator);
        List<UserReport> list = new List<UserReport>();
        foreach (string str in substrings)
        {
            if (!string.IsNullOrEmpty(str))
            {
                int id = Convert.ToInt32(str);
                List<UserReport> tempList = UserReport.GetUserReportsByProjectIdAndMonthAndYear(id, Month, Year);
                foreach (UserReport userReport in tempList)
                {
                    list.Add(userReport);
                }
            }
        }
        return list;
    }


    public static List<UserReport> GetCategoryReportsByCategoryIdAndDates(int CategoryId, DateTime StartDate, DateTime EndDate, string ProjectIds)
    {
        if (CategoryId <= DefaultValues.GetProjectIdMinValue())
            return (new List<UserReport>());

        DataAccess DALLayer = DataAccessHelper.GetDataAccess();
        return (DALLayer.GetCategoryReportsByCategoryIdAndDates(CategoryId, StartDate, EndDate,ProjectIds));
    }




    public static List<UserReport> GetCategoryReportsByCategoryIdsAndDates(string CategoryIds, DateTime StartDate, DateTime EndDate, string ProjectIds)
    {
        if (String.IsNullOrEmpty(CategoryIds))
            return (new List<UserReport>());

        char[] separator = new char[] { ',' };
        string[] substrings = CategoryIds.Split(separator);
        List<UserReport> list = new List<UserReport>();
        if (ProjectIds!= null&& ProjectIds!=""&& ProjectIds!="0")
        {
            ProjectIds = ProjectIds.Trim().Substring(0, ProjectIds.Length - 1);
        }
        foreach (string str in substrings)
        {
            if (!string.IsNullOrEmpty(str))
            {
                int id = Convert.ToInt32(str);
                List<UserReport> tempList = UserReport.GetCategoryReportsByCategoryIdAndDates(id, StartDate, EndDate,ProjectIds);
                foreach (UserReport userReport in tempList)
                {
                    list.Add(userReport);
                }
            }
        }
        return list;
    }

    public static List<UserReport> GetCategoryReportsByCategoryIdAndMonthAndYear(int CategoryId, int Month, int year,string ProjectId)
    {
        if (CategoryId <= DefaultValues.GetProjectIdMinValue())
            return (new List<UserReport>());

        DataAccess DALLayer = DataAccessHelper.GetDataAccess();
        return (DALLayer.GetCategoryReportsByCategoryIdAndMonthAndYear(CategoryId, Month, year,ProjectId));
    }




    public static List<UserReport> GetCategoryReportsByCategoryIdsAndMonthAndYear(string CategoryIds, int Month, int year, string ProjectIds)
    {
        if (String.IsNullOrEmpty(CategoryIds))
            return (new List<UserReport>());

        char[] separator = new char[] { ',' };
        string[] substrings = CategoryIds.Split(separator);
        List<UserReport> list = new List<UserReport>();

        if (ProjectIds != "" && ProjectIds != null && ProjectIds != "0")
        {
            ProjectIds = ProjectIds.Trim().Substring(0, ProjectIds.Length - 1);
        }

        foreach (string str in substrings)
        {
            if (!string.IsNullOrEmpty(str))
            {
                int id = Convert.ToInt32(str);
                List<UserReport> tempList = UserReport.GetCategoryReportsByCategoryIdAndMonthAndYear(id, Month, year, ProjectIds);
                foreach (UserReport userReport in tempList)
                {
                    list.Add(userReport);
                }
            }
        }
        return list;
    }


    public static List<UserReport> GetClientWiseUserReportsByProjectIdAndMonthAndYear(int ProjectIds, Int32 Month, Int32 Year)
    {
        List<UserReport> list = new List<UserReport>();
        List<UserReport> tempList = GetCliUserReportsByProjectIdAndMonthAndYear(ProjectIds, Month, Year);
        foreach (UserReport userReport in tempList)
        {
            list.Add(userReport);
        }
        return list;
    }

    public static List<UserReport> GetCliUserReportsByProjectIdAndMonthAndYear(int projectId, Int32 Month, Int32 Year)
    {
        CustomDAO objCustomDAO = new CustomDAO();
        return (objCustomDAO.GetClientWiseUserReportsByProjectIdAndMonthAndYear(projectId, Month, Year));
    }
  }
}
