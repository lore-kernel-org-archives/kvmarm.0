From: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 5/5] vfio/type1: return MSI mapping requirements with
	VFIO_IOMMU_GET_INFO
Date: Thu, 7 Apr 2016 15:44:51 +0200
Message-ID: <57066453.4050300@linaro.org>
References: <1459758611-2972-1-git-send-email-eric.auger@linaro.org>
	<1459758611-2972-6-git-send-email-eric.auger@linaro.org>
	<20160406163225.1cbadeb6@t450s.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20160406163225.1cbadeb6-1yVPhWWZRC1BDLzU/O5InQ@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: julien.grall-5wv7dgnIgG8@public.gmane.org, eric.auger-qxv4g6HH51o@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Manish.Jaggi-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/07/2016 12:32 AM, Alex Williamson wrote:
> On Mon,  4 Apr 2016 08:30:11 +0000
> Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> 
>> This patch allows the user-space to know whether MSI addresses need to
>> be mapped in the IOMMU. The user-space uses VFIO_IOMMU_GET_INFO ioctl and
>> IOMMU_INFO_REQUIRE_MSI_MAP gets set if they need to.
>>
>> Also the number of IOMMU pages requested to map those is returned in
>> msi_iova_pages field. User-space must use this information to allocate an
>> IOVA contiguous region of size msi_iova_pages * ffs(iova_pgsizes) and pass
>> it with VFIO_IOMMU_MAP_DMA iotcl (VFIO_DMA_MAP_FLAG_MSI_RESERVED_IOVA set).
>>
>> Signed-off-by: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>
>> ---
>>
>> Currently it is assumed a single doorbell page is used per MSI controller.
>> This is the case for known ARM MSI controllers (GICv2M, GICv3 ITS, ...).
>> If an MSI controller were to expose more doorbells it could implement a
>> new callback at irq_chip interface.
>>
>> v4 -> v5:
>> - move msi_info and ret declaration within the conditional code
>>
>> v3 -> v4:
>> - replace former vfio_domains_require_msi_mapping by
>>   more complex computation of MSI mapping requirements, especially the
>>   number of pages to be provided by the user-space.
>> - reword patch title
>>
>> RFC v1 -> v1:
>> - derived from
>>   [RFC PATCH 3/6] vfio: Extend iommu-info to return MSIs automap state
>> - renamed allow_msi_reconfig into require_msi_mapping
>> - fixed VFIO_IOMMU_GET_INFO
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 147 ++++++++++++++++++++++++++++++++++++++++
>>  include/uapi/linux/vfio.h       |   2 +
>>  2 files changed, 149 insertions(+)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index b330b81..f1def50 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -39,6 +39,7 @@
>>  #include <linux/dma-reserved-iommu.h>
>>  #include <linux/irqdomain.h>
>>  #include <linux/msi.h>
>> +#include <linux/irq.h>
>>  
>>  #define DRIVER_VERSION  "0.2"
>>  #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>"
>> @@ -95,6 +96,17 @@ struct vfio_group {
>>  	struct list_head	next;
>>  };
>>  
>> +struct vfio_irq_chip {
>> +	struct list_head next;
>> +	struct irq_chip *chip;
>> +};
>> +
>> +struct vfio_msi_map_info {
>> +	bool mapping_required;
>> +	unsigned int iova_pages;
>> +	struct list_head irq_chip_list;
>> +};
>> +
>>  /*
>>   * This code handles mapping and unmapping of user data buffers
>>   * into DMA'ble space using the IOMMU
>> @@ -267,6 +279,127 @@ static int vaddr_get_pfn(unsigned long vaddr, int prot, unsigned long *pfn)
>>  	return ret;
>>  }
>>  
>> +#if defined(CONFIG_GENERIC_MSI_IRQ_DOMAIN) && defined(CONFIG_IOMMU_DMA_RESERVED)
>> +/**
>> + * vfio_dev_compute_msi_map_info: augment MSI mapping info (@data) with
>> + * the @dev device requirements.
>> + *
>> + * @dev: device handle
>> + * @data: opaque pointing to a struct vfio_msi_map_info
>> + *
>> + * returns 0 upon success or -ENOMEM
>> + */
>> +static int vfio_dev_compute_msi_map_info(struct device *dev, void *data)
>> +{
>> +	struct irq_domain *domain;
>> +	struct msi_domain_info *info;
>> +	struct vfio_msi_map_info *msi_info = (struct vfio_msi_map_info *)data;
>> +	struct irq_chip *chip;
>> +	struct vfio_irq_chip *iter, *new;
>> +
>> +	domain = dev_get_msi_domain(dev);
>> +	if (!domain)
>> +		return 0;
>> +
>> +	/* Let's compute the needs for the MSI domain */
>> +	info = msi_get_domain_info(domain);
>> +	chip = info->chip;
>> +	list_for_each_entry(iter, &msi_info->irq_chip_list, next) {
>> +		if (iter->chip == chip)
>> +			return 0;
>> +	}
>> +
>> +	new = kzalloc(sizeof(*new), GFP_KERNEL);
>> +	if (!new)
>> +		return -ENOMEM;
>> +
>> +	new->chip = chip;
>> +
>> +	list_add(&new->next, &msi_info->irq_chip_list);
>> +
>> +	/*
>> +	 * new irq_chip to be taken into account; we currently assume
>> +	 * a single iova doorbell by irq chip requesting MSI mapping
>> +	 */
>> +	msi_info->iova_pages += 1;
>> +	return 0;
>> +}
>> +
>> +/**
>> + * vfio_domain_compute_msi_map_info: compute MSI mapping requirements (@data)
>> + * for vfio_domain @d
>> + *
>> + * @d: vfio domain handle
>> + * @data: opaque pointing to a struct vfio_msi_map_info
>> + *
>> + * returns 0 upon success or -ENOMEM
>> + */
>> +static int vfio_domain_compute_msi_map_info(struct vfio_domain *d, void *data)
>> +{
>> +	int ret = 0;
>> +	struct vfio_msi_map_info *msi_info = (struct vfio_msi_map_info *)data;
>> +	struct vfio_irq_chip *iter, *tmp;
>> +	struct vfio_group *g;
>> +
>> +	msi_info->iova_pages = 0;
>> +	INIT_LIST_HEAD(&msi_info->irq_chip_list);
>> +
>> +	if (iommu_domain_get_attr(d->domain,
>> +				   DOMAIN_ATTR_MSI_MAPPING, NULL))
>> +		return 0;
>> +	msi_info->mapping_required = true;
>> +	list_for_each_entry(g, &d->group_list, next) {
>> +		ret = iommu_group_for_each_dev(g->iommu_group, msi_info,
>> +			   vfio_dev_compute_msi_map_info);
>> +		if (ret)
>> +			goto out;
>> +	}
>> +out:
>> +	list_for_each_entry_safe(iter, tmp, &msi_info->irq_chip_list, next) {
>> +		list_del(&iter->next);
>> +		kfree(iter);
>> +	}
>> +	return ret;
>> +}
>> +
>> +/**
>> + * vfio_compute_msi_map_info: compute MSI mapping requirements
>> + *
>> + * Do some MSI addresses need to be mapped? IOMMU page size?
>> + * Max number of IOVA pages needed by any domain to map MSI
>> + *
>> + * @iommu: iommu handle
>> + * @info: msi map info handle
>> + *
>> + * returns 0 upon success or -ENOMEM
>> + */
>> +static int vfio_compute_msi_map_info(struct vfio_iommu *iommu,
>> +				 struct vfio_msi_map_info *msi_info)
>> +{
>> +	int ret = 0;
>> +	struct vfio_domain *d;
>> +	unsigned long bitmap = ULONG_MAX;
>> +	unsigned int iova_pages = 0;
>> +
>> +	msi_info->mapping_required = false;
>> +
>> +	mutex_lock(&iommu->lock);
>> +	list_for_each_entry(d, &iommu->domain_list, next) {
>> +		bitmap &= d->domain->ops->pgsize_bitmap;
>> +		ret = vfio_domain_compute_msi_map_info(d, msi_info);
>> +		if (ret)
>> +			goto out;
>> +		if (msi_info->iova_pages > iova_pages)
>> +			iova_pages = msi_info->iova_pages;
>> +	}
>> +out:
>> +	msi_info->iova_pages = iova_pages;
>> +	mutex_unlock(&iommu->lock);
>> +	return ret;
>> +}
>> +
>> +#endif
>> +
>>  /*
>>   * Attempt to pin pages.  We really don't want to track all the pfns and
>>   * the iommu can only map chunks of consecutive pfns anyway, so get the
>> @@ -1179,6 +1312,20 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>>  
>>  		info.flags = VFIO_IOMMU_INFO_PGSIZES;
>>  
>> +#if defined(CONFIG_GENERIC_MSI_IRQ_DOMAIN) && defined(CONFIG_IOMMU_DMA_RESERVED)
>> +		{
>> +			struct vfio_msi_map_info msi_info;
>> +			int ret;
>> +
>> +			ret = vfio_compute_msi_map_info(iommu, &msi_info);
>> +			if (ret)
>> +				return ret;
>> +
>> +			if (msi_info.mapping_required)
>> +				info.flags |= VFIO_IOMMU_INFO_REQUIRE_MSI_MAP;
>> +			info.msi_iova_pages = msi_info.iova_pages;
>> +		}
>> +#endif
>>  		info.iova_pgsizes = vfio_pgsize_bitmap(iommu);
>>  
>>  		return copy_to_user((void __user *)arg, &info, minsz) ?
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index a49be8a..e3e501c 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -488,7 +488,9 @@ struct vfio_iommu_type1_info {
>>  	__u32	argsz;
>>  	__u32	flags;
>>  #define VFIO_IOMMU_INFO_PGSIZES (1 << 0)	/* supported page sizes info */
>> +#define VFIO_IOMMU_INFO_REQUIRE_MSI_MAP (1 << 1)/* MSI must be mapped */
>>  	__u64	iova_pgsizes;		/* Bitmap of supported page sizes */
>> +	__u32   msi_iova_pages;	/* number of IOVA pages needed to map MSIs */
>>  };
>>  
>>  #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
> 
> Take a look at the capability chain extensions I used for adding some
> new capabilities for vfio regions and let me know why we shouldn't do
> something similar for this info ioctl.  A fixed structure gets messy
> almost instantly when we start adding new fields to it.  Thanks,

Ok

Thank you for your time

Best Regards

Eric
> 
> Alex
> 
> c84982a vfio: Define capability chains
> d7a8d5e vfio: Add capability chain helpers
> ff63eb6 vfio: Define sparse mmap capability for regions
> 188ad9d vfio/pci: Include sparse mmap capability for MSI-X table regions
> c7bb4cb vfio: Define device specific region type capability
> 28541d4 vfio/pci: Add infrastructure for additional device specific regions
> 
