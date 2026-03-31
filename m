Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BFE4279798
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 03:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774928710; cv=none; b=e+zlZ5mhWeujQddC9MBe9TwdwUiP6WDK9t61VrdXA8W8ZUz8m8XSFbQQALieTvokWYmW7Ea0Us33jMVqIZ2ivPLZt8e5XXXspnbPVBQzpqtGriCSjO7cMiCktvtSpq6ckv7yIlsOSSakkS8M3ERhpVvnfimXAu8AfdNJiSAsi20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774928710; c=relaxed/simple;
	bh=kRCgOKiEXBtkP2zut1iIoXGIx3BXzq6a1jI7lDIRJ64=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZbYnRC2HSif3vKx4NHOF/kl+iAj7Ep+zPXCtmZp6sc6qSJCp1Hshverq4WvckMlM9dXTBIjx0kLw3yeHmx7TfASesWQxBsH5MoGnvcY9K5e5xy98IQMfB63jLAHBeL8PHUdb0hdAgA+TFGmJLzT13xEEFlVg8vQTkDklMOPTfOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Z9vq5dxB; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Z9vq5dxB"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8E3011BCA;
	Mon, 30 Mar 2026 20:45:01 -0700 (PDT)
Received: from [10.57.18.211] (unknown [10.57.18.211])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE2C03F641;
	Mon, 30 Mar 2026 20:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774928707; bh=kRCgOKiEXBtkP2zut1iIoXGIx3BXzq6a1jI7lDIRJ64=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Z9vq5dxBTJkJGlqvBPfGjLBZdsRSG9tEs4uJmTVQPhJI6EWNhGlqW7DVsfqrFIcnD
	 0XoThGTo4iEL6kAq2UH/Ly4obtJwK1X/2qefLaQLH6P9eXF/OaynOMacmrVYEQfQ+f
	 2s/5EIkJ4xhufPBamFMfQ48enWQ67BdXBPGrHxU8=
Message-ID: <711ba4de-f545-4a7a-a027-6d5e46fdcb5e@arm.com>
Date: Tue, 31 Mar 2026 09:15:00 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/30] KVM: arm64: Extract page table mapping in
 user_mem_abort()
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
 Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>
References: <20260327113618.4051534-1-maz@kernel.org>
 <20260327113618.4051534-7-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260327113618.4051534-7-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/03/26 5:05 PM, Marc Zyngier wrote:
> From: Fuad Tabba <tabba@google.com>
> 
> Extract the code responsible for locking the KVM MMU and mapping the PFN
> into the stage-2 page tables into a new helper, kvm_s2_fault_map().
> 
> This helper manages the kvm_fault_lock, checks for MMU invalidation
> retries, attempts to adjust for transparent huge pages (THP), handles
> MTE sanitization if needed, and finally maps or relaxes permissions on
> the stage-2 entries.
> 
> With this change, the main user_mem_abort() function is now a sequential
> dispatcher that delegates to specialized helper functions.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/kvm/mmu.c | 128 +++++++++++++++++++++++--------------------
>  1 file changed, 68 insertions(+), 60 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d1ffdce18631a..164f1160ea33d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1892,68 +1892,13 @@ static int kvm_s2_fault_compute_prot(struct kvm_s2_fault *fault)
>  	return 0;
>  }
>  
> -static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> -			  struct kvm_s2_trans *nested,
> -			  struct kvm_memory_slot *memslot, unsigned long hva,
> -			  bool fault_is_perm)
> +static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
>  {
> -	int ret = 0;
> -	struct kvm_s2_fault fault_data = {
> -		.vcpu = vcpu,
> -		.fault_ipa = fault_ipa,
> -		.nested = nested,
> -		.memslot = memslot,
> -		.hva = hva,
> -		.fault_is_perm = fault_is_perm,
> -		.ipa = fault_ipa,
> -		.logging_active = memslot_is_logging(memslot),
> -		.force_pte = memslot_is_logging(memslot),
> -		.s2_force_noncacheable = false,
> -		.vfio_allow_any_uc = false,
> -		.prot = KVM_PGTABLE_PROT_R,
> -	};
> -	struct kvm_s2_fault *fault = &fault_data;
> -	struct kvm *kvm = vcpu->kvm;
> -	void *memcache;
> +	struct kvm *kvm = fault->vcpu->kvm;
>  	struct kvm_pgtable *pgt;
> +	int ret;
>  	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
>  
> -	if (fault->fault_is_perm)
> -		fault->fault_granule = kvm_vcpu_trap_get_perm_fault_granule(fault->vcpu);
> -	fault->write_fault = kvm_is_write_fault(fault->vcpu);
> -	fault->exec_fault = kvm_vcpu_trap_is_exec_fault(fault->vcpu);
> -	VM_WARN_ON_ONCE(fault->write_fault && fault->exec_fault);
> -
> -	/*
> -	 * Permission faults just need to update the existing leaf entry,
> -	 * and so normally don't require allocations from the memcache. The
> -	 * only exception to this is when dirty logging is enabled at runtime
> -	 * and a write fault needs to collapse a block entry into a table.
> -	 */
> -	fault->topup_memcache = !fault->fault_is_perm ||
> -				(fault->logging_active && fault->write_fault);
> -	ret = prepare_mmu_memcache(fault->vcpu, fault->topup_memcache, &memcache);
> -	if (ret)
> -		return ret;
> -
> -	/*
> -	 * Let's check if we will get back a huge page backed by hugetlbfs, or
> -	 * get block mapping for device MMIO region.
> -	 */
> -	ret = kvm_s2_fault_pin_pfn(fault);
> -	if (ret != 1)
> -		return ret;
> -
> -	ret = 0;
> -
> -	ret = kvm_s2_fault_compute_prot(fault);
> -	if (ret == 1) {
> -		ret = 1; /* fault injected */
> -		goto out_put_page;
> -	}
> -	if (ret)
> -		goto out_put_page;
> -
>  	kvm_fault_lock(kvm);
>  	pgt = fault->vcpu->arch.hw_mmu->pgt;
>  	if (mmu_invalidate_retry(kvm, fault->mmu_seq)) {
> @@ -2001,8 +1946,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		 * PTE, which will be preserved.
>  		 */
>  		fault->prot &= ~KVM_NV_GUEST_MAP_SZ;
> -		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, fault->fault_ipa, fault->prot,
> -								 flags);
> +		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, fault->fault_ipa,
> +								 fault->prot, flags);
>  	} else {
>  		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault->fault_ipa, fault->vma_pagesize,
>  							 __pfn_to_phys(fault->pfn), fault->prot,
> @@ -2018,6 +1963,69 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		mark_page_dirty_in_slot(kvm, fault->memslot, fault->gfn);
>  
>  	return ret != -EAGAIN ? ret : 0;
> +}
> +
> +static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> +			  struct kvm_s2_trans *nested,
> +			  struct kvm_memory_slot *memslot, unsigned long hva,
> +			  bool fault_is_perm)
> +{
> +	int ret = 0;
> +	struct kvm_s2_fault fault_data = {
> +		.vcpu = vcpu,
> +		.fault_ipa = fault_ipa,
> +		.nested = nested,
> +		.memslot = memslot,
> +		.hva = hva,
> +		.fault_is_perm = fault_is_perm,
> +		.ipa = fault_ipa,
> +		.logging_active = memslot_is_logging(memslot),
> +		.force_pte = memslot_is_logging(memslot),
> +		.s2_force_noncacheable = false,
> +		.vfio_allow_any_uc = false,
> +		.prot = KVM_PGTABLE_PROT_R,
> +	};
> +	struct kvm_s2_fault *fault = &fault_data;
> +	void *memcache;
> +
> +	if (fault->fault_is_perm)
> +		fault->fault_granule = kvm_vcpu_trap_get_perm_fault_granule(fault->vcpu);
> +	fault->write_fault = kvm_is_write_fault(fault->vcpu);
> +	fault->exec_fault = kvm_vcpu_trap_is_exec_fault(fault->vcpu);
> +	VM_WARN_ON_ONCE(fault->write_fault && fault->exec_fault);
> +
> +	/*
> +	 * Permission faults just need to update the existing leaf entry,
> +	 * and so normally don't require allocations from the memcache. The
> +	 * only exception to this is when dirty logging is enabled at runtime
> +	 * and a write fault needs to collapse a block entry into a table.
> +	 */
> +	fault->topup_memcache = !fault->fault_is_perm ||
> +				(fault->logging_active && fault->write_fault);
> +	ret = prepare_mmu_memcache(fault->vcpu, fault->topup_memcache, &memcache);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Let's check if we will get back a huge page backed by hugetlbfs, or
> +	 * get block mapping for device MMIO region.
> +	 */
> +	ret = kvm_s2_fault_pin_pfn(fault);
> +	if (ret != 1)
> +		return ret;
> +
> +	ret = 0;
> +
> +	ret = kvm_s2_fault_compute_prot(fault);
> +	if (ret == 1) {
> +		ret = 1; /* fault injected */
> +		goto out_put_page;
> +	}
> +	if (ret)
> +		goto out_put_page;
> +
> +	ret = kvm_s2_fault_map(fault, memcache);
> +	return ret;
>  
>  out_put_page:
>  	kvm_release_page_unused(fault->page);

