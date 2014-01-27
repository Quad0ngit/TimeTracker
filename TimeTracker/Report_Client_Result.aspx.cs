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
using System.Text;
using ASPNET.StarterKit.BusinessLogicLayer;
using System.Collections.Generic;

public partial class TimeTracker_Report_Client_Result : System.Web.UI.Page
{
    int SelectedProjectIds = 0;
    DateTime SelectedStartingDate;
    DateTime SelectedEndDate;
    CustomFacade objCustomFacade = new CustomFacade();
    List<Project> objlstProject = new List<Project>();

    void Page_Load(object sender, EventArgs e)
    {


        if (Session["SelectedProjectIds"].ToString() != "" && Session["SelectedProjectIds"] != null)
        {
            SelectedProjectIds = Convert.ToInt32(Session["SelectedProjectIds"]);
        }
        if (Session["SelectedStartingDate"] != "" && Session["SelectedStartingDate"] != null)
        {
            SelectedStartingDate = Convert.ToDateTime(Session["SelectedStartingDate"]);
        }
        if (Session["SelectedEndDate"] != "" && Session["SelectedEndDate"] != null)
        {
            SelectedEndDate = Convert.ToDateTime(Session["SelectedEndDate"]);
        }

        if (!IsPostBack)
        {
            BindDeatils(SelectedProjectIds, SelectedStartingDate, SelectedEndDate);
            // BindUserWise(ProjectIds, Month, Year);
        }    
    }

    protected void EntryListDataBinding(object sender, EventArgs args)
    {
        DataList temp = (DataList)sender;
        if (temp.Items.Count <= 0)
        {
            temp.ShowHeader = false;
            temp.ShowFooter = false;
        }
        else
        {
            temp.ShowHeader = true;
            temp.ShowFooter = true;
        }
    }

    private void BindDeatils(int SelectedProjectIds, DateTime StartingDate, DateTime EndDate)
    {
        try
        {
            objlstProject = objCustomFacade.GetProjectByIdsAndDates(SelectedProjectIds, StartingDate, EndDate);
            if (objlstProject.Count > 0)
            {
                ProjectList.DataSource = objlstProject;
                ProjectList.DataBind();
            }
        }
        catch (Exception)
        {
        }
    }

    protected void OnProjectListItemCreated(object sender, DataListItemEventArgs e)
    {
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
