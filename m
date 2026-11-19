Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795100590;
	b=5Pq4MZKzYL3j4BrQk/CkZ99qQ8UcALxX08ePV0f8M/GNpPmQuOSqcrnb8RIsPoK+11Hi
	 CeeQwV/+FiGGPSIftdtIQTKYTgV0VjCLjsgzxhyw0XZXczbxjvwrKqxyVyOVOd8F+eq+g
	 yJQB9wqbiAdvWAXKV7Yv0C33JsXyM+IIIeH7AgUauy+OdWgTedVk6iSpHF+gyH/ejoKYM
	 mYV7822n3wDnXm8tpELDikIPZZhxTQ4yBi+ZzundplB7MWos3DcAj4sXZPdfIWCNOoPV9
	 4DwDNHwc2FdCnEIbEGgtrwGYzEigpWv4zDZli8raqcUi+Hhq9cwDHtKHY6kJe/tlNXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795100590;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:From:To:Cc:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=P+ZIy8aH9ITo5eh4D5fwyzhSNQ9D+PcunkDFedH/A1o=;
	b=RFCe+0qOqwUeBqFNDiDhpCxy/+3XvwH4lYz5l/S4tEb/gAhlXlHcVufmZU8p17dbRMms
	 Tt2I1xZeZgEKf5kbcnSPi84KwsNTQldnF5gMweQ00NyDUb2yaWrmWzLTrCxBnuJFrCqtQ
	 v4mbBhYU3oi2qmzSMFGq6bKa87hF7YkmvTvE4ESevXRESZaxYNElkzyd/rEN4oS+d22Vg
	 QeoK3VC/DA2ZGQxby6TbEMTJLY8olEfkSc89gqb0taUh4UsncXNM2nWgUDr8skuAIozeR
	 2jTkiYzdryIdPtMUPrjTpQGHHErBm1xzb47RkJrF+HYNyP0ZradKk0umEbc3F93/U8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=TpFtQPMr;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69D9F606A33E;
	Thu, 19 Nov 2026 15:03:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69D9F606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=TpFtQPMr
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDB111575;
	Thu, 19 Nov 2026 07:03:06 -0800 (PST)
Received: from [10.0.129.3] (Suzukis-MBP.cambridge.arm.com [10.0.129.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E521C3F882;
	Thu, 19 Nov 2026 07:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795100589; bh=vmOaRyVveMHXPngdaDt5C75x34UiZI+ujGTl+l0JLps=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=TpFtQPMrlKc11d4l23KDGKBUy4VfSJAEebFHth//GPfGi7SUbl+4MOe0JfVy0OnOQ
	 7o72w/vm6GYeUgkDpmJuvtfhVG0l0BsQ/a1fsRJM5c8vXjOBM48978xmt6C4CIlBAo
	 EBkjxkmYub7fBEDSCZYMkO7GGr9SAPEDV9lb7w4M=
Message-ID: <6049409f-3d32-49cb-9223-9128d8e764c7@arm.com>
Date: Thu, 19 Nov 2026 15:03:07 +0000
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
Subject: Re: [PATCH v3 05/11] KVM: arm64: CCA: Tear down RTTs
Content-Language: en-GB
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: sashiko-reviews@lists.linux.dev, Steven Price <steven.price@arm.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261116164358.142785-1-steven.price@arm.com>
 <20261116164358.142785-6-steven.price@arm.com>
 <sashiko-outbox-217410@kernel.org>
 <bbd8332b-1b2a-4a87-9232-4463d5e5a904@arm.com>
In-Reply-To: <bbd8332b-1b2a-4a87-9232-4463d5e5a904@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 19/11/2026 10:51, Suzuki K Poulose wrote:
> On 16/11/2026 17:08, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 4 potential
>> issues to consider:
>> - [High] KVM: arm64: unclamped stage-2 levels in get_start_level() on
>>    64K pages
>> - [Medium] KVM: arm64: CCA: unlocked kvm_realm_is_created() check in
>>    kvm_uninit_stage2_mmu()
>> - [Low] KVM: arm64: mix of guard() and goto cleanup in
>>    kvm_destroy_realm()
>> - [Low] KVM: arm64: possible skipped parent retry in
>>    realm_tear_down_rtt_level()
>> -- 
>>
>> commit 80a462fb8b46e04c72060d069b1296caf72d83ff
>> Author: Steven Price <steven.price@arm.com>
>>
>> KVM: arm64: CCA: Tear down RTTs
>>
>> This commit adds stage-2 unmapping and Realm Translation Table (RTT)
>> teardown for Arm CCA Realms during stage-2 MMU uninitialization and final
>> Realm destruction.
>>
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index ac72db3d4505f..9baf2352d2a8f 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -1145,9 +1145,25 @@ int kvm_init_stage2_mmu(struct kvm *kvm, 
>>> struct kvm_s2_mmu *mmu, unsigned long t
>>>       return err;
>>>   }
>>> +static void kvm_realm_uninit_stage2(struct kvm_s2_mmu *mmu)
>>> +{
>>> +    struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>>> +
>>> +    mutex_lock(&kvm->arch.config_lock);
>>> +    if (kvm_realm_state(kvm) == REALM_STATE_NEW ||
>>> +        kvm_realm_state(kvm) == REALM_STATE_ACTIVE) {
>>> +        kvm_set_realm_state(kvm, REALM_STATE_DYING);
>>> +        WARN_ON(kvm_realm_teardown_stage2(kvm));
>>> +    }
>>> +    mutex_unlock(&kvm->arch.config_lock);
>>> +}
>>> +
>>>   void kvm_uninit_stage2_mmu(struct kvm *kvm)
>>>   {
>>> -    kvm_free_stage2_pgd(&kvm->arch.mmu);
>>> +    if (kvm_realm_is_created(kvm))
>>> +        kvm_realm_uninit_stage2(&kvm->arch.mmu);
>>> +    else
>>> +        kvm_free_stage2_pgd(&kvm->arch.mmu);
>>>       kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
>>>   }
>>
>> [Severity: Medium]
>> Can kvm_uninit_stage2_mmu() race with Realm creation by checking
>> kvm_realm_is_created() outside kvm->arch.config_lock?
>>
>> If kvm_mmu_notifier_release() -> kvm_arch_flush_shadow_all() runs before
>> or concurrently with Realm creation, kvm_uninit_stage2_mmu() takes the
>> else branch without holding config_lock, freeing mmu->pgt and clearing
>> mmu->pgd_phys while leaving realm.state at REALM_STATE_NONE.  Checking
>> kvm_vm_is_realm(kvm) here and handling all realm.state transitions inside
>> kvm_realm_uninit_stage2() under config_lock (including moving
>> REALM_STATE_NONE to REALM_STATE_DEAD and freeing the PGD) would avoid the
>> race.
>>
>>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>>> index 57f59b618a96e..74b89da4e8015 100644
>>> --- a/arch/arm64/kvm/rmi.c
>>> +++ b/arch/arm64/kvm/rmi.c
>>> @@ -16,22 +16,213 @@ u32 kvm_rmm_ipa_limit(void)
>>>       return u64_get_bits(rmi_feat_reg(0), RMI_FEATURE_REGISTER_0_S2SZ);
>>>   }
>>> +static int get_start_level(struct realm *realm)
>>> +{
>>> +    /*
>>> +     * kvm_init_ipa_range() enforces a minimum of 32 IPA bits
>>> +     * (ARM64_MIN_PARANGE_BITS).
>>> +     */
>>> +    return 4 - stage2_pgtable_levels(realm->ia_bits);
>>> +}
>>
>> [Severity: High]
>> Does get_start_level() return 3 instead of 2 for a 32-bit or 33-bit IPA
>> Realm on CONFIG_ARM64_64K_PAGES?
>>
>> stage2_pgtable_levels(ipa) evaluates ARM64_HW_PGTABLE_LEVELS((ipa) - 4),
>> which is 1 for 32 or 33 IPA bits with 64K pages, whereas kvm_get_vtcr()
>> clamps the stage-2 levels to at least 2:
>>
>> arch/arm64/kvm/hyp/pgtable.c:kvm_get_vtcr() {
>>      ...
>>     lvls = stage2_pgtable_levels(phys_shift);
>>     if (lvls < 2)
>>         lvls = 2;
>>      ...
>> }
>>
>> When get_start_level() returns 3, realm_tear_down_rtt_range() calls
>> realm_tear_down_rtt_level() with level = 4 (> KVM_PGTABLE_LAST_LEVEL),
>> triggering WARN_ON() and returning -EINVAL, which causes
>> kvm_destroy_realm() to abort and leak the Realm Descriptor, RTT granules
>> and stage-2 PGD pages.
> 
> My bad. There is already a helper, VTCR_EL2_LVLS() to convert vtcr back 
> to levels. We could as well save it in realm, as we seem to need it
> more than once.

Or even we should reuse the code by wrapping the above logic in
kvm_get_vtcr() to something like:

  int kvm_stage2_pgtable_levels(phys_shift)

Suzuki

> 
>>
>> [ ... ]
>>
>>> +static int realm_tear_down_rtt_level(struct realm *realm, int level,
>>> +                     unsigned long start, unsigned long end)
>>> +{
>>> +    ssize_t map_size;
>>> +    unsigned long addr, next_addr;
>>> +
>>> +    if (WARN_ON(level > KVM_PGTABLE_LAST_LEVEL))
>>> +        return -EINVAL;
>>> +
>>> +    map_size = kvm_granule_size(level - 1);
>>> +    if (WARN_ON(!IS_ALIGNED(start, map_size)))
>>> +        return -EINVAL;
>>> +
>>> +    for (addr = start; addr < end; addr = next_addr) {
>>> +        phys_addr_t rtt_granule;
>>> +        long ret;
>>> +        unsigned long align_addr = ALIGN(addr, map_size);
>>> +
>>> +        next_addr = ALIGN(addr + 1, map_size);
>>> +
>>> +        if (next_addr > end || align_addr != addr) {
>>> +            /*
>>> +             * The target range is smaller than what this level
>>> +             * covers, recurse deeper.
>>> +             */
>>> +            ret = realm_tear_down_rtt_level(realm,
>>> +                            level + 1,
>>> +                            addr,
>>> +                            min(next_addr, end));
>>> +            if (ret)
>>> +                return ret;
>>> +            continue;
>>> +        }
>>> +
>>> +        ret = realm_rtt_destroy(realm, addr, level,
>>> +                    &rtt_granule, &next_addr);
>>> +        if (ret < 0)
>>> +            return ret;
>>> +
>>> +        switch (RMI_RESULT_STATUS(ret)) {
>>> +        case RMI_SUCCESS:
>>> +            free_rtt(rtt_granule);
>>> +            break;
>>> +        case RMI_ERROR_RTT:
>>> +            if (next_addr > addr) {
>>> +                /* Missing RTT, skip */
>>> +                break;
>>> +            }
>>> +            /*
>>> +             * We tear down the RTT range for the full IPA
>>> +             * space, after everything is unmapped. Also we
>>> +             * descend down only if we cannot tear down a
>>> +             * top level RTT. Thus RMM must be able to walk
>>> +             * to the requested level. e.g., a block mapping
>>> +             * exists at L1 or L2.
>>> +             */
>>> +            if (WARN_ON(RMI_RESULT_DATA_LEVEL(ret) != level))
>>> +                return -EBUSY;
>>
>> [Severity: Low]
>> This question rests on an Arm CCA RMM specification detail that could not
>> be confirmed from the kernel source: when SMC_RMI_RTT_DESTROY fails with
>> RMI_ERROR_RTT because the RTT at @level still has live child table
> 
> If the RTT entry at @level is live, RMM returns (RMI_ERROR_RTT, level) 
> with out_top == addr.
> 
> 
>> entries, can the RMM return out_top > addr (with addr < next_addr <
>> addr + map_size) if the initial entries in that RTT are non-live, or 
>> report
>> RMI_RESULT_DATA_LEVEL(ret) == level - 1?
> 
> 
> Suzuki
> 

