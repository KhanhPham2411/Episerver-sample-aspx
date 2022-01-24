<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="EPiServer.Cms.UI.AspNetIdentity" %>
<%@ Import Namespace="Microsoft.AspNet.Identity" %>
<%@ Import Namespace="EPiServer.Framework" %>
<%@ Import Namespace="EPiServer.Framework.Initialization" %>
<%@ Import Namespace="Microsoft.AspNet.Identity.EntityFramework" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Configuration.Provider" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="EPiServer.ServiceLocation" %>
<%@ Import Namespace="Microsoft.AspNet.Identity.Owin" %>
<%@ Import Namespace="EPiServer.Shell.Security" %>

<form id="form1" runat="server" enctype="multipart/form-data">
    <h2>
        <input type="text" id="userNameToMatch" name="userNameToMatch" />
        <asp:Button runat="server" OnClick="Search" Text="Search" />
    </h2>
    <h2>
        <input type="text" id="userNameToCreate" name="userNameToCreate" value="<%=username%>"/>
        <asp:Button runat="server" OnClick="CreateUser" Text="Create User" />
    </h2>
    <h2>
        <input type="text" id="userNameToReset" name="userNameToReset"/>
        <asp:Button runat="server" OnClick="ResetPassword" Text="Reset Password" />
    </h2>
    <h2>
        <input type="text" id="userNameToImpersonate" name="userNameToImpersonate"/>
        <asp:Button runat="server" OnClick="Impersonate" Text="Impersonate" />
    </h2>
</form>


<script language="C#" type="text/C#" runat="server">
    void Search(object sender, EventArgs e)
    {
        var userNameToMatch = Request.Form["userNameToMatch"];
        Log("Result of keyword: " + userNameToMatch);
        SearchWithUIProvider(userNameToMatch);
    }
    void SearchWithUIProvider(string userNameToMatch)
    {
        Response.Write("<h3> Using UI provider </h3>");
        var userProvider = ServiceLocator.Current.GetInstance<UIUserProvider>();
        int totalRecord;
        var UIUsers = userProvider.FindUsersByName(userNameToMatch, 0, 5, out totalRecord);
        Log("Found " + totalRecord + " users :");
        foreach (var user in UIUsers)
        {
            Log(user.Username);
        }
    }

    static string username = "sysadmin9";
    string password = "P@ssw0rd";
    string email = username + "@episerver.com";
    string[] roles = { "Administrators" };


    void CreateUser(object sender, EventArgs e)
    {
        var uiSignInManager = ServiceLocator.Current.GetInstance<UISignInManager>();
        var uiUserProvider = ServiceLocator.Current.GetInstance<UIUserProvider>();
        var uiRoleProvider = ServiceLocator.Current.GetInstance<UIRoleProvider>();
        var uiUserManager = ServiceLocator.Current.GetInstance<UIUserManager>();

        username = Request.Form["userNameToCreate"];
        email = username + "@episerver.com";

        int totalRecord;
        var user = uiUserProvider.FindUsersByName(username, 0, 1, out totalRecord).FirstOrDefault();

        if(user == null)
        {
            UIUserCreateStatus status;
            IEnumerable<string> errors = Enumerable.Empty<string>();
            var result = uiUserProvider.CreateUser(username, password, email, null, null, true, out status, out errors);

            foreach (var error in errors)
            {
                Log(error);
            }

            if (errors.Count() == 0)
            {
                string role = roles.FirstOrDefault();
                if (!uiRoleProvider.RoleExists(role))
                {
                    uiRoleProvider.CreateRole(role);
                }

                uiRoleProvider.AddUserToRoles(username, roles);
                Log("Created successfully user: " + username);
            }
        }
        else
        {
            Log("Failed to create as the user " + username + " already exist");
            return;
        }

        Log("User name: " + username);
        Log("Password: " + password);
        Log("Email: " + email);
        GotoLoginPage();
    }
    void GotoLoginPage()
    {
        Response.Write("===> <a href=\"Util/Login.aspx\" target=\"_blank\">Go to Login page</a>");
        Response.Write("<strike><div>****************************</div></strike>");
    }

    void ResetPassword(object sender, EventArgs e)
    {
        var userName = Request.Form["userNameToReset"];
        Log("Reseting password for user: " + userName);
        var uiSignInManager = ServiceLocator.Current.GetInstance<UISignInManager>();
        var userProvider = ServiceLocator.Current.GetInstance<UIUserProvider>();
        var uiUserManager = ServiceLocator.Current.GetInstance<UIUserManager>();
        int totalRecord;
        var user = userProvider.FindUsersByName(userName, 0, 1, out totalRecord).FirstOrDefault();
        if (user != null)
        {
            bool success = uiUserManager.ResetPassword(user, password);
            if (success)
            {
                Log("Password changed successfully to: " + password);
            }
            else
            {
                Log("Failed to change password");
                return;
            }
        }
        GotoLoginPage();
    }

    void Impersonate(object sender, EventArgs e)
    {
        var userName = Request.Form["userNameToImpersonate"];
        Log("Impersonating: " + userName);
        Log("New password: " + password);
        var uiSignInManager = ServiceLocator.Current.GetInstance<UISignInManager>();
        var userProvider = ServiceLocator.Current.GetInstance<UIUserProvider>();
        var uiUserManager = ServiceLocator.Current.GetInstance<UIUserManager>();
        int totalRecord;
        var user = userProvider.FindUsersByName(userName, 0, 1, out totalRecord).FirstOrDefault();
        if (user != null)
        {
            bool success = uiUserManager.ResetPassword(user, password);
            if (success)
            {
                Log("Password changed successfully to: " + password);
            }
            else
            {
                Log("Failed to change password");
                return;
            }
            success = uiSignInManager.SignIn(user.ProviderName, user.Username, password);
            if (success)
            {
                Log("Impersonated successfully with user " + userName);
            }
            else
            {
                Log("Failed to impersonated");
                return;
            }
        }
        else
        {
            Log("Not found user to impersonate");
            return;
        }
        Response.Write("<a href=\"Episerver\" target=\"_blank\">Go to Admin page</a>");
        Response.Write("<strike><div>****************************</div></strike>");

    }


    void Log(string text, string tag="div")
    {
        Response.Write("<" + tag + ">" + text + "</"+ tag +">");
    }
</script>

<%
   
%>

