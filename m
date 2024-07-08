Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAA974077
	for <kvmarm@lists.linux.dev>; Mon,  8 Jul 2024 23:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720482151; cv=none; b=rOoNZJkIniMhFiyJtCCd5xX0Hjc7viekpbTYHc7PW59SFuNTAY6DXysutm8L24ubwSoRPPQjT5TtstGZg2Rd5vU7n7/CUGhC0raY582MXHIbCfEJ6SwVUHrMHrPQzB7x3LV3tKuFM7ZzVnun4UTZPXjjP8H83tAo3SH8nYuFgIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720482151; c=relaxed/simple;
	bh=fXFkuGwJtPDomAOLHssxdyjY3IJRo5Ot7cYvZXhXmlo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JJla39kZoHEJpoEjc3ndDaHUhPfLeiL813Ynd/0/WufDw6HTEWshdcRAXiiW6cBJ/oZA+nvseVIDfRdHMoygl18zbhTmyvh1+jpSB0V5nV0f55f4jrlKPsbckX1V8nIkZcBiapJ51uq0EKp2EC33b0U5dqHK00E+xeeOPsqP68M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ylM6xbbX; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ylM6xbbX"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-447f8aa87bfso165641cf.0
        for <kvmarm@lists.linux.dev>; Mon, 08 Jul 2024 16:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720482148; x=1721086948; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nM7n3F0up3r61YyqcXWbM5R0i4/2z/TwS0sdB2eyKMU=;
        b=ylM6xbbXEbgIzprag+G2zOG8xLzrCbweBvUArvaWeastHEIUBpk3isL7rLhwillaJ1
         gQYbIZ8F63EO3/aXnywz3Su2uIbZVEHtEqT31OAM+mPb9t4BfqdJBVX+lKZCfTjjf1eW
         aETehFQO1fStuK3Pig41rNlOUsVqj4S3wcGpGbDK6cF2CiNwBQSmTmZTkYheHMrSdxhA
         phpXSKNUucpxbOLucaNR9RymvITvtFZqQyU9/opLBUoVIECsckOgJT3xOZWHp498Jiqd
         yubW6/79RgJl0X3QaEMkHgwoXLSazRKqyyItT9RBhQJerW6qHz3vELTUBxDTeazzIuiI
         WpEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720482148; x=1721086948;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nM7n3F0up3r61YyqcXWbM5R0i4/2z/TwS0sdB2eyKMU=;
        b=qHA3GnrZDvYYalETGxR+zEym65G8+upFpNHJNNFlCfy3/HGtXQ1P1XCNyVRcLE7Rwe
         R3pJaLDDL1HMtvY9laWaAD+iWAh5/0nkuFqLmXPkukWY5ECR5+XTzPn2WTrXZQd2ob0z
         N3w0WTJS7VBxbbKPuXjMxVerQqnLyjXqzjzzVCNQOlR67ZtriG4WkhbeHB5vc+GKYuUJ
         grC5e9++XT1zflq6z7gfdYzHyYDmqa0acVbSOtRzYSDWyBTEAMYzu1rsWDlHVFRcDwZw
         KU+jxWXjiVBBU9qunMDhsNpBCj0eft7Jq0m5E1Ssn6zwoRmiqkBJ1xDdSGTtLTsVm+96
         vlCA==
X-Forwarded-Encrypted: i=1; AJvYcCXPXgKt/NIlPJIJvH4qWT/qSlMI6QRShw07yMS2gdm/Vj6sQW1595FB1RlCqS6gr2CA34ZpjLrfr/Zcv2xw4wL8FsHDAxfu
X-Gm-Message-State: AOJu0YxRdszvfEXaI/QqiLite6cRGFvLHlAXtAZk+p53f/lZpHWR9pXB
	6u3I0BAN00yxHypOd65S4zlAbnX0aax8/Fz4mmVlNGAdMEJ2P3PXDek211pNAUw705XJAZXJkWt
	P/onXDz/9m8qx/jlg6XoDh6i0NxR3fKQO+aUG
X-Google-Smtp-Source: AGHT+IF5waWqD1+AOGNDtNFnA/E3lGLbDiFUJIIuSfBZaHyKwMMyMoyshkPlNYgy3P4wdxcBdGual2ZDEbwUTDImpqE=
X-Received: by 2002:ac8:6742:0:b0:447:e4cb:bf50 with SMTP id
 d75a77b69052e-447fb2f6c08mr1579121cf.8.1720482148269; Mon, 08 Jul 2024
 16:42:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-9-jthoughton@google.com> <CAOUHufb2f_EwHY5LQ59k7Nh7aS1-ZbOKtkoysb8BtxRNRFMypQ@mail.gmail.com>
 <CADrL8HUJaG=O+jBVvXGVjJOriev9vxkZ6n27ekc5Pxv5D+fbcg@mail.gmail.com>
In-Reply-To: <CADrL8HUJaG=O+jBVvXGVjJOriev9vxkZ6n27ekc5Pxv5D+fbcg@mail.gmail.com>
From: Yu Zhao <yuzhao@google.com>
Date: Mon, 8 Jul 2024 17:41:49 -0600
Message-ID: <CAOUHufZ2Vd+Ea5vka20+SCVB446LZEA0mWy=RScN=7AChd869w@mail.gmail.com>
Subject: Re: [PATCH v5 8/9] mm: multi-gen LRU: Have secondary MMUs participate
 in aging
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Morse <james.morse@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Sean Christopherson <seanjc@google.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 8, 2024 at 11:31=E2=80=AFAM James Houghton <jthoughton@google.c=
om> wrote:
>
> On Fri, Jul 5, 2024 at 11:36=E2=80=AFAM Yu Zhao <yuzhao@google.com> wrote=
:
> >
> > On Mon, Jun 10, 2024 at 6:22=E2=80=AFPM James Houghton <jthoughton@goog=
le.com> wrote:
> > >
> > > Secondary MMUs are currently consulted for access/age information at
> > > eviction time, but before then, we don't get accurate age information=
.
> > > That is, pages that are mostly accessed through a secondary MMU (like
> > > guest memory, used by KVM) will always just proceed down to the oldes=
t
> > > generation, and then at eviction time, if KVM reports the page to be
> > > young, the page will be activated/promoted back to the youngest
> > > generation.
> > >
> > > The added feature bit (0x8), if disabled, will make MGLRU behave as i=
f
> > > there are no secondary MMUs subscribed to MMU notifiers except at
> > > eviction time.
> > >
> > > Implement aging with the new mmu_notifier_test_clear_young_fast_only(=
)
> > > notifier. For architectures that do not support this notifier, this
> > > becomes a no-op. For architectures that do implement it, it should be
> > > fast enough to make aging worth it.
> > >
> > > Suggested-by: Yu Zhao <yuzhao@google.com>
> > > Signed-off-by: James Houghton <jthoughton@google.com>
> > > ---
> > >
> > > Notes:
> > >     should_look_around() can sometimes use two notifiers now instead =
of one.
> > >
> > >     This simply comes from restricting myself from not changing
> > >     mmu_notifier_clear_young() to return more than just "young or not=
".
> > >
> > >     I could change mmu_notifier_clear_young() (and
> > >     mmu_notifier_test_young()) to return if it was fast or not. At th=
at
> > >     point, I could just as well combine all the notifiers into one no=
tifier,
> > >     like what was in v2 and v3.
> > >
> > >  Documentation/admin-guide/mm/multigen_lru.rst |   6 +-
> > >  include/linux/mmzone.h                        |   6 +-
> > >  mm/rmap.c                                     |   9 +-
> > >  mm/vmscan.c                                   | 185 ++++++++++++++--=
--
> > >  4 files changed, 164 insertions(+), 42 deletions(-)
> >
> > ...
> >
> > >  static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned=
 long end,
> > >                            struct mm_walk *args)
> > >  {
> > > @@ -3357,8 +3416,9 @@ static bool walk_pte_range(pmd_t *pmd, unsigned=
 long start, unsigned long end,
> > >         struct pglist_data *pgdat =3D lruvec_pgdat(walk->lruvec);
> > >         DEFINE_MAX_SEQ(walk->lruvec);
> > >         int old_gen, new_gen =3D lru_gen_from_seq(max_seq);
> > > +       struct mm_struct *mm =3D args->mm;
> > >
> > > -       pte =3D pte_offset_map_nolock(args->mm, pmd, start & PMD_MASK=
, &ptl);
> > > +       pte =3D pte_offset_map_nolock(mm, pmd, start & PMD_MASK, &ptl=
);
> > >         if (!pte)
> > >                 return false;
> > >         if (!spin_trylock(ptl)) {
> > > @@ -3376,11 +3436,12 @@ static bool walk_pte_range(pmd_t *pmd, unsign=
ed long start, unsigned long end,
> > >                 total++;
> > >                 walk->mm_stats[MM_LEAF_TOTAL]++;
> > >
> > > -               pfn =3D get_pte_pfn(ptent, args->vma, addr);
> > > +               pfn =3D get_pte_pfn(ptent, args->vma, addr, pgdat);
> > >                 if (pfn =3D=3D -1)
> > >                         continue;
> > >
> > > -               if (!pte_young(ptent)) {
> > > +               if (!pte_young(ptent) &&
> > > +                   !lru_gen_notifier_test_young(mm, addr)) {
> > >                         walk->mm_stats[MM_LEAF_OLD]++;
> > >                         continue;
> > >                 }
> > > @@ -3389,8 +3450,9 @@ static bool walk_pte_range(pmd_t *pmd, unsigned=
 long start, unsigned long end,
> > >                 if (!folio)
> > >                         continue;
> > >
> > > -               if (!ptep_test_and_clear_young(args->vma, addr, pte +=
 i))
> > > -                       VM_WARN_ON_ONCE(true);
> > > +               lru_gen_notifier_clear_young(mm, addr, addr + PAGE_SI=
ZE);
> > > +               if (pte_young(ptent))
> > > +                       ptep_test_and_clear_young(args->vma, addr, pt=
e + i);
> > >
> > >                 young++;
> > >                 walk->mm_stats[MM_LEAF_YOUNG]++;
> >
> >
> > There are two ways to structure the test conditions in walk_pte_range()=
:
> > 1. a single pass into the MMU notifier (combine test/clear) which
> > causes a cache miss from get_pfn_page() if the page is NOT young.
> > 2. two passes into the MMU notifier (separate test/clear) if the page
> > is young, which does NOT cause a cache miss if the page is NOT young.
> >
> > v2 can batch up to 64 PTEs, i.e., it only goes into the MMU notifier
> > twice every 64 PTEs, and therefore the second option is a clear win.
> >
> > But you are doing twice per PTE. So what's the rationale behind going
> > with the second option? Was the first option considered?
>
> Hi Yu,
>
> I didn't consider changing this from your v2[1]. Thanks for bringing it u=
p.
>
> The only real change I have made is that I reordered the
> (!test_spte_young() && !pte_young()) to what it is now (!pte_young()
> && !lru_gen_notifier_test_young()) because pte_young() can be
> evaluated much faster.
>
> I am happy to change the initial test_young() notifier to a
> clear_young() (and drop the later clear_young(). In fact, I think I
> should. Making the condition (!pte_young() &&
> !lru_gen_notifier_clear_young()) makes sense to me. This returns the
> same result as if it were !lru_gen_notifier_test_young() instead,
> there is no need for a second clear_young(), and we don't call
> get_pfn_folio() on pages that are not young.

We don't want to do that because we would lose the A-bit for a folio
that's beyond the current reclaim scope, i.e., the cases where
get_pfn_folio() returns NULL (a folio from another memcg, e.g.).

> WDYT? Have I misunderstood your comment?

I hope this is clear enough:

@@ -3395,7 +3395,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned
long start, unsigned long end,
                if (pfn =3D=3D -1)
                        continue;

-               if (!pte_young(ptent)) {
+               if (!pte_young(ptent) && !mm_has_notifiers(args->mm)) {
                        walk->mm_stats[MM_LEAF_OLD]++;
                        continue;
                }
@@ -3404,8 +3404,8 @@ static bool walk_pte_range(pmd_t *pmd, unsigned
long start, unsigned long end,
                if (!folio)
                        continue;

-               if (!ptep_test_and_clear_young(args->vma, addr, pte + i))
-                       VM_WARN_ON_ONCE(true);
+               if (!ptep_clear_young_notify(args->vma, addr, pte + i))
+                       continue;

                young++;
                walk->mm_stats[MM_LEAF_YOUNG]++;

> Also, I take it your comment was not just about walk_pte_range() but
> about the similar bits in lru_gen_look_around() as well, so I'll make
> whatever changes we agree on there too (or maybe factor out the common
> bits).
>
> [1]: https://lore.kernel.org/kvmarm/20230526234435.662652-11-yuzhao@googl=
e.com/
>
> > In addition, what about the non-lockless cases? Would this change make
> > them worse by grabbing the MMU lock twice per PTE?
>
> That's a good point. Yes I think calling the notifier twice here would
> indeed exacerbate problems with a non-lockless notifier.

I think so too, but I haven't verified it. Please do?
