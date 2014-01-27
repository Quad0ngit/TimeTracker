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
using System.IO;
using System.Web.Extensions.Util;
using System.Data.SqlClient;
using ASPNET.StarterKit.DataAccessLayer;

public partial class TimeEntry_aspx : System.Web.UI.Page {
  public TimeEntry_aspx() {
  }

  void Page_Load(object sender, EventArgs e) {

      
    if (!Page.IsPostBack) {
      if ((Page.User.IsInRole("ProjectAdministrator") || Page.User.IsInRole("ProjectManager"))) {
        UserList.DataSourceID = "ProjectMembers";

        //if (Page.User.ToString() != null && Page.User.ToString() != "")
        //{
        //    UserList.SelectedValue = Page.User.ToString();
        //}
          //UserList.SelectedValue=
        if (Page.User.IsInRole("ProjectAdministrator")) {
          ProjectData.SortParameterName = "sortParameter";
          ProjectData.SelectMethod = "GetAllProjects";
          divTimeSheet.Visible = false;
          AllProjectList.DataBind();
          ListItem select = new ListItem("Select", "0");
          if (AllProjectList.Items.Contains(select).ToString() != "True")
          {
              AllProjectList.Items.Insert(0, new ListItem("Select All", "0"));
          }
          UserList.DataBind();
          
    
          ProjectList.Items.Insert(0, new ListItem("Select", "0")); 
          admin.Attributes.Add("style","width:0px;");
          admin.Visible = false;   
        }
        else if (Page.User.IsInRole("ProjectManager")) {

          ProjectData.SelectParameters.Add(new Parameter("userName", TypeCode.String, Page.User.Identity.Name));
          ProjectData.SelectMethod = "GetProjectsByUserName";         
          SQLDataAccess objSQLDataAccess = new SQLDataAccess();
          List<Category> objCategorylist = objSQLDataAccess.GetCategoriesByUserName(Convert.ToString(""));
          CategoryList.DataSource = objCategorylist;
          CategoryList.DataTextField = "Name";
          CategoryList.DataValueField = "Id";
          //CategoryList.DA =Convert.ToString(objCategorylist[0].Name);
          //CategoryList.SelectedValue = Convert.ToString(objCategorylist[0].Id);
          CategoryList.DataBind();
          AllProjectList.DataBind();
          ListItem select = new ListItem("Select", "0");
          if (AllProjectList.Items.Contains(select).ToString() != "True")
          {
              AllProjectList.Items.Insert(0, new ListItem("Select All", "0"));
          }
          UserList.DataBind();
          UserList.Items.Insert(0, new ListItem("Select", "0"));
          //ProjectList.Items.Insert(0, new ListItem("Select", "0"));         
        }
      }
      else if (Page.User.IsInRole("TeamLeader"))
      {
          ProjectData.SelectParameters.Add(new Parameter("userName", TypeCode.String, Page.User.Identity.Name));
          ProjectData.SelectMethod = "GetProjectsByUserName";
          UserList.Items.Add(Page.User.Identity.Name);

          SQLDataAccess objSQLDataAccess = new SQLDataAccess();
          List<Category> objCategorylist = objSQLDataAccess.GetCategoriesByUserName(Convert.ToString(Page.User.Identity.Name));
          CategoryList.DataSource = objCategorylist;
          CategoryList.DataTextField = "Name";
          CategoryList.DataValueField = "Id";
          //CategoryList.DA =Convert.ToString(objCategorylist[0].Name);
          //CategoryList.SelectedValue = Convert.ToString(objCategorylist[0].Id);
          CategoryList.DataBind();
          AllProjectList.DataBind();
          ListItem select = new ListItem("Select", "0");
          if (AllProjectList.Items.Contains(select).ToString() != "True")
          {
              AllProjectList.Items.Insert(0, new ListItem("Select All", "0"));
          }
        
         // ProjectList.Items.Insert(0, new ListItem("Select", "0")); /
      }
      else
      {
          ProjectData.SelectParameters.Add(new Parameter("userName", TypeCode.String, Page.User.Identity.Name));


          ProjectData.SelectMethod = "GetProjectsByUserName";
          CustomFacade objCustomFacade = new CustomFacade();
          List<Project> listProject = new List<Project>();
          //listProject = objCustomFacade.GetProjectsByUserName(Page.User.Identity.Name);

          UserList.Items.Add(Page.User.Identity.Name);
          //UserList.Items.Insert(0, new ListItem("Select", "0"));

          SQLDataAccess objSQLDataAccess = new SQLDataAccess();
          List<Category> objCategorylist = objSQLDataAccess.GetCategoriesByUserName(Convert.ToString(Page.User.Identity.Name));
          CategoryList.DataSource = objCategorylist;
          CategoryList.DataTextField = "Name";
          CategoryList.DataValueField = "Id";
          //CategoryList.DA =Convert.ToString(objCategorylist[0].Name);
          //CategoryList.SelectedValue = Convert.ToString(objCategorylist[0].Id);
          CategoryList.DataBind();
          AllProjectList.DataBind();
          ListItem select = new ListItem("Select", "0");
          if (AllProjectList.Items.Contains(select).ToString() != "True")
          {
              AllProjectList.Items.Insert(0, new ListItem("Select All", "0"));
          }
          //ProjectList.Items.Insert(0, new ListItem("Select", "0")); 
      }
      username.Text = "Welcome: " + Session["username"];
      ProjectList.DataBind();
      //ProjectList.Items.Insert(0, new ListItem("Select", "0"));

      //if (ProjectList.SelectedValue != "0" && ProjectList.SelectedValue != "")
      //{
      //    if (Session["username"] != null && Session["username"] != "")
      //    {
      //        UserList.SelectedItem.Text = Convert.ToString(Session["username"]);
      //    }
      //}
      
      //if (ProjectListGridView.Rows.Count==0)
      //{
      //    lblexport.Visible =false;
      //    lnkexport.Visible = false;
      //}
      if (ProjectList.Items.Count >= 1)
      {
          TimeEntryView.Visible = true;
          MessageView.Visible = false;
      }
      else
      {
          TimeEntryView.Visible = true;
          MessageView.Visible = false;
      }
      StartDate.Text = DateTime.Now.Date.AddDays(-7).ToShortDateString();
      EndDate.Text = DateTime.Now.ToShortDateString();
      ProjectListGridView.DataBind();
    }
    if (UserList.Items.Count == 0) {
        AddEntry.Enabled = false;
    }
    

  }

 
  protected void AddEntry_Click(object sender, System.EventArgs e) {
      Page.Validate();
    if (Page.IsValid == false)
        return;
    if (txtDate.Text != "" && txtDate.Text != null && Hours.Text != "" && Hours.Text != null && Hours.Text != "0.0" && Hours.Text != "0")
    {
        TimeEntry timeEntry = new TimeEntry(Page.User.Identity.Name, Convert.ToInt32(ProjectList.SelectedValue), Convert.ToInt32(CategoryList.SelectedValue), Convert.ToDecimal(Hours.Text), Convert.ToDateTime(txtDate.Text), Page.User.Identity.Name);
        timeEntry.Description = Description.Text;
        timeEntry.Save();
    }
    txtDate.Text = string.Empty;
    Description.Text = string.Empty;
    
    if (Convert.ToDecimal(Hours.Text) <= 0)
    {
        hourscheck.Visible = true;
        hourscheck.Text = "Hours should be greater than zero";
    }
    //hourscheck.Visible = false;
    Hours.Text = string.Empty;
    ProjectListGridView.DataBind();


  }
   

  protected void Cancel_Click(object sender, EventArgs args) {
    Description.Text = string.Empty;
    Hours.Text = string.Empty;
  }

    protected void CustomValidator1_ServerValidate(object source, ServerValidateEventArgs args) {

        if (Description.Text.Length > 200)
            args.IsValid = false;
        else
            args.IsValid = true;
    }
    protected void ProjectListGridView_RowDeleting(object sender, GridViewDeleteEventArgs e) {

    }
 
    private Decimal totalDuration = 0;

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
            //totalDuration += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "Duration"));
            //totalhours.Visible = true; 
            //totalhours.Text = totalDuration.ToString();;
               
                     
        }
        else if (e.Row.RowType == DataControlRowType.Footer)
        {
           
            //e.Row.Cells[2].Text = "Total Duration is:";
            //e.Row.Cells[3].Text = Convert.ToString(totalDuration);
        }
        

        totalhours.Text = TimeEntry.totalhours.ToString(); 
        
    }
    


    protected void ProjectListGridView_RowUpdated(object sender, GridViewUpdatedEventArgs e) {
     
    }

    //public void Page_Error(object sender, EventArgs e)
    //{
    //    Exception objErr = Server.GetLastError().GetBaseException();
    //    Server.ClearError();
    //    Response.Redirect("../TimeTracker/CustomErrorPage.aspx");
    //}


    protected void lnkexport_Click(object sender, EventArgs e)
    {
        ProjectListGridView.DataBind();
        if (ProjectListGridView.Rows.Count>=1)
        {
            Response.ClearContent();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", string.Format("attachment; filename={0}", "TimeSheet.xls"));
            Response.ContentType = "application/vnd.ms-excel";
            StringWriter sw = new StringWriter();

            sw.Write("<table class='timeentry-edit' cellspacing='0' cellpadding='2' rules='all' border='0' id='ctl00_maincontent_ProjectListGridView' style='border-width:0px;border-style:None;width:100%;border-collapse:collapse;'><tr class='grid-header' align='left'><th scope='col'>User Name</th><th scope='col'>Total Duration Worked</th>	</tr><tr class='row1' style='border-style:None;'><td style='background-Color:#FFFFFF;'>"+UserList.SelectedItem.ToString()+"</td><td style='background-Color:#FFFFFF;'>"+totalhours.Text+"</td></tr></table>");
          

            HtmlTextWriter htw = new HtmlTextWriter(sw);

            

            ProjectListGridView.AllowPaging = false;
            ProjectListGridView.DataBind();
            ProjectListGridView.RenderBeginTag(htw);
            // ProjectListGridView.HeaderRow.RenderControl(htw);


            int j = 1;
            //This loop is used to apply stlye to cells based on particular row
            ProjectListGridView.Columns[5].Visible = false;
            ProjectListGridView.Columns[6].Visible = false;
            foreach (GridViewRow gvrow in ProjectListGridView.Rows)
            {
                for (int k = 0; k < gvrow.Cells.Count; k++)
                {
                   gvrow.Cells[k].Style.Add("background-Color", "#FFFFFF");
                }
            }
            //ProjectListGridView.RenderControl(htw);

            //style to format numbers to string
            string style = @"<style> .textmode { mso-number-format:\@; } </style>";

            ProjectListGridView.FooterRow.RenderControl(htw);
            ProjectListGridView.RenderEndTag(htw);
            ProjectListGridView.HeaderRow.Style.Add("background-color", "#FFFFFF");
            ProjectListGridView.RenderControl(htw);
           
            Response.Write(sw.ToString());
            Response.End();   
        
            
        }

    }
    

    public override void VerifyRenderingInServerForm(Control control)
    {
        // Confirms that an HtmlForm control is rendered for the   

        if (ProjectListGridView.Rows.Count>=1)
        {
            lblexport.Attributes["Style"] = "display:inline-block;";
            lnkexport.Attributes["Style"] = "display:inline-block;";
            
            //totalhours.Visible = true;
        }
        else
        {
            lblexport.Attributes["Style"] = "display:none;";
            lnkexport.Attributes["Style"] = "display:none;";
            //totalhours.Visible = false;
        }

    }




    protected void ProjectListGridView_SelectedIndexChanged(object sender, EventArgs e)
    {
        

    }
    protected void TimeSheet_Click(object sender, EventArgs e)
    {
        //SQLDataAccess sQLDataAccess = new SQLDataAccess();
        //List<TimeEntry> allProjectDetailsWithinDates = sQLDataAccess.GetTimeEntriesByUserNameProjectIdAndDates(UserList.SelectedItem.ToString(), Convert.ToInt32(AllProjectList.SelectedValue), Convert.ToDateTime(StartDate.Text), Convert.ToDateTime(EndDate.Text));
        ////ProjectListGridView.DataSource = allProjectDetailsWithinDates;
        Requiredfieldvalidator4.Validate();
        Requiredfieldvalidator5.Validate();
        if (Page.IsValid == false)
            return;
        
      
        ProjectListGridView.DataBind();
    }
    protected void ProjectList_SelectedIndexChanged(object sender, EventArgs e)
    {
        AllProjectList.SelectedValue = ProjectList.SelectedValue;
    }
    //protected void ProjectListGridView_RowUpdating(object sender, GridViewUpdateEventArgs e)
    //{
        
    //}

    protected void Hours_TextChanged(object sender, EventArgs e)
    {
        
    }



   
    protected void ProjectListGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        ProjectListGridView.PageIndex = e.NewPageIndex;
        ProjectListGridView.DataBind();
    }

    protected void EndDate_TextChanged(object sender, EventArgs e)
    {
        if (Convert.ToDateTime(StartDate.Text) > Convert.ToDateTime(EndDate.Text))
            dateCompare.Visible = true;
        dateCompare.Text = "Start Date should be less than End Date.";

    }
    protected void UserList_SelectedIndexChanged(object sender, EventArgs e)
    {
        ProjectListGridView.PageIndex = 0;
    }
}
