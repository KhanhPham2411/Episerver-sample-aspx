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
        <input type="text" id="userName" name="userName" />
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


    void Impersonate(object sender, EventArgs e)
    {
        var userName = Request.Form["userName"];
        string password = "P@ssw0rd2";

        Log("Impersonating: " + userName);
        Log("New password: " + password);

        var uiSignInManager = ServiceLocator.Current.GetInstance<UISignInManager>();
        var userProvider = ServiceLocator.Current.GetInstance<UIUserProvider>();
        var uiUserManager = ServiceLocator.Current.GetInstance<UIUserManager>();

        int totalRecord;
        var user = userProvider.FindUsersByName(userName, 0, 1, out totalRecord).First();
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
            }
        }
        else
        {
            Log("Not found user to impersonate");
        }


        Response.Write("<strike><div>****************************</div></strike>");
        Response.Write("<a href=\"Episerver\" target=\"_blank\">Go to Admin page</a>");
    }

    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }
</script>

<%
    
%>

