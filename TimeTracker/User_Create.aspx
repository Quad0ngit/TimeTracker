<%@ Page Language="C#" MasterPageFile="~/TimeTracker/MasterPage.master" CodeFile="User_Create.aspx.cs"
    Inherits="User_Create_aspx" Title="Quadone - Time Tracker - Administration - User Creation" Culture="auto" UICulture="auto"  %>
<asp:Content ID="Content1" ContentPlaceHolderID="maincontent" runat="Server">

                     
    <div id="adminedit">
        <a name="content_start" id="content_start"></a>
        <fieldset>
            <!-- add H2 here and hide it with css since you can not put h2 inside a legend tag -->
            <h2 class="none">
                User Detail</h2>
            <legend>Create New User</legend>
            <asp:CreateUserWizard ID="CreateUserWizard1" runat="server" Width="100%" OnFinishButtonClick="Wizard_FinishButton_Click"
                ContinueDestinationPageUrl="User_List.aspx" 
                OnCreatedUser="CreateUserWizard1_CreatedUser" 
                DuplicateUserNameErrorMessage=" User Name should be unique.">
                <StartNavigationTemplate>
                    <asp:Button ID="StartNextButton" runat="server" CommandName="MoveNext" 
                        Text="Next" />
                </StartNavigationTemplate>
                <WizardSteps>
                    <asp:CreateUserWizardStep runat="server" Title="Sign Up for Your New Account">
                     
                        <ContentTemplate>
                            <table border="0" cellpadding="0" cellspacing="0" class="create_user_main" 
                                style="width: 108%">
                             <tr>
                                        <td align="center" colspan="2">
                                            <asp:CompareValidator ID="CompareValidator1" runat="server" 
                                                ControlToCompare="Password" ControlToValidate="ConfirmPassword" 
                                                Display="Dynamic" 
                                                ErrorMessage="The Password and Confirmation Password must match." 
                                                ValidationGroup="CreateUserWizard1" SetFocusOnError="true"></asp:CompareValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                     <td align="center" colspan="2" style="color:Red;">
                                     <asp:CustomValidator ID="EmailCheck" runat="server" ValidationGroup="CreateUserWizard1" Font-Names="verdana"  ControlToValidate="Email" ForeColor="red" ErrorMessage="Email Id already exists." OnServerValidate="Email_TextChanged"  ></asp:CustomValidator> 
                                     </td>
                                     </tr>
                                    <tr>
                                        <td align="center" colspan="2" style="color:Red; font-size:14px;" >
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            <asp:Literal ID="ErrorMessage" runat="server" EnableViewState="False"></asp:Literal>
                                            &nbsp;
                                            
                                        </td>
                                    </tr>
                                <tr>
                                    <td align="center" class="header-lightgray" colspan="2" style="color:Blue; font-size:small;">
                                        Create A New User Account </td>
                                        
                                </tr>
                                <caption>
                                    
                                 <tr>
                                    <td align="center" colspan="2" style="color:Red;">
                                    <asp:RegularExpressionValidator ID="maxlengthofusername"
                                             runat="server" ControlToValidate="UserName"  ErrorMessage="User name is too long. Max 20 characters accepted. "
                                             ValidationExpression="^([\s\S]){1,20}$" ValidationGroup="CreateUserWizard1" SetFocusOnError="true"></asp:RegularExpressionValidator>
                                     </td>
                                     </tr>
                                     
                                    <tr>
                                        <td align="right" class="label_txt" style="width: 446px">
                                            <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">User 
                                        Name:</asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="UserName" runat="server" TabIndex="0" ></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" 
                                                ControlToValidate="UserName" SetFocusOnError="true" ErrorMessage="User Name is required." 
                                                ToolTip="User Name is required." ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator ID="spacesnotallow" runat="server" 
                                                ControlToValidate="UserName" SetFocusOnError="true" ErrorMessage="Numbers,special charecters or Spaces not allowed" 
                                                ValidationExpression="^[a-zA-Z]+$" ValidationGroup="CreateUserWizard1" ></asp:RegularExpressionValidator>
                                              
                                              
                                        </td>
                                    </tr>
                                    
                                    <tr>
                                        <td align="right" class="label_txt" style="width: 446px; height: 42px;">
                                            <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password">Password:</asp:Label>
                                        </td>
                                        <td style="height: 42px">
                                            <asp:TextBox ID="Password" runat="server" TextMode="Password"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" 
                                                ControlToValidate="Password" ErrorMessage="Password is required." 
                                                ToolTip="Password is required." ValidationGroup="CreateUserWizard1" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" class="label_txt" style="width: 446px">
                                            <asp:Label ID="ConfirmPasswordLabel" runat="server" 
                                                AssociatedControlID="ConfirmPassword">Confirm Password:</asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="ConfirmPassword" runat="server" TextMode="Password"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="ConfirmPasswordRequired" runat="server" 
                                                ControlToValidate="ConfirmPassword" 
                                                ErrorMessage="Confirm Password is required." 
                                                ToolTip="Confirm Password is required." ValidationGroup="CreateUserWizard1" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" class="label_txt" style="width: 446px">
                                            <asp:Label ID="usertype" runat="server" AssociatedControlID="usertype">User 
                                        Type:</asp:Label>
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="categoryList" runat="server" Width="150px">
                                                <%--<asp:ListItem Text="Developer" Value="1"></asp:ListItem>
                                                <asp:ListItem Text=" Designer" Value="2"></asp:ListItem>
                                                <asp:ListItem Text="Tester" Value="3"></asp:ListItem>
                                                <asp:ListItem Text="Business Analyst" Value="4"></asp:ListItem>
                                                <asp:ListItem Text="Quality Analyst" Value="5"></asp:ListItem>
                                                <asp:ListItem Text="Hr/Admin/Finance" Value="6"></asp:ListItem>--%>
                                            </asp:DropDownList>
                                        </td>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                            ControlToValidate="categoryList" ErrorMessage="Category is required." 
                                            ToolTip="category is required." ValidationGroup="CreateUserWizard1" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                                    </tr>
                                    <tr>
                                        <td align="right" class="label_txt" style="width: 446px">
                                            <asp:Label ID="EmailLabel" runat="server" AssociatedControlID="Email">E-mail:</asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="Email" runat="server"  ></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="EmailRequired" runat="server" 
                                                ControlToValidate="Email" ErrorMessage="E-mail is required." 
                                                ToolTip="E-mail is required." ValidationGroup="CreateUserWizard1" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                                            
                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                                                ControlToValidate="Email" ErrorMessage="Invalid Email" SetFocusOnError="True" ValidationGroup="CreateUserWizard1"
                                                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"  ></asp:RegularExpressionValidator>
                                             
                                           </td>
                                     </tr>
                                     <tr>
                                        <td align="right" class="label_txt" style="width: 446px">
                                            <asp:Label ID="Label1" runat="server">Assign user to the Team Leader:</asp:Label>
                                        </td>
                                        <td>
                                             <asp:DropDownList ID="ddlTeamLeader" runat="server" Width="150px">
                                            </asp:DropDownList>
                                             <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ValidationGroup="CreateUserWizard1"
                                                Display="Dynamic" ControlToValidate="ddlTeamLeader" SetFocusOnError="true" ErrorMessage="Team Leader Name is a required value.">
                                            </asp:RequiredFieldValidator>   
                                        </td>
                                     
                                     </tr>
                                     <tr>
                                        <td align="right" class="label_txt" style="width: 446px">
                                            <asp:Label ID="QuestionLabel" runat="server" AssociatedControlID="Question">Security 
                                        Question:</asp:Label>
                                        </td>
                                        <td>
                                            <%--<asp:TextBox ID="Question" runat="server"></asp:TextBox>--%>
                                            <asp:DropDownList runat="server" ID="Question">
                                                <asp:ListItem Selected="True" Text="Select" Value="select"></asp:ListItem>
                                                <asp:ListItem Text="What is your mother's maiden name?" Value="What is your mother's maiden name?"></asp:ListItem>
                                                <asp:ListItem Text="What is your pet's name?" Value="What is your pet's name?"></asp:ListItem>
                                                <asp:ListItem Text="What is your birth place?" Value="What is your birth place?"></asp:ListItem>
												<asp:ListItem Text="What is your first school name?" Value="What is your first school name?"></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="QuestionRequired" runat="server"  InitialValue="select" 
                                                ControlToValidate="Question" ErrorMessage="Security question is required." 
                                                ToolTip="Security question is required." ValidationGroup="CreateUserWizard1" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" class="label_txt" style="width: 446px">
                                            <asp:Label ID="AnswerLabel" runat="server" AssociatedControlID="Answer">Security 
                                        Answer:</asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="Answer" runat="server"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="AnswerRequired" runat="server" 
                                                ControlToValidate="Answer" ErrorMessage="Security answer is required." 
                                                ToolTip="Security answer is required." ValidationGroup="CreateUserWizard1" SetFocusOnError="true">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                </caption>
                                 
                                
                            </table>
                        </ContentTemplate>
                        <CustomNavigationTemplate>
                            <table border="0" cellspacing="5" style="width:100%;height:100%;">
                                <tr>
                                   <%-- <td style="width:43%;">&nbsp;</td>--%>
                                  
                                    <td style="width:57%; text-align:center;" colspan="2">
                                        <asp:Button ID="StepNextButton" runat="server" CommandName="MoveNext" 
                                            Text="Create User" ValidationGroup="CreateUserWizard1" />
                                    </td>
                                </tr>
                            </table>
                        </CustomNavigationTemplate>
                    </asp:CreateUserWizardStep>
                    <asp:WizardStep runat="server">
                        <center>
                            Add the user to a group:
                            <br />
                            <asp:DropDownList ID="GroupName" runat="server" Width="150px">
                                <asp:ListItem Value="0" Text="Project Administrator"></asp:ListItem>
                                <asp:ListItem Value="3" Text="Project Manager"></asp:ListItem>
                                <asp:ListItem Value="1" Text="Project Consultant"></asp:ListItem>
                                <asp:ListItem Value="4" Text="Team Leader"></asp:ListItem>
                            </asp:DropDownList>
                            <br />
                        </center>
                    </asp:WizardStep>
                     <asp:CompleteWizardStep runat="server" Title="Complete">
                    </asp:CompleteWizardStep>
                </WizardSteps>
                <TitleTextStyle CssClass="header-lightgray" />
            </asp:CreateUserWizard>
            <asp:Label runat="server" ID="noAccessMsg" Visible="false" EnableViewState="false"
                Text="User can not be created at this time. Please contact your administratior"></asp:Label>
        </fieldset>
    </div>
</asp:Content>
