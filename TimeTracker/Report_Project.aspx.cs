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

public partial class Report_Project_aspx : System.Web.UI.Page

{
    public Report_Project_aspx ()
    {
    }

    void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            MonthList.SelectedValue = Convert.ToString(DateTime.Now.Month);
            YearList.SelectedValue = Convert.ToString(DateTime.Now.Year);
            if (Page.User.IsInRole("ProjectAdministrator"))
            {
                ProjectData.SelectMethod = "GetAllProjectsReport";
            }
            else
            {
                ProjectData.SelectParameters.Add(new Parameter("userName", TypeCode.String, Page.User.Identity.Name));
                ProjectData.SelectParameters.Add(new Parameter("sortParameter", TypeCode.String, string.Empty));
                ProjectData.SelectMethod = "GetProjectsByManagerUserName";
            }
            ProjectList.DataBind();
            StartDate.Text = DateTime.Now.Date.AddDays(-7).ToShortDateString();
            txtDate.Text = DateTime.Now.Date.ToShortDateString(); 
        }
       
    }

    protected string BuildValueList(ListItemCollection items, bool itemMustBeSelected)
    {
        StringBuilder idList = new StringBuilder();
        foreach (ListItem item in items)
        {
            if (itemMustBeSelected && !item.Selected)
                continue;

            else
            {
                idList.Append(item.Value.ToString());
                idList.Append(",");
            }
        }
        return idList.ToString();
    }

    protected void GenProjectRpt_Click(object sender, System.EventArgs e)
    {
        ProjectListRequiredFieldValidator.Validate();
        Page.Validate();
        if (Page.IsValid == false)
            return;
        if (Convert.ToDateTime(StartDate.Text) > Convert.ToDateTime(txtDate.Text))
        {
            dateCompare.Text = "From Date should be less than To Date.";
            return;
        }
        if (ProjectListRequiredFieldValidator.IsValid)
        {
            Session.Add("SelectedProjectIds", BuildValueList(ProjectList.Items, true));
            Session.Add("SelectedStartingDate", StartDate.Text);
            Session.Add("SelectedEndDate", txtDate.Text);
            Server.Transfer("Report_Project_Result.aspx");
            //Response.Redirect("Report_Project_Result.aspx");
        }
    }

    protected void GenProjectRptByMonth_Click(object sender, System.EventArgs e)
    {
        ProjectListRequiredFieldValidator.Validate();
        Page.Validate();
        if (Page.IsValid == false)
            return;
        
        if (ProjectListRequiredFieldValidator.IsValid)
        {
            Session.Add("SelectedProjectIds", BuildValueList(ProjectList.Items, true));
            Session.Add("SelectedMonth", MonthList.SelectedItem.Text);
            Session.Add("SelectedMonthValue", MonthList.SelectedValue);
            Session.Add("SelectedYear", YearList.SelectedValue);
            Server.Transfer("Report_Project_ResultByMonth.aspx");
            //Response.Redirect("Report_Project_Result.aspx");
        }
    }

    public void Page_Error(object sender, EventArgs e)
    {
        Exception objErr = Server.GetLastError().GetBaseException();
        Server.ClearError();
        Response.Redirect("../TimeTracker/CustomErrorPage.aspx");
    }
}
