using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Report_Project_ResultByMonth_aspx : System.Web.UI.Page
{
    public Report_Project_ResultByMonth_aspx()
    {
    }

    void Page_Load(object sender, EventArgs e) {

        //ProjectList.DataBind();
        
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
