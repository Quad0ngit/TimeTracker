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
using ASPNET.StarterKit.DataAccessLayer;
using System.Text;

public partial class TimeTracker_ClientWiseReport : System.Web.UI.Page
{
    CustomFacade ObjCustomFacade = new CustomFacade();
    List<Project> objlstProject = new List<Project>();
    void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            MonthList.SelectedValue = Convert.ToString(DateTime.Now.Month);
            YearList.SelectedValue = Convert.ToString(DateTime.Now.Year);          
            DateTime startingDate = DateTime.Now;
            DateTime endDate = DateTime.Now;
            StartDate.Text = DateTime.Now.Date.AddDays(-7).ToShortDateString();
            txtDate.Text = DateTime.Now.Date.ToShortDateString();
            BindProjects();            
        }
    }

    private void BindProjects()
    {
        objlstProject = ObjCustomFacade.GetClientDeatils();
        if (objlstProject.Count > 0)
        {
            lstPojects.DataSource = objlstProject;
            lstPojects.DataTextField = "Name";
            lstPojects.DataValueField = "Id";
            lstPojects.DataBind();
            lstPojects.Visible = true;
        }
        else
        {
            lstPojects.Visible = false;
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

    protected void GenCategoryRpt_Click(object sender, System.EventArgs e)
    {
        Page.Validate();
        if (Page.IsValid == false)
            return;
        if (Convert.ToDateTime(StartDate.Text) > Convert.ToDateTime(txtDate.Text))
        {
            dateCompare.Text = "From Date should be less than End Date.";
            return;
        }
        //Session.Add("SelectedCategories", BuildValueList(CategoryList.Items, true));
        Session.Add("SelectedStartingDate", StartDate.Text);
        Session.Add("SelectedEndDate", txtDate.Text);
        Session.Add("SelectedProjectIds",lstPojects.SelectedValue);
        Server.Transfer("Report_Client_Result.aspx");
    }

    protected void GenProjectRptByMonth_Click(object sender, System.EventArgs e)
    {

        RequiredFieldValidator3.Validate();
        Page.Validate();
        if (Page.IsValid == false)
            return;

        if (RequiredFieldValidator3.IsValid)
        {
            Session.Add("SelectedProjectIds",lstPojects.SelectedValue);
            Session.Add("SelectedMonth", MonthList.SelectedItem.Text);
            Session.Add("SelectedMonthValue", MonthList.SelectedValue);
            Session.Add("SelectedYear", YearList.SelectedValue);

            Server.Transfer("Report_Client_ResultByMonth.aspx");
            //Response.Redirect("Report_Project_Result.aspx");
        }
    }

    public void Page_Error(object sender, EventArgs e)
    {
        Exception objErr = Server.GetLastError().GetBaseException();
        Server.ClearError();
        //Response.Redirect("../TimeTracker/CustomErrorPage.aspx");
    }

  
}
