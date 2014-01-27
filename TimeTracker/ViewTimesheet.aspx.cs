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
using System.Collections.Generic;
using ASPNET.StarterKit.BusinessLogicLayer;

public partial class TimeTracker_ViewTimesheet : System.Web.UI.Page
{
    CustomFacade objCustomFacade = new CustomFacade();
    List<Project> objlstProject = new List<Project>();
    List<TimeEntry> objlstTimeEntry = new List<TimeEntry>();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindTeamUser();
        }

    }

    private void BindTeamUser()
    {
        try
        {
          objlstProject= objCustomFacade.getTeamUserByTeamleader(Page.User.Identity.Name);
          if (objlstProject.Count>0)
          {
              ddlUserList.DataSource = objlstProject;
              ddlUserList.DataValueField = "UserId";
              ddlUserList.DataTextField = "Name";
              ddlUserList.DataBind();
          }
          ddlUserList.Items.Insert(0, new ListItem("Select", "0"));
          ddlUserList.SelectedValue = "0";
        }
        catch (Exception)
        {
        }
    }

    protected void ddlUserList_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            if (ddlUserList.SelectedValue != "0")
            {
                objlstProject = objCustomFacade.GetProjectDetailsByUserDetails(Convert.ToString(ddlUserList.SelectedItem.Text));
                if (objlstProject.Count > 0)
                {
                    AllProjectList.DataSource = objlstProject;
                    AllProjectList.DataTextField = "Name";
                    AllProjectList.DataValueField = "Id";
                    AllProjectList.DataBind();
                }
                AllProjectList.Items.Insert(0, new ListItem("Select", "0"));
                AllProjectList.SelectedValue = "0";
            }
        }
        catch (Exception)
        {
        }
    }
    protected void TimeSheet_Click(object sender, EventArgs e)
    {
        try
        {
            Requiredfieldvalidator4.Validate();
            Requiredfieldvalidator5.Validate();
            if (Page.IsValid == false)
                return;
            else
            {
               objlstTimeEntry=objCustomFacade.GetTimeEntriesByUserNameProjectIdAndDates(Convert.ToString(ddlUserList.SelectedItem.Text.Trim()), Convert.ToString(AllProjectList.SelectedValue), Convert.ToDateTime(StartDate.Text), Convert.ToDateTime(EndDate.Text));
               if (objlstTimeEntry.Count > 0)
               {
                   ProjectListGridView.DataSource = objlstTimeEntry;
                   ProjectListGridView.DataBind();
                   ProjectListGridView.Visible = true;
                   lblMsg.Visible = false;
               }
               else
               {
                   lblMsg.Visible = true;
                   ProjectListGridView.Visible = false;
                   totalhours.Text = "0";
               }
            }
        
        }
        catch (Exception)
        {
           
        }
    }
    protected void EndDate_TextChanged(object sender, EventArgs e)
    {
        if (Convert.ToDateTime(StartDate.Text) > Convert.ToDateTime(EndDate.Text))
            dateCompare.Visible = true;
        dateCompare.Text = "Start Date should be less than End Date.";

    }
    protected void ProjectListGridView_SelectedIndexChanged(object sender, EventArgs e)
    {


    }

    protected void ProjectListGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            foreach (DataControlFieldCell cell in e.Row.Cells)
            {
                foreach (Control control in cell.Controls)
                {
                    ImageButton button = control as ImageButton;
                    if (button != null && button.CommandName == "Delete")
                        button.OnClientClick = "if(!confirm('Are you sure you want to delete this record ?')){ return false; };";
                }
            }
        }
        else if (e.Row.RowType == DataControlRowType.Footer)
        { 
        }
        totalhours.Text = TimeEntry.totalhours.ToString();
    }
}
