
<%@ Page Language="C#" MasterPageFile="~/TimeTracker/MasterPage.master" CodeFile="Report_Resources_ResultByMonth.aspx.cs"
    Inherits="Report_Resources_ResultByMonth_aspx" Title="Quadone - Time Tracker - Resource Reports" Culture="auto" UICulture="auto" EnableEventValidation="false"  %>
<asp:Content ID="Content1" ContentPlaceHolderID="maincontent" runat="Server">

    <script type="text/javascript" >
    function HideExcel() { 
    
    }

</script>
    <div id="projectreport">
        <a name="content_start" id="content_start"></a>
        <fieldset>
            <h2 class="none">
                Resources Report</h2>
            <legend>Resources Report</legend>
            
            <asp:ObjectDataSource ID="UserReportData" runat="server" TypeName="ASPNET.StarterKit.BusinessLogicLayer.UserTotalDurationReport"
                SelectMethod="GetUserReportsByUserNamesAndMonthAndYear">
                <SelectParameters>
                    <asp:SessionParameter Name="userNames" SessionField="SelectedUserNames" Type="String" />
                    <asp:SessionParameter Name="Month" SessionField="SelectedMonthValue" Type="Int32" />
                    <asp:SessionParameter Name="Year" SessionField="SelectedYear" Type="Int32" />
                    <asp:SessionParameter Name="ProjectId" SessionField="SelectedProjectId" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
             <div id="ExportResources"  align="right">
             <asp:Label ID="lblexportres" runat="server" ForeColor="Blue" Text="Export To -" Visible="false" ></asp:Label>
             <asp:ImageButton ID="lnkexportResources" CssClass="lnkexport" runat="server"  ImageUrl="images/btn_Excel.gif"  ToolTip="Export To ExcelSheet"  onclick="lnkexportResources_Click" />
             </div>
            <table class="tan-border" cellspacing="0" cellpadding="0" width="100%" border="0">
                <tr valign="top">
                    <td style="padding:0">
                        <asp:Label ID="NoData" runat="server" Visible="False" CssClass="header-gray">
                        No Data Retrieved.
                        </asp:Label>
                        <asp:DataList ID="UserList" runat="server" Width="100%" DataSourceID="UserReportData"
                            OnItemCreated="OnListUserTimeEntriesItemCreated">
                            <HeaderTemplate>
                                <table cellspacing="0" cellpadding="0" width="100%" border="0" class="project_main_list">
                                    <tr>
                                        <th class="report-header" style="width:20%;">
                                            Month</th>
                                        <th style="width:80%;" class="report-header">
                                            Year</th>
                                    </tr>
                                    <tr>
                                        <td class="report-text">
                                            <asp:Label ID="StartingDate" runat="server" Text='<%# Session["SelectedMonth"] %>' />
                                        </td>
                                        <td class="report-text">
                                            <asp:Label ID="EndingDate" runat="server" Text='<%# Session["SelectedYear"]  %>' />
                                        </td>
                                    </tr>
                                </table>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <div class="report_list_main" style="padding:10px 0px;">
                                    <div class="user-details">
                                        <span class="consultant_name">UserName :
                                        <asp:Label ID="UserNameLabel" runat="server" Text='<%# Eval("UserName") %>' /></span><br />
                                        <span class="consultant_name">Total Duration Worked :
                                        <asp:Label ID="TotalDurationLabel" runat="server" Text='<%# Eval("TotalDuration") %>' /></span>                              
                                   </div>
                              <table cellspacing="0" cellpadding="0" width="100%" border="0" id="tblresourceitems">
                                    <tr>
                                        <td>
                                            <asp:ObjectDataSource ID="TimeEntryData"  runat="server" TypeName="ASPNET.StarterKit.BusinessLogicLayer.TimeEntry"
                                                SelectMethod="GetTimeEntriesByUserNameProjectIdAndMonthAndYear">
                                                <SelectParameters>
                                                    <asp:Parameter Name="userName" Type="string" />
                                                    <asp:SessionParameter Name="ProjectId" SessionField="SelectedProjectId" Type="String" />
                                                     <asp:SessionParameter Name="Month" SessionField="SelectedMonthValue" Type="Int32" />
                                                    <asp:SessionParameter Name="Year" SessionField="SelectedYear" Type="Int32" />
                                                </SelectParameters>
                                            </asp:ObjectDataSource>
                                            <asp:GridView ID="ListUserTimeEntries" CssClass="project_main_list" 
                                                DataSourceID="TimeEntryData" DataKeyNames="Id"
                                                AutoGenerateColumns="False" AllowSorting="True" BorderWidth="0px" 
                                                runat="server" BorderStyle="None" Width="100%" CellPadding="0"
                                                onpageindexchanging="ListUserTimeEntries_PageIndexChanging">
                                                <HeaderStyle CssClass="grid-header" HorizontalAlign="Left" />
                                                <AlternatingRowStyle CssClass="dark" />
                                                <RowStyle HorizontalAlign="Left" ForeColor="Gray" />
                                                <Columns>
                                                    <asp:BoundField DataField="ReportedDate" HeaderText="Reported Date" DataFormatString="{0:d-MMM-yyyy}" />
                                                    <asp:BoundField DataField="ProjectName" HeaderText="Project Name"  />
                                                    <asp:BoundField DataField="CategoryName" HeaderText="Category Name" />
                                                    <asp:BoundField DataField="Duration" HeaderText="Duration" />
                                                    <asp:BoundField DataField="Description" HeaderText="Description" />
                                                </Columns>
                                                <EmptyDataTemplate>
                                                <asp:Label ID="Label10" runat="server" Text="Label">There are no time entries for this user</asp:Label>
                                                </EmptyDataTemplate>
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                </table>
                                </div>
                            </ItemTemplate>
                        </asp:DataList>
                    </td>
                    <td>
                     
                    </td>
                </tr>
            </table>
        </fieldset>
    </div>
</asp:Content>

