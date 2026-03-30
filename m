Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFECC296BD3
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 04:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774843706; cv=none; b=fEqEwayu1E+Hg/GpK6BudEBz8N9DctajnkkAq6lxSuZINbZzKZ8PEKCLwSA/YIT2n5y6TdA7npAhXnCutMPYQ5Ki9Vbi5dsVyNJsU2034THhNFpFmdi+WkNFvlPJfuhZsnLBZnXvA8LBcT+Xq8Q6wHz5ds5laVXVkvowjj3AeUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774843706; c=relaxed/simple;
	bh=bVSQPfEfQn4rPyXd+zCo7Beo5cEzgv22ia45f2SbACA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mk1+uvQyT85zetugfB/KqqcazUPoQXt9/MHqAwsKMInMKCdRZDULSfhaBV4IChSkEOOjT+qA+rI/OKJjQczxDFFxCWuz/nN1Eeu6KFKnyAkwVBQN00lyinozoC71i9gd2mSeugosQbBzBI2+IHSSbbYNiS6U0h3WUBlFLj2LBns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=j+jaHXPc; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="j+jaHXPc"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 32BE01C14;
	Sun, 29 Mar 2026 21:08:16 -0700 (PDT)
Received: from [10.164.18.48] (unknown [10.164.18.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E57D03F915;
	Sun, 29 Mar 2026 21:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774843702; bh=bVSQPfEfQn4rPyXd+zCo7Beo5cEzgv22ia45f2SbACA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=j+jaHXPcfSC7jhFN9veLngykywyrPl9njMGZ6EG1fk6LpITiNUM91nOCpx7ElxYdO
	 07FE3K+z2Rms/OJw4/EC2pOHU+u4Ve10JdY9XvOPFsKO5Rb8KTGy5nPRQdDMSgellE
	 2qGRTvaLZE5bCv3Pa0cNHurx/A6O/wxw3VBGve0o=
Message-ID: <5d51d6d4-d4c9-498e-8537-e25e4ecd961b@arm.com>
Date: Mon, 30 Mar 2026 09:38:16 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/30] KVM: arm64: Extract VMA size resolution in
 user_mem_abort()
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
 Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>
References: <20260327113618.4051534-1-maz@kernel.org>
 <20260327113618.4051534-2-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260327113618.4051534-2-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/03/26 5:05 PM, Marc Zyngier wrote:
> From: Fuad Tabba <tabba@google.com>
> 
> As part of an effort to refactor user_mem_abort() into smaller, more
> focused helper functions, extract the logic responsible for determining
> the VMA shift and page size into a new static helper,
> kvm_s2_resolve_vma_size().
> 
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/kvm/mmu.c | 130 ++++++++++++++++++++++++-------------------
>  1 file changed, 73 insertions(+), 57 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 17d64a1e11e5c..f8064b2d32045 100644
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

