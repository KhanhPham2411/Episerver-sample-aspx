<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.Configuration.Provider" %>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="EPiServer.Framework" %>
<%@ Import Namespace="EPiServer.Framework.Initialization" %>


<%
    var user = "EpiSQLAdmin12";
    var pass = "P@ssw0rd";
    var roles = new String[] { "Administrators", "CmsAdmins", "Episerver Administrators" };
    var mu = Membership.GetUser(user);

    if (mu != null)
    {
        Response.Write("User " + user + " already exist");
        return;
    }
    try
    {
        Membership.CreateUser(user, pass, user + "@site.com");
        try
        {
            foreach (var role in roles)
            {
                if (!Roles.RoleExists(role))
                    Roles.CreateRole(role);
                Roles.AddUserToRole(user, role);
            }
        }
        catch (ProviderException pe)
        {
            Response.Write(pe);
            return;
        }

        Response.Write("created successfully");
        Response.Write("User: " + user);
        Response.Write("Pass: " + pass);
    }
    catch (MembershipCreateUserException mcue)
    {
        Response.Write(mcue);
    }
%>
