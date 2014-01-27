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

public partial class TimeTracker_CreateClient : System.Web.UI.Page
{
    List<Project> lstProjectDetails = new List<Project>();
    CustomFacade objCustomFacade = new CustomFacade();

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                bindClients();
            }
        }
        catch (Exception)
        {
        }
        btnSubmit.Attributes.Add("onclick", "return ValidatePage();");
    }

    private void bindClients()
    {
        try
        {           
            lstProjectDetails = objCustomFacade.GetClientDeatils();
            if (lstProjectDetails.Count > 0)
            {
                gv_ClientDeatils.DataSource = lstProjectDetails;
                gv_ClientDeatils.DataBind();
                gv_ClientDeatils.Visible = true;
                lblMsg.Visible = false;
            }
            else
            {
                gv_ClientDeatils.Visible = false;
                lblMsg.Visible = true;
                lblMsg.Text = "No results found.";
            }
        }
        catch (Exception)
        {          
        }
    }
    protected void gv_ClientDeatils_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        GridViewRow row = (GridViewRow)((LinkButton)e.CommandSource).NamingContainer;
        int AutoId = Convert.ToInt32(gv_ClientDeatils.DataKeys[row.RowIndex]["Id"]);
        string ClientName = Convert.ToString(gv_ClientDeatils.DataKeys[row.RowIndex]["Name"]);
        if (e.CommandName == "EditClient")
        {
            hdnClientId.Value = Convert.ToString(AutoId);
            txtClientName.Text = ClientName;
            txtContact.Text = row.Cells[1].Text;
            txtAddress.Text = row.Cells[2].Text;
            ScriptManager.RegisterStartupScript(Page, GetType(), "PopUp", "AssignTeamLead();", true);        
        }
      
    }
    protected void gv_ClientDeatils_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        try
        {

        }
        catch (Exception)
        {          
        }
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        try
        {
            objCustomFacade.saveClientDeatils(Convert.ToInt32(hdnClientId.Value), Convert.ToString(txtClientName.Text), Convert.ToString(txtContact.Text), Convert.ToString(txtAddress.Text));
            bindClients();
            if (Convert.ToInt32(hdnClientId.Value) != 0)
            {
                lblMsg.Text = "Client details saved successfully.";
            }
            else
            { lblMsg.Text = "Client details updated successfully."; }
        }
        catch (Exception)
        {
        }
    }
}
