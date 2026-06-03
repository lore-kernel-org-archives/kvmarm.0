Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE8F73DB30D;
	Wed,  3 Jun 2026 15:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780501729; cv=none; b=o/7QueJwDs0wM+hJJCGPTWLFen5ZDNHYdq39ySlu64tnN6i0prIH1/aDxXCyw0dbSIdZpCLtfK//wFENoAJ/0iqOfvtB8slq3ldqJ0QLkQq8XhYQBdr+Y24XPSPfagA9iEr8aSlg8R91gn0BJgnhktrqmRjBWdjORgH22cD/4gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780501729; c=relaxed/simple;
	bh=1E551gN1dW3DaJrtslhBJb4Wsh1IeGzvKsbxMskfADE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LjjnDG6GsVSHLKerU8URZn47LY7Kdk9WyF5pm5OTr35UXjVBCHmKgcsofpP9Bf2k+n2OT0oju2jVWo9DwrBH970x9X3KPOfDfjI/8hLtdm1Eee16VKPKryirmhuO1perzcnCDgGYxhqb+0EtTQeOBWPC0a0PnpfsBd7OzittUss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lLwc+eGO; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lLwc+eGO"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63DC93562;
	Wed,  3 Jun 2026 08:48:42 -0700 (PDT)
Received: from [10.57.26.22] (unknown [10.57.26.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 060573F86F;
	Wed,  3 Jun 2026 08:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780501727; bh=1E551gN1dW3DaJrtslhBJb4Wsh1IeGzvKsbxMskfADE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lLwc+eGOzZ6ig1082EIChzXnvW+qOJp53mnLOfF6yFCNDKeKdjI92Azp9T9UECWO/
	 grDGPX/naVT5gcMwENdi96EyzSmVc8kdRlTb4vELbgdB6rQmcSDwF40NDTo324+whI
	 C68z/ZDsv0aO6Sb80Z3miZorgMoUDxMh5GZB8JJY=
Message-ID: <092d084f-dd9a-4181-8b09-79ddb482c021@arm.com>
Date: Wed, 3 Jun 2026 16:48:40 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 08/44] arm64: RMI: Ensure that the RMM has GPT entries
 for memory
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-9-steven.price@arm.com>
 <2ad282da-88fd-49ab-8145-964ff298ca83@redhat.com>
Content-Language: en-GB
From: Steven Price <steven.price@arm.com>
In-Reply-To: <2ad282da-88fd-49ab-8145-964ff298ca83@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 21/05/2026 01:58, Gavin Shan wrote:
> Hi Steven,
> 
> On 5/13/26 11:17 PM, Steven Price wrote:
>> The RMM maintains the state of all the granules in the system to make
>> sure that the host is abiding by the rules. This state can be maintained
>> at different granularity, per page (TRACKING_FINE) or per region
>> (TRACKING_COARSE). The region size depends on the underlying
>> "RMI_GRANULE_SIZE". For a "coarse" region all pages in the region must
>> be of the same state, this implies we need to have "fine" tracking for
>> DRAM, so that we can delegated individual pages.
>>
>> For now we only support a statically carved out memory for tracking
>> granules for the "fine" regions. This can be extended in the future to
>> allow modifying the tracking granularity and remove the need for a
>> static allocation.
>>
>> Similarly, the firmware may create L0 GPT entries describing the total
>> address space. But if we change the "PAS" (Physical Address Space) of a
>> granule then the firmware may need to create L1 tables to track the PAS
>> at a finer granularity.
>>
>> Note: support is currently missing for SROs which means that if the RMM
>> needs memory donating this will fail (and render CCA unusable in Linux).
>> This effectively means that the L1 GPT tables must be created before
>> Linux starts.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v13:
>>   * Moved out of KVM
>> ---
>>   arch/arm64/include/asm/rmi_cmds.h |   2 +
>>   arch/arm64/kernel/rmi.c           | 103 ++++++++++++++++++++++++++++++
>>   2 files changed, 105 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/
>> asm/rmi_cmds.h
>> index 9179934925c5..9078a2920a7c 100644
>> --- a/arch/arm64/include/asm/rmi_cmds.h
>> +++ b/arch/arm64/include/asm/rmi_cmds.h
>> @@ -33,6 +33,8 @@ struct rmi_sro_state {
>>   } while (RMI_RETURN_STATUS(res.a0) == RMI_BUSY ||            \
>>        RMI_RETURN_STATUS(res.a0) == RMI_BLOCKED)
>>   +bool rmi_is_available(void);
>> +
>>   unsigned long rmi_sro_execute(struct rmi_sro_state *sro, gfp_t gfp);
>>   void rmi_sro_free(struct rmi_sro_state *sro);
>>   diff --git a/arch/arm64/kernel/rmi.c b/arch/arm64/kernel/rmi.c
>> index a14ead5dedda..52a415e99500 100644
>> --- a/arch/arm64/kernel/rmi.c
>> +++ b/arch/arm64/kernel/rmi.c
>> @@ -7,6 +7,8 @@
>>     #include <asm/rmi_cmds.h>
>>   +static bool arm64_rmi_is_available;
>> +
>>   unsigned long rmm_feat_reg0;
>>   unsigned long rmm_feat_reg1;
>>   @@ -88,6 +90,102 @@ static int rmi_configure(void)
>>       return 0;
>>   }
>>   +/*
>> + * For now we set the tracking_region_size to 0 for
>> RMI_RMM_CONFIG_SET().
>> + * TODO: Support other tracking sizes (via Kconfig option).
>> + */
>> +#ifdef CONFIG_PAGE_SIZE_4KB
>> +#define RMM_GRANULE_TRACKING_SIZE    SZ_1G
>> +#elif defined(CONFIG_PAGE_SIZE_16KB)
>> +#define RMM_GRANULE_TRACKING_SIZE    SZ_32M
>> +#elif defined(CONFIG_PAGE_SIZE_64KB)
>> +#define RMM_GRANULE_TRACKING_SIZE    SZ_512M
>> +#endif
>> +
> 
> RMM_GRANULE_TRACKING_SIZE is never used in this series.

Ah, good spot. In a previous version the tracking size was necessary 
when walking below. But the spec was updated to a range based API so 
this is no longer necessary.

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
>> +        if (ret != RMI_SUCCESS ||
>> +            state != RMI_TRACKING_FINE ||
>> +            category != RMI_MEM_CATEGORY_CONVENTIONAL) {
>> +            /* TODO: Set granule tracking in this case */
>> +            pr_err("Granule tracking for region isn't fine/
>> conventional: %llx",
>> +                   start);
>> +            return -ENODEV;
>> +        }
>> +        start = next;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +static unsigned long rmi_l0gpt_size(void)
>> +{
>> +    return 1UL << (30 + FIELD_GET(RMI_FEATURE_REGISTER_1_L0GPTSZ,
>> +                      rmm_feat_reg1));
>> +}
>> +
> 
> rmi_l0gpt_size() is only used by rmi_create_gpts(), its logic can be
> combined to that function.

True - I think partly due to the long line I split this into a separate 
function. But I could do something like:

	unsigned long l0gpt_sz;

	l0gpt_sz = 1UL << (30 + FIELD_GET(RMI_FEATURE_REGISTER_1_L0GPTSZ,
					  rmi_feat_reg(1)));

which isn't too bad.

Thanks,
Steve

>> +static int rmi_create_gpts(phys_addr_t start, phys_addr_t end)
>> +{
>> +    unsigned long l0gpt_sz = rmi_l0gpt_size();
>> +
>> +    start = ALIGN_DOWN(start, l0gpt_sz);
>> +    end = ALIGN(end, l0gpt_sz);
>> +
>> +    while (start < end) {
>> +        int ret = rmi_gpt_l1_create(start);
>> +
>> +        /*
>> +         * Make sure the L1 GPT tables are created for the region.
>> +         * RMI_ERROR_GPT indicates the L1 table already exists.
>> +         */
>> +        if (ret && ret != RMI_ERROR_GPT) {
>> +            /*
>> +             * FIXME: Handle SRO so that memory can be donated for
>> +             * the tables.
>> +             */
>> +            pr_err("GPT Level1 table missing for %llx\n", start);
>> +            return -ENOMEM;
>> +        }
>> +        start += l0gpt_sz;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +static int rmi_init_metadata(void)
>> +{
>> +    phys_addr_t start, end;
>> +    const struct memblock_region *r;
>> +
>> +    for_each_mem_region(r) {
>> +        int ret;
>> +
>> +        start = memblock_region_memory_base_pfn(r) << PAGE_SHIFT;
>> +        end = memblock_region_memory_end_pfn(r) << PAGE_SHIFT;
>> +        ret = rmi_verify_memory_tracking(start, end);
>> +        if (ret)
>> +            return ret;
>> +        ret = rmi_create_gpts(start, end);
>> +        if (ret)
>> +            return ret;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +bool rmi_is_available(void)
>> +{
>> +    return arm64_rmi_is_available;
>> +}
>> +
>>   static int __init arm64_init_rmi(void)
>>   {
>>       /* Continue without realm support if we can't agree on a version */
>> @@ -101,6 +199,11 @@ static int __init arm64_init_rmi(void)
>>         if (rmi_configure())
>>           return 0;
>> +    if (rmi_init_metadata())
>> +        return 0;
>> +
>> +    arm64_rmi_is_available = true;
>> +    pr_info("RMI configured");
>>         return 0;
>>   }
> 
> Thanks,
> Gavin
> 

