
<%@ Page Language="C#" MasterPageFile="~/TimeTracker/MasterPage.master" CodeFile="Report_Project_ResultByMonth.aspx.cs"
    Inherits="Report_Project_ResultByMonth_aspx" Title="Quadone - Time Tracker - Project Report" Culture="auto" UICulture="auto" %>
<asp:Content ID="Content1" ContentPlaceHolderID="maincontent" runat="Server">
    <div id="projectreport">
        <a name="content_start" id="content_start"></a>
        <fieldset>
            <h2 class="none">
                Project Report</h2>
            <legend>Project Report</legend>
            <asp:Label ID="NoData" runat="server" CssClass="header-gray" Visible="False">
            No Data Retrieved.
            </asp:Label>
            <asp:ObjectDataSource ID="ProjectReportData" runat="server" TypeName="ASPNET.StarterKit.BusinessLogicLayer.Project"
                SelectMethod="GetProjectReportByIdsAndMonthAndYear">
                <SelectParameters>
                    <asp:SessionParameter Name="ProjectIds" SessionField="SelectedProjectIds" Type="String" />
                    <asp:SessionParameter Name="Month" SessionField="SelectedMonthValue" Type="Int32" />
                    <asp:SessionParameter Name="Year" SessionField="SelectedYear" Type="Int32" />
                </SelectParameters>
            </asp:ObjectDataSource>
            <asp:DataList ID="ProjectList" RepeatColumns="1" RepeatDirection="Vertical" runat="server"
                DataSourceID="projectReportData" OnItemCreated="OnProjectListItemCreated">
               
                <HeaderStyle CssClass="header-gray" />
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
                    <table border="0" cellpadding="0" cellspacing="0" class="Content project_main_list" width="100%">
                        <tr>
                            <td valign="top" style="padding:0;">
                                <table border="0" cellpadding="0" cellspacing="0" class="Content" width="100%">
                                    <tr>
                                        <td width="180" class="report-main-header">
                                            Project Name</td>
                                        <td width="70" align="right" class="report-main-header">
                                            Est. Hours</td>
                                        <td width="100" align="right" class="report-main-header">
                                            Actual Hours</td>
                                        <td width="100" align="right" class="report-main-header">
                                            Est. Completion</td>
                                    </tr>
                                    <tr>
                                        <td class="report-text project_name" >
                                            <%# Eval("Name") %>
                                        </td>
                                        <td class="report-text" align="center">
                                            <%# Eval("EstimateDuration") %>
                                        </td>
                                        <td class="report-text" align="center">
                                            <%# Eval("ActualDuration") %>
                                        </td>
                                        <td class="report-text" align="center">
                                            <%# Eval("CompletionDate", "{0:d}") %>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" style="padding:0;">
                               <asp:ObjectDataSource ID="UserReportData" runat="server" TypeName="ASPNET.StarterKit.BusinessLogicLayer.UserReport"
                                   SelectMethod="GetUserReportsByProjectIdsAndMonthAndYear">
                                        <SelectParameters>
                                          <asp:SessionParameter Name="ProjectIds" SessionField="SelectedProjectIds" Type="String" />
                                          <asp:SessionParameter Name="Month" SessionField="SelectedMonthValue" Type="Int32" />
                                          <asp:SessionParameter Name="Year" SessionField="SelectedYear" Type="Int32" />
                                        </SelectParameters>
                               </asp:ObjectDataSource>
                                <asp:DataList ID="EntryList" CssClass="report_project" Width="100%" 
                                    DataSourceID="UserReportData" runat="server" 
                                    OnDataBinding="EntryListDataBinding">
                                    <HeaderTemplate>
                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tr>
                                                <th valign="top" align="left" class="report-header">Category</th>
                                                <th valign="top" align="left" class="report-header">User Name</th>                                                   
                                                <th valign="top" align="left" class="report-header">Worked Hours</th>                                                   
                                            </tr>
                                         </table>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <table>
                                        <tr>
                                            <td valign="top" class="report-text" align="left" style="width:30%;">
                                                <!-- Add Hyperlink here00 -->
                                                <asp:Label Text='<%#Eval("Category")%>' ID="Category" runat="server"></asp:Label>
                                           
                                            </td>
                                            <td valign="top" class="report-text" align="left" style="width:30%;">
                                                <!-- Add Hyperlink here00 -->
                                             <asp:Label Text='<%#Eval("UserName")%>' ID="UserName" runat="server"></asp:Label>
                                                
                                            </td>
                                            <td valign="top" class="report-text" align="left" style="width:40%;">
                                            <asp:Label Text='<%#Eval("ActualDuration")%>' ID="ActualDuration" runat="server"></asp:Label> 
                                            </td>
                                        </tr>
                                        </table>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <%--<asp:Label Visible='<%#bool.Parse((UserReportData.Items.Count==0).ToString())%>' runat="server" ID="lblNoRecord" Text="No Record Found!"></asp:Label>                                    --%>
                                    </FooterTemplate>
                                </asp:DataList>
                            </td>
                        </tr>
                    </table>
                </ItemTemplate>
            </asp:DataList>
        </fieldset>
    </div>
</asp:Content>
