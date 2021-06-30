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
        <input placeholder="orderGroupId - 365086" type="text" id="orderGroupIdToUpdate" name="orderGroupIdToUpdate" />
        <asp:Button runat="server" OnClick="UpdateOrder" Text="Update Order with market name" />
        <input value="test" type="text" id="marketName" name="marketName" />
    </h2><h2>
        <input placeholder="orderGroupId - 365086" type="text" id="orderGroupIdToLoad" name="orderGroupIdToLoad" />
        <asp:Button runat="server" OnClick="LoadOrder" Text="Load Order" />
    </h2>
    <h2>
        <input placeholder="orderGroupId - 365086" type="text" id="orderGroupIdToCancel" name="orderGroupIdToCancel" />
        <asp:Button runat="server" OnClick="CancelOrder" Text="Cancel Order" />
    </h2>
    <h2>
        <input placeholder="orderGroupId - 365086" type="text" id="orderGroupIdToDelete" name="orderGroupIdToDelete" />
        <asp:Button runat="server" OnClick="DeleteOrder" Text="Delete Order" />
    </h2>
    <h2>
        <input placeholder="" type="text" id="keywordToSearch" name="keywordToSearch" />
        <asp:Button runat="server" OnClick="SearchOrder" Text="Search Order" />
    </h2>
</form>

<script language="C#" type="text/C#" runat="server">
    void UpdateOrder(object sender, EventArgs e)
    {
        var orderRepository = ServiceLocator.Current.GetInstance<IOrderRepository>();
        int orderGroupId = int.Parse(Request.Form["orderGroupIdToUpdate"]);
        string marketName = Request.Form["marketName"];

        var orderGroup = orderRepository.Load<IPurchaseOrder>(orderGroupId);
        orderGroup.MarketName = marketName;
        var orderReference = orderRepository.Save(orderGroup);

        // load again
        orderGroup = orderRepository.Load<IPurchaseOrder>(orderReference.OrderGroupId);
        Log("Market name changed to " + marketName);
    }
    void LoadOrder(object sender, EventArgs e)
    {
        var orderRepository = ServiceLocator.Current.GetInstance<IOrderRepository>();
        int orderGroupId = int.Parse(Request.Form["orderGroupIdToLoad"]);

        var orderGroup = orderRepository.Load<IPurchaseOrder>(orderGroupId);
        Log(orderGroup.Name);
    }
    void CancelOrder(object sender, EventArgs e)
    {
        var orderRepository = ServiceLocator.Current.GetInstance<IOrderRepository>();
        int orderGroupId = int.Parse(Request.Form["orderGroupIdToCancel"]);
        var orderGroup = orderRepository.Load<IPurchaseOrder>(orderGroupId);

        var purchaseOrderProcessor = ServiceLocator.Current.GetInstance<IPurchaseOrderProcessor>();
        purchaseOrderProcessor.CancelOrder((IPurchaseOrder)orderGroup);
    }
    void DeleteOrder(object sender, EventArgs e)
    {
        var orderRepository = ServiceLocator.Current.GetInstance<IOrderRepository>();
        int orderGroupId = int.Parse(Request.Form["orderGroupIdToDelete"]);
        var order = orderRepository.Load<IPurchaseOrder>(orderGroupId);

        orderRepository.Delete(order.OrderLink);
    }
    void SearchOrder(object sender, EventArgs e)
    {
       var result = OrderContext.Current.FindPurchaseOrdersByStatus(OrderStatus.InProgress);
    }

    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }
</script>

<%
    Response.Write("<h3> Order Testing </h3>");
%>
