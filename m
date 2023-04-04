Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFA6D2F2
	for <kvmarm@lists.linux.dev>; Tue,  4 Apr 2023 21:07:19 +0000 (UTC)
Received: by mail-oi1-f174.google.com with SMTP id r16so25168449oij.5
        for <kvmarm@lists.linux.dev>; Tue, 04 Apr 2023 14:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680642438;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D8wCu932h/gRywCSwLxOAEpXzxqJvpG+Yqrg4CPRzmc=;
        b=JAd/1nZVeoy351xux6KFsMVzLIQjl9PnuOcBokKzB3bGJ+AiPCVTDt2lioXuKb9qEq
         5xsvX9ZUJR/B5ESv4oz0I9GWx8PfRAoXHcNqEjR+5xzUwdN1AYQqGCigmKxDNJcqs5bH
         M91VOT22HKSZKYEFfOaVFy5dpvkSqQvQAIZmIUEXQb6XP5bZBC1r8kT/j1fKPN1oz2yq
         8yctitBEz1sts5F9bOkZ0F7bc4Na1Sx2pgp8pEjGQxqW+XLprm0XEm5h7+jAKBJDTpxW
         8ZBHIYFtoJ/HMbC4p2PZQHGs/BsniOmP9elZZJnM7xXiA5UV0p6m6I6fLrv/eyX7EEsw
         w2tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680642438;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D8wCu932h/gRywCSwLxOAEpXzxqJvpG+Yqrg4CPRzmc=;
        b=UnMKEHa0ouIrg7aQHQ1PhVucnWTOkqTmInszJDMH8rtImmAzqX592QPgOlWE0Z4jrC
         t/QP2ZR8QjjfY50GenzxKIw0ZnPtZd0675/SFpn0ycKK71t0mEgLQyKMMgsYsmcq5vJ9
         9IFJsfkKoECpDNvcfoJcPT1sWPzJVExDgFq+ZvesWcLfIupUwYHdZOuozFN1JxPHb0rr
         tc5goUN9siaYvDHOzxoSRlkHulqNHhIXdFBQFuDq38lkLZUZMfn6x/uBSUZWtoExtQtp
         GN23d4GwE0zoHU6MtqEgpeSTAUcH/CwLWVbW8dCPHeI1IYQuYpkNmwxR9FKdcndP3kZw
         EarA==
X-Gm-Message-State: AAQBX9f/0SuGQKRPRguxSNWL25HRU9ScvmEL669O4Wk3Jg1yDaZjrsk4
	SEtb/v7kvHDbFxs0xRzDbDyVJeVW1QeEqEDItOCB5Q==
X-Google-Smtp-Source: AKy350Z0YdQn3UAJSOuwQI8sp3lim7hTJHnaVlPm9ru9ZlukibPZgsTTBipva6Zi/jo0R/RR52EY0KdPqFTpNqI9Eyo=
X-Received: by 2002:a54:4483:0:b0:37f:ab56:ff42 with SMTP id
 v3-20020a544483000000b0037fab56ff42mr1246545oiv.9.1680642438159; Tue, 04 Apr
 2023 14:07:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230206172340.2639971-1-rananta@google.com> <20230206172340.2639971-8-rananta@google.com>
 <ZCTa5wfVtGScLQEa@linux.dev> <CAJHc60xvSFpUs+o84fR14Rghd6rruBJkCMBtroeCeLDtjJg=gw@mail.gmail.com>
 <ZCx4QCs+cjr4nYev@linux.dev>
In-Reply-To: <ZCx4QCs+cjr4nYev@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 4 Apr 2023 14:07:06 -0700
Message-ID: <CAJHc60xQ36vah9+eEOLqKdjamfoxijPTwXLrrhOy=NVvMW=VOw@mail.gmail.com>
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

On Tue, Apr 4, 2023 at 12:19=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Tue, Apr 04, 2023 at 10:52:01AM -0700, Raghavendra Rao Ananta wrote:
> > On Wed, Mar 29, 2023 at 5:42=E2=80=AFPM Oliver Upton <oliver.upton@linu=
x.dev> wrote:
> > >
> > > On Mon, Feb 06, 2023 at 05:23:40PM +0000, Raghavendra Rao Ananta wrot=
e:
> > > > The current implementation of the stage-2 unmap walker
> > > > traverses the entire page-table to clear and flush the TLBs
> > > > for each entry. This could be very expensive, especially if
> > > > the VM is not backed by hugepages. The unmap operation could be
> > > > made efficient by disconnecting the table at the very
> > > > top (level at which the largest block mapping can be hosted)
> > > > and do the rest of the unmapping using free_removed_table().
> > > > If the system supports FEAT_TLBIRANGE, flush the entire range
> > > > that has been disconnected from the rest of the page-table.
> > > >
> > > > Suggested-by: Ricardo Koller <ricarkol@google.com>
> > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > > ---
> > > >  arch/arm64/kvm/hyp/pgtable.c | 44 ++++++++++++++++++++++++++++++++=
++++
> > > >  1 file changed, 44 insertions(+)
> > > >
> > > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgta=
ble.c
> > > > index 0858d1fa85d6b..af3729d0971f2 100644
> > > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > > @@ -1017,6 +1017,49 @@ static int stage2_unmap_walker(const struct =
kvm_pgtable_visit_ctx *ctx,
> > > >       return 0;
> > > >  }
> > > >
> > > > +/*
> > > > + * The fast walker executes only if the unmap size is exactly equa=
l to the
> > > > + * largest block mapping supported (i.e. at KVM_PGTABLE_MIN_BLOCK_=
LEVEL),
> > > > + * such that the underneath hierarchy at KVM_PGTABLE_MIN_BLOCK_LEV=
EL can
> > > > + * be disconnected from the rest of the page-table without the nee=
d to
> > > > + * traverse all the PTEs, at all the levels, and unmap each and ev=
ery one
> > > > + * of them. The disconnected table is freed using free_removed_tab=
le().
> > > > + */
> > > > +static int fast_stage2_unmap_walker(const struct kvm_pgtable_visit=
_ctx *ctx,
> > > > +                            enum kvm_pgtable_walk_flags visit)
> > > > +{
> > > > +     struct kvm_pgtable_mm_ops *mm_ops =3D ctx->mm_ops;
> > > > +     kvm_pte_t *childp =3D kvm_pte_follow(ctx->old, mm_ops);
> > > > +     struct kvm_s2_mmu *mmu =3D ctx->arg;
> > > > +
> > > > +     if (!kvm_pte_valid(ctx->old) || ctx->level !=3D KVM_PGTABLE_M=
IN_BLOCK_LEVEL)
> > > > +             return 0;
> > > > +
> > > > +     if (!stage2_try_break_pte(ctx, mmu))
> > > > +             return -EAGAIN;
> > > > +
> > > > +     /*
> > > > +      * Gain back a reference for stage2_unmap_walker() to free
> > > > +      * this table entry from KVM_PGTABLE_MIN_BLOCK_LEVEL - 1.
> > > > +      */
> > > > +     mm_ops->get_page(ctx->ptep);
> > >
> > > Doesn't this run the risk of a potential UAF if the refcount was 1 be=
fore
> > > calling stage2_try_break_pte()? IOW, stage2_try_break_pte() will drop
> > > the refcount to 0 on the page before this ever gets called.
> > >
> > > Also, AFAICT this misses the CMOs that are required on systems w/o
> > > FEAT_FWB. Without them it is possible that the host will read somethi=
ng
> > > other than what was most recently written by the guest if it is using
> > > noncacheable memory attributes at stage-1.
> > >
> > > I imagine the actual bottleneck is the DSB required after every
> > > CMO/TLBI. Theoretically, the unmap path could be updated to:
> > >
> > >  - Perform the appropriate CMOs for every valid leaf entry *without*
> > >    issuing a DSB.
> > >
> > >  - Elide TLBIs entirely that take place in the middle of the walk
> > >
> > >  - After the walk completes, dsb(ish) to guarantee that the CMOs have
> > >    completed and the invalid PTEs are made visible to the hardware
> > >    walkers. This should be done implicitly by the TLBI implementation
> > >
> > >  - Invalidate the [addr, addr + size) range of IPAs
> > >
> > > This would also avoid over-invalidating stage-1 since we blast the
> > > entire stage-1 context for every stage-2 invalidation. Thoughts?
> > >
> > Correct me if I'm wrong, but if we invalidate the TLB after the walk
> > is complete, don't you think there's a risk of race if the guest can
> > hit in the TLB even though the page was unmapped?
>
> Yeah, we'd need to do the CMOs _after_ making the translation invalid in
> the page tables and completing the TLB invalidation. Apologies.
>
> Otherwise, the only requirement we need to uphold w/ either the MMU
> notifiers or userspace is that the translation has been invalidated at
> the time of return.
>
Actually, my concern about the race was against the hardware. If we
follow the above approach, let's say we invalidated a certain set of
PTEs, but the TLBs aren't yet invalidated. During this point if
another vCPU accesses the range governed by the invalidated PTEs,
wouldn't it still hit in the TLB? Have I misunderstood you or am I
missing something?

Thank you.
Raghavendra
> --
> Thanks,
> Oliver
