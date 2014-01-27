<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ProjectDocuments.aspx.cs" Inherits="TimeTracker_ProjectDocuments" MasterPageFile="~/TimeTracker/MasterPage.master" %>


<asp:Content ID="Content1" ContentPlaceHolderID="maincontent" runat="Server">

  <script language="javascript" type="text/javascript">

      function AddProjectDocument() {
          document.getElementById("<%=ddlEditProject.ClientID%>").value = "0";
          var uploadControl = document.getElementById('<%=PrjFileUploader.ClientID%>'); 
          uploadControl.value = ""; 
          $.colorbox({ width: "400px", height: "250px", inline: true, href: "#divAddDocument" }, function() { });
          return false;
      }

      function DeleteDetails() {
          var conf = confirm('Are you sure you want to delete?');
          if (conf) {
              return true;
          }
          else {
              return false;
          }
      }


      function ValidatePage() {
          var Project = document.getElementById("<%=ddlEditProject.ClientID%>").value;
          var fuData = document.getElementById('<%= PrjFileUploader.ClientID %>');
          var FileUploadPath = fuData.value;
          var PreErrorMsg = "Please provide following missing information";
          var isfocusset = false;

          if (Project == "0") {
              PreErrorMsg += "\n - Project ";
              if (!isfocusset) { $('input[id$=ddlEditProject]').focus(); isfocusset = true; }
          }
          if (FileUploadPath == '') {
              PreErrorMsg += "\n - Project Document";
              if (!isfocusset) { $('input[id$=PrjFileUploader]').focus(); isfocusset = true; }
          }
          if (PreErrorMsg != "Please provide following missing information") {
              alert(PreErrorMsg);
              return false;
          }
          else {
              return true;
          }
      }
  
  </script>
    <div>
         <a name="content_start" id="content_start"></a>
        <fieldset>
              <table cellpadding="0" cellspacing="0" width="100%">
                <tr><td>&nbsp;</td></tr>
                <tr>
                    <td style="width:40%" align="right"><asp:Label runat="server" ID="Label1" Text="Project Name :"></asp:Label> &nbsp; &nbsp;</td>
                    <td style="width:60%">
                        <asp:DropDownList runat="server" ID="ddlProject"  AutoPostBack="true"
                            onselectedindexchanged="ddlProject_SelectedIndexChanged"></asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="right">
                        <a href="javascript:void(0)" onclick="return AddProjectDocument();" class="AddUserClass">
                        Add Project Document</a>          
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan="2">
                        <asp:Label runat="server" ID="lblMsg" Visible="false"></asp:Label>
                        <asp:GridView runat="server" ID="gv_ProjectDocments" 
                            AutoGenerateColumns="false" DataKeyNames="ProjectId,AutoId"  
                            CssClass="project_list_main" onrowcommand="gv_ProjectDocments_RowCommand" 
                            onrowdatabound="gv_ProjectDocments_RowDataBound">                        
                            <Columns>
                                <asp:BoundField HeaderText="Project Name" DataField="Name" />
                                <asp:TemplateField HeaderText="Document" ItemStyle-HorizontalAlign="Left">
                                    <ItemTemplate>
                                        <asp:LinkButton runat="server" ID="lnkDocument"  CommandName="DownloadDocument">
                                           <asp:Label runat="server" ID="lblProjectName" Text='<%# DataBinder.Eval(Container, "DataItem.PrjDocName")%>' ></asp:Label>
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField HeaderText="Created By" DataField="CreatedUser" />
                                <asp:BoundField HeaderText="Created On" DataField="DateCreated" DataFormatString="{0:d-MMM-yyyy}" />   
                                 <asp:TemplateField HeaderText="Delete">
                                    <ItemTemplate>
                                        <asp:LinkButton runat="server" ID="lnkDeleteDocument"  CommandName="DeleteDocument" OnClientClick="return DeleteDetails();">
                                            <asp:Image ID="img" runat="server" ImageUrl="images/icon-delete.gif" />
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>                            
                            </Columns>                        
                        </asp:GridView>
                    </td>
                </tr>
              </table>  
        </fieldset>
    </div>
        
        <div id="addDocument" style="display:none;" >
        <div id="divAddDocument">  
            <table id="TblAddDocs" cellpadding="0" cellspacing="5" style="padding-top:10px;" width="100%" >
                <tr>
                    <td align="center" colspan="2"><h3>Add Project Document</h3></td>
                </tr>
                <tr>
                    <td align="right" style="width:25%;">Project : </td>
                    <td style="width:75%;"><asp:DropDownList runat="server" ID="ddlEditProject"></asp:DropDownList></td>
                </tr>
                <tr>
                    <td></td>
                    <td><asp:FileUpload ID="PrjFileUploader" runat="server" /></td>
                </tr>
                <tr><td></td><td><asp:Button runat="server" ID="btnSubmit" Text="Submit" onclick="btnSubmit_Click" /></td></tr>
            </table>
        </div> 
        </div>
</asp:Content>