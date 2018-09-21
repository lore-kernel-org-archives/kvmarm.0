From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC v2 01/20] iommu: Introduce bind_pasid_table API
Date: Fri, 21 Sep 2018 11:45:36 +0200
Message-ID: <a90227f8-9986-7092-9f49-59f7a2713368@redhat.com>
References: <20180918142457.3325-1-eric.auger@redhat.com>
 <20180918142457.3325-2-eric.auger@redhat.com>
 <20180920102114.23e15767@jacob-builder>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180920102114.23e15767@jacob-builder>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com, tianyu.lan@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jacob,

On 9/20/18 7:21 PM, Jacob Pan wrote:
> On Tue, 18 Sep 2018 16:24:38 +0200
> Eric Auger <eric.auger@redhat.com> wrote:
> 
>> From: Jacob Pan <jacob.jun.pan@linux.intel.com>
>>
>> In virtualization use case, when a guest is assigned
>> a PCI host device, protected by a virtual IOMMU on a guest,
>> the physical IOMMU must be programmed to be consistent with
>> the guest mappings. If the physical IOMMU supports two
>> translation stages it makes sense to program guest mappings
>> onto the first stage/level (ARM/VTD terminology) while to host
>> owns the stage/level 2.
>>
>> In that case, it is mandated to trap on guest configuration
>> settings and pass those to the physical iommu driver.
>>
>> This patch adds a new API to the iommu subsystem that allows
>> to bind and unbind the guest configuration data to the host.
>>
>> A generic iommu_pasid_table_config struct is introduced in
>> a new iommu.h uapi header. This is going to be used by the VFIO
>> user API. We foresee at least two specializations of this struct,
>> for PASID table passing and ARM SMMUv3.
>>
>> Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
>> Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
>> Signed-off-by: Ashok Raj <ashok.raj@intel.com>
>> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> In practice, I think it would be simpler to have a single
>> set_pasid_table function instead of bind/unbind. The "bypass" field
>> tells the stage 1 is bypassed (equivalent to the unbind actually).
>> On userspace we have notifications that the device context has
>> changed. Calling either bind or unbind requires to have an understand
>> of what was the previous state and call different notifiers. So to me
>> the bind/unbind complexifies the user integration while not bring much
>> benefits.
>>
> I don't have strong preference and I think having a single function
> makes sense. In VT-d2, the bind/unbind operation is a result of PASID
> cache invalidation from the guest. So there is no symmetrical
> bind/unbin user calls.

OK thank you for the feedback.
> 
>> This patch generalizes the API introduced by Jacob & co-authors in
>> https://lwn.net/Articles/754331/
>>
>> v1 -> v2:
>> - restore the original pasid table name
>> - remove the struct device * parameter in the API
>> - reworked iommu_pasid_smmuv3
>> ---
>>  drivers/iommu/iommu.c      | 19 ++++++++++++++
>>  include/linux/iommu.h      | 21 +++++++++++++++
>>  include/uapi/linux/iommu.h | 52
>> ++++++++++++++++++++++++++++++++++++++ 3 files changed, 92
>> insertions(+) create mode 100644 include/uapi/linux/iommu.h
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 8c15c5980299..db2c7c9502ae 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -1362,6 +1362,25 @@ int iommu_attach_device(struct iommu_domain
>> *domain, struct device *dev) }
>>  EXPORT_SYMBOL_GPL(iommu_attach_device);
>>  
>> +int iommu_bind_pasid_table(struct iommu_domain *domain,
>> +			   struct iommu_pasid_table_config *cfg)
>> +{
>> +	if (unlikely(!domain->ops->bind_pasid_table))
>> +		return -ENODEV;
>> +
>> +	return domain->ops->bind_pasid_table(domain, cfg);
>> +}
>> +EXPORT_SYMBOL_GPL(iommu_bind_pasid_table);
>> +
>> +void iommu_unbind_pasid_table(struct iommu_domain *domain)
>> +{
>> +	if (unlikely(!domain->ops->unbind_pasid_table))
>> +		return;
>> +
>> +	domain->ops->unbind_pasid_table(domain);
>> +}
>> +EXPORT_SYMBOL_GPL(iommu_unbind_pasid_table);
>> +
>>  static void __iommu_detach_device(struct iommu_domain *domain,
>>  				  struct device *dev)
>>  {
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index 87994c265bf5..e56cad4863f7 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -25,6 +25,7 @@
>>  #include <linux/errno.h>
>>  #include <linux/err.h>
>>  #include <linux/of.h>
>> +#include <uapi/linux/iommu.h>
>>  
>>  #define IOMMU_READ	(1 << 0)
>>  #define IOMMU_WRITE	(1 << 1)
>> @@ -185,6 +186,8 @@ struct iommu_resv_region {
>>   * @domain_get_windows: Return the number of windows for a domain
>>   * @of_xlate: add OF master IDs to iommu grouping
>>   * @pgsize_bitmap: bitmap of all possible supported page sizes
>> + * @bind_pasid_table: bind pasid table
>> + * @unbind_pasid_table: unbind pasid table and restore defaults
>>   */
>>  struct iommu_ops {
>>  	bool (*capable)(enum iommu_cap);
>> @@ -231,6 +234,10 @@ struct iommu_ops {
>>  	int (*of_xlate)(struct device *dev, struct of_phandle_args
>> *args); bool (*is_attach_deferred)(struct iommu_domain *domain,
>> struct device *dev); 
>> +	int (*bind_pasid_table)(struct iommu_domain *domain,
>> +				struct iommu_pasid_table_config
>> *cfg);
>> +	void (*unbind_pasid_table)(struct iommu_domain *domain);
>> +
>>  	unsigned long pgsize_bitmap;
>>  };
>>  
>> @@ -292,6 +299,9 @@ extern int iommu_attach_device(struct
>> iommu_domain *domain, struct device *dev);
>>  extern void iommu_detach_device(struct iommu_domain *domain,
>>  				struct device *dev);
>> +extern int iommu_bind_pasid_table(struct iommu_domain *domain,
>> +				  struct iommu_pasid_table_config
>> *cfg); +extern void iommu_unbind_pasid_table(struct iommu_domain
>> *domain); extern struct iommu_domain *iommu_get_domain_for_dev(struct
>> device *dev); extern int iommu_map(struct iommu_domain *domain,
>> unsigned long iova, phys_addr_t paddr, size_t size, int prot);
>> @@ -684,6 +694,17 @@ const struct iommu_ops
>> *iommu_ops_from_fwnode(struct fwnode_handle *fwnode) return NULL;
>>  }
>>  
>> +static inline
>> +int iommu_bind_pasid_table(struct iommu_domain *domain,
>> +			   struct iommu_pasid_table_config *cfg)
>> +{
>> +	return -ENODEV;
>> +}
>> +static inline
>> +void iommu_unbind_pasid_table(struct iommu_domain *domain)
>> +{
>> +}
>> +
>>  #endif /* CONFIG_IOMMU_API */
>>  
>>  #ifdef CONFIG_IOMMU_DEBUGFS
>> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
>> new file mode 100644
>> index 000000000000..babec91ae7e1
>> --- /dev/null
>> +++ b/include/uapi/linux/iommu.h
>> @@ -0,0 +1,52 @@
>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> +/*
>> + * IOMMU user API definitions
>> + *
>> + *
>> + * This program is free software; you can redistribute it and/or
>> modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef _UAPI_IOMMU_H
>> +#define _UAPI_IOMMU_H
>> +
>> +#include <linux/types.h>
>> +
>> +/**
>> + * SMMUv3 Stream Table Entry stage 1 related information
>> + * @s1contextptr: Context Descriptor Table GPA
>> + * @abort: shall the STE lead to abort
>> + * @s1fmt: STE s1fmt field as set by the guest
>> + * @s1cdmax: STE s1cdmax as set by the guest
>> + * @s1dss: STE s1dss as set by the guest
>> + * All field names match the smmu 3.0/3.1 spec (ARM IHI 0070A)
>> + */
>> +struct iommu_pasid_smmuv3 {
>> +	__u64 s1contextptr;
>> +	__u8 bypass;
>> +	__u8 abort;
>> +	__u8 s1fmt;
>> +	__u8 s1cdmax;
>> +	__u8 s1dss;
>> +};
>> +
>> +/**
>> + * PASID table data used to bind guest PASID table to the host IOMMU
>> + * Note PASID table corresponds to the Context Table on ARM SMMUv3.
>> + *
>> + * @version: API version to prepare for future extensions
>> + * @format: format of the PASID table
>> + *
>> + */
>> +struct iommu_pasid_table_config {
> don;t you need some vendor neutral data such as 
>  * @base_ptr:	PASID table pointer
>  * @pasid_bits:	number of bits supported in the guest PASID table, must be less
>  *		or equal than the host supported PASID size.
At the moment I put those info in the vendor specific struct, ie.
iommu_pasid_smmuv3
s1contextptr = base_ptr whereas s1cdmax corresponds to the number of
entries pointed by S1contextptr.

I am open to moving those fields back to the generic part if their
semantic is shared by all the archs.

Thanks

Eric
> 
> 
>> +#define PASID_TABLE_CFG_VERSION_1 1
>> +	__u32 version;
>> +#define IOMMU_PASID_FORMAT_SMMUV3	(1 << 0)
>> +	__u32 format;
>> +	union {
>> +		struct iommu_pasid_smmuv3 smmuv3;
>> +	};
>> +};
>> +
>> +#endif /* _UAPI_IOMMU_H */
> 
