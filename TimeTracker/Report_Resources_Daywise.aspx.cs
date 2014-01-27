using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class Report_Resources_Daywise_aspx : System.Web.UI.Page
{
    public Report_Resources_Daywise_aspx ()
    {
    }

    void Page_Load(object sender, EventArgs e)
    {
        divProjectResource.Visible = false;
        
        if (!Page.IsPostBack)
        {
            MonthList.SelectedValue = Convert.ToString(DateTime.Now.Month);
            YearList.SelectedValue = Convert.ToString(DateTime.Now.Year);
            if (Page.User.IsInRole("ProjectAdministrator"))
            {
                ProjectData.SelectMethod = "GetAllProjects";
            }
            else
            {
                ProjectData.SelectParameters.Add(new Parameter("userName", TypeCode.String, Page.User.Identity.Name));
                ProjectData.SelectParameters.Add(new Parameter("sortParameter", TypeCode.String, string.Empty));
                ProjectData.SelectMethod = "GetProjectsByManagerUserName";
            }
            ProjectList.DataBind();
          
            UserData.SelectParameters.Add(new Parameter("userNames", TypeCode.String, BuildValueList(ProjectList.Items, false)));
            UserData.SelectMethod = "GetProjectMembers";

            DateTime startingDate = DateTime.Now;
            DateTime endDate = DateTime.Now;
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

    protected void GenResourceRpt_Click(object sender, System.EventArgs e)
    {
        UserListRequiredFieldValidator.Validate();
        Page.Validate();
        if (Page.IsValid == false)
            return;
        if (Convert.ToDateTime(StartDate.Text) > Convert.ToDateTime(txtDate.Text))
        {
            dateCompare.Text = "From Date should be less than To Date.";
            return;
        }

        if (UserListRequiredFieldValidator.IsValid)
        {
            Session.Add("SelectedUserNames", BuildValueList(UserList.Items, true));
            Session.Add("SelectedStartingDate", StartDate.Text);
            Session.Add("SelectedEndDate", txtDate.Text);
            Session.Add("SelectedProjectId", 0);
            Server.Transfer("Report_Resources_Daywise_Result.aspx");
            //Response.Redirect("Report_Resources_Result.aspx");
        }
    }


    protected void GenProjectRptByMonth_Click(object sender, System.EventArgs e)
    {
        UserListRequiredFieldValidator.Validate();
        Page.Validate();
        if (Page.IsValid == false)
            return;

        if (UserListRequiredFieldValidator.IsValid)
        {
            Session.Add("SelectedUserNames", BuildValueList(UserList.Items, true));
            Session.Add("SelectedMonth", MonthList.SelectedItem.ToString());
            Session.Add("SelectedMonthValue", MonthList.SelectedValue);
            Session.Add("SelectedYear", YearList.SelectedValue);
            Session.Add("SelectedProjectId", 0);
            Server.Transfer("Report_Resources_Daywise_ResultByMonth.aspx");
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
