  
<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Import Namespace="EPiServer.Commerce.Extensions" %>
<%@ Import Namespace="EPiServer.ServiceLocation" %>
<%@ Import Namespace="Mediachase.Commerce.Catalog" %>
<%@ Import Namespace="EPiServer" %>
<%@ Import Namespace="EPiServer.Core" %>
<%@ Import Namespace="EPiServer.DataAccess" %>
<%@ Import Namespace="EPiServer.Security" %>
<%@ Import Namespace="EPiServer.Commerce.Catalog.ContentTypes" %>
<%@ Import Namespace="EPiServer.Reference.Commerce.Site.Features.Product.Models" %>
<%@ Import Namespace="EPiServer.Commerce.Catalog.Linking" %>


<form id="form1" runat="server" enctype="multipart/form-data">
    <h2>
        <asp:Button runat="server" OnClick="Test" Text="Test" />
    </h2>
</form>

<script language="C#" type="text/C#" runat="server">

    ContentReference GetCatalog()
    {
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();
        var rootLink = _referenceConverter.GetRootLink();
        return _contentRepository.GetChildren<CatalogContent>(rootLink).Skip(1).First().ContentLink;
    }

    ContentReference CreateCatalogNode(ContentReference parentLink=null)
    {
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();

        if (parentLink == null)
        {
            var rootLink = _referenceConverter.GetRootLink();
            var firstCatalog = _contentRepository.GetChildren<CatalogContent>(rootLink).First();
            parentLink = firstCatalog.ContentLink;
        }


        var catalogNode = _contentRepository.GetDefault<FashionNode>(parentLink);
        catalogNode.Name = DateTime.Now.ToString("Node_dd_MM_yyyy_HH_mm_ss");

        return _contentRepository.Save(catalogNode, SaveAction.Publish);
    }

    ContentReference CreateProduct(ContentReference parentLink)
    {
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();

        var catalogNode = _contentRepository.GetDefault<FashionProduct>(parentLink);
        catalogNode.Name = DateTime.Now.ToString("Product_dd_MM_yyyy_HH_mm_ss");

        return _contentRepository.Save(catalogNode, SaveAction.Publish);
    }

    ContentReference GetVariant()
    {
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();

        var variantLink = _referenceConverter.GetContentLink("SKU-44477844");

        var variant = _contentRepository.Get<FashionVariant>(variantLink).CreateWritableClone<FashionVariant>();

        return variant.ContentLink;
    }


    void Test(object sender, EventArgs e)
    {
        var _relationRepository = ServiceLocator.Current.GetInstance<IRelationRepository>();

        var catalogNodeParent = CreateCatalogNode();
        var variant = GetVariant();

        for (int i = 0; i < 400; i++)
        {
            var catalogNodeChild = CreateCatalogNode(catalogNodeParent);
            _relationRepository.UpdateRelation(new NodeEntryRelation()
            {
                IsPrimary = false,
                Parent = catalogNodeChild,
                Child = variant
            });
        }

    }

    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }
</script>

<%
    Response.Write("<h3> Catalog Node testing </h3>");
%>