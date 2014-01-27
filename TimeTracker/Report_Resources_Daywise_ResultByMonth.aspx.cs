using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Report_Resources_Daywise_ResultByMonth_aspx : System.Web.UI.Page
{
    public Report_Resources_Daywise_ResultByMonth_aspx()
    {
    }

    void Page_Load(object sender, EventArgs e)
    {

    }

    protected void OnListUserTimeEntriesItemCreated(object sender, DataListItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            ObjectDataSource ds = e.Item.FindControl("UserReportWithDate") as ObjectDataSource;
            if (ds != null && (DataBinder.Eval(e.Item.DataItem, "UserName") != null))
            {
                ds.SelectParameters["userName"].DefaultValue = DataBinder.Eval(e.Item.DataItem, "UserName").ToString();
            }

        }
    }

    public void Page_Error(object sender, EventArgs e)
    {
        Exception objErr = Server.GetLastError().GetBaseException();
        Server.ClearError();
        Response.Redirect("../TimeTracker/CustomErrorPage.aspx");
    }


    public override void VerifyRenderingInServerForm(Control control)
    {
        if (!IsPostBack)
        {
            foreach (DataListItem li in UserList.Items)
            {
                GridView grd = (GridView)li.FindControl("UserReportDataByDate");
                ObjectDataSource ds = li.FindControl("UserReportWithDate") as ObjectDataSource;
                grd.DataSource = ds;
                grd.DataBind();
            }
            
       }
    }


       
    protected void UserReportDataByDate_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView grd = (sender as GridView);
        grd.PageIndex = e.NewPageIndex;
        
    }
}
