Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640F33A6406
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 10:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773743252; cv=pass; b=DYkwg03j+kcroBPVMlPsC4cZL2LfDjWHoTWk3W75s+X1PNAaswcMDf5wLOBO3+bD+Jpq6vMVYP2x8WeGznf6zvEEMNH14WHhRdeawVjx+HXgpNw7v+Q/UwzE5PX+enbsrjX7IDom6MYaijHEOiQLCZy21c194HkCkCUtrxohX9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773743252; c=relaxed/simple;
	bh=2Xd5M50xCa8Djj5uatW4VeWyyR7Dmjndp5CqvF8cFk8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kjoQiiZuHbb0kDoP28Q/wtU4S2f7Y/z4NFtJK7RE2FBJJIpSXn8N/tVQTUEJKLKuuJf8kB61fU80wvFO/dMC+fVZV0rRp8pNcyEF1HgoyXuwgGpNm9aZTeFxsqWsBlfr2vgpybyPhC6Nkh3fSBqzJ11huKrnU9xEbCsqIU57dQQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kuxv8XKZ; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kuxv8XKZ"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5091ed02c54so340381cf.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 03:27:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773743249; cv=none;
        d=google.com; s=arc-20240605;
        b=FM9KNn6cAMJuRx2QLve8XVwv4Z4rTtxAQDrLA62AIeqQwfVNRU4hV2LFcnHRui1uwV
         /ZUrX09dMBxm6SGF7+KXsbPOpIC3V70LPPGSn+SfqW20kXdUuuuAA9ZxU+rN1bRw1HNb
         uBEb/OJ0V/DWMOlQHJT4D80gLqeujW3RTQrcuUm0mdEcsz1zWe+HNCYiOao+FA0Kssxp
         u0c81um1dz4+WoVvmESaAv7WKaxaYegRp8Y/oV93zdmIIXYgL1Jd11upXQIm7NnEmhEg
         Sp9Xn4n7rq/2y771eLiIT530y3PmJR5VQc6V58A+2lKNFYolXJ9zOgGq8ToqmbyZWyN5
         9UFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6z2QesgUHrW6ujbflxaKSakZAZnvUy6jDbI7p8UXByU=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=hdbt9671GSywZx7M+LP4a4tgQhOF/vUe+HEClDcnJCdCfRj5/NvgdJtgFNSfv4h1LR
         hfsz30+cZXru4hWy1/TBmUsAMTr3NyPgBPq5caK2MJu0E+wPO7hb3oDqqoB4Uo8CusXR
         hwJWnde/LBuI//7BFXFSM0hJPBhTLhq7JrQ4ggxKuyKEdMVm+JX7di4VD1wwKnRlpm+y
         6FyX8I2zxUuqOcHFhPRm/i6/tpTCphnFo8gGUVnX60ExpFVck+Oc/fLZyVpe8AyiqmwQ
         u+rMxvxgNLOg40ZDeYX83LA2Tsz81p4yW23ZyLlkeh8RsxsYNe8bKUfxSIb3Ft9bZ6aB
         7UqQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773743249; x=1774348049; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6z2QesgUHrW6ujbflxaKSakZAZnvUy6jDbI7p8UXByU=;
        b=kuxv8XKZFFNzmU0D7EAdr/yJ8/9iy6bpjwdu1+BmAZmV7IeJ9EWINligu4ACwj1JOK
         9uTCo2oE37qk/BS9dgrN5z173B/hZgsOPRcv67q5uXH9Q5S9uR8Q+9NpwNB0FG/02g05
         1Cw9ord1jsU6qcFajnCdiSvfB9NQTvZCOvjPLkB/5uUfmoPTn1oeo+1OEoA0oZnxb22o
         DFu1W75fUrMY9e5h3jVlAwSpdCYR8DrwijOHve+4gzce1i+hX2IL7op+nn5L6XdwnHoV
         R16MU6baFj5tIHFlI2OhluEQuU80iWOPXgVSuKm2pASfz4CBvXoZR6xUZzI9Pc/Ys5F9
         aYOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773743249; x=1774348049;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6z2QesgUHrW6ujbflxaKSakZAZnvUy6jDbI7p8UXByU=;
        b=TI+eBVUMukRV4c1DD5k/sTr649AiQ1eRFbSa35q1bU1pCmYEVxbdvN2BnhipnvIioc
         dxDvPRKtBoYDECkWo4LW1XiQcdSAaG4h747HLx2Q5W2CmhTw0VgtEGfZwWQDKE+HQJxe
         5+kTTnIAN6ODRzahRTcRzrZtOwjD2La7kzp3q8M0SDcB5tbBXscNoXFV+XMsNuRlouB4
         uv+uIIU3QId5I9O7hdJ5nvAYRBk2cqtQVak7GDeXSVWwNSckDuLTulEUwnGH2nqFXlRN
         05RTiuQdcTqjoMeCnc1T/GiSr8zmCROdP1vdljJk0SsMqiz8vZKxHZX7Qw1y1eeJcHyS
         T+2w==
X-Gm-Message-State: AOJu0YzoqyN/I2ng4WKT505sNGti8i1cDbm4JhoqEX5g3UcZo4/MZ0Pf
	gK+4JWQUOIMPS1l0vnyLjbFaasczoRuxzD+Q6rUhwHhuIq0HOiDQxh4Gc0Ae9Fs8dVniBvvvzXX
	PJSyYQy2lOgmx7EWmHSpv2uYz2NGVYFwbXLilee+h
X-Gm-Gg: ATEYQzwvqRTSDJUirwOrBJu264OMnBdbBX1Qzb7p7Na5wnXhzDvBR83TECH8Jtd3JUx
	IRRpdvIgBwimDQaOtnF2IKScXNdsFc6iQwHvW0Vr2lgJW8zfc3stGhpxzwqlzwwISqT0vlQas/S
	3SiYHNmbZx+HXq4MVhd1gMaeT8rlsdru9Ab1zPuCuqvYIdJvBldlNMTPfoNDqFpMbccppHzJu+E
	qjpDWmDc7R9doi2MDtXKDAQIoIMNIJqoQs1cvDYDyELOB9J4V8/gfhA4jhGVizjhpGAPQ/4rHwe
	l6/BVFyCYMIu4u+QhcfKbPDsf+u6NyYXq8Cn
X-Received: by 2002:ac8:57c7:0:b0:501:3b94:bcae with SMTP id
 d75a77b69052e-50998d2b71amr13100431cf.8.1773743248721; Tue, 17 Mar 2026
 03:27:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316175451.1866175-1-maz@kernel.org> <20260316175451.1866175-4-maz@kernel.org>
In-Reply-To: <20260316175451.1866175-4-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Mar 2026 10:26:51 +0000
X-Gm-Features: AaiRm52HtiPqd9e-rProreG2CqS-RI4t2RwOOd-r6myF45LuqD4GGHks47r9O8I
Message-ID: <CA+EHjTxE1T5TC2EnaUPDF2_wtMi8RgbTntYep8_YQE73x7t1CA@mail.gmail.com>
Subject: Re: [PATCH 03/17] KVM: arm64: Move fault context to const structure
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Mar 2026 at 17:55, Marc Zyngier <maz@kernel.org> wrote:
>
> In order to make it clearer what gets updated or not during fault
> handling, move a set of information that losely represents the
> fault context.
>
> This gets populated early, from handle_mem_abort(), and gets passed
> along as a const pointer. user_mem_abort()'s signature is majorly
> improved in doing so, and kvm_s2_fault loses a bunch of fields.
>
> gmem_abort() will get a similar treatment down the line.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/mmu.c | 133 ++++++++++++++++++++++---------------------
>  1 file changed, 69 insertions(+), 64 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index ab8a269d4366d..2a7128b8dd14f 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1640,23 +1640,28 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         return ret != -EAGAIN ? ret : 0;
>  }
>
> -static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
> -                                    unsigned long hva,
> -                                    struct kvm_memory_slot *memslot,
> -                                    struct kvm_s2_trans *nested,
> -                                    bool *force_pte)
> +struct kvm_s2_fault_desc {
> +       struct kvm_vcpu         *vcpu;
> +       phys_addr_t             fault_ipa;
> +       struct kvm_s2_trans     *nested;
> +       struct kvm_memory_slot  *memslot;
> +       unsigned long           hva;
> +};
> +
> +static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
> +                                    struct vm_area_struct *vma, bool *force_pte)
>  {
>         short vma_shift;
>
>         if (*force_pte)
>                 vma_shift = PAGE_SHIFT;
>         else
> -               vma_shift = get_vma_page_shift(vma, hva);
> +               vma_shift = get_vma_page_shift(vma, s2fd->hva);
>
>         switch (vma_shift) {
>  #ifndef __PAGETABLE_PMD_FOLDED
>         case PUD_SHIFT:
> -               if (fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
> +               if (fault_supports_stage2_huge_mapping(s2fd->memslot, s2fd->hva, PUD_SIZE))
>                         break;
>                 fallthrough;
>  #endif
> @@ -1664,7 +1669,7 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
>                 vma_shift = PMD_SHIFT;
>                 fallthrough;
>         case PMD_SHIFT:
> -               if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE))
> +               if (fault_supports_stage2_huge_mapping(s2fd->memslot, s2fd->hva, PMD_SIZE))
>                         break;
>                 fallthrough;
>         case CONT_PTE_SHIFT:
> @@ -1677,7 +1682,7 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
>                 WARN_ONCE(1, "Unknown vma_shift %d", vma_shift);
>         }
>
> -       if (nested) {
> +       if (s2fd->nested) {
>                 unsigned long max_map_size;
>
>                 max_map_size = *force_pte ? PAGE_SIZE : PUD_SIZE;
> @@ -1687,7 +1692,7 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
>                  * can only create a block mapping if the guest stage 2 page
>                  * table uses at least as big a mapping.
>                  */
> -               max_map_size = min(kvm_s2_trans_size(nested), max_map_size);
> +               max_map_size = min(kvm_s2_trans_size(s2fd->nested), max_map_size);
>
>                 /*
>                  * Be careful that if the mapping size falls between
> @@ -1706,11 +1711,6 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
>  }
>
>  struct kvm_s2_fault {
> -       struct kvm_vcpu *vcpu;
> -       phys_addr_t fault_ipa;
> -       struct kvm_s2_trans *nested;
> -       struct kvm_memory_slot *memslot;
> -       unsigned long hva;
>         bool fault_is_perm;
>
>         bool write_fault;
> @@ -1732,28 +1732,28 @@ struct kvm_s2_fault {
>         vm_flags_t vm_flags;
>  };
>
> -static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
> +static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
> +                                    struct kvm_s2_fault *fault)
>  {
>         struct vm_area_struct *vma;
> -       struct kvm *kvm = fault->vcpu->kvm;
> +       struct kvm *kvm = s2fd->vcpu->kvm;
>
>         mmap_read_lock(current->mm);
> -       vma = vma_lookup(current->mm, fault->hva);
> +       vma = vma_lookup(current->mm, s2fd->hva);
>         if (unlikely(!vma)) {
> -               kvm_err("Failed to find VMA for fault->hva 0x%lx\n", fault->hva);
> +               kvm_err("Failed to find VMA for hva 0x%lx\n", s2fd->hva);
>                 mmap_read_unlock(current->mm);
>                 return -EFAULT;
>         }
>
> -       fault->vma_pagesize = 1UL << kvm_s2_resolve_vma_size(vma, fault->hva, fault->memslot,
> -                                                            fault->nested, &fault->force_pte);
> +       fault->vma_pagesize = BIT(kvm_s2_resolve_vma_size(s2fd, vma, &fault->force_pte));
>
>         /*
>          * Both the canonical IPA and fault IPA must be aligned to the
>          * mapping size to ensure we find the right PFN and lay down the
>          * mapping in the right place.
>          */
> -       fault->gfn = ALIGN_DOWN(fault->fault_ipa, fault->vma_pagesize) >> PAGE_SHIFT;
> +       fault->gfn = ALIGN_DOWN(s2fd->fault_ipa, fault->vma_pagesize) >> PAGE_SHIFT;
>
>         fault->mte_allowed = kvm_vma_mte_allowed(vma);
>
> @@ -1775,31 +1775,33 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
>         return 0;
>  }
>
> -static gfn_t get_canonical_gfn(struct kvm_s2_fault *fault)
> +static gfn_t get_canonical_gfn(const struct kvm_s2_fault_desc *s2fd,
> +                              const struct kvm_s2_fault *fault)
>  {
>         phys_addr_t ipa;
>
> -       if (!fault->nested)
> +       if (!s2fd->nested)
>                 return fault->gfn;
>
> -       ipa = kvm_s2_trans_output(fault->nested);
> +       ipa = kvm_s2_trans_output(s2fd->nested);
>         return ALIGN_DOWN(ipa, fault->vma_pagesize) >> PAGE_SHIFT;
>  }
>
> -static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
> +static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
> +                               struct kvm_s2_fault *fault)
>  {
>         int ret;
>
> -       ret = kvm_s2_fault_get_vma_info(fault);
> +       ret = kvm_s2_fault_get_vma_info(s2fd, fault);
>         if (ret)
>                 return ret;
>
> -       fault->pfn = __kvm_faultin_pfn(fault->memslot, get_canonical_gfn(fault),
> +       fault->pfn = __kvm_faultin_pfn(s2fd->memslot, get_canonical_gfn(s2fd, fault),
>                                        fault->write_fault ? FOLL_WRITE : 0,
>                                        &fault->writable, &fault->page);
>         if (unlikely(is_error_noslot_pfn(fault->pfn))) {
>                 if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
> -                       kvm_send_hwpoison_signal(fault->hva, __ffs(fault->vma_pagesize));
> +                       kvm_send_hwpoison_signal(s2fd->hva, __ffs(fault->vma_pagesize));
>                         return 0;
>                 }
>                 return -EFAULT;
> @@ -1808,9 +1810,10 @@ static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
>         return 1;
>  }
>
> -static int kvm_s2_fault_compute_prot(struct kvm_s2_fault *fault)
> +static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
> +                                    struct kvm_s2_fault *fault)
>  {
> -       struct kvm *kvm = fault->vcpu->kvm;
> +       struct kvm *kvm = s2fd->vcpu->kvm;
>
>         /*
>          * Check if this is non-struct page memory PFN, and cannot support
> @@ -1862,13 +1865,13 @@ static int kvm_s2_fault_compute_prot(struct kvm_s2_fault *fault)
>          * and trigger the exception here. Since the memslot is valid, inject
>          * the fault back to the guest.
>          */
> -       if (esr_fsc_is_excl_atomic_fault(kvm_vcpu_get_esr(fault->vcpu))) {
> -               kvm_inject_dabt_excl_atomic(fault->vcpu, kvm_vcpu_get_hfar(fault->vcpu));
> +       if (esr_fsc_is_excl_atomic_fault(kvm_vcpu_get_esr(s2fd->vcpu))) {
> +               kvm_inject_dabt_excl_atomic(s2fd->vcpu, kvm_vcpu_get_hfar(s2fd->vcpu));
>                 return 1;
>         }
>
> -       if (fault->nested)
> -               adjust_nested_fault_perms(fault->nested, &fault->prot, &fault->writable);
> +       if (s2fd->nested)
> +               adjust_nested_fault_perms(s2fd->nested, &fault->prot, &fault->writable);
>
>         if (fault->writable)
>                 fault->prot |= KVM_PGTABLE_PROT_W;
> @@ -1882,8 +1885,8 @@ static int kvm_s2_fault_compute_prot(struct kvm_s2_fault *fault)
>         else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
>                 fault->prot |= KVM_PGTABLE_PROT_X;
>
> -       if (fault->nested)
> -               adjust_nested_exec_perms(kvm, fault->nested, &fault->prot);
> +       if (s2fd->nested)
> +               adjust_nested_exec_perms(kvm, s2fd->nested, &fault->prot);
>
>         if (!fault->fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm)) {
>                 /* Check the VMM hasn't introduced a new disallowed VMA */
> @@ -1899,15 +1902,16 @@ static phys_addr_t get_ipa(const struct kvm_s2_fault *fault)
>         return gfn_to_gpa(fault->gfn);
>  }
>
> -static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
> +static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
> +                           struct kvm_s2_fault *fault, void *memcache)
>  {
> -       struct kvm *kvm = fault->vcpu->kvm;
> +       struct kvm *kvm = s2fd->vcpu->kvm;
>         struct kvm_pgtable *pgt;
>         int ret;
>         enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
>
>         kvm_fault_lock(kvm);
> -       pgt = fault->vcpu->arch.hw_mmu->pgt;
> +       pgt = s2fd->vcpu->arch.hw_mmu->pgt;
>         ret = -EAGAIN;
>         if (mmu_invalidate_retry(kvm, fault->mmu_seq))
>                 goto out_unlock;
> @@ -1921,8 +1925,8 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
>                 if (fault->fault_is_perm && fault->fault_granule > PAGE_SIZE) {
>                         fault->vma_pagesize = fault->fault_granule;
>                 } else {
> -                       fault->vma_pagesize = transparent_hugepage_adjust(kvm, fault->memslot,
> -                                                                         fault->hva, &fault->pfn,
> +                       fault->vma_pagesize = transparent_hugepage_adjust(kvm, s2fd->memslot,
> +                                                                         s2fd->hva, &fault->pfn,
>                                                                           &fault->gfn);
>
>                         if (fault->vma_pagesize < 0) {
> @@ -1960,34 +1964,27 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
>
>         /* Mark the fault->page dirty only if the fault is handled successfully */
>         if (fault->writable && !ret)
> -               mark_page_dirty_in_slot(kvm, fault->memslot, get_canonical_gfn(fault));
> +               mark_page_dirty_in_slot(kvm, s2fd->memslot, get_canonical_gfn(s2fd, fault));
>
>         if (ret != -EAGAIN)
>                 return ret;
>         return 0;
>  }
>
> -static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> -                         struct kvm_s2_trans *nested,
> -                         struct kvm_memory_slot *memslot, unsigned long hva,
> -                         bool fault_is_perm)
> +static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>  {
> -       bool write_fault = kvm_is_write_fault(vcpu);
> -       bool logging_active = memslot_is_logging(memslot);
> +       bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
> +       bool write_fault = kvm_is_write_fault(s2fd->vcpu);
> +       bool logging_active = memslot_is_logging(s2fd->memslot);
>         struct kvm_s2_fault fault = {
> -               .vcpu = vcpu,
> -               .fault_ipa = fault_ipa,
> -               .nested = nested,
> -               .memslot = memslot,
> -               .hva = hva,
> -               .fault_is_perm = fault_is_perm,
> +               .fault_is_perm = perm_fault,
>                 .logging_active = logging_active,
>                 .force_pte = logging_active,
>                 .prot = KVM_PGTABLE_PROT_R,
> -               .fault_granule = fault_is_perm ? kvm_vcpu_trap_get_perm_fault_granule(vcpu) : 0,
> +               .fault_granule = perm_fault ? kvm_vcpu_trap_get_perm_fault_granule(s2fd->vcpu) : 0,
>                 .write_fault = write_fault,
> -               .exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu),
> -               .topup_memcache = !fault_is_perm || (logging_active && write_fault),
> +               .exec_fault = kvm_vcpu_trap_is_exec_fault(s2fd->vcpu),
> +               .topup_memcache = !perm_fault || (logging_active && write_fault),
>         };
>         void *memcache;
>         int ret;
> @@ -2000,7 +1997,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>          * only exception to this is when dirty logging is enabled at runtime
>          * and a write fault needs to collapse a block entry into a table.
>          */
> -       ret = prepare_mmu_memcache(vcpu, fault.topup_memcache, &memcache);
> +       ret = prepare_mmu_memcache(s2fd->vcpu, fault.topup_memcache, &memcache);
>         if (ret)
>                 return ret;
>
> @@ -2008,17 +2005,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>          * Let's check if we will get back a huge fault->page backed by hugetlbfs, or
>          * get block mapping for device MMIO region.
>          */
> -       ret = kvm_s2_fault_pin_pfn(&fault);
> +       ret = kvm_s2_fault_pin_pfn(s2fd, &fault);
>         if (ret != 1)
>                 return ret;
>
> -       ret = kvm_s2_fault_compute_prot(&fault);
> +       ret = kvm_s2_fault_compute_prot(s2fd, &fault);
>         if (ret) {
>                 kvm_release_page_unused(fault.page);
>                 return ret;
>         }
>
> -       return kvm_s2_fault_map(&fault, memcache);
> +       return kvm_s2_fault_map(s2fd, &fault, memcache);
>  }
>
>  /* Resolve the access fault by making the page young again. */
> @@ -2284,12 +2281,20 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>         VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
>                         !write_fault && !kvm_vcpu_trap_is_exec_fault(vcpu));
>
> +       const struct kvm_s2_fault_desc s2fd = {
> +               .vcpu           = vcpu,
> +               .fault_ipa      = fault_ipa,
> +               .nested         = nested,
> +               .memslot        = memslot,
> +               .hva            = hva,
> +       };
> +
>         if (kvm_slot_has_gmem(memslot))
>                 ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
>                                  esr_fsc_is_permission_fault(esr));
>         else
> -               ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
> -                                    esr_fsc_is_permission_fault(esr));
> +               ret = user_mem_abort(&s2fd);
> +
>         if (ret == 0)
>                 ret = 1;
>  out:
> --
> 2.47.3
>
>
