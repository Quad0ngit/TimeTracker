<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChangePassword.aspx.cs" Inherits="TimeTracker_ChangePassword" MasterPageFile="~/TimeTracker/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="maincontent" runat="Server">
    <div>
         <a name="content_start" id="content_start"></a>
        <fieldset>
            <!-- add H2 here and hide it with css since you can not put h2 inside a legend tag -->
            <h2 class="none">Change Password</h2>
            <legend>Change Password</legend>
            <table cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td><asp:Label runat="server" ID="Label1" Text="Old Password"></asp:Label></td>
                    <td>
                        <asp:TextBox runat="server" ID="txtOldPassword" TextMode="Password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                            ErrorMessage="*" ControlToValidate="txtOldPassword"
                            Display="Dynamic" />
                    </td>
                </tr>
                 <tr>
                    <td><asp:Label runat="server" ID="Label2" Text="New Password"></asp:Label></td>
                    <td>
                        <asp:TextBox runat="server" ID="txtPassword" TextMode="Password"></asp:TextBox>
                         <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                            ErrorMessage="*" ControlToValidate="txtPassword"
                            Display="Dynamic" />
                    </td>
                </tr>
                <tr>
                    <td><asp:Label runat="server" ID="Label3" Text="Confirm Password"></asp:Label></td>
                    <td>
                        <asp:TextBox runat="server" ID="txtConfirmPassword" TextMode="Password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                            ErrorMessage="*" ControlToValidate="txtConfirmPassword"
                            Display="Dynamic" />  
                        <asp:CompareValidator ID="CompareValidator1" runat="server" ErrorMessage="Password and Re-Password is mismatch." ControlToCompare="txtPassword" ControlToValidate="txtConfirmPassword"></asp:CompareValidator>  
                    </td>
                </tr>
                <tr><td>&nbsp;</td></tr>
                <tr><td align="center"  colspan="2"><asp:Button runat="server" ID="btnSubmit" onclick="btnSubmit_Click"  Text="Submit"/></td></tr>
            </table>
        </fieldset>
    </div>
</asp:Content>