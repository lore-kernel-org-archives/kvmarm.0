Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA951E2858
	for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 11:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753182526; cv=none; b=oNv3FRiXKAgvKXsFUz6Fx08wKxShT5HAimCN0UrJCn7Fri1sF2e8uFwTW9K/XlxYOHQUIU3R0iC/uSgGGkqdZpR8fHF2cMNlzrhA0EpCDLw5QeifI5LTTt+f2RTtIo/AdjMjGEvcSgHGgkigqrPzWpQMSMWi9GYp/NI4msDxORo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753182526; c=relaxed/simple;
	bh=FWIv3x+7jARtSRUKIBRPksekNnDXxImW3zaETxfIwrE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XP609NV6tDSsKw7Pj72CPRYBqy1V2QiFa/MYxfHEXAMuYWcCzvTJVbyCCwNuTSY7HPrwdkTPpTpPJsmY49ahNhpxQulSYK9bUStmU7Qchy7Gx3SSPgHbTM5FDUp+ed5iK8Ve2Q+r01PzmhGctSq6TOdO6+tXYNwceiM3dj4enXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F9xSpoTB; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F9xSpoTB"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4aaf43cbbdcso147691cf.1
        for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 04:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753182524; x=1753787324; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q4OlHSsQD8Q3GzLrFxGBtNoCw1qRv1k2dQlrD5QI9ZA=;
        b=F9xSpoTB0hIf0MsdoMsJbC8feu/eZFFKm3xoxlyNRQQE8GBryrEAcqaZsiH5oB4O9V
         dfnbalSWEHZWV0BrymcyhKDFWCn57Q14xG3oWTud1RROVEhcBzy2GE//Ev5kC3i74FZC
         zGl0VGORIQyApQQKfYiVSR5adHq8JBciHgJI9RdQsPxwOvw4ziGBoEycFW3kj2FTcHs0
         XVbZGMvxm55bF1fescKrIKsYR+NujwusSt3TYNXAFpmFdLg70i5Drb2bEE+DbMnAzwbB
         YnVN8K7rXXtJCGT8GXLDbzqy8cza7F6XzHslls9MlRUXN32U4zoWnxoHlGkShEmTtE6n
         wdHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753182524; x=1753787324;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q4OlHSsQD8Q3GzLrFxGBtNoCw1qRv1k2dQlrD5QI9ZA=;
        b=XZ/rLLRrou1x7XwRKdkLWbP4FyOn83yCdDcUAqSOLvekCBexHfhR27l16qBMfAMUhQ
         bOafa8Kh8AIfJQjoA/mkKKd32jOwwQClRkRAQULaPFeECh8+wI5sZAXwaKVs47OCSAYv
         zp+ZaTgUyLNkYVPYlacI3LJ+tDcGJQSprChe4eLLIRuX44X/beBAynJlhazk+OkisCIu
         LJyQ9bzKukEl9ExwdZcUfswjXFo2cNJKSC/Z7Y2+4x7tm1jJH4luS3U6Irx7y/mPSx4v
         UNFBqWgNEO1nUcuE967BYcCiu6uSSmbxezc/hOTMHX1aHA1XrpsYRHmR3HKhP2hSBc+E
         uLhA==
X-Forwarded-Encrypted: i=1; AJvYcCUbp59qW1boy3k5L3bFS/tuddIxd4fQyfkV0bP+ZWsG5ibjtqTOiYW6dhd+C9oZnpqgchBGEXA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3WYhnYG6XCPRoDf7KoO0SVONFpj+jSvWe9/5Om9GynzwFSd7A
	XNH3NfeJj7vvM7v7QnFss4MdKmPjugKoj2ZuOvZFdJ4R9pbo+up4T/F7YmjH2UywjL8fl7Rjagf
	O2IZJrDjgkXzsKakiscZw6arIGLNdVUomyhRfS+Lc
X-Gm-Gg: ASbGncu1TwDI+EH8clp8LSPJB+FPjKG2RF8gCSECktCV7YEFPGlF5ld67wsxIAr7hQg
	9RZr7UegeOTvY7+3I3YLxQnQCoaOvH0G83pG6TLMmCq0Lz6uKee2xkae8p2mcdZlIe+/+yRRq4f
	DyAwoWmRUU2RNebqr3aCWWvWAjyAmGndVcI1Gcywi2/jFFU2BZbB4lIhwqEgh4ydorko58ODpmf
	xF6Mao/CSoWae3fVo27PlC+OtF+3oL8xG5+
X-Google-Smtp-Source: AGHT+IGUb3iz4a5qMCYNx1u6U7GTJFpP1c5NB9X/RTiomiZ52K/XsGtaFjte5gDNRBdO8xNk6Dmgs2XbsK+QW4EU7aI=
X-Received: by 2002:a05:622a:8359:b0:494:b4dd:befd with SMTP id
 d75a77b69052e-4ae5e2ca83dmr2714601cf.8.1753182523270; Tue, 22 Jul 2025
 04:08:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-12-tabba@google.com>
 <8340ec70-1c44-47a7-8c48-89e175501e89@intel.com> <aH7KghhsjaiIL3En@google.com>
 <c35b8c34-2736-45fe-8a97-bfedbf72537e@intel.com>
In-Reply-To: <c35b8c34-2736-45fe-8a97-bfedbf72537e@intel.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 22 Jul 2025 12:08:06 +0100
X-Gm-Features: Ac12FXz9tmJwpwAgcImOsShRgOCpw0ZxfeluqVRurIjOexvh31HNQ0n432YkfPI
Message-ID: <CA+EHjTzNDrwzdpoEuiqvzk3-A7LAsdJ-6y-Gcj7h7+dUTh=6pw@mail.gmail.com>
Subject: Re: [PATCH v15 11/21] KVM: x86/mmu: Allow NULL-able fault in kvm_max_private_mapping_level
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
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

On Tue, 22 Jul 2025 at 06:36, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> On 7/22/2025 7:17 AM, Sean Christopherson wrote:
> > On Fri, Jul 18, 2025, Xiaoyao Li wrote:
> >> On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> >>> From: Ackerley Tng <ackerleytng@google.com>
> >>>
> >>> Refactor kvm_max_private_mapping_level() to accept a NULL kvm_page_fault
> >>> pointer and rename it to kvm_gmem_max_mapping_level().
> >>>
> >>> The max_mapping_level x86 operation (previously private_max_mapping_level)
> >>> is designed to potentially be called without an active page fault, for
> >>> instance, when kvm_mmu_max_mapping_level() is determining the maximum
> >>> mapping level for a gfn proactively.
> >>>
> >>> Allow NULL fault pointer: Modify kvm_max_private_mapping_level() to
> >>> safely handle a NULL fault argument. This aligns its interface with the
> >>> kvm_x86_ops.max_mapping_level operation it wraps, which can also be
> >>> called with NULL.
> >>
> >> are you sure of it?
> >>
> >> The patch 09 just added the check of fault->is_private for TDX and SEV.
> >
> > +1, this isn't quite right.  That's largely my fault (no pun intended) though, as
> > I suggested the basic gist of the NULL @fault handling, and it's a mess.  More at
> > the bottom.
> >
> >>> Rename function to kvm_gmem_max_mapping_level(): This reinforces that
> >>> the function's scope is for guest_memfd-backed memory, which can be
> >>> either private or non-private, removing any remaining "private"
> >>> connotation from its name.
> >>>
> >>> Optimize max_level checks: Introduce a check in the caller to skip
> >>> querying for max_mapping_level if the current max_level is already
> >>> PG_LEVEL_4K, as no further reduction is possible.
> >>>
> >>> Acked-by: David Hildenbrand <david@redhat.com>
> >>> Suggested-by: Sean Christoperson <seanjc@google.com>
> >>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >>> Signed-off-by: Fuad Tabba <tabba@google.com>
> >>> ---
> >>>    arch/x86/kvm/mmu/mmu.c | 16 +++++++---------
> >>>    1 file changed, 7 insertions(+), 9 deletions(-)
> >>>
> >>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> >>> index bb925994cbc5..6bd28fda0fd3 100644
> >>> --- a/arch/x86/kvm/mmu/mmu.c
> >>> +++ b/arch/x86/kvm/mmu/mmu.c
> >>> @@ -4467,17 +4467,13 @@ static inline u8 kvm_max_level_for_order(int order)
> >>>     return PG_LEVEL_4K;
> >>>    }
> >>> -static u8 kvm_max_private_mapping_level(struct kvm *kvm,
> >>> -                                   struct kvm_page_fault *fault,
> >>> -                                   int gmem_order)
> >>> +static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, int order,
> >>> +                                struct kvm_page_fault *fault)
> >>>    {
> >>> -   u8 max_level = fault->max_level;
> >>>     u8 req_max_level;
> >>> +   u8 max_level;
> >>> -   if (max_level == PG_LEVEL_4K)
> >>> -           return PG_LEVEL_4K;
> >>> -
> >>> -   max_level = min(kvm_max_level_for_order(gmem_order), max_level);
> >>> +   max_level = kvm_max_level_for_order(order);
> >>>     if (max_level == PG_LEVEL_4K)
> >>>             return PG_LEVEL_4K;
> >>> @@ -4513,7 +4509,9 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
> >>>     }
> >>>     fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
> >>> -   fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault, max_order);
> >>> +   if (fault->max_level >= PG_LEVEL_4K)
> >>> +           fault->max_level = kvm_gmem_max_mapping_level(vcpu->kvm,
> >>> +                                                         max_order, fault);
> >>
> >> I cannot understand why this change is required. In what case will
> >> fault->max_level < PG_LEVEL_4K?
> >
> > Yeah, I don't get this code either.  I also don't think KVM should call
> > kvm_gmem_max_mapping_level() *here*.  That's mostly a problem with my suggested
> > NULL @fault handling.  Dealing with kvm_gmem_max_mapping_level() here leads to
> > weirdness, because kvm_gmem_max_mapping_level() also needs to be invoked for the
> > !fault path, and then we end up with multiple call sites and the potential for a
> > redundant call (gmem only, is private).
> >
> > Looking through surrounding patches, the ordering of things is also "off".
> > "Generalize private_max_mapping_level x86 op to max_mapping_level" should just
> > rename the helper; reacting to !is_private memory in TDX belongs in "Consult
> > guest_memfd when computing max_mapping_level", because that's where KVM plays
> > nice with non-private memory.
> >
> > But that patch is also doing too much, e.g. shuffling code around and short-circuting
> > the non-fault case, which makes it confusing and hard to review.  Extending gmem
> > hugepage support to shared memory should be "just" this:
> >
> > @@ -3335,8 +3336,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
> >          if (max_level == PG_LEVEL_4K)
> >                  return PG_LEVEL_4K;
> >
> > -       if (is_private)
> > -               host_level = kvm_max_private_mapping_level(kvm, fault, slot, gfn);
> > +       if (is_private || kvm_memslot_is_gmem_only(slot))
> > +               host_level = kvm_gmem_max_mapping_level(kvm, fault, slot, gfn,
> > +                                                       is_private);
> >          else
> >                  host_level = host_pfn_mapping_level(kvm, gfn, slot);
> >          return min(host_level, max_level);
> >
> > plus the plumbing and the small TDX change.  All the renames and code shuffling
> > should be done in prep patches.
> >
> > The attached patches are compile-tested only, but I think they get use where we
> > want to be, and without my confusing suggestion to try and punt on private mappings
> > in the hugepage recovery paths.  They should slot it at the right patch numbers
> > (relative to v15).
> >
> > Holler if the patches don't work, I'm happy to help sort things out so that v16
> > is ready to go.
>
> I have some feedback though the attached patches function well.
>
> - In 0010-KVM-x86-mmu-Rename-.private_max_mapping_level-to-.gm.patch,
> there is double gmem in the name of vmx/vt 's callback implementation:
>
>      vt_gmem_gmem_max_mapping_level
>      tdx_gmem_gmem_max_mapping_level
>      vt_op_tdx_only(gmem_gmem_max_mapping_level)

Sean's patches do that, then he fixes it in a later patch. I'll fix
this at the source.

> - In 0013-KVM-x86-mmu-Extend-guest_memfd-s-max-mapping-level-t.patch,
>    kvm_x86_call(gmem_max_mapping_level)(...) returns 0 for !private case.
>    It's not correct though it works without issue currently.
>
>    Because current gmem doesn't support hugepage so that the max_level
>    gotten from gmem is always PG_LEVEL_4K and it returns early in
>    kvm_gmem_max_mapping_level() on
>
>         if (max_level == PG_LEVEL_4K)
>                 return max_level;
>
>    But just look at the following case:
>
>      return min(max_level,
>         kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private));
>
>    For non-TDX case and non-SNP case, it will return 0, i.e.
>    PG_LEVEL_NONE eventually.
>
>    so either 1) return PG_LEVEL_NUM/PG_LEVEL_1G for the cases where
>    .gmem_max_mapping_level callback doesn't have specific restriction.
>
>    or 2)
>
>         tmp = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private);
>         if (tmp)
>                 return min(max_level, tmp);
>
>         return max-level;

Sean? What do you think?

Thanks!
/fuad
