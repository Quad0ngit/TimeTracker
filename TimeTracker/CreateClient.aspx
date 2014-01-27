<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CreateClient.aspx.cs" Inherits="TimeTracker_CreateClient" MasterPageFile="~/TimeTracker/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="maincontent" runat="Server">

  <script language="javascript" type="text/javascript">
      function AddClientDeatils() {
          document.getElementById("<%=txtClientName.ClientID%>").value = "";
          $.colorbox({ width: "400px", height: "280px", inline: true, href: "#divAddClient" }, function() { });
          return false;
      }
      function ValidatePage() {
          var Project = document.getElementById("<%=txtClientName.ClientID%>").value.trim();
          var Contact = document.getElementById("<%=txtContact.ClientID%>").value.trim();
          var Address = document.getElementById("<%=txtAddress.ClientID%>").value.trim();
          var PreErrorMsg = "Please provide following missing information";
          var isfocusset = false;
          if (Project.trim() == "") {
              PreErrorMsg += "\n - Client Name ";
              if (!isfocusset) { $('input[id$=txtClientName]').focus(); isfocusset = true; }
          }
          if (Contact.trim() == "") {
              PreErrorMsg += "\n - Contact Number ";
              if (!isfocusset) { $('input[id$=txtContact]').focus(); isfocusset = true; }
          }
          if (Address.trim() == "") {
              PreErrorMsg += "\n - Address ";
              if (!isfocusset) { $('input[id$=txtAddress]').focus(); isfocusset = true; }
          }
          if (PreErrorMsg != "Please provide following missing information") {
              alert(PreErrorMsg);
              return false;
          }
          else {
              return true;
          }
      }

      function AssignTeamLead() {
          
          $.colorbox({ width: "400px", height: "280px", inline: true, href: "#divAddClient" }, function() { });
          return false;
      }

  </script>
     <div>
        <a name="content_start" id="content_start"></a>
        <fieldset>
              <table cellpadding="0" cellspacing="0" width="50%">
                 <tr>
                    <td colspan="2" align="right">                       
                                 
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan="2">
                        <div style="padding:0px 0px 5px 401px;"> <a href="javascript:void(0)" onclick="return AddClientDeatils();" class="AddUserClass">Add Client</a></div>
                        <asp:Label runat="server" ID="lblMsg" Visible="false"></asp:Label>
                        <asp:GridView runat="server" ID="gv_ClientDeatils"  DataKeyNames="Id,Name"
                            AutoGenerateColumns="false" 
                            CssClass="project_list_main" onrowcommand="gv_ClientDeatils_RowCommand" 
                            onrowdatabound="gv_ClientDeatils_RowDataBound">
                            <Columns>
                                <asp:BoundField HeaderText="Client Name" DataField="Name" />
                                <asp:BoundField HeaderText="Contact Number" DataField="ContactNo" />
                                <asp:BoundField HeaderText="Address" DataField="Address" />
                                <asp:TemplateField HeaderText="Edit">
                                    <ItemTemplate>
                                        <asp:LinkButton runat="server" ID="lnkEditClient"  CommandName="EditClient">
                                           <asp:Image ID="img" runat="server" ImageUrl="~/TimeTracker/images/editIcon.gif" />
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
        <div id="divAddClient">  
            <table id="TblAddDocs" cellpadding="0" cellspacing="5" style="padding-top:10px;" width="100%" >
                <tr>
                    <td align="center" colspan="2"><h3>Add Client</h3></td>
                </tr>
                <tr>
                    <td align="right" style="width:25%;">Client Name : </td>
                    <td style="width:75%;"><asp:TextBox runat="server" ID="txtClientName"></asp:TextBox></td>
                </tr>
                <tr>
                    <td align="right" style="width:25%;">Contact Number : </td>
                    <td style="width:75%;"><asp:TextBox runat="server" ID="txtContact" MaxLength="12" ></asp:TextBox></td>
                </tr>
                <tr>
                    <td align="right" style="width:25%;">Address : </td>
                    <td style="width:75%;"><asp:TextBox runat="server" ID="txtAddress" TextMode="MultiLine"></asp:TextBox></td>
                </tr>
                <tr><td></td><td><asp:Button runat="server" ID="btnSubmit" Text="Submit" onclick="btnSubmit_Click"/></td></tr>
            </table>
        </div> 
        </div>
          <asp:HiddenField runat="server" ID="hdnClientId" Value="0" />

</asp:Content>