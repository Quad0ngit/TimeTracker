using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections.Generic;
using ASPNET.StarterKit.BusinessLogicLayer;
using System.Text;

public partial class Project_List_aspx : System.Web.UI.Page
{
    public Project_List_aspx()
    {
    }
    void Page_Load(object sender, EventArgs e)
    {
        String hiddenFieldValue = hidLastTab.Value;
        StringBuilder js = new StringBuilder();
        js.Append("<script type='text/javascript'>");
        js.Append("var previouslySelectedTab = ");
        js.Append(hiddenFieldValue);
        js.Append(";</script>");
        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "acttab", js.ToString());
        //this.Header.Controls.Add(new LiteralControl(js.ToString()));

        if (Page.User.IsInRole("ProjectAdministrator"))
        {
            ProjectData.SortParameterName = "sortParameter";
            ProjectData.SelectMethod = "GetAllOpenProjects";

            ClosedProjectData.SortParameterName = "sortParameter";
            ClosedProjectData.SelectMethod = "GetAllClosedProjects";
        }
        else
        {

            bool wasFound = false;
            bool wasFound1 = false;
            foreach (Parameter parameter in ProjectData.SelectParameters)
            {
                if (parameter.Name == "userName")
                    wasFound = true;
            }
            foreach (Parameter parameter in ClosedProjectData.SelectParameters)
            {
                if (parameter.Name == "userName")
                    wasFound1 = true;
            }
            if (!wasFound)
            {
                Parameter param = new Parameter("userName", TypeCode.String, Page.User.Identity.Name);
                ProjectData.SelectParameters.Add(param);
            }
            if (!wasFound1)
            {
                Parameter param1 = new Parameter("userName", TypeCode.String, Page.User.Identity.Name);
                ClosedProjectData.SelectParameters.Add(param1);
            }
            ProjectData.SortParameterName = "sortParameter";
            ProjectData.SelectMethod = "GetOpenProjectsByManagerUserName";
            ClosedProjectData.SortParameterName = "sortParameter";
            ClosedProjectData.SelectMethod = "GetCloseProjectsByManagerUserName";
        }
    }
    protected void Button_Click(Object sender, EventArgs args)
    {
        Response.Redirect("Project_Details.aspx");
    }
    protected void ListAllProjects_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {

        //e.Keys.Add("Id", ListAllProjects.Rows[e.RowIndex].Cells[0].Text);
    }

    protected void ListAllClosedProjects_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {

        //e.Keys.Add("Id", ListAllProjects.Rows[e.RowIndex].Cells[0].Text);
    }

    protected void ListAllProjects_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            foreach (DataControlFieldCell cell in e.Row.Cells)
            {
                foreach (Control control in cell.Controls)
                {
                    ImageButton button = control as ImageButton;

                    if (button != null && button.CommandName == "Delete")
                        button.OnClientClick = "if(!confirm('Deleting a project will also delete all the time entries and categories associated with the project. This deletion cannot be undone. Are you sure you want to delete this project?')){ return false; };";
                }
            }
        }
    }

    protected void ListAllClosedProjects_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            foreach (DataControlFieldCell cell in e.Row.Cells)
            {
                foreach (Control control in cell.Controls)
                {
                    ImageButton button = control as ImageButton;
                    if (button != null && button.CommandName == "Delete")
                        button.OnClientClick = "if(!confirm('Deleting a project will also delete all the time entries and categories associated with the project. This deletion cannot be undone. Are you sure you want to delete this project?')){ return false; };";
                }
            }
        }
    }


    public void Page_Error(object sender, EventArgs e)
    {
        Exception objErr = Server.GetLastError().GetBaseException();
        Server.ClearError();
        Response.Redirect("../TimeTracker/CustomErrorPage.aspx");
    }
    public void EditProject_click(object sender, EventArgs e)
    {
       
        GridViewRow gvr = (GridViewRow)((ImageButton)sender).Parent.Parent;
        string id = ((HiddenField)gvr.FindControl("id")).Value;
        Response.Redirect("Project_Details.aspx?ProjectId=" + id);
    }

}
