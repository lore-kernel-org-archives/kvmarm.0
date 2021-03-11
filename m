Return-Path: <SRS0=mhFy=IJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 730F3C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 14:28:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 88F6664FB3
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 14:28:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88F6664FB3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D36484B12E;
	Thu, 11 Mar 2021 09:28:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7HNP2206M0K9; Thu, 11 Mar 2021 09:28:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D9CE4B20E;
	Thu, 11 Mar 2021 09:28:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 307824B197
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 09:28:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4b-B2isM1UiC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Mar 2021 09:28:29 -0500 (EST)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 712CA4B18B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 09:28:29 -0500 (EST)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DxB8Y626Xz9rwr;
 Thu, 11 Mar 2021 22:26:37 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Thu, 11 Mar 2021 22:28:18 +0800
Subject: Re: [RFC PATCH] kvm: arm64: Try stage2 block mapping for host device
 MMIO
To: Marc Zyngier <maz@kernel.org>
References: <20210122083650.21812-1-zhukeqian1@huawei.com>
 <87y2euf5d2.wl-maz@kernel.org>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <e2a36913-2ded-71ff-d3ed-f7f8d831447c@huawei.com>
Date: Thu, 11 Mar 2021 22:28:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <87y2euf5d2.wl-maz@kernel.org>
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org,
 Alexios Zavras <alexios.zavras@intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Robin Murphy <robin.murphy@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 2021/3/11 16:43, Marc Zyngier wrote:
> Digging this patch back from my Inbox...
Yeah, thanks ;-)

> 
> On Fri, 22 Jan 2021 08:36:50 +0000,
> Keqian Zhu <zhukeqian1@huawei.com> wrote:
>>
>> The MMIO region of a device maybe huge (GB level), try to use block
>> mapping in stage2 to speedup both map and unmap.
>>
>> Especially for unmap, it performs TLBI right after each invalidation
>> of PTE. If all mapping is of PAGE_SIZE, it takes much time to handle
>> GB level range.
>>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>  arch/arm64/include/asm/kvm_pgtable.h | 11 +++++++++++
>>  arch/arm64/kvm/hyp/pgtable.c         | 15 +++++++++++++++
>>  arch/arm64/kvm/mmu.c                 | 12 ++++++++----
>>  3 files changed, 34 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
>> index 52ab38db04c7..2266ac45f10c 100644
>> --- a/arch/arm64/include/asm/kvm_pgtable.h
>> +++ b/arch/arm64/include/asm/kvm_pgtable.h
>> @@ -82,6 +82,17 @@ struct kvm_pgtable_walker {
>>  	const enum kvm_pgtable_walk_flags	flags;
>>  };
>>  
>> +/**
>> + * kvm_supported_pgsize() - Get the max supported page size of a mapping.
>> + * @pgt:	Initialised page-table structure.
>> + * @addr:	Virtual address at which to place the mapping.
>> + * @end:	End virtual address of the mapping.
>> + * @phys:	Physical address of the memory to map.
>> + *
>> + * The smallest return value is PAGE_SIZE.
>> + */
>> +u64 kvm_supported_pgsize(struct kvm_pgtable *pgt, u64 addr, u64 end, u64 phys);
>> +
>>  /**
>>   * kvm_pgtable_hyp_init() - Initialise a hypervisor stage-1 page-table.
>>   * @pgt:	Uninitialised page-table structure to initialise.
>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>> index bdf8e55ed308..ab11609b9b13 100644
>> --- a/arch/arm64/kvm/hyp/pgtable.c
>> +++ b/arch/arm64/kvm/hyp/pgtable.c
>> @@ -81,6 +81,21 @@ static bool kvm_block_mapping_supported(u64 addr, u64 end, u64 phys, u32 level)
>>  	return IS_ALIGNED(addr, granule) && IS_ALIGNED(phys, granule);
>>  }
>>  
>> +u64 kvm_supported_pgsize(struct kvm_pgtable *pgt, u64 addr, u64 end, u64 phys)
>> +{
>> +	u32 lvl;
>> +	u64 pgsize = PAGE_SIZE;
>> +
>> +	for (lvl = pgt->start_level; lvl < KVM_PGTABLE_MAX_LEVELS; lvl++) {
>> +		if (kvm_block_mapping_supported(addr, end, phys, lvl)) {
>> +			pgsize = kvm_granule_size(lvl);
>> +			break;
>> +		}
>> +	}
>> +
>> +	return pgsize;
>> +}
>> +
>>  static u32 kvm_pgtable_idx(struct kvm_pgtable_walk_data *data, u32 level)
>>  {
>>  	u64 shift = kvm_granule_shift(level);
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 7d2257cc5438..80b403fc8e64 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -499,7 +499,8 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>>  int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>>  			  phys_addr_t pa, unsigned long size, bool writable)
>>  {
>> -	phys_addr_t addr;
>> +	phys_addr_t addr, end;
>> +	unsigned long pgsize;
>>  	int ret = 0;
>>  	struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
>>  	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
>> @@ -509,21 +510,24 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>>  
>>  	size += offset_in_page(guest_ipa);
>>  	guest_ipa &= PAGE_MASK;
>> +	end = guest_ipa + size;
>>  
>> -	for (addr = guest_ipa; addr < guest_ipa + size; addr += PAGE_SIZE) {
>> +	for (addr = guest_ipa; addr < end; addr += pgsize) {
>>  		ret = kvm_mmu_topup_memory_cache(&cache,
>>  						 kvm_mmu_cache_min_pages(kvm));
>>  		if (ret)
>>  			break;
>>  
>> +		pgsize = kvm_supported_pgsize(pgt, addr, end, pa);
>> +
>>  		spin_lock(&kvm->mmu_lock);
>> -		ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot,
>> +		ret = kvm_pgtable_stage2_map(pgt, addr, pgsize, pa, prot,
>>  					     &cache);
>>  		spin_unlock(&kvm->mmu_lock);
>>  		if (ret)
>>  			break;
>>  
>> -		pa += PAGE_SIZE;
>> +		pa += pgsize;
>>  	}
>>  
>>  	kvm_mmu_free_memory_cache(&cache);
> 
> There is one issue with this patch, which is that it only does half
> the job. A VM_PFNMAP VMA can definitely be faulted in dynamically, and
> in that case we force this to be a page mapping. This conflicts with
> what you are doing here.
Oh yes, these two paths should keep a same mapping logic.

I try to search the "force_pte" and find out some discussion [1] between you and Christoffer.
And I failed to get a reason about forcing pte mapping for device MMIO region (expect that
we want to keep a same logic with the eager mapping path). So if you don't object to it, I
will try to implement block mapping for device MMIO in user_mem_abort().

> 
> There is also the fact that if we can map things on demand, why are we
> still mapping these MMIO regions ahead of time?
Indeed. Though this provides good *startup* performance for guest accessing MMIO, it's hard
to keep the two paths in sync. We can keep this minor optimization or delete it to avoid hard
maintenance, which one do you prefer?

BTW, could you please have a look at my another patch series[2] about HW/SW combined dirty log? ;)

Thanks,
Keqian

[1] https://patchwork.kernel.org/project/linux-arm-kernel/patch/20191211165651.7889-2-maz@kernel.org/
[2] https://lore.kernel.org/linux-arm-kernel/20210126124444.27136-1-zhukeqian1@huawei.com/


> 
> Thanks,
> 
> 	M.
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
