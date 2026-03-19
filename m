Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6978A3E51F4;
	Thu, 19 Mar 2026 15:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773933625; cv=none; b=oV+wX8Chcs0vfixj8DMgnvdh635vdZ5Pb/lB3PJj2lBeDGjVrTjn14pzY+9ilpSpydhi1Vm2ZIkUe3zYntg0NOCRTrsPYdDXzTBP0Lwfcr8DZXF485OU2qO56nBiEW+a0bl1EAPfggY5/NMIM8AjEkwJIVGfbpQNvLYkx2qZ0xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773933625; c=relaxed/simple;
	bh=+3sQrpjOuKdIAlirdE28mVLzCO8eM4+rqElVdhsuQ4A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fk/xqlQfBPUrl95vOp3Qs9wJLzfhqCHbTNVNubknv9FLhp2y3aEWR4kP1u9dmcEjpNCxaTwqU9xVz7WhKVGv706oEaPwffbVwCoVm7eLZGpsksgacPL3wtNcupvdBYfUHAku1EzDuR0iAGUkWEMCxbfCEfBYlHQKCGC6P6zStDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CA131A25;
	Thu, 19 Mar 2026 08:20:15 -0700 (PDT)
Received: from [10.1.35.24] (e122027.cambridge.arm.com [10.1.35.24])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 557F43F778;
	Thu, 19 Mar 2026 08:20:17 -0700 (PDT)
Message-ID: <a1779d7a-1680-483f-be6c-791ac4d219e1@arm.com>
Date: Thu, 19 Mar 2026 15:20:15 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 10/48] arm64: RMI: Ensure that the RMM has GPT entries
 for memory
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-11-steven.price@arm.com>
 <b83d601c-c4a0-4e6b-aae0-e49f02e67e30@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <b83d601c-c4a0-4e6b-aae0-e49f02e67e30@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 19/03/2026 10:31, Suzuki K Poulose wrote:
> Hi Steven
> 
> On 18/03/2026 15:53, Steven Price wrote:
>> The RMM may not be tracking all the memory of the system at boot. Create
> 
> Looks good to me. Please find some suggestions below.
> 
> 
> May be add a bit more context here :
> 
> RMM maintains the state of all the granules in the System to make sure
> that the host is abiding by the rules. This state can be maintained at
> different granularity - per PAGE (TRACKING_FINE) or per region (COARSE),
> where the "region size" depends on the underlying "RMI_GRANULE_SIZE".
> The state of the "tracked area" must be the same. This implies, we may
> need to have "FINE" tracking for DRAM, so that we can start delegating
> PAGEs. For now, we only support RMM with statically carved out memory
> for tracking FINE granularity for the tracking regions. We will extend
> the support for modifying the TRACKING region in the future.
> 
> Similarly, the firmware may create L0 GPT entries describing the total
> address space (think of this as Block mappings in the page tables). But
> if we change the "PAS" of a granule in the block mapping, we may need
> to create L1 tables to track the PAS at the finer granularity. For now
> we only support a system where the L1 GPTs are created at boot time
> and dynamic GPT support will be added later.

Thanks for the wording - that does indeed make things clearer. SRO
support will effectively enable the "future" items.

>> the necessary tracking state and GPTs within the RMM so that all boot
>> memory can be delegated to the RMM as needed during runtime.
>>
>> Note: support is currently missing for SROs which means that if the RMM
>> needs memory donating this will fail (and render CCA unusable in Linux).
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> New patch for v13
>> ---
>>   arch/arm64/kvm/rmi.c | 89 ++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 89 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index 9590dff9a2c1..80aedc85e94a 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -4,6 +4,7 @@
>>    */
>>     #include <linux/kvm_host.h>
>> +#include <linux/memblock.h>
>>     #include <asm/kvm_pgtable.h>
>>   #include <asm/rmi_cmds.h>
>> @@ -56,6 +57,18 @@ static int rmi_check_version(void)
>>       return 0;
>>   }
>>   +/*
>> + * These are the 'default' sizes when passing 0 as the
>> tracking_region_size.
>> + * TODO: Support other granule sizes
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
> Probably this should be made a Kconfig option, like the VA_BITS we have
> today for each page size.

Yes that's probably a good option - note that for 4k page size there is
only the one option in the spec. So this is only relevant for 16K/64K.

Thanks for the other comment suggestions below (and in the other email)
- all good points.

Thanks,
Steve

>>   static int rmi_configure(void)
>>   {
>>       struct rmm_config *config __free(free_page) = NULL;
>> @@ -95,6 +108,80 @@ static int rmi_configure(void)
>>       return 0;
>>   }
>>   +static int rmi_verify_memory_tracking(phys_addr_t start,
>> phys_addr_t end)
> 
> Could we add a comment what we are trying to do here ?
> 
> /*
>  * Make sure the area is tracked by RMM at FINE granularity.
>  * We do not support changing the TRACKING yet. This will
>  * be added in the future.
>  */
> 
> 
>> +{
>> +    start = ALIGN_DOWN(start, RMM_GRANULE_TRACKING_SIZE);
>> +    end = ALIGN(end, RMM_GRANULE_TRACKING_SIZE);
>> +
>> +    while (start < end) {
>> +        unsigned long ret, category, state;
>> +
>> +        ret = rmi_granule_tracking_get(start, &category, &state);
>> +        if (ret != RMI_SUCCESS ||
>> +            state != RMI_TRACKING_FINE ||
>> +            category != RMI_MEM_CATEGORY_CONVENTIONAL) {
>> +            /* TODO: Set granule tracking in this case */
>> +            kvm_err("Granule tracking for region isn't fine/
>> conventional: %llx",
>> +                start);
>> +            return -ENODEV;
>> +        }
>> +        start += RMM_GRANULE_TRACKING_SIZE;
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
>> +static int rmi_create_gpts(phys_addr_t start, phys_addr_t end)
>> +{
>> +    unsigned long l0gpt_sz = rmi_l0gpt_size();
>> +
>> +    start = ALIGN_DOWN(start, l0gpt_sz);
>> +    end = ALIGN(end, l0gpt_sz);
>> +
>> +    while (start < end) {
>> +        int ret = rmi_gpt_l1_create(start);
> 
> How about adding a comment here explaining why we look for RMI_ERROR_GPT ?
> 
> 
>>
>         /*
>          * Make sure the L1 GPT tables are created for the region.
>          * RMI_ERROR_GPT indicates the L1 table exists.
>          */
>  +
>> +        if (ret && ret != RMI_ERROR_GPT) {
> 
> 
>> +            /*
>> +             * FIXME: Handle SRO so that memory can be donated for
>> +             * the tables.
>> +             */
>> +            kvm_err("GPT Level1 table missing for %llx\n", start);
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
>>   static int rmm_check_features(void)
>>   {
>>       if (kvm_lpa2_is_enabled() && !
>> rmi_has_feature(RMI_FEATURE_REGISTER_0_LPA2)) {
>> @@ -120,6 +207,8 @@ void kvm_init_rmi(void)
>>           return;
>>       if (rmi_configure())
>>           return;
>> +    if (rmi_init_metadata())
>> +        return;
>>         /* Future patch will enable static branch kvm_rmi_is_available */
>>   }
> 

