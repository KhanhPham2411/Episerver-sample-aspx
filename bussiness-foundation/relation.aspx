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
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.IO.Compression" %>

<%@ Import Namespace="EPiServer.DataAbstraction" %>
<%@ Import Namespace="EPiServer.DataAccess.Internal" %>

<%@ Import Namespace="Mediachase.Commerce.Customers" %>
<%@ Import Namespace="Mediachase.BusinessFoundation.Data" %>
<%@ Import Namespace="Mediachase.BusinessFoundation.Data.Meta.Management" %>
<%@ Import Namespace="Mediachase.BusinessFoundation.Core" %>


<form id="form1" runat="server" enctype="multipart/form-data">
    <h2><asp:Button runat="server" OnClick="CreateBridgeClass" Text="Create Bridge Class" /></h2>
</form>

<script language="C#" type="text/C#" runat="server">
    void CreateBridgeClass(object sender, EventArgs e)
    {
        var className = "Contact_Organization";
        MetaDataWrapper.CreateBridgeClass(className,
                className,
                className + "s",
                "Contact",
                "Contact",
                string.Empty,
                "Organization",
                "Organization",
                string.Empty);

    }

    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }
</script>

<%
    Response.Write("<h3> Metafield Testing </h3>");
%>
