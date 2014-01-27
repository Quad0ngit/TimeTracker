using System;
using System.Collections.Generic;
using ASPNET.StarterKit.DataAccessLayer;

namespace ASPNET.StarterKit.BusinessLogicLayer
{
    public class UserTotalDurationReport
    {
        /*** FIELD PRIVATE ***/
        private decimal _TotalDuration;
        private string _UserName;
        private DateTime _timeEntryDate;

        /*** CONSTRUCTOR ***/
        public UserTotalDurationReport(decimal totalDuration, string userName)
        {

            if (totalDuration < DefaultValues.GetDurationMinValue())
                throw (new ArgumentOutOfRangeException("totalDuration"));

            if (String.IsNullOrEmpty(userName))
                throw (new NullReferenceException("userName"));

            _TotalDuration = totalDuration;
            _UserName = userName;
            
        }

        public UserTotalDurationReport(decimal totalDuration, DateTime TimeEntryDate)
        {

            if (totalDuration < DefaultValues.GetDurationMinValue())
                throw (new ArgumentOutOfRangeException("totalDuration"));

            _TotalDuration = totalDuration;
            _timeEntryDate = TimeEntryDate;
        }

        /*** PROPERTIES ***/
        public decimal TotalDuration
        {
            get { return _TotalDuration; }
        }

        public DateTime timeEntryDate
        {
            get { return _timeEntryDate; }
        }


        public string UserName
        {
            get
            {
                if (String.IsNullOrEmpty(_UserName))
                    return string.Empty;
                else
                    return _UserName;
            }
        }

        public static List<UserTotalDurationReport> GetUserReportsByUserName(string userName)
        {
            if (String.IsNullOrEmpty(userName))
                return (new List<UserTotalDurationReport>());

            DataAccess DALLayer = DataAccessHelper.GetDataAccess();
            return (DALLayer.GetUserReportsByUserName(userName));
        }

        public static List<UserTotalDurationReport> GetUserReportsByUserNames(string userNames )
        {
            if (String.IsNullOrEmpty(userNames))
                return (new List<UserTotalDurationReport>());

            char[] separator = new char[] { ',' };
            string[] substrings = userNames.Split(separator);
            List<UserTotalDurationReport> list = new List<UserTotalDurationReport>();

            foreach (string str in substrings)
            {
                if (!string.IsNullOrEmpty(str))
                {
                    List<UserTotalDurationReport> tempList = UserTotalDurationReport.GetUserReportsByUserName(str);
                    foreach (UserTotalDurationReport userReport in tempList)
                    {
                        list.Add(userReport);
                    }
                }
            }
            return list;
        }
        public static List<UserTotalDurationReport> GetUserReportsByUserNameAndDates(string userName, DateTime startDate, DateTime endDate,string ProjectId)
        {
            if (String.IsNullOrEmpty(userName))
                return (new List<UserTotalDurationReport>());
            if (ProjectId != null && ProjectId != "0" && ProjectId.Contains(","))
            {
                if (ProjectId.Length > 0)
                {
                    ProjectId = ProjectId.Trim().Substring(0, ProjectId.Length - 1);
                }
            }
            DataAccess DALLayer = DataAccessHelper.GetDataAccess();
            return (DALLayer.GetUserReportsByUserNameAndDates(userName,startDate,endDate,ProjectId));
        }

        public static List<UserTotalDurationReport> GetUserReportsByUserNamesAndDates(string userNames, DateTime startDate, DateTime endDate, string ProjectId)
        {
            if (String.IsNullOrEmpty(userNames))
                return (new List<UserTotalDurationReport>());

            char[] separator = new char[] { ',' };
            string[] substrings = userNames.Split(separator);
            List<UserTotalDurationReport> list = new List<UserTotalDurationReport>();
            if (ProjectId != null && ProjectId != "0" && ProjectId.Contains(","))
            {
                if (ProjectId.Length > 0)
                {
                    ProjectId = ProjectId.Trim().Substring(0, ProjectId.Length - 1);
                }
            }
            foreach (string str in substrings)
            {
                if (str != "")
                {
                    if (ProjectId == "0")
                    {
                        CustomFacade ObjCustomFacade = new CustomFacade();
                        List<Project> objlstProject = new List<Project>();
                        objlstProject = ObjCustomFacade.GetProjectDetailsByUserDetails(Convert.ToString(str));
                        if (objlstProject.Count > 0)
                        {
                            for (int i = 0; i < objlstProject.Count; i++)
                            {
                                if (ProjectId == "")
                                {
                                    ProjectId = ProjectId + "," + Convert.ToString(objlstProject[i].Id);
                                }
                                else
                                {
                                    ProjectId = Convert.ToString(objlstProject[i].Id);
                                }
                            }
                        }
                    }
                    if (!string.IsNullOrEmpty(str))
                    {
                        List<UserTotalDurationReport> tempList = UserTotalDurationReport.GetUserReportsByUserNameAndDates(str, startDate, endDate, ProjectId);
                        foreach (UserTotalDurationReport userReport in tempList)
                        {
                            list.Add(userReport);
                        }
                    }
                }
            }
            return list;
        }


        public static List<UserTotalDurationReport> GetUserReportsByUserNameAndMonthAndyear(string userName, int Month, int Year, string ProjectId)
        {
            if (String.IsNullOrEmpty(userName))
                return (new List<UserTotalDurationReport>());
            DataAccess DALLayer = DataAccessHelper.GetDataAccess();
            return (DALLayer.GetUserReportsByUserNameAndMonthAndyear(userName, Month, Year,ProjectId));
        }

        public static List<UserTotalDurationReport> GetUserReportsByUserNamesAndMonthAndyear(string userNames, int Month, int Year,string ProjectId)
        {
            if (String.IsNullOrEmpty(userNames))
                return (new List<UserTotalDurationReport>());

            char[] separator = new char[] { ',' };
            string[] substrings = userNames.Split(separator);
            //string[] substringProject = ProjectId.Split(separator);
            List<UserTotalDurationReport> list = new List<UserTotalDurationReport>();
            if (ProjectId != null && ProjectId!="0")
            {
                if (ProjectId.Length > 0)
                {
                    ProjectId = ProjectId.Trim().Substring(0, ProjectId.Length - 1);
                }
            }
            foreach (string str in substrings)
            {
            if (ProjectId=="0")
            {
                CustomFacade ObjCustomFacade = new CustomFacade();
                List<Project> objlstProject = new List<Project>();
                 objlstProject = ObjCustomFacade.GetProjectDetailsByUserDetails(Convert.ToString(str));
                 if (objlstProject.Count > 0)
                 {
                     for (int i = 0; i < objlstProject.Count; i++)
                     {
                         if (ProjectId == "")
                         {
                             ProjectId = ProjectId + "," + Convert.ToString(objlstProject[i].Id);
                         }
                         else
                         {
                             ProjectId = Convert.ToString(objlstProject[i].Id);
                         }
                     }                  
                 }
            }

            if (!string.IsNullOrEmpty(str))
            {
                //foreach (var item in substringProject)
                //{
                //    if (!string.IsNullOrEmpty(item))
                //    {
                        List<UserTotalDurationReport> tempList = UserTotalDurationReport.GetUserReportsByUserNameAndMonthAndyear(str, Month, Year, ProjectId);
                        foreach (UserTotalDurationReport userReport in tempList)
                        {
                            list.Add(userReport);
                        }
                //    }
                //}
            }
            }
            return list;
        }


        public static List<UserTotalDurationReport> GetUserReportsDateWiseByUserNameAndDates(string userName, DateTime startDate, DateTime endDate)
        {
            if (String.IsNullOrEmpty(userName))
                return (new List<UserTotalDurationReport>());

            DataAccess DALLayer = DataAccessHelper.GetDataAccess();
            return (DALLayer.GetUserReportsDateWiseByUserNameAndDates(userName, startDate, endDate));
        }

        public static List<UserTotalDurationReport> GetUserReportsDateWiseByUserNamesAndDates(string userNames, DateTime startDate, DateTime endDate)
        {
            if (String.IsNullOrEmpty(userNames))
                return (new List<UserTotalDurationReport>());

            char[] separator = new char[] { ',' };
            string[] substrings = userNames.Split(separator);
            List<UserTotalDurationReport> list = new List<UserTotalDurationReport>();

            foreach (string str in substrings)
            {
                if (!string.IsNullOrEmpty(str))
                {
                    List<UserTotalDurationReport> tempList = UserTotalDurationReport.GetUserReportsDateWiseByUserNameAndDates(str, startDate, endDate);
                    foreach (UserTotalDurationReport userReport in tempList)
                    {
                        list.Add(userReport);
                    }
                }
            }
            return list;
        }

        public static List<UserTotalDurationReport> GetUserReportsDateWiseByUserNameAndMonthAndYear(string userName, int Month, int Year)
        {
            if (String.IsNullOrEmpty(userName))
                return (new List<UserTotalDurationReport>());

            DataAccess DALLayer = DataAccessHelper.GetDataAccess();
            return (DALLayer.GetUserReportsDateWiseByUserNameAndMonthAndYear(userName, Month, Year));
        }

        public static List<UserTotalDurationReport> GetUserReportsDateWiseByUserNamesAndMonthAndYear(string userNames, int Month, int Year)
        {
            if (String.IsNullOrEmpty(userNames))
                return (new List<UserTotalDurationReport>());

            char[] separator = new char[] { ',' };
            string[] substrings = userNames.Split(separator);
            List<UserTotalDurationReport> list = new List<UserTotalDurationReport>();

            foreach (string str in substrings)
            {
                if (!string.IsNullOrEmpty(str))
                {
                    List<UserTotalDurationReport> tempList = UserTotalDurationReport.GetUserReportsDateWiseByUserNameAndMonthAndYear(str, Month, Year);
                    foreach (UserTotalDurationReport userReport in tempList)
                    {
                        list.Add(userReport);
                    }
                }
            }
            return list;
        }


        //  public static List<UserTotalDurationReport> GetresourceReportByProjectId(int ProjectId)
        //  {
        //      if (Id <= DefaultValues.GetProjectIdMinValue())
        //          return (null);

        //      DataAccess DALLayer = DataAccessHelper.GetDataAccess();
        //      return (DALLayer.GetresourceReportByProjectId(ProjectId));
        //  }
        //  public static List<UserTotalDurationReport> GetresourceReportByProjectIds(String ProjectIds)
        //  {
        //      if (String.IsNullOrEmpty(ProjectIds))
        //          return (new List<UserTotalDurationReport>());

        //      char[] separator = new char[] { ',' };
        //      string[] substrings = ProjectIds.Split(separator);
        //      List<UserTotalDurationReport> list = new List<UserTotalDurationReport>();

        //      foreach (string str in substrings)
        //      {
        //          if (!string.IsNullOrEmpty(str))
        //          {
        //              List<UserTotalDurationReport> tempList = UserTotalDurationReport.GetresourceReportByProjectId(str);
        //              foreach (UserTotalDurationReport userReport in tempList)
        //              {
        //                  list.Add(userReport);
        //              }
        //          }
        //      }
        //      return list;
        //  }
        //}


        public List<UserReport> GetUserReportsByProjectIdsAndMonthAndYear(Int32 ProjectIds, Int32 Month, Int32 Year)
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
            CustomDAO objCustomDAO = new CustomDAO();
            return (objCustomDAO.GetClientWiseUserReportsByProjectIdAndMonthAndYear(projectId, Month, Year));
        }


    }
}


