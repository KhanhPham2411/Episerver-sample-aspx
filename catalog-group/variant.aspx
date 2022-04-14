  
<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Import Namespace="EPiServer.Commerce.Extensions" %>
<%@ Import Namespace="RF.Website.CMS.Features.Catalog.ProductDetailPage.Models" %>
<%@ Import Namespace="EPiServer.ServiceLocation" %>
<%@ Import Namespace="Mediachase.Commerce.Catalog" %>
<%@ Import Namespace="EPiServer" %>
<%@ Import Namespace="EPiServer.Core" %>
<%@ Import Namespace="EPiServer.DataAccess" %>
<%@ Import Namespace="EPiServer.Security" %>
<%@ Import Namespace="System.Globalization" %>


<form id="form1" runat="server" enctype="multipart/form-data">
    <h2><asp:Button runat="server" OnClick="PublishSingleVariant" Text="Publish Single Variant" /></h2>
    <h2><asp:Button runat="server" OnClick="GetVariant" Text="Get Variant" /></h2>
    <h2><asp:Button runat="server" OnClick="GetVariantByVersionAPI" Text="Get Variant By VersionAPI" /></h2>
    <h2>
        <input placeholder="VariantCode: P-37008157" type="text" id="VariantCode" name="VariantCode" value="P-37008157" />
        <asp:Button runat="server" OnClick="PutVariant" Text="Put Variant" />
    </h2>
    <h2>
        <input placeholder="parentCode: mens" type="text" id="parentCode" name="parentCode" value="mens" />
        <asp:Button runat="server" OnClick="PostVariant" Text="Post Variant" />
    </h2>
</form>

<script language="C#" type="text/C#" runat="server">
    void GetVariant(object sender, EventArgs e)
    {
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();

        var variantLink = _referenceConverter.GetContentLink("210321450");
        var entryId = _referenceConverter.GetObjectId(variantLink);
        var workId = 8331774;
        var versionVariantLink = _referenceConverter.GetContentLink(entryId, CatalogContentType.CatalogEntry, workId);

        var variant = _contentRepository.Get<GeneralVariant>(variantLink).CreateWritableClone<GeneralVariant>();

        Log("Code: " + variant.Code);
        Log("StopPublish: " + variant.StopPublish.Value.ToString());
        Log("ContentGuid: " + variant.ContentGuid.ToString());
    }
    void GetVariantByVersionAPI(object sender, EventArgs e)
    {
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();
        var _contentVersionRepository = ServiceLocator.Current.GetInstance<IContentVersionRepository>();

        var variantLink = _referenceConverter.GetContentLink("210321450");
        var versions = _contentVersionRepository.List(variantLink);
        var lastestPublished = versions.OrderByDescending(c => c.Saved)
            .FirstOrDefault(v => v.Status == VersionStatus.Published && v.LanguageBranch == "en");

        var variant = _contentRepository.Get<GeneralVariant>(lastestPublished.ContentLink).CreateWritableClone<GeneralVariant>();

        Log("Code: " + variant.Code);
        Log("StopPublish: " + variant.StopPublish.Value.ToString());
        Log("ContentGuid: " + variant.ContentGuid.ToString());
    }

    void PublishSingleVariant(object sender, EventArgs e)
    {
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();

        var parent = _referenceConverter.GetContentLink("P-37008157");
        var Variant = _contentRepository.Get<GeneralVariant>(parent).CreateWritableClone<GeneralVariant>();
        //Variant.Name = "Test123456";

        _contentRepository.Publish(Variant);
    }

    void PutVariant(object sender, EventArgs e)
    {
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();
        var VariantCode = Request.Form["VariantCode"];

        var VariantLink = _referenceConverter.GetContentLink(VariantCode);
        var Variant = _contentRepository.Get<GeneralVariant>(VariantLink).CreateWritableClone<GeneralVariant>();

        bool IsPublished = false;
        bool IsActive = false;

        Variant.IsPendingPublish = !IsActive || !IsPublished;
        SaveAction saveAction = GetSaveAction(IsPublished, Variant.Status);

        bool isMasterLanguage = true;
        _contentRepository.Save(Variant, isMasterLanguage ? SaveAction.Publish | SaveAction.ForceCurrentVersion : saveAction, AccessLevel.NoAccess);
    }

    void PostVariant(object sender, EventArgs e)
    {
        bool IsPublished = false;
        bool IsActive = false;

        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();
        var parentCode = Request.Form["parentCode"];

        var parentLink = _referenceConverter.GetContentLink(parentCode);
        var entryContent = _contentRepository.GetDefault<GeneralVariant>(parentLink);
        entryContent.Name = "New Variant";
        var savedContentLink = _contentRepository.Save(entryContent, SaveAction.Publish, AccessLevel.NoAccess);

        var Variant = _contentRepository.Get<GeneralVariant>(savedContentLink).CreateWritableClone<GeneralVariant>();
        Variant.IsPendingPublish = !IsActive || !IsPublished;
        SaveAction saveAction = GetSaveAction(IsPublished, Variant.Status);

        bool isMasterLanguage = true;
        _contentRepository.Save(Variant, isMasterLanguage ? SaveAction.Publish | SaveAction.ForceCurrentVersion : saveAction, AccessLevel.NoAccess);
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
    Response.Write("<h3> Variant testing </h3>");
%>