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


<%@ Import Namespace="EPiServer.ServiceLocation" %>
<%@ Import Namespace="Mediachase.Commerce.Orders" %>
<%@ Import Namespace="EPiServer.Web.Routing" %>
<%@ Import Namespace="EPiServer.Web" %>
<%@ Import Namespace="EPiServer.Core" %>
<%@ Import Namespace="EPiServer" %>
<%@ Import Namespace="Mediachase.Commerce.Catalog" %>
<%@ Import Namespace="EPiServer.Commerce.Catalog" %>
<%@ Import Namespace="EPiServer.Commerce.Catalog.ContentTypes" %>
<%@ Import Namespace="EPiServer.Framework.Modules.Internal" %>
<%@ Import Namespace="EPiServer.Commerce.SpecializedProperties" %>


<form id="form1" runat="server" enctype="multipart/form-data">
    <h2>
        <input value="SKU-36127195" type="text" id="entryCode" name="entryCode" />
        <asp:Button runat="server" OnClick="Run" Text="Run" />
    </h2>

</form>

<script language="C#" type="text/C#" runat="server">
    IContentImage GetMediaFromAsset(CommerceMedia commerceMedia)
    {
        var _contentLoader = ServiceLocator.Current.GetInstance<IContentLoader>();

        try
        {
            if (ContentReference.IsNullOrEmpty(commerceMedia.AssetLink))
            {
                return null;
            }

            return _contentLoader.Get<IContent>(commerceMedia.AssetLink) as IContentImage;
        }
        catch (ContentNotFoundException)
        {
            return null;
        }
    }

    bool HasBlobProperty(IContentImage mediaContent, string propName)
    {
        var _blobResolver = ServiceLocator.Current.GetInstance<IBlobResolver>();

        return _blobResolver.ResolveProperty(mediaContent, propName) != null;
    }

    string GetThumbnailUrl(IAssetContainer content, string propertyName)
    {
        var _assetUrlResolver = ServiceLocator.Current.GetInstance<AssetUrlResolver>();
        var _urlResolver = ServiceLocator.Current.GetInstance<UrlResolver>();
        var _moduleResourceResolver = ServiceLocator.Current.GetInstance<ModuleResourceResolver>();

        return _assetUrlResolver.GetAssetUrl<IContentImage>(content, (selectedItem) =>
        {
            var mediaContent = GetMediaFromAsset(selectedItem);

            Log(_urlResolver.GetType().ToString());
            var mediaUrl = _urlResolver.GetUrl(mediaContent.ContentLink);
            Log("mediaUrl: " + mediaUrl);

            var virtualPath = _urlResolver.GetVirtualPath(mediaContent.ContentLink, "en", null);
            Log("virtualPath: " + virtualPath.VirtualPath);
            Log("rootPath: " + virtualPath.DataTokens["rootPath"]);
            var url = virtualPath.GetUrl();
            Log("url: " + url);

            // return fallback URL - fulll image URL
            if (!HasBlobProperty(mediaContent, propertyName))
            {
                Log("=> This media don't have Blob");
                return mediaUrl;
            }

            Log("=> This media do have Blob");
            var builder = new UrlBuilder(mediaUrl);
            builder.Path = UriUtil.Combine(builder.Path, propertyName);
            return builder.ToString();
        });
    }

    void Run(object sender, EventArgs e)
    {
        var resolver = ServiceLocator.Current.GetInstance<IVirtualPathResolver>();
        var _thumbnailUrlResolver = ServiceLocator.Current.GetInstance<ThumbnailUrlResolver>();
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentLoader = ServiceLocator.Current.GetInstance<IContentLoader>();

        var entryCode = Request.Form["entryCode"];

        var entryContentLink = _referenceConverter.GetContentLink(entryCode);
        var content = _contentLoader.Get<IContent>(entryContentLink);
        var thumbnailUrl = GetThumbnailUrl((IAssetContainer)content, "thumbnail");
        Log("relative: " + thumbnailUrl);

        //var result1 = _thumbnailUrlResolver.GetAbsoluteThumbnailUrl(entryContentLink, "thumbnail");
        //Log(result1);

        //var result = resolver.ToAbsolute(thumbnailUrl);
        //Log("absolute: " + result);
    }


    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }
</script>

<%
    Response.Write("<h3> Route Testing </h3>");
%>
