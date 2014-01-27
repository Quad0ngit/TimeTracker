<%@ Page Language="C#" MasterPageFile="~/TimeTracker/MasterPage.master" CodeFile="User_List.aspx.cs"
    Inherits="User_List_aspx" Title="Quadone - Time Tracker - Administration - List of Users" Culture="auto" UICulture="auto" %>
<asp:Content ID="Content1" ContentPlaceHolderID="maincontent" runat="Server">
    <script type="text/javascript" >
        function AssignTeamLead() {
            $.colorbox({ width: "250px", height: "200px", inline: true, href: "#divAssignTeamlead" }, function() { });
            return false;
        }

        function ValidatePage() {
            var Project = document.getElementById("<%=ddlTeamLead.ClientID%>").value;
            var PreErrorMsg = "Please provide following missing information";
            var isfocusset = false;
            if (Project == "0") {
                PreErrorMsg += "\n - TeamLead ";
                if (!isfocusset) { $('input[id$=ddlTeamLead]').focus(); isfocusset = true; }
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

    <div id="adminedit">
        <a name="content_start" id="content_start"></a>
        <fieldset>
            <!-- add H2 here and hide it with css since you can not put h2 inside a legend tag -->
            <h2 class="none">
                User List</h2>
            <legend>Users List</legend>
            <div style="text-align:center;">
            <asp:Label ID="lblResult" runat="server" Font-Bold="true" ForeColor="green"/></div>
            <br />
                        <asp:ObjectDataSource id="listusers" runat="server" TypeName="System.Web.Security.Membership"
                            SelectMethod="GetAllUsers" />
                        <asp:GridView ID="ListAllUsers" 
                DataKeyNames="UserName" AutoGenerateColumns="False"
                            AllowSorting="True" AllowPaging="True" BorderWidth="0px" 
                runat="server" BorderStyle="None" CssClass="project_list_main"
                                    Width="100%" CellPadding="2" PageSize="15"   
                        onrowcancelingedit="ListAllUsers_RowCancelingEdit"
                        onrowediting="ListAllUsers_RowEditing"
                        onrowupdating="ListAllUsers_RowUpdating" 
                onpageindexchanging="ListAllUsers_PageIndexChanging" 
                onrowdeleting="ListAllUsers_RowDeleting" onrowcommand="ListAllUsers_RowCommand" 
                                onrowdatabound="ListAllUsers_RowDataBound" >
                            <Columns>
                             <asp:TemplateField>
                        <HeaderTemplate>
                            S.No.</HeaderTemplate>
                        <ItemTemplate>
                        <asp:Label ID="lblSRNO" runat="server" 
                             Text='<%#Container.DataItemIndex+1 %>'></asp:Label>
                        </ItemTemplate>
                        </asp:TemplateField>
                                <asp:BoundField DataField="UserName" HeaderText="User Name" ReadOnly="true" />
                                 <asp:TemplateField  HeaderText="E-Mail Address"> 
                                 <ItemTemplate>
                                   <asp:Label Text='<%#Eval("Email")%>' ID="lastname" runat="server" />
                                  </ItemTemplate>
                                 <EditItemTemplate>
                                       <asp:TextBox ID="Email" runat="server"  Text='<%# Eval("Email")%>' />
                                       <asp:RequiredFieldValidator ID="EmailRequired" runat="server" 
                                            ControlToValidate="Email" ErrorMessage="Email is required." 
                                            ToolTip="User Name is required." ></asp:RequiredFieldValidator>
                                       <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                                             ErrorMessage="Invalid Email" ControlToValidate="Email"
                                             SetFocusOnError="True"
                                             ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                 </EditItemTemplate>
                                </asp:TemplateField>
                                 <asp:TemplateField  HeaderText="Role"> 
                                     <ItemTemplate>
                                       <asp:Label Text='<%# FormatText(Eval("ProviderUserKey"))%>' ID="UserId" runat="server" />
                                      </ItemTemplate>
                                 </asp:TemplateField>
                               
                               <%-- <asp:BoundField DataField="Email" HeaderText="E-Mail Address" />--%>
                                <%--<asp:CommandField ShowEditButton="True" HeaderText="Edit" 
                                    ItemStyle-HorizontalAlign="Left" ButtonType="Image" EditImageUrl="images/editIcon.gif"
                                UpdateImageUrl="images/icon-save.gif" CancelImageUrl="images/icon-cancel.gif" >
                            <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                </asp:CommandField>--%>
                                <asp:TemplateField HeaderText="Assign Teamlead">
                                <ItemTemplate>
                                    <asp:label runat="server" ID="lblAssignTeamLeader" Text="Assign TeamLead" ForeColor="#396EAA"></asp:label>
                                    <asp:LinkButton runat="server" id="lnkAssignTeamLeader" Text="Assign TeamLead" CommandArgument="AssignTeamLead" ></asp:LinkButton>
                                </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Delete">
                                <ItemTemplate>
                                <asp:ImageButton ID="DeleteButton" runat="server" CommandName="Delete" ItemStyle-HorizontalAlign="Left" ImageUrl="images/delete_icon.gif"
                               ButtonType="Image"
                                OnClientClick="return confirm('Are you sure you want to delete this user?');" />
                                </ItemTemplate>
                                </asp:TemplateField>
                           
                            </Columns>
                            <RowStyle HorizontalAlign="Left" CssClass="row1" />
                            <HeaderStyle CssClass="grid-header" HorizontalAlign="Left" />
                            <AlternatingRowStyle CssClass="dark" />
                        </asp:GridView>
                        <br />
                        <asp:Button ID="CreateUser" runat="server" Text="Create new user" CssClass="submit"
                            OnClick="Button_Click" />
                        <br />
                         
        </fieldset>
    </div>
       
        <div id="addDocument" style="display:none;" >
        <div id="divAssignTeamlead">  
            <table id="TblAddDocs" class="tbladd" cellpadding="0" cellspacing="0" style="padding-top:10px;" >
                <tr>
                    <td align="center" colspan="2"><h2>Assign Teamlead</h2></td>
                </tr>
                <tr>
                    <td width="40%">Team Leader</td>
                    <td width="60%"><asp:DropDownList runat="server" ID="ddlTeamLead"></asp:DropDownList></td>
                </tr>
                <tr><td>&nbsp;</td></tr>
                <tr><td></td><td align="left"><asp:Button runat="server" ID="btnSubmit" Text="Submit" onclick="btnSubmit_Click" /></td></tr>
            </table>
        </div> 
        </div>
        <asp:HiddenField runat="server" ID="hdnUserId" Value="" />
</asp:Content>
