Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795478470;
	b=evc9Edy1swLDRLoU/IejShfGTuIdMai8brNki20lasKohZBX/OpynQXKsUtvmsOFoDpX
	 ZYJGsD7unoJkcB2Z1+g/K+axcSCWB7y6YSMNF+PHBXR429AtnvTjvC8UbxTaK/2+8S4Qi
	 j+HhTduhdP1veKjy5coNKd4OzGM40sXL+cghWHWDL5rA5qdNtFkpVari8GJ3V/1htU+x4
	 zESRpAkOM1s/9j7sh12bDoIVkbDMhC/uhfP/2umrCeoCy4r2B8vPC86zB1flZGtCuXIeC
	 CS2mOSJQTIbw0fQIQDKR8N2y17X7WZ0G1hwz5cA0SnNCIvH34x0YAF8IWvsNirUpPJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795478470;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:From:To:Cc:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=mvZfEfW5RStelXlEG0PRgWitbRj+0/EdNDsq46xASbM=;
	b=3Vgo8mGNJvNr0y68cUlQ5ESiYZ9SeLqq9krqz3apLgnp4Yd/napczHnBR8HwNxkk76v1
	 Q++UiWcjevhbbLeaAhrvlp7tET1xIwlHhAWye3s0UeYVqch1/cQ15b17nvIBUeNyoQqE6
	 KT+k7J0S9rZa8KLjcwgXkC6IlYe0LIMC7r5637wY75JRXYrJ1qEJ+8I56nL/OLJdZSBwK
	 /o9WJNHFxSWpIvrlH1kfNHFWz4teeO09RHbXao5kIYZ7zPfpbo04Hnv4YIrk7axhXF0WJ
	 uwxQiCLps+3+hifrKiZDVex0ob3A2O1LpM71DQBlKbUmaH09/mgLmn/DFIbUuGIgM1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=c4KjOW5B;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06DEC606A322;
	Tue, 24 Nov 2026 00:01:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06DEC606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=c4KjOW5B
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1ADFC339;
	Mon, 23 Nov 2026 16:01:05 -0800 (PST)
Received: from [10.57.72.180] (unknown [10.57.72.180])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C7213F763;
	Mon, 23 Nov 2026 16:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795478468; bh=z+PUNwa9+EwbdaBwXou0c5+rj8T7/aI/DwQawFtJnzc=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=c4KjOW5BN9ItMHCoak80zBU8BS/AQ/7DYC9pa1KyF8ybcl+E3+zHmcpmUjFciBjuU
	 DhI/i1i+PRwzk6i/8pYVS0rmfSz92fJcWwcDyaxGqmK1QrQ2UkqB9sJtFjpU4PMn19
	 QYcGemWHIzJsSmGftPtNImsHDcDAz/UpM2Zu8BZk=
Message-ID: <4ac7d031-ed52-48ae-be47-c8045bdc58f7@arm.com>
Date: Tue, 24 Nov 2026 00:01:02 +0000
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
Subject: Re: [PATCH v4 06/11] KVM: arm64: CCA: Destroy RTTs
Content-Language: en-GB
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
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
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 Kohei Enju <enju.kohei@fujitsu.com>
References: <20261123104233.95710-1-steven.price@arm.com>
 <20261123104233.95710-7-steven.price@arm.com>
 <b224f2af-5881-4ea9-9e6f-38b8fef8ad9e@arm.com>
In-Reply-To: <b224f2af-5881-4ea9-9e6f-38b8fef8ad9e@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 23/11/2026 11:57, Suzuki K Poulose wrote:
> On 23/11/2026 10:42, Steven Price wrote:
>> The RMM owns the stage 2 page tables for a realm, and KVM must request
>> that the RMM creates/destroys entries as necessary. The physical pages
>> to store the page tables are delegated to the realm as required, and can
>> be undelegated when no longer used.
>>
>> Creating new RTTs is the easy part, destroying them is a little more
>> tricky. The result of realm_rtt_destroy() can be used to effectively
>> walk the tree and destroy the entries (undelegating pages that were
>> given to the realm).
>>
> 
> 
>> Tear down a created Realm whether it is still new or has been activated.
>> Unmap the Realm IPA space once during stage-2 teardown. Defer
>> destruction of non-root RTTs until final Realm destruction, after
>> REALM_TERMINATE and before destroying the RD; root RTTs remain until the
>> RD has gone away.
> 
> While I understand what this is trying to convey, it may be unclear
> to someone who is not familiar with the "Realm Liveness".
> How about something like :
> 
> Realm can be destroyed ONLY if all stage2 Root RTTs are not live
> (along with no RECs or other resources assigned to it).
> i.e., there are no live mappings or tables mapped from the Root
> tables. So, we unmap the entire stage2 and move the Realm to
> ZOMBIE state then destroy all the non-root level RTTs. The Root
> level RTTs can only be reclaimed after the RD is destroyed.
> 
> The comment in the code is actually pretty clear.
> 
>>
>> Use the same minimum of two stage-2 levels as VTCR when deriving
>> the Realm's starting RTT level. Without this, narrow IPAs on
>> 64K-page hosts can give the RMM a different starting level from
>> KVM's own page tables.
> 
> I believe this paragraph can go as we now have start_level cached.
> 
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>>
>> ---
>> Changes since v3:
>> - Match VTCR's minimum of two stage-2 levels for Realm RTTs.
>> - Use explicit config_lock cleanup in Realm destruction.
>>
>> Changes since v2:
>> - Use the actual stage-2 start level and correct the RTT skip
>>    granularity. Free SRO state on final teardown errors.
>>
>> Changes since v1:
>> - Tear down created Realms in both NEW and ACTIVE states. Fix the
>>    RTT start level, page accounting on failed undelegation, and
>>    handling of RTT granules returned by RMI.
>> ---
>>   arch/arm64/include/asm/kvm_rmi.h |   3 +
>>   arch/arm64/kvm/mmu.c             |  17 ++-
>>   arch/arm64/kvm/rmi.c             | 178 +++++++++++++++++++++++++++++++
>>   3 files changed, 197 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/ 
>> asm/kvm_rmi.h
>> index 4ac1af622872..01ecaabd839b 100644
>> --- a/arch/arm64/include/asm/kvm_rmi.h
>> +++ b/arch/arm64/include/asm/kvm_rmi.h
>> @@ -58,6 +58,7 @@ enum realm_state {
>>    * @state: The lifetime state machine for the realm
>>    * @ia_bits: Number of valid Input Address bits in the IPA
>>    * @start_level: Starting level of the Realm Translation Table
>> + * @stage2_unmapped: The Realm stage-2 mappings have been removed
>>    */
>>   struct realm {
>>       phys_addr_t rd_phys;
>> @@ -72,11 +73,13 @@ struct realm {
>>       enum realm_state state;
>>       unsigned int ia_bits;
>>       int start_level;
>> +    bool stage2_unmapped;
>>   };
>>   u32 kvm_rmm_ipa_limit(void);
>>   int kvm_init_realm(struct kvm *kvm);
>>   void kvm_destroy_realm(struct kvm *kvm);
>> +void kvm_realm_unmap_stage2_all(struct kvm *kvm);
>>   #endif /* __ASM_KVM_RMI_H */
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 84b02699f103..4a975715375c 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1149,9 +1149,24 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct 
>> kvm_s2_mmu *mmu, unsigned long t
>>       return err;
>>   }
>> +static void kvm_realm_uninit_stage2(struct kvm_s2_mmu *mmu)
>> +{
>> +    struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>> +
>> +    guard(mutex)(&kvm->arch.config_lock);
>> +    if (kvm_realm_state(kvm) == REALM_STATE_NEW ||
>> +        kvm_realm_state(kvm) == REALM_STATE_ACTIVE) {
>> +        kvm_set_realm_state(kvm, REALM_STATE_DYING);
>> +        kvm_realm_unmap_stage2_all(kvm);
>> +    }
>> +}
>> +
>>   void kvm_uninit_stage2_mmu(struct kvm *kvm)
>>   {
>> -    kvm_free_stage2_pgd(&kvm->arch.mmu);
>> +    if (kvm_realm_is_created(kvm))
>> +        kvm_realm_uninit_stage2(&kvm->arch.mmu);
>> +    else
>> +        kvm_free_stage2_pgd(&kvm->arch.mmu);
>>       kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
>>   }
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index fafca2439c46..435174ac3d87 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -16,22 +16,196 @@ u32 kvm_rmm_ipa_limit(void)
>>       return u64_get_bits(rmi_feat_reg(0), RMI_FEATURE_REGISTER_0_S2SZ);
>>   }
>> +static void free_rtt(phys_addr_t phys)
>> +{
>> +    kvm_account_pgtable_pages(phys_to_virt(phys), -1);
>> +    if (rmi_free_delegated_page(phys))
>> +        kvm_account_pgtable_pages(phys_to_virt(phys), 1);
>> +}
>> +
>> +/*
>> + * realm_rtt_destroy - Destroy an RTT at @level for @addr.
>> + *
>> + * Returns - Result of the RMI_RTT_DESTROY call, and:
>> + * @rtt_granule:    RTT granule, if the RTT was destroyed.
>> + * @next_addr:        IPA corresponding to the next possible valid 
>> entry we
>> + *            can target
>> + */
>> +static long realm_rtt_destroy(struct realm *realm, unsigned long addr,
>> +                  int level, phys_addr_t *rtt_granule,
>> +                  unsigned long *next_addr)
>> +{
>> +    unsigned long out_rtt;
>> +    long ret;
>> +
>> +    ret = rmi_rtt_destroy(realm->rd_phys, addr, level,
>> +                  &out_rtt, next_addr);
>> +
>> +    if (ret == RMI_SUCCESS)
>> +        *rtt_granule = out_rtt;
>> +
>> +    return ret;
>> +}
>> +
>> +static int realm_destroy_rtt_level(struct realm *realm, int level,
>> +                   unsigned long start, unsigned long end)
>> +{
>> +    ssize_t map_size;
>> +    unsigned long addr, next_addr;
>> +
>> +    if (WARN_ON(level > KVM_PGTABLE_LAST_LEVEL))
>> +        return -EINVAL;
>> +
>> +    map_size = kvm_granule_size(level - 1);
>> +    if (WARN_ON(!IS_ALIGNED(start, map_size)))
>> +        return -EINVAL;
>> +
>> +    for (addr = start; addr < end; addr = next_addr) {
>> +        phys_addr_t rtt_granule;
>> +        long ret;
>> +        unsigned long align_addr = ALIGN(addr, map_size);
>> +
>> +        next_addr = ALIGN(addr + 1, map_size);
>> +
>> +        if (next_addr > end || align_addr != addr) {
>> +            /*
>> +             * The target range is smaller than what this level
>> +             * covers, recurse deeper.
>> +             */
>> +            ret = realm_destroy_rtt_level(realm,
>> +                              level + 1,
>> +                              addr,
>> +                              min(next_addr, end));
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
>> +             * We destroy the RTT range for the full IPA
>> +             * space, after everything is unmapped. Also we
>> +             * descend down only if we cannot destroy a
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
>> +             * and destroy the RTTs.
>> +             */
>> +            next_addr = ALIGN(addr + 1, map_size);
>> +            ret = realm_destroy_rtt_level(realm,
>> +                              level + 1,
>> +                              addr,
>> +                              next_addr);
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
>> +static int realm_destroy_rtt_range(struct realm *realm,
>> +                   unsigned long start, unsigned long end)
>> +{
>> +    /*
>> +     * Root level RTTs can only be destroyed after the RD is 
>> destroyed. So
>> +     * destroy everything below the root level
>> +     */
>> +    return realm_destroy_rtt_level(realm, realm->start_level + 1,
>> +                       start, end);
>> +}
>> +
> 
> minor nit: May be we could fold the above into realm_destroy_rtts()
> 
>> +static int realm_destroy_rtts(struct kvm *kvm)
>> +{
>> +    struct realm *realm = &kvm->arch.realm;
>> +    unsigned int ia_bits = realm->ia_bits;
>> +
>> +    lockdep_assert_held(&kvm->arch.config_lock);
>> +
>> +    return realm_destroy_rtt_range(realm, 0, (1UL << ia_bits));
>> +}
>> +
>> +void kvm_realm_unmap_stage2_all(struct kvm *kvm)
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

Actually, the unprotected IPA mapping entries are not "live".
So we could unmap only the protected IPA half and destroy the
RTTs directly on the unprotected IPA.

Suzuki
