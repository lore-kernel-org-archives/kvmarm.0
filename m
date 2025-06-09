Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5278F11185
	for <kvmarm@lists.linux.dev>; Mon,  9 Jun 2025 07:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749452693; cv=none; b=HYXp7DFvgQOCIl0lkjTb4h8PyBRYvN0M5o6LFozfTQvRJqS5OPMjQWvm3DjPjjQ0+12SL5SPwtW2GiR4LRAa3XmRXnXx6MUp1DMIdZ3bu4nxSGm1j4yKWGbASc/PNREP3iy0po/nVIIX97BHvl+737Wd89dnhUx2DWaT5hKAJmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749452693; c=relaxed/simple;
	bh=bEzNOpILT4J/3KMb+dwJUDvfvYZcdKO0vE4maMecPVo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nuPtT9gz5G8Cceyn2063lVPuRrIjDnUI8QbuplMcmXmimkF6Z4uVdKzznCmH/38gv/mH57rJaMBd7/JIbwuuKrgny1RPbl912n8Gq9igsHEVXr6XjYQ5uVHvkCA6HOGT/zJMYW59Bk4YxCs20m/HRFav8Yje1tUNQa+l6Ddm0zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xxo2epaC; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xxo2epaC"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-47e9fea29easo509251cf.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Jun 2025 00:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749452691; x=1750057491; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+N3CGTr+tsr/uhnfC8qTP0YVw9wnzSW/U670sIzNZSM=;
        b=Xxo2epaCquucR27p+MlbOCZJuLKrm/OPu2EGPpwXUDIPHJ1kojFKGveZ1jxzdBmnOQ
         OA9HZMa56y2eE5IA/Zy9sy9iyg94kZlENVTld+/Av5OHQ1k+83j+eg6c0VRyipfWoqDC
         jWvFAj2rS494jaRoc7vDXmefVES7CPfkFhjuFwicNRmRtFiiroLb2OwrIiC4eEk/mbyc
         uWg6b3aICkHLx7EsYcrByM86Q8r9vgxjbCULYuDSWVJxkinQEICZbVOcjD7nfSxNs3Bt
         rwvxieaSLENCsUSiGAdCkBcL5K1DMXaD3GHnHIBJ2LYNeekFO7TwqFc1chXejBLRPvZx
         qRiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749452691; x=1750057491;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+N3CGTr+tsr/uhnfC8qTP0YVw9wnzSW/U670sIzNZSM=;
        b=TMIq+jWac9Czo7pKeq+SDJLaLm8lrtfPOezp1D0ZAGc2PM/mRuBNiY+CiixXXHEVEf
         jKY9XW+QafleBqZTtTFj3Pl5oi+vzEtsl0r91llejxuMbd5shrEOEozNMIQReNES56Ca
         4+qf+rTPgCAWv/YnnBZ2RSSjWJLNdAZ3IftIMReDJu71wwobg7KDgFEBNMQuJap4dHtZ
         YOq+4n7luOCddLDX+Rh6Ia8CFSsfZhQf3bVWOqcR9x+8VUQ9FaZGNBTamVnGuQCCeKa1
         6rlBTvg6voXj2jZyq3dKybC/Uf355ur8ItafV8weUP2V9Xe9++C7oLKwF1/PMvki8ZOY
         tEIA==
X-Forwarded-Encrypted: i=1; AJvYcCUQh6fR+y4JqgkxG6bZnim0W8W1k7ede5/lipvjV3S4jUGSfJEQChGhUILU+ioJu2CkOpNpp3U=@lists.linux.dev
X-Gm-Message-State: AOJu0YwJ0SxjuuCwl64ON9Q/KMT6Z7EK5ADTMLKM29vLXVm1oZRNhyt3
	h5Dm1fhaPFtjsEU+FlB63i+MbOn+31OvSwgwZETvK0znsohqQuxv4bVO2ufLcvQh0nRi5HmnIFa
	8SBvMb1/yUpmlfcicisSjodjwvw0OVmOFCZWh0Dwm
X-Gm-Gg: ASbGncvhVmeT6oFDLuoeq+8Qwt6iPvAQo+iPhnxfAYZ1ie1uVjPXNc5gQdlLjseczmj
	hDvrhBqVO4sNSaCAxgH8NlcSOI62npzCmJYE/brXucdB3U39w5iVQgi1NDUu7cWht+Kcq/T0AzD
	/fE4hze0os+pCV6MgkPFIM6yG9QRiN0lKXEPBxPMOhv0a9VeYULxjajg==
X-Google-Smtp-Source: AGHT+IH8qs+W58ZUawbbJmU7f5tqoqWC/1K6Dg90nbqErlCvF4kyP/X0ehbBnXN7pEfkdAYLTzbrBaCmKXCJr6F0rYI=
X-Received: by 2002:a05:622a:11c1:b0:494:b4dd:befd with SMTP id
 d75a77b69052e-4a6ef9d2c13mr5372561cf.8.1749452690788; Mon, 09 Jun 2025
 00:04:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-15-tabba@google.com>
 <3d9a15ff-fbb2-4e9a-b97b-c0e40eb23043@redhat.com>
In-Reply-To: <3d9a15ff-fbb2-4e9a-b97b-c0e40eb23043@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 9 Jun 2025 08:04:14 +0100
X-Gm-Features: AX0GCFsczmm-1bXIlO1Jg10AW7DfDInPlMUvClXpf3ptG11SFLUaa_qGeD9GUQs
Message-ID: <CA+EHjTzSWbw=Vrc+_4rEs_QsQ=6w44H4pGrJPtZeY8n=s4qZRw@mail.gmail.com>
Subject: Re: [PATCH v11 14/18] KVM: arm64: Handle guest_memfd-backed guest
 page faults
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

On Mon, 9 Jun 2025 at 05:08, Gavin Shan <gshan@redhat.com> wrote:
>
> Hi Fuad,
>
> On 6/6/25 1:37 AM, Fuad Tabba wrote:
> > Add arm64 support for handling guest page faults on guest_memfd backed
> > memslots. Until guest_memfd supports huge pages, the fault granule is
> > restricted to PAGE_SIZE.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >   arch/arm64/kvm/mmu.c | 93 ++++++++++++++++++++++++++++++++++++++++++--
> >   1 file changed, 90 insertions(+), 3 deletions(-)
> >
>
> One comment below. Otherwise, it looks good to me.
>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
>
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index ce80be116a30..f14925fe6144 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1508,6 +1508,89 @@ static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
> >       *prot |= kvm_encode_nested_level(nested);
> >   }
> >
> > +#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
> > +
> > +static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > +                   struct kvm_s2_trans *nested,
> > +                   struct kvm_memory_slot *memslot, bool is_perm)
> > +{
> > +     bool logging, write_fault, exec_fault, writable;
> > +     enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
> > +     enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> > +     struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> > +     struct page *page;
> > +     struct kvm *kvm = vcpu->kvm;
> > +     void *memcache;
> > +     kvm_pfn_t pfn;
> > +     gfn_t gfn;
> > +     int ret;
> > +
> > +     ret = prepare_mmu_memcache(vcpu, !is_perm, &memcache);
> > +     if (ret)
> > +             return ret;
> > +
> > +     if (nested)
> > +             gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
> > +     else
> > +             gfn = fault_ipa >> PAGE_SHIFT;
> > +
> > +     logging = memslot_is_logging(memslot);
> > +     write_fault = kvm_is_write_fault(vcpu);
> > +     exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> > +
> > +     if (write_fault && exec_fault) {
> > +             kvm_err("Simultaneous write and execution fault\n");
> > +             return -EFAULT;
> > +     }
> > +
> > +     if (is_perm && !write_fault && !exec_fault) {
> > +             kvm_err("Unexpected L2 read permission error\n");
> > +             return -EFAULT;
> > +     }
> > +
> > +     ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
> > +     if (ret) {
> > +             kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
> > +                                           write_fault, exec_fault, false);
> > +             return ret;
> > +     }
> > +
>
> -EFAULT or -EHWPOISON shall be returned, as documented in virt/kvm/api.rst. Besides,
> kvm_send_hwpoison_signal() should be executed when -EHWPOISON is returned from
> kvm_gmem_get_pfn()? :-)

This is a bit different since we don't have a VMA. Refer to the discussion here:

https://lore.kernel.org/all/20250514212653.1011484-1-jthoughton@google.com/

Thanks!
/fuad

> Thanks,
> Gavin
>
> > +     writable = !(memslot->flags & KVM_MEM_READONLY) &&
> > +                (!logging || write_fault);
> > +
> > +     if (nested)
> > +             adjust_nested_fault_perms(nested, &prot, &writable);
> > +
> > +     if (writable)
> > +             prot |= KVM_PGTABLE_PROT_W;
> > +
> > +     if (exec_fault ||
> > +         (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
> > +          (!nested || kvm_s2_trans_executable(nested))))
> > +             prot |= KVM_PGTABLE_PROT_X;
> > +
> > +     kvm_fault_lock(kvm);
> > +     if (is_perm) {
> > +             /*
> > +              * Drop the SW bits in favour of those stored in the
> > +              * PTE, which will be preserved.
> > +              */
> > +             prot &= ~KVM_NV_GUEST_MAP_SZ;
> > +             ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, fault_ipa, prot, flags);
> > +     } else {
> > +             ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, PAGE_SIZE,
> > +                                          __pfn_to_phys(pfn), prot,
> > +                                          memcache, flags);
> > +     }
> > +     kvm_release_faultin_page(kvm, page, !!ret, writable);
> > +     kvm_fault_unlock(kvm);
> > +
> > +     if (writable && !ret)
> > +             mark_page_dirty_in_slot(kvm, memslot, gfn);
> > +
> > +     return ret != -EAGAIN ? ret : 0;
> > +}
> > +
> >   static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >                         struct kvm_s2_trans *nested,
> >                         struct kvm_memory_slot *memslot, unsigned long hva,
> > @@ -1532,7 +1615,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >       enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> >       struct kvm_pgtable *pgt;
> >       struct page *page;
> > -     enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
> > +     enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
> >
> >       if (fault_is_perm)
> >               fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
> > @@ -1959,8 +2042,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> >               goto out_unlock;
> >       }
> >
> > -     ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
> > -                          esr_fsc_is_permission_fault(esr));
> > +     if (kvm_slot_has_gmem(memslot))
> > +             ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
> > +                              esr_fsc_is_permission_fault(esr));
> > +     else
> > +             ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
> > +                                  esr_fsc_is_permission_fault(esr));
> >       if (ret == 0)
> >               ret = 1;
> >   out:
>
