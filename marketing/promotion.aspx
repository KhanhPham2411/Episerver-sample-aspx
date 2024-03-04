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
<%@ Import Namespace="EPiServer.Commerce.Marketing" %>
<%@ Import Namespace="EPiServer.DataAccess" %>
<%@ Import Namespace="EPiServer.Core" %>
<%@ Import Namespace="EPiServer.Commerce.Marketing.Promotions" %>

<form id="form1" runat="server" enctype="multipart/form-data">
    <h2>
        <input placeholder="promotionId - 365086" type="text" id="promotionIdToUpdate" name="promotionIdToUpdate" />
        <asp:Button runat="server" OnClick="UpdatePromotion" Text="Update Promotion" />
    </h2>
</form>

<script language="C#" type="text/C#" runat="server">
    void UpdatePromotion(object sender, EventArgs e)
    {
        var contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();
        int promotionId = int.Parse(Request.Form["promotionIdToUpdate"]);

        var promotionContent = new ContentReference(promotionId);
        var promotion = contentRepository.Get<PromotionData>(promotionContent).CreateWritableClone() as BuyQuantityGetFreeItems;
        promotion.Condition.Items = new List<ContentReference>() { 
            new ContentReference(10), 
            new ContentReference(10),
            new ContentReference(11)
        };

        contentRepository.Save(promotion, SaveAction.Publish, EPiServer.Security.AccessLevel.NoAccess);
        Log("Promotion updated successfully");
    }

    void UpdatePromotionInclude(object sender, EventArgs e)
    {
        var contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();
        int promotionId = int.Parse(Request.Form["promotionIdToUpdate"]);

        var promotionContent = new ContentReference(promotionId);
        var promotion = contentRepository.Get<PromotionData>(promotionContent).CreateWritableClone() as PromotionData;
        promotion.ExcludedItems = new List<ContentReference>() { new ContentReference(10), new ContentReference(10) };

        contentRepository.Save(promotion, SaveAction.Publish, EPiServer.Security.AccessLevel.NoAccess);
        Log("Promotion updated successfully");
    }

    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }
</script>

<%
    Response.Write("<h3> Order Testing </h3>");
%>
