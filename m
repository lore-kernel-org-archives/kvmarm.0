From: Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC v2 12/20] dma-iommu: Implement NESTED_MSI cookie
Date: Wed, 24 Oct 2018 19:02:59 +0100
Message-ID: <bd90bf0e-1bf6-244b-0ed6-0018ddc25eb4@arm.com>
References: <20180918142457.3325-1-eric.auger@redhat.com>
	<20180918142457.3325-13-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180918142457.3325-13-eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-GB
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yi.l.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org
Cc: tianyu.lan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, christoffer.dall-5wv7dgnIgG8@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On 2018-09-18 3:24 pm, Eric Auger wrote:
> Up to now, when the type was UNMANAGED, we used to
> allocate IOVA pages within a range provided by the user.
> This does not work in nested mode.
> 
> If both the host and the guest are exposed with SMMUs, each
> would allocate an IOVA. The guest allocates an IOVA (gIOVA)
> to map onto the guest MSI doorbell (gDB). The Host allocates
> another IOVA (hIOVA) to map onto the physical doorbell (hDB).
> 
> So we end up with 2 unrelated mappings, at S1 and S2:
>           S1             S2
> gIOVA    ->     gDB
>                 hIOVA    ->    hDB
> 
> The PCI device would be programmed with hIOVA.
> 
> iommu_dma_bind_doorbell allows to pass gIOVA/gDB to the host
> so that gIOVA can be used by the host instead of re-allocating
> a new IOVA. That way the host can create the following nested
> mapping:
> 
>           S1           S2
> gIOVA    ->    gDB    ->    hDB
> 
> this time, the PCI device will be programmed with the gIOVA MSI
> doorbell which is correctly map through the 2 stages.

If I'm understanding things correctly, this plus a couple of the 
preceding patches all add up to a rather involved way of coercing an 
automatic allocator to only "allocate" predetermined addresses in an 
entirely known-ahead-of-time manner. Given that the guy calling 
iommu_dma_bind_doorbell() could seemingly just as easily call 
iommu_map() at that point and not bother with an allocator cookie and 
all this machinery at all, what am I missing?

Robin.

> 
> Signed-off-by: Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> ---
> 
> v1 -> v2:
> - unmap stage2 on put()
> ---
>   drivers/iommu/dma-iommu.c | 97 +++++++++++++++++++++++++++++++++++++--
>   include/linux/dma-iommu.h | 11 +++++
>   2 files changed, 105 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index 511ff9a1d6d9..53444c3e8f2f 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -37,12 +37,14 @@
>   struct iommu_dma_msi_page {
>   	struct list_head	list;
>   	dma_addr_t		iova;
> +	dma_addr_t		ipa;
>   	phys_addr_t		phys;
>   };
>   
>   enum iommu_dma_cookie_type {
>   	IOMMU_DMA_IOVA_COOKIE,
>   	IOMMU_DMA_MSI_COOKIE,
> +	IOMMU_DMA_NESTED_MSI_COOKIE,
>   };
>   
>   struct iommu_dma_cookie {
> @@ -109,14 +111,17 @@ EXPORT_SYMBOL(iommu_get_dma_cookie);
>    *
>    * Users who manage their own IOVA allocation and do not want DMA API support,
>    * but would still like to take advantage of automatic MSI remapping, can use
> - * this to initialise their own domain appropriately. Users should reserve a
> + * this to initialise their own domain appropriately. Users may reserve a
>    * contiguous IOVA region, starting at @base, large enough to accommodate the
>    * number of PAGE_SIZE mappings necessary to cover every MSI doorbell address
> - * used by the devices attached to @domain.
> + * used by the devices attached to @domain. The other way round is to provide
> + * usable iova pages through the iommu_dma_bind_doorbell API (nested stages
> + * use case)
>    */
>   int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base)
>   {
>   	struct iommu_dma_cookie *cookie;
> +	int nesting, ret;
>   
>   	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
>   		return -EINVAL;
> @@ -124,7 +129,12 @@ int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base)
>   	if (domain->iova_cookie)
>   		return -EEXIST;
>   
> -	cookie = cookie_alloc(IOMMU_DMA_MSI_COOKIE);
> +	ret =  iommu_domain_get_attr(domain, DOMAIN_ATTR_NESTING, &nesting);
> +	if (!ret && nesting)
> +		cookie = cookie_alloc(IOMMU_DMA_NESTED_MSI_COOKIE);
> +	else
> +		cookie = cookie_alloc(IOMMU_DMA_MSI_COOKIE);
> +
>   	if (!cookie)
>   		return -ENOMEM;
>   
> @@ -145,6 +155,7 @@ void iommu_put_dma_cookie(struct iommu_domain *domain)
>   {
>   	struct iommu_dma_cookie *cookie = domain->iova_cookie;
>   	struct iommu_dma_msi_page *msi, *tmp;
> +	bool s2_unmap = false;
>   
>   	if (!cookie)
>   		return;
> @@ -152,7 +163,15 @@ void iommu_put_dma_cookie(struct iommu_domain *domain)
>   	if (cookie->type == IOMMU_DMA_IOVA_COOKIE && cookie->iovad.granule)
>   		put_iova_domain(&cookie->iovad);
>   
> +	if (cookie->type == IOMMU_DMA_NESTED_MSI_COOKIE)
> +		s2_unmap = true;
> +
>   	list_for_each_entry_safe(msi, tmp, &cookie->msi_page_list, list) {
> +		if (s2_unmap && msi->phys) {
> +			size_t size = cookie_msi_granule(cookie);
> +
> +			WARN_ON(iommu_unmap(domain, msi->ipa, size) != size);
> +		}
>   		list_del(&msi->list);
>   		kfree(msi);
>   	}
> @@ -161,6 +180,50 @@ void iommu_put_dma_cookie(struct iommu_domain *domain)
>   }
>   EXPORT_SYMBOL(iommu_put_dma_cookie);
>   
> +/**
> + * iommu_dma_bind_doorbell - Allows to provide a usable IOVA page
> + * @domain: domain handle
> + * @binding: IOVA/IPA binding
> + *
> + * In nested stage use case, the user can provide IOVA/IPA bindings
> + * corresponding to a guest MSI stage 1 mapping. When the host needs
> + * to map its own MSI doorbells, it can use the IPA as stage 2 input
> + * and map it onto the physical MSI doorbell.
> + */
> +int iommu_dma_bind_doorbell(struct iommu_domain *domain,
> +			    struct iommu_guest_msi_binding *binding)
> +{
> +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
> +	struct iommu_dma_msi_page *msi;
> +	dma_addr_t ipa, iova;
> +	size_t size;
> +
> +	if (!cookie)
> +		return -EINVAL;
> +
> +	if (cookie->type != IOMMU_DMA_NESTED_MSI_COOKIE)
> +		return -EINVAL;
> +
> +	size = 1 << binding->granule;
> +	iova = binding->iova & ~(phys_addr_t)(size - 1);
> +	ipa = binding->gpa & ~(phys_addr_t)(size - 1);
> +
> +	list_for_each_entry(msi, &cookie->msi_page_list, list) {
> +		if (msi->iova == iova)
> +			return 0; /* this page is already registered */
> +	}
> +
> +	msi = kzalloc(sizeof(*msi), GFP_KERNEL);
> +	if (!msi)
> +		return -ENOMEM;
> +
> +	msi->iova = iova;
> +	msi->ipa = ipa;
> +	list_add(&msi->list, &cookie->msi_page_list);
> +	return 0;
> +}
> +EXPORT_SYMBOL(iommu_dma_bind_doorbell);
> +
>   /**
>    * iommu_dma_get_resv_regions - Reserved region driver helper
>    * @dev: Device from iommu_get_resv_regions()
> @@ -846,6 +909,34 @@ static struct iommu_dma_msi_page *iommu_dma_get_msi_page(struct device *dev,
>   		if (msi_page->phys == msi_addr)
>   			return msi_page;
>   
> +	/*
> +	 * In nested stage mode, we do not allocate an MSI page in
> +	 * a range provided by the user. Instead, IOVA/IPA bindings are
> +	 * individually provided. We reuse thise IOVAs to build the
> +	 * IOVA -> IPA -> MSI PA nested stage mapping.
> +	 */
> +	if (cookie->type == IOMMU_DMA_NESTED_MSI_COOKIE) {
> +		list_for_each_entry(msi_page, &cookie->msi_page_list, list)
> +			if (!msi_page->phys) { /* this binding is free to use */
> +				dma_addr_t ipa = msi_page->ipa;
> +				int ret;
> +
> +				msi_page->phys = msi_addr;
> +
> +				/* do the stage 2 mapping */
> +				ret = iommu_map(domain, ipa, msi_addr, size,
> +						IOMMU_MMIO | IOMMU_WRITE);
> +				if (ret) {
> +					pr_warn("MSI S2 mapping failed (%d)\n",
> +						ret);
> +					return NULL;
> +				}
> +				return msi_page;
> +			}
> +		pr_warn("%s no MSI binding found\n", __func__);
> +		return NULL;
> +	}
> +
>   	msi_page = kzalloc(sizeof(*msi_page), GFP_ATOMIC);
>   	if (!msi_page)
>   		return NULL;
> diff --git a/include/linux/dma-iommu.h b/include/linux/dma-iommu.h
> index e8ca5e654277..324745eef644 100644
> --- a/include/linux/dma-iommu.h
> +++ b/include/linux/dma-iommu.h
> @@ -24,6 +24,7 @@
>   #include <linux/dma-mapping.h>
>   #include <linux/iommu.h>
>   #include <linux/msi.h>
> +#include <uapi/linux/iommu.h>
>   
>   int iommu_dma_init(void);
>   
> @@ -74,12 +75,15 @@ int iommu_dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
>   /* The DMA API isn't _quite_ the whole story, though... */
>   void iommu_dma_map_msi_msg(int irq, struct msi_msg *msg);
>   void iommu_dma_get_resv_regions(struct device *dev, struct list_head *list);
> +int iommu_dma_bind_doorbell(struct iommu_domain *domain,
> +			    struct iommu_guest_msi_binding *binding);
>   
>   #else
>   
>   struct iommu_domain;
>   struct msi_msg;
>   struct device;
> +struct iommu_guest_msi_binding;
>   
>   static inline int iommu_dma_init(void)
>   {
> @@ -104,6 +108,13 @@ static inline void iommu_dma_map_msi_msg(int irq, struct msi_msg *msg)
>   {
>   }
>   
> +static inline int
> +iommu_dma_bind_doorbell(struct iommu_domain *domain,
> +			struct iommu_guest_msi_binding *binding)
> +{
> +	return -ENODEV;
> +}
> +
>   static inline void iommu_dma_get_resv_regions(struct device *dev, struct list_head *list)
>   {
>   }
> 
