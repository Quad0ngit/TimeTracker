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
using System.IO;
using System.Net;
using System.ComponentModel;

public partial class TimeTracker_ProjectDocuments : System.Web.UI.Page
{
    CustomFacade objCustomFacade = new CustomFacade();
    List<Project> lstProjectDetails = new List<Project>();
    List<Project> lstProjectDocs = new List<Project>();
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                BindProjects();
            }
        }
        catch (Exception)
        {
        }
        btnSubmit.Attributes.Add("onclick", "return ValidatePage();");
    }

    private void BindProjects()
    {
        try
        {
          lstProjectDetails=  objCustomFacade.GetProjectDetails();
          if (lstProjectDetails.Count>0)
          {
              ddlProject.DataSource = lstProjectDetails;
              ddlProject.DataValueField = "Id";
              ddlProject.DataTextField = "Name";
              ddlProject.DataBind();

              ddlEditProject.DataSource = lstProjectDetails;
              ddlEditProject.DataValueField = "Id";
              ddlEditProject.DataTextField = "Name";
              ddlEditProject.DataBind();
          }
          ddlProject.Items.Insert(0, new ListItem("Select", "0"));
          ddlProject.SelectedValue = "0";
          ddlEditProject.Items.Insert(0, new ListItem("Select", "0"));
          ddlEditProject.SelectedValue = "0";
        }
        catch (Exception)
        { 
        }
    }

    protected void ddlProject_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            bindProjectDocuments();            
        }
        catch (Exception)
        {
        }
    }

    private void bindProjectDocuments()
    {
        try
        {
            if (ddlProject.SelectedValue != "0")
            {
                int PrjId = Convert.ToInt32(ddlProject.SelectedValue);
                lstProjectDocs = objCustomFacade.getProjectDocsDetailsByProjectId(PrjId);
                if (lstProjectDocs.Count > 0)
                {
                    gv_ProjectDocments.Visible = true;
                    gv_ProjectDocments.DataSource = lstProjectDocs;
                    gv_ProjectDocments.DataBind();
                    lblMsg.Visible = false;
                }
                else
                {
                    gv_ProjectDocments.Visible = false;
                    lblMsg.Visible = true;
                    lblMsg.Text = "No records found.";
                    lblMsg.CssClass = "redtext";
                }
            }
            else
            {
                gv_ProjectDocments.Visible = false;
            }
        }
        catch (Exception)
        {
        }
    }
    protected void gv_ProjectDocments_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            GridViewRow row = (GridViewRow)((LinkButton)e.CommandSource).NamingContainer;
            int ProjectId = Convert.ToInt32(gv_ProjectDocments.DataKeys[row.RowIndex]["ProjectId"]);
            int AutoId = Convert.ToInt32(gv_ProjectDocments.DataKeys[row.RowIndex]["AutoId"]);

            if (e.CommandName == "DownloadDocument")
            {
                lstProjectDocs = objCustomFacade.getProjectDocsDetailsByProjectId(ProjectId);
                if (lstProjectDocs.Count > 0)
                {
                    var result = (from res in lstProjectDocs
                                  where res.AutoId == AutoId
                                  select res).ToList();
                    string PhysicalProjectPath = HttpContext.Current.Server.MapPath("~") + "\\" + ConfigurationManager.AppSettings["PhysicalProjectPathDownload"].ToString() + Convert.ToString(ddlProject.SelectedItem.Text);
                    string fileName = "";
                    foreach (var item in result)
                    {
                        PhysicalProjectPath = PhysicalProjectPath + "\\" + item.PrjEncDocName;
                        fileName = item.PrjDocName;
                    }
                    WebClient objWebClient = new WebClient();
                    if (File.Exists(@PhysicalProjectPath))
                    {
                        Response.ContentType = "application/bak";
                        Response.AppendHeader("Content-Disposition", "attachment; filename=" + fileName);
                        Response.TransmitFile(@PhysicalProjectPath);
                        Response.End();
                    }
                }

            }
            if (e.CommandName == "DeleteDocument")
            {
                lstProjectDocs = objCustomFacade.getProjectDocsDetailsByProjectId(ProjectId);
                if (lstProjectDocs.Count > 0)
                {
                    var result = (from res in lstProjectDocs
                                  where res.AutoId == AutoId
                                  select res).ToList();
                    string PhysicalProjectPath = HttpContext.Current.Server.MapPath("~") + "\\" + ConfigurationManager.AppSettings["PhysicalProjectPathDownload"].ToString() + Convert.ToString(ddlProject.SelectedItem.Text);
                    string fileName = "";
                    foreach (var item in result)
                    {
                        PhysicalProjectPath = PhysicalProjectPath + "\\" + item.PrjEncDocName;
                        fileName = item.PrjDocName;
                    }
                    WebClient objWebClient = new WebClient();
                    if (File.Exists(@PhysicalProjectPath))
                    {
                        File.Delete(@PhysicalProjectPath);
                        objCustomFacade.DeleteProjectDocsDetailsByAutoId(AutoId);
                    }
                    bindProjectDocuments();
                    lblMsg.Visible = true;
                    lblMsg.Text = "Record deleted successfully.";
                    lblMsg.CssClass = "greentext"; 
                }
            }
        }
        catch (Exception)
        {
        }
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["username"] != null && Session["username"] != "")
            {
                if (PrjFileUploader.HasFile)
                {
                    string orgFileName = Path.GetFileName(PrjFileUploader.FileName);
                    string fileName = Path.GetFileName(PrjFileUploader.FileName);
                    if (!objCustomFacade.FindIsProjectDocumentExists(fileName, Convert.ToInt32(ddlEditProject.SelectedValue)))
                    {
                        string fileExtension = "";
                        string PhysicalProjectPath = "";
                        string[] test = fileName.Split('.');
                        fileExtension = fileName.Substring(fileName.LastIndexOf("."));
                        fileExtension = fileExtension.Replace(".", "");
                        PhysicalProjectPath = Server.MapPath(ConfigurationManager.AppSettings["PhysicalProjectPath"].ToString() + Convert.ToString(ddlEditProject.SelectedItem.Text));
                        if (!Directory.Exists(PhysicalProjectPath))
                        {
                            Directory.CreateDirectory(PhysicalProjectPath);
                        }
                        string[] tempArr = fileName.Split(new char[] { '.' });
                        string fileFormat = tempArr[tempArr.Length - 1].ToString();
                        fileName = fileName.Substring(0, fileName.LastIndexOf(".")).Replace(" ", "_").ToString().Replace("'", "") + DateTime.Now.GetHashCode().ToString() + "." + fileFormat.ToString();
                        string targetfileName = PhysicalProjectPath + "\\" + fileName.ToString();
                        PrjFileUploader.PostedFile.SaveAs(targetfileName);
                        string UserName = "";
                        if (Session["username"] != null && Session["username"] != "")
                        {
                            UserName = Convert.ToString(Session["username"]);
                        }
                        Project objProject = new Project(0, Convert.ToInt32(ddlEditProject.SelectedValue), Convert.ToString(ddlEditProject.SelectedItem.Text), Convert.ToDateTime(DateTime.Now), Convert.ToString(UserName), Convert.ToString(orgFileName), Convert.ToString(fileName));
                        objCustomFacade.saveProjectDocumentsByProjectId(objProject);
                        bindProjectDocuments();
                        lblMsg.Visible = false;
                    }
                    else
                    {
                        lblMsg.Visible = true;
                        lblMsg.Text = "Already file exists for this project.";
                        lblMsg.CssClass = "greentext";
                    }
                }
            }
            else
            {
                Session.Clear();
                Session.Abandon();
                Response.Redirect("Login.aspx");
            }

        }
        catch (Exception)
        {
        }

    }
    protected void gv_ProjectDocments_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        try
        {

        }
        catch (Exception)
        {
            
            throw;
        }
    }
}
