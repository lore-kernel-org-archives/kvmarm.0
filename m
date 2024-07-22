Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A88208A4
	for <kvmarm@lists.linux.dev>; Mon, 22 Jul 2024 20:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721681182; cv=none; b=jAwZfsNenfwpI6FUgKifzh3WQVwHdZc5Erwryu9yVw9XdIsyGY8q3Sl5mWP6L+34UBCIH0C56kP6jJlwSImxGARIk9aYG543d5RU9H1g8DknMJC11K1+SUmeaKgJY529Mec1aTnURFKXdy/RHsAG762aeV5pgx3+f0KLjFdmMVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721681182; c=relaxed/simple;
	bh=/+51pdv1BE32TzIpcUMnL9pAgL9LPgsuHGxWK97F+fc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hksj43qKCXMvZK1u83OovsyUWfd7F7wwOzUev08Y/atLHlTqJqhBg6m+iF6XbwGsu93szq9893+mG6sybP+p7UuKM9/f2s0eGPFxibU4OEjzDfe1WpD4AOAxQbkYAl8xX+W5iVVjJOlCpmbZ14lELNyHQHscSl9iTErFThK43KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LL9NgXIX; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LL9NgXIX"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-44e534a1fbeso18891cf.1
        for <kvmarm@lists.linux.dev>; Mon, 22 Jul 2024 13:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721681179; x=1722285979; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+dA2de0TPq97lZ7zf2Lryp0hLTOjDnt1RCWONOWWc3s=;
        b=LL9NgXIXdVrqxJW7Eba9RsCfXJSbiC5b7dqZcxWUw2Xd5nIkVdicRTZ4UggCpgXON6
         guZrMcuTUqTAke+QnCfyUmi5pFxdMRmvNMj1nYF9JiZhcBxEAI9ESZe7c9V79EHV+lQe
         qdjSGAKtK7GqSfuJC6yeeWnA2OiohHmp5F+AT4G1CtbaTVVUJCLiAbtWtORkpuUtsGl+
         vCIIybUNv10tm2J18hPLZMDboXFQg2CAAWKs7L2YOVipVzQSn8JhKIvv11zNavHpaCZ0
         p3pKhfxQBs3BmJzyTmRM71fMCawH7Fkn/gGw5+GBapCFcSDxXepaX3z0eih/nwTZgX7p
         M5fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721681179; x=1722285979;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+dA2de0TPq97lZ7zf2Lryp0hLTOjDnt1RCWONOWWc3s=;
        b=iiLZ+7bL+NyyTIB+0ITYacSrvJvMA5X3fSB/Npd2rwqsEkitRJRlB5/mjn9qkcDkg1
         V4Z3Nw4JzOSLTg1EX0Nyo6/h3mJoYZrlJ4GwfVp14/5+7oF3YVqU87neXsRpCqE+Z+aU
         2eaQTUNNvM6wltJlEIb8iQUW+irSaXtbRhgntq4NWMdC2H6AjmSuPBbiaQ8WX8LnIDME
         Dddi3PqeygPZwx5Doha39U8gaHjbpFN5oyG3qa4O1nj0XSAK+rDsXt2w4pErJc1AamXe
         5dN1R//vlFbdEnYFVP7kf8qNEhyqYnz98WVzi21jVY6XqPnKJad/h64lKcO3GEJtFaoE
         USUQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9Fanjv1YI1K04PWXTBFEhvurVsO7RExnCT1BVcSv73sA90XCH9JiGkwy6YBbLJ6TGVAf7hbEwmhc6b56fAZjXysKkdtmA
X-Gm-Message-State: AOJu0Yw6uA4g6MzkVe3AOsG+aW+hu+SK3GGLE/wgrTl5QI1ULqpo20bp
	3STOj35KKQAeviwubI6lJl5bgI7AZfx1u/P/tmxTf/SkGHiad8sK2G1FWjsIzSloXFU4pkZn8+k
	9crbPc5qEzkoVi2R8pV+zP7Ylkh6RGoICt9Xf
X-Google-Smtp-Source: AGHT+IHmG6svEkQAUKQGLl75jQoJQoNjqUrFjS34eF1iJLFIfux81mHYuigDqfh57v63/vRcBxBh34E0nXtZyYS1jfA=
X-Received: by 2002:ac8:5e4e:0:b0:447:d81a:9320 with SMTP id
 d75a77b69052e-44fa7da9b77mr5801921cf.20.1721681179016; Mon, 22 Jul 2024
 13:46:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-9-jthoughton@google.com> <CAOUHufb2f_EwHY5LQ59k7Nh7aS1-ZbOKtkoysb8BtxRNRFMypQ@mail.gmail.com>
 <CADrL8HUJaG=O+jBVvXGVjJOriev9vxkZ6n27ekc5Pxv5D+fbcg@mail.gmail.com> <CAOUHufZ2Vd+Ea5vka20+SCVB446LZEA0mWy=RScN=7AChd869w@mail.gmail.com>
In-Reply-To: <CAOUHufZ2Vd+Ea5vka20+SCVB446LZEA0mWy=RScN=7AChd869w@mail.gmail.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 22 Jul 2024 13:45:42 -0700
Message-ID: <CADrL8HVRSyS8ZADRTvHZ-QDKBRv1SFvVyJKkr-CW2mzpNjW5Zw@mail.gmail.com>
Subject: Re: [PATCH v5 8/9] mm: multi-gen LRU: Have secondary MMUs participate
 in aging
To: Yu Zhao <yuzhao@google.com>
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

On Mon, Jul 8, 2024 at 4:42=E2=80=AFPM Yu Zhao <yuzhao@google.com> wrote:
>
> On Mon, Jul 8, 2024 at 11:31=E2=80=AFAM James Houghton <jthoughton@google=
.com> wrote:
> >
> > On Fri, Jul 5, 2024 at 11:36=E2=80=AFAM Yu Zhao <yuzhao@google.com> wro=
te:
> > >
> > > On Mon, Jun 10, 2024 at 6:22=E2=80=AFPM James Houghton <jthoughton@go=
ogle.com> wrote:
> > > > @@ -3389,8 +3450,9 @@ static bool walk_pte_range(pmd_t *pmd, unsign=
ed long start, unsigned long end,
> > > >                 if (!folio)
> > > >                         continue;
> > > >
> > > > -               if (!ptep_test_and_clear_young(args->vma, addr, pte=
 + i))
> > > > -                       VM_WARN_ON_ONCE(true);
> > > > +               lru_gen_notifier_clear_young(mm, addr, addr + PAGE_=
SIZE);
> > > > +               if (pte_young(ptent))
> > > > +                       ptep_test_and_clear_young(args->vma, addr, =
pte + i);
> > > >
> > > >                 young++;
> > > >                 walk->mm_stats[MM_LEAF_YOUNG]++;
> > >
> > >
> > > There are two ways to structure the test conditions in walk_pte_range=
():
> > > 1. a single pass into the MMU notifier (combine test/clear) which
> > > causes a cache miss from get_pfn_page() if the page is NOT young.
> > > 2. two passes into the MMU notifier (separate test/clear) if the page
> > > is young, which does NOT cause a cache miss if the page is NOT young.
> > >
> > > v2 can batch up to 64 PTEs, i.e., it only goes into the MMU notifier
> > > twice every 64 PTEs, and therefore the second option is a clear win.
> > >
> > > But you are doing twice per PTE. So what's the rationale behind going
> > > with the second option? Was the first option considered?
> >
> > Hi Yu,
> >
> > I didn't consider changing this from your v2[1]. Thanks for bringing it=
 up.
> >
> > The only real change I have made is that I reordered the
> > (!test_spte_young() && !pte_young()) to what it is now (!pte_young()
> > && !lru_gen_notifier_test_young()) because pte_young() can be
> > evaluated much faster.
> >
> > I am happy to change the initial test_young() notifier to a
> > clear_young() (and drop the later clear_young(). In fact, I think I
> > should. Making the condition (!pte_young() &&
> > !lru_gen_notifier_clear_young()) makes sense to me. This returns the
> > same result as if it were !lru_gen_notifier_test_young() instead,
> > there is no need for a second clear_young(), and we don't call
> > get_pfn_folio() on pages that are not young.
>
> We don't want to do that because we would lose the A-bit for a folio
> that's beyond the current reclaim scope, i.e., the cases where
> get_pfn_folio() returns NULL (a folio from another memcg, e.g.).
>
> > WDYT? Have I misunderstood your comment?
>
> I hope this is clear enough:
>
> @@ -3395,7 +3395,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned
> long start, unsigned long end,
>                 if (pfn =3D=3D -1)
>                         continue;
>
> -               if (!pte_young(ptent)) {
> +               if (!pte_young(ptent) && !mm_has_notifiers(args->mm)) {
>                         walk->mm_stats[MM_LEAF_OLD]++;
>                         continue;
>                 }
> @@ -3404,8 +3404,8 @@ static bool walk_pte_range(pmd_t *pmd, unsigned
> long start, unsigned long end,
>                 if (!folio)
>                         continue;
>
> -               if (!ptep_test_and_clear_young(args->vma, addr, pte + i))
> -                       VM_WARN_ON_ONCE(true);
> +               if (!ptep_clear_young_notify(args->vma, addr, pte + i))

walk->mm_stats[MM_LEAF_OLD]++ should be here, I take it.

> +                       continue;
>
>                 young++;
>                 walk->mm_stats[MM_LEAF_YOUNG]++;
>
> > Also, I take it your comment was not just about walk_pte_range() but
> > about the similar bits in lru_gen_look_around() as well, so I'll make
> > whatever changes we agree on there too (or maybe factor out the common
> > bits).
> >
> > [1]: https://lore.kernel.org/kvmarm/20230526234435.662652-11-yuzhao@goo=
gle.com/
> >
> > > In addition, what about the non-lockless cases? Would this change mak=
e
> > > them worse by grabbing the MMU lock twice per PTE?
> >
> > That's a good point. Yes I think calling the notifier twice here would
> > indeed exacerbate problems with a non-lockless notifier.
>
> I think so too, but I haven't verified it. Please do?

I have some results now, sorry for the wait.

It seems like one notifier is definitely better. It doesn't look like
the read lock actually made anything worse with what I was testing
(faulting memory in while doing aging). This is kind of surprising,
but either way, I'll change it to the single notifier in v6. Thanks
Yu!

Here are the results I'm basing this conclusion on, using the selftest
added at the end of this series.

# Use taskset to minimize NUMA concern.
# Give an extra core for the aging thread.
# THPs disabled (echo never > /sys/kernel/mm/transparent_hugepage/enabled)

x86:

# taskset -c 0-32 ./access_tracking_perf_test -l -v 32
# # One notifier
Populating memory             : 1.933017284s
Writing to populated memory   : 0.017323539s
Reading from populated memory : 0.013113260s
lru_gen: Aging                : 0.894133259s
lru_gen: Aging                : 0.738950525s
Writing to idle memory        : 0.059661329s
lru_gen: Aging                : 0.922719935s
lru_gen: Aging                : 0.829129877s
Reading from idle memory      : 0.059095098s
lru_gen: Aging                : 0.922689975s

# # Two notifiers
Populating memory             : 1.842645795s
Writing to populated memory   : 0.017277075s
Reading from populated memory : 0.013047457s
lru_gen: Aging                : 0.900751764s
lru_gen: Aging                : 0.707203167s
Writing to idle memory        : 0.060663733s
lru_gen: Aging                : 1.539957250s  <------ got longer
lru_gen: Aging                : 0.797475887s
Reading from idle memory      : 0.084415591s
lru_gen: Aging                : 1.539417121s  <------ got longer

arm64*:
(*Patched to do aging; not done in v5 or v6. Doing this to see if the read
lock is made substantially worse by using two notifiers vs. one.)

# taskset -c 0-16 ./access_tracking_perf_test -l -v 16 -m 3
# # One notifier
Populating memory             : 1.439261355s
Writing to populated memory   : 0.009755279s
Reading from populated memory : 0.007714120s
lru_gen: Aging                : 0.540183328s
lru_gen: Aging                : 0.455427973s
Writing to idle memory        : 0.010130399s
lru_gen: Aging                : 0.563424247s
lru_gen: Aging                : 0.500419850s
Reading from idle memory      : 0.008519640s
lru_gen: Aging                : 0.563178643s

# # Two notifiers
Populating memory             : 1.526805625s
Writing to populated memory   : 0.009836118s
Reading from populated memory : 0.007757280s
lru_gen: Aging                : 0.537770978s
lru_gen: Aging                : 0.421915391s
Writing to idle memory        : 0.010281959s
lru_gen: Aging                : 0.971448688s  <------ got longer
lru_gen: Aging                : 0.466956547s
Reading from idle memory      : 0.008588559s
lru_gen: Aging                : 0.971030648s  <------ got longer


arm64, faulting memory in while aging:

# perf record -g -- taskset -c 0-16 ./access_tracking_perf_test -l -v 16 -m=
 3 -p
# # One notifier
vcpu wall time                : 1.433908058s
lru_gen avg pass duration     : 0.172128073s, (passes:11, total:1.893408807=
s)

# # Two notifiers
vcpu wall time                : 1.450387765s
lru_gen avg pass duration     : 0.175652974s, (passes:10, total:1.756529744=
s)

# perf report
# # One notifier
-    6.25%     0.00%  access_tracking  [kernel.kallsyms]  [k] try_to_inc_ma=
x_seq
   - try_to_inc_max_seq
      - 6.06% walk_page_range
           __walk_page_range
         - walk_pgd_range
            - 6.04% walk_pud_range
               - 4.73% __mmu_notifier_clear_young
                  + 4.29% kvm_mmu_notifier_clear_young

# # Two notifiers
-    6.43%     0.00%  access_tracking  [kernel.kallsyms]  [k] try_to_inc_ma=
x_seq
   - try_to_inc_max_seq
      - 6.25% walk_page_range
           __walk_page_range
         - walk_pgd_range
            - 6.23% walk_pud_range
               - 2.75% __mmu_notifier_test_young
                  + 2.48% kvm_mmu_notifier_test_young
               - 2.39% __mmu_notifier_clear_young
                  + 2.19% kvm_mmu_notifier_clear_young
