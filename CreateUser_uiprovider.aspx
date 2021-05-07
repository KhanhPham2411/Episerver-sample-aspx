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
    <h2><asp:Button runat="server" OnClick="CreateUser" Text="Create User" /></h2>
</form>


<script language="C#" type="text/C#" runat="server">
    static string username = "sysadmin9";
    string password = "P@ssw0rd";
    string email = username + "@mysite.com";
    string[] roles = { "Administrators" };
    string[] connectionStrings = { "EPiServerDB", "EcfSqlConnection" }; // "EcfSqlConnection", "EPiServerDB"

    void CreateUser(object sender, EventArgs e)
    {
        var uiSignInManager = ServiceLocator.Current.GetInstance<UISignInManager>();
        var uiUserProvider = ServiceLocator.Current.GetInstance<UIUserProvider>();
        var uiRoleProvider = ServiceLocator.Current.GetInstance<UIRoleProvider>();
        var uiUserManager = ServiceLocator.Current.GetInstance<UIUserManager>();

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
                uiRoleProvider.AddUserToRoles(username, roles);
                Log("Created successfully user: " + username);
            }
        }
        else
        {
            Log("Failed to create as the user " + username + " already exist");
        }

        Response.Write("<strike><div>****************************</div></strike>");
        Response.Write("<a href=\"Util/Login.aspx\" target=\"_blank\">Go to Login page</a>");
    }

    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }
</script>

<%
    Response.Write("<h3> User name: " + username + "</h3>");
    Response.Write("<h3> Password: " + password + "</h3>");
    Response.Write("<h3> Email: " + email + "</h3>");
%>

