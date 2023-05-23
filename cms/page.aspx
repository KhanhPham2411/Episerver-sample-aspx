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

<%@ Import Namespace="EPiServer.Commerce.Order" %>
<%@ Import Namespace="EPiServer.ServiceLocation" %>
<%@ Import Namespace="Mediachase.Commerce.Orders" %>
<%@ Import Namespace="EPiServer" %>
<%@ Import Namespace="EPiServer.Core" %>
<%@ Import Namespace="EPiServer.Reference.Commerce.Site.Features.Checkout.Pages" %>


<form id="form1" runat="server" enctype="multipart/form-data">
    <h2>
        <input placeholder="pageId - 10" type="text" id="pageId" name="pageId" value="10"/>
        <asp:Button runat="server" OnClick="LoadPage" Text="Load Page" />
    </h2>
   
</form>

<script language="C#" type="text/C#" runat="server">

    void LoadPage(object sender, EventArgs e)
    {
        var contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();
        int pageId = int.Parse(Request.Form["pageId"]);

        var page = contentRepository.Get<CheckoutPage>(new ContentReference(pageId));
        Log("ProductMenuItems.Count:" + page.ProductMenuItems.Count);
        Log(page.Name);
    }
   

    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }
</script>

<%
    Response.Write("<h3> Page Testing </h3>");
%>
