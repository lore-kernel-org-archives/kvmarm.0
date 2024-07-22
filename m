Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125301E891
	for <kvmarm@lists.linux.dev>; Mon, 22 Jul 2024 21:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721683451; cv=none; b=K6KNEYyC4arB3MENjl7c89aeir0SXDMUAR0us1jHniWiHUdRyPivqUjRLxCp2Ep/0NFJPpkpOeUZ7jL9e+M2ZwUPJxKcxl5D7OQEg2Q3TTGk8z+BVV+a/8fKDDQXUe7pFJGUSRK901ZKg4ojQWpM18cYJB7Z1GaC+YYtDOXRF74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721683451; c=relaxed/simple;
	bh=BThTVvfcR9JWFWvbsMUclsG5OU2SU4XBfxzGrpzk6tQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k7pvXVMjeCMs5SrNtyv14uPZQImZE0lwce1UJsbQfkQGO4tNkTXHxvuYJ/WvBsjkhUWWlp/F9oBremJbGxBWT5gRIei/Wu3XEsXbDImMNEz7Zr0yLVoBvSy5CAITbbpdV5Qcc/yhkoUX+jHzbxVlziZ3ENYznDlmSDjT3srzELQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SGiZkfv+; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SGiZkfv+"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-44e534a1fbeso28981cf.1
        for <kvmarm@lists.linux.dev>; Mon, 22 Jul 2024 14:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721683449; x=1722288249; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jUvbV8cr91Az3570PAWe2v2K6wrQs4UKFeU0Jgh3ytQ=;
        b=SGiZkfv+dnsQmkLeuVgYYfNIGBUHo4a8ezAk9V3Lkjp/YaJh5jI8vsFVi2pYsH3Wf0
         vOFGI3TyECzBnf/rWfBe9jtoNmGuKfVg4Si79HYbyQ8edKEOVrWlMkSa+LNIDPV576dc
         +NX7VTQxTUh845cLFqnzLU9cQ9DIFF9Y8Oipvmf9Cl/CmM/0/ABRx7RRJSP0KSovI2YL
         ZugLnOiJ8esaPsir9GBKGcA7r3YMyA36DvT8jQj4Ey6diFXo9c7Iwbk0lbUkC5tjS/3Q
         6CNM8fu9paG/vYmQ9vyg6K6NmVTeMXbk1//tITklHkP7uLQC0ahWUyTGhOSDN+Pqpq0U
         s4PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721683449; x=1722288249;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jUvbV8cr91Az3570PAWe2v2K6wrQs4UKFeU0Jgh3ytQ=;
        b=c5w4ZalfCGLiMh8jpoRXRQSYbyjlRYsAtZaj6O8+XwiyeAMD0Q+VPgEYPg+KpuTE4G
         Aj3qPexnY7yB+VBSCWchOB5MO4fjydDINVsU2ETA35p+CDzHeRYVLnKicCeOrfDEln9l
         secerlQLZYmL5yrNp7EdlKJQaCLDvOr7cONzrEDpHixkoIo4j1ugAX9lfWhgGPyvJPqt
         mldspdRaZZgg709rWhPOYZUbRQE45N/F3rYBMsagfHXn15zRqvUMcyy/qHo/cr3lTt6y
         m3Xzp606FhTIjMq0CX1WWfVMEnsoq19Cz5ZFwfc1dySZYdWGuZSLUz3cOUMLXZIGCxdc
         7XXA==
X-Forwarded-Encrypted: i=1; AJvYcCVQbz8WpBHt6ahniN/XToYArnCTlZOxzlR9tTvJ4fqQD0Ahh7cwr46T2mN3pMO8K6RHW4YcW4IbVMqnJlYq7Um7+Qt8jk2O
X-Gm-Message-State: AOJu0YwxXziyiH8MAAh5zdQw6yQo8P0hv6Xxms2EEq+UkPgm8INsn2IX
	tmPqN0zhJmYJiCARARBP0z4uKHTajzWTavUSoYeNJj58sBd2Hg5APc2icemqXv2ORTcNYdz5YQ6
	kGXvWN3+6dwIpi7txmeSOEHUlRTAKLjmltGDh
X-Google-Smtp-Source: AGHT+IF65D9l0J9nysjn+Fs0bUa7Rk1bA005g2DJfpgR1lRIXz0pmT072M//KBwaPKskcNk0gii+b5JQqm5e6s9QHbM=
X-Received: by 2002:a05:622a:164a:b0:447:e8bd:2fbe with SMTP id
 d75a77b69052e-44faa96a947mr5161191cf.1.1721683448578; Mon, 22 Jul 2024
 14:24:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-9-jthoughton@google.com> <CAOUHufb2f_EwHY5LQ59k7Nh7aS1-ZbOKtkoysb8BtxRNRFMypQ@mail.gmail.com>
 <CADrL8HUJaG=O+jBVvXGVjJOriev9vxkZ6n27ekc5Pxv5D+fbcg@mail.gmail.com>
 <CAOUHufZ2Vd+Ea5vka20+SCVB446LZEA0mWy=RScN=7AChd869w@mail.gmail.com> <CADrL8HVRSyS8ZADRTvHZ-QDKBRv1SFvVyJKkr-CW2mzpNjW5Zw@mail.gmail.com>
In-Reply-To: <CADrL8HVRSyS8ZADRTvHZ-QDKBRv1SFvVyJKkr-CW2mzpNjW5Zw@mail.gmail.com>
From: Yu Zhao <yuzhao@google.com>
Date: Mon, 22 Jul 2024 15:23:29 -0600
Message-ID: <CAOUHufapvh13G9CAwsGiap0=LjE+qor4i1hT=3APOtBSjtX4Kw@mail.gmail.com>
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

On Mon, Jul 22, 2024 at 2:46=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> On Mon, Jul 8, 2024 at 4:42=E2=80=AFPM Yu Zhao <yuzhao@google.com> wrote:
> >
> > On Mon, Jul 8, 2024 at 11:31=E2=80=AFAM James Houghton <jthoughton@goog=
le.com> wrote:
> > >
> > > On Fri, Jul 5, 2024 at 11:36=E2=80=AFAM Yu Zhao <yuzhao@google.com> w=
rote:
> > > >
> > > > On Mon, Jun 10, 2024 at 6:22=E2=80=AFPM James Houghton <jthoughton@=
google.com> wrote:
> > > > > @@ -3389,8 +3450,9 @@ static bool walk_pte_range(pmd_t *pmd, unsi=
gned long start, unsigned long end,
> > > > >                 if (!folio)
> > > > >                         continue;
> > > > >
> > > > > -               if (!ptep_test_and_clear_young(args->vma, addr, p=
te + i))
> > > > > -                       VM_WARN_ON_ONCE(true);
> > > > > +               lru_gen_notifier_clear_young(mm, addr, addr + PAG=
E_SIZE);
> > > > > +               if (pte_young(ptent))
> > > > > +                       ptep_test_and_clear_young(args->vma, addr=
, pte + i);
> > > > >
> > > > >                 young++;
> > > > >                 walk->mm_stats[MM_LEAF_YOUNG]++;
> > > >
> > > >
> > > > There are two ways to structure the test conditions in walk_pte_ran=
ge():
> > > > 1. a single pass into the MMU notifier (combine test/clear) which
> > > > causes a cache miss from get_pfn_page() if the page is NOT young.
> > > > 2. two passes into the MMU notifier (separate test/clear) if the pa=
ge
> > > > is young, which does NOT cause a cache miss if the page is NOT youn=
g.
> > > >
> > > > v2 can batch up to 64 PTEs, i.e., it only goes into the MMU notifie=
r
> > > > twice every 64 PTEs, and therefore the second option is a clear win=
.
> > > >
> > > > But you are doing twice per PTE. So what's the rationale behind goi=
ng
> > > > with the second option? Was the first option considered?
> > >
> > > Hi Yu,
> > >
> > > I didn't consider changing this from your v2[1]. Thanks for bringing =
it up.
> > >
> > > The only real change I have made is that I reordered the
> > > (!test_spte_young() && !pte_young()) to what it is now (!pte_young()
> > > && !lru_gen_notifier_test_young()) because pte_young() can be
> > > evaluated much faster.
> > >
> > > I am happy to change the initial test_young() notifier to a
> > > clear_young() (and drop the later clear_young(). In fact, I think I
> > > should. Making the condition (!pte_young() &&
> > > !lru_gen_notifier_clear_young()) makes sense to me. This returns the
> > > same result as if it were !lru_gen_notifier_test_young() instead,
> > > there is no need for a second clear_young(), and we don't call
> > > get_pfn_folio() on pages that are not young.
> >
> > We don't want to do that because we would lose the A-bit for a folio
> > that's beyond the current reclaim scope, i.e., the cases where
> > get_pfn_folio() returns NULL (a folio from another memcg, e.g.).
> >
> > > WDYT? Have I misunderstood your comment?
> >
> > I hope this is clear enough:
> >
> > @@ -3395,7 +3395,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned
> > long start, unsigned long end,
> >                 if (pfn =3D=3D -1)
> >                         continue;
> >
> > -               if (!pte_young(ptent)) {
> > +               if (!pte_young(ptent) && !mm_has_notifiers(args->mm)) {
> >                         walk->mm_stats[MM_LEAF_OLD]++;
> >                         continue;
> >                 }
> > @@ -3404,8 +3404,8 @@ static bool walk_pte_range(pmd_t *pmd, unsigned
> > long start, unsigned long end,
> >                 if (!folio)
> >                         continue;
> >
> > -               if (!ptep_test_and_clear_young(args->vma, addr, pte + i=
))
> > -                       VM_WARN_ON_ONCE(true);
> > +               if (!ptep_clear_young_notify(args->vma, addr, pte + i))
>
> walk->mm_stats[MM_LEAF_OLD]++ should be here, I take it.
>
> > +                       continue;
> >
> >                 young++;
> >                 walk->mm_stats[MM_LEAF_YOUNG]++;
> >
> > > Also, I take it your comment was not just about walk_pte_range() but
> > > about the similar bits in lru_gen_look_around() as well, so I'll make
> > > whatever changes we agree on there too (or maybe factor out the commo=
n
> > > bits).
> > >
> > > [1]: https://lore.kernel.org/kvmarm/20230526234435.662652-11-yuzhao@g=
oogle.com/
> > >
> > > > In addition, what about the non-lockless cases? Would this change m=
ake
> > > > them worse by grabbing the MMU lock twice per PTE?
> > >
> > > That's a good point. Yes I think calling the notifier twice here woul=
d
> > > indeed exacerbate problems with a non-lockless notifier.
> >
> > I think so too, but I haven't verified it. Please do?
>
> I have some results now, sorry for the wait.
>
> It seems like one notifier is definitely better. It doesn't look like
> the read lock actually made anything worse with what I was testing
> (faulting memory in while doing aging). This is kind of surprising,

Not at all if you were only doing the aging path, which only takes the
lock for read.

Under memory pressure, we need to both the aging and eviction, and the
latter has to take the lock for write (to unmap). And that's when the
real contention happens, because the search space is too big -- the
entire system memory for global reclaim -- unmapping can easily
collide with clearing the A-bit.

> but either way, I'll change it to the single notifier in v6. Thanks
> Yu!
>
> Here are the results I'm basing this conclusion on, using the selftest
> added at the end of this series.
>
> # Use taskset to minimize NUMA concern.
> # Give an extra core for the aging thread.
> # THPs disabled (echo never > /sys/kernel/mm/transparent_hugepage/enabled=
)
>
> x86:
>
> # taskset -c 0-32 ./access_tracking_perf_test -l -v 32
> # # One notifier
> Populating memory             : 1.933017284s
> Writing to populated memory   : 0.017323539s
> Reading from populated memory : 0.013113260s
> lru_gen: Aging                : 0.894133259s
> lru_gen: Aging                : 0.738950525s
> Writing to idle memory        : 0.059661329s
> lru_gen: Aging                : 0.922719935s
> lru_gen: Aging                : 0.829129877s
> Reading from idle memory      : 0.059095098s
> lru_gen: Aging                : 0.922689975s
>
> # # Two notifiers
> Populating memory             : 1.842645795s
> Writing to populated memory   : 0.017277075s
> Reading from populated memory : 0.013047457s
> lru_gen: Aging                : 0.900751764s
> lru_gen: Aging                : 0.707203167s
> Writing to idle memory        : 0.060663733s
> lru_gen: Aging                : 1.539957250s  <------ got longer
> lru_gen: Aging                : 0.797475887s
> Reading from idle memory      : 0.084415591s
> lru_gen: Aging                : 1.539417121s  <------ got longer
>
> arm64*:
> (*Patched to do aging; not done in v5 or v6. Doing this to see if the rea=
d
> lock is made substantially worse by using two notifiers vs. one.)
>
> # taskset -c 0-16 ./access_tracking_perf_test -l -v 16 -m 3
> # # One notifier
> Populating memory             : 1.439261355s
> Writing to populated memory   : 0.009755279s
> Reading from populated memory : 0.007714120s
> lru_gen: Aging                : 0.540183328s
> lru_gen: Aging                : 0.455427973s
> Writing to idle memory        : 0.010130399s
> lru_gen: Aging                : 0.563424247s
> lru_gen: Aging                : 0.500419850s
> Reading from idle memory      : 0.008519640s
> lru_gen: Aging                : 0.563178643s
>
> # # Two notifiers
> Populating memory             : 1.526805625s
> Writing to populated memory   : 0.009836118s
> Reading from populated memory : 0.007757280s
> lru_gen: Aging                : 0.537770978s
> lru_gen: Aging                : 0.421915391s
> Writing to idle memory        : 0.010281959s
> lru_gen: Aging                : 0.971448688s  <------ got longer
> lru_gen: Aging                : 0.466956547s
> Reading from idle memory      : 0.008588559s
> lru_gen: Aging                : 0.971030648s  <------ got longer
>
>
> arm64, faulting memory in while aging:
>
> # perf record -g -- taskset -c 0-16 ./access_tracking_perf_test -l -v 16 =
-m 3 -p
> # # One notifier
> vcpu wall time                : 1.433908058s
> lru_gen avg pass duration     : 0.172128073s, (passes:11, total:1.8934088=
07s)
>
> # # Two notifiers
> vcpu wall time                : 1.450387765s
> lru_gen avg pass duration     : 0.175652974s, (passes:10, total:1.7565297=
44s)
>
> # perf report
> # # One notifier
> -    6.25%     0.00%  access_tracking  [kernel.kallsyms]  [k] try_to_inc_=
max_seq
>    - try_to_inc_max_seq
>       - 6.06% walk_page_range
>            __walk_page_range
>          - walk_pgd_range
>             - 6.04% walk_pud_range
>                - 4.73% __mmu_notifier_clear_young
>                   + 4.29% kvm_mmu_notifier_clear_young
>
> # # Two notifiers
> -    6.43%     0.00%  access_tracking  [kernel.kallsyms]  [k] try_to_inc_=
max_seq
>    - try_to_inc_max_seq
>       - 6.25% walk_page_range
>            __walk_page_range
>          - walk_pgd_range
>             - 6.23% walk_pud_range
>                - 2.75% __mmu_notifier_test_young
>                   + 2.48% kvm_mmu_notifier_test_young
>                - 2.39% __mmu_notifier_clear_young
>                   + 2.19% kvm_mmu_notifier_clear_young
