Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DAF78F2E;
	Wed, 18 Jun 2025 15:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750261593; cv=none; b=T9Rt7nprAQ+FYsDmhUSG37T/w4FZkT/F6DcBMrRgHVjDGyTP/Bn1B6LnFeL15cPZABnYaOFKm1O8qEYzyMY+0yBrs9UWsu3VPUFyeZovRRyzu+rLZ8U5bY1iTvyfBSPdSgohGtKiOp2cfkroiqznkQ700gIep/yl6YX8hpeAVyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750261593; c=relaxed/simple;
	bh=5hmVSLrklEmE0kLkMAgHfMrkwLWa7AwfUPZRu0yfE+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i2/UuILwX1UIUrWOCXRPLbMuLQR6hgqWgUbn84CrOVKDeQqTRUglZWoSvD4qqpWMpbumryHpz1aETVFRGZgUfjuOvP5/siMBlCR1tGz6CEa3FJwBbwPc0OxT3hkddodk69IwbckCTtV+Mx5JX5JV6KkzJc8IEIPtaFY5/wmnJAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CFAC4CEE7;
	Wed, 18 Jun 2025 15:46:25 +0000 (UTC)
Date: Wed, 18 Jun 2025 16:46:23 +0100
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
Subject: Re: [PATCH v7 2/5] KVM: arm64: Block cacheable PFNMAP mapping
Message-ID: <aFLfT_c4Fcxt8euY@arm.com>
References: <20250618065541.50049-1-ankita@nvidia.com>
 <20250618065541.50049-3-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250618065541.50049-3-ankita@nvidia.com>

On Wed, Jun 18, 2025 at 06:55:38AM +0000, ankita@nvidia.com wrote:
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 3d77a278fc4f..d6e0d5f46b45 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1470,6 +1470,22 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
>  	return vma->vm_flags & VM_MTE_ALLOWED;
>  }
>  
> +/*
> + * Determine the memory region cacheability from VMA's pgprot. This
> + * is used to set the stage 2 PTEs.
> + */
> +static bool kvm_vma_is_cacheable(struct vm_area_struct *vma)
> +{
> +	switch (FIELD_GET(PTE_ATTRINDX_MASK, pgprot_val(vma->vm_page_prot))) {
> +	case MT_NORMAL_NC:
> +	case MT_DEVICE_nGnRnE:
> +	case MT_DEVICE_nGnRE:
> +		return false;
> +	default:
> +		return true;
> +	}
> +}
> +
>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			  struct kvm_s2_trans *nested,
>  			  struct kvm_memory_slot *memslot, unsigned long hva,
> @@ -1477,7 +1493,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  {
>  	int ret = 0;
>  	bool write_fault, writable, force_pte = false;
> -	bool exec_fault, mte_allowed;
> +	bool exec_fault, mte_allowed, is_vma_cacheable = false;

Nit: do we need to initialise is_vma_cacheable here? It did not seem
used until the kvm_vma_is_cacheable() call. Anyway, it's harmless.

>  	bool disable_cmo = false, vfio_allow_any_uc = false;
>  	unsigned long mmu_seq;
>  	phys_addr_t ipa = fault_ipa;
> @@ -1619,6 +1635,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  
>  	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
>  
> +	is_vma_cacheable = kvm_vma_is_cacheable(vma);
> +
>  	/* Don't use the VMA after the unlock -- it may have vanished */
>  	vma = NULL;
>  
> @@ -1643,6 +1661,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		return -EFAULT;
>  
>  	if (!kvm_can_use_cmo_pfn(pfn)) {
> +		if (is_vma_cacheable)
> +			return -EINVAL;
> +
>  		/*
>  		 * If the page was identified as device early by looking at
>  		 * the VMA flags, vma_pagesize is already representing the

This block also sets 'disable_cmo' (originally 'device') to true.

> @@ -1726,6 +1747,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		prot |= KVM_PGTABLE_PROT_X;
>  
>  	if (disable_cmo) {
> +		if (is_vma_cacheable) {
> +			ret = -EINVAL;
> +			goto out_unlock;
> +		}

so, is there anything else changing 'disable_cmo' up to this point? If
not, I'd drop the second is_vma_cacheable check.

-- 
Catalin
