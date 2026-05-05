Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5640A4A3404
	for <kvmarm@lists.linux.dev>; Tue,  5 May 2026 18:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778004102; cv=pass; b=m6yrrznhtWzK+1rM1jSda5jbUfah+8y0ruScD3xK3JXoGNqH1prfcNzcbGIhg/JvkG1KUC/DqyPRO0D+4HzrqgPX2RqamjTIEbmPW7I4ModOwSDLAYXRomI9tF7NwdqAWLUtuVfcDyy/J4t+4b9pGW9KFNUXUpKMMwzUL1o7BM4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778004102; c=relaxed/simple;
	bh=f+ypqmN+lQj0IF/Oa+7CTxDcYQldd91C7IUoR3r3pGw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IYlH3eEDie5b4lC0NkIDXWO0MIFkAoPoChnPTFUsxfYx7VbTQiVQZDWbF+pt1sFYywJdNH9HEt+KhLZU6g3zMIPn44Sk2+NeTSXC17tvLdJ2aL82IccmPlsfVxrBPis0KzGccv1CHvAjS2U1slMMnhV+6Kgz5ws+2MuedPkFPP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e7R/Prfa; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e7R/Prfa"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-67b7c71c165so6778527a12.0
        for <kvmarm@lists.linux.dev>; Tue, 05 May 2026 11:01:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778004098; cv=none;
        d=google.com; s=arc-20240605;
        b=P+rbMy2SOuSf31nCRj1EW81OBy7DkM4LUPYhowwCH3EM8lhEO4QfpG5xw8GbhQVh+M
         EeggEGW/3i9fSSOEvWnJ1/YzPcVSJbQ7HftpcgMpAVhy8H7DPYmopzsb1ROeXASy6uFi
         80t3PZZ3uIx8PgbyzOcx/C1mV+yYsIfyOFmqmU0agq1p2hoa83FecP9nSmpCaP7z+WQT
         4XvAwNiuhiOKCnJvmE9i5vrPFSVzYkwUwEoQyXYmSJ+mrWIrkLRpSWHUBhlYN7p6irvb
         GT7yMvXfW//T/jigVvlepIOVgah3bmk5+uZprUk18qkdeOOY1q2LafULWVjLU2jKFxJE
         5L8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nQUZmjv7aHFLMaMFauN5kz/OKqGsuDJKsdlinZQqRbc=;
        fh=4wAVcEhDGw3sJ026MfLKMNbHa3rcfxbVwdVG7DPh3Kg=;
        b=iFpbAP/UYvUi1Wk3zWHy/n7f/My8y26LA8/9nHst0CLSfv8/hhF7GdKO/TXvAKQetZ
         qGyrv+XSOyyhU62EHjbtDh4ungW5E7CtVI03+AYyKB3hfi3t1A1xguipWlDkoH6X8T84
         Zk8cwugF5Ulnrc8Ga+KVd7FNvNuHOshAjz5WYTjkLXoXv6L+2iKPLANE5QeV4RO9wHXx
         sWK2Cc9L9UcofTLLqc/+79UIvScmmH+19eWuOOUtkP24Fu7U5aJDXrchLnl7uQt7WM7K
         K5h7iy6d5XwjMwxeYbqNcJobwFsIc0WFm1kicSUJihsOOLHGEfHyIT1mbFN/SpH6y8ZZ
         PONA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778004098; x=1778608898; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nQUZmjv7aHFLMaMFauN5kz/OKqGsuDJKsdlinZQqRbc=;
        b=e7R/PrfaihO3PbKCrn8WUr/zYlSzOoJYFupknPCGAMCai3fPDc0BDfYyKARqGOOvZT
         46To5aWEgxvn0Mw1IUHdjEy6RwUKIdLox6NpVjC6aFOi802chZNTLej26L9Z72rFckbJ
         pwqD/bieP09XmYqEgZVTWLjiFatTePKd2HFWQVyO46vGUaLMn9q403pg291MRD+KpC/q
         nLiTanQkUPyA+x3DZ2sqk2dJHAJaDA/O3t8/4V9tMFcCr845oGoI3qe7s6j9xRvHxmEm
         hmskoeZx/mdXm8eh85O6Xx0hK3TwTI9wgs9y5sTKzCDPb2v57p0/KErxftejJTNu1H3Q
         X+WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778004098; x=1778608898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nQUZmjv7aHFLMaMFauN5kz/OKqGsuDJKsdlinZQqRbc=;
        b=Alv0W+jfX1gD92OjIlSCcMufTtZOHhF4FCfEcajammzVFRZ/HKamIwp4MGKkJeAeRy
         oJkc68eT0vM6nmA1QM5a/CR87r8lUv+Ftx/v/KjYM9h/TuNnkhO7EGY/879H95rnKhKR
         op4jSd6bZ1hzhDNGF+dxgxZgUKWLhbY4AHtI6MH1MB839w6nkcX75SPepcPSx8vGVog9
         rmPV4jy6qF+ielyTan/gYHtcpd6NownKE+Wxq5V2RSQNmkkZmDwGwNy8yQWXlReV7YaZ
         xkpjPTAQhyIu0LkZ02+JvxM+UcUeKncGKbT0C1ivxAsBUwlCoOxevhC9vuWh268k5MmY
         iQZg==
X-Forwarded-Encrypted: i=1; AFNElJ90QW2TzF5VhkSN2TjcALAulKGHlYj4mTYWIzc7/OhFiu2nqfI9dCHneBh07EvW1rpljUaIvbg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyuBsOqWeKTMCd4NI31QiDITPIYnhqvXJ2YPgfQiLDloZQ3+KZB
	HUkbqMnlhSWsgtEETcDrDn5d3Q1IaBwR2vKIQJrqxF1mJfz4EI+FgZT5RVAlnBoh4P2t7jgRlkZ
	avEHwFWv31n5OBEGs48TvW/kTAvfHiWFMnWSxvR2x
X-Gm-Gg: AeBDievSKM1HGKG1zenLdLNBlH+BV/ZqJhd5tFrPk7ozhnhaZq3HrV1ZAOJxeoJlPaz
	nSKMRVFE+ibpv911yr3pbItRNC5TlSB4jMmuAag0tAJxjto/Ai0XfwZpyA1W7cT/YuX4f8lhQ61
	kaq0uzWXo6Nca6jyqtHgF0wwuzuXbyQjeB+1HEIABLVBtrqG9n2g57chok81ahY54HrTkZy0vXL
	Eduu8NTnXxzt3f7EeQxhwxGP/26N5K+r85fznwB8TBii+zWxEkdahWYrkvsaT4jdI7SQAGKGSFb
	FZZwZhmqSWKDELhBPMXQQYJ+qdsO+EB9ex6rTO8ZNVvW0Ri6vOTIUEVWxuwcB33jRNAoCs50VhF
	/+t2B4sgPlpwkkumZDxF0tAwIjA==
X-Received: by 2002:a17:906:9f87:b0:ba7:cc67:488b with SMTP id
 a640c23a62f3a-bbffab33111mr887380266b.5.1778004097049; Tue, 05 May 2026
 11:01:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260504224213.1049426-2-jthoughton@google.com>
 <20260504231048.1184273-1-jthoughton@google.com> <afohshVlK9YcBk-f@google.com>
In-Reply-To: <afohshVlK9YcBk-f@google.com>
From: James Houghton <jthoughton@google.com>
Date: Tue, 5 May 2026 11:01:00 -0700
X-Gm-Features: AVHnY4J0Tr074uKX9gnTkNPmv46TNeS2NEyt9u-k5f94BeNvCS-2m8Zf89eFVRE
Message-ID: <CADrL8HX223b3YS8aHr7b=AZZ2J5ga+-SwLQX9Rs9Ep=rMM5wUA@mail.gmail.com>
Subject: Re: [PATCH 1/5] KVM: arm64: Grab KVM MMU write lock in kvm_arch_flush_shadow_all()
To: Sean Christopherson <seanjc@google.com>
Cc: chenhuacai@kernel.org, gshan@redhat.com, jhogan@kernel.org, 
	joey.gouly@arm.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mips@vger.kernel.org, loongarch@lists.linux.dev, maobibo@loongson.cn, 
	maz@kernel.org, oupton@kernel.org, pbonzini@redhat.com, ricarkol@google.com, 
	shahuang@redhat.com, stable@vger.kernel.org, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, zhaotianrui@loongson.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 5, 2026 at 10:05=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, May 04, 2026, James Houghton wrote:
> > On Mon, May 4, 2026 at 3:42=E2=80=AFPM James Houghton <jthoughton@googl=
e.com> wrote:
> > >
> > > kvm_arch_flush_shadow_all() may sometimes be called on the same `kvm`
> > > concurrently in the event that the KVM's `mm` is __mmput() at the
> > > same time that last reference to the KVM is being dropped.
> > >
> > > T1              T2
> > > KVM_CREATE_VM
> > >                 Get VM file from T1
> > > close VM
> > > exit_mm()       close VM
> > >
> > > T1: exit_mm() -> kvm_mmu_notifier_release() -> kvm_flush_shadow_all()=
,
> > >     with only the KVM srcu read lock held.
> > >
> > > T2: kvm_vm_release() ---> mmu_notifier_unregister() ->
> > >     kvm_mmu_notifier_release() -> kvm_flush_shadow_all(),
> > >     again, with only the KVM srcu read lock held.
> > >
> > > This leads to a potential double-free of
> > > kvm->arch.kvm_mmu_free_memory_cache and now with NV
> > > kvm->arch.nested_mmus.
>
> ...
>
> > >  void kvm_uninit_stage2_mmu(struct kvm *kvm)
> > >  {
> > > -       kvm_free_stage2_pgd(&kvm->arch.mmu);
> > > +       lockdep_assert_held_write(&kvm->mmu_lock);
> >
> > *facepalm*.... this doesn't account for the other callers of
> > kvm_uninit_stage2_mmu(). They will get lockdep warnings.
> >
> > I've attached a diff to the bottom of this reply that *does* deal with =
them.
> > :( Sorry.
>
> ...
>
> > > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > > index 883b6c1008fb..977598bff5e6 100644
> > > --- a/arch/arm64/kvm/nested.c
> > > +++ b/arch/arm64/kvm/nested.c
> > > @@ -1190,11 +1190,13 @@ void kvm_arch_flush_shadow_all(struct kvm *kv=
m)
> > >  {
> > >         int i;
> > >
> > > +       guard(write_lock)(&kvm->mmu_lock);
> > > +
> > >         for (i =3D 0; i < kvm->arch.nested_mmus_size; i++) {
> > >                 struct kvm_s2_mmu *mmu =3D &kvm->arch.nested_mmus[i];
> > >
> > >                 if (!WARN_ON(atomic_read(&mmu->refcnt)))
> > > -                       kvm_free_stage2_pgd(mmu);
> > > +                       kvm_free_stage2_pgd_locked(mmu);
> > >         }
> > >         kvfree(kvm->arch.nested_mmus);
> > >         kvm->arch.nested_mmus =3D NULL;
> > > --
> > > 2.54.0.545.g6539524ca2-goog
> >
> > And here is the diff that should fix this patch. (Sorry!!)
>
> There are more issues.  kvm->arch.mmu.split_page_cache can be freed by
> kvm_arch_commit_memory_region(), which holds slots_lock and slots_arch_lo=
ck,
> but not mmu_lock.

Thanks. I also noticed that kvm->arch.mmu.split_page_cache is
documented as being protected by kvm->slots_lock; we should be holding
it here. But we cannot take it here because we are already holding the
KVM srcu lock.

> IMO, the handling of kvm->arch.mmu.split_page_cache should be reworked.  =
I don't
> entirely get the motivation for aggressively freeing the cache.  The cach=
e will
> only be filled if KVM actually does eager page splitting, so it's not lik=
e KVM is
> burning pages for setups that will never use the cache.
>
> Maybe I'm underestimating how many pages arm64 needs in the worst case sc=
enario?
> (I can't follow the math, too many macros).  But if KVM is configuring th=
e cache
> with a capacity that's _so_ high that the "wasted" memory is problematic,=
 then we
> probably should we revisit the capacity and algorithm.  E.g. if KVM is sp=
litting
> from 1GiB =3D> 4KiB in a single pass (I can't tell if KVM does this on ar=
m64), then
> we could break that into a 1GiB =3D> 2MiB =3D> 4KiB sequence.

I'm not sure I've fully understood the point you're making, but I
*think* we can just drop the
    kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
line from kvm_uninit_stage2_mmu(). It will get freed when the VM is
destroyed anyway.

So I'm thinking of splitting this patch into two (unless someone tells
me otherwise):

1. Drop the kvm_mmu_free_memory_cache() from kvm_uninit_stage2_mmu()
    Fixes: e7bf7a490c68 ("KVM: arm64: Split huge pages when dirty
logging is enabled")

2. Grab the MMU write lock around the kvfree(nested_mmus) bit in
kvm_arch_flush_shadow_all(); do the kvfree() without holding the the
lock.
    Fixes: 4f128f8e1aaac ("KVM: arm64: nv: Support multiple nested
Stage-2 mmu structures")
