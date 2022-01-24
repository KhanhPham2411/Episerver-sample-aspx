  
<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Import Namespace="EPiServer.Commerce.Extensions" %>
<%@ Import Namespace="EPiServer.Reference.Commerce.Site.Features.Product.Models" %>
<%@ Import Namespace="EPiServer.ServiceLocation" %>
<%@ Import Namespace="Mediachase.Commerce.Catalog" %>
<%@ Import Namespace="EPiServer" %>
<%@ Import Namespace="EPiServer.Core" %>
<%@ Import Namespace="EPiServer.DataAccess" %>
<%@ Import Namespace="EPiServer.Security" %>


<form id="form1" runat="server" enctype="multipart/form-data">
    <h2><asp:Button runat="server" OnClick="PublishSingleProduct" Text="Publish Single Product" /></h2>
    <h2><asp:Button runat="server" OnClick="GetProduct" Text="Get Product" /></h2>
    <h2>
        <input placeholder="productCode: P-37008157" type="text" id="productCode" name="productCode" value="P-37008157" />
        <asp:Button runat="server" OnClick="PutProduct" Text="Put Product" />
    </h2>
    <h2>
        <input placeholder="parentCode: mens" type="text" id="parentCode" name="parentCode" value="mens" />
        <asp:Button runat="server" OnClick="PostProduct" Text="Post Product" />
    </h2>
</form>

<script language="C#" type="text/C#" runat="server">
    void GetProduct(object sender, EventArgs e)
    {
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();

        var parent = _referenceConverter.GetContentLink("P-37008157");
        var product = _contentRepository.Get<FashionProduct>(parent).CreateWritableClone<FashionProduct>();

        Log(product.Code);
        Log(product.ContentGuid.ToString());
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

    void PutProduct(object sender, EventArgs e)
    {
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();
        var productCode = Request.Form["productCode"];

        var productLink = _referenceConverter.GetContentLink(productCode);
        var product = _contentRepository.Get<FashionProduct>(productLink).CreateWritableClone<FashionProduct>();

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
        var entryContent = _contentRepository.GetDefault<FashionProduct>(parentLink);
        entryContent.Name = "New Product";
        var savedContentLink = _contentRepository.Save(entryContent, SaveAction.Publish, AccessLevel.NoAccess);

        var product = _contentRepository.Get<FashionProduct>(savedContentLink).CreateWritableClone<FashionProduct>();
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