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
using ASPNET.StarterKit.DataAccessLayer;
using System.Text;
using System.Collections.Generic;

public partial class Report_categories_aspx : System.Web.UI.Page
{
    CustomFacade ObjCustomFacade = new CustomFacade();
    List<Project> objlstProject = new List<Project>();
    void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            MonthList.SelectedValue = Convert.ToString(DateTime.Now.Month);
            YearList.SelectedValue = Convert.ToString(DateTime.Now.Year);
            if (Page.User.IsInRole("ProjectAdministrator") || Page.User.IsInRole("ProjectManager"))
            {

                SQLDataAccess objSQLDataAccess = new SQLDataAccess();
                List<Category> objCategorylist = objSQLDataAccess.GetCategoriesByUserName(Convert.ToString(""));
                CategoryList.DataSource = objCategorylist;
                CategoryList.DataTextField = "Name";
                CategoryList.DataValueField = "Id";
                CategoryList.DataBind();
               
            }
            DateTime startingDate = DateTime.Now;
            DateTime endDate = DateTime.Now;
            StartDate.Text = DateTime.Now.Date.AddDays(-7).ToShortDateString();
            txtDate.Text = DateTime.Now.Date.ToShortDateString();
            BindProjects();
        }
    }

    private void BindProjects()
    {
        objlstProject = ObjCustomFacade.GetProjectDetails();
        if (objlstProject.Count > 0)
        {
            lstPojects.DataSource = objlstProject;
            lstPojects.DataTextField = "Name";
            lstPojects.DataValueField = "Id";
            lstPojects.DataBind();
            lstPojects.Visible = true;
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
        CategoryListRequiredFieldValidator.Validate();
        Page.Validate();
        if (Page.IsValid == false)
            return;
        if (Convert.ToDateTime(StartDate.Text) > Convert.ToDateTime(txtDate.Text))
        {
            dateCompare.Text = "From Date should be less than To Date.";
            return;
        }
        if (CategoryListRequiredFieldValidator.IsValid)
        {
            Session.Add("SelectedCategories", BuildValueList(CategoryList.Items, true));
            Session.Add("SelectedStartingDate", StartDate.Text);
            Session.Add("SelectedEndDate", txtDate.Text);
            Session.Add("SelectedProjectIds", BuildValueList(lstPojects.Items, true));
            Server.Transfer("Report_Categories_Result.aspx");

            //Response.Redirect("Report_Categories_Result.aspx");
        }
    }

    protected void GenProjectRptByMonth_Click(object sender, System.EventArgs e)
    {
        CategoryListRequiredFieldValidator.Validate();
        Page.Validate();
        if (Page.IsValid == false)
            return;

        if (CategoryListRequiredFieldValidator.IsValid)
        {
            Session.Add("SelectedCategories", BuildValueList(CategoryList.Items, true));
            Session.Add("SelectedMonth", MonthList.SelectedItem.ToString());
            Session.Add("SelectedMonthValue", MonthList.SelectedValue);
            Session.Add("SelectedYear", YearList.SelectedValue);
            Session.Add("SelectedProjectIds", BuildValueList(lstPojects.Items, true));
            Server.Transfer("Report_Categories_ResultByMonth.aspx");
            //Response.Redirect("Report_Project_Result.aspx");
        }
    }

    public void Page_Error(object sender, EventArgs e)
    {
        Exception objErr = Server.GetLastError().GetBaseException();
        Server.ClearError();
        Response.Redirect("../TimeTracker/CustomErrorPage.aspx");
    }

    protected void CategoryList_SelectedIndexChanged(object sender, EventArgs e)
    {
        objlstProject = ObjCustomFacade.GetProjectDetailsByCategoryDetails(Convert.ToString(CategoryList.SelectedValue));
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
}
