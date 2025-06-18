Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F5119D081;
	Wed, 18 Jun 2025 16:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750264466; cv=none; b=jo4HN5bjeQEXHFTgW/dSV9dx68KU7wxvbfQkUwMZPexJVjpB1Vtyt2NzJKPpEajvSEO8RoUXUpU+osQzT/dFNbwpndCaH8AWb8sP8/G6lmjkoVNbz50fQi+ZqTtGgJsu9Jm7XDhWH9alThI8+/nS5l7OG4ARjWqnNvfyYQoeVzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750264466; c=relaxed/simple;
	bh=z9J8mMaMxFTDbzG2gynpi72sG4inc2DuGiKFJSnJpEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pI92mpFS1Rmash1nKqEnn5eM8hYPg2lFcyAexrehftzolhdvuLFDhuKlmY2rGPfExJMZzQqV+DKgDpYsMXlG6jpJ2usUyXAIBz6J6/NTjNANk34Ssmt6nvacQdzuh5W6u+bHEw3CkHkFqHLQl3pzabBDWG1tYxIWVWD7u5CdxRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF032C4CEE7;
	Wed, 18 Jun 2025 16:34:18 +0000 (UTC)
Date: Wed, 18 Jun 2025 17:34:16 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: ankita@nvidia.com
Cc: jgg@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	will@kernel.org, ryan.roberts@arm.com, shahuang@redhat.com,
	lpieralisi@kernel.org, david@redhat.com, ddutile@redhat.com,
	seanjc@google.com, aniketa@nvidia.com, cjia@nvidia.com,
	kwankhede@nvidia.com, kjaju@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, zhiw@nvidia.com,
	mochs@nvidia.com, udhoke@nvidia.com, dnigam@nvidia.com,
	alex.williamson@redhat.com, sebastianene@google.com,
	coltonlewis@google.com, kevin.tian@intel.com, yi.l.liu@intel.com,
	ardb@kernel.org, akpm@linux-foundation.org, gshan@redhat.com,
	linux-mm@kvack.org, tabba@google.com, qperret@google.com,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, maobibo@loongson.cn
Subject: Re: [PATCH v7 4/5] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <aFLqiAyXZLoOTepi@arm.com>
References: <20250618065541.50049-1-ankita@nvidia.com>
 <20250618065541.50049-5-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250618065541.50049-5-ankita@nvidia.com>

On Wed, Jun 18, 2025 at 06:55:40AM +0000, ankita@nvidia.com wrote:
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index a71b77df7c96..6a3955e07b5e 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1660,6 +1660,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  
>  	is_vma_cacheable = kvm_vma_is_cacheable(vma);
>  
> +	/* Reject COW VM_PFNMAP */
> +	if ((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags))
> +		return -EINVAL;

It may help to add a comment here why this needs to be rejected. I
forgot the details but tracked it down to an email from David a few
months ago:

https://lore.kernel.org/all/a2d95399-62ad-46d3-9e48-6fa90fd2c2f3@redhat.com/

> +
>  	/* Don't use the VMA after the unlock -- it may have vanished */
>  	vma = NULL;
>  
> @@ -1684,9 +1688,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		return -EFAULT;
>  
>  	if (!kvm_can_use_cmo_pfn(pfn)) {
> -		if (is_vma_cacheable)
> -			return -EINVAL;
> -
>  		/*
>  		 * If the page was identified as device early by looking at
>  		 * the VMA flags, vma_pagesize is already representing the
> @@ -1696,8 +1697,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		 *
>  		 * In both cases, we don't let transparent_hugepage_adjust()
>  		 * change things at the last minute.
> +		 *
> +		 * Do not set device as the device memory is cacheable. Note
> +		 * that such mapping is safe as the KVM S2 will have the same
> +		 * Normal memory type as the VMA has in the S1.
>  		 */
> -		disable_cmo = true;
> +		if (!is_vma_cacheable)
> +			disable_cmo = true;

I'm tempted to stick to the 'device' variable name. Or something like
s2_noncacheable. As I commented, it's not just about disabling CMOs.

>  	} else if (logging_active && !write_fault) {
>  		/*
>  		 * Only actually map the page as writable if this was a write
> @@ -1784,6 +1790,19 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		prot |= KVM_PGTABLE_PROT_X;
>  	}
>  
> +	/*
> +	 *  When FWB is unsupported KVM needs to do cache flushes
> +	 *  (via dcache_clean_inval_poc()) of the underlying memory. This is
> +	 *  only possible if the memory is already mapped into the kernel map.
> +	 *
> +	 *  Outright reject as the cacheable device memory is not present in
> +	 *  the kernel map and not suitable for cache management.
> +	 */
> +	if (is_vma_cacheable && !kvm_arch_supports_cacheable_pfnmap()) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}

I'm missing the full context around this hunk but, judging by
indentation, does it also reject any cacheable vma even if it is not
PFNMAP on pre-FWB hardware?

-- 
Catalin
