Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 033872264CA
	for <kvmarm@lists.linux.dev>; Thu, 12 Feb 2026 10:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770892648; cv=none; b=Yc1V9J2fEDmPXBHJ9J+VkThejzVc4JzEG/P6YwJMRQ3e2SCL20N8rStgw9VRWNFwSuYDb+lbVlIkI5vS24+b92HESGSWLVHBXnKeox6tOjjZpxCw7aK/pYFK0tjVnE8xUOn4QZ27ZlsGV0m1AOImMYWe6nWdlkcy4RSvATwRQQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770892648; c=relaxed/simple;
	bh=4Johd8JfA6XoYWEldlA+wx42tVV46l7P+ou4nWAcVhI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nNbUncMAM7BkE5CdZosOiVJRpdTlqYVJ1b/r5u8yB3jNNHpflqGMLMnaUIkMJmmIeLH9FxjMX6W8R7f4mnouix3FS+ywdTqkcDu0WGp5UcIwPGZ20qlnXwKyoFbJGe/ixCB0rdJrQZZLFBQBnN47im76ZzQMZmtVvkPIXZCsYGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F3CE8339;
	Thu, 12 Feb 2026 02:37:19 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 286023F632;
	Thu, 12 Feb 2026 02:37:22 -0800 (PST)
Date: Thu, 12 Feb 2026 10:37:19 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 14/35] KVM: arm64: Handle aborts from protected VMs
Message-ID: <aY2tX6V0pCqwGth5@raptor>
References: <20260119124629.2563-1-will@kernel.org>
 <20260119124629.2563-15-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119124629.2563-15-will@kernel.org>

Hi Will,

On Mon, Jan 19, 2026 at 12:46:07PM +0000, Will Deacon wrote:
> Introduce a new abort handler for resolving stage-2 page faults from
> protected VMs by pinning and donating anonymous memory. This is
> considerably simpler than the infamous user_mem_abort() as we only have
> to deal with translation faults at the pte level.
> 
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/mmu.c | 89 ++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 81 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index a23a4b7f108c..b21a5bf3d104 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1641,6 +1641,74 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	return ret != -EAGAIN ? ret : 0;
>  }
>  
> +static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> +		struct kvm_memory_slot *memslot, unsigned long hva)
> +{
> +	unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
> +	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> +	struct mm_struct *mm = current->mm;
> +	struct kvm *kvm = vcpu->kvm;
> +	void *hyp_memcache;
> +	struct page *page;
> +	int ret;
> +
> +	ret = prepare_mmu_memcache(vcpu, true, &hyp_memcache);
> +	if (ret)
> +		return -ENOMEM;
> +
> +	ret = account_locked_vm(mm, 1, true);
> +	if (ret)
> +		return ret;
> +
> +	mmap_read_lock(mm);
> +	ret = pin_user_pages(hva, 1, flags, &page);
> +	mmap_read_unlock(mm);

If the page is part of a large folio, the entire folio gets pinned here, not
just the page returned by pin_user_pages(). Do you reckon that should be
considered when calling account_locked_vm()?

> +
> +	if (ret == -EHWPOISON) {
> +		kvm_send_hwpoison_signal(hva, PAGE_SHIFT);
> +		ret = 0;
> +		goto dec_account;
> +	} else if (ret != 1) {
> +		ret = -EFAULT;
> +		goto dec_account;
> +	} else if (!folio_test_swapbacked(page_folio(page))) {
> +		/*
> +		 * We really can't deal with page-cache pages returned by GUP
> +		 * because (a) we may trigger writeback of a page for which we
> +		 * no longer have access and (b) page_mkclean() won't find the
> +		 * stage-2 mapping in the rmap so we can get out-of-whack with
> +		 * the filesystem when marking the page dirty during unpinning
> +		 * (see cc5095747edf ("ext4: don't BUG if someone dirty pages
> +		 * without asking ext4 first")).

I've been trying to wrap my head around this. Would you mind providing a few
more hints about what the issue is? I'm sure the approach is correct, it's
likely just me not being familiar with the code.

> +		 *
> +		 * Ideally we'd just restrict ourselves to anonymous pages, but
> +		 * we also want to allow memfd (i.e. shmem) pages, so check for
> +		 * pages backed by swap in the knowledge that the GUP pin will
> +		 * prevent try_to_unmap() from succeeding.
> +		 */
> +		ret = -EIO;
> +		goto unpin;
> +	}
> +
> +	write_lock(&kvm->mmu_lock);
> +	ret = pkvm_pgtable_stage2_map(pgt, fault_ipa, PAGE_SIZE,
> +				      page_to_phys(page), KVM_PGTABLE_PROT_RWX,
> +				      hyp_memcache, 0);
> +	write_unlock(&kvm->mmu_lock);
> +	if (ret) {
> +		if (ret == -EAGAIN)
> +			ret = 0;
> +		goto unpin;
> +	}

This looks correct to me, there's no need to check for the notifier sequence
number if the MMU notifiers are ignored. And concurrent faults on the same page
are handled by treating -EAGAIN as success.

> +
> +	return 0;
> +unpin:
> +	unpin_user_pages(&page, 1);
> +dec_account:
> +	account_locked_vm(mm, 1, false);
> +	return ret;
> +}
> +
>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			  struct kvm_s2_trans *nested,
>  			  struct kvm_memory_slot *memslot, unsigned long hva,
> @@ -2190,15 +2258,20 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  		goto out_unlock;
>  	}
>  
> -	VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
> -			!write_fault && !kvm_vcpu_trap_is_exec_fault(vcpu));
> +	if (kvm_vm_is_protected(vcpu->kvm)) {
> +		ret = pkvm_mem_abort(vcpu, fault_ipa, memslot, hva);

I guess the reason this comes after handling an access fault is because you want
the WARN_ON() to trigger in pkvm_pgtable_stage2_mkyoung().

Thanks,
Alex

> +	} else {
> +		VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
> +				!write_fault &&
> +				!kvm_vcpu_trap_is_exec_fault(vcpu));
>  
> -	if (kvm_slot_has_gmem(memslot))
> -		ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
> -				 esr_fsc_is_permission_fault(esr));
> -	else
> -		ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
> -				     esr_fsc_is_permission_fault(esr));
> +		if (kvm_slot_has_gmem(memslot))
> +			ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
> +					 esr_fsc_is_permission_fault(esr));
> +		else
> +			ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
> +					     esr_fsc_is_permission_fault(esr));
> +	}
>  	if (ret == 0)
>  		ret = 1;
>  out:
> -- 
> 2.52.0.457.g6b5491de43-goog
> 
> 
