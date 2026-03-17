Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C47372B2B
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 12:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773751937; cv=pass; b=hok1y4nYVc1gm86qgwMzek4GInbVerreCqiLBzC50bogHPg1/DUPeF0jq+tHs4Ch+ME9ZWo8PF/0EVSbP3fl2SpyuAO1Iv97xdXymNSv2QBlzIPnxI3B/UM0kKxG5dDmMdQf4hQ4xvbo49+bhyG1+LEvVAPWkGxJekvTxUp/blo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773751937; c=relaxed/simple;
	bh=0om9Zy7i16ckF3gAo9e6uqrwq1St43XKpnKuJ922RNg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UmEKHFtEBcrrPfU+QLalVCJK2BbJnmtPUi59ulk+Tcwl4pACxAgSxhhFqYlu2pQQ9NsxFPi2ILDtxJ1OQe6TGVUfjgA1w18EJVuUBT/M+B03zzyOmR1wTgl0DVqELrKrRrI9IpkgbA8z1q0a7X5g4TXaXsBKA5fzNPpXl2yc5CA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cZd0CT5h; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cZd0CT5h"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5091ed02c54so395661cf.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 05:52:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773751935; cv=none;
        d=google.com; s=arc-20240605;
        b=DBTMUrkTtO3uzJ6Y8DW68A1GbE1pGNB04fFnBkNEnh8N03LPfHgv5l9PuTEqkVEtC6
         ahJVSXeZqsmaqu2qVgFrBc59l1nQWyguVUyyD5rzJrP3iuuzgR8YzSFSPCWYtnJ3LAru
         0SQB0acX4D1hfDHrPi1ixp/MZaF3GBpLqeGWZPxVjCrSZtnqH12fFcS89aSut+dcuWZg
         I6DAd3M8f56cSTjRM4CDa9WG05nAgD/iMSppL+/5d+CeqUcFfjGkH5v0d8aQ7QP8nJtu
         Zlf98CRaPGRSE6+Hq8qG1/kOD2RMFhFzXx3RnGW1IqsN8hY626swaKUZULsss0yRXC0T
         iSHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=yqdhsZMms3Hyv+l4q3AGibpbsTitIRWecBmHePuTWJ8=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=Ago4JNC0qM+3NQU4qTlslyWR8AVwHVQvkhluCkXrDhH3HpoyTfmvHVZwMpkwEF9RJC
         nQsFVjGtge3y7fayvfovsgWXQyFaPtkYei73mNPIJG/qU2ifGcJRIqZ2LbAgDVtp99rn
         lMYeL7kyWhoZU/c4J/lsxfFd8IvtgINVV5NvTmizT/Me8eZp14t+be967uAqVGm9AibS
         WH1V7fP1271SPK/qHsN+jAfgtUjj8K9Qf48JubEMwSF/sf7CJrixNses4QeLTc07vK1S
         P/9cYOm2660zahaPKv+Sx9PxDVN9CJ7PpnEm6cVCUG0bbfQ29V1kAUiKgY5GpWR2nKYw
         vSug==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773751935; x=1774356735; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yqdhsZMms3Hyv+l4q3AGibpbsTitIRWecBmHePuTWJ8=;
        b=cZd0CT5hx8GdaH6oHqUM4wkcB1IV0Tw1pAbc2uF1qbfQAV4LFVxnsRelj+lWLwzNnJ
         ePrp2WF0cIaZtfFYMu/TNZBKrxEULnVzIWLbLsShPFzny9zRWOhqRDS3YzOAMaygfrsQ
         j3fSwrC5kItUtqwtFRXgOOkk7Sz0O5evZtxyCd+73GNxGfaA1JC3yn/ywYIzwuSYqHIc
         dyx8WFvPz7CaRDnQgo5kH7sTmskf/DZyI4FLqEmp/IjHhDQJK16QalHsln4t5fBbNRN7
         iri+VKnS8gw6GK3glcoiTqNssWMxvIGn6azIcjfB3+5GPwZXs1I/YVbEe+ibYVMeR7zt
         W9Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773751935; x=1774356735;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yqdhsZMms3Hyv+l4q3AGibpbsTitIRWecBmHePuTWJ8=;
        b=n2twYyKe0aPRZzRHFIs47IiNQwOEHb8gCrdYlbDejkPSJJHhyqg4PISlYecoGv3JJ0
         E5fjcSSIWpDR1MWi3+PkoUWAJmcPYPO4LD9KD81C//d+xyw3niyRkXp1i71ju3m79PlB
         Lq4xI99OEX91Q5nuxJ6Nwx/KGUcRE0m+oqholBUv1FofqBLdj9HFHmgRUJaSaPNOuFf5
         djsNHQmYOQHx7Ggm5l+4d32SvtIwlNkLabVWuZ8BnD0zegrQo08Jy6N29WLSp06vEnEg
         VTe73GameqhaBz6fUKa2WQt2ibvkYDH1vvRy7oz8/m9hwvJ54N9ONT7/EzYGBYw87fr7
         hcFg==
X-Gm-Message-State: AOJu0YwouqcLFEYAUUAr0LViDtJm9ZD82TwjQp1eLiC/yH8bxjBpFD+G
	tEZq0UXY89vRciRD2xCsrsU2DddNSen9ngcvvPjc3fqDJWrNePuWW84YKrMMMI7ZTXBet4LvtZz
	dQs6Zk2gxZzk3Uu5eW+/sMa1BTKly1wrk+h3XsdgI
X-Gm-Gg: ATEYQzyYzgD72mRGzRM34ecuxW3TsgjWd2GkaqmdtFnYWBpxq8YevubGcOG6Kg6oKdl
	AA65YDsJaOruRofWXL/Z2C6toUZVFWgpdx+LhBZ8K9iCHtNNDWaWKe8aNVtlD9LMQJE6yMXq6mD
	7tUUS0ceWCDy86x9wGhB6xE7qkTdo1PTNbzel0avUyBvq91DjqrOyZVh6rFwDQgxQl3ebgu477s
	ZPVpdMQefkkk35dXf+UF/rAiLKoLkiI9DoW/282cijlyBPyxZ0q7hpsA/sNCFb67jyzACmO1gVy
	zPL0z2pQKS8ipBW00XNLEZg2toYr8eaBqb699Zf8MV+C9Pk=
X-Received: by 2002:a05:622a:34f:b0:509:1cf9:ea11 with SMTP id
 d75a77b69052e-5099ae36e43mr13321661cf.7.1773751934515; Tue, 17 Mar 2026
 05:52:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316175451.1866175-1-maz@kernel.org> <20260316175451.1866175-10-maz@kernel.org>
In-Reply-To: <20260316175451.1866175-10-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Mar 2026 12:51:37 +0000
X-Gm-Features: AaiRm50Du2xrfQCZBL5z6Chj3KUwzQGCZZeT5SEq7dCMJNMiEDXSdkpbqldTIWo
Message-ID: <CA+EHjTykfSjBQVpL5KPANzF7tvWCFiCkZUk2oTfQjgT8E7d5AQ@mail.gmail.com>
Subject: Re: [PATCH 09/17] KVM: arm64: Move VMA-related information to kvm_s2_fault_vma_info
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Mar 2026 at 17:55, Marc Zyngier <maz@kernel.org> wrote:
>
> Mecanically extract a bunch of VMA-related fields from kvm_s2_fault
> and move them to a new kvm_s2_fault_vma_info structure.
>
> This is not much, but it already allows us to define which functions
> can update this structure, and which ones are pure consumers of the
> data. Those in the latter camp are updated to take a const pointer
> to that structure.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

I really like how, with this patch, we now distinguish between
vma_pagesize and mapping_size. Less chance for bugs or confusion.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/mmu.c | 113 +++++++++++++++++++++++--------------------
>  1 file changed, 61 insertions(+), 52 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index abe239752c696..a5b0dd41560f6 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1710,20 +1710,23 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
>         return vma_shift;
>  }
>
> +struct kvm_s2_fault_vma_info {
> +       unsigned long   mmu_seq;
> +       long            vma_pagesize;
> +       vm_flags_t      vm_flags;
> +       gfn_t           gfn;
> +       bool            mte_allowed;
> +       bool            is_vma_cacheable;
> +};
> +
>  struct kvm_s2_fault {
>         bool writable;
> -       bool mte_allowed;
> -       bool is_vma_cacheable;
>         bool s2_force_noncacheable;
> -       unsigned long mmu_seq;
> -       gfn_t gfn;
>         kvm_pfn_t pfn;
>         bool logging_active;
>         bool force_pte;
> -       long vma_pagesize;
>         enum kvm_pgtable_prot prot;
>         struct page *page;
> -       vm_flags_t vm_flags;
>  };
>
>  static bool kvm_s2_fault_is_perm(const struct kvm_s2_fault_desc *s2fd)
> @@ -1732,7 +1735,8 @@ static bool kvm_s2_fault_is_perm(const struct kvm_s2_fault_desc *s2fd)
>  }
>
>  static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
> -                                    struct kvm_s2_fault *fault)
> +                                    struct kvm_s2_fault *fault,
> +                                    struct kvm_s2_fault_vma_info *s2vi)
>  {
>         struct vm_area_struct *vma;
>         struct kvm *kvm = s2fd->vcpu->kvm;
> @@ -1745,20 +1749,20 @@ static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
>                 return -EFAULT;
>         }
>
> -       fault->vma_pagesize = BIT(kvm_s2_resolve_vma_size(s2fd, vma, &fault->force_pte));
> +       s2vi->vma_pagesize = BIT(kvm_s2_resolve_vma_size(s2fd, vma, &fault->force_pte));
>
>         /*
>          * Both the canonical IPA and fault IPA must be aligned to the
>          * mapping size to ensure we find the right PFN and lay down the
>          * mapping in the right place.
>          */
> -       fault->gfn = ALIGN_DOWN(s2fd->fault_ipa, fault->vma_pagesize) >> PAGE_SHIFT;
> +       s2vi->gfn = ALIGN_DOWN(s2fd->fault_ipa, s2vi->vma_pagesize) >> PAGE_SHIFT;
>
> -       fault->mte_allowed = kvm_vma_mte_allowed(vma);
> +       s2vi->mte_allowed = kvm_vma_mte_allowed(vma);
>
> -       fault->vm_flags = vma->vm_flags;
> +       s2vi->vm_flags = vma->vm_flags;
>
> -       fault->is_vma_cacheable = kvm_vma_is_cacheable(vma);
> +       s2vi->is_vma_cacheable = kvm_vma_is_cacheable(vma);
>
>         /*
>          * Read mmu_invalidate_seq so that KVM can detect if the results of
> @@ -1768,39 +1772,40 @@ static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
>          * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
>          * with the smp_wmb() in kvm_mmu_invalidate_end().
>          */
> -       fault->mmu_seq = kvm->mmu_invalidate_seq;
> +       s2vi->mmu_seq = kvm->mmu_invalidate_seq;
>         mmap_read_unlock(current->mm);
>
>         return 0;
>  }
>
>  static gfn_t get_canonical_gfn(const struct kvm_s2_fault_desc *s2fd,
> -                              const struct kvm_s2_fault *fault)
> +                              const struct kvm_s2_fault_vma_info *s2vi)
>  {
>         phys_addr_t ipa;
>
>         if (!s2fd->nested)
> -               return fault->gfn;
> +               return s2vi->gfn;
>
>         ipa = kvm_s2_trans_output(s2fd->nested);
> -       return ALIGN_DOWN(ipa, fault->vma_pagesize) >> PAGE_SHIFT;
> +       return ALIGN_DOWN(ipa, s2vi->vma_pagesize) >> PAGE_SHIFT;
>  }
>
>  static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
> -                               struct kvm_s2_fault *fault)
> +                               struct kvm_s2_fault *fault,
> +                               struct kvm_s2_fault_vma_info *s2vi)
>  {
>         int ret;
>
> -       ret = kvm_s2_fault_get_vma_info(s2fd, fault);
> +       ret = kvm_s2_fault_get_vma_info(s2fd, fault, s2vi);
>         if (ret)
>                 return ret;
>
> -       fault->pfn = __kvm_faultin_pfn(s2fd->memslot, get_canonical_gfn(s2fd, fault),
> +       fault->pfn = __kvm_faultin_pfn(s2fd->memslot, get_canonical_gfn(s2fd, s2vi),
>                                        kvm_is_write_fault(s2fd->vcpu) ? FOLL_WRITE : 0,
>                                        &fault->writable, &fault->page);
>         if (unlikely(is_error_noslot_pfn(fault->pfn))) {
>                 if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
> -                       kvm_send_hwpoison_signal(s2fd->hva, __ffs(fault->vma_pagesize));
> +                       kvm_send_hwpoison_signal(s2fd->hva, __ffs(s2vi->vma_pagesize));
>                         return 0;
>                 }
>                 return -EFAULT;
> @@ -1810,7 +1815,8 @@ static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
>  }
>
>  static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
> -                                    struct kvm_s2_fault *fault)
> +                                    struct kvm_s2_fault *fault,
> +                                    const struct kvm_s2_fault_vma_info *s2vi)
>  {
>         struct kvm *kvm = s2fd->vcpu->kvm;
>
> @@ -1818,8 +1824,8 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>          * Check if this is non-struct page memory PFN, and cannot support
>          * CMOs. It could potentially be unsafe to access as cacheable.
>          */
> -       if (fault->vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(fault->pfn)) {
> -               if (fault->is_vma_cacheable) {
> +       if (s2vi->vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(fault->pfn)) {
> +               if (s2vi->is_vma_cacheable) {
>                         /*
>                          * Whilst the VMA owner expects cacheable mapping to this
>                          * PFN, hardware also has to support the FWB and CACHE DIC
> @@ -1879,7 +1885,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>                 fault->prot |= KVM_PGTABLE_PROT_X;
>
>         if (fault->s2_force_noncacheable)
> -               fault->prot |= (fault->vm_flags & VM_ALLOW_ANY_UNCACHED) ?
> +               fault->prot |= (s2vi->vm_flags & VM_ALLOW_ANY_UNCACHED) ?
>                                KVM_PGTABLE_PROT_NORMAL_NC : KVM_PGTABLE_PROT_DEVICE;
>         else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
>                 fault->prot |= KVM_PGTABLE_PROT_X;
> @@ -1889,74 +1895,73 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>
>         if (!kvm_s2_fault_is_perm(s2fd) && !fault->s2_force_noncacheable && kvm_has_mte(kvm)) {
>                 /* Check the VMM hasn't introduced a new disallowed VMA */
> -               if (!fault->mte_allowed)
> +               if (!s2vi->mte_allowed)
>                         return -EFAULT;
>         }
>
>         return 0;
>  }
>
> -static phys_addr_t get_ipa(const struct kvm_s2_fault *fault)
> -{
> -       return gfn_to_gpa(fault->gfn);
> -}
> -
>  static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
> -                           struct kvm_s2_fault *fault, void *memcache)
> +                           struct kvm_s2_fault *fault,
> +                           const struct kvm_s2_fault_vma_info *s2vi, void *memcache)
>  {
> +       enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
>         struct kvm *kvm = s2fd->vcpu->kvm;
>         struct kvm_pgtable *pgt;
>         long perm_fault_granule;
> +       long mapping_size;
> +       gfn_t gfn;
>         int ret;
> -       enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
>
>         kvm_fault_lock(kvm);
>         pgt = s2fd->vcpu->arch.hw_mmu->pgt;
>         ret = -EAGAIN;
> -       if (mmu_invalidate_retry(kvm, fault->mmu_seq))
> +       if (mmu_invalidate_retry(kvm, s2vi->mmu_seq))
>                 goto out_unlock;
>
>         perm_fault_granule = (kvm_s2_fault_is_perm(s2fd) ?
>                               kvm_vcpu_trap_get_perm_fault_granule(s2fd->vcpu) : 0);
> +       mapping_size = s2vi->vma_pagesize;
> +       gfn = s2vi->gfn;
>
>         /*
>          * If we are not forced to use fault->page mapping, check if we are
>          * backed by a THP and thus use block mapping if possible.
>          */
> -       if (fault->vma_pagesize == PAGE_SIZE &&
> +       if (mapping_size == PAGE_SIZE &&
>             !(fault->force_pte || fault->s2_force_noncacheable)) {
>                 if (perm_fault_granule > PAGE_SIZE) {
> -                       fault->vma_pagesize = perm_fault_granule;
> +                       mapping_size = perm_fault_granule;
>                 } else {
> -                       fault->vma_pagesize = transparent_hugepage_adjust(kvm, s2fd->memslot,
> -                                                                         s2fd->hva, &fault->pfn,
> -                                                                         &fault->gfn);
> -
> -                       if (fault->vma_pagesize < 0) {
> -                               ret = fault->vma_pagesize;
> +                       mapping_size = transparent_hugepage_adjust(kvm, s2fd->memslot,
> +                                                                  s2fd->hva, &fault->pfn,
> +                                                                  &gfn);
> +                       if (mapping_size < 0) {
> +                               ret = mapping_size;
>                                 goto out_unlock;
>                         }
>                 }
>         }
>
>         if (!perm_fault_granule && !fault->s2_force_noncacheable && kvm_has_mte(kvm))
> -               sanitise_mte_tags(kvm, fault->pfn, fault->vma_pagesize);
> +               sanitise_mte_tags(kvm, fault->pfn, mapping_size);
>
>         /*
>          * Under the premise of getting a FSC_PERM fault, we just need to relax
> -        * permissions only if vma_pagesize equals perm_fault_granule. Otherwise,
> +        * permissions only if mapping_size equals perm_fault_granule. Otherwise,
>          * kvm_pgtable_stage2_map() should be called to change block size.
>          */
> -       if (fault->vma_pagesize == perm_fault_granule) {
> +       if (mapping_size == perm_fault_granule) {
>                 /*
>                  * Drop the SW bits in favour of those stored in the
>                  * PTE, which will be preserved.
>                  */
>                 fault->prot &= ~KVM_NV_GUEST_MAP_SZ;
> -               ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, get_ipa(fault),
> +               ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, gfn_to_gpa(gfn),
>                                                                  fault->prot, flags);
>         } else {
> -               ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, get_ipa(fault), fault->vma_pagesize,
> +               ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, gfn_to_gpa(gfn), mapping_size,
>                                                          __pfn_to_phys(fault->pfn), fault->prot,
>                                                          memcache, flags);
>         }
> @@ -1965,9 +1970,12 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>         kvm_release_faultin_page(kvm, fault->page, !!ret, fault->writable);
>         kvm_fault_unlock(kvm);
>
> -       /* Mark the fault->page dirty only if the fault is handled successfully */
> -       if (fault->writable && !ret)
> -               mark_page_dirty_in_slot(kvm, s2fd->memslot, get_canonical_gfn(s2fd, fault));
> +       /* Mark the page dirty only if the fault is handled successfully */
> +       if (fault->writable && !ret) {
> +               phys_addr_t ipa = gfn_to_gpa(get_canonical_gfn(s2fd, s2vi));
> +               ipa &= ~(mapping_size - 1);
> +               mark_page_dirty_in_slot(kvm, s2fd->memslot, gpa_to_gfn(ipa));
> +       }
>
>         if (ret != -EAGAIN)
>                 return ret;
> @@ -1978,6 +1986,7 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>  {
>         bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
>         bool logging_active = memslot_is_logging(s2fd->memslot);
> +       struct kvm_s2_fault_vma_info s2vi = {};
>         struct kvm_s2_fault fault = {
>                 .logging_active = logging_active,
>                 .force_pte = logging_active,
> @@ -2002,17 +2011,17 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>          * Let's check if we will get back a huge fault->page backed by hugetlbfs, or
>          * get block mapping for device MMIO region.
>          */
> -       ret = kvm_s2_fault_pin_pfn(s2fd, &fault);
> +       ret = kvm_s2_fault_pin_pfn(s2fd, &fault, &s2vi);
>         if (ret != 1)
>                 return ret;
>
> -       ret = kvm_s2_fault_compute_prot(s2fd, &fault);
> +       ret = kvm_s2_fault_compute_prot(s2fd, &fault, &s2vi);
>         if (ret) {
>                 kvm_release_page_unused(fault.page);
>                 return ret;
>         }
>
> -       return kvm_s2_fault_map(s2fd, &fault, memcache);
> +       return kvm_s2_fault_map(s2fd, &fault, &s2vi, memcache);
>  }
>
>  /* Resolve the access fault by making the page young again. */
> --
> 2.47.3
>
