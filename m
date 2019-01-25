From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC v3 01/21] iommu: Introduce set_pasid_table API
Date: Fri, 25 Jan 2019 10:20:34 +0100
Message-ID: <668880de-e967-6290-c842-54e2796f3bfe@redhat.com>
References: <20190108102633.17482-1-eric.auger@redhat.com>
 <20190108102633.17482-2-eric.auger@redhat.com>
 <20190111114316.71e77d5f@x1.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190111114316.71e77d5f@x1.home>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Williamson <alex.williamson@redhat.com>
Cc: eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com, kevin.tian@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex,

On 1/11/19 7:43 PM, Alex Williamson wrote:
> On Tue,  8 Jan 2019 11:26:13 +0100
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
>> to set the pasid table information.
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
>> This patch generalizes the API introduced by Jacob & co-authors in
>> https://lwn.net/Articles/754331/
>>
>> v2 -> v3:
>> - replace unbind/bind by set_pasid_table
>> - move table pointer and pasid bits in the generic part of the struct
>>
>> v1 -> v2:
>> - restore the original pasid table name
>> - remove the struct device * parameter in the API
>> - reworked iommu_pasid_smmuv3
>> ---
>>  drivers/iommu/iommu.c      | 10 ++++++++
>>  include/linux/iommu.h      | 14 +++++++++++
>>  include/uapi/linux/iommu.h | 50 ++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 74 insertions(+)
>>  create mode 100644 include/uapi/linux/iommu.h
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 3ed4db334341..0f2b7f1fc7c8 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -1393,6 +1393,16 @@ int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
>>  }
>>  EXPORT_SYMBOL_GPL(iommu_attach_device);
>>  
>> +int iommu_set_pasid_table(struct iommu_domain *domain,
>> +			  struct iommu_pasid_table_config *cfg)
>> +{
>> +	if (unlikely(!domain->ops->set_pasid_table))
>> +		return -ENODEV;
>> +
>> +	return domain->ops->set_pasid_table(domain, cfg);
>> +}
>> +EXPORT_SYMBOL_GPL(iommu_set_pasid_table);
>> +
>>  static void __iommu_detach_device(struct iommu_domain *domain,
>>  				  struct device *dev)
>>  {
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index e90da6b6f3d1..1da2a2357ea4 100644
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
>> @@ -184,6 +185,7 @@ struct iommu_resv_region {
>>   * @domain_window_disable: Disable a particular window for a domain
>>   * @of_xlate: add OF master IDs to iommu grouping
>>   * @pgsize_bitmap: bitmap of all possible supported page sizes
>> + * @set_pasid_table: set pasid table
>>   */
>>  struct iommu_ops {
>>  	bool (*capable)(enum iommu_cap);
>> @@ -226,6 +228,9 @@ struct iommu_ops {
>>  	int (*of_xlate)(struct device *dev, struct of_phandle_args *args);
>>  	bool (*is_attach_deferred)(struct iommu_domain *domain, struct device *dev);
>>  
>> +	int (*set_pasid_table)(struct iommu_domain *domain,
>> +			       struct iommu_pasid_table_config *cfg);
>> +
>>  	unsigned long pgsize_bitmap;
>>  };
>>  
>> @@ -287,6 +292,8 @@ extern int iommu_attach_device(struct iommu_domain *domain,
>>  			       struct device *dev);
>>  extern void iommu_detach_device(struct iommu_domain *domain,
>>  				struct device *dev);
>> +extern int iommu_set_pasid_table(struct iommu_domain *domain,
>> +				 struct iommu_pasid_table_config *cfg);
>>  extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
>>  extern struct iommu_domain *iommu_get_dma_domain(struct device *dev);
>>  extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
>> @@ -696,6 +703,13 @@ const struct iommu_ops *iommu_ops_from_fwnode(struct fwnode_handle *fwnode)
>>  	return NULL;
>>  }
>>  
>> +static inline
>> +int iommu_set_pasid_table(struct iommu_domain *domain,
>> +			  struct iommu_pasid_table_config *cfg)
>> +{
>> +	return -ENODEV;
>> +}
>> +
>>  #endif /* CONFIG_IOMMU_API */
>>  
>>  #ifdef CONFIG_IOMMU_DEBUGFS
>> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
>> new file mode 100644
>> index 000000000000..7a7cf7a3de7c
>> --- /dev/null
>> +++ b/include/uapi/linux/iommu.h
>> @@ -0,0 +1,50 @@
>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> +/*
>> + * IOMMU user API definitions
>> + *
>> + *
>> + * This program is free software; you can redistribute it and/or modify
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
>> + * @abort: shall the STE lead to abort
>> + * @s1fmt: STE s1fmt field as set by the guest
>> + * @s1dss: STE s1dss as set by the guest
>> + * All field names match the smmu 3.0/3.1 spec (ARM IHI 0070A)
>> + */
>> +struct iommu_pasid_smmuv3 {
>> +	__u8 abort;
>> +	__u8 s1fmt;
>> +	__u8 s1dss;
>> +};
>> +
> 
> I can find STE.S1DSS and STE.S1FMT in the spec, but not STE.ABORT, is
> this something to do with Config[2:0]?  Are we allowed to describe what
> these fields are beyond their name and why they're necessary here vs
> the other fields or do the spec restrictions preclude that?
Yes you're right abort matches !Config[2]

what about:

/**
 * SMMUv3 Stream Table Entry stage 1 related information
 * The PASID table is referred to as the context descriptor (CD) table.
 *
 * @s1fmt: STE s1fmt (format of the CD table: single CD, linear table
   or 2-level table)
 * @s1dss: STE s1dss (specifies the behavior when pasid_bits != 0
   an no pasid is passed along with the incoming transaction)
 * Please refer to the smmu 3.x spec (ARM IHI 0070A) for full details
 */
struct iommu_pasid_smmuv3 {
#define PASID_TABLE_SMMUV3_CFG_VERSION_1 1
        __u32   version;
        __u8 s1fmt;
        __u8 s1dss;
        __u8 padding[2];
};


> 
>> +/**
>> + * PASID table data used to bind guest PASID table to the host IOMMU
>> + * Note PASID table corresponds to the Context Table on ARM SMMUv3.
>> + *
>> + * @version: API version to prepare for future extensions
>> + * @format: format of the PASID table
>> + *
>> + */
>> +struct iommu_pasid_table_config {
>> +#define PASID_TABLE_CFG_VERSION_1 1
>> +	__u32	version;
>> +#define IOMMU_PASID_FORMAT_SMMUV3	(1 << 0)
>> +	__u32	format;
>> +	__u64	base_ptr;
>> +	__u8	pasid_bits;
>> +	__u8	bypass;
>> +	union {
>> +		struct iommu_pasid_smmuv3 smmuv3;
>> +	};
>> +};
> 
> Structure is not naturally aligned or explicitly aligned for
> interchange with userspace.  It might work for smmuv3 since the
> structure is only composed of bytes, but looks troublesome in general.
> Should each format type also contain a version?  Is format intended to
> be a bit-field or a signature?  It seems we only need a signature, but
> only having a single format defined, it looks like a bit-field, which
> makes me worry what we do when we exhaust the bits.

I think a signature is what we need.

  The bypass field
> should be better defined, is it 0/1?  zero/non-zero?  more selective?

I suggest to replace by a signature config field (bypass, abort, translate)

Thanks

Eric
> Thanks,
> 
> Alex
> 
>> +
>> +#endif /* _UAPI_IOMMU_H */
> 
