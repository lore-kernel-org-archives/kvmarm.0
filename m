From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [RFC v3 01/21] iommu: Introduce set_pasid_table API
Date: Fri, 11 Jan 2019 18:16:06 +0000
Message-ID: <0203e4ce-eace-be6e-7e95-5a02c069c8e8@arm.com>
References: <20190108102633.17482-1-eric.auger@redhat.com>
 <20190108102633.17482-2-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C81A4A486
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jan 2019 13:16:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qwvW8yqWYrP8 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Jan 2019 13:16:24 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E86B4A484
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jan 2019 13:16:24 -0500 (EST)
In-Reply-To: <20190108102633.17482-2-eric.auger@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: marc.zyngier@arm.com, kevin.tian@intel.com, ashok.raj@intel.com
List-Id: kvmarm@lists.cs.columbia.edu

On 08/01/2019 10:26, Eric Auger wrote:
> From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> 
> In virtualization use case, when a guest is assigned
> a PCI host device, protected by a virtual IOMMU on a guest,
> the physical IOMMU must be programmed to be consistent with
> the guest mappings. If the physical IOMMU supports two
> translation stages it makes sense to program guest mappings
> onto the first stage/level (ARM/VTD terminology) while to host
> owns the stage/level 2.
> 
> In that case, it is mandated to trap on guest configuration
> settings and pass those to the physical iommu driver.
> 
> This patch adds a new API to the iommu subsystem that allows
> to set the pasid table information.
> 
> A generic iommu_pasid_table_config struct is introduced in
> a new iommu.h uapi header. This is going to be used by the VFIO
> user API. We foresee at least two specializations of this struct,
> for PASID table passing and ARM SMMUv3.

Last sentence is a bit confusing. With SMMUv3 it is also used for the
PASID table, even when it only has one entry and PASID is disabled.

> Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
> Signed-off-by: Ashok Raj <ashok.raj@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> This patch generalizes the API introduced by Jacob & co-authors in
> https://lwn.net/Articles/754331/
> 
> v2 -> v3:
> - replace unbind/bind by set_pasid_table
> - move table pointer and pasid bits in the generic part of the struct
> 
> v1 -> v2:
> - restore the original pasid table name
> - remove the struct device * parameter in the API
> - reworked iommu_pasid_smmuv3
> ---
>  drivers/iommu/iommu.c      | 10 ++++++++
>  include/linux/iommu.h      | 14 +++++++++++
>  include/uapi/linux/iommu.h | 50 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 74 insertions(+)
>  create mode 100644 include/uapi/linux/iommu.h
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 3ed4db334341..0f2b7f1fc7c8 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1393,6 +1393,16 @@ int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(iommu_attach_device);
>  
> +int iommu_set_pasid_table(struct iommu_domain *domain,
> +			  struct iommu_pasid_table_config *cfg)
> +{
> +	if (unlikely(!domain->ops->set_pasid_table))
> +		return -ENODEV;
> +
> +	return domain->ops->set_pasid_table(domain, cfg);
> +}
> +EXPORT_SYMBOL_GPL(iommu_set_pasid_table);
> +
>  static void __iommu_detach_device(struct iommu_domain *domain,
>  				  struct device *dev)
>  {
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index e90da6b6f3d1..1da2a2357ea4 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -25,6 +25,7 @@
>  #include <linux/errno.h>
>  #include <linux/err.h>
>  #include <linux/of.h>
> +#include <uapi/linux/iommu.h>
>  
>  #define IOMMU_READ	(1 << 0)
>  #define IOMMU_WRITE	(1 << 1)
> @@ -184,6 +185,7 @@ struct iommu_resv_region {
>   * @domain_window_disable: Disable a particular window for a domain
>   * @of_xlate: add OF master IDs to iommu grouping
>   * @pgsize_bitmap: bitmap of all possible supported page sizes
> + * @set_pasid_table: set pasid table
>   */
>  struct iommu_ops {
>  	bool (*capable)(enum iommu_cap);
> @@ -226,6 +228,9 @@ struct iommu_ops {
>  	int (*of_xlate)(struct device *dev, struct of_phandle_args *args);
>  	bool (*is_attach_deferred)(struct iommu_domain *domain, struct device *dev);
>  
> +	int (*set_pasid_table)(struct iommu_domain *domain,
> +			       struct iommu_pasid_table_config *cfg);
> +
>  	unsigned long pgsize_bitmap;
>  };
>  
> @@ -287,6 +292,8 @@ extern int iommu_attach_device(struct iommu_domain *domain,
>  			       struct device *dev);
>  extern void iommu_detach_device(struct iommu_domain *domain,
>  				struct device *dev);
> +extern int iommu_set_pasid_table(struct iommu_domain *domain,
> +				 struct iommu_pasid_table_config *cfg);
>  extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
>  extern struct iommu_domain *iommu_get_dma_domain(struct device *dev);
>  extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
> @@ -696,6 +703,13 @@ const struct iommu_ops *iommu_ops_from_fwnode(struct fwnode_handle *fwnode)
>  	return NULL;
>  }
>  
> +static inline
> +int iommu_set_pasid_table(struct iommu_domain *domain,
> +			  struct iommu_pasid_table_config *cfg)
> +{
> +	return -ENODEV;
> +}
> +
>  #endif /* CONFIG_IOMMU_API */
>  
>  #ifdef CONFIG_IOMMU_DEBUGFS
> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
> new file mode 100644
> index 000000000000..7a7cf7a3de7c
> --- /dev/null
> +++ b/include/uapi/linux/iommu.h
> @@ -0,0 +1,50 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * IOMMU user API definitions
> + *
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.

I don't think we need both the boilerplate and the SPDX header

> + */
> +
> +#ifndef _UAPI_IOMMU_H
> +#define _UAPI_IOMMU_H
> +
> +#include <linux/types.h>
> +
> +/**
> + * SMMUv3 Stream Table Entry stage 1 related information
> + * @abort: shall the STE lead to abort
> + * @s1fmt: STE s1fmt field as set by the guest
> + * @s1dss: STE s1dss as set by the guest
> + * All field names match the smmu 3.0/3.1 spec (ARM IHI 0070A)

Not really the case for @abort. Could you clarify whether @abort is
valid in combination with @bypass?

> + */
> +struct iommu_pasid_smmuv3 {
> +	__u8 abort;
> +	__u8 s1fmt;
> +	__u8 s1dss;
> +};
> +
> +/**
> + * PASID table data used to bind guest PASID table to the host IOMMU
> + * Note PASID table corresponds to the Context Table on ARM SMMUv3.
> + *
> + * @version: API version to prepare for future extensions
> + * @format: format of the PASID table
> + *
> + */
> +struct iommu_pasid_table_config {
> +#define PASID_TABLE_CFG_VERSION_1 1
> +	__u32	version;
> +#define IOMMU_PASID_FORMAT_SMMUV3	(1 << 0)
> +	__u32	format;
> +	__u64	base_ptr;
> +	__u8	pasid_bits;
> +	__u8	bypass;

We need some padding, in case someone adds a new struct to the union
that requires 64-byte alignment

And 'bypass' might not be the right name if we're making it common,
maybe 'reset' would be clearer? Or we just need to explain that bypass
is the initial state of a nesting domain

Thanks,
Jean

> +	union {
> +		struct iommu_pasid_smmuv3 smmuv3;
> +	};
> +};
> +
> +#endif /* _UAPI_IOMMU_H */
> 
