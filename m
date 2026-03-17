Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A669D3EB7EF
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 15:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773760045; cv=none; b=A86o3pUKd1V37RI/B3xUNowEflrXO/NDK5MGMCfyce/Hsnj5x6nN/M5qv6tzG9u+AmYP2XQM3XlCLTwcmchQfXvsj+XLkSPulHSVzdkbLpjDP0ODAkAobpnYo2mG5/6wXnzxXbQOfbNaeOb5u0DDKm142Zix14rUsE4d1RFx9iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773760045; c=relaxed/simple;
	bh=X86NAYcSKjoY3jgQwc3wqUxd4UAWPN0ewDHMBpqG4dA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YLnLc3ts5bsd3zUeCuwwxwNBQWSydBmO55kr1bp8ru2Frci4JqxQCGjHP1PfxFe3WJxcjR8bWyWq+42gB0KBSrZye0TBo8NR0maAAo4DeCGKgVGgoLNkVXMSYqX+qbdaGjAto9I7CKhBZkhAq7d5TPuLaC4GsdWtKuDR3EkIQ3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F34A91477;
	Tue, 17 Mar 2026 08:07:16 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9CAC43F778;
	Tue, 17 Mar 2026 08:07:21 -0700 (PDT)
Date: Tue, 17 Mar 2026 15:07:16 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	qperret@google.com, vdonnefort@google.com
Subject: Re: [PATCH v1 01/13] KVM: arm64: Extract VMA size resolution in
 user_mem_abort()
Message-ID: <20260317150716.GA3808327@e124191.cambridge.arm.com>
References: <20260306140232.2193802-1-tabba@google.com>
 <20260306140232.2193802-2-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306140232.2193802-2-tabba@google.com>

On Fri, Mar 06, 2026 at 02:02:20PM +0000, Fuad Tabba wrote:
> As part of an effort to refactor user_mem_abort() into smaller, more
> focused helper functions, extract the logic responsible for determining
> the VMA shift and page size into a new static helper,
> kvm_s2_resolve_vma_size().
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/mmu.c | 130 ++++++++++++++++++++++++-------------------
>  1 file changed, 73 insertions(+), 57 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 17d64a1e11e5..f8064b2d3204 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1639,6 +1639,77 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	return ret != -EAGAIN ? ret : 0;
>  }
>  
> +static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
> +				     unsigned long hva,
> +				     struct kvm_memory_slot *memslot,
> +				     struct kvm_s2_trans *nested,
> +				     bool *force_pte, phys_addr_t *ipa)
> +{
> +	short vma_shift;
> +	long vma_pagesize;
> +
> +	if (*force_pte)
> +		vma_shift = PAGE_SHIFT;
> +	else
> +		vma_shift = get_vma_page_shift(vma, hva);
> +
> +	switch (vma_shift) {
> +#ifndef __PAGETABLE_PMD_FOLDED
> +	case PUD_SHIFT:
> +		if (fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
> +			break;
> +		fallthrough;
> +#endif
> +	case CONT_PMD_SHIFT:
> +		vma_shift = PMD_SHIFT;
> +		fallthrough;
> +	case PMD_SHIFT:
> +		if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE))
> +			break;
> +		fallthrough;
> +	case CONT_PTE_SHIFT:
> +		vma_shift = PAGE_SHIFT;
> +		*force_pte = true;
> +		fallthrough;
> +	case PAGE_SHIFT:
> +		break;
> +	default:
> +		WARN_ONCE(1, "Unknown vma_shift %d", vma_shift);
> +	}
> +
> +	vma_pagesize = 1UL << vma_shift;
> +
> +	if (nested) {
> +		unsigned long max_map_size;
> +
> +		max_map_size = *force_pte ? PAGE_SIZE : PUD_SIZE;
> +
> +		*ipa = kvm_s2_trans_output(nested);
> +
> +		/*
> +		 * If we're about to create a shadow stage 2 entry, then we
> +		 * can only create a block mapping if the guest stage 2 page
> +		 * table uses at least as big a mapping.
> +		 */
> +		max_map_size = min(kvm_s2_trans_size(nested), max_map_size);
> +
> +		/*
> +		 * Be careful that if the mapping size falls between
> +		 * two host sizes, take the smallest of the two.
> +		 */
> +		if (max_map_size >= PMD_SIZE && max_map_size < PUD_SIZE)
> +			max_map_size = PMD_SIZE;
> +		else if (max_map_size >= PAGE_SIZE && max_map_size < PMD_SIZE)
> +			max_map_size = PAGE_SIZE;
> +
> +		*force_pte = (max_map_size == PAGE_SIZE);
> +		vma_pagesize = min_t(long, vma_pagesize, max_map_size);
> +		vma_shift = __ffs(vma_pagesize);
> +	}
> +
> +	return vma_shift;
> +}
> +
>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			  struct kvm_s2_trans *nested,
>  			  struct kvm_memory_slot *memslot, unsigned long hva,
> @@ -1695,65 +1766,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		return -EFAULT;
>  	}
>  
> -	if (force_pte)
> -		vma_shift = PAGE_SHIFT;
> -	else
> -		vma_shift = get_vma_page_shift(vma, hva);
> -
> -	switch (vma_shift) {
> -#ifndef __PAGETABLE_PMD_FOLDED
> -	case PUD_SHIFT:
> -		if (fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
> -			break;
> -		fallthrough;
> -#endif
> -	case CONT_PMD_SHIFT:
> -		vma_shift = PMD_SHIFT;
> -		fallthrough;
> -	case PMD_SHIFT:
> -		if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE))
> -			break;
> -		fallthrough;
> -	case CONT_PTE_SHIFT:
> -		vma_shift = PAGE_SHIFT;
> -		force_pte = true;
> -		fallthrough;
> -	case PAGE_SHIFT:
> -		break;
> -	default:
> -		WARN_ONCE(1, "Unknown vma_shift %d", vma_shift);
> -	}
> -
> +	vma_shift = kvm_s2_resolve_vma_size(vma, hva, memslot, nested,
> +					    &force_pte, &ipa);
>  	vma_pagesize = 1UL << vma_shift;
>  
> -	if (nested) {
> -		unsigned long max_map_size;
> -
> -		max_map_size = force_pte ? PAGE_SIZE : PUD_SIZE;
> -
> -		ipa = kvm_s2_trans_output(nested);
> -
> -		/*
> -		 * If we're about to create a shadow stage 2 entry, then we
> -		 * can only create a block mapping if the guest stage 2 page
> -		 * table uses at least as big a mapping.
> -		 */
> -		max_map_size = min(kvm_s2_trans_size(nested), max_map_size);
> -
> -		/*
> -		 * Be careful that if the mapping size falls between
> -		 * two host sizes, take the smallest of the two.
> -		 */
> -		if (max_map_size >= PMD_SIZE && max_map_size < PUD_SIZE)
> -			max_map_size = PMD_SIZE;
> -		else if (max_map_size >= PAGE_SIZE && max_map_size < PMD_SIZE)
> -			max_map_size = PAGE_SIZE;
> -
> -		force_pte = (max_map_size == PAGE_SIZE);
> -		vma_pagesize = min_t(long, vma_pagesize, max_map_size);
> -		vma_shift = __ffs(vma_pagesize);
> -	}
> -
>  	/*
>  	 * Both the canonical IPA and fault IPA must be aligned to the
>  	 * mapping size to ensure we find the right PFN and lay down the
> -- 
> 2.53.0.473.g4a7958ca14-goog
> 
