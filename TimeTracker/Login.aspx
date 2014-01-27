<%@ Page Language="C#" MasterPageFile="~/TimeTracker/Login.master" CodeFile="Login.aspx.cs"
    Inherits="Login_aspx" Title="Quadone - Time Tracker - Site Login"  Culture="auto" UICulture="auto" %>
<asp:Content ID="Content1" ContentPlaceHolderID="maincontent" runat="Server">
    <div id="adminedit" class="login_main">
            <!-- add H2 here and hide it with css since you can not put h2 inside a legend tag -->
            <h2 class="none">User Login</h2>
            <asp:Login ID="Login1" runat="server" OnLoggedIn="Login1_LoggedIn">
                <LoginButtonStyle CssClass="submit input_btn" />
                <LayoutTemplate>
                    <table border="0" cellpadding="1" cellspacing="0" 
                        style="border-collapse:collapse;">
                        <tr>
                            <td>
                                <table border="0" cellpadding="0">
                                    <tr>
                                        <td align="right" class="label_txt" style="height:40px;">
                                            <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">User 
                                            Name:</asp:Label>
                                        </td>
                                        <td style="height:40px;">
                                            <asp:TextBox ID="UserName" runat="server" ></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" 
                                                ControlToValidate="UserName" ErrorMessage="User Name is required." 
                                                ToolTip="User Name is required." ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" class="label_txt">
                                            <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password">Password:</asp:Label>
                                        </td>
                                        <td style="height:40px;">
                                            <asp:TextBox ID="Password" runat="server" TextMode="Password"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" 
                                                ControlToValidate="Password" ErrorMessage="Password is required." 
                                                ToolTip="Password is required." ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="label_txt">&nbsp;</td>
                                        <td class="tdcheck">
                                            <asp:CheckBox ID="RememberMe" runat="server" CssClass="check" Text="Remember me next time." />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="2" style="color:Red;height:40px;">
                                            <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="label_txt">&nbsp;</td>
                                        <td>
                                            <asp:Button ID="LoginButton" runat="server" CommandName="Login" 
                                                CssClass="submit input_btn" Text="Log In" ValidationGroup="Login1" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </LayoutTemplate>
                <LayoutTemplate>
                    <table border="0" cellpadding="1" cellspacing="0" 
                        style="border-collapse:collapse;">
                        <tr>
                            <td>
                                <table border="0" cellpadding="0">
                                <tr>
                                        <td align="center" colspan="2" style="color:Red;">
                                            <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" class="label_txt">
                                            <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">User 
                                            Name :</asp:Label>
                                        </td>
                                        <td style="height:40px;">
                                            <asp:TextBox ID="UserName" runat="server"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" 
                                                ControlToValidate="UserName" ErrorMessage="User Name is required." 
                                                ToolTip="User Name is required." ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" class="label_txt">
                                            <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password">Password :</asp:Label>
                                        </td>
                                        <td style="height:40px;">
                                            <asp:TextBox ID="Password" runat="server" TextMode="Password"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" 
                                                ControlToValidate="Password" ErrorMessage="Password is required." 
                                                ToolTip="Password is required." ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td class="check" >
                                            <asp:CheckBox ID="RememberMe" runat="server" Text="Remember me next time." />
                                        </td>
                                    </tr>
                                    
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td align="left">
                                            <asp:Button ID="LoginButton" runat="server" CommandName="Login" 
                                                CssClass="submit" Text="Log In" ValidationGroup="Login1" />
                                        </td>
                                     
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </LayoutTemplate>
            </asp:Login>
        <script type="text/javascript" language="javascript">
            $(document).ready(function(){
            $('#navtop, #breadcrumb').hide();
            }); 
        </script>

        
    </div>
</asp:Content>
