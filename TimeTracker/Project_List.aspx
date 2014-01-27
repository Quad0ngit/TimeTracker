<%@ Page Language="C#" MasterPageFile="~/TimeTracker/MasterPage.master" CodeFile="Project_List.aspx.cs"
    Inherits="Project_List_aspx" Title="Quadone - Time Tracker - List of Projects"
    Culture="auto" UICulture="auto" %>
<asp:Content ID="Content1" ContentPlaceHolderID="maincontent" runat="Server">
      <script language="javascript" type="text/javascript">
        $(document).ready(function () {
            $('#tabs').tabs({
                activate: function () {
                    var newIdx = $('#tabs').tabs('option', 'active');
                    $('#<%=hidLastTab.ClientID%>').val(newIdx);

                }, heightStyle: "auto",
                active: previouslySelectedTab,
                show: { effect: "fadeIn", duration: 1000 }
            });

        });
    </script>
  
	   
            <div id="projectadministration">
        <a name="content_start" id="content_start"></a>
        <fieldset>
            <!-- add H2 here and hide it with css since you can not put h2 inside a legend tag -->
            <h2 class="none">Projects List</h2>
               
            <legend>Projects List</legend>  
            
              <div style="width:900px; margin:0 auto">
              <div id="tabs" style="margin:0 auto;  margin-bottom:2px;">
              <ul>
                 <li><a href="#tabs-1">Open Projects</a></li>
                 <li><a href="#tabs-2">Completed Projects</a></li>
             </ul>          
             <div id="tabs-1">
                <asp:ObjectDataSource ID="ProjectData" runat="server" TypeName="ASPNET.StarterKit.BusinessLogicLayer.Project"
                    DeleteMethod="DeleteProject" OldValuesParameterFormatString="{0}">
                    <DeleteParameters>
                        <asp:Parameter Name="Id" Type="Int32" />
                    </DeleteParameters>
                </asp:ObjectDataSource>
                <asp:GridView ID="ListAllProjects" DataSourceID="ProjectData"  AutoGenerateColumns="False" DataKeyNames="Id"
                AllowSorting="true" BorderWidth="0" runat="server" BorderStyle="None" Width="100%" CssClass="project_list_main"
                CellPadding="2" PageSize="15" BorderColor="White" AllowPaging="true" OnRowDataBound ="ListAllProjects_RowDataBound" OnRowDeleting="ListAllProjects_RowDeleting">
                <Columns>
                    <asp:TemplateField>
                        <HeaderTemplate>
                            S.No.</HeaderTemplate>
                        <ItemTemplate>
                        <asp:Label ID="lblSRNO" runat="server" 
                             Text='<%#Container.DataItemIndex+1 %>'></asp:Label>
                        </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField >
                        <ItemTemplate>
                         <asp:HiddenField ID="id" runat="server" Value='<%# Eval("ID") %>' />
                        </ItemTemplate>
                        </asp:TemplateField>
                    <asp:BoundField DataField="Name" HeaderText="Project Name" SortExpression="Name" />
                    <asp:BoundField DataField="ManagerUserName" HeaderText="Project Manager" SortExpression="ManagerUserName" />
                    <asp:BoundField DataField="Description" HeaderText="Description" SortExpression="Description" />
                    <asp:BoundField DataField="CompletionDate" HeaderText="Estimate Completion" DataFormatString="{0:d-MMM-yyyy}" SortExpression="CompletionDate" />                       
                  <asp:BoundField DataField="DevelopmentEstimateDuration" HeaderText="Development Duration" SortExpression="DevEstimateDuration"  Visible="false"   />
                  <asp:BoundField DataField="TestingEstimateDuration" HeaderText="Testing Duration" SortExpression="TestingEstimateDuration" Visible="false" />
                  <asp:BoundField DataField="DesignEstimateDuration" HeaderText="Designing Duration" SortExpression="DesignEstimateDuration" Visible="false" />
                  <asp:BoundField DataField="BAEstimateDuration" HeaderText="BA Duration" SortExpression="BAEstimateDuration" Visible="false"  />
                  <asp:BoundField DataField="ProjectManagementEstimateDuration" HeaderText="Project Management Duration" SortExpression="PMEstimateDuration" Visible="false" />
                  <asp:BoundField DataField="OtherDuration" HeaderText="Other Duration" SortExpression="OtherEstimateDuration" Visible="false" />
                  <asp:BoundField DataField="EstimateDuration" HeaderText="Estimate Duration" SortExpression="EstimateDuration" />
                  <asp:TemplateField HeaderText="Edit" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                    <asp:ImageButton ID="EditProject" ButtonType="Image"  ImageUrl="images/editIcon.gif" runat="server" ItemStyle-HorizontalAlign="Left" OnClick="EditProject_click" />
                    </ItemTemplate>
                    </asp:TemplateField>
                    <%--<asp:HyperLinkField  HeaderText="Edit Project" DataNavigateUrlFields="Id" DataNavigateUrlFormatString="Project_Details.aspx?ProjectId={0}" 
                        Text="Edit..." >
                   
                    </asp:HyperLinkField >--%>
                       
                    <asp:CommandField ShowDeleteButton="True" HeaderText="Completed" DeleteImageUrl="images/icon-delete.png" ItemStyle-HorizontalAlign="Center" ButtonType="Image" />
                </Columns>
                <RowStyle HorizontalAlign="Left" CssClass="row1" />
                <HeaderStyle CssClass="grid-header" HorizontalAlign="Left" />
                <AlternatingRowStyle CssClass="dark" />
                <EmptyDataTemplate>
                    <asp:Label ID="Label10" runat="server" Text="Label">There are not projects assigned to you</asp:Label>
                </EmptyDataTemplate>
            </asp:GridView>            
            </div>
            <div id="tabs-2">
                 <asp:ObjectDataSource ID="ClosedProjectData" runat="server" TypeName="ASPNET.StarterKit.BusinessLogicLayer.Project"
                    DeleteMethod="DeleteProject" OldValuesParameterFormatString="{0}">
                    <DeleteParameters>
                        <asp:Parameter Name="Id" Type="Int32" />
                    </DeleteParameters>
                </asp:ObjectDataSource>
                <asp:GridView ID="ListAllClosedProjects" DataSourceID="ClosedProjectData"  
                     AutoGenerateColumns="False" DataKeyNames="Id"
                AllowSorting="True" BorderWidth="0px" runat="server" BorderStyle="None" 
                     Width="100%" CssClass="project_list_main" 
                CellPadding="2" PageSize="15" BorderColor="White" AllowPaging="True" 
                     OnRowDataBound ="ListAllClosedProjects_RowDataBound" 
                     OnRowDeleting="ListAllClosedProjects_RowDeleting">
                <Columns>
                    <asp:CommandField ShowDeleteButton="false" />
                    <asp:TemplateField>
                        <HeaderTemplate>
                            S.No.</HeaderTemplate>
                        <ItemTemplate>
                        <asp:Label ID="lblSRNO" runat="server" 
                             Text='<%#Container.DataItemIndex+1 %>'></asp:Label>
                        </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField >
                        <ItemTemplate>
                         <asp:HiddenField ID="id" runat="server" Value='<%# Eval("ID") %>' />
                        </ItemTemplate>
                        </asp:TemplateField>
                    <asp:BoundField DataField="Name" HeaderText="Project Name" SortExpression="Name" />
                    <asp:BoundField DataField="ManagerUserName" HeaderText="Project Manager" SortExpression="ManagerUserName" />
                    <asp:BoundField DataField="Description" HeaderText="Description" SortExpression="Description" />
                    <asp:BoundField DataField="CompletionDate" HeaderText="Estimate Completion" DataFormatString="{0:d-MMM-yyyy}" SortExpression="CompletionDate" />                       
                  <asp:BoundField DataField="DevelopmentEstimateDuration" HeaderText="Development Duration" SortExpression="DevEstimateDuration"  Visible="false"   />
                  <asp:BoundField DataField="TestingEstimateDuration" HeaderText="Testing Duration" SortExpression="TestingEstimateDuration" Visible="false" />
                  <asp:BoundField DataField="DesignEstimateDuration" HeaderText="Designing Duration" SortExpression="DesignEstimateDuration" Visible="false" />
                  <asp:BoundField DataField="BAEstimateDuration" HeaderText="BA Duration" SortExpression="BAEstimateDuration" Visible="false"  />
                  <asp:BoundField DataField="ProjectManagementEstimateDuration" HeaderText="Project Management Duration" SortExpression="PMEstimateDuration" Visible="false" />
                  <asp:BoundField DataField="OtherDuration" HeaderText="Other Duration" SortExpression="OtherEstimateDuration" Visible="false" />
                  <asp:BoundField DataField="EstimateDuration" HeaderText="Estimate Duration" SortExpression="EstimateDuration" />
                  <asp:TemplateField HeaderText="Edit" ItemStyle-HorizontalAlign="Center" Visible="false">
                    <ItemTemplate>
                    <asp:ImageButton ID="EditProject" ButtonType="Image"  ImageUrl="images/editIcon.gif" runat="server" ItemStyle-HorizontalAlign="Left" OnClick="EditProject_click" />
                    </ItemTemplate>
                    </asp:TemplateField>
                    <%--<asp:HyperLinkField  HeaderText="Edit Project" DataNavigateUrlFields="Id" DataNavigateUrlFormatString="Project_Details.aspx?ProjectId={0}" 
                        Text="Edit..." >
                   
                    </asp:HyperLinkField >--%>
                       
                    </Columns>
                <RowStyle HorizontalAlign="Left" CssClass="row1" />
                <HeaderStyle CssClass="grid-header" HorizontalAlign="Left" />
                <AlternatingRowStyle CssClass="dark" />
                <EmptyDataTemplate>
                    <asp:Label ID="Label10" runat="server" Text="Label">There are not projects assigned to you</asp:Label>
                </EmptyDataTemplate>
            </asp:GridView>
            
            </div>
            </div>
            </div>            
            <br />
            <asp:Button ID="CreateProject" runat="server" Text="Create new project" OnClick="Button_Click" />
        </fieldset>
    </div>
        
         <asp:HiddenField ID="hidLastTab" Value="0" runat="server" />
        
</asp:Content>
