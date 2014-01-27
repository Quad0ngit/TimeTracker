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
using System.Collections;

public partial class Project_Details_aspx : System.Web.UI.Page
{
    public Project_Details_aspx()
    {
        LoadComplete += new EventHandler(Page_LoadComplete);
    }

    private Project CurrentProject = null;

    

    void GetCurrentProject()
    {
        int projectIdFromQueryString;
        if (Request.QueryString["ProjectId"] != null && Int32.TryParse((string)Request.QueryString["ProjectId"], out projectIdFromQueryString)) {
            CurrentProject = Project.GetProjectById(projectIdFromQueryString);
        }
    }
    ArrayList arraylist1 = new ArrayList();
    ArrayList arraylist2 = new ArrayList();

    void Page_Load(object sender, EventArgs e) {
        successful.Text = "";
        GetCurrentProject();
        if (!Page.IsPostBack)
        {
            ManagerData.SelectMethod = "GetUsersInRole";
           
            BindClientDeatails();
            if (Request.QueryString["succ"] != null)
            {
                if (Convert.ToString(Request.QueryString["succ"])== "true")
                {
                    successful.Text = "Project saved successfully";
                    Error.Text = "";
                }
            }
             
            if (Request.QueryString["error"] != null)
            {
                if (Convert.ToString(Request.QueryString["succ"]) == "false")
                {
                    successful.Text = "";
                    Error.Text = "Project name already exists.";
                }
            }

            ManagerData.SelectParameters.Add(new Parameter("roleName", TypeCode.String, "ProjectManager"));
            ProjectConsultantData.SelectParameters.Add(new Parameter("roleName", TypeCode.String, "Consultant"));
            
            if (CurrentProject != null)
            {
                ddlClientName.SelectedValue = CurrentProject.ClientName;
                ProjectName.Text = CurrentProject.Name;
                DateTime dt = Convert.ToDateTime(CurrentProject.CompletionDate);
                EstimatedDate.Text = dt.ToString("d");
                ddlClientName.SelectedValue = Convert.ToString(CurrentProject.ClientName);
                txtDevHours.Text = Convert.ToString(CurrentProject.DevelopmentEstimateDuration);
                txtTestingHrs.Text = Convert.ToString(CurrentProject.TestingEstimateDuration);
                txtDesignHrs.Text = Convert.ToString(CurrentProject.DesignEstimateDuration);
                txtBAHrs.Text = Convert.ToString(CurrentProject.BAEstimateDuration);
                txtProjectHrs.Text = Convert.ToString(CurrentProject.ProjectManagementEstimateDuration);
                txtOtherDuration.Text = Convert.ToString(CurrentProject.OtherDuration);
                Duration.Text = Convert.ToString(CurrentProject.EstimateDuration);
                Description.Text = CurrentProject.Description;
                Managers.SelectedValue = CurrentProject.ManagerUserName;
                if (CurrentProject.IsCompleted== true)
                {
                    chkIsCompleted.Checked = true;
                }
                Consultants.DataBind();               
            }            
        }
        DeleteButton2.Attributes.Add("onclick", "return confirm('Deleting a project will also delete all the time entries and categories associated with the project. This deletion cannot be undone. Are you sure you want to delete this project?')");
    }

    private void BindClientDeatails()
    {
        try
        {
            List<Project> lstProjectDetails = new List<Project>();
            CustomFacade objCustomFacade = new CustomFacade();
            lstProjectDetails = objCustomFacade.GetClientDeatils();
            if (lstProjectDetails.Count > 0)
            {
                ddlClientName.DataSource = lstProjectDetails;
                ddlClientName.DataTextField = "Name";
                ddlClientName.DataValueField = "Id";
                ddlClientName.DataBind();
            }
            ddlClientName.Items.Insert(0, new ListItem("Select", "0"));
            ddlClientName.SelectedValue = "0";
        }
        catch (Exception)
        { 
        }
    }

    void Page_LoadComplete(object sender, EventArgs e)
    {
        try
        {
            if (CurrentProject != null && !Page.IsPostBack)
            {
                SelectProjectMembers(CurrentProject.Id);
            }
        }
        catch(Exception ex){}

    }

    //void Page_PreRender(object sender, EventArgs e)
    //{
    //    ViewState["ActiveConsultants"] = BuildValueList(Consultants.Items, true);
    //}

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

    protected void CancelButton_Click(object obj, EventArgs args)
    {
        Response.Redirect("Project_List.aspx");
    }
  
    protected void DeleteButton_Click(object obj, EventArgs args)
    {
        if (CurrentProject != null)
        {
            Project newProject = Project.GetProjectById(CurrentProject.Id);
            newProject.Delete();
            Response.Redirect("Project_List.aspx");
        }
    }
  
    protected void SaveButton_Click(object obj, EventArgs args)
    {
        if (Page.IsValid == false)
            return;
        Project newProject;
          if (CurrentProject != null)
            {
                newProject = Project.GetProjectById(CurrentProject.Id);

            }
            else
            {
                newProject = new Project(Page.User.Identity.Name, Page.User.Identity.Name, ProjectName.Text);
            }
          try
          {
              CustomFacade objCustomFacade = new CustomFacade();
              
                  newProject.ClientName = Convert.ToString(ddlClientName.SelectedValue);
                  newProject.Name = ProjectName.Text;
                  newProject.CompletionDate = Convert.ToDateTime(EstimatedDate.Text);
                  newProject.Description = Description.Text;
                  newProject.DevelopmentEstimateDuration = Convert.ToDecimal(txtDevHours.Text);
                  newProject.TestingEstimateDuration = Convert.ToDecimal(txtTestingHrs.Text);
                  newProject.DesignEstimateDuration = Convert.ToDecimal(txtDesignHrs.Text);
                  newProject.BAEstimateDuration = Convert.ToDecimal(txtBAHrs.Text);
                  newProject.ProjectManagementEstimateDuration = Convert.ToDecimal(txtProjectHrs.Text);
                  newProject.OtherDuration = Convert.ToDecimal(txtOtherDuration.Text);
                  //Duration.Enabled = true;
                  //if (Duration.Text.Trim() != "")
                  //{
                  //    newProject.EstimateDuration = Convert.ToDecimal(Duration.Text);
                  //}
                  //else
                  //{
                  newProject.EstimateDuration = Convert.ToDecimal(hdnDuration.Value);
                  //}

                  //Duration.Enabled = false;
                  newProject.ManagerUserName = Managers.SelectedItem.Value;
                  if (chkIsCompleted.Checked == true)
                  {
                      newProject.IsCompleted = true;
                  }
                  else
                  {
                      newProject.IsCompleted = false;
                  }
                  if (CurrentProject != null)
                  {
                      if (!objCustomFacade.IsProjectExists(ProjectName.Text.Trim(), CurrentProject.Id))
                      {
                          if (!newProject.Save())
                          {
                              // ErrorMessage.Text = "There was an error.  Please fix it and try it again.";

                          }
                          UpdateProjectMembers(newProject.Id);

                          string strUrl = "Project_Details.aspx?ProjectId=" + newProject.Id.ToString() + "&succ=true";
                          Response.Redirect(strUrl);
                      }
                      else
                      {
                          Error.Visible = true;
                          Error.Text = "Already the project name is exists.";
                      }
                  }
                  else
                  {
                      if (!newProject.Save())
                      {
                          // ErrorMessage.Text = "There was an error.  Please fix it and try it again.";

                      }
                      UpdateProjectMembers(newProject.Id);

                      string strUrl = "Project_Details.aspx?ProjectId=" + newProject.Id.ToString() + "&succ=true";
                      Response.Redirect(strUrl);
                  }
                 
             
          }

          catch (Exception ex)
          {
              string strUrl1 = "Project_Details.aspx?ProjectId=" + newProject.Id.ToString() + "&error=false";


              Error.Text = "Project name already exists.";
              //Response.Redirect(strUrl1);
          }
      
    }

    protected void SelectProjectMembers(int projectId)
    {
        
        Consultants.DataBind();
        List<string> userList = Project.GetProjectMembers(projectId);

        foreach (string user in userList)
        {
            if (user != "Select")
            {
                ListItem item = Consultants.Items.FindByValue(user);
                Consultants.Items.Remove(item);
                SelectedResources.Items.Add(item);
            }
            
        }
    }

    protected void UpdateProjectMembers(int projectId)
    {
     //   string activeConsultants = string.Empty;

        //if (ViewState["ActiveConsultants"] != null)
        //{
        //    activeConsultants = ViewState["ActiveConsultants"].ToString();

        //}
         //activeConsultants = BuildValueList(SelectedResources.Items, false);
        //List<string> userList = user
        //foreach (string item in userList)
        //{
        //    if (SelectedResources.DataTextField.Contains(item))
        //    {
        //        Project.AddUserToProject(projectId, item);
        //    }
        //    if (Consultants.DataTextField.Contains(item))
        //    {
        //        Project.RemoveUserFromProject(projectId, item);
        //    }
        //}

        List<string> userList = Project.GetProjectMembers(projectId);
       
        foreach (ListItem Resources in Consultants.Items)
        {
            Project.RemoveUserFromProject(projectId, Resources.Text);
        }
        foreach (ListItem SelectedUsers in SelectedResources.Items)
        {
            Project.AddUserToProject(projectId, SelectedUsers.Text);
        }
    }
    
    protected void CustomValidator1_ServerValidate(object source, ServerValidateEventArgs args) {

        if (Description.Text.Length > 300)
            args.IsValid = false;
        else
            args.IsValid = true;
    }

    public void Page_Error(object sender, EventArgs e)
    {
        Exception objErr = Server.GetLastError().GetBaseException();
        Server.ClearError();
        Response.Redirect("../TimeTracker/CustomErrorPage.aspx");
    }
    protected void btn1_Click(object sender, EventArgs e)
    {
        lbltxt.Visible = false;
        if (Consultants.SelectedIndex >= 0)
        {
            for (int i = 0; i < Consultants.Items.Count; i++)
            {
                if (Consultants.Items[i].Selected)
                {
                    if (!arraylist1.Contains(Consultants.Items[i]))
                    {
                        arraylist1.Add(Consultants.Items[i]);

                    }
                    
                }

            }
           
            for (int i = 0; i < arraylist1.Count; i++)
            {
                if (!SelectedResources.Items.Contains(((ListItem)arraylist1[i])))
                {
                    SelectedResources.Items.Add(((ListItem)arraylist1[i]));
                }
                Consultants.Items.Remove(((ListItem)arraylist1[i]));
            }
            SelectedResources.SelectedIndex = -1;
        }
        else
        {
            lbltxt.Visible = true;
            lbltxt.Text = "Please select atleast one in consultant to move";
        }
        Duration.Text = Convert.ToString(Convert.ToDecimal(txtBAHrs.Text) + Convert.ToDecimal(txtDesignHrs.Text) + Convert.ToDecimal(txtDevHours.Text) + Convert.ToDecimal(txtOtherDuration.Text) + Convert.ToDecimal(txtProjectHrs.Text) + Convert.ToDecimal(txtTestingHrs.Text));

    }
    protected void btn3_Click(object sender, EventArgs e)
    {
        lbltxt.Visible = false;
        if (SelectedResources.SelectedIndex >= 0)
        {
            for (int i = 0; i < SelectedResources.Items.Count; i++)
            {
                if (SelectedResources.Items[i].Selected)
                {
                    if (!arraylist2.Contains(SelectedResources.Items[i]))
                    {
                        arraylist2.Add(SelectedResources.Items[i]);
                    }

                }
            }
            for (int i = 0; i < arraylist2.Count; i++)
            {
                if (!Consultants.Items.Contains(((ListItem)arraylist2[i])))
                {
                    Consultants.Items.Add(((ListItem)arraylist2[i]));
                }
                SelectedResources.Items.Remove(((ListItem)arraylist2[i]));
            }
            Consultants.SelectedIndex = -1;
        }
        else
        {
            lbltxt.Visible = true;
            lbltxt.Text = "Please select atleast one in selected consultants to move";
        }
        Duration.Text = Convert.ToString(Convert.ToDecimal(txtBAHrs.Text) + Convert.ToDecimal(txtDesignHrs.Text) + Convert.ToDecimal(txtDevHours.Text) + Convert.ToDecimal(txtOtherDuration.Text) + Convert.ToDecimal(txtProjectHrs.Text) + Convert.ToDecimal(txtTestingHrs.Text));
    }


    protected void SelectedResourcesOnLoad(object sender, EventArgs e)
    {
    //    ArrayList list = new ArrayList();
    //    foreach (object o in SelectedResources.Items)
    //    {
    //        list.Add(o);
    //    }
    //    SelectedResources.Items.Clear();
    //    list.Sort();
    //    Array selected 
        //RoleName

    //    Array.Sort(SelectedResources.Items);
    //    //Array.Sort(list);
    //    int j;
    //    for (j = 0; j < list.Count;j++ )
    //    {
    //        SelectedResources.Items.Add(((ListItem)list[j]));
    //    }
  }
    protected void Consultants_DataBound(object sender, EventArgs e)
    {
        int count = Consultants.Items.Count;
        string RoleName = "";
        if (count>0)
        {
            for (int i = 0; i < Consultants.Items.Count; i++)
            {
                CustomFacade objCustomFacade = new CustomFacade();
                RoleName = objCustomFacade.GetRoleDetailsBYUserName(Consultants.Items[i].Value);
                if (RoleName.ToLower().Contains("projectadministrator") || RoleName.ToLower().Contains("projectmanager"))
                {
                    Consultants.Items.Remove(Consultants.Items[i].Value);
                }
            }
        }
    }
}
