Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793638924;
	b=uAWU/u7BrsG1fUVUcuDCEdKuChcBMlG0QKs3rgHMvnD41nl9ZDgr67fRuB4KVuZoS403
	 NwhBW6apZcG89PnMqKWD8bOducZrfpXh/38TRiCjliDMRcrImKksZtJgtsbGaXJS6Hl7t
	 ivHtPEIDsDm/m1e4gHO4VEjio+FjVdeDA4e+pfkNitRB7zxfFhJC9ymdSFpTcS+8Szq2p
	 kax4jiU9vHfM2+raV/S+xkx+XOpqdxO/lLxwA+uIk3PZawdbE3qFUQAVrouWeglZsIGIl
	 RtN1v/QigD5ESOqM0P/N8bSCMrVoagha57/Z6Tk8goZkfkyDFpA7tA6wW3yp6+I7yIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793638924;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=bpH9MkRAZiC53uZXlhyRKBkxR5xRQR1vmni4kZzNvpA=;
	b=LZo3q71Hf/5bkhq0TeAyOhZBoAvey/1bnh8fGbor3/ONXrPDVwQabMSpqSucs5CQWoSu
	 GpdtRzcdil80SbFKOiCUsEQTxMXy3bjb1ILl+L2ODMJ5WDQF/7UPrjKYgYUpyS6M95IKr
	 d/YlYu6Isrdz4QU548wehgs5zAHGs+OGQnz//Dokb/cohGO6337YsLTVzIGPRSltcJUa7
	 pSciPivNZZrb7dRGb3IuE/Xykr5I8ccllPp4E3tY3ATsjYrTwndNpQJHGjpKfKQZRLyGQ
	 6anB/iqeD9ArmTkg7mOzhYurFTLMUH145t3oyOtag7ErZ7Jf6UDfXLebmmS74EgsOqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=nYDGH9IB;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E97AB606F3DE;
	Mon,  2 Nov 2026 17:02:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E97AB606F3DE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=nYDGH9IB
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE33A16F3;
	Mon,  2 Nov 2026 09:01:58 -0800 (PST)
Received: from [10.57.58.9] (unknown [10.57.58.9])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F10C83F59E;
	Mon,  2 Nov 2026 09:02:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793638921; bh=E9jNczzchk5nHtI0CgVSTbFnwcvfP7xLsfmDy95J5TI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nYDGH9IBV5B8LPpqW6tP4xAjJO9W19nd1DYv9I4nTTI5W+6UCqTuKXWi/Qst8LFSi
	 hP7+J/AsSNIRBGUquck3lr3ycA04Ut4VYaal8plplh1VkM9n+ASRvMm3zumxl6gEdP
	 7nqaO74SBk+j5J9Xi984sCJl9sU2t6KRNdSScrCI=
Message-ID: <be11184a-909c-4fed-83b7-90ff6d3aac28@arm.com>
Date: Mon, 2 Nov 2026 17:01:58 +0000
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
To: sashiko-reviews@lists.linux.dev, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-8-steven.price@arm.com>
 <sashiko-outbox-193650@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <sashiko-outbox-193650@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 02/11/2026 15:18, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [High] KVM: arm64: stage-2 PGD leak for uncreated Realms in kvm_destroy_realm()
> - [High] KVM: arm64: unclamped stage-2 levels in get_start_level() breaks 64K RTT teardown
> - [High] KVM: arm64: free_rtt() accounts page table pages after freeing the page
> - [Medium] KVM: arm64: kvm_realm_uninit_stage2() ignores REALM_STATE_NEW
> --
> 
> commit 5954ac2ccf8825a659e2f39dc0db05d96c40be84
> Author: Steven Price <steven.price@arm.com>
> 
> KVM: arm64: CCA: Tear down RTTs
> 
> This commit adds stage-2 page table and Realm Translation Table (RTT)
> teardown for arm64 CCA realms. It unmaps the Realm IPA space during stage-2
> teardown and walks non-root RTTs during final Realm destruction to destroy
> and undelegate them before destroying the Realm Descriptor.
> 
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index b049ea67d9af3..51fda7b2ff7f3 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1145,9 +1145,24 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>>  	return err;
>>  }
>>  
>> +static void kvm_realm_uninit_stage2(struct kvm_s2_mmu *mmu)
>> +{
>> +	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>> +
>> +	mutex_lock(&kvm->arch.config_lock);
>> +	if (kvm_realm_state(kvm) == REALM_STATE_ACTIVE) {
>> +		kvm_set_realm_state(kvm, REALM_STATE_DYING);
>> +		WARN_ON(kvm_realm_teardown_stage2(kvm));
>> +	}
>> +	mutex_unlock(&kvm->arch.config_lock);
>> +}
> 
> [Severity: Medium]
> What happens if kvm_uninit_stage2_mmu() is called via
> kvm_mmu_notifier_release() -> kvm_flush_shadow_all() ->
> kvm_arch_flush_shadow_all() while the Realm is in REALM_STATE_NEW?
> 
> According to enum realm_state in arch/arm64/include/asm/kvm_rmi.h, the Realm
> Descriptor has already been created and stage-2 memory may already be
> populated in REALM_STATE_NEW. Unlike kvm_destroy_realm(), which checks
> kvm_realm_is_created(kvm), sets REALM_STATE_DYING, and unmaps stage-2 for
> both REALM_STATE_NEW and REALM_STATE_ACTIVE, kvm_realm_uninit_stage2() only
> checks for REALM_STATE_ACTIVE.
> 
> Should kvm_realm_uninit_stage2() also handle REALM_STATE_NEW (for example by
> checking kvm_realm_is_created(kvm)) so that stage-2 mappings are unmapped
> before exit_mmap() finishes and the Realm transitions to REALM_STATE_DYING?

Yes we should handle REALM_STATE_NEW. I'm not convinced about using
kvm_realm_is_created(). That would include REALM_STATE_DYING.

>>  void kvm_uninit_stage2_mmu(struct kvm *kvm)
>>  {
>> -	kvm_free_stage2_pgd(&kvm->arch.mmu);
>> +	if (kvm_vm_is_realm(kvm))
>> +		kvm_realm_uninit_stage2(&kvm->arch.mmu);
>> +	else
>> +		kvm_free_stage2_pgd(&kvm->arch.mmu);
>>  	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
>>  }
> 
> [Severity: High]
> Does skipping kvm_free_stage2_pgd() here leak mmu->pgt, the root stage-2 PGD
> pages (mmu->pgt->pgd), and the per-CPU mmu->last_vcpu_ran allocation when a
> Realm VM is destroyed before the Realm is created in the RMM?
> 
> During VM creation, kvm_arch_init_vm() calls kvm_init_stage2_mmu() while the
> Realm state is still REALM_STATE_NONE. If userspace closes the VM file
> descriptor without creating the Realm in the RMM, kvm_destroy_realm() takes
> its early return before reaching kvm_free_stage2_pgd(&kvm->arch.mmu):
> 
> arch/arm64/kvm/rmi.c:kvm_destroy_realm() {
> 	...
> 	if (!kvm_realm_is_created(kvm)) {
> 		kfree(realm->sro);
> 		realm->sro = NULL;
> 		return;
> 	}
> 	...
> 	kvm_free_stage2_pgd(&kvm->arch.mmu);
> }
> 
> Similarly, if kvm_init_nested() or kvm_init_realm() fails in
> kvm_arch_init_vm() after kvm_init_stage2_mmu() succeeds:
> 
> arch/arm64/kvm/arm.c:kvm_arch_init_vm() {
> 	...
> 	ret = kvm_init_nested(kvm);
> 	if (ret)
> 		goto err_uninit_mmu;
> 
> 	if (kvm_vm_is_realm(kvm)) {
> 		ret = kvm_init_realm(kvm);
> 		if (ret)
> 			goto err_uninit_mmu;
> 	}
> 
> 	return 0;
> 
> err_uninit_mmu:
> 	kvm_uninit_stage2_mmu(kvm);
> 	return ret;
> }
> 
> the error path only calls kvm_uninit_stage2_mmu(kvm) and never calls
> kvm_destroy_realm(), leaking the stage-2 PGD allocations there as well.

Here I think using kvm_realm_is_created() make sense. Once the realm is
up we want to "skip" kvm_free_stage2_pgd() because we need the RMM to
tear things down first.

>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index 45ecbaa467d1d..f190143b33ba5 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
> 
> [ ... ]
> 
>> @@ -21,11 +29,180 @@ u32 kvm_rmm_ipa_limit(void)
>>  	return u64_get_bits(rmi_feat_reg(0), RMI_FEATURE_REGISTER_0_S2SZ);
>>  }
>>  
>> +static int get_start_level(struct realm *realm)
>> +{
>> +	return 4 - stage2_pgtable_levels(realm->ia_bits);
>> +}
> 
> [Severity: High]
> Can get_start_level() return a level that mismatches the stage-2 page table
> configuration on 64KB page kernels and cause realm_destroy_rtts() to fail?
> 
> When kvm_init_ipa_range() configures mmu->vtcr via kvm_get_vtcr(), the
> number of stage-2 levels is clamped to at least 2:
> 
> arch/arm64/kvm/hyp/pgtable.c:kvm_get_vtcr() {
> 	...
> 	lvls = stage2_pgtable_levels(phys_shift);
> 	if (lvls < 2)
> 		lvls = 2;
> 	...
> }
> 
> Under CONFIG_ARM64_64K_PAGES with a 32-bit or 33-bit IPA,
> stage2_pgtable_levels(realm->ia_bits) evaluates to 1, so get_start_level()
> returns 3 (KVM_PGTABLE_LAST_LEVEL) instead of 2.
> 
> When kvm_destroy_realm() -> realm_destroy_rtts() ->
> realm_tear_down_rtt_range() then calls:
> 
> 	realm_tear_down_rtt_level(realm, get_start_level(realm) + 1,
> 				  start, end);
> 
> it passes level 4 into realm_tear_down_rtt_level(), hitting
> WARN_ON(level > KVM_PGTABLE_LAST_LEVEL) and returning -EINVAL. That in turn
> causes kvm_destroy_realm() to warn and return early, leaking the delegated
> RD, RTT granules, root stage-2 PGD pages, and realm->sro.

Good spot - yes get_start_level() should do the same clamping to a min of 2.

>> +
>> +static void free_rtt(phys_addr_t phys)
>> +{
>> +	if (rmi_free_delegated_page(phys))
>> +		return;
>> +
>> +	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
>> +}
> 
> [Severity: High]
> Does calling kvm_account_pgtable_pages() after rmi_free_delegated_page()
> access the page after it has already been freed and uncharged from its
> memcg?
> 
> In drivers/firmware/arm_rmm/rmi.c, rmi_free_delegated_page() undelegates the
> granule and immediately frees the page back to the page allocator:
> 
> drivers/firmware/arm_rmm/rmi.c:rmi_free_delegated_page() {
> 	if (WARN_ON_ONCE(rmi_undelegate_page(phys))) {
> 		/* Undelegate failed: leak the page */
> 		return -EBUSY;
> 	}
> 
> 	free_page((unsigned long)phys_to_virt(phys));
> 
> 	return 0;
> }
> 
> Because free_page() clears page->memcg_data in __free_pages_prepare() and
> releases the page for reallocation, the subsequent call to
> kvm_account_pgtable_pages(phys_to_virt(phys), -1) ->
> mod_lruvec_page_state() operates on a freed struct page and sees a NULL
> folio_memcg(), failing to decrement the memory cgroup's
> NR_SECONDARY_PAGETABLE counter (or racing with a concurrent reallocation of
> that page).
> 
> Should kvm_account_pgtable_pages(phys_to_virt(phys), -1) be called before
> freeing the page, matching kvm_s2_free_pages_exact() and kvm_s2_put_page()
> in arch/arm64/kvm/mmu.c?
> 

Yes. The issue here is that rmi_free_delegated_page() could fail and
then the accounting is wrong. I guess we can decrement the account,
attempt the free and increment the account again if it fails.

        kvm_account_pgtable_pages(phys_to_virt(phys), -1);
        if (rmi_free_delegated_page(phys))
                kvm_account_pgtable_pages(phys_to_virt(phys), 1);

Thanks,
Steve

