Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E44647A0DB;
	Wed,  9 Sep 2026 08:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788942838; cv=none; b=q5vCfrqKE9llAlmW0HTXB3iI3+mQp8/K528c9xoXLO9USm970le87rZLBjDRoJaXGUHpdK2silv+e536/KsYJLomYryVBSFSM9ZUaOfmb7utCLqH+10XCiWIFrHSzosIxD1ToFYDjZCZsSEQeKWRL2hyW4GIOsjh1ySppY6fdE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788942838; c=relaxed/simple;
	bh=E2NXkOXVm5eIOeHzLPV+I5ohnhnEVAdWslRC/hgInXE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GEhlJRIn27++ukL2vlbmHYH66WkZWo6B8/IoB2B8vns3+HD4yNswXOpJ90CieslyIfU5n7z/GAN4CDIU0WxCbppCX0TY06gX+V1ou9fvP9Sh7Uio73F8+9/iCIsUddr06CSoMv9JAOJAnoilzklF76aHqzXsFjJBslkppAxvEaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZyXYtoiv; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZyXYtoiv"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D3AEB1576;
	Wed,  9 Sep 2026 01:33:49 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4EDAC3F7D8;
	Wed,  9 Sep 2026 01:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788942833; bh=E2NXkOXVm5eIOeHzLPV+I5ohnhnEVAdWslRC/hgInXE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZyXYtoivKMKc/yGAurELQdxPLQlUzsDYfHuEVHUAl7ayfots+aieAxgoTT4P8mKkZ
	 P1Jf3MXw97lJcwHM6KNfOIVF+plWq/Rk7jG1Yral4RegL0dyZmALHeOTPg/8NnFjn7
	 MJyZpIC//mkHvHZHpEPPhainBzoyrW6q24UNfjUs=
Message-ID: <a4e7c150-d859-4cd7-ba5e-9fdf8dd0a8cd@arm.com>
Date: Wed, 9 Sep 2026 09:33:48 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 6/7] firmware: arm_rmm: Ensure the RMM has GPT entries
 for memory
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
 <20260907095942.1140734-7-suzuki.poulose@arm.com>
 <5d2aa6a0-61a3-4b0c-8866-58c4a7888de3@redhat.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <5d2aa6a0-61a3-4b0c-8866-58c4a7888de3@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 09/09/2026 07:40, Gavin Shan wrote:
> On 9/7/26 7:59 PM, Suzuki K Poulose wrote:
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
>>   drivers/firmware/arm_rmm/rmi.c | 139 +++++++++++++++++++++++++++++++++
>>   include/linux/arm-rmi-cmds.h   |  75 ++++++++++++++++++
>>   2 files changed, 214 insertions(+)
>>
>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/ 
>> arm_rmm/rmi.c
>> index d969c8738efde..34058e34188d3 100644
>> --- a/drivers/firmware/arm_rmm/rmi.c
>> +++ b/drivers/firmware/arm_rmm/rmi.c
>> @@ -5,6 +5,7 @@
>>   #include <linux/cpufeature.h>
>>   #include <linux/memblock.h>
>> +#include <linux/memory.h>
>>   #include <linux/arm-rmi-cmds.h>
>>   #include <linux/processor.h>
>>   #include <linux/slab.h>
>> @@ -12,6 +13,8 @@
>>   #include <asm/memory.h>
>>   #include <asm/pgtable-hwdef.h>
>> +static bool arm64_rmi_is_available;
>> +
>>   /* Currently only the first 2 registers are used by Linux */
>>   #define RMI_FEAT_REG_COUNT    2
>>   static __ro_after_init unsigned long 
>> rmi_feat_reg_cache[RMI_FEAT_REG_COUNT];
>> @@ -639,6 +642,124 @@ static int rmi_configure(void)
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
>> +/*
>> + * We do not support creating L1 GPTs yet. So, make sure that
>> + * all the regions are managed by the firmware.
>> + */
>> +static int rmi_verify_gpt_firmware_managed(phys_addr_t start, 
>> phys_addr_t end)
>> +{
>> +    unsigned long l0gpt_sz;
>> +    unsigned long next, par_state;
>> +
>> +    l0gpt_sz = 1UL << (30 + FIELD_GET(RMI_FEATURE_REGISTER_1_L0GPTSZ,
>> +                      rmi_feat_reg(1)));
>> +    start = ALIGN_DOWN(start, l0gpt_sz);
>> +    end = ALIGN(end, l0gpt_sz);
>> +
>> +    while (start < end) {
>> +        long ret = rmi_gpt_info(start, end, &next, &par_state);
>> +
>> +        if (ret != RMI_SUCCESS)
>> +            return -ENOMEM;
>> +
>> +        if (par_state != RMI_GPT_PAR_PLAT) {
>> +            pr_err("GPT for the region is not managed by firmware 
>> %llx-%lx\n",
>> +                start, next);
>> +            return -ENOMEM;
> 
> I guess -ENODEV is more appropriate:
> 
>              return -ENODEV

Ack

> 
>> +        }
>> +        start = next;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +static int rmi_prepare_memory(phys_addr_t start, phys_addr_t end)
>> +{
>> +    int ret;
>> +
>> +    ret = rmi_verify_memory_tracking(start, end);
>> +    if (ret)
>> +        return ret;
>> +
>> +    return rmi_verify_gpt_firmware_managed(start, end);
>> +}
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
>> +        ret = rmi_prepare_memory(start, end);
>> +        if (ret)
>> +            return ret;
> 
> The local variable 'start' and 'end' can be dropped:
> 
>          ret = 
> rmi_prepare_memory(PFN_PHYS(memblock_region_memory_base_pfn(r)),
>                       PFN_PHYS(memblock_region_memory_end_pfn(r)));
>          if (ret)
>              return ret;

It makes the code a bit more easier to read, so I would keep it.

> 
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +static int rmi_memory_notifier(struct notifier_block *nb,
>> +                   unsigned long action, void *data)
>> +{
>> +    struct memory_notify *arg = data;
>> +    phys_addr_t start, end;
>> +    int ret;
>> +
>> +    if (action != MEM_GOING_ONLINE)
>> +        return NOTIFY_DONE;
>> +
>> +    start = PFN_PHYS(arg->start_pfn);
>> +    end = PFN_PHYS(arg->start_pfn + arg->nr_pages);
>> +    ret = rmi_prepare_memory(start, end);
>> +
>> +    return notifier_from_errno(ret);
>> +}
>> +
>> +static struct notifier_block rmi_memory_nb = {
>> +    .notifier_call = rmi_memory_notifier,
>> +};
>> +
>> +bool is_rmi_available(void)
>> +{
>> +    return arm64_rmi_is_available;
>> +}
>> +EXPORT_SYMBOL_GPL(is_rmi_available);
>> +
>>   static int __init arm64_init_rmi(void)
>>   {
>>       int ret = 0;
>> @@ -666,8 +787,26 @@ static int __init arm64_init_rmi(void)
>>       if (ret) {
>>           pr_err("RMM activate failed\n");
>>           ret = ret < 0 ? ret : -ENXIO;
>> +        goto out_free_sro;
>>       }
>> +    ret = rmi_init_metadata();
>> +    if (ret)
>> +        goto out_deactivate;
>> +
>> +    ret = register_memory_notifier(&rmi_memory_nb);
>> +    if (ret)
>> +        goto out_deactivate;
>> +
>> +    arm64_rmi_is_available = true;
>> +    pr_info("RMI configured\n");
>> +    kfree(sro);
>> +
>> +    return 0;
>> +
>> +out_deactivate:
>> +    rmi_rmm_deactivate(sro);
>> +out_free_sro:
>>       kfree(sro);
>>       return ret;
>>   }
>> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
>> index dea7c7004d35f..79e2c1f165112 100644
>> --- a/include/linux/arm-rmi-cmds.h
>> +++ b/include/linux/arm-rmi-cmds.h
>> @@ -35,6 +35,8 @@ static inline int rmi_undelegate_page(phys_addr_t phys)
>>       return rmi_undelegate_range(phys, PAGE_SIZE);
>>   }
>> +bool is_rmi_available(void);
>> +
>>   long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t gfp);
>>   void rmi_sro_free(struct rmi_sro_state *sro);
>>   long rmi_sro_execute(struct arm_smccc_1_2_regs *regs);
>> @@ -64,6 +66,19 @@ static inline int rmi_rmm_config_set(unsigned long 
>> cfg_ptr)
>>       return res.a0;
>>   }
>> +/**
>> + * rmi_rmm_deactivate() - Deactivate the RMM and reclaim any memory 
>> donated at
>> + * rmi_rmm_activate()
>> + *
>> + * @sro: Preallocated SRO context to be used
>> + *
>> + * Return: 0 on success, positive RMI result code or negative Linux 
>> error code
>> + */
>> +static inline long rmi_rmm_deactivate(struct rmi_sro_state *sro)
>> +{
>> +    return rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_RMM_DEACTIVATE);
>> +}
>> +
> 
> It seems rmi_rmm_deactivate() is used for once by 
> rmi.c::arm64_init_rmi(). If so,
> we needn't to expose this function and just combine the logics to 
> rmi.c::arm64_init_rmi().

True, for now. But we might want to deactivate the RMM from, e.g., say
kexec in the future. I could move it in for now, and expose this when
we get to use it.

> 
>>   /**
>>    * rmi_rmm_activate() - Activate the RMM
>>    * @sro: Preallocated SRO context to be used
>> @@ -75,6 +90,66 @@ static inline long rmi_rmm_activate(struct 
>> rmi_sro_state *sro)
>>       return rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_RMM_ACTIVATE);
>

>> +static inline int rmi_granule_tracking_get(unsigned long start,
>> +                       unsigned long end,
>> +                       unsigned long *out_category,
>> +                       unsigned long *out_state,
>> +                       unsigned long *out_top)
>> +{


>> +
>> +    return res.a0;
>> +}
>> +
> 
> rmi_granule_tracking_get() is used for once by 
> rmi.c::rmi_verify_memory_tracking(). We needn't
> expose rmi_granule_tracking_get() and combine its logic into 
> rmi.c::rmi_verify_memory_tracking().

Ack


> 
>> +/*
>> + * rmi_gpt_info - Query the GPT info for the given PAR.
>> + * @base: Base of the physical address region
>> + * @top: Top of the physical address region
>> + * @out_top: Top of the phyiscal address region for which
>> + *        the GPT @out_gpt_par_state is valid
>> + * @out_gpt_par_state: State of the GPT covered by [base, out_top)
>> + */
>> +static inline long rmi_gpt_info(unsigned long base, unsigned long end,
>> +                   unsigned long *out_top,
>> +                   unsigned long *out_gpt_par_state)
>> +{


>> +    return ret;
>> +}
>> +
> 
> Similarly, rmi_gpt_info() is used for once by 
> rmi.c::rmi_verify_gpt_firmware_managed(). We
> needn't expose this function and can combine the logic to 
> rmi.c::rmi_verify_gpt_firmware_managed().

Ack

Suzuki

