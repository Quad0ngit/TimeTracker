<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Report_Client_Result.aspx.cs" Inherits="TimeTracker_Report_Client_Result" MasterPageFile="~/TimeTracker/MasterPage.master" %>
 
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
          <%--  <asp:ObjectDataSource ID="ProjectReportData" runat="server" TypeName="ASPNET.StarterKit.BusinessLogicLayer.Project"
                SelectMethod="GetProjectByIdsAndDates">
                <SelectParameters>
                    <asp:SessionParameter Name="ProjectIds" SessionField="SelectedProjectIds" Type="String" />
                    <asp:SessionParameter Name="startDate" SessionField="SelectedStartingDate" Type="DateTime" />
                    <asp:SessionParameter Name="endDate" SessionField="SelectedEndDate" Type="DateTime" />
                </SelectParameters>
            </asp:ObjectDataSource>--%>
            <asp:DataList ID="ProjectList" RepeatColumns="1" RepeatDirection="Vertical" runat="server">
                <HeaderStyle CssClass="header-gray" />
                <HeaderTemplate>
                                <table cellspacing="0" cellpadding="0" width="100%" border="0" class="project_main_list">                                    
                                    <tr>
                                        <th class="report-header" style="width:20%;">
                                            Beginning Date</th>
                                        <th style="width:80%;" class="report-header">
                                            Ending Date</th>
                                    </tr>
                                    <tr>
                                        <td class="report-text">
                                            <asp:Label ID="StartingDate" runat="server" Text='<%# Session["SelectedStartingDate"] %>' />
                                        </td>
                                        <td class="report-text">
                                            <asp:Label ID="EndingDate" runat="server" Text='<%# Session["SelectedEndDate"]  %>' />
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
                                   SelectMethod="GetUserReportsByProjectIdsAndDates">
                                        <SelectParameters>
                                          <%--  <asp:SessionParameter Name="ProjectIds" SessionField="SelectedProjectIds" Type="String" />--%>
                                         <%-- <asp:Parameter Name="ProjectIds" Type="String" />--%>
                                          <asp:SessionParameter Name="ProjectIds" SessionField="SelectedProjectIds" Type="String" />
                                          <asp:SessionParameter Name="startDate" SessionField="SelectedStartingDate" Type="DateTime" />
                                           <asp:SessionParameter Name="endDate" SessionField="SelectedEndDate" Type="DateTime" />
                                          <%--<asp:Parameter Name="StartDate" Type="DateTime" />
                                          <asp:Parameter Name="EndDate" Type="DateTime" />--%>
                                        </SelectParameters>
                               </asp:ObjectDataSource>
                                <asp:DataList ID="EntryList" CssClass="report_project" Width="100%" 
                                    DataSourceID="UserReportData" runat="server" 
                                    OnDataBinding="EntryListDataBinding">
                                    <HeaderTemplate>
                                        <table border="0" cellpadding="0" cellspacing="0" class="Content" width="100%">
                                            <tr>
                                                <td valign="top" align="left" class="report-header">Category</td>
                                                <td valign="top" align="left" class="report-header">User Name</td>                                                   
                                                <td valign="top" align="left" class="report-header">Worked Hours</td>     
                                            </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                             <td valign="top" class="report-text" align="left" style="width:30%;">
                                                <!-- Add Hyperlink here00 -->
                                                <span class="consultant_name"><asp:Label Text='<%#Eval("Category")%>' ID="Category" runat="server"></asp:Label></span>                                                
                                            </td>
                                            <td valign="top" class="report-text" align="left" style="width:30%;">
                                                <!-- Add Hyperlink here00 -->
                                                  <span class="consultant_name"><asp:Label Text='<%#Eval("UserName")%>' ID="UserName" runat="server"></asp:Label></span>                                                
                                            </td>
                                            <td valign="top" class="report-text" align="left" style="width:70%;">
                                              <asp:Label Text='<%#Eval("ActualDuration")%>' ID="ActualDuration" runat="server"></asp:Label>                                                                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        </table>
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
