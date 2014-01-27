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
using ASPNET.StarterKit.DataAccessLayer;
using System.Data.SqlClient;

public partial class User_Create_aspx : System.Web.UI.Page {
    CustomFacade objCustomFacade = new CustomFacade();
    List<Project> objlstProject = new List<Project>();

  public User_Create_aspx() {
  }

  void Page_Load(object sender, EventArgs e)
  {
      // disable the UI for annonymous user when the config switch is disable

      if (Page.User.IsInRole("ProjectAdministrator"))
      {

          SQLDataAccess objSQLDataAccess = new SQLDataAccess();
          List<Category> objCategorylist = objSQLDataAccess.GetCategoriesByUserName(Convert.ToString(""));
          DropDownList CategoryList = (DropDownList)CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("categoryList");
          CategoryList.DataSource = objCategorylist;
          CategoryList.DataTextField = "Name";
          CategoryList.DataValueField = "Id";
          CategoryList.DataBind();
      }
      if (!Page.User.Identity.IsAuthenticated && String.Compare(ConfigurationManager.AppSettings["AllowUserCreationForAnonymousUsers"], "0") == 0)
      {
          noAccessMsg.Visible = true;
          CreateUserWizard1.Visible = false;
      }

      if (!Page.IsPostBack)
      {
          if (Page.User.IsInRole("ProjectAdministrator"))
          {
              CreateUserWizard1.LoginCreatedUser = false;
              GroupName.SelectedValue = GetDefaultRoleForNewUser();
          }
          bindTeamLeaders();
      }
  }

  private void bindTeamLeaders()
  {
      try
      {
          DropDownList ddlTeamLeader = (DropDownList)CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("ddlTeamLeader");
          objlstProject = objCustomFacade.GetProjectLeaderDeatils();
          if (objlstProject.Count > 0)
          {
              ddlTeamLeader.DataSource = objlstProject;
              ddlTeamLeader.DataValueField = "UserId";
              ddlTeamLeader.DataTextField = "Name";
              ddlTeamLeader.DataBind();

          }
          ddlTeamLeader.Items.Insert(0, new ListItem("None", "0"));
          ddlTeamLeader.SelectedValue = "0";
      }
      catch (Exception)
      {
      }
  }
 

  protected void AddUserToRole(string newUserName, string roleInformation) {
    switch (roleInformation) {
      case ("0"):
        Roles.AddUserToRole(newUserName, "ProjectAdministrator");
        Roles.AddUserToRole(newUserName, "Consultant");
        break;

      case ("3"):
        Roles.AddUserToRole(newUserName, "ProjectManager");
        Roles.AddUserToRole(CreateUserWizard1.UserName, "Consultant");
        break;

        case("4"):
       // Roles.AddUserToRole(newUserName, "TeamLeader");
        Roles.AddUserToRole(CreateUserWizard1.UserName, "TeamLeader");
        Roles.AddUserToRole(CreateUserWizard1.UserName, "Consultant");
        break;

      default:
        Roles.AddUserToRole(CreateUserWizard1.UserName, "Consultant");
        break;
    }

  }

  protected void CreateUserWizard1_CreatedUser(object sender, EventArgs e) {
      if (!Page.IsValid)
      {
          var userName = CreateUserWizard1.FindControl("UserName");
          Page.SetFocus(userName);
          return;
      }
      //string connectionString = ConfigurationManager.ConnectionStrings["LocalSqlServer"].ConnectionString;
      //using (SqlConnection myConnection = new SqlConnection(connectionString))
      //{

      //    myConnection.Open();

      //    SqlCommand cmd = new SqlCommand("asp.net_starterkits_checkingEmailid", myConnection);
      //    cmd.CommandType = CommandType.StoredProcedure;
      //    cmd.CommandText = "[dbo].[asp.net_starterkits_checkingEmailid]";
      //    TextBox txtEmail = (TextBox)CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("Email");
      //    cmd.Parameters.AddWithValue("@emailID", txtEmail.Text);
      //    SqlDataAdapter da = new SqlDataAdapter(cmd);
      //    DataTable dt = new DataTable();
      //    da.Fill(dt);
      //    if (dt.Rows.Count>0)
      //    {

      //        Label emailLbel = (Label)CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("CheckEmailLabel");
      //        emailLbel.Text = "Select Different Email id.";
      //        myConnection.Close();
      //        //CheckEmailLabel.Text = "Select Different Email id.";
      //        return;
      //    }
          
      //}


    if (!Page.User.IsInRole("ProjectAdministrator"))
      {
          AddUserToRole(CreateUserWizard1.UserName, GetDefaultRoleForNewUser());
      }
      MembershipUser objUser = Membership.GetUser(CreateUserWizard1.UserName);
      Guid genUserId = (Guid)objUser.ProviderUserKey;
      string username=objUser.UserName;
      DropDownList Category = (DropDownList)CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("categoryList");
      int category = Convert.ToInt32(Category.SelectedValue);
      insertCategory(genUserId, category, username);
      DropDownList ddlTeamLeader = (DropDownList)CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("ddlTeamLeader");
      if (ddlTeamLeader.SelectedValue!="0")
      {
        objCustomFacade.SaveUserToTeamLead(Convert.ToString(genUserId), Convert.ToString(ddlTeamLeader.SelectedValue));    
      }
      
          //CreateUserWizard1.ActiveStepIndex = CreateUserWizard1.WizardSteps.IndexOf(CreateUserWizard1.CompleteStep);
          //
     }
  



  protected void Wizard_FinishButton_Click(object sender, WizardNavigationEventArgs e) {
    if (Page.User.IsInRole("ProjectAdministrator")) {
      AddUserToRole(CreateUserWizard1.UserName, GroupName.SelectedValue);

      //MembershipUser objUser = Membership.GetUser(CreateUserWizard1.UserName);
      //Guid genUserId = (Guid)objUser.ProviderUserKey;

      //int category = Convert.ToInt32(DropDownList1.SelectedItem.Value);
      //insertCategory(genUserId, category);

      CreateUserWizard1.ActiveStepIndex = CreateUserWizard1.WizardSteps.IndexOf(CreateUserWizard1.CompleteStep);
    }
  }

  private string GetDefaultRoleForNewUser() {
    if (ConfigurationManager.AppSettings["DefaultRoleForNewUser"] == null) {
      throw (new Exception("DefaultRoleForNewUser was not been defined in the appsettings section of config"));

    }
    else {
      string defaultRole = ConfigurationManager.AppSettings["DefaultRoleForNewUser"];
      if (string.IsNullOrEmpty(defaultRole)) {
        throw (new Exception("DefaultRoleForNewUser does not contain a default value"));
      }
      else {
        if (string.Compare(defaultRole, "3") < 0 && string.Compare(defaultRole, "0") >= 0) {
          return (ConfigurationManager.AppSettings["DefaultRoleForNewUser"]);
        }
        else {
          throw (new ArgumentException("DefaultRoleForNewUser defined in the appsettings has to be between 0 and 2"));
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

  public void insertCategory(Guid UserId, int Category , string username)
  {
      string insertSql = "INSERT INTO UserXCategories(UserId,CategoryId, UserName) VALUES(@UserId, @Category, @UserName)";
      string connectionString = ConfigurationManager.ConnectionStrings["LocalSqlServer"].ConnectionString;
      using (SqlConnection myConnection = new SqlConnection(connectionString))
      {

          myConnection.Open();

          SqlCommand myCommand = new SqlCommand(insertSql, myConnection);
          myCommand.Parameters.AddWithValue("@UserId", UserId);

          myCommand.Parameters.AddWithValue("@Category", Category);

          myCommand.Parameters.AddWithValue("@UserName", username);

          myCommand.ExecuteNonQuery();

          myConnection.Close();


      }

  }

  public bool CheckEmail()
  {
      bool emailExsit = false;
      TextBox txtEmail = (TextBox)CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("Email");
      MembershipUserCollection users = Membership.FindUsersByEmail(txtEmail.Text);
      if (users.Count > 0)
      {
          emailExsit = true;
      }
      else
      {
          emailExsit = false;
      }
      return emailExsit;
  }

  public void Email_TextChanged(object source, ServerValidateEventArgs args)
  {
      string connectionString = ConfigurationManager.ConnectionStrings["LocalSqlServer"].ConnectionString;
      using (SqlConnection myConnection = new SqlConnection(connectionString))
      {

          myConnection.Open();

          SqlCommand cmd = new SqlCommand("asp.net_starterkits_checkingEmailid", myConnection);
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.CommandText = "[dbo].[asp.net_starterkits_checkingEmailid]";
          TextBox txtEmail = (TextBox)CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("Email");
          cmd.Parameters.AddWithValue("@emailID", txtEmail.Text);
          SqlDataAdapter da = new SqlDataAdapter(cmd);
          DataTable dt = new DataTable();
          da.Fill(dt);
          if (dt.Rows.Count > 0)
          {

              //Label emailLbel = (Label)CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("CheckEmailLabel");
              //emailLbel.Text = "Select Different Email id.";
              myConnection.Close();
              args.IsValid = false;
              //CheckEmailLabel.Text = "Select Different Email id.";
             
          }
      }

  }
}
