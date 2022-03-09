  
<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Import Namespace="EPiServer.Commerce.Extensions" %>
<%@ Import Namespace=" Foundation.Features.CatalogContent.Product" %>
<%@ Import Namespace="EPiServer.ServiceLocation" %>
<%@ Import Namespace="Mediachase.Commerce.Catalog" %>
<%@ Import Namespace="EPiServer" %>
<%@ Import Namespace="EPiServer.Core" %>
<%@ Import Namespace="EPiServer.DataAccess" %>
<%@ Import Namespace="EPiServer.Security" %>
<%@ Import Namespace="EPiServer.Commerce.Catalog.ContentTypes" %>


<form id="form1" runat="server" enctype="multipart/form-data">
    <h2><asp:Button runat="server" OnClick="PublishSingleProduct" Text="Publish Single Product" /></h2>
    <h2><asp:Button runat="server" OnClick="GetProduct" Text="Get Product" /></h2>
    <h2><asp:Button runat="server" OnClick="UpdateProduct" Text="Update Product" /></h2>
    <h2>
        <input placeholder="productCode: P-37008157" type="text" id="productCode" name="productCode" value="P-37008157" />
        <asp:Button runat="server" OnClick="PutProduct" Text="Put Product" />
    </h2>
    <h2>
        <input placeholder="parentCode: mens" type="text" id="parentCode" name="parentCode" value="mens" />
        <asp:Button runat="server" OnClick="PostProduct" Text="Post Product" />
    </h2>
    <h2>
<%--        <input placeholder="parentCode: mens" type="text" id="parentCode" name="parentCode" value="mens" />--%>
        <asp:Button runat="server" OnClick="CreateBatchProduct" Text="Create Batch Product" />
    </h2>
</form>

<script language="C#" type="text/C#" runat="server">
    void GetProduct(object sender, EventArgs e)
    {
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();

        var parent = _referenceConverter.GetContentLink("P-37008157");
        var product = _contentRepository.Get<GenericProduct>(parent).CreateWritableClone<GenericProduct>();

        Log(product.Code);
        Log(product.ContentGuid.ToString());
    }

    void UpdateProduct(object sender, EventArgs e)
    {
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();

        var productLink = _referenceConverter.GetContentLink("P-42518256");
        var productToUpdate = _contentRepository.Get<GenericProduct>(productLink).CreateWritableClone<GenericProduct>();
        productToUpdate.Name = "[Updated]" + productToUpdate.Name;

        _contentRepository.Save(productToUpdate, SaveAction.Publish);
    }

    void PublishSingleProduct(object sender, EventArgs e)
    {
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();

        var parent = _referenceConverter.GetContentLink("P-37008157");
        var product = _contentRepository.Get<GenericProduct>(parent).CreateWritableClone<GenericProduct>();
        product.Brand = "Test123456";

        _contentRepository.Publish(product);
    }

    void CreateBatchProduct(object sender, EventArgs e)
    {
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();

        var rootLink = _referenceConverter.GetRootLink();
        var catalog = _contentRepository.GetChildren<CatalogContent>(rootLink).First();

        GenericProduct product = _contentRepository.GetDefault<GenericProduct>(catalog.ContentLink);
        product.Code = "sample_product";
        product.Name = "Sample product";
        product.DisplayName = "Sample product";
        product.IsPendingPublish = false;
        product.StopPublish = DateTime.Today.AddYears(10);

        var products = new List<CatalogContentBase> { product };
        _contentRepository.Publish(products);
    }

    void CreateOrUpdateBatchProduct(object sender, EventArgs e)
    {
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();

        var rootLink = _referenceConverter.GetRootLink();
        var catalog = _contentRepository
            .GetChildren<CatalogContent>(rootLink)
            .First();

        var productContentLink = _referenceConverter.GetContentLink("sample_product");
        GenericProduct product;

        if (ContentReference.IsNullOrEmpty(productContentLink))
        {
            product = _contentRepository.GetDefault<GenericProduct>(catalog.ContentLink);
            product.Code = "sample_product";
        }
        else
        {
            product = _contentRepository.Get<GenericProduct>(productContentLink);
            product = (GenericProduct) product.CreateWritableClone();
        }

        product.Name = "Sample product";
        product.DisplayName = "Sample product";
        product.IsPendingPublish = false;
        product.StopPublish = DateTime.Today.AddYears(10);

        var products = new List<CatalogContentBase> { product };
        _contentRepository.Publish(products, PublishAction.SyncDraft);
    }

    void PutProduct(object sender, EventArgs e)
    {
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();
        var productCode = Request.Form["productCode"];

        var productLink = _referenceConverter.GetContentLink(productCode);
        var product = _contentRepository.Get<GenericProduct>(productLink).CreateWritableClone<GenericProduct>();

        bool IsPublished = false;
        bool IsActive = false;

        product.IsPendingPublish = !IsActive || !IsPublished;
        SaveAction saveAction = GetSaveAction(IsPublished, product.Status);

        bool isMasterLanguage = true;
        _contentRepository.Save(product, isMasterLanguage ? SaveAction.Publish | SaveAction.ForceCurrentVersion : saveAction, AccessLevel.NoAccess);
    }

    void PostProduct(object sender, EventArgs e)
    {
        bool IsPublished = false;
        bool IsActive = false;

        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();
        var parentCode = Request.Form["parentCode"];

        var parentLink = _referenceConverter.GetContentLink(parentCode);
        var entryContent = _contentRepository.GetDefault<GenericProduct>(parentLink);
        entryContent.Name = "New Product";
        var savedContentLink = _contentRepository.Save(entryContent, SaveAction.Publish, AccessLevel.NoAccess);

        var product = _contentRepository.Get<GenericProduct>(savedContentLink).CreateWritableClone<GenericProduct>();
        product.IsPendingPublish = !IsActive || !IsPublished;
        SaveAction saveAction = GetSaveAction(IsPublished, product.Status);

        bool isMasterLanguage = true;
        _contentRepository.Save(product, isMasterLanguage ? SaveAction.Publish | SaveAction.ForceCurrentVersion : saveAction, AccessLevel.NoAccess);
    }

    SaveAction GetSaveAction(VersionStatus currentStatus)
    {
        if (currentStatus == VersionStatus.Published)
        {
            return SaveAction.Publish | SaveAction.ForceCurrentVersion;
        }

        return SaveAction.Publish;
    }

    SaveAction GetSaveAction(bool isPublished, VersionStatus currentStatus)
    {
        if (isPublished || currentStatus == VersionStatus.Published)
        {
            return SaveAction.Publish | SaveAction.ForceCurrentVersion;
        }

        return SaveAction.Save | SaveAction.ForceCurrentVersion;
    }

    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }
</script>

<%
    Response.Write("<h3> Product testing </h3>");
%>