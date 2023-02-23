Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0EA7E
	for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 19:11:37 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-536c525d470so137028787b3.18
        for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 11:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lgz23S0KW/3Vuh8fPybY+EaMWzwQFtPo75lQKh/z++I=;
        b=illZ3Rsxhz/9jljbLI+FUdfsGaNHQ+3fywMFYtiPdi4y1cf10XY7ukC5ghyLXOpRiX
         ECKpfvO4XF3GMAEqQtGTGUg1jqO+AbRdSqGFpyrvz1Y54kJ0qEPuz3ERkD1mNPRjChGr
         FIk8fspffno+cxbJIVBWXLSAjcURDSQfT0pVMLjA9MwRSCOas0U4UaV//I6oaWp4/jP8
         Nedf5FJP2yTEdqt4rNWa/GGGRcnTa9xaHgSx+sUBPJmKn+5OuioGUbjEJBaVHxmxHjpR
         JfrWlzWMnyD8o2vHK884xzIW6y4U6nk3QsjYBj1PHqc/oR+/TNHECEU3hASerxLBXfzT
         1/Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Lgz23S0KW/3Vuh8fPybY+EaMWzwQFtPo75lQKh/z++I=;
        b=zKvZywodaqxjPmK1Sbs66S5NLJb3HE7NJ2igr4xmzsyPnZn2AVS+OxMuJllWisiJ6f
         sfEiIOb6V7SRY+epYQSTotZ4A2408vGAWO2Ff7xWFArmDs8iMfCtM2IbZaTxD1EHPzsB
         n/dOzlUkqD1H3v6WFPmLtSXDZ3nuaTm3h3SiB8NwxeC0FEiI8+bdybUbT82nFPCIyjbD
         AQ5qUafeuaJ3AEu539jecJzq/JpLvqVh7FeZueNbA08980oPj+O+bDJ14HZUc6vY+zef
         2B9eXEwrcwJ8pAni20ZxCEKYcdIS+nYdsD9cBPEEz6it+5uXVCYSa8HtJwCRSUVOtGky
         zYIw==
X-Gm-Message-State: AO0yUKVUNTH60INcP1BQVHVETiRZyftMwxNDHicL/V0KhMdqpGPonevr
	RRz3A45c3GJrsJPAK52iHabA/YGW/nc=
X-Google-Smtp-Source: AK7set9CAvBzEvzau8o9w7k/cYlwu85gWQxy7MQm2EeJKeyL2LgEayAQYJRKvwtnPY5l/Yt7cVb6SpmQxus=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:50b:0:b0:a36:3875:564a with SMTP id
 o11-20020a5b050b000000b00a363875564amr1021123ybp.2.1677179496807; Thu, 23 Feb
 2023 11:11:36 -0800 (PST)
Date: Thu, 23 Feb 2023 11:11:35 -0800
In-Reply-To: <CAOUHufbAKpv95k6rVedstjD_7JzP0RrbOD652gyZh2vbAjGPOg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-6-yuzhao@google.com>
 <Y/elw7CTvVWt0Js6@google.com> <CAOUHufbAKpv95k6rVedstjD_7JzP0RrbOD652gyZh2vbAjGPOg@mail.gmail.com>
Message-ID: <Y/e6Z+KIl6sYJoRg@google.com>
Subject: Re: [PATCH mm-unstable v1 5/5] mm: multi-gen LRU: use mmu_notifier_test_clear_young()
From: Sean Christopherson <seanjc@google.com>
To: Yu Zhao <yuzhao@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Michael Larabel <michael@michaellarabel.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, x86@kernel.org, linux-mm@google.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 23, 2023, Yu Zhao wrote:
> On Thu, Feb 23, 2023 at 10:43=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Thu, Feb 16, 2023, Yu Zhao wrote:
> > >   kswapd (MGLRU before)
> > >     100.00%  balance_pgdat
> > >       100.00%  shrink_node
> > >         100.00%  shrink_one
> > >           99.97%  try_to_shrink_lruvec
> > >             99.06%  evict_folios
> > >               97.41%  shrink_folio_list
> > >                 31.33%  folio_referenced
> > >                   31.06%  rmap_walk_file
> > >                     30.89%  folio_referenced_one
> > >                       20.83%  __mmu_notifier_clear_flush_young
> > >                         20.54%  kvm_mmu_notifier_clear_flush_young
> > >   =3D>                      19.34%  _raw_write_lock
> > >
> > >   kswapd (MGLRU after)
> > >     100.00%  balance_pgdat
> > >       100.00%  shrink_node
> > >         100.00%  shrink_one
> > >           99.97%  try_to_shrink_lruvec
> > >             99.51%  evict_folios
> > >               71.70%  shrink_folio_list
> > >                 7.08%  folio_referenced
> > >                   6.78%  rmap_walk_file
> > >                     6.72%  folio_referenced_one
> > >                       5.60%  lru_gen_look_around
> > >   =3D>                    1.53%  __mmu_notifier_test_clear_young
> >
> > Do you happen to know how much of the improvement is due to batching, a=
nd how
> > much is due to using a walkless walk?
>=20
> No. I have three benchmarks running at the moment:
> 1. Windows SQL server guest on x86 host,
> 2. Apache Spark guest on arm64 host, and
> 3. Memcached guest on ppc64 host.
>=20
> If you are really interested in that, I can reprioritize -- I need to
> stop 1) and use that machine to get the number for you.

After looking at the "MGLRU before" stack again, it's definitely worth gett=
ing
those numbers.  The "before" isn't just taking mmu_lock, it's taking mmu_lo=
ck for
write _and_ flushing remote TLBs on _every_ PTE.  I suspect the batching is=
 a
tiny percentage of the overall win (might be larger with RETPOLINE and frie=
nds),
and that the bulk of the improvement comes from avoiding the insanity of
kvm_mmu_notifier_clear_flush_young().

Speaking of which, what would it take to drop mmu_notifier_clear_flush_youn=
g()
entirely?  I.e. why can MGLRU tolerate stale information but !MGLRU cannot?=
  If
we simply deleted mmu_notifier_clear_flush_young() and used mmu_notifier_cl=
ear_young()
instead, would anyone notice, let alone care?

> > > @@ -5699,6 +5797,9 @@ static ssize_t show_enabled(struct kobject *kob=
j, struct kobj_attribute *attr, c
> > >       if (arch_has_hw_nonleaf_pmd_young() && get_cap(LRU_GEN_NONLEAF_=
YOUNG))
> > >               caps |=3D BIT(LRU_GEN_NONLEAF_YOUNG);
> > >
> > > +     if (kvm_arch_has_test_clear_young() && get_cap(LRU_GEN_SPTE_WAL=
K))
> > > +             caps |=3D BIT(LRU_GEN_SPTE_WALK);
> >
> > As alluded to in patch 1, unless batching the walks even if KVM does _n=
ot_ support
> > a lockless walk is somehow _worse_ than using the existing mmu_notifier=
_clear_flush_young(),
> > I think batching the calls should be conditional only on LRU_GEN_SPTE_W=
ALK.  Or
> > if we want to avoid batching when there are no mmu_notifier listeners, =
probe
> > mmu_notifiers.  But don't call into KVM directly.
>=20
> I'm not sure I fully understand. Let's present the problem on the MM
> side: assuming KVM supports lockless walks, batching can still be
> worse (very unlikely), because GFNs can exhibit no memory locality at
> all. So this option allows userspace to disable batching.

I'm asking the opposite.  Is there a scenario where batching+lock is worse =
than
!batching+lock?  If not, then don't make batching depend on lockless walks.

> I fully understand why you don't want MM to call into KVM directly. No
> acceptable ways to set up a clear interface between MM and KVM other
> than the MMU notifier?

There are several options I can think of, but before we go spend time desig=
ning
the best API, I'd rather figure out if we care in the first place.
