Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA54B4C94
	for <kvmarm@lists.linux.dev>; Wed, 12 Jun 2024 00:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718152468; cv=none; b=lhjuCV4RrZdsY+y6iZQlihi8eEROsmAYGGu3LINhEQ9H8kyBZZcBOK1y7wXzAV+KgRJvdnHBw4LK7g5tuyp2xURbWMg4yFHqBPxGwcxHelM5S+8bUzzixZalw5FGy1uJ4woqNlR9pTzj1yEGsZWnaItmSWotaop9SPVUynxG2wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718152468; c=relaxed/simple;
	bh=VXq4cGbbJ5wUC3sXPQGmmw6XT5m9n5fm86NSv1tTzA0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GlsPJUpPd1K9Hmmx1CqbBz8HiOwzP0SPE083KXgLaAMEhytMNrttJJJxxHiAobAmvuXKvCpL4UeCDiDcPp/F8ebpWtHhq6BHbNGFRX/z6zkOqxZb2HNVdDJ8khMyCDyK2i3aBimxlCL4Canh0gKJvpGXWB0Jdy/J4m2bMpWSo4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YpVpXyvu; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YpVpXyvu"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-667fd2bf4feso5513316a12.3
        for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 17:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718152466; x=1718757266; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wZtnx2ypD298MOxfRWQWCGDlyBsjwxOedcKmzJ1Vh/w=;
        b=YpVpXyvuBSJ1jeZUwGHS+c9uIk3Al5jOkOkxm2AU1RXBE1A7meEmf/JcTAV8KSwWK8
         jRL3zoHJsOGNY3ubF5fBj4TWwcZguoyanCgchSo8n86XfY1AG33R6CZeqYTMnuGyX/CC
         EteOOkgQDAFDRxeSc8q+Quu8pqxIZvxRJ4ivHZTWqWQUJdoP7i0/5GFHJsdDT2pVUb0z
         mJekZAFY5eeE76t+kJj4ul5SgcQiDrMxS+iQnyLSRSqdEOP0mIUnfijWIPFqeU2GBCxY
         dCi1CzwkS8LRifqScdePgeLqsM3swfmJQ9ke5XTOQyfnucq1QBE6jPf9X3ZEjdwPbKKE
         H4ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718152466; x=1718757266;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wZtnx2ypD298MOxfRWQWCGDlyBsjwxOedcKmzJ1Vh/w=;
        b=DpyBeJFGxYRVOi2YyB+juzfJrjV8NQp+TaNSexFXnG9PB78fYkwPBNwP9XYmx3DJJl
         cTI/x0AxN5R1TMDKPWTfwtcJrQK+KHpnVfgBdKEkRYEJbu0x7feaZrs0h5y9FGBJbSAv
         iyiEAgFJV0f/1vNhK42Yws9MgZOL+Sc0ox91t0RydX5cBQqRu40f3BYrWbhgseLFOuiS
         bAGXiVJV9T+TGT71CHNSgAkErTndmlvqodLaKMk+A8kCVP60SmhwRYIwO2gxNyVOJb/h
         r1AyCwhODEp4Ow01yyErxMxlOqRhPhmASpwKmBBmHsg92Hr1pFD2/rLlndHozjaTGAsq
         PD+A==
X-Forwarded-Encrypted: i=1; AJvYcCWPkcrmcRjGoQNRil/rmjk41D1gGD4mqUveTH4frw9C/x5nmXr3cMcM1pXC5yt0xtBholB/YAzn/FNXkO1f5kClvfBVb6jJ
X-Gm-Message-State: AOJu0YzqXztvOqLBkF7gNRFdyHuFjqsEYHlkn6eM0M9/dPrA8DTbcgd2
	rgtrnloBE25tYPlYTkRnQe+sWBJb7SZaQ4NkymgrBNmA66WkWn+kPakRoYM+Ak1EyVizhEKrroX
	X3w==
X-Google-Smtp-Source: AGHT+IEfUID57KRVZYNnDxF72ThhfPcukhPZNhZpGIpvsildrCe9AtFmJCUvjyphH5TOLB/4W627VDGrjJE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:515:b0:6f6:7aa3:fc71 with SMTP id
 41be03b00d2f7-6fae161fed2mr810a12.2.1718152466035; Tue, 11 Jun 2024 17:34:26
 -0700 (PDT)
Date: Tue, 11 Jun 2024 17:34:24 -0700
In-Reply-To: <CADrL8HU_FKHTz_6d=xhVLZFDQ_zQo-zdB2rqdpa2CKusa1uo+A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-5-jthoughton@google.com> <CAOUHufYGqbd45shZkGCpqeTV9wcBDUoo3iw1SKiDeFLmrP0+=w@mail.gmail.com>
 <CADrL8HVHcKSW3hiHzKTit07gzo36jtCZCnM9ZpueyifgNdGggw@mail.gmail.com>
 <ZmioedgEBptNoz91@google.com> <CADrL8HU_FKHTz_6d=xhVLZFDQ_zQo-zdB2rqdpa2CKusa1uo+A@mail.gmail.com>
Message-ID: <ZmjtEBH42u7NUWRc@google.com>
Subject: Re: [PATCH v5 4/9] mm: Add test_clear_young_fast_only MMU notifier
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Yu Zhao <yuzhao@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2024, James Houghton wrote:
> On Tue, Jun 11, 2024 at 12:42=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > --
> > diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
> > index 7b77ad6cf833..07872ae00fa6 100644
> > --- a/mm/mmu_notifier.c
> > +++ b/mm/mmu_notifier.c
> > @@ -384,7 +384,8 @@ int __mmu_notifier_clear_flush_young(struct mm_stru=
ct *mm,
> >
> >  int __mmu_notifier_clear_young(struct mm_struct *mm,
> >                                unsigned long start,
> > -                              unsigned long end)
> > +                              unsigned long end,
> > +                              bool fast_only)
> >  {
> >         struct mmu_notifier *subscription;
> >         int young =3D 0, id;
> > @@ -393,9 +394,12 @@ int __mmu_notifier_clear_young(struct mm_struct *m=
m,
> >         hlist_for_each_entry_rcu(subscription,
> >                                  &mm->notifier_subscriptions->list, hli=
st,
> >                                  srcu_read_lock_held(&srcu)) {
> > -               if (subscription->ops->clear_young)
> > -                       young |=3D subscription->ops->clear_young(subsc=
ription,
> > -                                                               mm, sta=
rt, end);
> > +               if (!subscription->ops->clear_young ||
> > +                   fast_only && !subscription->ops->has_fast_aging)
> > +                       continue;
> > +
> > +               young |=3D subscription->ops->clear_young(subscription,
> > +                                                       mm, start, end)=
;
>=20
> KVM changing has_fast_aging dynamically would be slow, wouldn't it?

No, it could/would be done quite quickly.  But, I'm not suggesting has_fast=
_aging
be dynamic, i.e. it's not an "all aging is guaranteed to be fast", it's a "=
this
MMU _can_ do fast aging".  It's a bit fuzzy/weird mostly because KVM can es=
sentially
have multiple secondary MMUs wired up to the same mmu_notifier.

> I feel like it's simpler to just pass in fast_only into `clear_young` its=
elf
> (and this is how I interpreted what you wrote above anyway).

Eh, maybe?  A "has_fast_aging" flag is more robust in the sense that it req=
uires
secondary MMUs to opt-in, i.e. all secondary MMUs will be considered "slow"=
 by
default.
=20
It's somewhat of a moot point because KVM is the only secondary MMU that im=
plements
.clear_young() and .test_young() (which I keep forgetting), and that seems =
unlikely
to change.

A flag would also avoid an indirect call and thus a RETPOLINE when CONFIG_R=
ETPOLINE=3Dy,
i.e. would be a minor optimization when KVM doesn't suppport fast aging.  B=
ut that's
probably a pretty unlikely combination, so it's probably not a valid argume=
nt.

So, I guess I don't have a strong opinion?

> > Double ugh.  Peeking ahead at the "failure" code, NAK to adding
> > kvm_arch_young_notifier_likely_fast for all the same reasons I objected=
 to
> > kvm_arch_has_test_clear_young() in v1.  Please stop trying to do anythi=
ng like
> > that, I will NAK each every attempt to have core mm/ code call directly=
 into KVM.
>=20
> Sorry to make you repeat yourself; I'll leave it out of v6. I don't
> like it either, but I wasn't sure how important it was to avoid
> calling into unnecessary notifiers if the TDP MMU were completely
> disabled.

If it's important, e.g. for performance, then the mmu_notifier should have =
a flag
so that the behavior doesn't assume a KVM backend.   Hence my has_fast_agin=
g
suggestion.

> > Anyways, back to this code, before we spin another version, we need to =
agree on
> > exactly what behavior we want out of secondary MMUs.  Because to me, th=
e behavior
> > proposed in this version doesn't make any sense.
> >
> > Signalling failure because KVM _might_ have relevant aging information =
in SPTEs
> > that require taking kvm->mmu_lock is a terrible tradeoff.  And for the =
test_young
> > case, it's flat out wrong, e.g. if a page is marked Accessed in the TDP=
 MMU, then
> > KVM should return "young", not "failed".
>=20
> Sorry for this oversight. What about something like:
>=20
> 1. test (and maybe clear) A bits on TDP MMU
> 2. If accessed && !should_clear: return (fast)
> 3. if (fast_only): return (fast)
> 4. If !(must check shadow MMU): return (fast)
> 5. test (and maybe clear) A bits in shadow MMU
> 6. return (slow)

I don't understand where the "must check shadow MMU" in #4 comes from.  I a=
lso
don't think it's necessary; see below.
=20
> Some of this reordering (and maybe a change from
> kvm_shadow_root_allocated() to checking indirect_shadow_pages or
> something else) can be done in its own patch.
>
> > So rather than failing the fast aging, I think what we want is to know =
if an
> > mmu_notifier found a young SPTE during a fast lookup.  E.g. something l=
ike this
> > in KVM, where using kvm_has_shadow_mmu_sptes() instead of kvm_memslots_=
have_rmaps()
> > is an optional optimization to avoid taking mmu_lock for write in paths=
 where a
> > (very rare) false negative is acceptable.
> >
> >   static bool kvm_has_shadow_mmu_sptes(struct kvm *kvm)
> >   {
> >         return !tdp_mmu_enabled || READ_ONCE(kvm->arch.indirect_shadow_=
pages);
> >   }
> >
> >   static int __kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range=
,
> >                          bool fast_only)
> >   {
> >         int young =3D 0;
> >
> >         if (!fast_only && kvm_has_shadow_mmu_sptes(kvm)) {
> >                 write_lock(&kvm->mmu_lock);
> >                 young =3D kvm_handle_gfn_range(kvm, range, kvm_age_rmap=
);
> >                 write_unlock(&kvm->mmu_lock);
> >         }
> >
> >         if (tdp_mmu_enabled && kvm_tdp_mmu_age_gfn_range(kvm, range))
> >                 young =3D 1 | MMU_NOTIFY_WAS_FAST;
>=20
> I don't think this line is quite right. We might set
> MMU_NOTIFY_WAS_FAST even when we took the mmu_lock. I understand what
> you mean though, thanks.

The name sucks, but I believe the logic is correct.  As posted here in v5, =
the
MGRLU code wants to age both fast _and_ slow MMUs.  AIUI, the intent is to =
always
get aging information, but only look around at other PTEs if it can be done=
 fast.

	if (should_walk_secondary_mmu()) {
		notifier_result =3D
			mmu_notifier_test_clear_young_fast_only(
					vma->vm_mm, addr, addr + PAGE_SIZE,
					/*clear=3D*/true);
	}

	if (notifier_result & MMU_NOTIFIER_FAST_FAILED)
		secondary_young =3D mmu_notifier_clear_young(vma->vm_mm, addr,
							   addr + PAGE_SIZE);
	else {
		secondary_young =3D notifier_result & MMU_NOTIFIER_FAST_YOUNG;
		notifier_was_fast =3D true;
	}

The change, relative to v5, that I am proposing is that MGLRU looks around =
if
the page was young in _a_ "fast" secondary MMU, whereas v5 looks around if =
and
only if _all_ secondary MMUs are fast.

In other words, if a fast MMU had a young SPTE, look around _that_ MMU, via=
 the
fast_only flag.
