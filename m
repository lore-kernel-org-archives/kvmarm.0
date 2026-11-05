Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793895759;
	b=yDa1lMFTdnuzFgX45xL1JBY4yZ81cSGi/ydsszfJoh01GFgUWnS4HyiH0K2rW/y6nTuX
	 GBq5HmWtexS17X3hpRQGcjcYiflpLRGSTOPzu281HOvViuRk+W4j4u0D3QDyjqUaU4bH3
	 Q1VtEL24CWz1MFzZ5xcwy39jx3hAIUto8QNtisgDMqXk+1yg8gbOHxqsddMnl2Uqm/Lyh
	 QrPEq70dWpcS588G7TUQ/PBU3iJ/dyORTHlf2tL8wIxd/9Jy95Kx/7iRmToQOq2z5WCNm
	 MH889tri9H9whGT3ZUuW8OQnsf6PhZ+G5J7HKYk3p47Y4HKehATrQ8Yp2BVKarD2siQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793895759;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=R6jYA7iBmBCj7SYoKaWXCO75SHiQlvdvK/ogEwlQqHI=;
	b=dAefG3c3nxZq4gbHGdSNDNwSe4am0pbIypjPCLAweRfEQgI1OZtSNy1HgjJewbTTs4tM
	 cKETliBgmKN9JWZkO2oiQc1ZEq5bRhJExfAhmACfmbbH05jXYiQpvrqsAaJbkIpSLUrMM
	 ecFyh4hr1aXG1ifn5TV2nczBZREs+C/ql8RBY83u6TCS17M1F6PK5mrGYES1H4zOm3W7i
	 f5iXVO2jJtjqv9ZOXbSlg+tyacb9HI/SSNUGBmTGUpC2V3ckSIAVHyc0U6rHwFFo3nqTL
	 o+v1+34zdqc6Yh+2mc2QCF3SziCVeCf9TwSvo2NW1nx1nD1H6c/a/ENOo6EzY8ZRbzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=vhbOLJDF;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B6B5606A31B;
	Thu,  5 Nov 2026 16:22:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B6B5606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=vhbOLJDF
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5F77415A1;
	Thu,  5 Nov 2026 08:22:33 -0800 (PST)
Received: from [10.0.128.250] (e122027.cambridge.arm.com [10.0.128.250])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E43423F632;
	Thu,  5 Nov 2026 08:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793895756; bh=vQSn9+Hzn9c5l4NQm7nVjwUaNvp3syznAMxQZ0y//yw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vhbOLJDF95Mhm84Hg5rSIEbRnHVOke4JfUAPiW2nUX8/lmdK3UNXIzxu8et+RlTRh
	 /QiCA+vLMmh0hi2yhIc7IZp9EJjpqDnNFvmO8szzD4koWqcRXmXt6mPJqJ9L8D2c3z
	 ExJntsCJSxEBFIgwStBagtvFksgKVuipZPPq4Q6w=
Message-ID: <cb183290-3fee-4535-aa3e-5cc172c2323a@arm.com>
Date: Thu, 5 Nov 2026 16:22:29 +0000
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
Subject: Re: [PATCH 07/11] KVM: arm64: CCA: Tear down RTTs
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
 <20261102141304.126883-8-steven.price@arm.com>
 <472e29a3-ab29-46b3-a70f-caab49befbb5@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <472e29a3-ab29-46b3-a70f-caab49befbb5@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 03/11/2026 15:20, Suzuki K Poulose wrote:
> On 02/11/2026 14:12, Steven Price wrote:
>> The RMM owns the stage 2 page tables for a realm, and KVM must request
>> that the RMM creates/destroys entries as necessary. The physical pages
>> to store the page tables are delegated to the realm as required, and can
>> be undelegated when no longer used.
>>
>> Creating new RTTs is the easy part, tearing down is a little more
>> tricky. The result of realm_rtt_destroy() can be used to effectively
>> walk the tree and destroy the entries (undelegating pages that were
>> given to the realm).
>>
>> Unmap the Realm IPA space once during stage-2 teardown. Defer destruction
>> of non-root RTTs until final Realm destruction, after REALM_TERMINATE and
>> before destroying the RD; root RTTs remain until the RD has gone away.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/include/asm/kvm_rmi.h |   9 ++
>>   arch/arm64/kvm/mmu.c             |  17 ++-
>>   arch/arm64/kvm/rmi.c             | 189 +++++++++++++++++++++++++++++++
>>   3 files changed, 214 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/
>> asm/kvm_rmi.h
>> index f1a1ed6b91f5..58d825e40bdf 100644
>> --- a/arch/arm64/include/asm/kvm_rmi.h
>> +++ b/arch/arm64/include/asm/kvm_rmi.h
>> @@ -57,6 +57,7 @@ enum realm_state {
>>    * @sro: Preallocated SRO state context for Realm MMU operations
>>    * @state: The lifetime state machine for the realm
>>    * @ia_bits: Number of valid Input Address bits in the IPA
>> + * @stage2_unmapped: The Realm stage-2 mappings have been removed
>>    */
>>   struct realm {
>>       void *rd;
>> @@ -70,6 +71,7 @@ struct realm {
>>       struct rmi_sro_state *sro;
>>       enum realm_state state;
>>       unsigned int ia_bits;
>> +    bool stage2_unmapped;
>>   };
>>     void kvm_init_rmi(void);
>> @@ -77,5 +79,12 @@ u32 kvm_rmm_ipa_limit(void);
>>     int kvm_init_realm(struct kvm *kvm);
>>   void kvm_destroy_realm(struct kvm *kvm);
>> +int kvm_realm_teardown_stage2(struct kvm *kvm);
>> +
>> +static inline bool kvm_realm_is_private_address(struct realm *realm,
>> +                        unsigned long addr)
>> +{
>> +    return !(addr & BIT(realm->ia_bits - 1));
>> +}
>>     #endif /* __ASM_KVM_RMI_H */
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index b049ea67d9af..51fda7b2ff7f 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1145,9 +1145,24 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct
>> kvm_s2_mmu *mmu, unsigned long t
>>       return err;
>>   }
>>   +static void kvm_realm_uninit_stage2(struct kvm_s2_mmu *mmu)
>> +{
>> +    struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>> +
>> +    mutex_lock(&kvm->arch.config_lock);
>> +    if (kvm_realm_state(kvm) == REALM_STATE_ACTIVE) {
>> +        kvm_set_realm_state(kvm, REALM_STATE_DYING);
>> +        WARN_ON(kvm_realm_teardown_stage2(kvm));
>> +    }
>> +    mutex_unlock(&kvm->arch.config_lock);
>> +}
>> +
>>   void kvm_uninit_stage2_mmu(struct kvm *kvm)
>>   {
>> -    kvm_free_stage2_pgd(&kvm->arch.mmu);
>> +    if (kvm_vm_is_realm(kvm))
>> +        kvm_realm_uninit_stage2(&kvm->arch.mmu);
>> +    else
>> +        kvm_free_stage2_pgd(&kvm->arch.mmu);
>>       kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
>>   }
>>   diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index 45ecbaa467d1..f190143b33ba 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -11,6 +11,14 @@
>>   #include <asm/kvm_pgtable.h>
>>   #include <asm/virt.h>
>>   +static inline unsigned long rmi_rtt_level_mapsize(int level)
>> +{
>> +    if (WARN_ON(level > KVM_PGTABLE_LAST_LEVEL))
>> +        return PAGE_SIZE;
>> +
>> +    return (1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
>> +}
> 
> 
> Now that we are using the same PAGE_SIZE as GRANULE size, we could
> replace the above helper with kvm_granule_size() ?

Makes sense - I added all these helpers when the RMM was always 4k page
size. Obviously I haven't yet managed to remove them all yet! ;)

>>   static bool rmi_has_feature(int reg, unsigned long feature)
>>   {
>>       return !!u64_get_bits(rmi_feat_reg(reg), feature);
>> @@ -21,11 +29,180 @@ u32 kvm_rmm_ipa_limit(void)
>>       return u64_get_bits(rmi_feat_reg(0), RMI_FEATURE_REGISTER_0_S2SZ);
>>   }
>>   +static int get_start_level(struct realm *realm)
>> +{
>> +    return 4 - stage2_pgtable_levels(realm->ia_bits);
>> +}
>> +
>> +static void free_rtt(phys_addr_t phys)
>> +{
>> +    if (rmi_free_delegated_page(phys))
>> +        return;
>> +
>> +    kvm_account_pgtable_pages(phys_to_virt(phys), -1);
>> +}
>> +
> 
> ...
> 
>> +
>> +static int realm_tear_down_rtt_level(struct realm *realm, int level,
>> +                     unsigned long start, unsigned long end)
>> +{
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
> 
> We assume that the start is aligned to the kvm_granule_size(level - 1)
> and thus this works ? Should we enforce this before the loop ?

I'll add a WARN_ON() path to check this.

>> +
>> +        next_addr = ALIGN(addr + 1, map_size);
> 
> So that we can be sure we have (align_addr != next_addr).
> 
>> +
>> +        if (next_addr > end || align_addr != addr) {
>> +            /*
>> +             * The target range is smaller than what this level
>> +             * covers, recurse deeper.
>> +             */
>> +            ret = realm_tear_down_rtt_level(realm,
>> +                            level + 1,
>> +                            addr,
>> +                            min(next_addr, end));
>> +            if (ret)
>> +                return ret;
>> +            continue;
>> +        }
>> +
>> +        ret = realm_rtt_destroy(realm, addr, level,
>> +                    &rtt_granule, &next_addr);
>> +        if (ret < 0)
>> +            return ret;
>> +
>> +        switch (RMI_RESULT_STATUS(ret)) {
>> +        case RMI_SUCCESS:
>> +            free_rtt(rtt_granule);
>> +            break;
>> +        case RMI_ERROR_RTT:
>> +            if (next_addr > addr) {
>> +                /* Missing RTT, skip */
>> +                break;
>> +            }
>> +            /*
>> +             * We tear down the RTT range for the full IPA
>> +             * space, after everything is unmapped. Also we
>> +             * descend down only if we cannot tear down a
>> +             * top level RTT. Thus RMM must be able to walk
>> +             * to the requested level. e.g., a block mapping
>> +             * exists at L1 or L2.
>> +             */
>> +            if (WARN_ON(RMI_RESULT_DATA_LEVEL(ret) != level))
>> +                return -EBUSY;
>> +            if (WARN_ON(level == KVM_PGTABLE_LAST_LEVEL))
>> +                return -EBUSY;
>> +
>> +            /*
>> +             * The table has active entries in it, recurse deeper
>> +             * and tear down the RTTs.
>> +             */
>> +            next_addr = ALIGN(addr + 1, map_size);
>> +            ret = realm_tear_down_rtt_level(realm,
>> +                            level + 1,
>> +                            addr,
>> +                            next_addr);
>> +            if (ret)
>> +                return ret;
>> +            /*
>> +             * Now that the child RTTs are destroyed,
>> +             * retry at this level.
>> +             */
>> +            next_addr = addr;
>> +            break;
>> +        default:
>> +            WARN_ON(1);
>> +            return -ENXIO;
>> +        }
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +static int realm_tear_down_rtt_range(struct realm *realm,
>> +                     unsigned long start, unsigned long end)
>> +{
>> +    /*
>> +     * Root level RTTs can only be destroyed after the RD is
>> destroyed. So
>> +     * tear down everything below the root level
>> +     */
>> +    return realm_tear_down_rtt_level(realm, get_start_level(realm) + 1,
>> +                     start, end);
>> +}
>> +
>> +static int realm_destroy_rtts(struct kvm *kvm)
>> +{
>> +    struct realm *realm = &kvm->arch.realm;
>> +    unsigned int ia_bits = realm->ia_bits;
>> +
>> +    lockdep_assert_held(&kvm->arch.config_lock);
> 
> Should we assert that realm->stage2_unmapped == true here, since we
> expect to not have any valid mappings ?

Will add.

>> +
>> +    return realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits));
>> +}
>> +
>> +static void realm_unmap_stage2(struct kvm *kvm)
>> +{
>> +    struct realm *realm = &kvm->arch.realm;
>> +
>> +    lockdep_assert_held(&kvm->arch.config_lock);
>> +
>> +    if (realm->stage2_unmapped)
>> +        return;
>> +
>> +    write_lock(&kvm->mmu_lock);
>> +    kvm_stage2_unmap_range(&kvm->arch.mmu, 0,
>> +                   BIT(realm->ia_bits - 1), true);
> 
> 
>> +    write_unlock(&kvm->mmu_lock);
> 
> Do we need this write_lock() ? IIUC, the Realm is dying and this is
> called from kvm_destroy_realm()/ kvm_free_stage2_pgd(). KVM assumes that
> stage2_destroy_range() is called without kvm->mmu_lock held (along with
> other relaxations).  The comment above stage2_destroy_range() says:

I think you might be right that we don't *need* it. The main requirement
from the current code is the cond_resched_rwlock_write() call in
realm_unmap_xxxx_range(). So the options I see are:

 1. Hold the lock even though we don't need to.

 2. Force may_block to false even though it could be true.

 3. Add an extra parameter to allow a call to cond_resched() rather than
cond_resched_rwlock_write().

My preference is to keep the code simple and hold the lock - do you see
any specific problem with taking the lock here?

Thanks,
Steve

> 
> /*
>  * Assume that @pgt is valid and unlinked from the KVM MMU to free the
>  * page-table without taking the kvm_mmu_lock and without performing any
>  * TLB invalidations.
>  *
>  * Also, the range of addresses can be large enough to cause need_resched
>  * warnings, for instance on CONFIG_PREEMPT_NONE kernels. Hence, invoke
>  * cond_resched() periodically to prevent hogging the CPU for a long time
>  * and schedule something else, if required.
>  */
> 
> So, I believe we should be safe here without the lock ?
> 
> Also, could we not call the realm unmap routine directly here, rather
> than going through the generic helper to get back to what we want ?
> 
> 
> Suzuki
> 
> 
>> +
>> +    realm->stage2_unmapped = true;
>> +}
>> +
>> +int kvm_realm_teardown_stage2(struct kvm *kvm)
>> +{
>> +    lockdep_assert_held(&kvm->arch.config_lock);
>> +
>> +    realm_unmap_stage2(kvm);
>> +    return 0;
>> +}
>> +
>>   void kvm_destroy_realm(struct kvm *kvm)
>>   {
>>       struct realm *realm = &kvm->arch.realm;
>>       size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
>>   +    guard(mutex)(&kvm->arch.config_lock);
>> +
>>       if (!kvm_realm_is_created(kvm)) {
>>           kfree(realm->sro);
>>           realm->sro = NULL;
>> @@ -34,12 +211,24 @@ void kvm_destroy_realm(struct kvm *kvm)
>>         kvm_set_realm_state(kvm, REALM_STATE_DYING);
>>   +    /*
>> +     * REALM_DESTROY requires the realm to be non-live: all RECs must
>> have
>> +     * been destroyed and the root RTTs must be empty. Unmap the IPA
>> space
>> +     * and destroy any non-root RTTs before tearing down the RD. The
>> root
>> +     * RTT pages are still owned by the RMM at this point, so keep
>> the KVM
>> +     * pgtable alive until after REALM_DESTROY and undelegation.
>> +     */
>> +    realm_unmap_stage2(kvm);
>> +
>>       if (realm->rd) {
>>           phys_addr_t rd_phys = virt_to_phys(realm->rd);
>>             if (WARN_ON(rmi_realm_terminate(rd_phys, realm->sro)))
>>               return;
>>   +        if (WARN_ON(realm_destroy_rtts(kvm)))
>> +            return;
>> +
>>           if (WARN_ON(rmi_realm_destroy(rd_phys, realm->sro)))
>>               return;
>>           rmi_free_delegated_page(rd_phys);
> 

