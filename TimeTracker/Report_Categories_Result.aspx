<%@ Page Language="C#" MasterPageFile="~/TimeTracker/MasterPage.master" CodeFile="Report_Categories_Result.aspx.cs"
    Inherits="Report_Categories_Result_aspx" Title="Quadone - Time Tracker - Project Report" Culture="auto" UICulture="auto" %>
<asp:Content ID="Content1" ContentPlaceHolderID="maincontent" runat="Server">
    <div id="projectreport">
        <a name="content_start" id="content_start"></a>
        <fieldset>
            <h2 class="none">
                Category Report</h2>
            <legend>Category Report</legend>
            <asp:Label ID="NoData" runat="server" CssClass="header-gray" Visible="False">
            No Data Retrieved.
            </asp:Label>
            <asp:ObjectDataSource ID="ProjectReportData" runat="server" TypeName="ASPNET.StarterKit.BusinessLogicLayer.Category"
              SelectMethod="GetCategoriesBycategoryIds" >
                <SelectParameters>
                    <asp:SessionParameter Name="CategoryIds" 
                         Type="string" SessionField="SelectedCategories" />
                </SelectParameters>
            </asp:ObjectDataSource>
                <asp:DataList ID="ProjectList" RepeatColumns="1" RepeatDirection="Vertical" runat="server"
                DataSourceID="projectReportData" OnItemCreated="OnCategoryListItemCreated"  Width="30%">
               <HeaderStyle CssClass="header-gray" />
                <HeaderTemplate>
                                <table cellspacing="0" cellpadding="0" width="100%" border="0" class="project_main_list">                                   
                                    <tr>
                                        <th class="report-header" style="width:55%;">
                                            Beginning Date</th>
                                        <th style="width:45%;" class="report-header">
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
                    <table border="0" cellpadding="0" cellspacing="0" class="Content" width="100%">
                     <tr>
                            <td valign="top" style="padding:0;">
                                <h1><%# Eval("Name")%></h1>
                               </td>
                        </tr>
                        <tr>
                            <td valign="top" style="padding:0;" colspan="2">
                               <asp:ObjectDataSource ID="CategoryReportData" runat="server" TypeName="ASPNET.StarterKit.BusinessLogicLayer.UserReport"
                                   SelectMethod="GetCategoryReportsByCategoryIdsAndDates">
                                        <SelectParameters>
                                          <%--  <asp:SessionParameter Name="ProjectIds" SessionField="SelectedProjectIds" Type="String" />--%>
                                          <asp:Parameter Name="CategoryIds" Type="String" />
                                          <asp:SessionParameter Name="startDate" SessionField="SelectedStartingDate" Type="DateTime" />
                                           <asp:SessionParameter Name="endDate" SessionField="SelectedEndDate" Type="DateTime" />
                                           <asp:SessionParameter Name="ProjectIds" SessionField="SelectedProjectIds" Type="String" />
                                          <%--<asp:Parameter Name="StartDate" Type="DateTime" />
                                          <asp:Parameter Name="EndDate" Type="DateTime" />--%>
                                        </SelectParameters>
                               </asp:ObjectDataSource>
                                <asp:DataList ID="EntryList" CssClass="report_project" Width="100%" 
                                    DataSourceID="CategoryReportData" runat="server" 
                                    OnDataBinding="EntryListDataBinding" onpOnPreRender="ShowFooter_OnPreRender" ShowFooter="false">
                                   <HeaderTemplate>
                                        <table border="0" cellpadding="0" cellspacing="0" class="Content  project_main_list" width="100%">
                                            <tr>
                                               <th style="width:35%">User Name</th>
                                                <th style="width:65%">Worked Hours</th>
                                            </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>    
                                            <td valign="top" class="report-text" align="left" style="width:30%;">
                                                <!-- Add Hyperlink here00 -->
                                                  <span class="consultant_name"><asp:Label Text='<%#Eval("UserName")%>' ID="UserName" runat="server"></asp:Label></span>
                                                
                                            </td>
                                            <td valign="top" class="report-text" align="left" style="width:70%;">
                                                Worked Hours : <asp:Label Text='<%#Eval("ActualDuration")%>' ID="ActualDuration" runat="server"></asp:Label> 
                                               
                                            </td>
                                       </tr>
                                     </ItemTemplate>
                                      <FooterTemplate>
                                      <br />
                                       &nbsp;<asp:Label ID="ApplicationEmptyLB" runat="server" Visible="true"  Text="No Record Found!" CssClass="nodata"></asp:Label>
                                       </FooterTemplate>
                                     <%--<FooterTemplate>
                                     <asp:Label Visible='<%#bool.Parse((EntryList.Items.Count==0).ToString())%>' runat="server" ID="lblNoRecord" Text="No Record Found!"></asp:Label>
                                     </FooterTemplate>--%>
                                </asp:DataList>
                                
                                </td>
                                </tr>
                           </table>
                           </ItemTemplate>
                           </asp:DataList>
                           </fieldset>
                           </div>
                           </asp:Content>
                                        