<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ClientWiseReport.aspx.cs" Inherits="TimeTracker_ClientWiseReport" MasterPageFile="~/TimeTracker/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="maincontent" runat="Server">
        <script src="jscript/JScript1.8.2.js"></script>
    <script src="jscript/JScript1.9.1.js"></script>
    <link rel="stylesheet" href="styles/StyleSheet.css" />
    <link rel="stylesheet" href="/resources/demos/style.css" />
     <link rel="stylesheet" href="/resources/demos/style.css" />
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />
    <script type="text/javascript">
    $(function() {
    $("[id*=StartDate]").datepicker({ dateFormat: 'mm/dd/yy' });
    });
</script>
    <div id="projectreportnew">
        <a name="content_start" id="content_start"></a>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
                </asp:ScriptManager>
        <fieldset>
            <h2 class="none">
                Categories Report</h2>
            <legend>Categories Report</legend>
           <div>
               <%-- <asp:Label ID="Label1" runat="server" Text="Label" AssociatedControlID="lstPojects">Select a Category. Use ctrl+click to Select multiple Categories at once:</asp:Label>
           --%>    <div class="left_select">
                <asp:ListBox ID="lstPojects" runat="server"  CssClass="resourcelist" SelectionMode="Single"
                Width="200px" Height="330px" Rows="22"/>
                  <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" Width="223px"
                    ErrorMessage="At least one project must be selected." ControlToValidate="lstPojects"
                    Display="Dynamic"></asp:RequiredFieldValidator>
             </div>   
            </div>
            <legend >Report By Month&amp; Year </legend>
            <div class="right_select">
                <!--div class="formsection">
                STEP 2 - Select a date range</div-->
                <table cellpadding="5" cellspacing="0" border="0">
                <tr>
                <td>
                <asp:Label ID="Label3" Text="Select Month:" runat="server"></asp:Label>
                 </td>
                 <td>
                 <asp:DropDownList ID="MonthList" runat="server">
                    <asp:ListItem Text="January" Value="1"></asp:ListItem>
                    <asp:ListItem Text="February" Value="2"></asp:ListItem>
                    <asp:ListItem Text="March" Value="3"></asp:ListItem>
                    <asp:ListItem Text="April" Value="4"></asp:ListItem>
                    <asp:ListItem Text="May" Value="5"></asp:ListItem>
                    <asp:ListItem Text="June" Value="6"></asp:ListItem>
                    <asp:ListItem Text="July" Value="7"></asp:ListItem>
                    <asp:ListItem Text="August" Value="8"></asp:ListItem>
                    <asp:ListItem Text="September" Value="9"></asp:ListItem>
                    <asp:ListItem Text="October" Value="10"></asp:ListItem>
                    <asp:ListItem Text="November" Value="11"></asp:ListItem>
                    <asp:ListItem Text="December" Value="12"></asp:ListItem>
                 </asp:DropDownList>
                 </td>
                 <td>
                 <asp:Label ID="Label4" Text="Select Year:" runat="server"></asp:Label>
                 </td>
                 <td>
                 <asp:DropDownList ID="YearList" runat="server">
                    <asp:ListItem Text="2013" Value="2013"></asp:ListItem>
                    <asp:ListItem Text="2014" Value="2014"></asp:ListItem>
                    <asp:ListItem Text="2015" Value="2015"></asp:ListItem>
                    <asp:ListItem Text="2016" Value="2016"></asp:ListItem>
                    <asp:ListItem Text="2017" Value="2017"></asp:ListItem>
                    <asp:ListItem Text="2018" Value="2018"></asp:ListItem>
                    <asp:ListItem Text="2019" Value="2019"></asp:ListItem>
                    <asp:ListItem Text="2020" Value="2020"></asp:ListItem>
                    <asp:ListItem Text="2021" Value="2021"></asp:ListItem>
                    <asp:ListItem Text="2022" Value="2022"></asp:ListItem>
                 </asp:DropDownList>
                 </td> 
                 <td rowspan="2">
                 <asp:Button ID="Button1" runat="server" CssClass="submit" Text="Generate Report"
                CausesValidation="False" OnClick="GenProjectRptByMonth_Click" />
                </td>
                 </tr>
                 <tr>
                 <td></td>
                 <td>
                  <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server"
                    ErrorMessage="At least one month must be selected." ControlToValidate="Monthlist"
                    Display="Dynamic" />  
                 </td>
               <td>
              
               </td>
               <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                    ErrorMessage="At least one Year must be selected." ControlToValidate="YearList"
                    Display="Dynamic" />
                </td>
               </tr>
               </table>
               </div>
            <legend >Report By Dates</legend>
            <div class="right_select">
                <!--div class="formsection">
                STEP 2 - Select a date range</div-->
                <table cellpadding="5" cellspacing="0" border="0" width="100%">
                <tr>
                <td width="11%">
                <asp:Label ID="FromDate" Text="From Date:" runat="server"></asp:Label>
                 </td>
                 <td width="25%">
                  <asp:TextBox ID="StartDate" runat="server" 
                    ></asp:TextBox> <span>[mm/dd/yyyy]</span>
                 </td>
                 <td width="10%">
                 <asp:Label ID="Label2" Text="To Date:" runat="server"></asp:Label>
                 </td>
                 <td width="25%">
                  <asp:TextBox ID="txtDate" runat="server"></asp:TextBox> <span>[mm/dd/yyyy]</span>
                 </td> 
                 <td rowspan="2" width="29%">
                 <asp:Button ID="GenProjectRpt" runat="server" CssClass="submit" Text="Generate Report"
                CausesValidation="False" OnClick="GenCategoryRpt_Click" />
                </td>
                 </tr>
                 <tr>
                 <td></td>
                 <td>   
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                    ErrorMessage="From Date must be given." ControlToValidate="StartDate"
                    Display="Dynamic"></asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="CompareValidator3" runat="server" ControlToValidate="StartDate"
                    Display="Dynamic" ErrorMessage="Date format is incorrect." Operator="DataTypeCheck"
                    Type="Date"></asp:CompareValidator>
               </td>
               <td>
              
               </td>
               <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                ErrorMessage="To Date must be given." ControlToValidate="txtDate"
                Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToValidate="txtDate"
                    Display="Dynamic" ErrorMessage="Date format is incorrect." Operator="DataTypeCheck"
                    Type="Date"></asp:CompareValidator>
                </td>
               </tr>
               <tr>
               <td colspan="3" style="text-align:right;">
                <asp:Label ID="dateCompare" ForeColor="red" runat="server"></asp:Label>
               </td>
               </tr>
              
            </table>
        </fieldset>
    </div>
</asp:Content>
