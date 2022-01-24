  
<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Import Namespace="EPiServer.Commerce.Extensions" %>
<%@ Import Namespace="EPiServer.Reference.Commerce.Site.Features.Product.Models" %>
<%@ Import Namespace="EPiServer.ServiceLocation" %>
<%@ Import Namespace="Mediachase.Commerce.Catalog" %>
<%@ Import Namespace="EPiServer" %>

<form id="form1" runat="server" enctype="multipart/form-data">
    <h2><asp:Button runat="server" OnClick="PublishBatchProduct" Text="Publish Batch Product" /></h2>
    <h2><asp:Button runat="server" OnClick="PublishSingleProduct" Text="Publish Single Product" /></h2>
    <h2><asp:Button runat="server" OnClick="GetProduct" Text="Get Product" /></h2>
</form>

<script language="C#" type="text/C#" runat="server">
    void GetProduct(object sender, EventArgs e) 
    { 
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();

        var parent = _referenceConverter.GetContentLink("P-37008157");
        var product = _contentRepository.Get<FashionProduct>(parent).CreateWritableClone<FashionProduct>();
    }

    void PublishBatchProduct(object sender, EventArgs e)
    {
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();

        var parent = _referenceConverter.GetContentLink("P-37008157");
        var product = _contentRepository.Get<FashionProduct>(parent).CreateWritableClone<FashionProduct>();
        product.Brand = "Test123456";

        var list = new List<FashionProduct>();
        list.Add(product);
        _contentRepository.Publish(list, PublishAction.SyncDraft);
    }

    void PublishSingleProduct(object sender, EventArgs e)
    {
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();

        var parent = _referenceConverter.GetContentLink("P-37008157");
        var product = _contentRepository.Get<FashionProduct>(parent).CreateWritableClone<FashionProduct>();
        product.Brand = "Test123456";

        _contentRepository.Publish(product);
    }

    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }
</script>

<%
    Response.Write("<h3> Batch publish testing </h3>");
%>