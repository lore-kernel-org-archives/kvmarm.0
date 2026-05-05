Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA523F9F2F
	for <kvmarm@lists.linux.dev>; Tue,  5 May 2026 17:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778000720; cv=none; b=CkvQCH/bTstNlOajnMzWKHTvDfNtG/dZFuhzU3l3JH2vNA+/K3oMi6hFWSwAgiAZXzOHRwAS/OBtTqcqqS4mkRgEfpI4m4Dt3YNy+GNiEnfh10ZGm2uLLKmC7IrClthnVvCJT0tN6wej60REMVcni2kc9aNhYBVH1BiyDC4V7oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778000720; c=relaxed/simple;
	bh=LlXGiT8km7O3+s8Me6WlqDhDtU9jqmDQ3ztOup/45zg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q1Esul9xlQHPmdGtIokyYXHpdFrz5HGsIbtRPJtBCevp88cKzLAtdh+XmE0MQFaeIhSymDY22UMfepjnIXna4QJ1zhMcxlEEgJbn4FkAWLOY0zo6ULXSfgxbIvm+ietJZ9BtUhUHCqV6+6VsvKZF9uLuZc9Mp1r7lRcECzRaUOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=muo837fj; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="muo837fj"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-83603145987so1525358b3a.2
        for <kvmarm@lists.linux.dev>; Tue, 05 May 2026 10:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778000717; x=1778605517; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m3ZWo/jJEgMHbppCM8fWNjqKfThN79PtinobDbAzSRU=;
        b=muo837fjjGX/Vb6h3iPiSpAn2j6F+gFbcTa5xRUvkFAacktSZKl+7pxdkU0i/4+eU9
         TRnvhoTOXwC729h9Ol4Dc6rrePmg/QFbdDoKyazN9rp7UtVDD/tvLOS4XEKSTMOqeJqk
         zgWbavRv1fMupVkoU8gc4sirSt4HwXQxjbMGiO+aeL8Ys4UdDiBN57IVov4LBBmVsqrU
         BO7lcexddqGCj2s1DcJOzyURU7dRa8HdQ/i4oCDNSEEzTp02auYL+TkOlfaUO/c/Jzql
         0aOTp91+8IrI1chOVCI7kppBVM8Eo6svW3LRfhpeXUfcFgzQT9CB77WNIKmtxigsUShr
         b3Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778000717; x=1778605517;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m3ZWo/jJEgMHbppCM8fWNjqKfThN79PtinobDbAzSRU=;
        b=G2qfswj6/B/q/9VI1B8tfwz2OZGbjlHx0/hYG6IlBPA8bqU6opu1jbzjdFBZxn2Nbc
         BjoB++cCLRBMulS/xLOTVkWZJAomdHU5RMx5aak138Vvl55WDWsKQ8axTfDshTCUKcCn
         YBZE3yi2h1eYOvVJ3UtnYO97bkQDwN9QFxi8fdp6e4xOYdXMKRcoo/Z9b4QoQTnU3/mU
         dUcDOGdixoO2Ynu08UCWVXhs7r7vLSaPPdYQ7LrGvrclmLYykqnTGxwgv3PGtAvpKKZz
         KeZH3oHwLMdYaVwMLNKGRZSqxm4AfwqZ3kTvr22//RgsRQZA5jkrKBy7ciZZEbRK8+z8
         4KIw==
X-Forwarded-Encrypted: i=1; AFNElJ+UKME/vyDBYmJDxz1+7kuiRvfCz2JD7za7ew0XuAmj1LGm7lWjbGKnd+U+KaBX1zgW574lves=@lists.linux.dev
X-Gm-Message-State: AOJu0YzeumBkdhh2rwfU7MxWuDFa5fXoiCOTeC1Z0Sc323p/miyMwYw7
	Lf9hYsDti0TZMASOSClBAFapbihul9VcbdgNSTCpQ8I+GPeoZAnPJNbKc1Ip08oQ95PdMJLqSNU
	BEv72pA==
X-Received: from pfblm11.prod.google.com ([2002:a05:6a00:3c8b:b0:82c:e899:f089])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:368c:b0:82c:e1a3:986f
 with SMTP id d2e1a72fcca58-839247bfb7bmr3652379b3a.43.1778000717292; Tue, 05
 May 2026 10:05:17 -0700 (PDT)
Date: Tue, 5 May 2026 10:05:15 -0700
In-Reply-To: <20260504231048.1184273-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260504224213.1049426-2-jthoughton@google.com> <20260504231048.1184273-1-jthoughton@google.com>
Message-ID: <afohshVlK9YcBk-f@google.com>
Subject: Re: [PATCH 1/5] KVM: arm64: Grab KVM MMU write lock in kvm_arch_flush_shadow_all()
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: chenhuacai@kernel.org, gshan@redhat.com, jhogan@kernel.org, 
	joey.gouly@arm.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mips@vger.kernel.org, loongarch@lists.linux.dev, maobibo@loongson.cn, 
	maz@kernel.org, oupton@kernel.org, pbonzini@redhat.com, ricarkol@google.com, 
	shahuang@redhat.com, stable@vger.kernel.org, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, zhaotianrui@loongson.cn
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 04, 2026, James Houghton wrote:
> On Mon, May 4, 2026 at 3:42=E2=80=AFPM James Houghton <jthoughton@google.=
com> wrote:
> >
> > kvm_arch_flush_shadow_all() may sometimes be called on the same `kvm`
> > concurrently in the event that the KVM's `mm` is __mmput() at the
> > same time that last reference to the KVM is being dropped.
> >
> > T1              T2
> > KVM_CREATE_VM
> >                 Get VM file from T1
> > close VM
> > exit_mm()       close VM
> >
> > T1: exit_mm() -> kvm_mmu_notifier_release() -> kvm_flush_shadow_all(),
> >     with only the KVM srcu read lock held.
> >
> > T2: kvm_vm_release() ---> mmu_notifier_unregister() ->
> >     kvm_mmu_notifier_release() -> kvm_flush_shadow_all(),
> >     again, with only the KVM srcu read lock held.
> >
> > This leads to a potential double-free of
> > kvm->arch.kvm_mmu_free_memory_cache and now with NV
> > kvm->arch.nested_mmus.

...

> >  void kvm_uninit_stage2_mmu(struct kvm *kvm)
> >  {
> > -       kvm_free_stage2_pgd(&kvm->arch.mmu);
> > +       lockdep_assert_held_write(&kvm->mmu_lock);
>=20
> *facepalm*.... this doesn't account for the other callers of
> kvm_uninit_stage2_mmu(). They will get lockdep warnings.
>=20
> I've attached a diff to the bottom of this reply that *does* deal with th=
em.
> :( Sorry.

...

> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index 883b6c1008fb..977598bff5e6 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> > @@ -1190,11 +1190,13 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
> >  {
> >         int i;
> >
> > +       guard(write_lock)(&kvm->mmu_lock);
> > +
> >         for (i =3D 0; i < kvm->arch.nested_mmus_size; i++) {
> >                 struct kvm_s2_mmu *mmu =3D &kvm->arch.nested_mmus[i];
> >
> >                 if (!WARN_ON(atomic_read(&mmu->refcnt)))
> > -                       kvm_free_stage2_pgd(mmu);
> > +                       kvm_free_stage2_pgd_locked(mmu);
> >         }
> >         kvfree(kvm->arch.nested_mmus);
> >         kvm->arch.nested_mmus =3D NULL;
> > --
> > 2.54.0.545.g6539524ca2-goog
>=20
> And here is the diff that should fix this patch. (Sorry!!)

There are more issues.  kvm->arch.mmu.split_page_cache can be freed by
kvm_arch_commit_memory_region(), which holds slots_lock and slots_arch_lock=
,
but not mmu_lock.

IMO, the handling of kvm->arch.mmu.split_page_cache should be reworked.  I =
don't
entirely get the motivation for aggressively freeing the cache.  The cache =
will
only be filled if KVM actually does eager page splitting, so it's not like =
KVM is
burning pages for setups that will never use the cache.

Maybe I'm underestimating how many pages arm64 needs in the worst case scen=
ario?
(I can't follow the math, too many macros).  But if KVM is configuring the =
cache
with a capacity that's _so_ high that the "wasted" memory is problematic, t=
hen we
probably should we revisit the capacity and algorithm.  E.g. if KVM is spli=
tting
from 1GiB =3D> 4KiB in a single pass (I can't tell if KVM does this on arm6=
4), then
we could break that into a 1GiB =3D> 2MiB =3D> 4KiB sequence.
