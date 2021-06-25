<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.Configuration.Provider" %>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="EPiServer.Framework" %>
<%@ Import Namespace="EPiServer.Framework.Initialization" %>


<%
    var user = "EpiSQLAdmin8";
    var mu = Membership.GetUser(user);

    if (mu != null) return;
    try
    {
        Membership.CreateUser(user, "P@ssw0rd", user + "@site.com");

        try
        {
            if (!Roles.RoleExists("Administrators"))
                Roles.CreateRole("Administrators");


            Roles.AddUserToRoles(user, new[] { "Administrators" });
            Response.Write("created successfully");
        }
        catch (ProviderException pe)
        {
            Response.Write(pe);
        }
    }
    catch (MembershipCreateUserException mcue)
    {
        Response.Write(mcue);
    }
%>
