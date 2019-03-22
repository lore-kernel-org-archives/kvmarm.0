From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v6 02/22] iommu: introduce device fault data
Date: Fri, 22 Mar 2019 09:00:27 +0100
Message-ID: <ccd64817-be47-0dcd-8293-4971a435892b@redhat.com>
References: <20190317172232.1068-1-eric.auger@redhat.com>
 <20190317172232.1068-3-eric.auger@redhat.com>
 <20190321150439.5aac2c01@jacob-builder>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190321150439.5aac2c01@jacob-builder>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com, kevin.tian@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org, vincent.stehle@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jacob,

On 3/21/19 11:04 PM, Jacob Pan wrote:
> On Sun, 17 Mar 2019 18:22:12 +0100
> Eric Auger <eric.auger@redhat.com> wrote:
> 
>> From: Jacob Pan <jacob.jun.pan@linux.intel.com>
>>
>> Device faults detected by IOMMU can be reported outside the IOMMU
>> subsystem for further processing. This patch introduces
>> a generic device fault data structure.
>>
>> The fault can be either an unrecoverable fault or a page request,
>> also referred to as a recoverable fault.
>>
>> We only care about non internal faults that are likely to be reported
>> to an external subsystem.
>>
>> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
>> Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
>> Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
>> Signed-off-by: Ashok Raj <ashok.raj@intel.com>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> v4 -> v5:
>> - simplified struct iommu_fault_event comment
>> - Moved IOMMU_FAULT_PERM outside of the struct
>> - Removed IOMMU_FAULT_PERM_INST
>> - s/IOMMU_FAULT_PAGE_REQUEST_PASID_PRESENT/
>>   IOMMU_FAULT_PAGE_REQUEST_PASID_VALID
>>
>> v3 -> v4:
>> - use a union containing aither an unrecoverable fault or a page
>>   request message. Move the device private data in the page request
>>   structure. Reshuffle the fields and use flags.
>> - move fault perm attributes to the uapi
>> - remove a bunch of iommu_fault_reason enum values that were related
>>   to internal errors
>> ---
>>  include/linux/iommu.h      |  44 ++++++++++++++
>>  include/uapi/linux/iommu.h | 115
>> +++++++++++++++++++++++++++++++++++++ 2 files changed, 159
>> insertions(+) create mode 100644 include/uapi/linux/iommu.h
>>
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index ffbbc7e39cee..c6f398f7e6e0 100644
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
>> @@ -48,6 +49,7 @@ struct bus_type;
>>  struct device;
>>  struct iommu_domain;
>>  struct notifier_block;
>> +struct iommu_fault_event;
>>  
>>  /* iommu fault flags */
>>  #define IOMMU_FAULT_READ	0x0
>> @@ -55,6 +57,7 @@ struct notifier_block;
>>  
>>  typedef int (*iommu_fault_handler_t)(struct iommu_domain *,
>>  			struct device *, unsigned long, int, void *);
>> +typedef int (*iommu_dev_fault_handler_t)(struct iommu_fault_event *,
>> void *); 
>>  struct iommu_domain_geometry {
>>  	dma_addr_t aperture_start; /* First address that can be
>> mapped    */ @@ -247,6 +250,46 @@ struct iommu_device {
>>  	struct device *dev;
>>  };
>>  
>> +/**
>> + * struct iommu_fault_event - Generic fault event
>> + *
>> + * Can represent recoverable faults such as a page requests or
>> + * unrecoverable faults such as DMA or IRQ remapping faults.
>> + *
>> + * @fault: fault descriptor
>> + * @iommu_private: used by the IOMMU driver for storing
>> fault-specific
>> + *                 data. Users should not modify this field before
>> + *                 sending the fault response.
>> + */
>> +struct iommu_fault_event {
>> +	struct iommu_fault fault;
>> +	u64 iommu_private;
>> +};
>> +
>> +/**
>> + * struct iommu_fault_param - per-device IOMMU fault data
>> + * @dev_fault_handler: Callback function to handle IOMMU faults at
>> device level
>> + * @data: handler private data
>> + *
>> + */
>> +struct iommu_fault_param {
>> +	iommu_dev_fault_handler_t handler;
>> +	void *data;
>> +};
>> +
>> +/**
>> + * struct iommu_param - collection of per-device IOMMU data
>> + *
>> + * @fault_param: IOMMU detected device fault reporting data
>> + *
>> + * TODO: migrate other per device data pointers under
>> iommu_dev_data, e.g.
>> + *	struct iommu_group	*iommu_group;
>> + *	struct iommu_fwspec	*iommu_fwspec;
>> + */
>> +struct iommu_param {
>> +	struct iommu_fault_param *fault_param;
>> +};
>> +
>>  int  iommu_device_register(struct iommu_device *iommu);
>>  void iommu_device_unregister(struct iommu_device *iommu);
>>  int  iommu_device_sysfs_add(struct iommu_device *iommu,
>> @@ -422,6 +465,7 @@ struct iommu_ops {};
>>  struct iommu_group {};
>>  struct iommu_fwspec {};
>>  struct iommu_device {};
>> +struct iommu_fault_param {};
>>  
>>  static inline bool iommu_present(struct bus_type *bus)
>>  {
>> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
>> new file mode 100644
>> index 000000000000..edcc0dda7993
>> --- /dev/null
>> +++ b/include/uapi/linux/iommu.h
>> @@ -0,0 +1,115 @@
>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> +/*
>> + * IOMMU user API definitions
>> + */
>> +
>> +#ifndef _UAPI_IOMMU_H
>> +#define _UAPI_IOMMU_H
>> +
>> +#include <linux/types.h>
>> +
>> +#define IOMMU_FAULT_PERM_WRITE	(1 << 0) /* write */
>> +#define IOMMU_FAULT_PERM_EXEC	(1 << 1) /* exec */
>> +#define IOMMU_FAULT_PERM_PRIV	(1 << 2) /* privileged */
>> +
>> +/*  Generic fault types, can be expanded IRQ remapping fault */
>> +enum iommu_fault_type {
>> +	IOMMU_FAULT_DMA_UNRECOV = 1,	/* unrecoverable fault */
>> +	IOMMU_FAULT_PAGE_REQ,		/* page request fault */
>> +};
>> +
>> +enum iommu_fault_reason {
>> +	IOMMU_FAULT_REASON_UNKNOWN = 0,
>> +
>> +	/* Could not access the PASID table (fetch caused external
>> abort) */
>> +	IOMMU_FAULT_REASON_PASID_FETCH,
>> +
>> +	/* pasid entry is invalid or has configuration errors */
>> +	IOMMU_FAULT_REASON_BAD_PASID_ENTRY,
>> +
>> +	/*
>> +	 * PASID is out of range (e.g. exceeds the maximum PASID
>> +	 * supported by the IOMMU) or disabled.
>> +	 */
>> +	IOMMU_FAULT_REASON_PASID_INVALID,
>> +
>> +	/*
>> +	 * An external abort occurred fetching (or updating) a
>> translation
>> +	 * table descriptor
>> +	 */
>> +	IOMMU_FAULT_REASON_WALK_EABT,
>> +
>> +	/*
>> +	 * Could not access the page table entry (Bad address),
>> +	 * actual translation fault
>> +	 */
>> +	IOMMU_FAULT_REASON_PTE_FETCH,
>> +
>> +	/* Protection flag check failed */
>> +	IOMMU_FAULT_REASON_PERMISSION,
>> +
>> +	/* access flag check failed */
>> +	IOMMU_FAULT_REASON_ACCESS,
>> +
>> +	/* Output address of a translation stage caused Address Size
>> fault */
>> +	IOMMU_FAULT_REASON_OOR_ADDRESS,
>> +};
>> +
> For VT-d scalable mode, fault reason can be further split into first
> level faults and second level faults. But since we pin the second level
> today and guest owns the first level, we only need to inject faults of
> the FL to vIOMMU. So I think this is fine today, I think this enum can
> be extended w/o a new version of the structure.

I think that's the same actually for SMMUv3. Here we only kept stage1
related fault reasons as stage2 should rather be kept internal to the
driver.

Thanks

Eric
> 
>> +/**
>> + * Unrecoverable fault data
>> + * @reason: reason of the fault
>> + * @addr: offending page address
>> + * @fetch_addr: address that caused a fetch abort, if any
>> + * @pasid: contains process address space ID, used in shared virtual
>> memory
>> + * @perm: Requested permission access using by the incoming
>> transaction
>> + * (IOMMU_FAULT_PERM_* values)
>> + */
>> +struct iommu_fault_unrecoverable {
>> +	__u32	reason; /* enum iommu_fault_reason */
>> +#define IOMMU_FAULT_UNRECOV_PASID_VALID		(1 << 0)
>> +#define IOMMU_FAULT_UNRECOV_PERM_VALID		(1 << 1)
>> +#define IOMMU_FAULT_UNRECOV_ADDR_VALID		(1 << 2)
>> +#define IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID	(1 << 3)
>> +	__u32	flags;
>> +	__u32	pasid;
>> +	__u32	perm;
>> +	__u64	addr;
>> +	__u64	fetch_addr;
>> +};
>> +
>> +/*
>> + * Page Request data (aka. recoverable fault data)
>> + * @flags : encodes whether the pasid is valid and whether this
>> + * is the last page in group
>> + * @pasid: pasid
>> + * @grpid: page request group index
>> + * @perm: requested page permissions (IOMMU_FAULT_PERM_* values)
>> + * @addr: page address
>> + */
>> +struct iommu_fault_page_request {
>> +#define IOMMU_FAULT_PAGE_REQUEST_PASID_VALID	(1 << 0)
>> +#define IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE	(1 << 1)
>> +#define IOMMU_FAULT_PAGE_REQUEST_PRIV_DATA	(1 << 2)
>> +	__u32   flags;
>> +	__u32	pasid;
>> +	__u32	grpid;
>> +	__u32	perm;
>> +	__u64	addr;
>> +	__u64	private_data[2];
>> +};
>> +
>> +/**
>> + * struct iommu_fault - Generic fault data
>> + *
>> + * @type contains fault type
>> + */
>> +
>> +struct iommu_fault {
>> +	__u32	type;   /* enum iommu_fault_type */
>> +	__u32	reserved;
>> +	union {
>> +		struct iommu_fault_unrecoverable event;
>> +		struct iommu_fault_page_request prm;
>> +	};
>> +};
>> +#endif /* _UAPI_IOMMU_H */
> 
> [Jacob Pan]
> 
