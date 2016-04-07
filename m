From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v6 4/7] dma-reserved-iommu: alloc/free_reserved_iova_domain
Date: Thu, 7 Apr 2016 11:33:32 +0200
Message-ID: <5706296C.5010003@linaro.org>
References: <1459757222-2668-1-git-send-email-eric.auger@linaro.org>
 <1459757222-2668-5-git-send-email-eric.auger@linaro.org>
 <20160406170021.4087a955@t450s.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 433DA409A2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2016 05:33:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iIc-KKmrdmWz for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2016 05:33:23 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 97B08407A5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2016 05:33:23 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id n3so96476184wmn.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Apr 2016 02:34:47 -0700 (PDT)
In-Reply-To: <20160406170021.4087a955@t450s.home>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex Williamson <alex.williamson@redhat.com>
Cc: eric.auger@st.com, jason@lakedaemon.net, kvm@vger.kernel.org, patches@linaro.org, marc.zyngier@arm.com, joro@8bytes.org, will.deacon@arm.com, linux-kernel@vger.kernel.org, Manish.Jaggi@caviumnetworks.com, iommu@lists.linux-foundation.org, linux-arm-kernel@lists.infradead.org, tglx@linutronix.de, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex,
On 04/07/2016 01:00 AM, Alex Williamson wrote:
> On Mon,  4 Apr 2016 08:06:59 +0000
> Eric Auger <eric.auger@linaro.org> wrote:
> 
>> Introduce alloc/free_reserved_iova_domain in the IOMMU API.
>> alloc_reserved_iova_domain initializes an iova domain at a given
>> iova base address and with a given size. This iova domain will
>> be used to allocate iova within that window. Those IOVAs will be reserved
>> for special purpose, typically MSI frame binding. Allocation function
>> within the reserved iova domain will be introduced in subsequent patches.
>>
>> Those functions are implemented and exposed if CONFIG_IOMMU_DMA_RESERVED
>> is seta.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>
>> ---
>>
>> v5 -> v6:
>> - use spin lock instead of mutex
>>
>> v3 -> v4:
>> - formerly in "iommu/arm-smmu: implement alloc/free_reserved_iova_domain" &
>>   "iommu: add alloc/free_reserved_iova_domain"
>>
>> v2 -> v3:
>> - remove iommu_alloc_reserved_iova_domain & iommu_free_reserved_iova_domain
>>   static implementation in case CONFIG_IOMMU_API is not set
>>
>> v1 -> v2:
>> - moved from vfio API to IOMMU API
>> ---
>>  drivers/iommu/Kconfig              |  8 ++++
>>  drivers/iommu/Makefile             |  1 +
>>  drivers/iommu/dma-reserved-iommu.c | 75 ++++++++++++++++++++++++++++++++++++++
>>  include/linux/dma-reserved-iommu.h | 45 +++++++++++++++++++++++
>>  4 files changed, 129 insertions(+)
>>  create mode 100644 drivers/iommu/dma-reserved-iommu.c
>>  create mode 100644 include/linux/dma-reserved-iommu.h
>>
>> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
>> index dd1dc39..a5a1530 100644
>> --- a/drivers/iommu/Kconfig
>> +++ b/drivers/iommu/Kconfig
>> @@ -74,6 +74,12 @@ config IOMMU_DMA
>>  	select IOMMU_IOVA
>>  	select NEED_SG_DMA_LENGTH
>>  
>> +# IOMMU reserved IOVA mapping (MSI doorbell)
>> +config IOMMU_DMA_RESERVED
>> +	bool
>> +	select IOMMU_API
>> +	select IOMMU_IOVA
>> +
>>  config FSL_PAMU
>>  	bool "Freescale IOMMU support"
>>  	depends on PPC32
>> @@ -307,6 +313,7 @@ config SPAPR_TCE_IOMMU
>>  config ARM_SMMU
>>  	bool "ARM Ltd. System MMU (SMMU) Support"
>>  	depends on (ARM64 || ARM) && MMU
>> +	select IOMMU_DMA_RESERVED
>>  	select IOMMU_API
>>  	select IOMMU_IO_PGTABLE_LPAE
>>  	select ARM_DMA_USE_IOMMU if ARM
>> @@ -320,6 +327,7 @@ config ARM_SMMU
>>  config ARM_SMMU_V3
>>  	bool "ARM Ltd. System MMU Version 3 (SMMUv3) Support"
>>  	depends on ARM64 && PCI
>> +	select IOMMU_DMA_RESERVED
>>  	select IOMMU_API
>>  	select IOMMU_IO_PGTABLE_LPAE
>>  	select GENERIC_MSI_IRQ_DOMAIN
>> diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
>> index c6edb31..6c9ae99 100644
>> --- a/drivers/iommu/Makefile
>> +++ b/drivers/iommu/Makefile
>> @@ -2,6 +2,7 @@ obj-$(CONFIG_IOMMU_API) += iommu.o
>>  obj-$(CONFIG_IOMMU_API) += iommu-traces.o
>>  obj-$(CONFIG_IOMMU_API) += iommu-sysfs.o
>>  obj-$(CONFIG_IOMMU_DMA) += dma-iommu.o
>> +obj-$(CONFIG_IOMMU_DMA_RESERVED) += dma-reserved-iommu.o
>>  obj-$(CONFIG_IOMMU_IO_PGTABLE) += io-pgtable.o
>>  obj-$(CONFIG_IOMMU_IO_PGTABLE_ARMV7S) += io-pgtable-arm-v7s.o
>>  obj-$(CONFIG_IOMMU_IO_PGTABLE_LPAE) += io-pgtable-arm.o
>> diff --git a/drivers/iommu/dma-reserved-iommu.c b/drivers/iommu/dma-reserved-iommu.c
>> new file mode 100644
>> index 0000000..a461482
>> --- /dev/null
>> +++ b/drivers/iommu/dma-reserved-iommu.c
>> @@ -0,0 +1,75 @@
>> +/*
>> + * Reserved IOVA Management
>> + *
>> + * Copyright (c) 2015 Linaro Ltd.
>> + *              www.linaro.org
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +
>> +#include <linux/iommu.h>
>> +#include <linux/iova.h>
>> +
>> +int iommu_alloc_reserved_iova_domain(struct iommu_domain *domain,
>> +				     dma_addr_t iova, size_t size,
>> +				     unsigned long order)
>> +{
>> +	unsigned long granule, mask;
>> +	struct iova_domain *iovad;
>> +	unsigned long flags;
>> +	int ret = 0;
>> +
>> +	granule = 1UL << order;
>> +	mask = granule - 1;
>> +	if (iova & mask || (!size) || (size & mask))
>> +		return -EINVAL;
>> +
>> +	iovad = kzalloc(sizeof(struct iova_domain), GFP_KERNEL);
>> +	if (!iovad)
>> +		return -ENOMEM;
>> +
>> +	spin_lock_irqsave(&domain->reserved_lock, flags);
>> +
>> +	if (domain->reserved_iova_cookie) {
>> +		ret = -EEXIST;
>> +		goto free_unlock;
>> +	}
>> +
>> +	init_iova_domain(iovad, granule,
>> +			 iova >> order, (iova + size - 1) >> order);
>> +	domain->reserved_iova_cookie = iovad;
>> +	goto unlock;
>> +
>> +free_unlock:
>> +	kfree(iovad);
>> +unlock:
>> +	spin_unlock_irqrestore(&domain->reserved_lock, flags);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(iommu_alloc_reserved_iova_domain);
>> +
>> +void iommu_free_reserved_iova_domain(struct iommu_domain *domain)
>> +{
>> +	struct iova_domain *iovad =
>> +		(struct iova_domain *)domain->reserved_iova_cookie;
>> +	unsigned long flags;
>> +
>> +	if (!iovad)
>> +		return;
>> +
>> +	spin_lock_irqsave(&domain->reserved_lock, flags);
>> +
>> +	put_iova_domain(iovad);
>> +	kfree(iovad);
>> +
>> +	spin_unlock_irqrestore(&domain->reserved_lock, flags);
>> +}
> 
> The locking here looks wrong, reserved_iova_cookie needs to be read
 and
> cleared (currently missing) within the lock, the put and free can
> probably happen outside the lock. Likewise the init_iova_domain() in
> the alloc path probably doesn't need to iccur under spinlock, but
> testing and setting reserved_iova_cookie does.
I agree with our statements. Need to rewrite this down.

  Seems like a mutex
> would do for locking here, but maybe the rb-tree manipulation has
> reasons for using a spinlock.
I moved to a spinlock after Jean-Philippe spotted a call sequence
disallowing sleeps:
https://lkml.org/lkml/2016/3/10/216
... which I did not address correctly in this respin, focusing on this
wrong spinlock re-writing.

Thanks

Eric
  Thanks,
> 
> Alex
> 
>> +EXPORT_SYMBOL_GPL(iommu_free_reserved_iova_domain);
>> diff --git a/include/linux/dma-reserved-iommu.h b/include/linux/dma-reserved-iommu.h
>> new file mode 100644
>> index 0000000..5bf863b
>> --- /dev/null
>> +++ b/include/linux/dma-reserved-iommu.h
>> @@ -0,0 +1,45 @@
>> +/*
>> + * Copyright (c) 2015 Linaro Ltd.
>> + *              www.linaro.org
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +#ifndef __DMA_RESERVED_IOMMU_H
>> +#define __DMA_RESERVED_IOMMU_H
>> +
>> +#ifdef __KERNEL__
>> +#include <asm/errno.h>
>> +
>> +#ifdef CONFIG_IOMMU_DMA_RESERVED
>> +#include <linux/iommu.h>
>> +
>> +/**
>> + * iommu_alloc_reserved_iova_domain: allocate the reserved iova domain
>> + *
>> + * @domain: iommu domain handle
>> + * @iova: base iova address
>> + * @size: iova window size
>> + * @order: page order
>> + */
>> +int iommu_alloc_reserved_iova_domain(struct iommu_domain *domain,
>> +				     dma_addr_t iova, size_t size,
>> +				     unsigned long order);
>> +
>> +/**
>> + * iommu_free_reserved_iova_domain: free the reserved iova domain
>> + *
>> + * @domain: iommu domain handle
>> + */
>> +void iommu_free_reserved_iova_domain(struct iommu_domain *domain);
>> +
>> +#endif	/* CONFIG_IOMMU_DMA_RESERVED */
>> +#endif	/* __KERNEL__ */
>> +#endif	/* __DMA_RESERVED_IOMMU_H */
> 
