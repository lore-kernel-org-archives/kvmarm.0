Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47E82B9BF
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 20:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713559711; cv=none; b=J/6y5ptsqEb5M0S6ijUCj89H5V3BFIXdNrfXoFLWPWBkVRZRws1KE9g3wRBFvVmp5kR+q2NldUlCVHplHogT96eRU438Cn9GqJS4iAZzlMFRptjkRtgQx7UqVgtDPlSyLaFGwiLqr9sj7aNcWqqvmhJGK5DrEO52Bp+b+QW12ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713559711; c=relaxed/simple;
	bh=DvvQfQjHZvt3I094t8XIXjqIQhk2wrjAku9v1k9ONJQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HTGYdqvFa/xYGhi7SB04x3D7hg8/SxCWhRMGRdQcf1RJbCPLuRtjOWbsIIALj2PR6G4ZrNtDaz50xRg7sJTW15fJkS8zXCzrnM/K1c+sftBYmBNFCeh1FjcXp+/7JfreugMkhq0qMkgAgorfCizgJYp3+YwPdMo58HZG+8xOTfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qcKCe6qB; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qcKCe6qB"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-434b5abbb0dso87491cf.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 13:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713559709; x=1714164509; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jdwBN6tcT1rkPndt3s/q21EflrWzoZs9NJ2XL0c5/ME=;
        b=qcKCe6qBCJD+MOdI6iC5qQ921agL+vBUqNME0S8Sl4e0C0QyIo3CBnaV3SRjXNYddb
         wC0WawSHkIESd2Qtc1q8+rTnjoGNpRbSlKMkg5Xzcf6kkO2BqOJZ5qd16f+1nogaNfC4
         7blu+WNzTBPkphq+1wY3LxoPcxltY51E7EF6WGQcg6jyshnh7xphXM7yLI3MlWcJFG0B
         Q5D5KkOteLo+4E+/DeqOGs4uimS7QiazEdDGuXJn+pkIOArqIgJLCjNDybp/jjtpy9PY
         hop6TaQG/oMlAOm7egaLCk6al60GgN7SVVP88R33jF45eGReAOo1Q9TBXzGXlpKbRlJV
         rUOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713559709; x=1714164509;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jdwBN6tcT1rkPndt3s/q21EflrWzoZs9NJ2XL0c5/ME=;
        b=XqPeKpkH3VubAqfBUni858HEh3nHpfQEhvBl15PQY3HF/L6nbiL2YCGt2tlnYI5810
         Emxw7uKQTKBwhT+6HdSqUUymSSfybZBRBspSTqUedSyz5e8ejDeuWj+dJ1EhiyDmqxsz
         RmmDPX+JwmkF+e6xI+gkyQQwyv+5TkC98HZzJwSLNIUq/ooLZzig7BDETqw7axwdohQv
         Z92RN71EZ/yWUACOVZJrIpFc8KYk8toSAZLHKRDw0mUGVQ+/nIHI9oYyK154ynkh0jvh
         yejRBPxKDOynUQnKOVSDfHlY3WXCroUENuDc/ipmHlST7MPyTfv10eni81j232a/aCFi
         TNoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUz+eSU/fZ8fK3qlZf3tCaTgHd8sfKvJvgp30j/9fL2UNe1gcSWIUAxZE32zpFoiXGlZKfoRBGazAtz3CJN8p2eZZ2t5/N
X-Gm-Message-State: AOJu0YyVDO71U1S4W70nG5z0rQOPgGmmfdqRlVASpyMEytNjMFjyEGBV
	j1efe8DC+h+6Y16FhIGh2rf56hnp10qiRdfk2rh0DYQoefZy2jhLJTyaeanaeh/SXsyA756wb3l
	x0ZeObCbaYKwr/a5JpejeMIR18qbeV1Uepzph
X-Google-Smtp-Source: AGHT+IHnP1X/uJdeFnAFt5SWKpANerf/z+ZZ3d5hKj8mNm8Ve8tSTI9oyLDn94kRt0shtjukZWu2UUMD2xkTzRuS724=
X-Received: by 2002:ac8:5309:0:b0:437:b985:8523 with SMTP id
 t9-20020ac85309000000b00437b9858523mr8583qtn.25.1713559708789; Fri, 19 Apr
 2024 13:48:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240401232946.1837665-1-jthoughton@google.com>
 <20240401232946.1837665-6-jthoughton@google.com> <ZhgZHJH3c5Lb5SBs@google.com>
 <Zhgdw8mVNYZvzgWH@google.com>
In-Reply-To: <Zhgdw8mVNYZvzgWH@google.com>
From: James Houghton <jthoughton@google.com>
Date: Fri, 19 Apr 2024 13:47:52 -0700
Message-ID: <CADrL8HUpHQQbQCxd8JGVRr=eT6e4SYyfYZ7eTDsv8PK44FYV_A@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] KVM: x86: Participate in bitmap-based PTE aging
To: David Matlack <dmatlack@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Gavin Shan <gshan@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Rientjes <rientjes@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2024 at 10:28=E2=80=AFAM David Matlack <dmatlack@google.com=
> wrote:
>
> On 2024-04-11 10:08 AM, David Matlack wrote:
> > On 2024-04-01 11:29 PM, James Houghton wrote:
> > > Only handle the TDP MMU case for now. In other cases, if a bitmap was
> > > not provided, fallback to the slowpath that takes mmu_lock, or, if a
> > > bitmap was provided, inform the caller that the bitmap is unreliable.
> > >
> > > Suggested-by: Yu Zhao <yuzhao@google.com>
> > > Signed-off-by: James Houghton <jthoughton@google.com>
> > > ---
> > >  arch/x86/include/asm/kvm_host.h | 14 ++++++++++++++
> > >  arch/x86/kvm/mmu/mmu.c          | 16 ++++++++++++++--
> > >  arch/x86/kvm/mmu/tdp_mmu.c      | 10 +++++++++-
> > >  3 files changed, 37 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/k=
vm_host.h
> > > index 3b58e2306621..c30918d0887e 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -2324,4 +2324,18 @@ int memslot_rmap_alloc(struct kvm_memory_slot =
*slot, unsigned long npages);
> > >   */
> > >  #define KVM_EXIT_HYPERCALL_MBZ             GENMASK_ULL(31, 1)
> > >
> > > +#define kvm_arch_prepare_bitmap_age kvm_arch_prepare_bitmap_age
> > > +static inline bool kvm_arch_prepare_bitmap_age(struct mmu_notifier *=
mn)
> > > +{
> > > +   /*
> > > +    * Indicate that we support bitmap-based aging when using the TDP=
 MMU
> > > +    * and the accessed bit is available in the TDP page tables.
> > > +    *
> > > +    * We have no other preparatory work to do here, so we do not nee=
d to
> > > +    * redefine kvm_arch_finish_bitmap_age().
> > > +    */
> > > +   return IS_ENABLED(CONFIG_X86_64) && tdp_mmu_enabled
> > > +                                    && shadow_accessed_mask;
> > > +}
> > > +
> > >  #endif /* _ASM_X86_KVM_HOST_H */
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 992e651540e8..fae1a75750bb 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -1674,8 +1674,14 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_g=
fn_range *range)
> > >  {
> > >     bool young =3D false;
> > >
> > > -   if (kvm_memslots_have_rmaps(kvm))
> > > +   if (kvm_memslots_have_rmaps(kvm)) {
> > > +           if (range->lockless) {
> > > +                   kvm_age_set_unreliable(range);
> > > +                   return false;
> > > +           }
> >
> > If a VM has TDP MMU enabled, supports A/D bits, and is using nested
> > virtualization, MGLRU will effectively be blind to all accesses made by
> > the VM.
> >
> > kvm_arch_prepare_bitmap_age() will return true indicating that the
> > bitmap is supported. But then kvm_age_gfn() and kvm_test_age_gfn() will
> > return false immediately and indicate the bitmap is unreliable because =
a
> > shadow root is allocate. The notfier will then return
> > MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE.
> >
> > Looking at the callers, MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE is never
> > consumed or used. So I think MGLRU will assume all memory is
> > unaccessed?
> >
> > One way to improve the situation would be to re-order the TDP MMU
> > function first and return young instead of false, so that way MGLRU at
> > least has visibility into accesses made by L1 (and L2 if EPT is disable
> > in L2). But that still means MGLRU is blind to accesses made by L2.
> >
> > What about grabbing the mmu_lock if there's a shadow root allocated and
> > get rid of MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE altogether?
> >
> >       if (kvm_memslots_have_rmaps(kvm)) {
> >               write_lock(&kvm->mmu_lock);
> >               young |=3D kvm_handle_gfn_range(kvm, range, kvm_age_rmap)=
;
> >               write_unlock(&kvm->mmu_lock);
> >       }
> >
> > The TDP MMU walk would still be lockless. KVM only has to take the
> > mmu_lock to collect accesses made by L2.
> >
> > kvm_age_rmap() and kvm_test_age_rmap() will need to become bitmap-aware
> > as well, but that seems relatively simple with the helper functions.
>
> Wait, even simpler, just check kvm_memslots_have_rmaps() in
> kvm_arch_prepare_bitmap_age() and skip the shadow MMU when processing a
> bitmap request.
>
> i.e.
>
> static inline bool kvm_arch_prepare_bitmap_age(struct kvm *kvm, struct mm=
u_notifier *mn)
> {
>         /*
>          * Indicate that we support bitmap-based aging when using the TDP=
 MMU
>          * and the accessed bit is available in the TDP page tables.
>          *
>          * We have no other preparatory work to do here, so we do not nee=
d to
>          * redefine kvm_arch_finish_bitmap_age().
>          */
>         return IS_ENABLED(CONFIG_X86_64)
>                 && tdp_mmu_enabled
>                 && shadow_accessed_mask
>                 && !kvm_memslots_have_rmaps(kvm);
> }
>
> bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> {
>         bool young =3D false;
>
>         if (!range->arg.metadata->bitmap && kvm_memslots_have_rmaps(kvm))
>                 young =3D kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
>
>         if (tdp_mmu_enabled)
>                 young |=3D kvm_tdp_mmu_age_gfn_range(kvm, range);
>
>         return young;
> }
>
> bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> {
>         bool young =3D false;
>
>         if (!range->arg.metadata->bitmap && kvm_memslots_have_rmaps(kvm))
>                 young =3D kvm_handle_gfn_range(kvm, range, kvm_test_age_r=
map);
>
>         if (tdp_mmu_enabled)
>                 young |=3D kvm_tdp_mmu_test_age_gfn(kvm, range);
>
>         return young;


Yeah I think this is the right thing to do. Given your other
suggestions (on patch 3), I think this will look something like this
-- let me know if I've misunderstood something:

bool check_rmap =3D !bitmap && kvm_memslot_have_rmaps(kvm);

if (check_rmap)
  KVM_MMU_LOCK(kvm);

rcu_read_lock(); // perhaps only do this when we don't take the MMU lock?

if (check_rmap)
  kvm_handle_gfn_range(/* ... */ kvm_test_age_rmap)

if (tdp_mmu_enabled)
  kvm_tdp_mmu_test_age_gfn() // modified to be RCU-safe

rcu_read_unlock();
if (check_rmap)
  KVM_MMU_UNLOCK(kvm);

> }
>
> Sure this could race with the creation of a shadow root but so can the
> non-bitmap code.
