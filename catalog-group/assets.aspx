  
<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Import Namespace="EPiServer.Commerce.Extensions" %>
<%@ Import Namespace="EPiServer.ServiceLocation" %>
<%@ Import Namespace="Mediachase.Commerce.Catalog" %>
<%@ Import Namespace="EPiServer" %>
<%@ Import Namespace="EPiServer.Core" %>
<%@ Import Namespace="EPiServer.DataAccess" %>
<%@ Import Namespace="EPiServer.Security" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="Foundation.Features.CatalogContent.Product" %>
<%@ Import Namespace="EPiServer.Web.Routing" %>


<form id="form1" runat="server" enctype="multipart/form-data">
    <h2>
        <input placeholder="ProductCode" type="text" id="ProductCode" name="ProductCode" value="P-39813617" />
        <asp:Button runat="server" OnClick="GetProductAssets" Text="Get Product Assets" />
    </h2>
   
</form>

<script language="C#" type="text/C#" runat="server">
    void GetProductAssets(object sender, EventArgs e)
    {
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();

        var productCode = Request.Form["ProductCode"];
        var productLink = _referenceConverter.GetContentLink(productCode);

        var product = _contentRepository.Get<GenericProduct>(productLink).CreateWritableClone<GenericProduct>();

        foreach (var asset in product.CommerceMediaCollection)
        {
            var virtualPath = GetVirtualPath(asset.AssetLink, false);
            if (virtualPath == null)
            {
                continue;
            }

            Log("AssetLink: " + asset.AssetLink.ID + ", virtualPath: " + virtualPath);
        }
    }

    string GetVirtualPath(ContentReference contentReference, bool thumbnail)
    {
        if (ContentReference.IsNullOrEmpty(contentReference))
        {
            return null;
        }
         var _urlResolver = ServiceLocator.Current.GetInstance<UrlResolver>();


        return UriSupport.AbsoluteUrlBySettings(
            VirtualPathUtility.AppendTrailingSlash(_urlResolver.GetUrl(contentReference)) +
            (thumbnail ? "thumbnail" : ""));
    }



    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }
</script>

<%
    Response.Write("<h3> Assets testing </h3>");
%>