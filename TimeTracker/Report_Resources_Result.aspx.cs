using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using System.Collections.Generic;
using ASPNET.StarterKit.BusinessLogicLayer;
using System.IO;

public partial class Report_Resources_Result_aspx : System.Web.UI.Page
{
    public Report_Resources_Result_aspx()
    {
    }

    void Page_Load(object sender, EventArgs e)
    {
        
    }

    protected void OnListUserTimeEntriesItemCreated(object sender, DataListItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            ObjectDataSource ds = e.Item.FindControl("TimeEntryData") as ObjectDataSource;
            if (ds != null && (DataBinder.Eval(e.Item.DataItem, "UserName") != null))  {
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
    protected void lnkexportResources_Click(object sender, EventArgs e)
    {
        StringWriter sw = new StringWriter();
         HtmlTextWriter htw = new HtmlTextWriter(sw);


        foreach (DataListItem li in UserList.Items)
        {
            GridView grd = (GridView)li.FindControl("ListUserTimeEntries");
            ObjectDataSource ds = li.FindControl("TimeEntryData") as ObjectDataSource;
            grd.DataSource = ds;
           


            Label userlabel = (Label)li.FindControl("UserNameLabel");

            Label DurationLabel = (Label)li.FindControl("TotalDurationLabel");
            sw.Write("--------------------------------------------------------");
            sw.WriteLine("\n");
            sw.WriteLine("\n");
            sw.NewLine = ("\n");
            sw.NewLine = ("\n");


            sw.Write("<table class='timeentry-edit' cellspacing='0' cellpadding='2' rules='all' border='0' style='border-width:0px;border-style:None;width:100%;border-collapse:collapse;'><tr class='grid-header' align='left'><th scope='col'>UserName</th><th scope='col'>Total Duration Worked</th>	</tr><tr class='row1' style='border-style:None;'><td style='background-Color:#FFFFFF;'>" + userlabel.Text + "</td><td style='background-Color:#FFFFFF;'>" + DurationLabel.Text + "</td></tr></table>");
           
           
             if (grd.Rows.Count >= 1)
            {
                    Response.ClearContent();
                    Response.Buffer = true;
                    Response.AddHeader("content-disposition", string.Format("attachment; filename={0}", "ResourcesTimeSheet.xls"));
                    Response.ContentType = "application/ms-excel";
                                       

                    grd.AllowPaging = false;
                    grd.RenderBeginTag(htw);
                   
                
                    int j = 1;

                    //This loop is used to apply stlye to cells based on particular row

                    foreach (GridViewRow gvrow in grd.Rows)
                    {
                        for (int k = 0; k < gvrow.Cells.Count; k++)
                        {
                            gvrow.Cells[k].Style.Add("background-Color", "#FFFFFF");
                        }
                    }
                    //grd.RenderControl(htw);

                    //style to format numbers to string
                    string style = @"<style> .textmode { mso-number-format:\@; } </style>";

                    grd.FooterRow.RenderControl(htw);
                    grd.RenderEndTag(htw);
                    grd.HeaderRow.Style.Add("background-color", "#FFFFFF");
                    grd.RenderControl(htw);
                   
                }
          
            else
            {
                grd.DataSource = null;
            }
            
        }
        sw.NewLine = ("\n");
        sw.NewLine = ("\n");
        sw.Close();
        Response.Write(sw.ToString());
        Response.End();

    }

    public override void VerifyRenderingInServerForm(Control control)
    {
        // Confirms that an HtmlForm control is rendered for the   
        foreach (DataListItem li in UserList.Items)
        {
            GridView grd = (GridView)li.FindControl("ListUserTimeEntries");
            ObjectDataSource ds = li.FindControl("TimeEntryData") as ObjectDataSource;
            //grd.DataSource = ds;
            //ImageButton imgd = (ImageButton)li.FindControl("lnkexportResources");
            //Label lbld = (Label)li.FindControl("lblexportres");
            if (grd!=null)
            {
                if (grd.Rows.Count >= 1)
                {
                    lblexportres.Visible = true;
                    lblexportres.Attributes["Style"] = "display:inline-block;";
                    lnkexportResources.Attributes["Style"] = "display:inline-block;";

                }
            }
            
            //else
            //{
            //    lnkexportResources.Attributes["Style"] = "display:none;";
            //    lnkexportResources.Attributes["Style"] = "display:none;";
            //}
        }

        foreach (DataListItem li in UserList.Items)
        {
            GridView grd = (GridView)li.FindControl("UserReportDataByDate");
            ObjectDataSource ds = li.FindControl("UserReportWithDate") as ObjectDataSource;
            //grd.DataSource = ds;
            //ImageButton imgd = (ImageButton)li.FindControl("lnkexportResources");
            //Label lbld = (Label)li.FindControl("lblexportres");

            //if (grd.Rows.Count >= 1)
            //{
            //    imgd.Attributes["Style"] = "display:inline-block;";
            //    lbld.Attributes["Style"] = "display:inline-block;";

            //}
            //else
            //{
            //    imgd.Attributes["Style"] = "display:none;";
            //    lbld.Attributes["Style"] = "display:none;";
            //}
        }
       
       
    }

    protected void UserReportDataByDate_RowDataBound(object sender, GridViewRowEventArgs e)
    {


        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            foreach (DataControlFieldCell cell in e.Row.Cells)
            {
              

            }
           

        }
        //reportdate.Text = e.Row.Cells[1].ToString();
    }

    protected void ListUserTimeEntries_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {

        //GridView grd = (sender as GridView);
        //DataListItem DLItem = (DataListItem)grd.NamingContainer;
        //grd.PageIndex = e.NewPageIndex;
        //grd.DataBind();

        
    }

    
}