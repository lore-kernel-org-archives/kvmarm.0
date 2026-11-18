Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019941;
	b=uKwDBJcrdmxS3H5ppB+G2DMgjsJzQxAUPZrIhoosIn2FIyR3LlPeteEkjeThbVFHWBkX
	 KahfEjY+u84xEuwdEm2MqzqY/llVKF81uX2wb+AnTtizYAlcn/DUZiP41uKtuTQ6PAPM4
	 6oqOazl7NbP5fU/exxZFkqHORFAKmA+TzZdbIT+KQeOH8iCLOVhmbU+vOp8iQlr5D+jHO
	 8jrn4ABkQLmItRQLUphFSr2B14RW8AkU5bbJ4aBo+tSWGUyqW8nLMjDGJYGZCQR9uT+TQ
	 ulU037xJ/Xd0KJgDs6o3dN+TyHeiON9kb5XNaJNRYRysTVA4oYLsq5WZhEIEWSfdkvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019941;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=xhshAXx/HJIV9Fr5BiwP97X+f/Jy0ofjge9BLQM7/vQ=;
	b=MCW9eXptpbklHRFKDUsmbK3reG/G+BGfigxAuKetem20AFOpYLBVIsy62zw5+Kp/ax/y
	 dxFOsqFS6YiOzfBOnRAswT/TXjK7TJIw3+4uesL4bJLOWZmFEt+jPUmT4Rd1gl9InW95V
	 DQoiyFetteyYyyGOryu7ZS+htJDIQJ3nFERIK+BNb9w8meM4LkakknpBhHmkSYYmTwcmR
	 380GIP5UXDD4VpD96uklqZVCwyre5q+60msro0RcgSFjNkcbIQ+xarmOy6qUH8GrHcdzo
	 WVOTuKIsfHGbOPFi0nYWYYb04OT8Mtq9+xDHRDW9IoHH2K1i1Im1ulitQbbv/9r/Y+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=O7IFJYlr;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94AB8606A330;
	Wed, 18 Nov 2026 16:39:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94AB8606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=O7IFJYlr
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE248143D;
	Wed, 18 Nov 2026 08:38:56 -0800 (PST)
Received: from [10.57.62.206] (unknown [10.57.62.206])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 69D713F673;
	Wed, 18 Nov 2026 08:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795019939; bh=QtGr9W/gG9i3RY3G1VDTPchQ3C8OnITHs2nsse5oX2U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=O7IFJYlrCnC46DDW0Xv+9KL4MUHkCr92xvtLOtqtDBARhHZj7x/YV6c/7jZq/HwUy
	 aLIoXBBFAHzUyYt+yCUX0ZjuJ3FZcvYsQt6f6A/ActbJ+S0j7Xj5d9Nw4upUHZBXlq
	 zN+4OJbRh9R0o7pp6i8zmJU3lRxU7IY3m7SpoVKE=
Message-ID: <effce188-1d76-4764-90e0-fcb9d83862bc@arm.com>
Date: Wed, 18 Nov 2026 16:38:56 +0000
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
To: sashiko-reviews@lists.linux.dev, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261116164358.142785-1-steven.price@arm.com>
 <20261116164358.142785-6-steven.price@arm.com>
 <sashiko-outbox-217410@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <sashiko-outbox-217410@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 16/11/2026 17:08, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential
> issues to consider:
> - [High] KVM: arm64: unclamped stage-2 levels in get_start_level() on
>   64K pages
> - [Medium] KVM: arm64: CCA: unlocked kvm_realm_is_created() check in
>   kvm_uninit_stage2_mmu()
> - [Low] KVM: arm64: mix of guard() and goto cleanup in
>   kvm_destroy_realm()
> - [Low] KVM: arm64: possible skipped parent retry in
>   realm_tear_down_rtt_level()
> --
> 
> commit 80a462fb8b46e04c72060d069b1296caf72d83ff
> Author: Steven Price <steven.price@arm.com>
> 
> KVM: arm64: CCA: Tear down RTTs
> 
> This commit adds stage-2 unmapping and Realm Translation Table (RTT)
> teardown for Arm CCA Realms during stage-2 MMU uninitialization and final
> Realm destruction.
> 
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index ac72db3d4505f..9baf2352d2a8f 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1145,9 +1145,25 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>>  	return err;
>>  }
>>  
>> +static void kvm_realm_uninit_stage2(struct kvm_s2_mmu *mmu)
>> +{
>> +	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>> +
>> +	mutex_lock(&kvm->arch.config_lock);
>> +	if (kvm_realm_state(kvm) == REALM_STATE_NEW ||
>> +	    kvm_realm_state(kvm) == REALM_STATE_ACTIVE) {
>> +		kvm_set_realm_state(kvm, REALM_STATE_DYING);
>> +		WARN_ON(kvm_realm_teardown_stage2(kvm));
>> +	}
>> +	mutex_unlock(&kvm->arch.config_lock);
>> +}
>> +
>>  void kvm_uninit_stage2_mmu(struct kvm *kvm)
>>  {
>> -	kvm_free_stage2_pgd(&kvm->arch.mmu);
>> +	if (kvm_realm_is_created(kvm))
>> +		kvm_realm_uninit_stage2(&kvm->arch.mmu);
>> +	else
>> +		kvm_free_stage2_pgd(&kvm->arch.mmu);
>>  	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
>>  }
> 
> [Severity: Medium]
> Can kvm_uninit_stage2_mmu() race with Realm creation by checking
> kvm_realm_is_created() outside kvm->arch.config_lock?
> 
> If kvm_mmu_notifier_release() -> kvm_arch_flush_shadow_all() runs before
> or concurrently with Realm creation, kvm_uninit_stage2_mmu() takes the
> else branch without holding config_lock, freeing mmu->pgt and clearing
> mmu->pgd_phys while leaving realm.state at REALM_STATE_NONE.  Checking
> kvm_vm_is_realm(kvm) here and handling all realm.state transitions inside
> kvm_realm_uninit_stage2() under config_lock (including moving
> REALM_STATE_NONE to REALM_STATE_DEAD and freeing the PGD) would avoid the
> race.

I don't believe this race can occur. The MMU notifier release runs as
the owning mm exits, while that mm will be help during ioctls (including
realm creation).

>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index 57f59b618a96e..74b89da4e8015 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -16,22 +16,213 @@ u32 kvm_rmm_ipa_limit(void)
>>  	return u64_get_bits(rmi_feat_reg(0), RMI_FEATURE_REGISTER_0_S2SZ);
>>  }
>>  
>> +static int get_start_level(struct realm *realm)
>> +{
>> +	/*
>> +	 * kvm_init_ipa_range() enforces a minimum of 32 IPA bits
>> +	 * (ARM64_MIN_PARANGE_BITS).
>> +	 */
>> +	return 4 - stage2_pgtable_levels(realm->ia_bits);
>> +}
> 
> [Severity: High]
> Does get_start_level() return 3 instead of 2 for a 32-bit or 33-bit IPA
> Realm on CONFIG_ARM64_64K_PAGES?
> 
> stage2_pgtable_levels(ipa) evaluates ARM64_HW_PGTABLE_LEVELS((ipa) - 4),
> which is 1 for 32 or 33 IPA bits with 64K pages, whereas kvm_get_vtcr()
> clamps the stage-2 levels to at least 2:
> 
> arch/arm64/kvm/hyp/pgtable.c:kvm_get_vtcr() {
>     ...
> 	lvls = stage2_pgtable_levels(phys_shift);
> 	if (lvls < 2)
> 		lvls = 2;
>     ...
> }
> 
> When get_start_level() returns 3, realm_tear_down_rtt_range() calls
> realm_tear_down_rtt_level() with level = 4 (> KVM_PGTABLE_LAST_LEVEL),
> triggering WARN_ON() and returning -EINVAL, which causes
> kvm_destroy_realm() to abort and leak the Realm Descriptor, RTT granules
> and stage-2 PGD pages.
> 
> [ ... ]

Hmm, I changed this based on Suzuki's argument[1] that ia_bits is at
least 32 bits. But I think Sashiko might have a point.

@Suzuki: Are we missing something? It certainly seems safer to just
match the logic in kvm_get_vtcr() and explicitly clamp. So unless you
can tell me what I'm missing then I'll change this back to:

  return 4 - max(2, stage2_pgtable_levels(realm->ia_bits));

[1] https://lore.kernel.org/r/e1690e53-70fb-47fe-bd06-4758b1e196d2@arm.com

>> +static int realm_tear_down_rtt_level(struct realm *realm, int level,
>> +				     unsigned long start, unsigned long end)
>> +{
>> +	ssize_t map_size;
>> +	unsigned long addr, next_addr;
>> +
>> +	if (WARN_ON(level > KVM_PGTABLE_LAST_LEVEL))
>> +		return -EINVAL;
>> +
>> +	map_size = kvm_granule_size(level - 1);
>> +	if (WARN_ON(!IS_ALIGNED(start, map_size)))
>> +		return -EINVAL;
>> +
>> +	for (addr = start; addr < end; addr = next_addr) {
>> +		phys_addr_t rtt_granule;
>> +		long ret;
>> +		unsigned long align_addr = ALIGN(addr, map_size);
>> +
>> +		next_addr = ALIGN(addr + 1, map_size);
>> +
>> +		if (next_addr > end || align_addr != addr) {
>> +			/*
>> +			 * The target range is smaller than what this level
>> +			 * covers, recurse deeper.
>> +			 */
>> +			ret = realm_tear_down_rtt_level(realm,
>> +							level + 1,
>> +							addr,
>> +							min(next_addr, end));
>> +			if (ret)
>> +				return ret;
>> +			continue;
>> +		}
>> +
>> +		ret = realm_rtt_destroy(realm, addr, level,
>> +					&rtt_granule, &next_addr);
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +		switch (RMI_RESULT_STATUS(ret)) {
>> +		case RMI_SUCCESS:
>> +			free_rtt(rtt_granule);
>> +			break;
>> +		case RMI_ERROR_RTT:
>> +			if (next_addr > addr) {
>> +				/* Missing RTT, skip */
>> +				break;
>> +			}
>> +			/*
>> +			 * We tear down the RTT range for the full IPA
>> +			 * space, after everything is unmapped. Also we
>> +			 * descend down only if we cannot tear down a
>> +			 * top level RTT. Thus RMM must be able to walk
>> +			 * to the requested level. e.g., a block mapping
>> +			 * exists at L1 or L2.
>> +			 */
>> +			if (WARN_ON(RMI_RESULT_DATA_LEVEL(ret) != level))
>> +				return -EBUSY;
> 
> [Severity: Low]
> This question rests on an Arm CCA RMM specification detail that could not
> be confirmed from the kernel source: when SMC_RMI_RTT_DESTROY fails with
> RMI_ERROR_RTT because the RTT at @level still has live child table
> entries, can the RMM return out_top > addr (with addr < next_addr <
> addr + map_size) if the initial entries in that RTT are non-live, or report
> RMI_RESULT_DATA_LEVEL(ret) == level - 1?

Nope. RMI_RTT_DESTROY will return with out_top == ipa if the target RTT
is live. out_top > ipa describes a missing RTT.

> If out_top advances to the first live entry inside the RTT at @level, the
> if (next_addr > addr) check treats the RTT as missing and advances addr to
> that unaligned next_addr; the next iteration then sees align_addr != addr,
> destroys the remaining child RTTs at level + 1, and continues to the next
> map_size boundary without retrying realm_rtt_destroy() on the parent RTT
> at @level, leaving it live and causing rmi_realm_destroy() to fail.  If
> instead the walk terminates at level - 1 with next_addr == addr,
> WARN_ON(RMI_RESULT_DATA_LEVEL(ret) != level) fires and aborts teardown
> with -EBUSY.
> 
> [ ... ]
> 
>>  void kvm_destroy_realm(struct kvm *kvm)
>>  {
>>  	struct realm *realm = &kvm->arch.realm;
>>  	size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
>>  
>> +	/*
>> +	 * Serialize final RMM teardown with Realm creation and stage-2 teardown,
>> +	 * which also access Realm state under config_lock.
>> +	 */
>> +	guard(mutex)(&kvm->arch.config_lock);
>> +
>>  	if (!kvm_realm_is_created(kvm))
>>  		goto out_free_sro;
>>  
>>  	kvm_set_realm_state(kvm, REALM_STATE_DYING);
>>  
>> +	/*
>> +	 * REALM_DESTROY requires the realm to be non-live: all RECs must have
>> +	 * been destroyed and the root RTTs must be empty. Unmap the IPA space
>> +	 * and destroy any non-root RTTs before tearing down the RD. The root
>> +	 * RTT pages are still owned by the RMM at this point, so keep the KVM
>> +	 * pgtable alive until after REALM_DESTROY and undelegation.
>> +	 */
>> +	realm_unmap_stage2(kvm);
>> +
>>  	if (realm->rd_phys) {
>>  		phys_addr_t rd_phys = realm->rd_phys;
>>  
>>  		if (WARN_ON(rmi_realm_terminate(rd_phys, realm->sro)))
>>  			goto out_free_sro;
>>  
>> +		if (WARN_ON(realm_destroy_rtts(kvm)))
>> +			goto out_free_sro;
>> +
>>  		if (WARN_ON(rmi_realm_destroy(rd_phys, realm->sro)))
>>  			goto out_free_sro;
>>  		rmi_free_delegated_page(rd_phys);
>> @@ -44,6 +235,9 @@ void kvm_destroy_realm(struct kvm *kvm)
>>  
>>  	kvm_set_realm_state(kvm, REALM_STATE_DEAD);
>>  
>> +	/* Now that the realm is destroyed, free the entry-level RTTs. */
>> +	kvm_free_stage2_pgd(&kvm->arch.mmu);
>> +
>>  out_free_sro:
>>  	kfree(realm->sro);
>>  	realm->sro = NULL;
> 
> [Severity: Low]
> This isn't a bug, but kvm_destroy_realm() mixes guard(mutex) with goto
> out_free_sro cleanup.  Using __free(kfree) for realm->sro (or explicit
> mutex_lock() and mutex_unlock()) would avoid mixing scope-based cleanup
> and goto unwinding in the same function.
> 

Yes I guess it's a little confusing mixing the two styles.

Thanks,
Steve

