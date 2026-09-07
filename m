Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53CA647FAF5
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 18:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788804920; cv=none; b=oAc3q+hk9EgoRHAlHDVvUGO7L7pRTfgl9RkDwrel3QIdy0FKA66x/DTXiayks2bNSQZFQDKHY4GD9rEnaXRWVTU5rkNaLcZppm3zmBnrsGUyqXXnWvvRnsAUooybc9MWhJN0AL+iKnDWPLJ/UNVsQt2N1NgLSH/Z+z71vieY/RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788804920; c=relaxed/simple;
	bh=ck9s6awvWoQabY7mvX0NzJU7mHT9euwaJcsle6oxm50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jz7t4rubJrhsh2FoEXIok1uXHWl9pJSfmHgQ7vyxdjqQ1Dt0mymQlKpeKd1fo8mwFogk8FzuRCVkVpjmf5yYBbHsEgXS+jmVO8Gm6bYQqQqKePIKnYTx4tBBETtwQh9HjjxP17KcVZpg4bG/YgrGBmUo8PAib2rOijcF6SwMj/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=vTDSDY6x; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="vTDSDY6x"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 76FC91476;
	Mon,  7 Sep 2026 11:15:12 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E5CEC3F528;
	Mon,  7 Sep 2026 11:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788804916; bh=ck9s6awvWoQabY7mvX0NzJU7mHT9euwaJcsle6oxm50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vTDSDY6xkHXiyCz/4Hm0HH8sVkIOLCZa+k3NpFfkNPFA3sFxxh8U7rKIga1h22erW
	 kCCv3Dt4Rf/mPRUXkmYocGUuqh3DPHdFvpb+yWnZ1GmbIEKB5VB7OunQOhv6djOruA
	 iciBQXHC0W/bHViFoPN/NpxoOJnjM4ulSt8GswVc=
Date: Mon, 7 Sep 2026 19:15:05 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org, 
	oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, keirf@google.com
Subject: Re: [PATCH 18/20] KVM: arm64: Add PKVM_HYP_REQ_SPLIT
Message-ID: <b55i2bcuqp2wgadrj5a6nuc3t4o7ordrlcugxhhjw37k6hrlks@2h7ulmokholz>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-19-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803100904.3563942-19-vdonnefort@google.com>

On Mon, Aug 03, 2026 at 11:09:02AM +0100, Vincent Donnefort wrote:
> With the upcoming support for stage-2 huge mappings for protected VMs,
> we need a way to split blocks. Since the host has its own "copy" of the
> guest stage-2 in the pkvm_mappings rb-tree, the split must be done
> simultaneously for both that tree and the guest stage-2. Therefore the
> hypervisor can't do it on its own and must rely on the host for this
> operation.
> 
> Create a pKVM hypervisor request to ask the host to split a specified
> region of the guest. On this request, the host can synchronise the split
> of both guest stage-2 (HVC __pkvm_host_split_guest) and the
> pkvm_mappings tree. It ensures a concurrent VM teardown can't observe a
> PMD_SIZE pkvm_mapping while the guest stage-2 is PAGE_SIZE.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index d01e6954d363..927d9de643fa 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -87,11 +87,18 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
>  
>  enum pkvm_hyp_req_type {
>  	PKVM_HYP_NO_REQ = 0,
> +	PKVM_HYP_REQ_SPLIT,
>  	__PKVM_HYP_REQ_TYPE_MAX,
>  };
>  
>  struct pkvm_hyp_req {
>  	u8 type;
> +	union {
> +		struct {
> +			u32	nr_pages;
> +			u64	gfn;
> +		} split;
> +	};
>  };
>  
>  struct kvm_hyp_memcache {
> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> index baafbd7ca215..370eddeefbae 100644
> --- a/arch/arm64/include/asm/kvm_pkvm.h
> +++ b/arch/arm64/include/asm/kvm_pkvm.h
> @@ -193,7 +193,10 @@ static inline size_t pkvm_host_sve_state_size(void)
>  }
>  
>  struct pkvm_mapping {
> -	struct rb_node node;
> +	union {
> +		struct rb_node node;
> +		struct list_head list;
> +	};
>  	u64 gfn;
>  	u64 pfn;
>  	u64 nr_pages;
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 379bdc2b258a..089b77cf2f6a 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -365,6 +365,69 @@ INTERVAL_TREE_DEFINE(struct pkvm_mapping, node, u64, __subtree_last,
>  		       });									\
>  	    )
>  
> +static void pkvm_mapping_free_spares(struct list_head *spares)
> +{
> +	struct pkvm_mapping *m, *tmp;
> +
> +	list_for_each_entry_safe(m, tmp, spares, list) {
> +		list_del(&m->list);
> +		kfree(m);
> +	}
> +}
> +
> +static int pkvm_mapping_alloc_spares(struct list_head *head, u64 nr_spares)
> +{
> +	struct pkvm_mapping *m;
> +
> +	while (nr_spares--) {
> +		m = kzalloc_obj(*m);
> +		if (!m) {
> +			pkvm_mapping_free_spares(head);
> +			return -ENOMEM;
> +		}
> +
> +		list_add(&m->list, head);
> +	}
> +
> +	return 0;
> +}
> +
> +static bool pkvm_mapping_can_split(struct pkvm_mapping *mapping)
> +{
> +	return mapping && (mapping->nr_pages * PAGE_SIZE == PMD_SIZE);
> +}
> +
> +static void pkvm_mapping_split(struct pkvm_mapping *mapping, struct kvm_pgtable *pgt,
> +			       struct list_head *spares)
> +{
> +	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
> +	u64 nr_pages = mapping->nr_pages - 1;
> +	gfn_t gfn = mapping->gfn + 1;
> +	u64 pfn = mapping->pfn + 1;
> +
> +	lockdep_assert_held_write(&kvm->mmu_lock);
> +
> +	pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
> +	mapping->nr_pages = 1;
> +	pkvm_mapping_insert(mapping, &pgt->pkvm_mappings);
> +
> +	while (nr_pages--) {
> +		struct pkvm_mapping *m;
> +
> +		if (WARN_ON(list_empty(spares)))
> +			break;
> +
> +		m = list_first_entry(spares, struct pkvm_mapping, list);
> +		list_del(&m->list);
> +
> +		m->nr_pages = 1;
> +		m->gfn = gfn++;
> +		m->pfn = pfn++;
> +
> +		pkvm_mapping_insert(m, &pgt->pkvm_mappings);
> +	}
> +}
> +

I don't see anything wrong with this linked list approach, but have you
considered just allocating an array of pointers for the allocated
pkvm_mappings? The union in pkvm_mappings can be avoided.

>  int pkvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>  			     struct kvm_pgtable_mm_ops *mm_ops)
>  {
> @@ -619,6 +682,91 @@ int pkvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size, void
>  	return -EINVAL;
>  }
>  
> +/*
> + * Splitting is only expected on the back of a guest HVC, while
> + * pkvm_pgtable_stage2_split() can be called with dirty logging.
> + */
> +static int __pkvm_pgtable_stage2_split(struct kvm_vcpu *vcpu, phys_addr_t ipa, u64 size)
> +{
> +	struct kvm_hyp_memcache *mc = &vcpu->arch.pkvm_memcache;
> +	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> +	struct page **pages __free(kfree) = NULL;
> +	struct mm_struct *mm = current->mm;
> +	struct kvm_memory_slot *memslot;
> +	struct pkvm_mapping *mapping;
> +	struct kvm *kvm = vcpu->kvm;
> +	struct list_head spares;
> +	unsigned long hva;
> +	bool writable;
> +	u64 nr_pages;
> +	int ret, idx;
> +	gfn_t gfn;
> +
> +	if (WARN_ON(!kvm_vm_is_protected(kvm)))
> +		return -EINVAL;
> +
> +	if (!IS_ALIGNED(ipa, PMD_SIZE) || size != PMD_SIZE)
> +		return -EINVAL;
> +
> +	ret = topup_hyp_memcache(mc, 1);
> +	if (ret)
> +		return ret;
> +
> +	/* We already have 1 pin on the huge-page */
> +	gfn = gpa_to_gfn(ipa) + 1;
> +	nr_pages = (size / PAGE_SIZE) - 1;
> +	pages = kmalloc_objs(struct page *, nr_pages);
> +	if (!pages)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&spares);
> +	ret = pkvm_mapping_alloc_spares(&spares, nr_pages);
> +	if (ret)
> +		return ret;
> +
> +	idx = srcu_read_lock(&kvm->srcu);
> +	memslot = gfn_to_memslot(kvm, gfn);
> +	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
> +	if (kvm_is_error_hva(hva) || !writable) {
> +		ret = -EFAULT;
> +		goto unlock_srcu;
> +	}
> +
> +	mmap_read_lock(mm);
> +	ret = pin_user_pages(hva, nr_pages, FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE, pages);

If I am not mistaken this is for getting additional pins only. hva walk
and pages[] are just by-product.

Can we use folio_add_pins() here instead? Then I think we won't need
pages[], the hva walk, and unpin_user_pages().

Thanks,
Wei-Lin Chang

> +	mmap_read_unlock(mm);
> +	if (ret != nr_pages) {
> +		if (ret > 0)
> +			unpin_user_pages(pages, ret);
> +		ret = -EFAULT;
> +		goto unlock_srcu;
> +	}
> +
> +	write_lock(&kvm->mmu_lock);
> +	mapping = pkvm_mapping_iter_first(&pgt->pkvm_mappings, ipa, ipa + size - 1);
> +	if (!pkvm_mapping_can_split(mapping)) {
> +		ret = -EINVAL;
> +		goto unlock_mmu;
> +	}
> +
> +	ret = kvm_call_hyp_nvhe(__pkvm_host_split_guest, gpa_to_gfn(ipa), size / PAGE_SIZE);
> +	if (ret)
> +		goto unlock_mmu;
> +
> +	pkvm_mapping_split(mapping, pgt, &spares);
> +
> +unlock_mmu:
> +	write_unlock(&kvm->mmu_lock);
> +	if (ret)
> +		unpin_user_pages(pages, nr_pages);
> +
> +unlock_srcu:
> +	srcu_read_unlock(&kvm->srcu, idx);
> +	pkvm_mapping_free_spares(&spares);
> +
> +	return ret;
> +}
> +

[...]

