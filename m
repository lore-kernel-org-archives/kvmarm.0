Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3525B5D6
	for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 16:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718124779; cv=none; b=EFGpUrE11hSd9113RK0dMYht5+/hh0EESO8ep4zcagKM3YfDGsORHCU1go3Ff8Ng8UmX5X2cLMbracfyVwqC1aEef67zT7lBowhr+59LosecEeEziHX1FZklUbSkHU7QrZRxUkceWQC4+/nnuz+LAS66dC7gQKXYKYoaGgv4yPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718124779; c=relaxed/simple;
	bh=cUks1IzqDZ+RbXqF/1qmr4hcitIbzZ5D/+vX7HNk2w8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n+M2ywoLmt67TBl5aN1Qsow6fMb4hA+vXJTpUaR/lrD2+69zqbV1P0GOUH1TqE9lF4MbTEv0Q5isoUQ1V1s3nh8f0/6QfaAxQebavy37B+M1QbhUUPb/pmHLxJ/ueRy9Ah7VvcfD4VumNhf14BmYDfNmnB9N4Vw5GicxRWmjG4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WBxfx7If; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WBxfx7If"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-44056f72257so111cf.0
        for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 09:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718124775; x=1718729575; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dNrvkbjbmCuGBxHxb5OVsA/4jQBqGMp/CsGTWofpaJ8=;
        b=WBxfx7If193ajWD7HEv5oqiDbqtTVCgxUD9NSrm7GdWpYiRTTjYHHSmNlCHq4ma4QU
         PBJxYjTNSnWBXiUO6bM1NiqmHsUqaMlFXpuTveXTLbyr0ZsjoIS7PxMmANUURXor4UxP
         n/KXIVWKXgqq9fHvHD0365Z51gmUk4knIBBo2gnz2vP3HhFGPpO4sEhTHPHutMyClH+t
         mCwI+mW5scJSG5Xyns23EV1qDlM3tHD7secuGxcZPCNPPnPsnu20xnppco5lrJvP7M9K
         zVyB6+QFB4y02tiQQP/vCNnrCirSzO9M2NUn672UvQky1itMPSVBOPHTgjoi1w8z4ZCC
         hd2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718124775; x=1718729575;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dNrvkbjbmCuGBxHxb5OVsA/4jQBqGMp/CsGTWofpaJ8=;
        b=MiagcxSAKbZXENqg6o8CAG72+BTb5kFUKQVR/JLyhPAM2hi2sI8ZzURgqYKOpuO0dp
         h61vcb00dS5B18dBXktL9tRgsz+sJtA7gLYtnhn6juz2GI6G2n8EQ+JXYjQugDESWRyb
         9Y+mmYbUH+85TAeTkp2wcVZLUE6cEOmpVyOgcFfejRcsf4e4bxFMGMJ8DSuCa3B3QR3b
         jMSUOhmaLkwHOqyxTZmBDXg2LsdG4OZXdrzY44yGWMcXjyQ9kcyO0qo/D5t4X7NdFZW5
         7tf7v6hkE5ZREiC0gMbgSV87qPvwCIQEDnYiEms5ZBs+7CmT/6VO5wOyN8BG1llI/apH
         Xhfw==
X-Forwarded-Encrypted: i=1; AJvYcCX8eB26hQmct/YSEFqm4gggvi5p+mwwW+1d1q73ewfoybnvMz6Gh0AS5KCBnwb8wpkm6gG698lcgpxU8CDpI24iIGYxN1mi
X-Gm-Message-State: AOJu0YzumTtrjFEnWwBRJs3XwBpe39snwX62yy5ZWpKke6BMs5XF6WJs
	GZB+niYsXSfdJEvL21387mw9rrPq21yrIJyS8LGLQjv5CpDjMeiBYV/CySxLBpKgdc02zcOqcku
	++FagV4VSYFa9C0Ks5IpT2doDO6Z0l6aMoZTA
X-Google-Smtp-Source: AGHT+IETSJr/vthLSu4M/9Ufm7UR5Sik6z7Xo2T1/mUMxnuXtcmtqz9kCiAXEk/F0m7s9fStq+7fFskXaiSQE2MAAyQ=
X-Received: by 2002:a05:622a:550d:b0:441:3c01:d0fa with SMTP id
 d75a77b69052e-4414798d3c1mr3642241cf.23.1718124775151; Tue, 11 Jun 2024
 09:52:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-4-jthoughton@google.com> <ZmfnYnm3K_rHX_VB@linux.dev>
In-Reply-To: <ZmfnYnm3K_rHX_VB@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Tue, 11 Jun 2024 09:52:17 -0700
Message-ID: <CADrL8HUSOZumE403KF6yjdy5CVkjdDjiGHDwuhOaM7H9Jq5Cjw@mail.gmail.com>
Subject: Re: [PATCH v5 3/9] KVM: arm64: Relax locking for kvm_test_age_gfn and kvm_age_gfn
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Morse <james.morse@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Sean Christopherson <seanjc@google.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 10, 2024 at 10:58=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Tue, Jun 11, 2024 at 12:21:39AM +0000, James Houghton wrote:
> > Replace the MMU write locks (taken in the memslot iteration loop) for
> > read locks.
> >
> > Grabbing the read lock instead of the write lock is safe because the
> > only requirement we have is that the stage-2 page tables do not get
> > deallocated while we are walking them. The stage2_age_walker() callback
> > is safe to race with itself; update the comment to reflect the
> > synchronization change.
> >
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> >  arch/arm64/kvm/Kconfig       |  1 +
> >  arch/arm64/kvm/hyp/pgtable.c | 15 +++++++++------
> >  arch/arm64/kvm/mmu.c         | 26 ++++++++++++++++++++------
> >  3 files changed, 30 insertions(+), 12 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > index 58f09370d17e..7a1af8141c0e 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -22,6 +22,7 @@ menuconfig KVM
> >       select KVM_COMMON
> >       select KVM_GENERIC_HARDWARE_ENABLING
> >       select KVM_GENERIC_MMU_NOTIFIER
> > +     select KVM_MMU_NOTIFIER_YOUNG_LOCKLESS
> >       select HAVE_KVM_CPU_RELAX_INTERCEPT
> >       select KVM_MMIO
> >       select KVM_GENERIC_DIRTYLOG_READ_PROTECT
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.=
c
> > index 9e2bbee77491..b1b0f7148cff 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1319,10 +1319,10 @@ static int stage2_age_walker(const struct kvm_p=
gtable_visit_ctx *ctx,
> >       data->young =3D true;
> >
> >       /*
> > -      * stage2_age_walker() is always called while holding the MMU loc=
k for
> > -      * write, so this will always succeed. Nonetheless, this delibera=
tely
> > -      * follows the race detection pattern of the other stage-2 walker=
s in
> > -      * case the locking mechanics of the MMU notifiers is ever change=
d.
> > +      * This walk may not be exclusive; the PTE is permitted to change
>
> s/may not/is not/

Will fix.

>
> > +      * from under us. If there is a race to update this PTE, then the
> > +      * GFN is most likely young, so failing to clear the AF is likely
> > +      * to be inconsequential.
> >        */
> >       if (data->mkold && !stage2_try_set_pte(ctx, new))
> >               return -EAGAIN;
> > @@ -1345,10 +1345,13 @@ bool kvm_pgtable_stage2_test_clear_young(struct=
 kvm_pgtable *pgt, u64 addr,
> >       struct kvm_pgtable_walker walker =3D {
> >               .cb             =3D stage2_age_walker,
> >               .arg            =3D &data,
> > -             .flags          =3D KVM_PGTABLE_WALK_LEAF,
> > +             .flags          =3D KVM_PGTABLE_WALK_LEAF |
> > +                               KVM_PGTABLE_WALK_SHARED,
> >       };
> > +     int r;
> >
> > -     WARN_ON(kvm_pgtable_walk(pgt, addr, size, &walker));
> > +     r =3D kvm_pgtable_walk(pgt, addr, size, &walker);
> > +     WARN_ON(r && r !=3D -EAGAIN);
>
> I could've been more explicit last time around, could you please tone
> this down to WARN_ON_ONCE() as well?

Will do, thanks.

>
> >       return data.young;
> >  }
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 8bcab0cc3fe9..a62c27a347ed 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1773,25 +1773,39 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struc=
t kvm_gfn_range *range)
> >  bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> >  {
> >       u64 size =3D (range->end - range->start) << PAGE_SHIFT;
> > +     bool young =3D false;
> > +
> > +     read_lock(&kvm->mmu_lock);
> >
> >       if (!kvm->arch.mmu.pgt)
> >               return false;
>
> I'm guessing you meant to have 'goto out' here, since this early return
> fails to drop the mmu_lock.

Ah sorry! Thanks for catching this.
