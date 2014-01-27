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

public partial class User_List_aspx : System.Web.UI.Page {

 CustomFacade objCustomFacade = new CustomFacade();
 List<Project> objlstProject = new List<Project>();

  public User_List_aspx() {
  }

  void Page_Load(object sender, EventArgs e)
  {
      if (!IsPostBack)
      {
          BindGridview();
          bindTeamLeaders();
      }
      btnSubmit.Attributes.Add("onclick", "return ValidatePage();");
  }
  protected void Button_Click(Object sender, EventArgs args) {
    Response.Redirect("User_Create.aspx");
  }
  protected void BindGridview()
  {
      ListAllUsers.DataSource = Membership.GetAllUsers();
     ListAllUsers.DataBind();
  }

  private void bindTeamLeaders()
  {
      try
      {
          //DropDownList ddlTeamLeader = (DropDownList)CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("ddlTeamLeader");
          objlstProject = objCustomFacade.GetProjectLeaderDeatils();
          if (objlstProject.Count > 0)
          {
              ddlTeamLead.DataSource = objlstProject;
              ddlTeamLead.DataValueField = "UserId";
              ddlTeamLead.DataTextField = "Name";
              ddlTeamLead.DataBind();
          }
          ddlTeamLead.Items.Insert(0, new ListItem("Select", "0"));
          ddlTeamLead.SelectedValue = "0";
      }
      catch (Exception)
      {
      }
  }

  protected void ListAllUsers_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
  {
      ListAllUsers.EditIndex = -1;
      BindGridview();
  }
  // This event is used to make our girdivew editable
  protected void ListAllUsers_RowEditing(object sender, GridViewEditEventArgs e)
  {
      ListAllUsers.EditIndex = e.NewEditIndex;
      BindGridview();
  }
  // This event is used to delete our gridview records
  protected void ListAllUsers_RowDeleting(object sender, GridViewDeleteEventArgs e)
  {
      string UserName = ListAllUsers.Rows[e.RowIndex].Cells[1].Text;

      Membership.DeleteUser(UserName);
      lblResult.Text = string.Format("{0} Details deleted Successfully", UserName);
      BindGridview();

  }
  // This event is used to update gridview data
  protected void ListAllUsers_RowUpdating(object sender, GridViewUpdateEventArgs e)
  {
      int index = ListAllUsers.EditIndex;
      GridViewRow gvrow = ListAllUsers.Rows[index];
     string  UserName = ListAllUsers.Rows[e.RowIndex].Cells[0].Text;

     string Email = ((TextBox)gvrow.Cells[1].FindControl("Email")).Text;
      MembershipUser user = Membership.GetUser(UserName);
      if (user != null)
      {
          user.Email = Email;
          Membership.UpdateUser(user);
          lblResult.Text = string.Format("{0} Details updated Successfully", UserName);
          
      }
      ListAllUsers.EditIndex = -1;
      BindGridview();
  }

  protected void ListAllUsers_PageIndexChanging(object sender, GridViewPageEventArgs e)
  {
      ListAllUsers.PageIndex = e.NewPageIndex;
      BindGridview();
  }

  public string FormatText(object objval)
  {
      string StrReturn = "";
      try
      {
          CustomFacade objCustomFacade = new CustomFacade();
          string UserID = Convert.ToString(objval);
          StrReturn = objCustomFacade.GetRoleDetailsBYUserId(UserID);
      }
      catch (Exception ex)
      {  
      }
      return StrReturn;
  }
  protected void ListAllUsers_RowCommand(object sender, GridViewCommandEventArgs e)
  {
      try
      {
           GridViewRow row = (GridViewRow)((LinkButton)e.CommandSource).NamingContainer;
           string UserName = Convert.ToString(ListAllUsers.DataKeys[row.RowIndex]["UserName"]);
           string UserId= objCustomFacade.getUserIdByUserName(UserName);
           if (UserId != "" && UserId != null)
           {
               hdnUserId.Value = UserId;
           }
           string TeamLeadUserrId = objCustomFacade.getTeamLeadUserIdByUserId(UserId);
           if (TeamLeadUserrId!="" && TeamLeadUserrId!= null)
           {
               ddlTeamLead.SelectedValue = TeamLeadUserrId;
           }
           ScriptManager.RegisterStartupScript(Page, GetType(), "PopUp", "AssignTeamLead();", true);           
      }
      catch (Exception)
      {
      }
  }

    
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        try
        {
            if (hdnUserId.Value!=""&& hdnUserId.Value!= null&& ddlTeamLead.SelectedValue!="0")
            {
                objCustomFacade.SaveUserToTeamLead(Convert.ToString(hdnUserId.Value), Convert.ToString(ddlTeamLead.SelectedValue));
                lblResult.Text = "User assign to teamlead successfully.";
                BindGridview();
            }
        }
        catch (Exception)
        {
        }
    }
    protected void ListAllUsers_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        try
        {
            if (e.Row.RowType == DataControlRowType.DataRow && e.Row.RowType != DataControlRowType.Header)
            {
                LinkButton lnkAssignTeamLeader = (LinkButton)e.Row.FindControl("lnkAssignTeamLeader");
                Label lblAssignTeamLeader = (Label)e.Row.FindControl("lblAssignTeamLeader");
                Label UserId = (Label)e.Row.FindControl("UserId");

                if (UserId.Text == "Consultant")
                {
                    lblAssignTeamLeader.Visible = false;
                    lnkAssignTeamLeader.Visible = true;
                }
                else
                {
                    lblAssignTeamLeader.Visible = true;
                    lnkAssignTeamLeader.Visible = false;
                }
                //Label lnkLabel = (Label)e.Row.FindControl("lblstatus");
                //if (lnkLabel != null)
                //{
                //    lnkLabel.Visible = true;
                //}
                //lnkLabel.Text = Convert.ToString(DataBinder.Eval(e.Row.DataItem, "status"));

            }

        }
        catch (Exception)
        {   
        }
    }
}
