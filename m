Return-Path: <SRS0=Sq8/=CS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D857BC43461
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 17:12:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1E59B21919
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 17:12:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uh9RRLGt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E59B21919
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DC694B24C;
	Wed,  9 Sep 2020 13:12:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dXTmLbR08uhB; Wed,  9 Sep 2020 13:12:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F4824B306;
	Wed,  9 Sep 2020 13:12:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2414D4B306
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 13:12:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2B3I2QaMjw+A for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Sep 2020 13:12:32 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B16354B304
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 13:12:32 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 779AB206E6;
 Wed,  9 Sep 2020 17:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599671551;
 bh=v0g3QnFoVJU7n7iPmuQiCcTtp7sU8H7GnpEBbQ5WMxE=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=Uh9RRLGtjjmyuwrqevOGc27Dwsri1dmOasiQsvBLdrl8suIVeGP9wWc2nUC13P7yP
 HtWoO926E/qEzewMRqW4pyzI2mekH9gVFzRjOaQiREPmu3LvpnK5HaaEHIpIVOq+zD
 in6qb1xaj3fcD1BYcUlDB/2y/aHx3vUDYlKdYcnA=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kG3e1-00AQVA-CE; Wed, 09 Sep 2020 18:12:29 +0100
MIME-Version: 1.0
Date: Wed, 09 Sep 2020 18:12:29 +0100
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v4 17/21] KVM: arm64: Convert user_mem_abort() to generic
 page-table API
In-Reply-To: <2ae77a66-9cc4-f4e1-9e98-a50d5891cf20@arm.com>
References: <20200907152344.12978-1-will@kernel.org>
 <20200907152344.12978-18-will@kernel.org>
 <2ae77a66-9cc4-f4e1-9e98-a50d5891cf20@arm.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <c2e5e055251db637327f81da452cea2c@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, qperret@google.com, james.morse@arm.com,
 suzuki.poulose@arm.com, catalin.marinas@arm.com, gshan@redhat.com,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Alex,

On 2020-09-09 15:20, Alexandru Elisei wrote:
> Hi Will,
> 
> On 9/7/20 4:23 PM, Will Deacon wrote:
>> Convert user_mem_abort() to call kvm_pgtable_stage2_relax_perms() when
>> handling a stage-2 permission fault and kvm_pgtable_stage2_map() when
>> handling a stage-2 translation fault, rather than walking the 
>> page-table
>> manually.
>> 
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Quentin Perret <qperret@google.com>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> Signed-off-by: Will Deacon <will@kernel.org>
>> ---
>>  arch/arm64/kvm/mmu.c | 124 
>> +++++++++++++++----------------------------
>>  1 file changed, 44 insertions(+), 80 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 0af48f35c8dd..dc923e873dad 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1496,18 +1496,19 @@ static int user_mem_abort(struct kvm_vcpu 
>> *vcpu, phys_addr_t fault_ipa,
>>  {
>>  	int ret;
>>  	bool write_fault, writable, force_pte = false;
>> -	bool exec_fault, needs_exec;
>> +	bool exec_fault;
>> +	bool device = false;
>>  	unsigned long mmu_seq;
>> -	gfn_t gfn = fault_ipa >> PAGE_SHIFT;
>>  	struct kvm *kvm = vcpu->kvm;
>>  	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
>>  	struct vm_area_struct *vma;
>>  	short vma_shift;
>> +	gfn_t gfn;
>>  	kvm_pfn_t pfn;
>> -	pgprot_t mem_type = PAGE_S2;
>>  	bool logging_active = memslot_is_logging(memslot);
>> -	unsigned long vma_pagesize, flags = 0;
>> -	struct kvm_s2_mmu *mmu = vcpu->arch.hw_mmu;
>> +	unsigned long vma_pagesize;
>> +	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>> +	struct kvm_pgtable *pgt;
>> 
>>  	write_fault = kvm_is_write_fault(vcpu);
>>  	exec_fault = kvm_vcpu_trap_is_iabt(vcpu);
>> @@ -1540,22 +1541,24 @@ static int user_mem_abort(struct kvm_vcpu 
>> *vcpu, phys_addr_t fault_ipa,
>>  		vma_pagesize = PAGE_SIZE;
>>  	}
>> 
>> -	/*
>> -	 * The stage2 has a minimum of 2 level table (For arm64 see
>> -	 * kvm_arm_setup_stage2()). Hence, we are guaranteed that we can
>> -	 * use PMD_SIZE huge mappings (even when the PMD is folded into 
>> PGD).
>> -	 * As for PUD huge maps, we must make sure that we have at least
>> -	 * 3 levels, i.e, PMD is not folded.
>> -	 */
>> -	if (vma_pagesize == PMD_SIZE ||
>> -	    (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm)))
>> -		gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
>> +	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
>> +		fault_ipa &= huge_page_mask(hstate_vma(vma));
> 
> This looks correct to me - if !kvm_stage2_has_pmd(), then PMD is folded 
> onto PUD
> and PGD, and PMD_SIZE == PUD_SIZE. Also I like the fact that we update
> gfn **and**
> fault_ipa, the previous version updated only gfn, which made gfn !=
> (fault_ipa >>
> PAGE_SHIFT).
> 
>> +
>> +	gfn = fault_ipa >> PAGE_SHIFT;
>>  	mmap_read_unlock(current->mm);
>> 
>> -	/* We need minimum second+third level pages */
>> -	ret = kvm_mmu_topup_memory_cache(memcache, 
>> kvm_mmu_cache_min_pages(kvm));
>> -	if (ret)
>> -		return ret;
>> +	/*
>> +	 * Permission faults just need to update the existing leaf entry,
>> +	 * and so normally don't require allocations from the memcache. The
>> +	 * only exception to this is when dirty logging is enabled at 
>> runtime
>> +	 * and a write fault needs to collapse a block entry into a table.
>> +	 */
>> +	if (fault_status != FSC_PERM || (logging_active && write_fault)) {
>> +		ret = kvm_mmu_topup_memory_cache(memcache,
>> +						 kvm_mmu_cache_min_pages(kvm));
>> +		if (ret)
>> +			return ret;
>> +	}
> 
> I'm not 100% sure about this.
> 
> I don't think we gain much over the previous code - if we had allocated 
> cache
> objects which we hadn't used, we would have used them next time 
> user_mem_abort()
> is called (kvm_mmu_topup_memory_cache() checks if we have the required 
> number of
> objects in the cache and returns early).
> 
> I'm not sure the condition is entirely correct either - if stage 2 
> already has a
> mapping for the IPA and we only need to set write permissions, 
> according to the
> condition above we still try to topup the cache, even though we don't 
> strictly
> need to.

That's because if you are logging, you may have to split an existing 
block
mapping and map a single page instead. This requires (at least) an extra
level, and that's why you need to top-up the cache in this case.

> 
>> 
>>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>>  	/*
>> @@ -1578,28 +1581,20 @@ static int user_mem_abort(struct kvm_vcpu 
>> *vcpu, phys_addr_t fault_ipa,
>>  		return -EFAULT;
>> 
>>  	if (kvm_is_device_pfn(pfn)) {
>> -		mem_type = PAGE_S2_DEVICE;
>> -		flags |= KVM_S2PTE_FLAG_IS_IOMAP;
>> -	} else if (logging_active) {
>> -		/*
>> -		 * Faults on pages in a memslot with logging enabled
>> -		 * should not be mapped with huge pages (it introduces churn
>> -		 * and performance degradation), so force a pte mapping.
>> -		 */
>> -		flags |= KVM_S2_FLAG_LOGGING_ACTIVE;
>> -
>> +		device = true;
>> +	} else if (logging_active && !write_fault) {
>>  		/*
>>  		 * Only actually map the page as writable if this was a write
>>  		 * fault.
>>  		 */
>> -		if (!write_fault)
>> -			writable = false;
>> +		writable = false;
>>  	}
>> 
>> -	if (exec_fault && is_iomap(flags))
>> +	if (exec_fault && device)
>>  		return -ENOEXEC;
>> 
>>  	spin_lock(&kvm->mmu_lock);
>> +	pgt = vcpu->arch.hw_mmu->pgt;
>>  	if (mmu_notifier_retry(kvm, mmu_seq))
>>  		goto out_unlock;
>> 
>> @@ -1610,62 +1605,31 @@ static int user_mem_abort(struct kvm_vcpu 
>> *vcpu, phys_addr_t fault_ipa,
>>  	if (vma_pagesize == PAGE_SIZE && !force_pte)
>>  		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
>>  							   &pfn, &fault_ipa);
>> -	if (writable)
>> +	if (writable) {
>> +		prot |= KVM_PGTABLE_PROT_W;
>>  		kvm_set_pfn_dirty(pfn);
>> +		mark_page_dirty(kvm, gfn);
> 
> The previous code called mark_page_dirty() only if the vma_pagesize == 
> PAGE_SIZE
> (and writable was true, obviously). Is this supposed to fix a bug?

No, this is actually introducing one. mark_page_dirty() checks that 
there is an
associated bitmap, and thus only happens when writing to a single page, 
but we
shouldn't do it for R/O memslots, which the current code avoids. It 
should be
guarded by logging_active.

> 
>> +	}
>> 
>> -	if (fault_status != FSC_PERM && !is_iomap(flags))
>> +	if (fault_status != FSC_PERM && !device)
>>  		clean_dcache_guest_page(pfn, vma_pagesize);
>> 
>> -	if (exec_fault)
>> +	if (exec_fault) {
>> +		prot |= KVM_PGTABLE_PROT_X;
>>  		invalidate_icache_guest_page(pfn, vma_pagesize);
>> +	}
>> 
>> -	/*
>> -	 * If we took an execution fault we have made the
>> -	 * icache/dcache coherent above and should now let the s2
>> -	 * mapping be executable.
>> -	 *
>> -	 * Write faults (!exec_fault && FSC_PERM) are orthogonal to
>> -	 * execute permissions, and we preserve whatever we have.
>> -	 */
>> -	needs_exec = exec_fault ||
>> -		(fault_status == FSC_PERM &&
>> -		 stage2_is_exec(mmu, fault_ipa, vma_pagesize));
>> -
>> -	if (vma_pagesize == PUD_SIZE) {
>> -		pud_t new_pud = kvm_pfn_pud(pfn, mem_type);
>> -
>> -		new_pud = kvm_pud_mkhuge(new_pud);
>> -		if (writable)
>> -			new_pud = kvm_s2pud_mkwrite(new_pud);
>> -
>> -		if (needs_exec)
>> -			new_pud = kvm_s2pud_mkexec(new_pud);
>> -
>> -		ret = stage2_set_pud_huge(mmu, memcache, fault_ipa, &new_pud);
>> -	} else if (vma_pagesize == PMD_SIZE) {
>> -		pmd_t new_pmd = kvm_pfn_pmd(pfn, mem_type);
>> -
>> -		new_pmd = kvm_pmd_mkhuge(new_pmd);
>> -
>> -		if (writable)
>> -			new_pmd = kvm_s2pmd_mkwrite(new_pmd);
>> -
>> -		if (needs_exec)
>> -			new_pmd = kvm_s2pmd_mkexec(new_pmd);
>> +	if (device)
>> +		prot |= KVM_PGTABLE_PROT_DEVICE;
>> +	else if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC))
>> +		prot |= KVM_PGTABLE_PROT_X;
>> 
>> -		ret = stage2_set_pmd_huge(mmu, memcache, fault_ipa, &new_pmd);
>> +	if (fault_status == FSC_PERM && !(logging_active && writable)) {
> 
> I don't understand the second part of the condition (!(logging_active 
> &&
> writable)). With logging active, when we get a fault because of a
> missing stage 2
> entry, we map the IPA as read-only at stage 2. If I understand this 
> code
> correctly, when the guest then tries to write to the same IPA, writable 
> == true
> and we map the IPA again instead of relaxing the permissions. Why is 
> that?

See my reply above: logging means potentially adding a new level, so we
treat it as a new mapping altogether (break the block mapping, TLBI, 
install
the new mapping one level down).

All the other cases are happily handled by just relaxing the 
permissions.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
