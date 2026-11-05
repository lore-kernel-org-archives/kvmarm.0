Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793897403;
	b=rRs8Kjvz6AiTl+8c5JJI9HyP4yev/1ziV6TDTJPmP1pxZd8Ijw9czQ4ooB02MHPYwBmC
	 t3pRHVs/a5gmKGtZu/jFDm3TO5tCdDy2OFEFZ1/gxiMA2hwv+zXdta90LxV6xlTwPUyPH
	 9FZQgypSeBQ5Ect4FZNIIOIoT57hoK59pzt8z/evYUFUIBuEYDqe6OLSu5uvNUuE4DO0u
	 OeQKi39lsNEW9CllibWsRNEZO6kDxlvczl5bzu08EPsQs9scWaDRCkk0bEy/4rBW1lhrp
	 m1yCx9uTl4d0+FZxLMT8dybgGGq7SwsTsz4wKecMQ0BvB8iRNfGazbOQ3uT2UiYkF6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793897403;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=bnhkiMQgKoBcevjL3lDyt/7tu4k+aU/usctlsx52gYc=;
	b=KBIUwbhrYtQMlB3Iz4AeWEFKrRJQK16S/PAw0tsXfTbcPjPsFqfB2ipxKYnWIHO+tPsf
	 as1rfAe/LaNMrCMuwLAYSToBD1tk+Mc0RIdVi3Zzkh1aK4zZ5crrXiGE8FU0QbAudW4Pu
	 60If5iEDGN4PNnxVUh/Q5CN/CFdH6Onaac/djM1cS5jEGNIA49iMQN5P0AmoVquJA8J8M
	 kTYojW8rwVYDEUHe5KpuKg/IbY3C+dtwHEe6usGpZt7VpL8N2pd2fQL6Ktou+FSGmVBYv
	 515fYP1Z2wtmO1YOVd4C3zCYlya8U5fUdxuDhd/xUc5UglvUSZ47o8pta5HBKoicDnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=WbSTd5yT;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4C8B606A32C;
	Thu,  5 Nov 2026 16:50:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4C8B606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=WbSTd5yT
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B5C8C1682;
	Thu,  5 Nov 2026 08:49:57 -0800 (PST)
Received: from [10.0.128.250] (e122027.cambridge.arm.com [10.0.128.250])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1E7AB3F632;
	Thu,  5 Nov 2026 08:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793897400; bh=B7sdCE0FL01Nwo4nHRQePFyUNDfvN2vdiE6ATBsLM9o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WbSTd5yTxR9Dy7rvQIrfkn2me2Z3rdvbUgvkwJGBnQg26rUQL6+U5r1u1Bs1CIH9O
	 8Gu9wGlwVbrTmnPFEttM2th5Ng84iPx/ruUscbYLdVvmeJfZF6a/C77fSZtUZ0FJG9
	 UEMv3FmuL8Cw+6+4YjjHJiwue0pX8FOU7S+NneeY=
Message-ID: <0d8b56d9-2eb2-41b3-adc5-6457f1eafe0e@arm.com>
Date: Thu, 5 Nov 2026 16:49:47 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/11] KVM: arm64: CCA: Add Realm RTT mapping and
 invalidation helpers
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
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-9-steven.price@arm.com>
 <1c2f2596-4b55-4fa1-a215-8c1099d4c1a2@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <1c2f2596-4b55-4fa1-a215-8c1099d4c1a2@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 04/11/2026 18:59, Suzuki K Poulose wrote:
> Hi Steven
> 
> On 02/11/2026 14:12, Steven Price wrote:
>> Add the RMI RTT creation and unmap helpers needed by CCA Realm stage-2
>> memory operations. REC exit handling and guest requested RIPAS changes
>> follow in the vCPU series.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/include/asm/kvm_rmi.h |  14 ++
>>   arch/arm64/kvm/rmi.c             | 346 +++++++++++++++++++++++++++++++
>>   2 files changed, 360 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/
>> asm/kvm_rmi.h
>> index 58d825e40bdf..72a9449f00d7 100644
>> --- a/arch/arm64/include/asm/kvm_rmi.h
>> +++ b/arch/arm64/include/asm/kvm_rmi.h
>> @@ -81,6 +81,20 @@ int kvm_init_realm(struct kvm *kvm);
>>   void kvm_destroy_realm(struct kvm *kvm);
>>   int kvm_realm_teardown_stage2(struct kvm *kvm);
>>   +enum kvm_gfn_range_filter;
>> +
>> +void kvm_realm_unmap_range_filter(struct kvm *kvm,
>> +                  unsigned long ipa,
>> +                  unsigned long size,
>> +                  bool may_block,
>> +                  enum kvm_gfn_range_filter attr_filter);
>> +
>> +void kvm_realm_unmap_range(struct kvm *kvm,
>> +               unsigned long ipa,
>> +               unsigned long size,
>> +               bool unmap_private,
>> +               bool may_block);
> 
> This can be removed now in favor of the one above ?

Indeed it seems all usage of it has gone - thanks for spotting.

>> +
>>   static inline bool kvm_realm_is_private_address(struct realm *realm,
>>                           unsigned long addr)
>>   {
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index f190143b33ba..1066f767f85d 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -34,6 +34,83 @@ static int get_start_level(struct realm *realm)
>>       return 4 - stage2_pgtable_levels(realm->ia_bits);
>>   }
>>   +static int find_map_level(struct realm *realm,
>> +              unsigned long start,
>> +              unsigned long end)
>> +{
>> +    int level = KVM_PGTABLE_LAST_LEVEL;
>> +
>> +    while (level > get_start_level(realm)) {
>> +        unsigned long map_size = rmi_rtt_level_mapsize(level - 1);
>> +
>> +        if (!IS_ALIGNED(start, map_size) ||
>> +            (start + map_size) > end)
>> +            break;
>> +
>> +        level--;
>> +    }
>> +
>> +    return level;
>> +}
>> +
>> +static unsigned long rmi_range_entry_size(int rmi_size)
> 
> I am wondering if we should move rmi_addr_block_size_to_bytes() from
> drivers/firmware/arm_rmm/rmi.c to include/linux/arm-rmi-cmds.h and
> allow the consumers to deal with the address range entries.

Yep, seem reasonable.

>> +{
>> +    if (WARN_ON(rmi_size > KVM_PGTABLE_LAST_LEVEL))
>> +        return 0;
>> +
>> +    return kvm_granule_size(KVM_PGTABLE_LAST_LEVEL - rmi_size);
>> +}
>> +
>> +static int undelegate_range_desc(unsigned long desc)
>> +{
>> +    unsigned long size =
>> rmi_range_entry_size(RMI_ADDR_RANGE_BLOCK_SIZE(desc));
>> +    unsigned long count = RMI_ADDR_RANGE_COUNT(desc);
>> +    unsigned long addr = RMI_ADDR_RANGE_ADDR(desc);
>> +    unsigned long state = RMI_ADDR_RANGE_STATE(desc);
>> +
>> +    if (state == RMI_OP_MEM_UNDELEGATED)
>> +        return 0;
>> +
>> +    if (size * count == 0)
>> +        return 0;
>> +
>> +    return rmi_undelegate_range(addr, size * count);
>> +}
>> +
>> +static phys_addr_t alloc_delegated_granule(struct
>> kvm_mmu_memory_cache *mc)
>> +{
>> +    phys_addr_t phys;
>> +    void *virt;
>> +
>> +    if (mc) {
>> +        virt = kvm_mmu_memory_cache_alloc(mc);
>> +    } else {
>> +        virt = (void *)__get_free_page(GFP_ATOMIC | __GFP_ZERO |
>> +                           __GFP_ACCOUNT);
>> +    }
>> +
>> +    if (!virt)
>> +        return PHYS_ADDR_MAX;
>> +
>> +    phys = virt_to_phys(virt);
>> +    if (rmi_delegate_page(phys)) {
>> +        free_page((unsigned long)virt);
>> +        return PHYS_ADDR_MAX;
>> +    }
>> +
>> +    return phys;
>> +}
>> +
>> +static phys_addr_t alloc_rtt(struct kvm_mmu_memory_cache *mc)
>> +{
>> +    phys_addr_t phys = alloc_delegated_granule(mc);
>> +
>> +    if (phys != PHYS_ADDR_MAX)
>> +        kvm_account_pgtable_pages(phys_to_virt(phys), 1);
>> +
>> +    return phys;
>> +}
>> +
>>   static void free_rtt(phys_addr_t phys)
>>   {
>>       if (rmi_free_delegated_page(phys))
>> @@ -42,6 +119,32 @@ static void free_rtt(phys_addr_t phys)
>>       kvm_account_pgtable_pages(phys_to_virt(phys), -1);
>>   }
>>   +static long realm_rtt_create(struct realm *realm,
>> +                 unsigned long addr,
>> +                 int level,
>> +                 phys_addr_t phys)
>> +{
>> +    addr = ALIGN_DOWN(addr, rmi_rtt_level_mapsize(level - 1));
> 
> As pointed out in the other patch, this could now be replaced with
> kvm_granule_size().

Ack.

> 
>> +    return rmi_rtt_create(virt_to_phys(realm->rd), phys, addr, level);
> 
> Does it make sense to save "rd_phys" as we tend to use the physical
> address more than the virt and we end up converting it all the time ?

Yes that's an improvement.

>> +}
>> +
>> +static long realm_rtt_fold(struct realm *realm,
>> +               unsigned long addr,
>> +               int level,
>> +               phys_addr_t *rtt_granule)
>> +{
>> +    unsigned long out_rtt;
>> +    long ret;
>> +
>> +    addr = ALIGN_DOWN(addr, rmi_rtt_level_mapsize(level - 1));
>> +    ret = rmi_rtt_fold(virt_to_phys(realm->rd), addr, level, &out_rtt);
>> +
>> +    if (rtt_granule)
>> +        *rtt_granule = out_rtt;
>> +
>> +    return ret;
>> +}
>> +
>>   /*
>>    * realm_rtt_destroy - Destroy an RTT at @level for @addr.
>>    *
>> @@ -65,6 +168,43 @@ static long realm_rtt_destroy(struct realm *realm,
>> unsigned long addr,
>>       return ret;
>>   }
>>   +static int realm_create_rtt_levels(struct realm *realm,
>> +                   unsigned long ipa,
>> +                   int level,
>> +                   int max_level,
>> +                   struct kvm_mmu_memory_cache *mc)
>> +{
>> +    while (level++ < max_level) {
>> +        phys_addr_t rtt = alloc_rtt(mc);
>> +        long ret;
>> +
>> +        if (rtt == PHYS_ADDR_MAX)
>> +            return -ENOMEM;
>> +
>> +        ret = realm_rtt_create(realm, ipa, level, rtt);
>> +        if (ret < 0) {
>> +            free_rtt(rtt);
>> +            return ret;
>> +        }
>> +
>> +        if (RMI_RESULT_STATUS(ret) == RMI_ERROR_RTT &&
>> +            RMI_RESULT_DATA_LEVEL(ret) == level - 1) {
>> +            /* The RTT already exists, continue */
>> +            free_rtt(rtt);
> 
> nit: We seem to be releasing the rtt (undelegating it and
> freeing a page) only to be reallocated later (and re-delegated). We
> could optimise this a little bit and may be reuse it for the next
> iteration ?
> (I understand this is rather a corner case)

Sure.

>> +            continue;
>> +        }
>> +
>> +        if (ret) {
>> +            WARN(1, "Failed to create RTT at level %d: %ld\n",
>> +                 level, ret);
>> +            free_rtt(rtt);
>> +            return -ENXIO;
>> +        }
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>>   static int realm_tear_down_rtt_level(struct realm *realm, int level,
>>                        unsigned long start, unsigned long end)
>>   {
>> @@ -161,6 +301,64 @@ static int realm_tear_down_rtt_range(struct realm
>> *realm,
>>                        start, end);
>>   }
>>   +/*
>> + * Returns 0 on successful fold, a negative value on error, a
>> positive value if
>> + * we were not able to fold all tables at this level.
>> + */
>> +static int realm_fold_rtt_level(struct realm *realm, int level,
>> +                unsigned long start, unsigned long end)
>> +{
>> +    int not_folded = 0;
>> +    ssize_t map_size;
>> +    unsigned long addr, next_addr;
>> +
>> +    if (WARN_ON(level > KVM_PGTABLE_LAST_LEVEL))
>> +        return -EINVAL;
>> +
>> +    map_size = rmi_rtt_level_mapsize(level - 1);
>> +
>> +    for (addr = start; addr < end; addr = next_addr) {
>> +        phys_addr_t rtt_granule;
>> +        long ret;
>> +        unsigned long align_addr = ALIGN(addr, map_size);
>> +
>> +        next_addr = ALIGN(addr + 1, map_size);
>> +
>> +        ret = realm_rtt_fold(realm, align_addr, level, &rtt_granule);
>> +        if (ret < 0)
>> +            return ret;
>> +
>> +        switch (RMI_RESULT_STATUS(ret)) {
>> +        case RMI_SUCCESS:
>> +            free_rtt(rtt_granule);
>> +            break;
>> +        case RMI_ERROR_RTT:
>> +            if (level == KVM_PGTABLE_LAST_LEVEL ||
> 
> 
>> +                RMI_RESULT_DATA_LEVEL(ret) < level) {
> 
> Should this be RMI_RESULT_DATA_LEVEL(ret) == level ?
> 
> Additionally if the walk terminated at a shallow level, i.e.,
> RMI_RESULT_DATA_LEVEL(ret) < level), then we don't have to conclude
> that the table was NOT folded. In effect, the table is actually folded
> at level above.
> 
> Also, we could move the next_addr in this case skip to the addr
> past to ALIGN(addr + 1, kvm_granule_size(RMI_RESULT_DATA_LEVEL(ret) - 1))

Yep, good point.

> 
>> +                not_folded++;
>> +                break;
>> +            }
>> +            /* Recurse a level deeper */
>> +            ret = realm_fold_rtt_level(realm,
>> +                           level + 1,
>> +                           addr,
>> +                           next_addr);
>> +            if (ret < 0) {
>> +                return ret;
>> +            } else if (ret == 0) {
>> +                /* Try again at this level */
>> +                next_addr = addr;
>> +            }
>> +            break;
>> +        default:
>> +            WARN_ON(1);
>> +            return -ENXIO;
>> +        }
>> +    }
>> +
>> +    return not_folded;
>> +}
>> +
>>   static int realm_destroy_rtts(struct kvm *kvm)
>>   {
>>       struct realm *realm = &kvm->arch.realm;
>> @@ -196,6 +394,154 @@ int kvm_realm_teardown_stage2(struct kvm *kvm)
>>       return 0;
>>   }
>>   +static void realm_unmap_shared_range(struct kvm *kvm,
>> +                     unsigned long start,
>> +                     unsigned long end,
>> +                     bool may_block)
>> +{
>> +    struct realm *realm = &kvm->arch.realm;
>> +    unsigned long rd = virt_to_phys(realm->rd);
>> +    unsigned long next_addr, addr;
>> +    unsigned long shared_bit = BIT(realm->ia_bits - 1);
>> +
>> +    if (start >= end)
>> +        return;
>> +
>> +    /*
>> +     * Callers may pass either an IPA range or its shared alias. Add the
>> +     * shared bit only for the former. Use addition so an exclusive
>> end at
>> +     * shared_bit advances to the end of the IPA space.
>> +     */
>> +    if (start < shared_bit) {
>> +        start += shared_bit;
>> +        end += shared_bit;
>> +    }
>> +
>> +    for (addr = start; addr < end; addr = next_addr) {
>> +        long ret;
>> +
>> +        ret = rmi_rtt_unprot_unmap(rd, addr, end, RMI_ADDR_TYPE_NONE,
>> +                       0, &next_addr, NULL, NULL);
>> +        if (WARN_ON(ret < 0))
>> +            return;
>> +
>> +        switch (RMI_RESULT_STATUS(ret)) {
>> +        case RMI_SUCCESS:
>> +            break;
>> +        case RMI_ERROR_RTT: {
>> +            int err_level = RMI_RESULT_DATA_LEVEL(ret);
>> +            int level = find_map_level(realm, addr, end);
>> +
>> +            if (err_level >= level) {
>> +                /* Nothing present, so skip */
>> +                next_addr = addr + rmi_rtt_level_mapsize(err_level);
>> +                break;
>> +            }
>> +
>> +            ret = realm_create_rtt_levels(realm, addr, err_level,
>> +                              level, NULL);
>> +            if (WARN_ON(ret))
>> +                return;
>> +            /* Retry with the RTT levels in place */
>> +            next_addr = addr;
>> +            break;
>> +        }
>> +        default:
>> +            WARN_ON(1);
>> +            return;
>> +        }
>> +
>> +        if (may_block)
>> +            cond_resched_rwlock_write(&kvm->mmu_lock);
>> +    }
>> +
>> +    realm_fold_rtt_level(realm, get_start_level(realm) + 1,
>> +                 start, end);
>> +}
>> +
>> +static void realm_unmap_private_range(struct kvm *kvm,
>> +                      unsigned long start,
>> +                      unsigned long end,
>> +                      bool may_block)
>> +{
>> +    struct realm *realm = &kvm->arch.realm;
>> +    unsigned long rd = virt_to_phys(realm->rd);
>> +    unsigned long next_addr, addr;
>> +    long ret;
>> +
>> +    for (addr = start; addr < end; addr = next_addr) {
>> +        unsigned long out_range;
>> +        unsigned long flags = RMI_ADDR_TYPE_SINGLE;
>> +        /* TODO: Optimise using RMI_ADDR_TYPE_LIST */
>> +
>> +retry:
>> +        ret = rmi_rtt_data_unmap(rd, addr, end, flags, 0,
>> +                     &next_addr, &out_range, NULL);
>> +        if (WARN_ON(ret < 0))
>> +            return;
>> +
>> +        if (RMI_RESULT_STATUS(ret) == RMI_ERROR_RTT) {
>> +            phys_addr_t rtt;
>> +
> 
> 
>> +            if (next_addr > addr)
>> +                continue; /* UNASSIGNED */
> 
> This is no longer valid. out_top (next_addr in our case) is only valid
> when ret == RMI_SUCCESS. Please drop. See VTKMV.

Sashiko pointed that out too.

>> +
>> +            rtt = alloc_rtt(NULL);
>> +            if (WARN_ON(rtt == PHYS_ADDR_MAX))
>> +                return;
>> +            ret = realm_rtt_create(realm, addr,
>> +                           RMI_RESULT_DATA_LEVEL(ret) + 1, rtt);
>> +            if (WARN_ON(ret)) {
>> +                free_rtt(rtt);
>> +                return;
>> +            }
>> +            goto retry;
>> +        } else if (WARN_ON(ret)) {
>> +            continue;
>> +        }
>> +
>> +        ret = undelegate_range_desc(out_range);
>> +        if (WARN_ON(ret))
>> +            break;
>> +
>> +        if (may_block)
>> +            cond_resched_rwlock_write(&kvm->mmu_lock);
>> +    }
>> +
>> +    realm_fold_rtt_level(realm, get_start_level(realm) + 1,
>> +                 start, end);
>> +}
>> +
>> +void kvm_realm_unmap_range_filter(struct kvm *kvm, unsigned long start,
>> +                  unsigned long size, bool may_block,
>> +                  enum kvm_gfn_range_filter attr_filter)
>> +{
>> +    unsigned long end = start + size;
>> +    struct realm *realm = &kvm->arch.realm;
>> +
>> +    if (!kvm_realm_is_created(kvm))
>> +        return;
>> +
>> +    end = min(BIT(realm->ia_bits - 1), end);
>> +
>> +    if (attr_filter & KVM_FILTER_SHARED)
>> +        realm_unmap_shared_range(kvm, start, end, may_block);
>> +    if (attr_filter & KVM_FILTER_PRIVATE)
>> +        realm_unmap_private_range(kvm, start, end, may_block);
>> +}
>> +
> 
> ---8>---
>> +void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start,
>> +               unsigned long size, bool unmap_private,
>> +               bool may_block)
>> +{
>> +    enum kvm_gfn_range_filter attr_filter = KVM_FILTER_SHARED;
>> +
>> +    if (unmap_private)
>> +        attr_filter |= KVM_FILTER_PRIVATE;
>> +
>> +    kvm_realm_unmap_range_filter(kvm, start, size, may_block,
>> attr_filter);
>> +}
>> +
> 
> ---8<---
> 
> No longer needed ?

Indeed - I'll drop this.

Thanks,
Steve

>>   void kvm_destroy_realm(struct kvm *kvm)
>>   {
>>       struct realm *realm = &kvm->arch.realm;
> 
> Suzuki

