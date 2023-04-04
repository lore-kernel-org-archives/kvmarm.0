Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D634D2F2
	for <kvmarm@lists.linux.dev>; Tue,  4 Apr 2023 21:46:05 +0000 (UTC)
Received: by mail-ot1-f49.google.com with SMTP id d22-20020a9d5e16000000b0069b5252ced7so18102691oti.13
        for <kvmarm@lists.linux.dev>; Tue, 04 Apr 2023 14:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680644764;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sep2IsHHPi6VwoK6jVRyP5qZG2pWFbR4+s4uvdE1Pj8=;
        b=TVNVkJ7Wgr3eBNyrguuJr4KbyC36pm49mYs5WIGWBdhvxbh36y5KZn55NFo2bZYEMS
         XJEYOZlehkfGVtYXb8z/Rh3KbYZCORYlfv1Yo16FL8npwtDgrJP42nOUqVBlup3W/OAg
         NbEweNaP+ZYnp0HJ6Oxg5pgrGU6th66YTULpbiUgOa3DRxZcmEXebsACoZTgNrJITZhX
         DnIt5IYnST38UbSJ4oKygwuHgqiS1+8zAlYV1RKtZnu7IixetGzLgEPnEgi9ipaB/00R
         E67fSn8ENKTlMswf/ShwbSXGWxe+2VxSp6GLh+5gEDDmA1837VObl0oKWs7chi17hnsw
         jUZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680644764;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sep2IsHHPi6VwoK6jVRyP5qZG2pWFbR4+s4uvdE1Pj8=;
        b=mRf7upnjf2Fx+X57jGbymTbncMa8J0T9IXjHVi3v0HOco87eibcjk5rcEKQqzTbSXD
         NhOIbWmOxlCFUTT6KtZExU/1XnthIF1aiRYG7t+appffrb8QitU7UQ/vfY9kNVSeuFId
         nI+3yDW/lyfk1WuGXsypZid+WpZjqe/Qi+YpEVowZq2giPA9NSpncwjtktGX63y5TcOy
         v7F8q8JotOjlzYBvU8qHaGPC4t2Kl+EeShp0q35bmnq5ej/qOsk8g4M9SmmJFh4jnAbr
         M5QOt5k1F3sPng/MWUctUCZ6NMWF9oKjMKf51VMkdINCUTN5IjEv8hLPvTruiSoQbK+D
         A41g==
X-Gm-Message-State: AAQBX9fljpzBkQuDt2zE0Y9CLLYuYKW+dMFx88XowJv8bKxMljlmX3us
	xJRj+flw5Demi+f0dSfhKxILK40lOxvhH90fcoNp5A==
X-Google-Smtp-Source: AKy350bcPlJB7oPstsY310EnzkBFuuMkGNuuxOTrisQk1MNOgJbl7QRAmzq9lGup3ADNCpG68LK4svZ9J/yeKc1spZE=
X-Received: by 2002:a05:6830:1be4:b0:6a1:1b5c:c6db with SMTP id
 k4-20020a0568301be400b006a11b5cc6dbmr1292746otb.7.1680644764217; Tue, 04 Apr
 2023 14:46:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230206172340.2639971-1-rananta@google.com> <20230206172340.2639971-8-rananta@google.com>
 <ZCTa5wfVtGScLQEa@linux.dev> <CAJHc60xvSFpUs+o84fR14Rghd6rruBJkCMBtroeCeLDtjJg=gw@mail.gmail.com>
 <ZCx4QCs+cjr4nYev@linux.dev> <CAJHc60xQ36vah9+eEOLqKdjamfoxijPTwXLrrhOy=NVvMW=VOw@mail.gmail.com>
 <ZCyXEsm0RkvMQuns@linux.dev>
In-Reply-To: <ZCyXEsm0RkvMQuns@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 4 Apr 2023 14:45:52 -0700
Message-ID: <CAJHc60y84QDxYsBUNX4EmhyQSM=SJkmYus82GW9k+BmZV96Vjg@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] KVM: arm64: Create a fast stage-2 unmap path
To: Oliver Upton <oliver.upton@linux.dev>
Cc: h@linux.dev, Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, Reiji Watanabe <reijiw@google.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 4, 2023 at 2:31=E2=80=AFPM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> On Tue, Apr 04, 2023 at 02:07:06PM -0700, Raghavendra Rao Ananta wrote:
> > On Tue, Apr 4, 2023 at 12:19=E2=80=AFPM Oliver Upton <oliver.upton@linu=
x.dev> wrote:
> > >
> > > On Tue, Apr 04, 2023 at 10:52:01AM -0700, Raghavendra Rao Ananta wrot=
e:
> > > > On Wed, Mar 29, 2023 at 5:42=E2=80=AFPM Oliver Upton <oliver.upton@=
linux.dev> wrote:
> > > > >
> > > > > On Mon, Feb 06, 2023 at 05:23:40PM +0000, Raghavendra Rao Ananta =
wrote:
> > > > > > The current implementation of the stage-2 unmap walker
> > > > > > traverses the entire page-table to clear and flush the TLBs
> > > > > > for each entry. This could be very expensive, especially if
> > > > > > the VM is not backed by hugepages. The unmap operation could be
> > > > > > made efficient by disconnecting the table at the very
> > > > > > top (level at which the largest block mapping can be hosted)
> > > > > > and do the rest of the unmapping using free_removed_table().
> > > > > > If the system supports FEAT_TLBIRANGE, flush the entire range
> > > > > > that has been disconnected from the rest of the page-table.
> > > > > >
> > > > > > Suggested-by: Ricardo Koller <ricarkol@google.com>
> > > > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > > > > ---
> > > > > >  arch/arm64/kvm/hyp/pgtable.c | 44 ++++++++++++++++++++++++++++=
++++++++
> > > > > >  1 file changed, 44 insertions(+)
> > > > > >
> > > > > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/=
pgtable.c
> > > > > > index 0858d1fa85d6b..af3729d0971f2 100644
> > > > > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > > > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > > > > @@ -1017,6 +1017,49 @@ static int stage2_unmap_walker(const str=
uct kvm_pgtable_visit_ctx *ctx,
> > > > > >       return 0;
> > > > > >  }
> > > > > >
> > > > > > +/*
> > > > > > + * The fast walker executes only if the unmap size is exactly =
equal to the
> > > > > > + * largest block mapping supported (i.e. at KVM_PGTABLE_MIN_BL=
OCK_LEVEL),
> > > > > > + * such that the underneath hierarchy at KVM_PGTABLE_MIN_BLOCK=
_LEVEL can
> > > > > > + * be disconnected from the rest of the page-table without the=
 need to
> > > > > > + * traverse all the PTEs, at all the levels, and unmap each an=
d every one
> > > > > > + * of them. The disconnected table is freed using free_removed=
_table().
> > > > > > + */
> > > > > > +static int fast_stage2_unmap_walker(const struct kvm_pgtable_v=
isit_ctx *ctx,
> > > > > > +                            enum kvm_pgtable_walk_flags visit)
> > > > > > +{
> > > > > > +     struct kvm_pgtable_mm_ops *mm_ops =3D ctx->mm_ops;
> > > > > > +     kvm_pte_t *childp =3D kvm_pte_follow(ctx->old, mm_ops);
> > > > > > +     struct kvm_s2_mmu *mmu =3D ctx->arg;
> > > > > > +
> > > > > > +     if (!kvm_pte_valid(ctx->old) || ctx->level !=3D KVM_PGTAB=
LE_MIN_BLOCK_LEVEL)
> > > > > > +             return 0;
> > > > > > +
> > > > > > +     if (!stage2_try_break_pte(ctx, mmu))
> > > > > > +             return -EAGAIN;
> > > > > > +
> > > > > > +     /*
> > > > > > +      * Gain back a reference for stage2_unmap_walker() to fre=
e
> > > > > > +      * this table entry from KVM_PGTABLE_MIN_BLOCK_LEVEL - 1.
> > > > > > +      */
> > > > > > +     mm_ops->get_page(ctx->ptep);
> > > > >
> > > > > Doesn't this run the risk of a potential UAF if the refcount was =
1 before
> > > > > calling stage2_try_break_pte()? IOW, stage2_try_break_pte() will =
drop
> > > > > the refcount to 0 on the page before this ever gets called.
> > > > >
> > > > > Also, AFAICT this misses the CMOs that are required on systems w/=
o
> > > > > FEAT_FWB. Without them it is possible that the host will read som=
ething
> > > > > other than what was most recently written by the guest if it is u=
sing
> > > > > noncacheable memory attributes at stage-1.
> > > > >
> > > > > I imagine the actual bottleneck is the DSB required after every
> > > > > CMO/TLBI. Theoretically, the unmap path could be updated to:
> > > > >
> > > > >  - Perform the appropriate CMOs for every valid leaf entry *witho=
ut*
> > > > >    issuing a DSB.
> > > > >
> > > > >  - Elide TLBIs entirely that take place in the middle of the walk
> > > > >
> > > > >  - After the walk completes, dsb(ish) to guarantee that the CMOs =
have
> > > > >    completed and the invalid PTEs are made visible to the hardwar=
e
> > > > >    walkers. This should be done implicitly by the TLBI implementa=
tion
> > > > >
> > > > >  - Invalidate the [addr, addr + size) range of IPAs
> > > > >
> > > > > This would also avoid over-invalidating stage-1 since we blast th=
e
> > > > > entire stage-1 context for every stage-2 invalidation. Thoughts?
> > > > >
> > > > Correct me if I'm wrong, but if we invalidate the TLB after the wal=
k
> > > > is complete, don't you think there's a risk of race if the guest ca=
n
> > > > hit in the TLB even though the page was unmapped?
> > >
> > > Yeah, we'd need to do the CMOs _after_ making the translation invalid=
 in
> > > the page tables and completing the TLB invalidation. Apologies.
> > >
> > > Otherwise, the only requirement we need to uphold w/ either the MMU
> > > notifiers or userspace is that the translation has been invalidated a=
t
> > > the time of return.
> > >
> > Actually, my concern about the race was against the hardware. If we
> > follow the above approach, let's say we invalidated a certain set of
> > PTEs, but the TLBs aren't yet invalidated. During this point if
> > another vCPU accesses the range governed by the invalidated PTEs,
> > wouldn't it still hit in the TLB? Have I misunderstood you or am I
> > missing something?
>
> Yep, that's exactly what would happen. There is no way to eliminate the
> race you mention, there will always be a window of time where the page
> tables no longer contain a particular translation but the TLBs may still
> be holding a valid entry.
>
This is new to me :)

> This race is benign so long as we guarantee that all translations for
> the affected address (i.e. in the page tables, cached in a TLB) have
> been invalidated before returning to the caller. For example, MM cannot
> start swapping out guest memory until it is guaranteed that the guest is
> no longer writing to it.
>
Well, if you feel that the risk is acceptable, we can probably defer
the invalidations until the unmap walk is finished.

Thank you.
Raghavendra

> --
> Thanks,
> Oliver
