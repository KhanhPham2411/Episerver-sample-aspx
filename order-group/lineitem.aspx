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
        <%--<input placeholder="" type="text" id="orderGroupIdToUpdate" name="orderGroupIdToUpdate" />--%>
        <asp:Button runat="server" OnClick="CreateLineItem" Text="Create Line Item" />
    </h2>
     <h2>
        <%--<input placeholder="" type="text" id="orderGroupIdToUpdate" name="orderGroupIdToUpdate" />--%>
        <asp:Button runat="server" OnClick="CreateDoubleLineItem" Text="Create Double Line Item" />
    </h2>
</form>

<script language="C#" type="text/C#" runat="server">
    void CreateLineItem(object sender, EventArgs e)
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
        AddLineItem(cart, "SKU-36127195");
        AddLineItem(cart, "SKU-44477844");
        AddLineItem(cart, "SKU-39850363");
        RemoveFirstLineItem(cart);
        AddLineItem(cart, "SKU-36127195");
        LogLineItemId(cart);
    }
    void CreateDoubleLineItem(object sender, EventArgs e)
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
        var tempLineItems = new List<ILineItem>();
        tempLineItems.Add(LoadLineItem(cart, "SKU-36127195"));
        tempLineItems.Add(LoadLineItem(cart, "SKU-44477844"));
        Log(string.Join(" ", tempLineItems.Select(item => item.LineItemId)));
        tempLineItems.ForEach(x => cart.AddLineItem(x));

        AddLineItem(cart, "SKU-39850363");
        RemoveFirstLineItem(cart);
        AddLineItem(cart, "SKU-36127195");
        LogLineItemId(cart);
    }

    void RemoveFirstLineItem(ICart cart)
    {
        var shipment = cart.GetFirstShipment();
        shipment.LineItems.Remove(shipment.LineItems.First());
    }
    void ClearLineItem(ICart cart)
    {
        foreach (var shipment in cart.GetFirstForm().Shipments)
        {
            shipment.LineItems.Clear();
        }
    }
    ILineItem LoadLineItem(ICart cart, string code)
    {
        var lineItem = cart.CreateLineItem(code);
        lineItem.Quantity = 1;

        return lineItem;
    }
    void AddLineItem(ICart cart, string code)
    {
        var lineItem = cart.CreateLineItem(code);
        lineItem.Quantity = 1;
        cart.AddLineItem(lineItem);
    }
    void LogLineItemId(ICart cart)
    {
        Log(string.Join(" ", cart.GetAllLineItems().Select(item => item.LineItemId)));
    }

    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }
</script>

<%
    Response.Write("<h3> Lineitem Testing </h3>");
%>
