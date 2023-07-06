Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23853EC9
	for <kvmarm@lists.linux.dev>; Thu,  6 Jul 2023 04:52:21 +0000 (UTC)
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2b701e41cd3so2935911fa.3
        for <kvmarm@lists.linux.dev>; Wed, 05 Jul 2023 21:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1688619140; x=1691211140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QwRjjzsaRyNYdKi/jrCTglo/MDQC7ke81mJ6ahjJPYc=;
        b=UqUAH1NZ/gQh4yQRPq/oi7meCjDjvhAuIb9s8k6WygD9wkGEDov7tiGjEArq7MC+vv
         8wgiZUBCtnhAy8z+2oyaKRXJGjVma9nOV9IobiKBf6zUWloDzXQmFWkZc056B/l33r4A
         U9P2agugWFQJe4X2TqOoJOqr3SyDUx5EQkTiE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688619140; x=1691211140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QwRjjzsaRyNYdKi/jrCTglo/MDQC7ke81mJ6ahjJPYc=;
        b=aDzIa4g3imI3wWCv9DuSz2EIG4+f52I18VUA5qYQz8Ksk+8Jij9p0USiq5vS7ml6T9
         43Gf12FgFiR+Wsvd6t4ezjGK5Y592VdlfJmf+ym5USdGzIUAG1xmo9Lr6bbrKf4US4y4
         mFGkq+BHdPkxvPV4wO1OYS25ibTv9D7FIK5iIEGCLlhx4z9kCAfFJFt7t7FtLq+qLyi2
         /5sPRu/9wohAfQbc0NjPjsWVAyKl4E1rbIc7akK8XanKTNO5an9J2ROMFvX1o2SURLn6
         IM/IyX37/XkSFBsTim4kCI9JXUc+bhPOi8186lb7Ip4078nGeGpuGroOTUoLdhGTxeIo
         35Qg==
X-Gm-Message-State: ABy/qLZbKOqeJHhxZtF2L8aEGFrOq51q6SLey51IZq5lRXUsfLWaWWlK
	Xt/vRLJ44W9ByKjHyZSmn+XaAc1YC4Rbwe0fc50kug==
X-Google-Smtp-Source: APBJJlHQrJdoiiNz49lPTVOLd0RgP3a+MjJFWouX2dt0nDJM8HM8LVPtUWKWnEK+E8nSDpBgWxdf7yqgzIbxjxpaD0c=
X-Received: by 2002:a2e:b0e8:0:b0:2b6:fd90:3f28 with SMTP id
 h8-20020a2eb0e8000000b002b6fd903f28mr487010ljl.21.1688619139622; Wed, 05 Jul
 2023 21:52:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-6-stevensd@google.com>
 <20230705101800.ut4c6topn6ylwczs@linux.intel.com>
In-Reply-To: <20230705101800.ut4c6topn6ylwczs@linux.intel.com>
From: David Stevens <stevensd@chromium.org>
Date: Thu, 6 Jul 2023 13:52:08 +0900
Message-ID: <CAD=HUj41PAKC0x+c3zWAr-aCm59K7hs2zRh1uWs9778_Mai4UA@mail.gmail.com>
Subject: Re: [PATCH v7 5/8] KVM: x86/mmu: Don't pass FOLL_GET to __kvm_follow_pfn
To: Yu Zhang <yu.c.zhang@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Peter Xu <peterx@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 5, 2023 at 7:17=E2=80=AFPM Yu Zhang <yu.c.zhang@linux.intel.com=
> wrote:
>
> On Tue, Jul 04, 2023 at 04:50:50PM +0900, David Stevens wrote:
> > From: David Stevens <stevensd@chromium.org>
> >
> > Stop passing FOLL_GET to __kvm_follow_pfn. This allows the host to map
> > memory into the guest that is backed by un-refcounted struct pages - fo=
r
> > example, higher order non-compound pages allocated by the amdgpu driver
> > via ttm_pool_alloc_page.
>
> I guess you mean the tail pages of the higher order non-compound pages?
> And as to the head page, it is said to be set to one coincidentally[*],
> and shall not be considered as refcounted.  IIUC, refcount of this head
> page will be increased and decreased soon in hva_to_pfn_remapped(), so
> this may not be a problem(?). But treating this head page differently,
> as a refcounted one(e.g., to set the A/D flags), is weired.
>
> Or maybe I missed some context, e.g., can the head page be allocted to
> guest at all?

Yes, this is to allow mapping the tail pages of higher order
non-compound pages - I should have been more precise in my wording.
The head pages can already be mapped into the guest.

Treating the head and tail pages would require changing how KVM
behaves in a situation it supports today (rather than just adding
support for an unsupported situation). Currently, without this series,
KVM can map VM_PFNMAP|VM_IO memory backed by refcounted pages into the
guest. When that happens, KVM sets the A/D flags. I'm not sure whether
that's actually valid behavior, nor do I know whether anyone actually
cares about it. But it's what KVM does today, and I would shy away
from modifying that behavior without good reason.

> >
> > The bulk of this change is tracking the is_refcounted_page flag so that
> > non-refcounted pages don't trigger page_count() =3D=3D 0 warnings. This=
 is
> > done by storing the flag in an unused bit in the sptes.
>
> Also, maybe we should mention this only works on x86-64.
>
> >
> > Signed-off-by: David Stevens <stevensd@chromium.org>
> > ---
> >  arch/x86/kvm/mmu/mmu.c          | 44 +++++++++++++++++++++------------
> >  arch/x86/kvm/mmu/mmu_internal.h |  1 +
> >  arch/x86/kvm/mmu/paging_tmpl.h  |  9 ++++---
> >  arch/x86/kvm/mmu/spte.c         |  4 ++-
> >  arch/x86/kvm/mmu/spte.h         | 12 ++++++++-
> >  arch/x86/kvm/mmu/tdp_mmu.c      | 22 ++++++++++-------
> >  6 files changed, 62 insertions(+), 30 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index e44ab512c3a1..b1607e314497 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
>
> ...
>
> > @@ -2937,6 +2943,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, st=
ruct kvm_memory_slot *slot,
> >       bool host_writable =3D !fault || fault->map_writable;
> >       bool prefetch =3D !fault || fault->prefetch;
> >       bool write_fault =3D fault && fault->write;
> > +     bool is_refcounted =3D !fault || fault->is_refcounted_page;
>
> Just wonder, what if a non-refcounted page is prefetched?  Or is it possi=
ble in
> practice?

Prefetching is still done via gfn_to_page_many_atomic, which sets
FOLL_GET. That's fixable, but it's not something this series currently
does.

> ...
> >
> > @@ -883,7 +884,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcp=
u, struct kvm_mmu *mmu,
> >   */
> >  static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page=
 *sp, int i)
> >  {
> > -     bool host_writable;
> > +     bool host_writable, is_refcounted;
> >       gpa_t first_pte_gpa;
> >       u64 *sptep, spte;
> >       struct kvm_memory_slot *slot;
> > @@ -940,10 +941,12 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu=
, struct kvm_mmu_page *sp, int
> >       sptep =3D &sp->spt[i];
> >       spte =3D *sptep;
> >       host_writable =3D spte & shadow_host_writable_mask;
> > +     // TODO: is this correct?
> > +     is_refcounted =3D spte & SPTE_MMU_PAGE_REFCOUNTED;
> >       slot =3D kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> >       make_spte(vcpu, sp, slot, pte_access, gfn,
> >                 spte_to_pfn(spte), spte, true, false,
> > -               host_writable, &spte);
> > +               host_writable, is_refcounted, &spte);
>
> Could we restrict that a non-refcounted page shall not be used as shadow =
page?

I'm not very familiar with the shadow mmu, so my response might not
make sense. But do you mean not allowing non-refcoutned pages as the
guest page tables shadowed by a kvm_mmu_page? It would probably be
possible to do that, and I doubt anyone would care about the
restriction. But as far as I can tell, the guest page table is only
accessed via kvm_vcpu_read_guest_atomic, which handles non-refcounted
pages just fine.

-David
