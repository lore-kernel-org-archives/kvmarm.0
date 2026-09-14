Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 452A740B0FE;
	Mon, 14 Sep 2026 08:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789375105; cv=none; b=nPs+0ueBIm4/jdcpwTLWtSWJvO2wsanoIlolHL0MCY43n4xwlHkE2fdW8DKwhRodB6shOij/qehEC2eesHjb+ZqVjCbRJXbXmnjhxrvXYQAhqaHOzBEXhAG4KFXKNruY6Z1o8qtgwOHSu9hWV685rXiabK3OmA3QWSnfKlyNa8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789375105; c=relaxed/simple;
	bh=44Zxr0bAzy/FVaHYHhpGrc8BaI6/0sVp1yPuJiyTLok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pdh29jqzKvq1FsfbFs/lfLWFanSGAj7zL2Q4UPbhxhWLpfrM/RppnQRrD0Io1PNFVUDDNaSdsM5vbS1d3Fzdner0ibxUvcFKhiAkA215Afn7g1elTm25e/dYUOftW17HIYXeXXQgK4ZBKyioE7VCJAr9UJj4YtYFPJeJc2w4Mqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=trDYbUBd; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="trDYbUBd"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BFD041570;
	Mon, 14 Sep 2026 01:38:15 -0700 (PDT)
Received: from [10.0.128.139] (unknown [10.0.128.139])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CD7EC3F7B4;
	Mon, 14 Sep 2026 01:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789375099; bh=44Zxr0bAzy/FVaHYHhpGrc8BaI6/0sVp1yPuJiyTLok=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=trDYbUBd8UJwtxnr5vASuBR49N08Qhrp+erecALsuVHO5qeuyeEwlNO1jTQ9dzICy
	 5RBCJaUgzOIw888gkG3fO+hInEVEOdJFYEAqqhFfwfoUUcwZoBACn0bOu1n6gl1/G9
	 M/9oFTHq4omPIvlpXxn5YpbUoMmFgSEg5bpJPIF0=
Message-ID: <dc733a28-cbca-46cb-a4bd-14840b1a0cc1@arm.com>
Date: Mon, 14 Sep 2026 09:38:15 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 6/7] firmware: arm_rmm: Ensure the RMM has GPT entries
 for memory
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-7-suzuki.poulose@arm.com>
 <b2fd288e-e0e7-49cc-b0cb-933fba501d79@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <b2fd288e-e0e7-49cc-b0cb-933fba501d79@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14/09/2026 06:41, Gavin Shan wrote:
> On 9/12/26 6:36 PM, Suzuki K Poulose wrote:
>> From: Steven Price <steven.price@arm.com>
>>
>> The RMM maintains the state of all the granules in the system to make
>> sure that the host is abiding by the rules. This state can be maintained
>> at different granularity, per page (TRACKING_FINE) or per region
>> (TRACKING_COARSE or TRACKING_INTERMEDIATE). The region size depends on 
>> the
>> underlying "RMI_GRANULE_SIZE". For a "coarse"/"intermediate" region, 
>> all pages
>> in the region must be of the same state, this implies we need to have 
>> "fine"
>> tracking for DRAM, so that we can delegate individual pages.
>>
>> For now we only support a statically carved out memory for tracking
>> granules for the "fine" regions. This can be extended in the future to
>> allow modifying the tracking granularity and remove the need for a
>> static allocation by the firmware.
>>
>> Similarly, the firmware may create L0 GPT entries describing the total
>> address space. But if we change the "PAS" (Physical Address Space) of a
>> granule, then the firmware may need to create L1 tables to track the PAS
>> at a finer granularity. Linux therefore checks if the platform 
>> firmware manages
>> the PAR region. i.e., the firmware is in charge of managing the L1 GPTs
>> (creation and the required memory for the GPT tables - via static 
>> carveouts)
>> without host intervention. Support for dynamic GPT creation by the 
>> host will be
>> added later.
>>
>> If the firmware requires us to manage the tracking or GPT memory, 
>> Deactivate
>> the RMM and reclaim any memory donated at RMM activation.
>>
>> Apply the same checks when hotplugged memory is brought online.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> [ Switch to RMI_GPT_L1_INFO for checking GPTs and deactivate RMM ]
>> Co-Developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   Changes since v17:
>>       * Move wrappers that may not be used elsewhere, out of arm-rmi- 
>> cmds.h
>>   Changes since v16:
>>       * Check fine tracking and create L1 GPTs for hotplug-added memory.
>>       * Clarify the L1 GPT setup and move the explanatory comment.
>>       * Switch to using RMI_GPT_INFO command for checking the GPTs.
>>       * Deactivate the RMM and reclaim the memory if we can't proceed.
>>   Changes since v15:
>>       * Skip firmware-reserved NOMAP memory in rmi_init_metadata()
>>       * Handle negative error codes from wrappers.
>>   Changes since v14:
>>       * Move the implementation into drivers/firmware/arm_rmm.
>>   Changes since v13:
>>       * Moved out of KVM
>> ---
>>   drivers/firmware/arm_rmm/rmi.c | 200 +++++++++++++++++++++++++++++++++
>>   include/linux/arm-rmi-cmds.h   |   2 +
>>   2 files changed, 202 insertions(+)
>>
>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/ 
>> arm_rmm/rmi.c
>> index ecc89e91d264d..583e1aca9b15a 100644
>> --- a/drivers/firmware/arm_rmm/rmi.c
>> +++ b/drivers/firmware/arm_rmm/rmi.c
>> @@ -5,12 +5,15 @@
>>   #include <linux/cpufeature.h>
>>   #include <linux/memblock.h>
>> +#include <linux/memory.h>
>>   #include <linux/arm-rmi-cmds.h>
>>   #include <linux/slab.h>
>>   #include <asm/memory.h>
>>   #include <asm/pgtable-hwdef.h>
>> +static bool arm64_rmi_is_available;
>> +
>>   /* Currently only the first 2 registers are used by Linux */
>>   #define RMI_FEAT_REG_COUNT    2
>>   static unsigned long rmi_feat_reg_cache[RMI_FEAT_REG_COUNT] 
>> __ro_after_init;
>> @@ -68,6 +71,69 @@ static inline long 
>> rmi_granule_range_undelegate(unsigned long base,
>>       return ret;
>>   }
>> +/**
>> + * rmi_granule_tracking_get() - Get configuration of a Granule 
>> tracking region
>> + * @start: Base PA of the tracking region
>> + * @end: End of the PA region
>> + * @out_category: Memory category
>> + * @out_state: Tracking region state
>> + * @out_top: Top of the memory region
>> + *
>> + * Return: RMI return code
>> + */
>> +static inline int rmi_granule_tracking_get(unsigned long start,
>> +                       unsigned long end,
>> +                       unsigned long *out_category,
>> +                       unsigned long *out_state,
>> +                       unsigned long *out_top)
>> +{
>> +    struct arm_smccc_1_2_regs regs = {
>> +        SMC_RMI_GRANULE_TRACKING_GET, start, end,
>> +    };
>> +
>> +    rmi_smccc_invoke(&regs);
>> +
>> +    if (regs.a0 != RMI_SUCCESS)
>> +        return regs.a0;
>> +
>> +    if (out_category)
>> +        *out_category = regs.a1;
>> +    if (out_state)
>> +        *out_state = regs.a2;
>> +    if (out_top)
>> +        *out_top = regs.a3;
>> +
>> +    return RMI_SUCCESS;
>> +}
>> +
>> +/*
>> + * rmi_gpt_info - Query the GPT info for the given PAR.
>> + * @start: Base of the physical address region
>> + * @top: Top of the physical address region
>> + * @out_top: Top of the phyiscal address region for which
>> + *        the GPT @out_gpt_par_state is valid
>> + * @out_gpt_par_state: State of the GPT covered by [start, out_top)
>> + */
>> +static inline long rmi_gpt_info(unsigned long start, unsigned long end,
>> +                unsigned long *out_top,
>> +                unsigned long *out_gpt_par_state)
>> +{
>> +    struct arm_smccc_1_2_regs regs = {
>> +        SMC_RMI_GPT_INFO, start, end,
>> +    };
>> +
>> +    rmi_smccc_invoke(&regs);
>> +    if (regs.a0 != RMI_SUCCESS)
>> +        return regs.a0;
>> +
>> +    if (out_top)
>> +        *out_top = regs.a1;
>> +    if (out_gpt_par_state)
>> +        *out_gpt_par_state = regs.a2;
>> +
>> +    return RMI_SUCCESS;
>> +}
>> +
>>   /**
>>    * rmi_features() - Read feature register
>>    * @index: Feature register index
>> @@ -759,6 +825,124 @@ static int rmi_configure(void)
>>       return ret;
>>   }
>> +/*
>> + * Make sure the area is tracked by RMM at FINE granularity.
>> + * We do not support changing the tracking yet.
>> + */
>> +static int rmi_verify_memory_tracking(phys_addr_t start, phys_addr_t 
>> end)
>> +{
>> +    while (start < end) {
>> +        unsigned long ret, category, state, next;
>> +
>> +        ret = rmi_granule_tracking_get(start, end, &category, &state, 
>> &next);
>> +        if (ret != RMI_SUCCESS)
>> +            return -ENOMEM;
>> +
>> +        if (state != RMI_TRACKING_FINE ||
>> +            category != RMI_MEM_CATEGORY_CONVENTIONAL) {
>> +            /* TODO: Set granule tracking in this case */
>> +            pr_err("Granule tracking for region isn't fine/ 
>> conventional: %llx-%lx\n",
>> +                   start, next);
>> +            return -ENODEV;
>> +        }
>> +        start = next;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
> 
> I would suggest to drop rmi_granule_tracking_get() by combining its 
> logics into
> rmi_verify_memory_tracking().
> 
> /*
>   * Make sure the area is tracked by RMM at FINE granularity.
>   * We do not support changing the tracking yet.
>   */
> static int rmi_verify_memory_tracking(phys_addr_t start, phys_addr_t end)
> {
>          struct arm_smccc_1_2_regs args;
> 
>          while (start < end) {
>                  args.a0 = SMC_RMI_GRANULE_TRACKING_GET;
>                  args.a1 = start;
>                  args.a2 = end;
>                  rmi_smccc_invoke(&args);
> 
>                  if (args.a0 != RMI_SUCCESS)
>                          return -ENOMEM;
> 
>                  if (args.a1 != RMI_MEM_CATEGORY_CONVENTIONAL ||
>                      args.a2 != RMI_TRACKING_FINE) {
>                          /* TODO: Set granule tracking in this case */
>                          pr_err("Granule tracking for region isn't fine/ 
> conventional: %llx-%lx\n",
>                                  start, args.a3);
>                          return -ENODEV;

I have moved the wrappers closer to the caller, but retained them to
  make it easier to read the code.
  e.g., error conditions around next >= start etc.

>                  }
> 
>                  start = args.a3;
>          }
> 
>          return 0;
> }

...

> 
> I would suggest to drop rmi_gpt_info() by combining its logics into 
> rmi_verify_gpt_firmware_managed().
> 

Same as above.

>> +
>> +static int rmi_init_metadata(void)
>> +{
>> +    phys_addr_t start, end;
>> +    struct memblock_region *r;
>> +
>> +    for_each_mem_region(r) {
>> +        int ret;
>> +
>> +        /* Firmware-reserved NOMAP regions are not usable system RAM */
>> +        if (memblock_is_nomap(r))
>> +            continue;
>> +
>> +        start = memblock_region_memory_base_pfn(r) << PAGE_SHIFT;
>> +        end = memblock_region_memory_end_pfn(r) << PAGE_SHIFT;
>> +
> 
> nit: unnecessary to covert the physical address (struct 
> memblock_region::base and (base + size))
> to PFN and then convert PFN to physical address:
> 
>          start = PAGE_ALIGN(r->base);
>          end = PAGE_ALIGN_DOWN(r->base + r->size);
>          if (start >= end)
>              continue;

Yes, I have handled this already per Sashiko review comment.

Thank you for the review!

Cheers
Suzuki
