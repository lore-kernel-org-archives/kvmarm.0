Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2B643AD7
	for <kvmarm@lists.linux.dev>; Thu, 11 Apr 2024 18:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712858469; cv=none; b=aLsJmUq1C4OBaUqe+E3OIOvP6tiQdysfmYff4UWnecM9aJI0gMq28rok4JDi/m2esTW5o+S9B2LH8IISYpY8wno5SPgDLimm85OVEKN77udfOJ12FhSAg+4vFJ1GQd4Dw3hToXP5bpeLn+JTbhgupmgm0xQGkUJIFGt/Im33IKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712858469; c=relaxed/simple;
	bh=ELksu+sLzaHjlNPUR9IEFLD8rhRIAjWKwOmmScUPvR4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kRK8cQaonX0H536r6Y7xt5A2sRcp3BJfGZz1WoPeY/BhczrE2l+mP18yYcu7aTtIUgCUWD2xSb6DnujZX0Qhpxrc5YjYhKFHzs50MD8xcJ86ZYgLr3YbP7pOtCTSBkjrJZh08G8YYNpoEEE3GOibTOJ0jrWYfYECWorMpnvO1ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MR6UnFpb; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MR6UnFpb"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-417d14c3411so1391115e9.2
        for <kvmarm@lists.linux.dev>; Thu, 11 Apr 2024 11:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712858466; x=1713463266; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TFQZlmoBEIaWgT85a+mHB96sryXc4pNLPf5zok3FIIo=;
        b=MR6UnFpbCkKgEduGoSsEwGcuWogjjwIan/dg2i7F9R41z8ohYypzCtcMmzMfZ0XmzQ
         VVRf5RmwI3PDAt7YSZpWf5vRW/T5oGnBjMWFet2WJHEuJGSjZj7u0OVdBvxnq39xQTQL
         a7SBWe5Z35ENcG+hcXKu4YrD4mIHGiDRJ36//IXWk2jewsgQRVdtyyhncUS+IxrEhik5
         UeJ73hrjQN5cXEYs7oexLBcKIp8r1u2Shg3Clq6SC9e6RoofOeXudTrseGUnJZ/iumLV
         DdGvGnIss+hXBngyeubIhbYrtmW28+F+hce+tJBiUdoatZytO2DayiU9AMry5qp8mqhX
         pHgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712858466; x=1713463266;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TFQZlmoBEIaWgT85a+mHB96sryXc4pNLPf5zok3FIIo=;
        b=nWm4xU/fr2FIFRxq0NMKp7hKLB17s3z1Hsduy4Ij108keBSHOq3+VZ5OVnm3sT2H0S
         9m25Ds5u+T77EkbW1a0yKFqpV05vdSoaY9finASg+uuFjQkSCdPLMIQmZ0EfcG752wYI
         612KRfrk+k9LRFxIkkyEMIDNtXPUH53xrfEj/1G/jyhOTJWncsvGSER+GVqy12l9mT9P
         MuHZfZfvbYTWquioa9Cky3oScmyfSFeTGOD1nmGsk44r1EdFD59YMQu7g49mjZvboBv5
         IoLz1UTku+nepnlhdQLHPBUgYnqmu7L0bINBPgzG8CovCzjnsrzK0JvczgKAu/HlvbKR
         Mk4Q==
X-Forwarded-Encrypted: i=1; AJvYcCX4uPJapdslQjdERFJgWKlBfiJR4vZkkE1oXI/p6Ol8MXJ2q8ng3gxCa2Vez3jiDhzdQeuWnfNT40bTKViFVuigTqTYHIJ2
X-Gm-Message-State: AOJu0Yxq3v4PZShcCR3tTNX/SYZ8R65YvZO8kitJG4o1uVI1VNF2MasC
	+367aCdCagLZ0zSuC2fo6rmhKtMTZ10dpsEaR8QKLWnEMuCxZShhot9jpIXHdbs8QfV0brx50rI
	UBxBmP42nMKUfvIbUT7vGrFDxrXryQwCQ2/qp
X-Google-Smtp-Source: AGHT+IEl4Iu+H70L5iEuaxVGs2wVMTfN36uwSB9T1kbBSUqJDIrWPvmyrfPoncl+j8yWfnTJVbG6KZ40Dk/wHobSp7A=
X-Received: by 2002:a5d:564e:0:b0:343:6551:935 with SMTP id
 j14-20020a5d564e000000b0034365510935mr235209wrw.66.1712858466173; Thu, 11 Apr
 2024 11:01:06 -0700 (PDT)
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
From: David Matlack <dmatlack@google.com>
Date: Thu, 11 Apr 2024 11:00:37 -0700
Message-ID: <CALzav=f=_+UQBJv_eZ=t5wE0AytVo1mwfDoum+ZyNfNHvyOccQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] KVM: x86: Participate in bitmap-based PTE aging
To: James Houghton <jthoughton@google.com>
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

Ah no, I'm wrong here. Setting args.unreliable causes the notifier to
return 0 instead of MMU_NOTIFIER_YOUNG_FAST.
MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE is used for something else.

The control flow of all this and naming of functions and macros is
overall confusing. args.unreliable and
MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE for one. Also I now realize
kvm_arch_prepare/finish_bitmap_age() are used even when the bitmap is
_not_ provided, so those names are also misleading.
