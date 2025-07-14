Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265EC21858E
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 06:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752474981; cv=none; b=Sw03+q6u9oIaML337MdUKpbiXKlBsmRiy2putQIKjIB5kVnWlN03wUIYSM75VcBoPYuM5GzIu/KEhRRIGFIq5AcVOpvGv7CH7wH0ooBPDVCr5q1WX4fEXtNNg3pbte/PNOcWZf3lPQjJOTN/a/xqbct+8ZgDjkvudtiZtnVv7js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752474981; c=relaxed/simple;
	bh=QE8xgqkvQss00D2u8wVq8zJ1bkSAtUbpo+nglj+nK7I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jBiW1h07YmgCn8GKfdZQZwmvxM0vtm97M6S3bpsfoXvOyVskubw6U97hNLHSXeHftPgq1KLtTSLJ8GftnGDHAeSw0bqOPdLE1ii7RtGwHZwlKeMqdVcWQf70bdxVQgD+H9D7oDGuH7+5uwJk2ea7LWL4aX4DUgSPLisYRL5y2gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hWTgPzuN; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hWTgPzuN"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4aa2cbc016dso314711cf.0
        for <kvmarm@lists.linux.dev>; Sun, 13 Jul 2025 23:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752474978; x=1753079778; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dZF+Ky0ktDSi2tu4HY/pzm8qU38Pe1SoFQA75nYTHJk=;
        b=hWTgPzuNP4SgMJKsz1d6nntmTqcwng0gZDPhmN++7xRMpLgpb7AMa+httScMTp/6jk
         eeAjsIz3dT00e/SNXKgh6AlFQN/ElDde1MQyKg9mTP5jd2a8KlLgPWmFmTWOMHBkQpsv
         QJBtnoMdVQxtfeTmNNITU7TVDhE3w7VaYoE+7XbI5sliWoTX2HMDg6VowuWGxRFcCQat
         h+ES2rnHv+Cz76qr037NFMyzxPDkmiVmx0JBTGf52OA9jGI9rHxyzvANSlL+N+cAyeMb
         e4O5vh7qOHd0MzrHLaFnnwBVE3xtjorXY2nNheaLO3caql/ywjVg2yP3fr1R6mbpLuMn
         aSwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752474978; x=1753079778;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dZF+Ky0ktDSi2tu4HY/pzm8qU38Pe1SoFQA75nYTHJk=;
        b=fJX/60OESQGenPEHUejH4kKQDAKxoEC8pXhditCOUWiGvSVnbnPEgYpasj6hB8qE7o
         Uzvt/w8h7hJtZDwzUOtxx298Ogyjlbng32pZXHK5yIchC/crYTnfuZHOjaqH/Utv4y+B
         23d/Sbc4lIfYRoc+IgmHurmvnEF1IHjhG5mmahYcWAKBO+EO3U7R+HO1O5uB7/geZfMS
         thZhkRLIiXQ+SGkZXuRJ+cxXbzub7LVYP8kb7QqaojepQXahHagZIJ4txMy91HTa2Tiu
         bYOtySSuQgIkSyQmiSq32ECZskTDsYS26ra0HxBjMDEKq1K0J6tvMdf97fOPqCGjfQae
         Rnkw==
X-Forwarded-Encrypted: i=1; AJvYcCXHiBhiDzeXS3Cfie9xz8gLCOBLX1vtU0G2NhK9TrXLqPtTLKVCIi+4DoH1X3DhvZuKxcdYvwg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxUKFp4TY/XlNFaNoQ+GUsKB61D9nC8yDoiiUMrhlFqzoS2PR9a
	w/LhkTPvm0WJool83Oxk0n4C5eTJNQz9+4w1Qc0yALDrQpxzkGVrYqWNxJ6MqQzOFNnzQOJFxgv
	4f3D4EFz4J2UaDYudUcaxNFCjfYxG0lQ2+4kmN5BE
X-Gm-Gg: ASbGncurFy3WZfoX4u8SXtW5tJaknlvYtk+RjzCBTXjr72VOkrwL4Khdx2IsL0RqQnR
	LofaQvFKOMaXKPef9OGwjD+QrRd45S+c/oYtNTmLmSjtttqINspRa1M6NTmLeDrfa+mCZ3tfRZl
	PcASwczedZTbpkcMOztv1BL1pXe7Q74smZvv/rsbxCGlfhH5+p8PHXkdpN3qoFmVhHhHyH04rVj
	+XB/uE=
X-Google-Smtp-Source: AGHT+IGUAkWGqNwyYlfnsIV6EkkPBFxL4VHZi8XE1tnkXrW7n/ZbY/7gbbYRwSh5UmMPS2fHVD8oBu3+Ej09sHNYdeM=
X-Received: by 2002:a05:622a:1450:b0:4a5:a83d:f50d with SMTP id
 d75a77b69052e-4ab544ec3a4mr4630431cf.11.1752474977130; Sun, 13 Jul 2025
 23:36:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250709105946.4009897-17-tabba@google.com> <20250711095937.22365-1-roypat@amazon.co.uk>
 <86a55aalbv.wl-maz@kernel.org> <CA+EHjTz-MWYUKA6dbcZGvt=rRXnorrpJHbNLq-Kng5q7yaLERA@mail.gmail.com>
 <867c0eafu4.wl-maz@kernel.org>
In-Reply-To: <867c0eafu4.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 14 Jul 2025 07:35:40 +0100
X-Gm-Features: Ac12FXz5OVPVA8v7QODq4KbEi6-bkk4Mp_oA-Ws0GJ1yiq68_TYv2mw4lRKzfA4
Message-ID: <CA+EHjTziOm5d-0M53hPzF3Naz+NQtNKZxJk_ZjmVv3MeX+h3Lg@mail.gmail.com>
Subject: Re: [PATCH v13 16/20] KVM: arm64: Handle guest_memfd-backed guest
 page faults
To: Marc Zyngier <maz@kernel.org>
Cc: "Roy, Patrick" <roypat@amazon.co.uk>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "amoorthy@google.com" <amoorthy@google.com>, 
	"anup@brainfault.org" <anup@brainfault.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"brauner@kernel.org" <brauner@kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "david@redhat.com" <david@redhat.com>, 
	"dmatlack@google.com" <dmatlack@google.com>, "fvdl@google.com" <fvdl@google.com>, 
	"hch@infradead.org" <hch@infradead.org>, "hughd@google.com" <hughd@google.com>, 
	"ira.weiny@intel.com" <ira.weiny@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"isaku.yamahata@intel.com" <isaku.yamahata@intel.com>, "james.morse@arm.com" <james.morse@arm.com>, 
	"jarkko@kernel.org" <jarkko@kernel.org>, "jgg@nvidia.com" <jgg@nvidia.com>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "jthoughton@google.com" <jthoughton@google.com>, 
	"keirf@google.com" <keirf@google.com>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"liam.merwick@oracle.com" <liam.merwick@oracle.com>, 
	"linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"mail@maciej.szmigiero.name" <mail@maciej.szmigiero.name>, "mic@digikod.net" <mic@digikod.net>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, 
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"peterx@redhat.com" <peterx@redhat.com>, "qperret@google.com" <qperret@google.com>, 
	"quic_cvanscha@quicinc.com" <quic_cvanscha@quicinc.com>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, 
	"quic_mnalajal@quicinc.com" <quic_mnalajal@quicinc.com>, 
	"quic_pderrin@quicinc.com" <quic_pderrin@quicinc.com>, 
	"quic_pheragu@quicinc.com" <quic_pheragu@quicinc.com>, 
	"quic_svaddagi@quicinc.com" <quic_svaddagi@quicinc.com>, 
	"quic_tsoni@quicinc.com" <quic_tsoni@quicinc.com>, "rientjes@google.com" <rientjes@google.com>, 
	"seanjc@google.com" <seanjc@google.com>, "shuah@kernel.org" <shuah@kernel.org>, 
	"steven.price@arm.com" <steven.price@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"vannapurve@google.com" <vannapurve@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "wei.w.wang@intel.com" <wei.w.wang@intel.com>, 
	"will@kernel.org" <will@kernel.org>, "willy@infradead.org" <willy@infradead.org>, 
	"xiaoyao.li@intel.com" <xiaoyao.li@intel.com>, "yilun.xu@intel.com" <yilun.xu@intel.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Fri, 11 Jul 2025 at 16:48, Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 11 Jul 2025 15:17:46 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Fri, 11 Jul 2025 at 14:50, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Fri, 11 Jul 2025 10:59:39 +0100,
> > > "Roy, Patrick" <roypat@amazon.co.uk> wrote:
> > > >
> > > >
> > > > Hi Fuad,
> > > >
> > > > On Wed, 2025-07-09 at 11:59 +0100, Fuad Tabba wrote:> -snip-
> > > > > +#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
> > > > > +
> > > > > +static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > > > > +                     struct kvm_s2_trans *nested,
> > > > > +                     struct kvm_memory_slot *memslot, bool is_perm)
> > > > > +{
> > > > > +       bool write_fault, exec_fault, writable;
> > > > > +       enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
> > > > > +       enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> > > > > +       struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> > > > > +       struct page *page;
> > > > > +       struct kvm *kvm = vcpu->kvm;
> > > > > +       void *memcache;
> > > > > +       kvm_pfn_t pfn;
> > > > > +       gfn_t gfn;
> > > > > +       int ret;
> > > > > +
> > > > > +       ret = prepare_mmu_memcache(vcpu, true, &memcache);
> > > > > +       if (ret)
> > > > > +               return ret;
> > > > > +
> > > > > +       if (nested)
> > > > > +               gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
> > > > > +       else
> > > > > +               gfn = fault_ipa >> PAGE_SHIFT;
> > > > > +
> > > > > +       write_fault = kvm_is_write_fault(vcpu);
> > > > > +       exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> > > > > +
> > > > > +       if (write_fault && exec_fault) {
> > > > > +               kvm_err("Simultaneous write and execution fault\n");
> > > > > +               return -EFAULT;
> > > > > +       }
> > > > > +
> > > > > +       if (is_perm && !write_fault && !exec_fault) {
> > > > > +               kvm_err("Unexpected L2 read permission error\n");
> > > > > +               return -EFAULT;
> > > > > +       }
> > > > > +
> > > > > +       ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
> > > > > +       if (ret) {
> > > > > +               kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
> > > > > +                                             write_fault, exec_fault, false);
> > > > > +               return ret;
> > > > > +       }
> > > > > +
> > > > > +       writable = !(memslot->flags & KVM_MEM_READONLY);
> > > > > +
> > > > > +       if (nested)
> > > > > +               adjust_nested_fault_perms(nested, &prot, &writable);
> > > > > +
> > > > > +       if (writable)
> > > > > +               prot |= KVM_PGTABLE_PROT_W;
> > > > > +
> > > > > +       if (exec_fault ||
> > > > > +           (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
> > > > > +            (!nested || kvm_s2_trans_executable(nested))))
> > > > > +               prot |= KVM_PGTABLE_PROT_X;
> > > > > +
> > > > > +       kvm_fault_lock(kvm);
> > > >
> > > > Doesn't this race with gmem invalidations (e.g. fallocate(PUNCH_HOLE))?
> > > > E.g. if between kvm_gmem_get_pfn() above and this kvm_fault_lock() a
> > > > gmem invalidation occurs, don't we end up with stage-2 page tables
> > > > refering to a stale host page? In user_mem_abort() there's the "grab
> > > > mmu_invalidate_seq before dropping mmap_lock and check it hasnt changed
> > > > after grabbing mmu_lock" which prevents this, but I don't really see an
> > > > equivalent here.
> > >
> > > Indeed. We have a similar construct in kvm_translate_vncr() as well,
> > > and I'd definitely expect something of the sort 'round here. If for
> > > some reason this is not needed, then a comment explaining why would be
> > > welcome.
> > >
> > > But this brings me to another interesting bit: kvm_translate_vncr() is
> > > another path that deals with a guest translation fault (despite being
> > > caught as an EL2 S1 fault), and calls kvm_faultin_pfn(). What happens
> > > when the backing store is gmem? Probably nothin
> >
> > I'll add guest_memfd handling logic to kvm_translate_vncr().
> >
> > > I don't immediately see why NV and gmem should be incompatible, so
> > > something must be done on that front too (including the return to
> > > userspace if the page is gone).
> >
> > Should it return to userspace or go back to the guest?
> > user_mem_abort() returns to the guest if the page disappears (I don't
> > quite understand the rationale behind that, but it was a deliberate
> > change [1]): on mmu_invalidate_retry() it sets ret to -EAGAIN [2],
> > which gets flipped to 0 on returning from user_mem_abort() [3].
>
> Outside of gmem, racing with an invalidation (resulting in -EAGAIN) is
> never a problem. We just replay the faulting instruction.  Also,
> kvm_faultin_pfn() never fails outside of error cases (guest accessing
> non-memory, or writing to RO memory). So returning to the guest is
> always the right thing to do, and userspace never needs to see any of
> that (I ignore userfaultfd here, as that's a different matter).
>
> With gmem, you don't really have a choice. Whoever is in charge of the
> memory told you it can't get to it, and it's only fair to go back to
> userspace for it to sort it out (if at all possible).

Makes sense.

> So when it comes to VNCR faults, the behaviour should be the same,
> given that the faulting page *is* a guest page, even if this isn't a
> stage-2 mapping that we are dealing with.
>
> I'd expect something along the lines of the hack below, (completely
> untested, as usual).

Thanks!
/fuad

> Thanks,
>
>         M.
>
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 5b191f4dc5668..98b1d6d4688a6 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1172,8 +1172,9 @@ static u64 read_vncr_el2(struct kvm_vcpu *vcpu)
>         return (u64)sign_extend64(__vcpu_sys_reg(vcpu, VNCR_EL2), 48);
>  }
>
> -static int kvm_translate_vncr(struct kvm_vcpu *vcpu)
> +static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *gmem)
>  {
> +       struct kvm_memory_slot *memslot;
>         bool write_fault, writable;
>         unsigned long mmu_seq;
>         struct vncr_tlb *vt;
> @@ -1216,9 +1217,21 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu)
>         smp_rmb();
>
>         gfn = vt->wr.pa >> PAGE_SHIFT;
> -       pfn = kvm_faultin_pfn(vcpu, gfn, write_fault, &writable, &page);
> -       if (is_error_noslot_pfn(pfn) || (write_fault && !writable))
> -               return -EFAULT;
> +       memslot = gfn_to_memslot(vcpu->kvm, gfn);
> +       *gmem = kvm_slot_has_gmem(memslot);
> +       if (!*gmem) {
> +               pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
> +                                       &writable, &page);
> +               if (is_error_noslot_pfn(pfn) || (write_fault && !writable))
> +                       return -EFAULT;
> +       } else {
> +               ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, &page, NULL);
> +               if (ret) {
> +                       kvm_prepare_memory_fault_exit(vcpu, vt->wr.pa, PAGE_SIZE,
> +                                                     write_fault, false, false);
> +                       return ret;
> +               }
> +       }
>
>         scoped_guard(write_lock, &vcpu->kvm->mmu_lock) {
>                 if (mmu_invalidate_retry(vcpu->kvm, mmu_seq))
> @@ -1292,14 +1305,14 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
>         if (esr_fsc_is_permission_fault(esr)) {
>                 inject_vncr_perm(vcpu);
>         } else if (esr_fsc_is_translation_fault(esr)) {
> -               bool valid;
> +               bool valid, gmem = false;
>                 int ret;
>
>                 scoped_guard(read_lock, &vcpu->kvm->mmu_lock)
>                         valid = kvm_vncr_tlb_lookup(vcpu);
>
>                 if (!valid)
> -                       ret = kvm_translate_vncr(vcpu);
> +                       ret = kvm_translate_vncr(vcpu, &gmem);
>                 else
>                         ret = -EPERM;
>
> @@ -1309,6 +1322,14 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
>                         /* Let's try again... */
>                         break;
>                 case -EFAULT:
> +               case -EIO:
> +                       /*
> +                        * FIXME: Add whatever other error cases the
> +                        * GMEM stuff can spit out.
> +                        */
> +                       if (gmem)
> +                               return 0;
> +                       fallthrough;
>                 case -EINVAL:
>                 case -ENOENT:
>                 case -EACCES:
>
> --
> Without deviation from the norm, progress is not possible.
