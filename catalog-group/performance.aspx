  
<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="EPiServer.Commerce.Extensions" %>
<%@ Import Namespace="EPiServer.ServiceLocation" %>
<%@ Import Namespace="Mediachase.Commerce.Catalog" %>
<%@ Import Namespace="EPiServer" %>
<%@ Import Namespace="EPiServer.Core" %>
<%@ Import Namespace="EPiServer.DataAccess" %>
<%@ Import Namespace="EPiServer.Security" %>
<%@ Import Namespace="EPiServer.Commerce.Catalog.ContentTypes" %>
<%@ Import Namespace="EPiServer.Commerce.Catalog.Provider.Persistence" %>
<%@ Import Namespace="Foundation.Custom" %>
<%@ Import Namespace="Foundation.Features.CatalogContent.Product" %>


<form id="form1" runat="server" enctype="multipart/form-data">
    <h2>
        <asp:Button runat="server" OnClick="BatchSavingProduct" Text="Batch Saving Product" />
    </h2>
    <h2>
        <asp:Button runat="server" OnClick="NormalSavingProduct" Text="Normal Saving Product" />
    </h2>
</form>

<script language="C#" type="text/C#" runat="server">
    ContentReference CreateCatalog()
    {
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();
        var rootLink = _referenceConverter.GetRootLink();
        var firstCatalog = _contentRepository.GetChildren<CatalogContent>(rootLink).First();

        var catalog = _contentRepository.GetDefault<CatalogContent>(rootLink);
        catalog.Name = DateTime.Now.ToString("dd_MM_yyyy_HH_mm_ss");
        catalog.DefaultCurrency = firstCatalog.DefaultCurrency;
        catalog.DefaultLanguage = firstCatalog.DefaultLanguage;
        catalog.WeightBase = firstCatalog.WeightBase;

        return _contentRepository.Save(catalog, SaveAction.Publish);
    }

    ContentReference GetCatalog()
    {
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();
        var rootLink = _referenceConverter.GetRootLink();
        return _contentRepository.GetChildren<CatalogContent>(rootLink).Skip(1).First().ContentLink;
    }

    void BatchSavingProduct(object sender, EventArgs e)
    {
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();

        var catalog = GetCatalog();
        var count = 100000;
        var products = new List<CatalogContentBase>();

        var stopwatch = new Stopwatch();
        stopwatch.Start();

        for (int i = 0; i < count; i++)
        {
            var guid = Guid.NewGuid().ToString();
            GenericProduct product = _contentRepository.GetDefault<GenericProduct>(catalog);
            product.Code = "sample_product_test" + guid;
            product.Name = "sample_product_test" + guid;
            product.DisplayName = "sample_product_test" + guid;
            product.IsPendingPublish = false;
            product.StopPublish = DateTime.Today.AddYears(10);
            product.SeoUri = "sample_product_test" + guid;

            products.Add(product);
        }


        _contentRepository.BatchSave(products, CatalogContentType.CatalogEntry, PublishAction.None);

        stopwatch.Stop();
        Log(string.Format("BatchSavingProduct => elapsed_time: {0}", stopwatch.ElapsedMilliseconds));
    }

    void NormalSavingProduct(object sender, EventArgs e)
    {
        var _referenceConverter = ServiceLocator.Current.GetInstance<ReferenceConverter>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();

        var catalog = CreateCatalog();
        var count = 100;

        var stopwatch = new Stopwatch();
        stopwatch.Start();

        for (int i = 0; i < count; i++)
        {
            var stopwatch2 = new Stopwatch();
            stopwatch2.Start();

            var guid = Guid.NewGuid().ToString();
            GenericProduct product = _contentRepository.GetDefault<GenericProduct>(catalog);
            product.Code = "sample_product_test" + guid;
            product.Name = "sample_product_test" + guid;
            product.DisplayName = "sample_product_test" + guid;
            product.IsPendingPublish = false;
            product.StopPublish = DateTime.Today.AddYears(10);
            product.SeoUri = "sample_product_test" + guid;

            _contentRepository.Save(product, SaveAction.Publish);

            stopwatch2.Stop();
            Log(string.Format("BatchSavingProduct => elapsed_time: {0}", stopwatch2.ElapsedMilliseconds));
        }

        stopwatch.Stop();
        Log(string.Format("BatchSavingProduct => elapsed_time: {0}", stopwatch.ElapsedMilliseconds));
    }

    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }

</script>

<%
    Response.Write("<h3> Product testing </h3>");
%>