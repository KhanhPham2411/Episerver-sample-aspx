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

<form id="form1" runat="server" enctype="multipart/form-data">
    <h2><asp:Button runat="server" OnClick="CreateUser" Text="Create User" /></h2>
</form>


<script language="C#" type="text/C#" runat="server">
    string username = "sysadmin6";
    string password = "p@ssword";
    string email = "sysadmin@mysite.com";
    string[] roles = { "Administrators" };
    string[] connectionStrings = { "EPiServerDB", "EcfSqlConnection" }; // "EcfSqlConnection", "EPiServerDB"

    void CreateUser(object sender, EventArgs e)
    {
        Response.Write("<h3> User name: " + username + "</h3>");
        Response.Write("<h3> Password: " + password + "</h3>");
        Response.Write("<h3> Email: " + email + "</h3>");

        foreach (var connectionString in connectionStrings)
        {
            CreateUserWithConnection(connectionString);
        }

        Response.Write("<strike><div>****************************</div></strike>");
        Response.Write("<a href=\"Util/Login.aspx\" target=\"_blank\">Go to Login page</a>");
    }
    void CreateUserWithConnection(string connectionString)
    {
        Response.Write("<strike><div>****************************</div></strike>");
        Response.Write("<h3> Using connection string: " + connectionString + "</h3>");
        Response.Write("<h3> Start creating user: " + username + "</h3>");

        using (UserStore<SiteUser> store = new UserStore<SiteUser>(new ApplicationDbContext<SiteUser>(connectionString)))
        {
            //If there's already a user, then we don't need a seed
            if (!store.Users.Any(x => x.UserName == username))
            {
                // CreateUser(UserStore<ApplicationUser> store, string username, string password, string email)
                IPasswordHasher hasher = new PasswordHasher();
                string passwordHash = hasher.HashPassword(password);

                SiteUser applicationUser = new SiteUser
                {
                    Email = email,
                    EmailConfirmed = true,
                    LockoutEnabled = true,
                    IsApproved = true,
                    UserName = username,
                    PasswordHash = passwordHash,
                    SecurityStamp = Guid.NewGuid().ToString()
                };

                store.CreateAsync(applicationUser).GetAwaiter().GetResult();
                SiteUser createdUser = store.FindByNameAsync(username).GetAwaiter().GetResult();

                // AddUserToRoles(UserStore<ApplicationUser> store, ApplicationUser user, string[] roles)
                IUserRoleStore<SiteUser, string> userRoleStore = store;
                using (var roleStore = new RoleStore<IdentityRole>(new ApplicationDbContext<SiteUser>(connectionString)))
                {
                    IList<string> userRoles = userRoleStore.GetRolesAsync(createdUser).GetAwaiter().GetResult();
                    foreach (string roleName in roles)
                    {
                        if (roleStore.FindByNameAsync(roleName).GetAwaiter().GetResult() == null)
                        {
                            roleStore.CreateAsync(new IdentityRole { Name = roleName }).GetAwaiter().GetResult();
                        }
                        if (!userRoles.Contains(roleName))
                            userRoleStore.AddToRoleAsync(createdUser, roleName).GetAwaiter().GetResult();
                    }
                }
                store.UpdateAsync(createdUser).GetAwaiter().GetResult();

                Response.Write("<h3> Created successfully user: " + username + "</h3>");
            }
            else
            {
                Response.Write("<h3> Failed to create as the user " + username + " already exist </h3>");
            }


        }
    }

    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }
</script>

<%
    
%>

