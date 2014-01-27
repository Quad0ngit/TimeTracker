<%@ Page Language="C#" MasterPageFile="~/TimeTracker/MasterPage.master" CodeFile="Project_Details.aspx.cs"
    Inherits="Project_Details_aspx" Title="Quadone - Time Tracker - Manage Projects"  EnableEventValidation="false" Culture="auto" UICulture="auto" %>
<asp:Content ID="Content1" ContentPlaceHolderID="maincontent" runat="Server">
        <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />
        <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
        <script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
        <link rel="stylesheet" href="/resources/demos/style.css" />
    <script type="text/javascript">
        $(function() {
            var date = new Date();
            var currentMonth = date.getMonth();
            var currentDate = date.getDate();
            var currentYear = date.getFullYear();
            $("[id*=EstimatedDate]").datepicker({
            minDate: new Date(currentYear, currentMonth, currentDate)}
             );
        });

        function validate() {
            var DevHrs = $("#<%=txtDevHours.ClientID %>").val();
            var TestingHrs = $("#<%=txtTestingHrs.ClientID %>").val();
            var DesignHrs = $("#<%=txtDesignHrs.ClientID %>").val();
            var BAHrs = $("#<%=txtBAHrs.ClientID %>").val();
            var PMHrs = $("#<%=txtProjectHrs.ClientID %>").val();
            var OtherHrs = $("#<%=txtOtherDuration.ClientID %>").val();
            var total = Number(DevHrs) + Number(TestingHrs) + Number(DesignHrs) + Number(BAHrs) + Number(PMHrs) + Number(OtherHrs);
            $("#<%=Duration.ClientID %>").val(total);
            var Duration = $("#<%=Duration.ClientID %>").val();
            $("#<%=hdnDuration.ClientID %>").val(Duration);            
        }

        function TotalHoursCalculate() {
            var DevHrs = $("#<%=txtDevHours.ClientID %>").val();
            var TestingHrs = $("#<%=txtTestingHrs.ClientID %>").val();
            var DesignHrs = $("#<%=txtDesignHrs.ClientID %>").val();
            var BAHrs = $("#<%=txtBAHrs.ClientID %>").val();
            var PMHrs = $("#<%=txtProjectHrs.ClientID %>").val();
            var OtherHrs = $("#<%=txtOtherDuration.ClientID %>").val();
            var total = Number(DevHrs) + Number(TestingHrs) + Number(DesignHrs) + Number(BAHrs) + Number(PMHrs) + Number(OtherHrs);
            //alert(total);
            $("#<%=Duration.ClientID %>").val(total);
            return false;
        }      
    
</script>
    <div id="adminedit">
        <a name="content_start" id="content_start"></a>
        <fieldset class="project_details_main">
            <!-- add H2 here and hide it with css since you can not put h2 inside a legend tag -->
          
           <h2 class="none">
                Project configuration</h2>
            
            <legend>Project configuration</legend><p>Define the project and specify which users
            will be part of the project.Press the SAVE button at the bottom for your configuration
            to take effect.</p>
            <table cellpadding="0" cellspacing="0" border="0" width="100%" class="project_list_main">
            <tr valign="top">
            <td width="30%">
            <div class="formsection">
                Project Information
            </div>
            <p>
            
            
                <asp:Label ID="Label13" runat="server" Text="Label" AssociatedControlID="ddlClientName">Client Name:</asp:Label>
                <br/>
                <asp:DropDownList runat="server" ID="ddlClientName" ></asp:DropDownList>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" SetFocusOnError="true" ControlToValidate="ddlClientName" ErrorMessage="Name is invalid" ValidationExpression="^[0-9a-zA-Z_ @,!#$%^&*()/[]+]*$"  Display="Dynamic"></asp:RegularExpressionValidator>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                    Display="Dynamic" ControlToValidate="ddlClientName" SetFocusOnError="true" ErrorMessage="Client Name is a required value." InitialValue="0">
                </asp:RequiredFieldValidator>
                <br />
            
            
                <asp:Label ID="Label1" runat="server" Text="Label" AssociatedControlID="ProjectName">Project Name:</asp:Label>
                <br/>
                <asp:TextBox ID="ProjectName" runat="server" Width="194px"
                    MaxLength="50"></asp:TextBox>
               <asp:RegularExpressionValidator ID="ValidProjectName" runat="server" SetFocusOnError="true" ControlToValidate="ProjectName" ErrorMessage="Name is invalid" ValidationExpression="^[0-9a-zA-Z_ @,!#$%^&*()/[]+]*$"  Display="Dynamic"></asp:RegularExpressionValidator>
                                    
                <asp:RequiredFieldValidator ID="ProjectNameRequiredfieldvalidator" runat="server"
                    Display="Dynamic" ControlToValidate="ProjectName" SetFocusOnError="true" ErrorMessage="Project Name is a required value.">
                </asp:RequiredFieldValidator>
                <br />
                
                <asp:Label ID="Label2" runat="server" Text="Label" AssociatedControlID="Managers">Project Manager:</asp:Label>
                <br/>
                <asp:ObjectDataSource ID="ManagerData" runat="server" TypeName="System.Web.Security.Roles">
                </asp:ObjectDataSource>
                    
                <asp:DropDownList ID="Managers" runat="server" Width="193px" DataSourceID="ManagerData" />                    
                <asp:RequiredFieldValidator ID="ManagerRequiredFieldValidator" runat="server" Display="Dynamic"
                    ControlToValidate="Managers" ErrorMessage="You must select a manager." SetFocusOnError="true">
                </asp:RequiredFieldValidator>
                <br />
                <asp:Label ID="Label3" runat="server" Text="Label" AssociatedControlID="EstimatedDate">Estimation completion date:</asp:Label>
                <br />
                   <asp:TextBox ID="EstimatedDate" runat="server" ></asp:TextBox>[mm/dd/yyyy]   
                 <br /> 
                <%--<asp:CompareValidator ID="CompletionDateCompareValidator" runat="server" Display="Dynamic"
                    ErrorMessage="Date format is incorrect." Operator="DataTypeCheck" Type="Date"
                    ControlToValidate="EstimatedDate">
                </asp:CompareValidator>--%>
                <asp:RequiredFieldValidator ID="CompletionDateRequiredFieldValidator" runat="server"
                    ControlToValidate="EstimatedDate" ErrorMessage="Est. Date is required."
                    Display="Dynamic" SetFocusOnError="true">
                </asp:RequiredFieldValidator>
                <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToValidate="EstimatedDate"
                    Display="Dynamic" ErrorMessage="Date format is incorrect." Operator="DataTypeCheck"
                    Type="Date" SetFocusOnError="true"></asp:CompareValidator>
                <br />
             <asp:Label ID="Label14" runat="server" Text="Label" AssociatedControlID="chkIsCompleted">Project Status :</asp:Label>
              <br />
                <asp:CheckBox runat="server" ID="chkIsCompleted" Text="Is Completed" />
                <br />
                <asp:Label ID="Label6" runat="server" Text="Development Hours (in hours):" AssociatedControlID="txtDevHours"></asp:Label>
                <br />
               <asp:TextBox ID="txtDevHours" runat="server" Width="49px" Columns="12"  onchange="return TotalHoursCalculate();"></asp:TextBox>
               <asp:CompareValidator ID="DevelopmentHrsCompareValidator" runat="server" ControlToValidate="txtDevHours"
                    ErrorMessage="Development Hours must be integer value." Display="Dynamic" Operator="DataTypeCheck"
                    Type="Double" SetFocusOnError="true">
                </asp:CompareValidator>
                 <asp:RequiredFieldValidator ID="DevelopmentHrsRequiredFieldValidator" runat="server" ControlToValidate="txtDevHours"
                    ErrorMessage="Development Hours is required." Display="Dynamic" SetFocusOnError="true">
                </asp:RequiredFieldValidator>
                 <asp:RangeValidator ID="DevelopmentRangeValidator" runat="server" ErrorMessage="Development Hours is out of range."
                    ControlToValidate="txtDevHours" MaximumValue="99999" MinimumValue="0" Type="Double" SetFocusOnError="true">
                </asp:RangeValidator>
                <br />
                <asp:Label ID="Label8" runat="server" Text="Testing Hours (in hours):" AssociatedControlID="txtTestingHrs"></asp:Label>
                <br />
               <asp:TextBox ID="txtTestingHrs" runat="server" Width="49px" Columns="12"  onchange="return TotalHoursCalculate();" ></asp:TextBox>
               <asp:CompareValidator ID="TestingHrsCompareValidator" runat="server" ControlToValidate="txtTestingHrs"
                    ErrorMessage="Testing Hours must be integer value." Display="Dynamic" Operator="DataTypeCheck"
                    Type="Double" SetFocusOnError="true">
                </asp:CompareValidator>
                 <asp:RequiredFieldValidator ID="TestingHrsRequiredFieldValidator" runat="server" ControlToValidate="txtTestingHrs"
                    ErrorMessage="Testing Hours is required." Display="Dynamic" SetFocusOnError="true">
                </asp:RequiredFieldValidator>
                 <asp:RangeValidator ID="TestingHrsRangeValidator" runat="server" ErrorMessage="Testing Hours is out of range."
                    ControlToValidate="txtTestingHrs" MaximumValue="99999" MinimumValue="0" Type="Double" SetFocusOnError="true">
                </asp:RangeValidator>
                 <br />
                <br />
                <asp:Label ID="Label9" runat="server" Text="Design Hours (in hours):" AssociatedControlID="txtDesignHrs"></asp:Label>
                <br />
               <asp:TextBox ID="txtDesignHrs" runat="server" Width="49px" Columns="12"  onchange="return TotalHoursCalculate();"></asp:TextBox>
               <asp:CompareValidator ID="DesignHrsCompareValidator" runat="server" ControlToValidate="txtTestingHrs"
                    ErrorMessage="Design Hours must be integer value." Display="Dynamic" Operator="DataTypeCheck"
                    Type="Double" SetFocusOnError="true">
                </asp:CompareValidator>
                 <asp:RequiredFieldValidator ID="DesignHrsRequiredFieldValidator" runat="server" ControlToValidate="txtDesignHrs"
                    ErrorMessage="Design Hours is required." Display="Dynamic" SetFocusOnError="true">
                </asp:RequiredFieldValidator>
                 <asp:RangeValidator ID="DesignHrsRangeValidator" runat="server" ErrorMessage="Design Hours is out of range."
                    ControlToValidate="txtDesignHrs" MaximumValue="99999" MinimumValue="0" Type="Double" SetFocusOnError="true">
                </asp:RangeValidator>              
                  <br />
                <asp:Label ID="Label10" runat="server" Text="BA Hours (in hours):" AssociatedControlID="txtBAHrs"></asp:Label>
                <br />
               <asp:TextBox ID="txtBAHrs" runat="server" Width="49px" Columns="12"  onchange="return TotalHoursCalculate();"></asp:TextBox>
               <asp:CompareValidator ID="BAHrsCompareValidator" runat="server" ControlToValidate="txtBAHrs"
                    ErrorMessage="BA Hours must be integer value." Display="Dynamic" Operator="DataTypeCheck"
                    Type="Double" SetFocusOnError="true">
                </asp:CompareValidator>
                 <asp:RequiredFieldValidator ID="BAHrsRequiredFieldValidator" runat="server" ControlToValidate="txtBAHrs"
                    ErrorMessage="BA Hours is required." Display="Dynamic" SetFocusOnError="true">
                </asp:RequiredFieldValidator>
                 <asp:RangeValidator ID="BAHrsRangeValidator" runat="server" ErrorMessage="BA Hours is out of range."
                    ControlToValidate="txtBAHrs" MaximumValue="99999" MinimumValue="0" Type="Double" SetFocusOnError="true">
                </asp:RangeValidator>                
                 <br />
                <asp:Label ID="Label11" runat="server" Text="Project Management Hours (in hours):" AssociatedControlID="txtProjectHrs"></asp:Label>
                <br />
               <asp:TextBox ID="txtProjectHrs" runat="server" Width="49px" Columns="12"  onchange="return TotalHoursCalculate();"></asp:TextBox>
               <asp:CompareValidator ID="PMHrsCompareValidator" runat="server" ControlToValidate="txtProjectHrs"
                    ErrorMessage="Project Hours must be integer value." Display="Dynamic" Operator="DataTypeCheck"
                    Type="Double" SetFocusOnError="true">
                </asp:CompareValidator>
                 <asp:RequiredFieldValidator ID="PMHrsRequiredFieldValidator" runat="server" ControlToValidate="txtProjectHrs"
                    ErrorMessage="Project Hours is required." Display="Dynamic" SetFocusOnError="true">
                </asp:RequiredFieldValidator>
                 <asp:RangeValidator ID="PMHrsRangeValidator" runat="server" ErrorMessage="Project Hours is out of range."
                    ControlToValidate="txtProjectHrs" MaximumValue="99999" MinimumValue="0" Type="Double" SetFocusOnError="true">
                </asp:RangeValidator>
                 <br />                 
                
                <asp:Label ID="Label12" runat="server" Text="Label" AssociatedControlID="txtOtherDuration">Others Duration (in hours):</asp:Label>
                <br />
                <asp:TextBox ID="txtOtherDuration" runat="server" Width="49px" Columns="12" onchange="return TotalHoursCalculate();"></asp:TextBox>
               <%-- <asp:CompareValidator ID="CompareValidator2" runat="server" ControlToValidate="txtOtherDuration"
                    ErrorMessage="Other duration must be integer value." Display="Dynamic" Operator="DataTypeCheck"
                    Type="Double" SetFocusOnError="true">
                </asp:CompareValidator>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtOtherDuration"
                    ErrorMessage="Other Duration is required." Display="Dynamic" SetFocusOnError="true">
                </asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidator2" runat="server" ErrorMessage="other duration is out of range"
                    ControlToValidate="txtOtherDuration" MaximumValue="99999" MinimumValue="0" Type="Double" SetFocusOnError="true">
                </asp:RangeValidator>--%>
                <br />                 
                <asp:Label ID="Label4" runat="server" Text="Label" AssociatedControlID="Duration">Total Estimated Duration (Hours):</asp:Label>
                <br />
                <asp:TextBox ID="Duration" runat="server" Width="49px" Columns="12" Enabled="false"></asp:TextBox>
               <%-- <asp:CompareValidator ID="DurationCompareValidator" runat="server" ControlToValidate="Duration"
                    ErrorMessage="Duration must be integer value." Display="Dynamic" Operator="DataTypeCheck"
                    Type="Double" SetFocusOnError="true">
                </asp:CompareValidator>
                <asp:RequiredFieldValidator ID="DurationRequiredFieldValidator" runat="server" ControlToValidate="Duration"
                    ErrorMessage="Duration is required." Display="Dynamic" SetFocusOnError="true">
                </asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidator1" runat="server" ErrorMessage="Duration is out of range"
                    ControlToValidate="Duration" MaximumValue="99999" MinimumValue="0" Type="Double" SetFocusOnError="true">
                </asp:RangeValidator>--%>
                <br />
                <asp:Label ID="Label5" runat="server" Text="Label" AssociatedControlID="Description">Description:</asp:Label>
                <br />
                <asp:TextBox ID="Description" runat="server" TextMode="MultiLine"
                    Width="204px" Columns="20" Rows="15" MaxLength="300"></asp:TextBox>
                <br />
                <asp:CustomValidator ID="CustomValidator1" runat="server" ControlToValidate="Description"
                    ErrorMessage="Description must be less than 300 characters" OnServerValidate="CustomValidator1_ServerValidate" SetFocusOnError="true"></asp:CustomValidator>
            </p>
            </td>
            <td width="30%">
            <div class="formsection">
                Specify Project Members
                </div>
                 <table align="center">
<tr>
</td>
</tr>
<tr>
<td colspan="3">
<asp:Label ID="Label7" runat="server" Text="Label" AssociatedControlID="Consultants">Select a resource. Use ctrl+click to select multiple resources at once:</asp:Label>
</td>
</tr>
<tr>
<td style="width: 20%;">
<p>
  
     <asp:ObjectDataSource ID="ProjectConsultantData" runat="server" TypeName="System.Web.Security.Roles"
     SelectMethod="GetUsersInRole">
     </asp:ObjectDataSource>
     <b>Consultants</b>
     <asp:ListBox ID="Consultants" runat="server" 
         OnDataBound="Consultants_DataBound"  
         OnSelectedIndexChanged="SelectedResourcesOnLoad" SelectionMode="Multiple" 
         Rows="9" DataSourceID="ProjectConsultantData" CssClass="resourcelist" 
        />
     </p>

</td>
<td>
<table>
<tr>
<td>
<asp:Button ID="btn1" runat="server" Text=">" Width="45px" onclick="btn1_Click" />
</td>
</tr>
<tr>
<td>
<asp:Button ID="btn3" runat="server" Text="<" Width="45px" onclick="btn3_Click" />
</td>
</tr>

</table>
</td>
<td>
<b>Selected Consultants</b>
<asp:ListBox ID="SelectedResources"  SelectionMode="Multiple" runat="server" Rows="9" OnLoad="SelectedResourcesOnLoad" CssClass="resourcelist" />  
</td>
</tr>
<tr>
<td colspan="3">
 <asp:Label ID="lbltxt" runat="server" ForeColor="Red"></asp:Label>
 <asp:Label ID="successful" style="color:Green; font-size:larger;" runat="server"></asp:Label>
 <asp:Label ID="Error" style="color:Red; font-size:larger;" runat="server"></asp:Label>
</td>
</tr>
</table>
    
 <div class="formsection">
                <asp:Button ID="SaveButton2" runat="server" CssClass="submit" Text="Save" OnClick="SaveButton_Click" OnClientClick="return validate();"></asp:Button>
                &nbsp;
                <asp:Button ID="CancelButton2" runat="server" CausesValidation="False" CssClass="reset"
                    Text="Cancel" OnClick="CancelButton_Click"></asp:Button>
                &nbsp;
                <asp:Button ID="DeleteButton2" runat="server" Text="Delete" CssClass="delete" CausesValidation="False"
                    OnClick="DeleteButton_Click"></asp:Button>
                    <asp:HiddenField ID="hdnDuration" runat="server" Value="" />
            </div>
        </fieldset>
    </div>
            </table>

</asp:Content>
