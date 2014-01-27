<%@ Page Language="C#" MasterPageFile="~/TimeTracker/MasterPage.master" CodeFile="TimeEntry.aspx.cs"
    Inherits="TimeEntry_aspx" Title="Quadone - Time Tracker - Log a Time Entry"
    Culture="auto" UICulture="auto" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="maincontent" runat="Server">
<script type="text/javascript" >
  function CalendarValidation() {
            alert("Please select date from date picker.");
            return false;
        }
    </script>
    <div id="TimeEntryView" runat="server" visible="false">
        
        <div id="">
        
            <div id="addhours" >
                <a name="content_start" id="content_start"></a>
                <asp:ScriptManager ID="ScriptManager1" runat="server">
                </asp:ScriptManager>
                <fieldset>
                <div id="admin" runat="server" >
                <legend>Log your hours</legend>
                 </div> 
                   Project:<br />
                    <asp:ObjectDataSource ID="ProjectData" runat="server" TypeName="ASPNET.StarterKit.BusinessLogicLayer.Project" />
                    <asp:DropDownList ID="ProjectList" runat="server" AutoPostBack="True" 
                        DataSourceID="ProjectData" Width="170px"
                        DataTextField="Name" DataValueField="Id" 
                        onselectedindexchanged="ProjectList_SelectedIndexChanged"  />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="ProjectList"
                        ErrorMessage="Project is a required value." Display="Dynamic" ValidationGroup="newEntry"></asp:RequiredFieldValidator>
                       
           <div id="divTimeSheet" runat="server">
                    <br />
                    Category:<br />
                    <asp:DropDownList ID="CategoryList" runat="server" />
                    
                    <br />
                    Day:<br />
                   <asp:TextBox ID="txtDate" runat="server" Columns="11"  AutoComplete="off"  onkeypress="return CalendarValidation();" ></asp:TextBox>   
                    [mm/dd/yyyy]
                        <asp:RequiredFieldValidator ID="Requiredfieldvalidator3" runat="server" ErrorMessage="Day is a required."
                        ControlToValidate="txtDate" Display="Dynamic" 
                        ValidationGroup="newEntry" ></asp:RequiredFieldValidator>
                        <asp:CompareValidator id="CompletionDateCompareValidator" runat="server" Display="Dynamic" ErrorMessage="Date format is incorrect." ControlToValidate="txtDate" Operator="DataTypeCheck" Type="Date" ValidationGroup="newEntry">
                       </asp:CompareValidator>
                   
                    <br />
                    Hours:<br />
                    <asp:TextBox ID="Hours" runat="server" Columns="5" CssClass="hours" ontextchanged="Hours_TextChanged" 
                        ></asp:TextBox><br />
                        <asp:Label ID="hourscheck" ForeColor="red" runat="server" ></asp:Label>
                    <asp:RequiredFieldValidator ID="Requiredfieldvalidator1" runat="server" ErrorMessage="Hours is a required value."
                        ControlToValidate="Hours" Display="Dynamic" ValidationGroup="newEntry" ></asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="CompareValidator1" runat="server" ErrorMessage="Hours must be a decimal value."
                        ControlToValidate="Hours" Type="Currency" Operator="DataTypeCheck" Display="Dynamic" ValidationGroup="newEntry"
                        ></asp:CompareValidator>
                    <asp:RangeValidator ID="RangeValidator1" runat="server" ErrorMessage="Hours is out of range."
                        ControlToValidate="Hours" MaximumValue="24" MinimumValue="0" Type="Double" ></asp:RangeValidator>
                    <br />
                    Description:<br/>
                    <asp:TextBox ID="Description" runat="server" TextMode="MultiLine" Rows="8" Columns="15"
                        MaxLength="200"></asp:TextBox>
                          <asp:RequiredFieldValidator ID="Requiredfieldvalidator6" runat="server" ErrorMessage="Description is a required value."
                    ControlToValidate="Description" Display="Dynamic" ValidationGroup="newEntry" ></asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator1" runat="server"
                            ControlToValidate="Description" ErrorMessage="Description must be less than 200 characters"
                            OnServerValidate="CustomValidator1_ServerValidate"></asp:CustomValidator>                   
                
                     <br />
                    <asp:Button ID="AddEntry" runat="server" CssClass="submit" CausesValidation="False"
                        Text="Add Entry" OnClick="AddEntry_Click" ValidationGroup="newEntry" />
                    <asp:Button ID="Cancel" runat="server" CssClass="reset" CausesValidation="False"
                        Text="Cancel" OnClick="Cancel_Click" />
                       
                 </div>      
                </fieldset>
                </div>
                </div>
            </div>
            <div id="timesheet">
            <div id="welcome" align="right">
            <asp:Label ID="username" runat="server" Font-Size="Large"></asp:Label>
            </div>
            <div id="Export"  align="right">
            <asp:Label ID="lblexport" runat="server" ForeColor="Blue" Text="Export To - " >
            <asp:ImageButton ID="lnkexport" CssClass="lnkexport" runat="server" ImageUrl="images/btn_Excel.gif" ToolTip="Export To ExcelSheet" onclick="lnkexport_Click" /></asp:Label>
            </div>
                <fieldset>
                    <!-- add H2 here and hide it with css since you can not put h2 inside a legend tag -->
                    <h2 class="none">
                        Time Sheet for:</h2>
                    <legend>Time Sheet For:
                    <asp:ObjectDataSource ID="ProjectMembers" runat="server" TypeName="ASPNET.StarterKit.BusinessLogicLayer.Project"
                            SelectMethod="GetProjectMembers">
                            <SelectParameters>
                                <asp:ControlParameter Name="Id" ControlID="ProjectList" PropertyName="SelectedValue"
                                    DefaultValue="0" Type="Int32" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                        
                        <asp:DropDownList ID="UserList" runat="server" AutoPostBack="True" 
                            CssClass="username" onselectedindexchanged="UserList_SelectedIndexChanged">
                            
                            </asp:DropDownList>
                    </legend>
                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                    <tr>
                    <td width="30%"> Project:   <td width="30%"> Start Date:   </td>
                      <td width="30%"> End Date:   </td>
                      <td style="text-align:center;" rowspan="3">
                    <asp:Button ID="Button1" runat="server" Text="GO" 
                            onclick="TimeSheet_Click" />
                    </td>
                      </tr>
                       <tr>
                       <td>           
                     <asp:DropDownList ID="AllProjectList" runat="server" AutoPostBack="True" 
                        DataSourceID="ProjectData" Width="170px"
                        DataTextField="Name" DataValueField="Id"  >
                         <asp:ListItem>All</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                   <td style="width:35%;">
                   <asp:TextBox ID="StartDate" runat="server" Width="90px"  onkeypress="return CalendarValidation();"></asp:TextBox> <span>[mm/dd/yyyy]</span>
                 </td>
                  <td style="width:35%;">
                  <asp:TextBox ID="EndDate" runat="server" Width="90px" 
                          ontextchanged="EndDate_TextChanged"  onkeypress="return CalendarValidation();"></asp:TextBox> <span>[mm/dd/yyyy]</span>
                   </td>
                 </tr>
                    <td>&nbsp;</td>
                    <td><asp:RequiredFieldValidator ID="Requiredfieldvalidator4" runat="server" ErrorMessage="Start Date is a required."
                        ControlToValidate="StartDate" Display="Dynamic" 
                        ></asp:RequiredFieldValidator>
                    <asp:CompareValidator id="CompareValidator2" runat="server" Display="Dynamic" ErrorMessage="Date format is incorrect." ControlToValidate="StartDate" Operator="DataTypeCheck" Type="Date" >
                       </asp:CompareValidator></td>
                    <td> <asp:RequiredFieldValidator ID="Requiredfieldvalidator5" runat="server" ErrorMessage=" End Date is a required."
                        ControlToValidate="EndDate" Display="Dynamic" 
                        ></asp:RequiredFieldValidator>
                        <asp:CompareValidator id="CompareValidator3" runat="server" Display="Dynamic" ErrorMessage="Date format is incorrect." ControlToValidate="EndDate" Operator="DataTypeCheck" Type="Date" >
                       </asp:CompareValidator></td>
                   
                    </tr>
                    <tr>
               <td colspan="3" style="text-align:center;">
                <asp:Label ID="dateCompare" ForeColor="red" Visible="false" runat="server"></asp:Label>
               </td>
               </tr>
                    </table>
                    <br />
                    Total Time Duration is:<asp:Label ID="totalhours" runat="server"></asp:Label>
                    <br /><br />
                    <asp:ObjectDataSource ID="ProjectListDataSource" runat="server" TypeName="ASPNET.StarterKit.BusinessLogicLayer.TimeEntry"
                        SelectMethod="GetTimeEntriesByUserNameProjectIdAndDates" 
                        DeleteMethod="DeleteTimeEntry" UpdateMethod="UpdateTimeEntry">
                        <DeleteParameters>
                            <asp:Parameter Name="Id" Type="Int32" />
                        </DeleteParameters>
                        <SelectParameters>
                            <asp:ControlParameter Name="userName" ControlID="UserList" PropertyName="SelectedValue"
                                Type="String" />
                            <asp:ControlParameter Name="projectId" ControlID="AllProjectList" PropertyName="SelectedValue"
                                DefaultValue="0" Type="String" />
                            <asp:ControlParameter Name="startingDate" Type="DateTime" ControlID="StartDate" />
                            <asp:ControlParameter Name="endDate" Type="DateTime" ControlID="EndDate" />
                        </SelectParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="Id" Type="Int32" />
                            <asp:Parameter Name="Description" Type="String" />
                            <asp:Parameter Name="Duration" Type="Decimal" />
                            <asp:Parameter Name="ReportedDate" Type="DateTime" />
                           <asp:ControlParameter Name="UserName" ControlID="UserList" PropertyName="SelectedValue"
                                Type="String" />
                        </UpdateParameters>
                    </asp:ObjectDataSource>
                    <asp:GridView ID="ProjectListGridView" runat="server" CssClass="timeentry-edit"
                        DataSourceID="ProjectListDataSource" AutoGenerateColumns="False" 
                        AllowSorting="True" BorderWidth="0px" ShowFooter="True" 
                        BorderStyle="None" Width="100%" CellPadding="2" DataKeyNames="Id" 
                                        OnRowDataBound ="ProjectListGridView_RowDataBound" 
                                        OnRowDeleting="ProjectListGridView_RowDeleting" 
                                        OnRowUpdated="ProjectListGridView_RowUpdated" AllowPaging="True" 
                                        
                        onselectedindexchanged="ProjectListGridView_SelectedIndexChanged" 
                        PageSize="8" >
                        <Columns>
                            <asp:BoundField DataField="ProjectName" HeaderText="Project Name" ItemStyle-Width="17%"  ReadOnly="true" />
                            <asp:BoundField DataField="CategoryName" HeaderText="Category Name" ItemStyle-Width="18%" 
                                ReadOnly="True" />
                                <asp:BoundField DataField="Reporteddate" HeaderText="Reported Date" ItemStyle-Width="17%" DataFormatString="{0:d-MMM-yyyy}" />
                                <asp:BoundField DataField="Duration" ControlStyle-CssClass="duration" ItemStyle-Width="8%" 
                                HeaderText="Duration" >
<ControlStyle CssClass="duration"></ControlStyle>
                            </asp:BoundField>
                                  <asp:BoundField DataField="Description" HeaderText="Description" ItemStyle-Width="28%" NullDisplayText="Description is a required value" />
                              <asp:CommandField ShowEditButton="True" HeaderText="Edit" ItemStyle-Width="6%" 
                                ItemStyle-HorizontalAlign="Center" ButtonType="Image" EditImageUrl="images/editIcon.gif"
                                UpdateImageUrl="images/icon-save.gif" 
                                CancelImageUrl="images/icon-cancel.gif" >
<ItemStyle HorizontalAlign="Center"></ItemStyle>
                            </asp:CommandField>
                            <asp:CommandField ShowDeleteButton="True" HeaderText="Delete"  ItemStyle-Width="6%"
                                ItemStyle-HorizontalAlign="Center" DeleteImageUrl="images/delete_icon.gif"
                                ButtonType="Image" >
<ItemStyle HorizontalAlign="Center"></ItemStyle>
                            </asp:CommandField>
                            <asp:TemplateField>
                             
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <asp:Label ID="Label10" runat="server" Text="Label">There are no time entries 
                            for this user</asp:Label>
                        </EmptyDataTemplate>
                        <RowStyle CssClass="row1" BorderStyle="None" />
                        <HeaderStyle CssClass="grid-header" HorizontalAlign="Left" />
                        <AlternatingRowStyle CssClass="dark" />
                        
                    </asp:GridView>
                </fieldset>
            </div>
            </div>
        </div>
    
    <div id="MessageView" runat="server" visible="false">
        <div id="projectadministration">
            <fieldset>
                <h2 class="none">
                    Time Sheet for:</h2>
                <legend>Time Sheet For:</legend>
                <center>
                    You do not have any projects assigned to you.
                </center>
            </fieldset>
        </div>
    </div>
</asp:Content>
