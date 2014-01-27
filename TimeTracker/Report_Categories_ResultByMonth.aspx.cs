using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Report_Categories_ResultByMonth_aspx : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void EntryListDataBinding(object sender, EventArgs args)
    {
        DataList temp = (DataList)sender;
        if (temp.Items.Count <= 0)
        {
            temp.ShowHeader = false;
            temp.ShowFooter = true;
        }
        else
        {
            temp.ShowHeader = true;
            temp.ShowFooter = false;
        }
    }
    protected void OnCategoryListItemCreated(object sender, DataListItemEventArgs e)
    {
        try
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                ObjectDataSource ds = e.Item.FindControl("CategoryReportData") as ObjectDataSource;
                if (ds != null && (DataBinder.Eval(e.Item.DataItem, "Id") != null))
                {
                    ds.SelectParameters["CategoryIds"].DefaultValue = DataBinder.Eval(e.Item.DataItem, "Id").ToString();
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

    protected void ShowFooter_OnPreRender(object sender, EventArgs e)
    {
        DataList objTempDL = (DataList)sender;
        if (objTempDL.Items.Count == 0)
        {
            objTempDL.ShowFooter = true;
        }
    }
}
