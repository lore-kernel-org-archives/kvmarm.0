Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649621106
	for <kvmarm@lists.linux.dev>; Fri,  7 Jul 2023 01:35:15 +0000 (UTC)
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-4fb5bcb9a28so2000702e87.3
        for <kvmarm@lists.linux.dev>; Thu, 06 Jul 2023 18:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1688693713; x=1691285713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jHzMQLp6cC/kLBC/6EOoqJ2QCFHXCMXxzGNBM9QacjY=;
        b=hJRjPgcTCc7q6itd2xbffCg48LKO/Qm/YiojcslhQVKO2e+xGuKwenYHZjO6sm/Nd4
         j+Q+arjaIozLu+vV0ToUrNaQE3iqbHFkEbzw62omnPFzlS5rZwkuqhAb6kqwNak5ba03
         v7eBCW1S9UdFdykuZWhw1cVpSMPjbwNVEnVDg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688693713; x=1691285713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jHzMQLp6cC/kLBC/6EOoqJ2QCFHXCMXxzGNBM9QacjY=;
        b=K2EB+scORCNsrCdpitWluuuY7PplWjVh1wRfHCBQbKTnB22CUzR7cAycgBItbEwN9F
         6HMwLs7OliD0PV53utPn2F4oF/ml2ZQXLyWpWWfOhlm/ihw7wt3wwtxgfvB6uppuhoTk
         So1hNgYsZ6mpp/0/kxIhTQfhISEx9IQcFwEGuAd6UJGqk/+LqK1Be4RZaZymf0T6IYly
         Do/M15N2zUCbyjntpoV04xEEEO1t3zmY9t0mpePL6ssK3JCHMZwLtYMz8ofl9tblzehd
         VVkbAKlz0/GXuFTeOJc9vlgHwb1ZeldALs1L8YRMhRS2uDC95Y1anbU/lj8Xtm5P06nn
         v06w==
X-Gm-Message-State: ABy/qLaTWqheaD2+a7Cev2aXiAKtl3ztgbNzqYbPy4DgbMbPf5t/xS32
	9XgaFC4ssR/SXRgaQVGhFXQIvgqzwNpWoKHM5Jmhfw==
X-Google-Smtp-Source: APBJJlE5Z1LKZjv+Su0EOT2WrS/jSlDd30OmLqLSEJNttXtFFbijFLtL5Sn7PdB1lMgsRBKF7D8wQuyk1Ic2XROTdJ4=
X-Received: by 2002:a05:6512:3e0c:b0:4fb:bc46:7c09 with SMTP id
 i12-20020a0565123e0c00b004fbbc467c09mr3594815lfv.6.1688693713232; Thu, 06 Jul
 2023 18:35:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-6-stevensd@google.com>
 <20230705101800.ut4c6topn6ylwczs@linux.intel.com> <CAD=HUj41PAKC0x+c3zWAr-aCm59K7hs2zRh1uWs9778_Mai4UA@mail.gmail.com>
 <20230706155805.GD3894444@ls.amr.corp.intel.com>
In-Reply-To: <20230706155805.GD3894444@ls.amr.corp.intel.com>
From: David Stevens <stevensd@chromium.org>
Date: Fri, 7 Jul 2023 10:35:02 +0900
Message-ID: <CAD=HUj6GiK3TSSe7UY8C2Jd+3tjZNBa-TLgk-UodyL=E+qKavg@mail.gmail.com>
Subject: Re: [PATCH v7 5/8] KVM: x86/mmu: Don't pass FOLL_GET to __kvm_follow_pfn
To: Isaku Yamahata <isaku.yamahata@gmail.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>, Sean Christopherson <seanjc@google.com>, 
	Marc Zyngier <maz@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, Peter Xu <peterx@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 7, 2023 at 12:58=E2=80=AFAM Isaku Yamahata <isaku.yamahata@gmai=
l.com> wrote:
>
> On Thu, Jul 06, 2023 at 01:52:08PM +0900,
> David Stevens <stevensd@chromium.org> wrote:
>
> > On Wed, Jul 5, 2023 at 7:17=E2=80=AFPM Yu Zhang <yu.c.zhang@linux.intel=
.com> wrote:
> > >
> > > On Tue, Jul 04, 2023 at 04:50:50PM +0900, David Stevens wrote:
> > > > From: David Stevens <stevensd@chromium.org>
> > > >
> > > > Stop passing FOLL_GET to __kvm_follow_pfn. This allows the host to =
map
> > > > memory into the guest that is backed by un-refcounted struct pages =
- for
> > > > example, higher order non-compound pages allocated by the amdgpu dr=
iver
> > > > via ttm_pool_alloc_page.
> > >
> > > I guess you mean the tail pages of the higher order non-compound page=
s?
> > > And as to the head page, it is said to be set to one coincidentally[*=
],
> > > and shall not be considered as refcounted.  IIUC, refcount of this he=
ad
> > > page will be increased and decreased soon in hva_to_pfn_remapped(), s=
o
> > > this may not be a problem(?). But treating this head page differently=
,
> > > as a refcounted one(e.g., to set the A/D flags), is weired.
> > >
> > > Or maybe I missed some context, e.g., can the head page be allocted t=
o
> > > guest at all?
> >
> > Yes, this is to allow mapping the tail pages of higher order
> > non-compound pages - I should have been more precise in my wording.
> > The head pages can already be mapped into the guest.
> >
> > Treating the head and tail pages would require changing how KVM
> > behaves in a situation it supports today (rather than just adding
> > support for an unsupported situation). Currently, without this series,
> > KVM can map VM_PFNMAP|VM_IO memory backed by refcounted pages into the
> > guest. When that happens, KVM sets the A/D flags. I'm not sure whether
> > that's actually valid behavior, nor do I know whether anyone actually
> > cares about it. But it's what KVM does today, and I would shy away
> > from modifying that behavior without good reason.
> >
> > > >
> > > > The bulk of this change is tracking the is_refcounted_page flag so =
that
> > > > non-refcounted pages don't trigger page_count() =3D=3D 0 warnings. =
This is
> > > > done by storing the flag in an unused bit in the sptes.
> > >
> > > Also, maybe we should mention this only works on x86-64.
> > >
> > > >
> > > > Signed-off-by: David Stevens <stevensd@chromium.org>
> > > > ---
> > > >  arch/x86/kvm/mmu/mmu.c          | 44 +++++++++++++++++++++--------=
----
> > > >  arch/x86/kvm/mmu/mmu_internal.h |  1 +
> > > >  arch/x86/kvm/mmu/paging_tmpl.h  |  9 ++++---
> > > >  arch/x86/kvm/mmu/spte.c         |  4 ++-
> > > >  arch/x86/kvm/mmu/spte.h         | 12 ++++++++-
> > > >  arch/x86/kvm/mmu/tdp_mmu.c      | 22 ++++++++++-------
> > > >  6 files changed, 62 insertions(+), 30 deletions(-)
> > > >
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index e44ab512c3a1..b1607e314497 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > >
> > > ...
> > >
> > > > @@ -2937,6 +2943,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu=
, struct kvm_memory_slot *slot,
> > > >       bool host_writable =3D !fault || fault->map_writable;
> > > >       bool prefetch =3D !fault || fault->prefetch;
> > > >       bool write_fault =3D fault && fault->write;
> > > > +     bool is_refcounted =3D !fault || fault->is_refcounted_page;
> > >
> > > Just wonder, what if a non-refcounted page is prefetched?  Or is it p=
ossible in
> > > practice?
> >
> > Prefetching is still done via gfn_to_page_many_atomic, which sets
> > FOLL_GET. That's fixable, but it's not something this series currently
> > does.
>
> So if we prefetch a page, REFCOUNTED bit is cleared unconditionally with =
this
> hunk.  kvm_set_page_{dirty, accessed} won't be called as expected for pre=
fetched
> spte.  If I read the patch correctly, REFCOUNTED bit in SPTE should repre=
sent
> whether the corresponding page is ref-countable or not, right?
>
> Because direct_pte_prefetch_many() is for legacy KVM MMU and FNAME(prefet=
ch_pte)
> is shadow paging, we need to test it with legacy KVM MMU or shadow paging=
 to hit
> the issue, though.
>

direct_pte_prefetch_many and prefetch_gpte both pass NULL for the
fault parameter, so is_refcounted will evaluate to true. So the spte's
refcounted bit will get set in that case.

-David
