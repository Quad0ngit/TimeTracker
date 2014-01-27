<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ViewTimesheet.aspx.cs" Inherits="TimeTracker_ViewTimesheet" MasterPageFile="~/TimeTracker/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="maincontent" runat="Server">

  <script language="javascript" type="text/javascript">
  
  
  </script>
   <div>
         <a name="content_start" id="content_start"></a>
        <fieldset>
          <table cellpadding="0" cellspacing="0" border="0" width="100%">
             <tr>
                <td width="25%" style="height: 15px"> User: </td>
                <td width="25%" style="height: 15px"> Project: </td>
                <td width="25%" style="height: 15px"> Start Date:   </td>
                <td width="25%" style="height: 15px" colspan="2"> End Date:   </td>
               
             </tr>
             <tr>
              <td style="width:22%;">
                 <asp:DropDownList ID="ddlUserList" runat="server" Width="170px"  AutoPostBack="true"
                      onselectedindexchanged="ddlUserList_SelectedIndexChanged">
                 </asp:DropDownList>
              </td>
               <td style="width:22%;">           
                  <asp:DropDownList ID="AllProjectList" runat="server" Width="170px"> 
                  <asp:ListItem Text="Select" Value="0" Selected="True"></asp:ListItem>                                               
                  </asp:DropDownList>
               </td>
               <td style="width:22%;">
                   <asp:TextBox ID="StartDate" runat="server" Width="90px"></asp:TextBox> <span>
                   [mm/dd/yyyy]</span>
               </td>
               <td style="width:22%;" align="left">
                  <asp:TextBox ID="EndDate" runat="server" Width="90px"  ontextchanged="EndDate_TextChanged"></asp:TextBox><span>
                   [mm/dd/yyyy]</span>
               </td>
                <td style="text-align:center;" rowspan="3" width="10%">
                   <asp:Button ID="Button1" runat="server" Text="GO" onclick="TimeSheet_Click" />
                </td>
             </tr>
             <tr>
              <td><asp:RequiredFieldValidator ID="Requiredfieldvalidator2" runat="server" ErrorMessage="user is a required."
                ControlToValidate="ddlUserList" Display="Dynamic" InitialValue="0"></asp:RequiredFieldValidator></td>
              <td><asp:RequiredFieldValidator ID="Requiredfieldvalidator1" runat="server" ErrorMessage="Project is a required."
                ControlToValidate="AllProjectList" Display="Dynamic" InitialValue="0"></asp:RequiredFieldValidator></td>
              <td>
                <asp:RequiredFieldValidator ID="Requiredfieldvalidator4" runat="server" ErrorMessage="Start Date is a required."
                ControlToValidate="StartDate" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:CompareValidator id="CompareValidator2" runat="server" Display="Dynamic" ErrorMessage="Date format is incorrect." ControlToValidate="StartDate" Operator="DataTypeCheck" Type="Date" >
                   </asp:CompareValidator>
              </td>
              <td> 
                <asp:RequiredFieldValidator ID="Requiredfieldvalidator5" runat="server" ErrorMessage=" End Date is a required." ControlToValidate="EndDate" Display="Dynamic" ></asp:RequiredFieldValidator>
                 <asp:CompareValidator id="CompareValidator3" runat="server" Display="Dynamic" ErrorMessage="Date format is incorrect." ControlToValidate="EndDate" Operator="DataTypeCheck" Type="Date" >
                </asp:CompareValidator>
              </td>
             </tr>
             <tr>
               <td colspan="3" style="text-align:center;">
                <asp:Label ID="dateCompare" ForeColor="red" Visible="false" runat="server"></asp:Label>
               </td>
             </tr>
          </table>
          <br />
          Total Time Duration is:&nbsp;<b><asp:Label ID="totalhours" runat="server"></asp:Label></b>
          <br /><br />
            <asp:Label ID="lblMsg" runat="server" Text="There are no time entries  for this user" Visible="false"></asp:Label>
                           
          <asp:GridView ID="ProjectListGridView" runat="server" CssClass="timeentry-edit"
                        AutoGenerateColumns="False" 
                        AllowSorting="True" BorderWidth="0px" ShowFooter="True" 
                        BorderStyle="None" Width="100%" CellPadding="2" DataKeyNames="Id" 
                                        OnRowDataBound ="ProjectListGridView_RowDataBound"
                                       AllowPaging="True"  Visible="false"
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
                            <asp:BoundField DataField="Description" HeaderText="Description" ItemStyle-Width="28%" />
                              <asp:CommandField ShowEditButton="True" HeaderText="Edit" ItemStyle-Width="6%"  Visible="false"
                                ItemStyle-HorizontalAlign="Center" ButtonType="Image" EditImageUrl="images/editIcon.gif"
                                UpdateImageUrl="images/icon-save.gif" 
                                CancelImageUrl="images/icon-cancel.gif" >
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                            </asp:CommandField>
                            <asp:CommandField ShowDeleteButton="True" HeaderText="Delete"  ItemStyle-Width="6%"  Visible="false"
                                ItemStyle-HorizontalAlign="Center" DeleteImageUrl="images/delete_icon.gif"
                                ButtonType="Image" >
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                            </asp:CommandField>
                            <asp:TemplateField>                             
                            </asp:TemplateField>
                        </Columns>
                         <RowStyle CssClass="row1" BorderStyle="None" />
                        <HeaderStyle CssClass="grid-header" HorizontalAlign="Left" />
                        <AlternatingRowStyle CssClass="dark" />
                    </asp:GridView>
        </fieldset>
   </div>
  </asp:Content>
