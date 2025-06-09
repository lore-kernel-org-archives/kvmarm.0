Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF3325A353
	for <kvmarm@lists.linux.dev>; Mon,  9 Jun 2025 07:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749452519; cv=none; b=kc0HEJOX6mmCxdiYpHJPdG1/2rG7IIl0TpvMCHIl0MrhIt35k6yyS54xYkGO5IGiuYxKmMNea/BXzT0Ku6l7FnvOLahZwYkHcWxnh7MF68/rgVfBGp0CCgaT0nmqwS4eSd8cOUccxZYxS/F4UZwFrZpYfCFMoA9NJ+XYVS+biqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749452519; c=relaxed/simple;
	bh=aRx90mh4DBsB382qZLbUgE6k75728wG4XEm7SKbHgaU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G/IjsTi3M3iZz5V7r7IbO9f8IxIMS8DjjLr6em6xNWts+PRiK0a0x0Ch3MCBA3Hp7ZE28wrxDjw37U89V7QXKXSv/5Z1IamOzVIREykc8peiaTm69rfHtKONU39ltk2QEMheNOXZCUZ7i0da6SbCcQttg0aLG4CEN8CoOCQ91BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sOsVT1ZJ; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sOsVT1ZJ"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4a58ef58a38so322931cf.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Jun 2025 00:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749452515; x=1750057315; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qd1ChU4RfLFVxxmL2KzsgjziSyYF1OUEgK3hVJNjklY=;
        b=sOsVT1ZJFiIMQIjVxZbg/TOXl/CNRtxpEmROt/gXfubkIeKEOWaVQzzLYc9+q4Eqwj
         0c4bOX2Ny3nrgR08C175at3H9jgCJMQS1L18mJxkH7OFBLP8+mmKCFzwEpyRmQyPM6ZW
         HduGaqhEwV4W6GTj8uTyeGK/2W+XZBkyk7OOe7/0/PtSf5EBA+QngNIl8CP9nQ/wGcax
         C3rlTRYmI/Ry3PdiZGSj4vlqkjxbvu+IjknC5+je6ZSOpBzbtkjGyJ8UbuR9wvBbg6dt
         Et+XWTNO3Lm0E+RVT/2v2NUjXl2nzOdmsZjpq6zOjinL3SfA4aP0qCIsB4GjGpK9DnEr
         RIFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749452515; x=1750057315;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qd1ChU4RfLFVxxmL2KzsgjziSyYF1OUEgK3hVJNjklY=;
        b=CbChFYoazu3oE6/oWK1VKHmCjspkGtSh+03InRENzKcpOdSidved4VAPdhi0hAlRjr
         OLMuFJfokFshx9un9LVlbtqVfZMh6e9MV9JKprti3UA3MBkvgg1cGhXOpw2RSfbPVj6I
         rPANW8UaKi16XwX5F9xRXSXghv1drmVTZ9ceG9v/owE4tlG5tF+/ySncBD1bKC9qn+r5
         kN9SMMoaQXFHxEnugBPloFYL0J2rLeCPTQshkBsgWzNeLHvFFogKlw1KOASPtXRqLJlR
         MfAX2o2OOCr2Drdylsm5V2jq8ZM4SW1vqHUlLm5o1GkNStQ3qIi2Etw7pCHtJeR0EDfu
         y8bQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsfx4cwl39mHl/abRl8SBIylKvQ1Q//zv3FjkvfizupN5Bn+wMnpeg17Um0v6Oz3HdtavmJK0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1/AW+gSb58S9nicLejXaX7LAikrGBCW97jA2A9fz8cxRAx+jM
	KGhBtdVEQhD4k5KhUT2kt3o5h6XwSR6CPpZAGiTRMY17waprzPvaWjnI2KQd7C7SOB97DMIFuDv
	KGXpLJyMOMCUSLPYHMLaOZzrM8hlIjYHgcVYU/E+u
X-Gm-Gg: ASbGncvQWbVs3o9EVtKw9kWSelmWzk0QU8XHFEzOSgVn84HCsoJgTG/4pY1mbvZUaSh
	uolJui9k+ugZUeNLsgkIdt1q/kE+dJiM/xIoAN74cFyz/lcc2NP7QAjaFQEPdRImSIWj5J1tXUr
	zL7ia3Kqk2clBYZh2CajOlXjXpkvCa8xv3Asz7C3FzZMi0ImvuDL/waw==
X-Google-Smtp-Source: AGHT+IEYTjTPB44LdkojWXh1DgFtqgfjL8IG40gv9XwgF99n42jhj0tJV9OMy0pM+Kly1ld8fJ7D+mY65UKD6ViNkf0=
X-Received: by 2002:a05:622a:189a:b0:494:4aa0:ad5b with SMTP id
 d75a77b69052e-4a6ef9d0503mr6371521cf.2.1749452514924; Mon, 09 Jun 2025
 00:01:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-14-tabba@google.com>
 <a4e63374-8b4f-4800-a638-35ff343f78d2@redhat.com>
In-Reply-To: <a4e63374-8b4f-4800-a638-35ff343f78d2@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 9 Jun 2025 08:01:17 +0100
X-Gm-Features: AX0GCFtueCmazOgupVxtUqJ3eDLk0zaHqIaK1R7EMlVz70IKr0ZL8XxR8nJ_svw
Message-ID: <CA+EHjTzYSZSQxh+97SSU7kg+S59CFMisF437wfAxnFRkfgUeFg@mail.gmail.com>
Subject: Re: [PATCH v11 13/18] KVM: arm64: Refactor user_mem_abort()
To: Gavin Shan <gshan@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

Hi Gavin,

On Mon, 9 Jun 2025 at 01:27, Gavin Shan <gshan@redhat.com> wrote:
>
> Hi Fuad,
>
> On 6/6/25 1:37 AM, Fuad Tabba wrote:
> > To simplify the code and to make the assumptions clearer,
> > refactor user_mem_abort() by immediately setting force_pte to
> > true if the conditions are met.
> >
> > Remove the comment about logging_active being guaranteed to never be
> > true for VM_PFNMAP memslots, since it's not actually correct.
> >
> > Move code that will be reused in the following patch into separate
> > functions.
> >
> > Other small instances of tidying up.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >   arch/arm64/kvm/mmu.c | 100 ++++++++++++++++++++++++-------------------
> >   1 file changed, 55 insertions(+), 45 deletions(-)
> >
>
> One nitpick below in case v12 is needed. In either way, it looks good to me:
>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
>
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index eeda92330ade..ce80be116a30 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1466,13 +1466,56 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
> >       return vma->vm_flags & VM_MTE_ALLOWED;
> >   }
> >
> > +static int prepare_mmu_memcache(struct kvm_vcpu *vcpu, bool topup_memcache,
> > +                             void **memcache)
> > +{
> > +     int min_pages;
> > +
> > +     if (!is_protected_kvm_enabled())
> > +             *memcache = &vcpu->arch.mmu_page_cache;
> > +     else
> > +             *memcache = &vcpu->arch.pkvm_memcache;
> > +
> > +     if (!topup_memcache)
> > +             return 0;
> > +
>
> It's unnecessary to initialize 'memcache' when topup_memcache is false.

I thought about this before, and I _think_ you're right. However, I
couldn't completely convince myself that that's always the case for
the code to be functionally equivalent (looking at the condition for
kvm_pgtable_stage2_relax_perms() at the end of the function). Which is
why, if I were to do that, I'd do it as a separate patch.

Thanks,
/fuad

>         if (!topup_memcache)
>                 return 0;
>
>         min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
>         if (!is_protected_kvm_enabled())
>                 *memcache = &vcpu->arch.mmu_page_cache;
>         else
>                 *memcache = &vcpu->arch.pkvm_memcache;
>
> Thanks,
> Gavin
>
> > +     min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
> > +
> > +     if (!is_protected_kvm_enabled())
> > +             return kvm_mmu_topup_memory_cache(*memcache, min_pages);
> > +
> > +     return topup_hyp_memcache(*memcache, min_pages);
> > +}
> > +
> > +/*
> > + * Potentially reduce shadow S2 permissions to match the guest's own S2. For
> > + * exec faults, we'd only reach this point if the guest actually allowed it (see
> > + * kvm_s2_handle_perm_fault).
> > + *
> > + * Also encode the level of the original translation in the SW bits of the leaf
> > + * entry as a proxy for the span of that translation. This will be retrieved on
> > + * TLB invalidation from the guest and used to limit the invalidation scope if a
> > + * TTL hint or a range isn't provided.
> > + */
> > +static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
> > +                                   enum kvm_pgtable_prot *prot,
> > +                                   bool *writable)
> > +{
> > +     *writable &= kvm_s2_trans_writable(nested);
> > +     if (!kvm_s2_trans_readable(nested))
> > +             *prot &= ~KVM_PGTABLE_PROT_R;
> > +
> > +     *prot |= kvm_encode_nested_level(nested);
> > +}
> > +
> >   static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >                         struct kvm_s2_trans *nested,
> >                         struct kvm_memory_slot *memslot, unsigned long hva,
> >                         bool fault_is_perm)
> >   {
> >       int ret = 0;
> > -     bool write_fault, writable, force_pte = false;
> > +     bool topup_memcache;
> > +     bool write_fault, writable;
> >       bool exec_fault, mte_allowed;
> >       bool device = false, vfio_allow_any_uc = false;
> >       unsigned long mmu_seq;
> > @@ -1484,6 +1527,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >       gfn_t gfn;
> >       kvm_pfn_t pfn;
> >       bool logging_active = memslot_is_logging(memslot);
> > +     bool force_pte = logging_active || is_protected_kvm_enabled();
> >       long vma_pagesize, fault_granule;
> >       enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> >       struct kvm_pgtable *pgt;
> > @@ -1501,28 +1545,16 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >               return -EFAULT;
> >       }
> >
> > -     if (!is_protected_kvm_enabled())
> > -             memcache = &vcpu->arch.mmu_page_cache;
> > -     else
> > -             memcache = &vcpu->arch.pkvm_memcache;
> > -
> >       /*
> >        * Permission faults just need to update the existing leaf entry,
> >        * and so normally don't require allocations from the memcache. The
> >        * only exception to this is when dirty logging is enabled at runtime
> >        * and a write fault needs to collapse a block entry into a table.
> >        */
> > -     if (!fault_is_perm || (logging_active && write_fault)) {
> > -             int min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
> > -
> > -             if (!is_protected_kvm_enabled())
> > -                     ret = kvm_mmu_topup_memory_cache(memcache, min_pages);
> > -             else
> > -                     ret = topup_hyp_memcache(memcache, min_pages);
> > -
> > -             if (ret)
> > -                     return ret;
> > -     }
> > +     topup_memcache = !fault_is_perm || (logging_active && write_fault);
> > +     ret = prepare_mmu_memcache(vcpu, topup_memcache, &memcache);
> > +     if (ret)
> > +             return ret;
> >
> >       /*
> >        * Let's check if we will get back a huge page backed by hugetlbfs, or
> > @@ -1536,16 +1568,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >               return -EFAULT;
> >       }
> >
> > -     /*
> > -      * logging_active is guaranteed to never be true for VM_PFNMAP
> > -      * memslots.
> > -      */
> > -     if (logging_active || is_protected_kvm_enabled()) {
> > -             force_pte = true;
> > +     if (force_pte)
> >               vma_shift = PAGE_SHIFT;
> > -     } else {
> > +     else
> >               vma_shift = get_vma_page_shift(vma, hva);
> > -     }
> >
> >       switch (vma_shift) {
> >   #ifndef __PAGETABLE_PMD_FOLDED
> > @@ -1597,7 +1623,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >                       max_map_size = PAGE_SIZE;
> >
> >               force_pte = (max_map_size == PAGE_SIZE);
> > -             vma_pagesize = min(vma_pagesize, (long)max_map_size);
> > +             vma_pagesize = min_t(long, vma_pagesize, max_map_size);
> >       }
> >
> >       /*
> > @@ -1626,7 +1652,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >        * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
> >        * with the smp_wmb() in kvm_mmu_invalidate_end().
> >        */
> > -     mmu_seq = vcpu->kvm->mmu_invalidate_seq;
> > +     mmu_seq = kvm->mmu_invalidate_seq;
> >       mmap_read_unlock(current->mm);
> >
> >       pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
> > @@ -1661,24 +1687,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >       if (exec_fault && device)
> >               return -ENOEXEC;
> >
> > -     /*
> > -      * Potentially reduce shadow S2 permissions to match the guest's own
> > -      * S2. For exec faults, we'd only reach this point if the guest
> > -      * actually allowed it (see kvm_s2_handle_perm_fault).
> > -      *
> > -      * Also encode the level of the original translation in the SW bits
> > -      * of the leaf entry as a proxy for the span of that translation.
> > -      * This will be retrieved on TLB invalidation from the guest and
> > -      * used to limit the invalidation scope if a TTL hint or a range
> > -      * isn't provided.
> > -      */
> > -     if (nested) {
> > -             writable &= kvm_s2_trans_writable(nested);
> > -             if (!kvm_s2_trans_readable(nested))
> > -                     prot &= ~KVM_PGTABLE_PROT_R;
> > -
> > -             prot |= kvm_encode_nested_level(nested);
> > -     }
> > +     if (nested)
> > +             adjust_nested_fault_perms(nested, &prot, &writable);
> >
> >       kvm_fault_lock(kvm);
> >       pgt = vcpu->arch.hw_mmu->pgt;
>
