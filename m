From: Dennis Chen <dennis.chen-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v11 4/8] iommu/msi-iommu: initialization
Date: Wed, 20 Jul 2016 19:43:38 +0800
Message-ID: <20160720114337.GB1915@arm.com>
References: <1468932911-23062-1-git-send-email-eric.auger@redhat.com>
	<1468932911-23062-5-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1468932911-23062-5-git-send-email-eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, andre.przywara-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, robert.richter-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, nd-5wv7dgnIgG8@public.gmane.org, Manish.Jaggi-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,
Some small questions/comments below:

On Tue, Jul 19, 2016 at 12:55:07PM +0000, Eric Auger wrote:
> iommu_get/put_msi_cookie allocates/frees the resource used to store
> and ref count the MSI doorbell mappings. iommu_msi_set_aperture
> initializes the iova domain used for MSI IOVA allocation and sets the
> iommu domain's msi geometry.
> 
> The implementation relies on dma-iommu API and iova API.
> 
> New msi functions are fully implemented if CONFIG_IOMMU_MSI is set.
> 
> Signed-off-by: Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> ---
> v10:
> - split error management in iommu_msi_set_aperture
> 
> v9:
> - remove is_aperture_set and use iommu_domain_msi_aperture_valid helper
>   instead
> - set iommu domain's msi geometry
> 
> v8:
> - new design where msi-iommu relies on dma-iommu
> - remove the iommu_domain * from the doorbell_mapping struct
> - added is_aperture_set
> 
> v7:
> - fix locking
> - add iova_cache_get/put
> - static inline functions when CONFIG_IOMMU_DMA_RESERVED is not set
> - introduce struct reserved_iova_domain to encapsulate prot info &
>   add prot parameter in alloc_reserved_iova_domain
> 
> v5 -> v6:
> - use spin lock instead of mutex
> 
> v3 -> v4:
> - formerly in "iommu/arm-smmu: implement alloc/free_reserved_iova_domain" &
>   "iommu: add alloc/free_reserved_iova_domain"
> 
> v2 -> v3:
> - remove iommu_alloc_reserved_iova_domain & iommu_free_reserved_iova_domain
>   static implementation in case CONFIG_IOMMU_API is not set
> 
> v1 -> v2:
> - moved from vfio API to IOMMU API
> ---
>  drivers/iommu/Kconfig     |   7 ++++
>  drivers/iommu/Makefile    |   1 +
>  drivers/iommu/msi-iommu.c | 100 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/msi-iommu.h |  65 ++++++++++++++++++++++++++++++
>  4 files changed, 173 insertions(+)
>  create mode 100644 drivers/iommu/msi-iommu.c
>  create mode 100644 include/linux/msi-iommu.h
> 
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index ad08603..5ea1610 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -74,6 +74,11 @@ config IOMMU_DMA
>  	select IOMMU_IOVA
>  	select NEED_SG_DMA_LENGTH
>  
> +# IOMMU MSI mapping
> +config IOMMU_MSI
> +	bool
> +	select IOMMU_DMA
> +
>  config FSL_PAMU
>  	bool "Freescale IOMMU support"
>  	depends on PPC_E500MC || (COMPILE_TEST && PPC)
> @@ -296,6 +301,7 @@ config SPAPR_TCE_IOMMU
>  config ARM_SMMU
>  	bool "ARM Ltd. System MMU (SMMU) Support"
>  	depends on (ARM64 || ARM) && MMU
> +	select IOMMU_MSI
>  	select IOMMU_API
>  	select IOMMU_IO_PGTABLE_LPAE
>  	select ARM_DMA_USE_IOMMU if ARM
> @@ -309,6 +315,7 @@ config ARM_SMMU
>  config ARM_SMMU_V3
>  	bool "ARM Ltd. System MMU Version 3 (SMMUv3) Support"
>  	depends on ARM64 && PCI
> +	select IOMMU_MSI
>  	select IOMMU_API
>  	select IOMMU_IO_PGTABLE_LPAE
>  	select GENERIC_MSI_IRQ_DOMAIN
> diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
> index c6edb31..a381e66 100644
> --- a/drivers/iommu/Makefile
> +++ b/drivers/iommu/Makefile
> @@ -2,6 +2,7 @@ obj-$(CONFIG_IOMMU_API) += iommu.o
>  obj-$(CONFIG_IOMMU_API) += iommu-traces.o
>  obj-$(CONFIG_IOMMU_API) += iommu-sysfs.o
>  obj-$(CONFIG_IOMMU_DMA) += dma-iommu.o
> +obj-$(CONFIG_IOMMU_MSI) += msi-iommu.o
>  obj-$(CONFIG_IOMMU_IO_PGTABLE) += io-pgtable.o
>  obj-$(CONFIG_IOMMU_IO_PGTABLE_ARMV7S) += io-pgtable-arm-v7s.o
>  obj-$(CONFIG_IOMMU_IO_PGTABLE_LPAE) += io-pgtable-arm.o
> diff --git a/drivers/iommu/msi-iommu.c b/drivers/iommu/msi-iommu.c
> new file mode 100644
> index 0000000..de02ede
> --- /dev/null
> +++ b/drivers/iommu/msi-iommu.c
> @@ -0,0 +1,100 @@
> +/*
> + * Reserved IOVA Management
> + *
> + * Copyright (c) 2015 Linaro Ltd.
> + *              www.linaro.org
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/iommu.h>
> +#include <linux/dma-iommu.h>
> +#include <linux/msi-iommu.h>
> +#include <linux/spinlock.h>
> +#include <linux/iova.h>
> +
> +struct doorbell_mapping {
> +	struct kref		kref;
> +	struct list_head	next;
> +	phys_addr_t		addr;
> +	dma_addr_t		iova;
> +	size_t			size;
> +};
> +
> +struct doorbell_mapping_info {
> +	struct list_head list; /* list of doorbell mapping entries */
> +	spinlock_t lock;
> +};
> +
> +int iommu_get_msi_cookie(struct iommu_domain *domain)
> +{
> +	struct doorbell_mapping_info *dmi;
> +	int ret;
> +
> +	if (domain->msi_cookie || domain->iova_cookie)
> +		return -EINVAL;
> +
> +	ret = iommu_get_dma_cookie(domain);
> +	if (ret)
> +		return ret;
> +
> +	dmi = kzalloc(sizeof(*dmi), GFP_KERNEL);

if dmi == NULL here, 

> +
> +	INIT_LIST_HEAD(&dmi->list);
> +	spin_lock_init(&dmi->lock);

will the above 2-line codes triger kernel NULL pointer dereference panic message?
if so why don't we check dmi immediately after the kzalloc call like this:

	dmi = kzalloc(sizeof(*dmi), GFP_KERNEL);
	domain->msi_cookie = dmi;
	if (!dmi)
		return -ENOMEM;

> +	iova_cache_get();

	return iova_cache_get();
> +
> +	domain->msi_cookie = dmi;
> +
> +	return dmi ? 0 : -ENOMEM;
> +}
> +EXPORT_SYMBOL(iommu_get_msi_cookie);
> +
> +void iommu_put_msi_cookie(struct iommu_domain *domain)
> +{
> +	struct doorbell_mapping_info *dmi = domain->msi_cookie;
> +
> +	if (!dmi)
> +		return;
> +
> +	domain->msi_cookie = NULL;
> +
> +	WARN_ON(!list_empty(&dmi->list));
> +
> +	kfree(dmi);
> +	iommu_put_dma_cookie(domain);
> +	iova_cache_put();
> +}
> +EXPORT_SYMBOL(iommu_put_msi_cookie);
> +
> +int iommu_msi_set_aperture(struct iommu_domain *domain,
> +			   dma_addr_t start, dma_addr_t end)
> +{
> +	struct doorbell_mapping_info *dmi = domain->msi_cookie;
> +	int ret;
> +
> +	if (!dmi)
> +		return -ENODEV;
> +
> +	if (iommu_domain_msi_aperture_valid(domain))
> +		return -EINVAL;
> +
> +	ret = iommu_dma_init_domain(domain, start, end - start + 1);
> +
> +	if (!ret) {
> +		domain->msi_geometry.aperture_start = start;
> +		domain->msi_geometry.aperture_end = end;
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(iommu_msi_set_aperture);
> +
> diff --git a/include/linux/msi-iommu.h b/include/linux/msi-iommu.h
> new file mode 100644
> index 0000000..392aa6f
> --- /dev/null
> +++ b/include/linux/msi-iommu.h
> @@ -0,0 +1,65 @@
> +/*
> + * Copyright (c) 2015 Linaro Ltd.
> + *              www.linaro.org
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +#ifndef __MSI_IOMMU_H
> +#define __MSI_IOMMU_H
> +
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +
> +struct iommu_domain;
> +
> +#ifdef CONFIG_IOMMU_MSI
> +
> +/**
> + * iommu_get_msi_cookie - Acquire MSI mapping resources for a domain
> + * @domain: IOMMU domain to prepare for MSI mapping
> + *
> + * IOMMU drivers which require MSI mapping should normally call this
> + * from their domain_alloc callback when domain->type ==
> + * IOMMU_DOMAIN_UNMANAGED.
> + */
> +int iommu_get_msi_cookie(struct iommu_domain *domain);
> +
> +/**
> + * iommu_put_msi_cookie - Release a domain's MSI mapping resources
> + * @domain: IOMMU domain previously prepared by iommu_get_msi_cookie()
> + *
> + * IOMMU drivers requesting MSI mapping should normally call this from
> + * their domain_free callback.
> + */
> +void iommu_put_msi_cookie(struct iommu_domain *domain);
> +
> +/**
> + * iommu_msi_set_aperture: allocate the msi iova domain
> + * according to the specified start/end IOVAs
> + *
> + * @domain: iommu domain handle
> + * @start: MSI iova start address
> + * @end: MSI iova end address
> + */
> +int iommu_msi_set_aperture(struct iommu_domain *domain,
> +			   dma_addr_t start, dma_addr_t end);
> +
> +#else
> +
> +static inline int
> +iommu_msi_set_aperture(struct iommu_domain *domain,
> +		       dma_addr_t start, dma_addr_t end)
> +{
> +	return -ENOENT;
> +}
> +
> +#endif	/* CONFIG_IOMMU_MSI */
> +#endif	/* __MSI_IOMMU_H */
> -- 
> 1.9.1
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 
