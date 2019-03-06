From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v4 02/22] iommu: introduce device fault data
Date: Wed, 6 Mar 2019 10:38:25 +0100
Message-ID: <43c5c3be-a609-62e1-efaa-c5571bb762c6@redhat.com>
References: <20190218135504.25048-1-eric.auger@redhat.com>
 <20190218135504.25048-3-eric.auger@redhat.com>
 <c9adfbda-b78a-405a-a691-9f99d7dc2a26@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c9adfbda-b78a-405a-a691-9f99d7dc2a26@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: marc.zyngier@arm.com, peter.maydell@linaro.org, kevin.tian@intel.com, ashok.raj@intel.com, christoffer.dall@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jean,

On 3/5/19 3:56 PM, Jean-Philippe Brucker wrote:
> On 18/02/2019 13:54, Eric Auger wrote:
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
>>
>> v3 -> v4:
>> - use a union containing aither an unrecoverable fault or a page
>>   request message. Move the device private data in the page request
>>   structure. Reshuffle the fields and use flags.
>> - move fault perm attributes to the uapi
>> - remove a bunch of iommu_fault_reason enum values that were related
>>   to internal errors
>> ---
>>  include/linux/iommu.h      |  47 +++++++++++++++
>>  include/uapi/linux/iommu.h | 115 +++++++++++++++++++++++++++++++++++++
>>  2 files changed, 162 insertions(+)
>>  create mode 100644 include/uapi/linux/iommu.h
>>
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index e90da6b6f3d1..032d33894723 100644
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
>> +typedef int (*iommu_dev_fault_handler_t)(struct iommu_fault_event *, void *);
>>  
>>  struct iommu_domain_geometry {
>>  	dma_addr_t aperture_start; /* First address that can be mapped    */
>> @@ -243,6 +246,49 @@ struct iommu_device {
>>  	struct device *dev;
>>  };
>>  
>> +/**
>> + * struct iommu_fault_event - Generic per device fault data
>> + *
>> + * - PCI and non-PCI devices
>> + * - Recoverable faults (e.g. page request), information based on PCI ATS
>> + *   and PASID spec.
> 
> "for example information based on PCI PRI and PASID extensions"? ATS+PRI
> have been integrated into the main spec, and only PRI is relevant here.
> 
>> + * - Un-recoverable faults of device interest
> 
> "of interest to device drivers"?

Simplified/Replaced by
"
* struct iommu_fault_event - Generic fault event
 *
 * Can represent recoverable faults such as a page requests or
 * unrecoverable faults such as DMA or IRQ remapping faults.
"
> 
>> + * - DMA remapping and IRQ remapping faults
>> + *
>> + * @fault: fault descriptor
>> + * @iommu_private: used by the IOMMU driver for storing fault-specific
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
>> + * @dev_fault_handler: Callback function to handle IOMMU faults at device level
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
>> + * TODO: migrate other per device data pointers under iommu_dev_data, e.g.
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
>> @@ -418,6 +464,7 @@ struct iommu_ops {};
>>  struct iommu_group {};
>>  struct iommu_fwspec {};
>>  struct iommu_device {};
>> +struct iommu_fault_param {};
>>  
>>  static inline bool iommu_present(struct bus_type *bus)
>>  {
>> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
>> new file mode 100644
>> index 000000000000..7ebf23ed6ccb
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
>> +/*  Generic fault types, can be expanded IRQ remapping fault */
>> +enum iommu_fault_type {
>> +	IOMMU_FAULT_DMA_UNRECOV = 1,	/* unrecoverable fault */
>> +	IOMMU_FAULT_PAGE_REQ,		/* page request fault */
>> +};
>> +
>> +enum iommu_fault_reason {
>> +	IOMMU_FAULT_REASON_UNKNOWN = 0,
>> +
>> +	/* Could not access the PASID table (fetch caused external abort) */
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
>> +	 * An external abort occurred fetching (or updating) a translation
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
>> +	/* Output address of a translation stage caused Address Size fault */
>> +	IOMMU_FAULT_REASON_OOR_ADDRESS,
>> +};
>> +
>> +/**
>> + * Unrecoverable fault data
>> + * @reason: reason of the fault
>> + * @addr: offending page address
>> + * @fetch_addr: address that caused a fetch abort, if any
>> + * @pasid: contains process address space ID, used in shared virtual memory
>> + * @perm: Requested permission access using by the incoming transaction
>> + *	IOMMU_FAULT_READ, IOMMU_FAULT_WRITE
> 
> Stale comment
removed
> 
>> + */
>> +struct iommu_fault_unrecoverable {
>> +	__u32	reason; /* enum iommu_fault_reason */
>> +#define IOMMU_FAULT_UNRECOV_PASID_VALID		(1 << 0)
>> +#define IOMMU_FAULT_UNRECOV_PERM_VALID		(1 << 1)
> 
> Not needed, since @perm is already a bitfield
not exactly, READ is encoded as 0. We need to differentiate read fault
from no perm provided. However if I follow your recommendation below and
transform the READ FAULT into a set bit this makes sense.

> 
>> +#define IOMMU_FAULT_UNRECOV_ADDR_VALID		(1 << 2)
>> +#define IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID	(1 << 3)
>> +	__u32	flags;
>> +	__u32	pasid;
>> +#define IOMMU_FAULT_PERM_WRITE	(1 << 0) /* write */
>> +#define IOMMU_FAULT_PERM_EXEC	(1 << 1) /* exec */
>> +#define IOMMU_FAULT_PERM_PRIV	(1 << 2) /* priviledged */
> 
> typo "privileged"
OK
> 
>> +#define IOMMU_FAULT_PERM_INST	(1 << 3) /* instruction */
> 
> Could you move these outside the struct definition? They are shared with
> the other struct. And it would be less confusing, from the device driver
> point of view, to merge those with the existing IOMMU_FAULT_* defines
> (but moving them to UAPI and making them bits)
ok I will look at this. Need to check if the read fault value is not
hardcoded anywhere.
> 
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
>> + * @perm: requested page permissions
>> + * @addr: page address
>> + */
>> +struct iommu_fault_page_request {
>> +#define IOMMU_FAULT_PAGE_REQUEST_PASID_PRESENT	(1 << 0)
> 
> PASID_VALID, to be consistent with the other set of flags?
OK
> 
>> +#define IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE	(1 << 1)
>> +#define IOMMU_FAULT_PAGE_REQUEST_PRIV_DATA	(1 << 2)
>> +	__u32   flags;
>> +	__u32	pasid;
>> +	__u32	grpid;
>> +	__u32	perm;
>> +	__u64	addr;
> 
> Given that we'll be reporting stall faults using this struct, it would
> be good to have the fetch_addr field and flag here as well.
OK
> 
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
> 
> What's the 'm' in "prm"? Maybe just "pr"?
This stands for page request message, I think this is the Intel's naming?

Thank you for the review.

Eric
> 
> Thanks,
> Jean
> 
>> +	};
>> +};
>> +#endif /* _UAPI_IOMMU_H */
>>
> 
