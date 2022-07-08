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


<form id="form1" runat="server" enctype="multipart/form-data">
    <h2>
        <%--<input placeholder="" type="text" id="" name="" />--%>
        <asp:Button runat="server" OnClick="CreateContact" Text="Create Contact" />
    </h2>
   
</form>

<script language="C#" type="text/C#" runat="server">
    void CreateContact(object sender, EventArgs e)
    {
        // string value = Request.Form["marketName"];

        var orderRepository = ServiceLocator.Current.GetInstance<IOrderRepository>();
        var usernamePre = "CustomerContact";

        for (int i = 0; i < 100000; i++) 
        {
            var guid = Guid.NewGuid();
            var userName = usernamePre + guid.ToString();
            var email = userName + "@example.com";

            var contact = CustomerContact.CreateInstance();
            contact.PrimaryKeyId = new PrimaryKeyId(guid);
            contact.UserId = "String:" + email;

            contact.FirstName = userName;
            contact.LastName = userName;
            contact.Email = email;
         

            contact.SaveChanges();
            // Log("Contact: " + userName + " created successfully");
        }

        Log("Contact created successfully");
    }

    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }
</script>

<%
    Response.Write("<h3> Contact Testing </h3>");
%>
