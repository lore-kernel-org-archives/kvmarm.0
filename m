Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB6DE78F3E
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 04:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774845199; cv=none; b=R6sElzJqA+/HdDzBbeWKjlGAPuySPqLMWcm14J3sWpHodvuXjk+adkXjiDReujAe+56Dj+V+dHGwxgff/yPOe9bFLHlmQSMr/wGY52jltpOUVoOjDpwx9z65qAUCntbxXJ41OXxcF1GhHtCbv0gtZ3aKhxmhoqYHRkixal7CbB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774845199; c=relaxed/simple;
	bh=1p2nxp7zPmbLPGIYzAgHmPQw4RKW7Te37pm+Fj7BROU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qJcjfv58kfHwPRZvHgjQpGR3tjCrwBu0/hviOvy2XaH6mlw5R7GT4l43BVG3azZkCzjmzyPWEaYy16N8H0MfXhyUGoKHumhKHOM5YXX5rx8QzFyMMG1D8Hvxgp/PnGWiwTCnE2efuZ6+2TFyvf0nkIQs7np+LlvjyLZDzHh5LxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ghNaBF+k; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ghNaBF+k"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6BF051C2B;
	Sun, 29 Mar 2026 21:33:11 -0700 (PDT)
Received: from [10.164.18.48] (unknown [10.164.18.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 60A5D3F915;
	Sun, 29 Mar 2026 21:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774845197; bh=1p2nxp7zPmbLPGIYzAgHmPQw4RKW7Te37pm+Fj7BROU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ghNaBF+kXm2UZ2wflipgYKvuu6yI+wUHgaSlATiiAZ9YEewZG18eg0IJqCB2IMvZp
	 UuhwMXGoAns1BlVh0S/NNHre87OuKPgfTwSIF57sV2XAR2I07HFEOHMKluphezyQCq
	 rKJWFhhEMzIV8Am0gbHMExdNEjVRGsk0OOoSqOmM=
Message-ID: <e9f72d56-86f5-443b-9d82-5c52b13efbf2@arm.com>
Date: Mon, 30 Mar 2026 10:03:11 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/30] KVM: arm64: Extract PFN resolution in
 user_mem_abort()
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
 Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>
References: <20260327113618.4051534-1-maz@kernel.org>
 <20260327113618.4051534-4-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260327113618.4051534-4-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/03/26 5:05 PM, Marc Zyngier wrote:
> From: Fuad Tabba <tabba@google.com>
> 
> Extract the section of code responsible for pinning the physical page
> frame number (PFN) backing the faulting IPA into a new helper,
> kvm_s2_fault_pin_pfn().
> 
> This helper encapsulates the critical section where the mmap_read_lock
> is held, the VMA is looked up, the mmu invalidate sequence is sampled,
> and the PFN is ultimately resolved via __kvm_faultin_pfn(). It also
> handles the early exits for hardware poisoned pages and noslot PFNs.
> 
> By isolating this region, we can begin to organize the state variables
> required for PFN resolution into the kvm_s2_fault struct, clearing out
> a significant amount of local variable clutter from user_mem_abort().
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/kvm/mmu.c | 105 ++++++++++++++++++++++++-------------------
>  1 file changed, 59 insertions(+), 46 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index b366bde15a429..5079a58b65b14 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1740,55 +1740,11 @@ struct kvm_s2_fault {
>  	vm_flags_t vm_flags;
>  };
>  
> -static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> -			  struct kvm_s2_trans *nested,
> -			  struct kvm_memory_slot *memslot, unsigned long hva,
> -			  bool fault_is_perm)
> +static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
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
>  	struct vm_area_struct *vma;
> -	void *memcache;
> -	struct kvm_pgtable *pgt;
> -	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
> -
> -	if (fault->fault_is_perm)
> -		fault->fault_granule = kvm_vcpu_trap_get_perm_fault_granule(fault->vcpu);
> -	fault->write_fault = kvm_is_write_fault(fault->vcpu);
> -	fault->exec_fault = kvm_vcpu_trap_is_exec_fault(fault->vcpu);
> -	VM_WARN_ON_ONCE(fault->write_fault && fault->exec_fault);
> +	struct kvm *kvm = fault->vcpu->kvm;
>  
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
>  	mmap_read_lock(current->mm);
>  	vma = vma_lookup(current->mm, fault->hva);
>  	if (unlikely(!vma)) {
> @@ -1842,6 +1798,63 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	if (is_error_noslot_pfn(fault->pfn))
>  		return -EFAULT;
>  
> +	return 1;
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
> +	struct kvm *kvm = vcpu->kvm;
> +	void *memcache;
> +	struct kvm_pgtable *pgt;
> +	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
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
>  	/*
>  	 * Check if this is non-struct page memory PFN, and cannot support
>  	 * CMOs. It could potentially be unsafe to access as cacheable.

