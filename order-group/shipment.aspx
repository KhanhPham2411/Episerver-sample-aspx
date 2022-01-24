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
<%@ Import Namespace="Mediachase.Commerce" %>


<form id="form1" runat="server" enctype="multipart/form-data">
    <h2>
        <input placeholder="orderGroupId - 365086" type="text" id="orderGroupIdToUpdate" name="orderGroupIdToUpdate" />
        <asp:Button runat="server" OnClick="CreateShipment" Text="Create Shipment" />
    </h2>
</form>

<script language="C#" type="text/C#" runat="server">
    void CreateShipment(object sender, EventArgs e)
    {
        var orderRepository = ServiceLocator.Current.GetInstance<IOrderRepository>();
        var orderGroupFactory = ServiceLocator.Current.GetInstance<IOrderGroupFactory>();
        var currentMarket = ServiceLocator.Current.GetInstance<ICurrentMarket>();
        ICart cart = orderRepository.LoadOrCreateCart<ICart>(CustomerContext.Current.CurrentContactId, "Default", currentMarket);
        if (cart != null)
        { 
            orderRepository.Delete(cart.OrderLink); 
        }

        cart = orderRepository.LoadOrCreateCart<ICart>(CustomerContext.Current.CurrentContactId, "Default", currentMarket);
        cart.GetFirstForm().Shipments.Clear();
        cart.GetFirstForm().Shipments.Add(orderGroupFactory.CreateShipment(cart)); // Expected shipmentId is -2, which it is
        orderRepository.Save(cart);

        cart = orderRepository.LoadOrCreateCart<ICart>(CustomerContext.Current.CurrentContactId, "Default", currentMarket);
        cart.GetFirstForm().Shipments.Add(orderGroupFactory.CreateShipment(cart));
        //Expected shipmentId is -3 which it is in 13.18.2, but in 13.26.0 this is assigned -2 which leaves us with two shipments with the same id
        cart.GetFirstForm().Shipments.Add(orderGroupFactory.CreateShipment(cart));
        // This shipment gets id -3 which is fine
    }

    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }
</script>

<%
    Response.Write("<h3> Shipment Testing </h3>");
%>
