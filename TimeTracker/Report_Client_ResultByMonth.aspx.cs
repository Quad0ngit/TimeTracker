using System;
using System.Collections;
using System.Configuration;
using System.Data;
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

public partial class TimeTracker_Report_Client_ResultByMonth : System.Web.UI.Page
{
    
    int ProjectIds = 0;
    int Month = 0;
    int Year = 0;

    CustomFacade objCustomFacade = new CustomFacade();
    List<UserReport> objlstUserReport = new List<UserReport>();
    List<Project> objlstProject = new List<Project>();
    SessionParameter objSessionParameter = new SessionParameter();

    void Page_Load(object sender, EventArgs e) {

        if (Session["SelectedProjectIds"].ToString() != "" && Session["SelectedProjectIds"] != null)
        {
            ProjectIds = Convert.ToInt32(Session["SelectedProjectIds"]);
        }
        if (Session["SelectedMonthValue"] != "" && Session["SelectedMonthValue"] != null)
        {
            Month = Convert.ToInt32(Session["SelectedMonthValue"]);
        }
        if (Session["SelectedYear"] != "" && Session["SelectedYear"] != null)
        {
            Year = Convert.ToInt32(Session["SelectedYear"]);
        }

        if (!IsPostBack)
        {
            BindDeatils(ProjectIds, Month, Year);
           // BindUserWise(ProjectIds, Month, Year);
        }        
    }

    private void BindDeatils(int SelectedProjectIds, int SelectedMonth, int SelectedYear)
    {
        try
        {
            objlstProject = objCustomFacade.GetClientReportByIdAndMonthAndYear(SelectedProjectIds, SelectedMonth, SelectedYear);
            if (objlstProject.Count>0)
            {
                ProjectList.DataSource = objlstProject;
                ProjectList.DataBind();
            }
        }
        catch (Exception)
        {
        }
    }

    protected void EntryListDataBinding(object sender, EventArgs args) {
        DataList temp = (DataList)sender;
        if (temp.Items.Count <= 0) {
            temp.ShowHeader = false;
            temp.ShowFooter = false;
        }
        else {
            temp.ShowHeader = true;
            temp.ShowFooter = true;
        }
    }

    protected void OnProjectListItemCreated(object sender, DataListItemEventArgs e) {
        try
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                ObjectDataSource ds = e.Item.FindControl("UserReportData") as ObjectDataSource;
                if (ds != null && (DataBinder.Eval(e.Item.DataItem, "Id") != null))
                {
                    ds.SelectParameters["ProjectIds"].DefaultValue = DataBinder.Eval(e.Item.DataItem, "Id").ToString();
                }
            }
        }
        catch (Exception ex)
        {  
        }
    }

    public void Page_Error(object sender, EventArgs e)
    {
        Exception objErr = Server.GetLastError().GetBaseException();
        Server.ClearError();
        Response.Redirect("../TimeTracker/CustomErrorPage.aspx");
    }
}
