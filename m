Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D2E2199931;
	Thu, 21 May 2026 15:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779377976; cv=none; b=j4d49ypQWswvNhfYhPQ30+wsdYcrqixhgvmDC4jY/H6yZ5/dQi0sRo02BLTSTDMOcappQlgQDBiY2S9Ame1HaLn8eMAmGkyfDNKV4oCbHTOu4legTuyRtw+nIPpF64sHiHBmLgGW0RYYH4W4nMrgVca511RV6Hf5Nt75ikIs+kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779377976; c=relaxed/simple;
	bh=9abohqYEGSI8G6o+btmzuRKboT24aErRDhVclbzNqn0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h3taeLqKrSk9hGnR3t3TJsN/pJGZfEQD1/d1huDz1t9EXj+I9O7D4qT8TLFPUIFxyGRzPMsmNd33/7KrfHdUofvikAJwCvJbhyEmpliE7mgIvjZvqFLiu/60wGxPWaGMDOk3XkEa3bg1+CT5C35rc+bumW2P1Wp+D5KnB/5CUcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TQjwiLUh; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TQjwiLUh"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B83943C7;
	Thu, 21 May 2026 08:39:28 -0700 (PDT)
Received: from [10.57.22.108] (unknown [10.57.22.108])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6439A3F7B4;
	Thu, 21 May 2026 08:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779377973; bh=9abohqYEGSI8G6o+btmzuRKboT24aErRDhVclbzNqn0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TQjwiLUhxZDb0S4oJEgT5ZUX35/4s+5PsiK6uIhkPLx8ATiDlx3dV3faDh4BjQamP
	 GmUIM0WJ5xJiLBuXiTJnQg2EklRadrAF+msOk92oXTDxUJtdjvFFEc/xHeHrQUQwhS
	 QvLywu0mT8JbUf5hUaRFNmH0PNqty1BMWJkKN6cs=
Message-ID: <e175cb7b-b4fa-4139-b46d-1986e2372d16@arm.com>
Date: Thu, 21 May 2026 16:39:27 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 08/44] arm64: RMI: Ensure that the RMM has GPT entries
 for memory
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-9-steven.price@arm.com> <868q9cx4ac.wl-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <868q9cx4ac.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21/05/2026 14:47, Marc Zyngier wrote:
> On Wed, 13 May 2026 14:17:16 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
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
>>   * Moved out of KVM
>> ---
>>   arch/arm64/include/asm/rmi_cmds.h |   2 +
>>   arch/arm64/kernel/rmi.c           | 103 ++++++++++++++++++++++++++++++
>>   2 files changed, 105 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
>> index 9179934925c5..9078a2920a7c 100644
>> --- a/arch/arm64/include/asm/rmi_cmds.h
>> +++ b/arch/arm64/include/asm/rmi_cmds.h
>> @@ -33,6 +33,8 @@ struct rmi_sro_state {
>>   } while (RMI_RETURN_STATUS(res.a0) == RMI_BUSY ||			\
>>   	 RMI_RETURN_STATUS(res.a0) == RMI_BLOCKED)
>>   
>> +bool rmi_is_available(void);
>> +
>>   unsigned long rmi_sro_execute(struct rmi_sro_state *sro, gfp_t gfp);
>>   void rmi_sro_free(struct rmi_sro_state *sro);
>>   
>> diff --git a/arch/arm64/kernel/rmi.c b/arch/arm64/kernel/rmi.c
>> index a14ead5dedda..52a415e99500 100644
>> --- a/arch/arm64/kernel/rmi.c
>> +++ b/arch/arm64/kernel/rmi.c
>> @@ -7,6 +7,8 @@
>>   
>>   #include <asm/rmi_cmds.h>
>>   
>> +static bool arm64_rmi_is_available;
>> +
>>   unsigned long rmm_feat_reg0;
>>   unsigned long rmm_feat_reg1;
>>   
>> @@ -88,6 +90,102 @@ static int rmi_configure(void)
>>   	return 0;
>>   }
>>   
>> +/*
>> + * For now we set the tracking_region_size to 0 for RMI_RMM_CONFIG_SET().
>> + * TODO: Support other tracking sizes (via Kconfig option).
>> + */
>> +#ifdef CONFIG_PAGE_SIZE_4KB
>> +#define RMM_GRANULE_TRACKING_SIZE	SZ_1G
>> +#elif defined(CONFIG_PAGE_SIZE_16KB)
>> +#define RMM_GRANULE_TRACKING_SIZE	SZ_32M
>> +#elif defined(CONFIG_PAGE_SIZE_64KB)
>> +#define RMM_GRANULE_TRACKING_SIZE	SZ_512M
>> +#endif
> 
> Basically, a level 2 mapping. Which means this whole block really is:
> 
> #define RMM_GRANULE_TRAKING_SIZE	(2 * PAGE_SHIFT - 3)
> 
> (adjust for D128 as needed).

True,

> 
>> +
>> +/*
>> + * Make sure the area is tracked by RMM at FINE granularity.
>> + * We do not support changing the tracking yet.
>> + */
>> +static int rmi_verify_memory_tracking(phys_addr_t start, phys_addr_t end)
>> +{
>> +	while (start < end) {
>> +		unsigned long ret, category, state, next;
>> +
>> +		ret = rmi_granule_tracking_get(start, end, &category, &state, &next);
>> +		if (ret != RMI_SUCCESS ||
>> +		    state != RMI_TRACKING_FINE ||
>> +		    category != RMI_MEM_CATEGORY_CONVENTIONAL) {
>> +			/* TODO: Set granule tracking in this case */
>> +			pr_err("Granule tracking for region isn't fine/conventional: %llx",
>> +			       start);
>> +			return -ENODEV;
> 
> How is this triggered? Do we really need to spam the console with
> this? A PA doesn't mean much, and there is no context (stack trace).

This could be triggered if the RMM doesn't have static carveout
for tracking the DRAM granules. (state != RMI_TRACKING_FINE).
This not worth WARN_ONCE(), we could simply not enable KVM.
We plan to add support for donating memory to the RMM in
the future. (Primarily we don't yet have an RMM implementation
that does dynamic management via SRO. This can be added later
as a separate series)

> 
> If that's not expected, turn this into a WARN_ONCE().




> 
>> +		}
>> +		start = next;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static unsigned long rmi_l0gpt_size(void)
>> +{
>> +	return 1UL << (30 + FIELD_GET(RMI_FEATURE_REGISTER_1_L0GPTSZ,
>> +				      rmm_feat_reg1));
>> +}
>> +
>> +static int rmi_create_gpts(phys_addr_t start, phys_addr_t end)
>> +{
>> +	unsigned long l0gpt_sz = rmi_l0gpt_size();
>> +
>> +	start = ALIGN_DOWN(start, l0gpt_sz);
>> +	end = ALIGN(end, l0gpt_sz);
>> +
>> +	while (start < end) {
>> +		int ret = rmi_gpt_l1_create(start);
>> +
>> +		/*
>> +		 * Make sure the L1 GPT tables are created for the region.
>> +		 * RMI_ERROR_GPT indicates the L1 table already exists.
>> +		 */
>> +		if (ret && ret != RMI_ERROR_GPT) {
>> +			/*
>> +			 * FIXME: Handle SRO so that memory can be donated for
>> +			 * the tables.
>> +			 */
>> +			pr_err("GPT Level1 table missing for %llx\n", start);
>> +			return -ENOMEM;
> 
> If any of this fails, where is the cleanup done? Is that part of the
> missing SRO support that's indicated in the commit message?
> 

For now, there is no cleanup required. What we essentially do here is
making sure that the GPT tables have been created upto L1 (i.e.,
by checking ret == RMI_ERROR_GPT).

We do not donate any memory now, but only support RMMs with static 
memory carved out for L1 GPT. Support for dynamic RMMs could be added as
a separate series, at which point, we could defer the table creation to
the actual use case (e.g, RMI_GRANULE_DELEGATE).

Clean up would be required when we donate memory to the RMM.

>> +		}
>> +		start += l0gpt_sz;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int rmi_init_metadata(void)
>> +{
>> +	phys_addr_t start, end;
>> +	const struct memblock_region *r;
>> +
>> +	for_each_mem_region(r) {
>> +		int ret;
>> +
>> +		start = memblock_region_memory_base_pfn(r) << PAGE_SHIFT;
>> +		end = memblock_region_memory_end_pfn(r) << PAGE_SHIFT;
>> +		ret = rmi_verify_memory_tracking(start, end);
>> +		if (ret)
>> +			return ret;
>> +		ret = rmi_create_gpts(start, end);
>> +		if (ret)
>> +			return ret;
>> +	}
> 
> How does this work with, say, memory hotplug?

Good point, we need a hook for hotpug to make sure this is taken care
of. As mentioned above, when we add support for RMM with support for
dynamic Tracking/GPT with SRO, this could be deferred to the actual
use (handling RMI return codes, RMI_ERROR_TRACKING/RMI_ERROR_GPT)

Suzuki


> 
>> +
>> +	return 0;
>> +}
>> +
>> +bool rmi_is_available(void)
>> +{
>> +	return arm64_rmi_is_available;
>> +}
>> +
>>   static int __init arm64_init_rmi(void)
>>   {
>>   	/* Continue without realm support if we can't agree on a version */
>> @@ -101,6 +199,11 @@ static int __init arm64_init_rmi(void)
>>   
>>   	if (rmi_configure())
>>   		return 0;
>> +	if (rmi_init_metadata())
>> +		return 0;
>> +
>> +	arm64_rmi_is_available = true;
>> +	pr_info("RMI configured");
>>   
>>   	return 0;
>>   }
> 
> Thanks,
> 
> 	M.
> 

