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


<%@ Import Namespace="Briscoes.ECommerce.Core.Models.Identity" %>



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
    string[] connectionStrings = { "EPiServerDB", "EcfSqlConnection" }; // "EcfSqlConnection", "EPiServerDB"

    void Search(object sender, EventArgs e)
    {
        var userNameToMatch = Request.Form["userNameToMatch"];
        Log("Result of keyword: " + userNameToMatch);

        foreach (var connectionString in connectionStrings)
        {
            SearchWithConnection(connectionString, userNameToMatch);
        }
    }
    void SearchWithConnection(string connectionString, string userNameToMatch)
    {
        Response.Write("<h3> Using connection string: " + connectionString + "</h3>");

        using (UserStore<SiteUser> store = new UserStore<SiteUser>(new ApplicationDbContext<SiteUser>(connectionString)))
        {
            var users = store.Users.Where(user => user.UserName.Contains(userNameToMatch));
            var countUser = users.Count();
            Log("Found " + countUser + " users :");
            foreach (var user in users.Take(5))
            {
                Log(user.UserName);
            }

           
        }
    }

    void Impersonate(object sender, EventArgs e)
    {
        var userName = Request.Form["userName"];
        Log("Impersonating " + userName);

        var userManger = ServiceLocator.Current.GetInstance<ApplicationUserManager<SiteUser>>();
        var signInManager = ServiceLocator.Current.GetInstance<ApplicationSignInManager<SiteUser>>();

        var user = userManger.FindByName(userName);
        if (user != null)
        {
            signInManager.SignIn(user, true, true);
            Log("Impersonated successfully with user " + userName);
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

