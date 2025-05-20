Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37432258CF2;
	Tue, 20 May 2025 17:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747760966; cv=none; b=ggI88ViB5G3idXUZm5Kdmd+gb6sUf0zncEtqja92Cdtd2n8rsCCykXkeVI5fwxoprVtLhYoH+ndxlP+5jCkS9/YUi71ErC5zv8BM0kOsUuYAqnwj7zxLAzcJA9b5IdFGRrsoWH0roS7S1GPkFNc94USGyZgXSimH8hNhHtuesUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747760966; c=relaxed/simple;
	bh=LXX2ffUrx8lgLkfqjFgzf2zWJAFwCxP/jMZmzvk6xYo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CkNOifOKPBJcZjjSRfO+GNOtg80j6fo0e3jwMLSSlQPT1KwOSCyUh8CRN5gW94xPHJcVZIAZhHU2vyid2jAD5G26UmPmF4Dx1fPEAhG9ITULYyF5NGx7bwsh0yb/TExCbP4FdBQk0iMW+LvsOvCmYM5AHPUuaSuVOPJkEEziEJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82013C4CEE9;
	Tue, 20 May 2025 17:09:18 +0000 (UTC)
Date: Tue, 20 May 2025 18:09:15 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: ankita@nvidia.com
Cc: jgg@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	will@kernel.org, ryan.roberts@arm.com, shahuang@redhat.com,
	lpieralisi@kernel.org, david@redhat.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, kjaju@nvidia.com,
	targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
	apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
	zhiw@nvidia.com, mochs@nvidia.com, udhoke@nvidia.com,
	dnigam@nvidia.com, alex.williamson@redhat.com,
	sebastianene@google.com, coltonlewis@google.com,
	kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, linux-mm@kvack.org,
	ddutile@redhat.com, tabba@google.com, qperret@google.com,
	seanjc@google.com, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	maobibo@loongson.cn
Subject: Re: [PATCH v4 1/5] KVM: arm64: Block cacheable PFNMAP mapping
Message-ID: <aCy3OwBe1HLa4O-7@arm.com>
References: <20250518054754.5345-1-ankita@nvidia.com>
 <20250518054754.5345-2-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250518054754.5345-2-ankita@nvidia.com>

On Sun, May 18, 2025 at 05:47:50AM +0000, ankita@nvidia.com wrote:
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 2feb6c6b63af..eaac4db61828 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1466,6 +1466,15 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
>  	return vma->vm_flags & VM_MTE_ALLOWED;
>  }
>  
> +/*
> + * Determine the memory region cacheability from VMA's pgprot. This
> + * is used to set the stage 2 PTEs.
> + */
> +static unsigned long mapping_type(pgprot_t page_prot)
> +{
> +	return FIELD_GET(PTE_ATTRINDX_MASK, pgprot_val(page_prot));
> +}
> +
>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			  struct kvm_s2_trans *nested,
>  			  struct kvm_memory_slot *memslot, unsigned long hva,
> @@ -1612,6 +1621,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  
>  	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
>  
> +	if ((vma->vm_flags & VM_PFNMAP) &&
> +	    mapping_type(vma->vm_page_prot) == MT_NORMAL)
> +		return -EINVAL;
> +
>  	/* Don't use the VMA after the unlock -- it may have vanished */
>  	vma = NULL;
>  
> @@ -2207,6 +2220,12 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  				ret = -EINVAL;
>  				break;
>  			}
> +
> +			/* Cacheable PFNMAP is not allowed */
> +			if (mapping_type(vma->vm_page_prot) == MT_NORMAL) {
> +				ret = -EINVAL;
> +				break;
> +			}

Should we capture MT_NORMAL_TAGGED as well? Presumably no driver sets
VM_MTE_ALLOWED but the same could be set about MT_NORMAL in the
vm_page_prot.

That said, we might as well invert the check, allow if MT_DEVICE_* or
MT_NORMAL_NC (the latter based on VM_ALLOW_ANY_UNCACHED).

-- 
Catalin
