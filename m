Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98A06FB7
	for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 20:29:00 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id fy8-20020a17090b020800b002374c592205so154407pjb.5
        for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 12:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iMpgRmyVDog12gGF5u00S3GFVvfa3RjsGhYYuIghQuw=;
        b=Oj0JNHRfBF0003MFOrybvJRxKWvg4a//DfyLNclUK+7N5/s7VjeN2Ybz0ne96gQ+y/
         Kce+Q0ZXdzbS+HItx2LVYs6XbJeGYav5T0kxtg6oSGyyAnYLkgfUmKMvnWrz/RJr2iGt
         BiNuY4XQIP71ObixRoPGWBrf5q6zjI9OvmSI5XqGwGSoaN4Qo8PjJcVdjNQWqFmCbaNT
         fDylmTkY2OnILfYvuCp/0wvlS/vK3WqeY+Vs8jpgS0bDY+Fzi+bVe+j3RecifYahcIhh
         j4oJs7UNz2z7WtDg2Ub7n9qah3g+mR+nVEw9Z6a8GUszbe4QIdPOG3iK1M22brh9bkyW
         z3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iMpgRmyVDog12gGF5u00S3GFVvfa3RjsGhYYuIghQuw=;
        b=6TcIbuZZTc3DLMVXNGSE86rb0IX4PCe8JigDPQJlL5LfWVPg0YviXAiZ3arhuphExs
         Vy+w85XIeocsWx4DX6g6OZgNuvGXYxI2wVBZta7feKtf5G6lqe9HLIa3XsyGv8AD6Voo
         k5Cn8mUBHI8whT7lacUZajV4UWcGOJaIJWmWxxrEnSmkUesJNNhnAlcNWa/LkZ+lxWhM
         3G/QrXVHJ29OBMB7c7ABW1nCG+X/oIPvdwM4ljvap8nq19uXE0m0jJGZevQ1Q19ug/eg
         VTrQJfwkNWN99efXqP8CAttJNY0MEF0dTSmpBlwanEQqrxvbzJkOyDNswpbLK2cy7KYO
         iscw==
X-Gm-Message-State: AO0yUKXeCDH1iv2BGB4SeTJDOM0AZjVqoVa4HPYahbJMelWZcO4s1wRa
	akZ3ztRfMRWAtBi2KSa04fk/siMlA90=
X-Google-Smtp-Source: AK7set/XyWT2OAnpm11r3FBKVIDwL0kXrUZRkKccpnOexZiyXc1HvjHh6IvJEeYAirA5lDcDXm4Ck4IuD34=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1955:b0:593:f5e4:8d87 with SMTP id
 s21-20020a056a00195500b00593f5e48d87mr2471665pfk.6.1677184140109; Thu, 23 Feb
 2023 12:29:00 -0800 (PST)
Date: Thu, 23 Feb 2023 12:28:58 -0800
In-Reply-To: <CAOUHufYWktz4SNjL_o_2oZNcJLXserwCot-Prv4UEG9uzn57rg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-6-yuzhao@google.com>
 <Y/elw7CTvVWt0Js6@google.com> <CAOUHufbAKpv95k6rVedstjD_7JzP0RrbOD652gyZh2vbAjGPOg@mail.gmail.com>
 <Y/e6Z+KIl6sYJoRg@google.com> <CAOUHufbwcqx21T=zmvYpnX_Mnd2A0KkPORbtxnJEwKuUKVSPzA@mail.gmail.com>
 <Y/fFWyYPu5Jf0de1@google.com> <CAOUHufYWktz4SNjL_o_2oZNcJLXserwCot-Prv4UEG9uzn57rg@mail.gmail.com>
Message-ID: <Y/fMimvChfhhbCid@google.com>
Subject: Re: [PATCH mm-unstable v1 5/5] mm: multi-gen LRU: use mmu_notifier_test_clear_young()
From: Sean Christopherson <seanjc@google.com>
To: Yu Zhao <yuzhao@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Michael Larabel <michael@michaellarabel.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org, 
	linux-mm@google.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 23, 2023, Yu Zhao wrote:
> On Thu, Feb 23, 2023 at 12:58=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Thu, Feb 23, 2023, Yu Zhao wrote:
> > > On Thu, Feb 23, 2023 at 12:11=E2=80=AFPM Sean Christopherson <seanjc@=
google.com> wrote:
> > > >
> > > > On Thu, Feb 23, 2023, Yu Zhao wrote:
> > > > > > As alluded to in patch 1, unless batching the walks even if KVM=
 does _not_ support
> > > > > > a lockless walk is somehow _worse_ than using the existing mmu_=
notifier_clear_flush_young(),
> > > > > > I think batching the calls should be conditional only on LRU_GE=
N_SPTE_WALK.  Or
> > > > > > if we want to avoid batching when there are no mmu_notifier lis=
teners, probe
> > > > > > mmu_notifiers.  But don't call into KVM directly.
> > > > >
> > > > > I'm not sure I fully understand. Let's present the problem on the=
 MM
> > > > > side: assuming KVM supports lockless walks, batching can still be
> > > > > worse (very unlikely), because GFNs can exhibit no memory localit=
y at
> > > > > all. So this option allows userspace to disable batching.
> > > >
> > > > I'm asking the opposite.  Is there a scenario where batching+lock i=
s worse than
> > > > !batching+lock?  If not, then don't make batching depend on lockles=
s walks.
> > >
> > > Yes, absolutely. batching+lock means we take/release mmu_lock for
> > > every single PTE in the entire VA space -- each small batch contains
> > > 64 PTEs but the entire batch is the whole KVM.
> >
> > Who is "we"?
>=20
> Oops -- shouldn't have used "we".
>=20
> > I don't see anything in the kernel that triggers walking the whole
> > VMA, e.g. lru_gen_look_around() limits the walk to a single PMD.  I fee=
l like I'm
> > missing something...
>=20
> walk_mm() -> walk_pud_range() -> walk_pmd_range() -> walk_pte_range()
> -> test_spte_young() -> mmu_notifier_test_clear_young().
>=20
> MGLRU takes two passes: during the first pass, it sweeps entire VA
> space on each MM (per MM/KVM); during the second pass, it uses the rmap o=
n each
> folio (per folio).

Ah.  IIUC, userspace can use LRU_GEN_SPTE_WALK to control whether or not to=
 walk
secondary MMUs, and the kernel further restricts LRU_GEN_SPTE_WALK to secon=
dary
MMUs that implement a lockless walk.  And if the answer is "no", secondary =
MMUs
are simply not consulted.

If that's correct, then the proper way to handle this is by extending mmu_n=
otifier_ops
to query (a) if there's at least one register listeners that implements
test_clear_young() and (b) if all registered listeners that implement test_=
clear_young()
support lockless walks.  That avoids direct dependencies on KVM, and avoids=
 making
assumptions that may not always hold true, e.g. that KVM is the only mmu_no=
tifier
user that supports the young APIs.

P.S. all of this info absolutely belongs in documentation and/or changelogs=
.
