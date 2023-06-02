Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D42C10E3
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 01:37:40 +0000 (UTC)
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-33b398f2ab8so62245ab.0
        for <kvmarm@lists.linux.dev>; Thu, 01 Jun 2023 18:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685669859; x=1688261859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XqK+LRqUfX7YWXdw+FC58BH33IXhJbV4zkm9bX0JR7g=;
        b=lNs//9ZjI8SYBNPM84Yyp+jfuQxpvN4VGBDkGBNVlWSSahevpk4zeGRX8Ch6GPM3Hq
         VnT2ijtWicIIZHThS+cvOf4QwGLiuTxbEfFkbXjB3LkrfHY4xoAz2gTAIgvP30Z9W5Sc
         Xd4ooWgvhdVYbJfe/SEvqzEl8P6xMoP3Ye7Dz+CFC0SHk7h5dWGe/iQIw3QrWieJGvnR
         l8z10UpgH45xTmiSJ/Zl60beF+7tIxysma7VFexBlweVYmnT/LoXS80UQyoV0LBCWDiR
         N4h2fq3Hf+TFGtgT2RrMSnbFrCFM58ckJNrpSMvDIwLFM9SNfccB73Fxhh1Kwj/LNf21
         oO9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685669859; x=1688261859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XqK+LRqUfX7YWXdw+FC58BH33IXhJbV4zkm9bX0JR7g=;
        b=ID8WAXXvSW6w2O4kcux5XH1id4x/yy08Nj6Q9K7tPdeY1y1x0ve6kzLaGOkYVnj6RQ
         6f5xnexB5vFV0eOLIlDPul2CYAGDRPtr3JpfR70dbh73TQWKQcrVlDuvjUbXLIA4QlDk
         aus7i0pLq0AI0OEJEM3wnAuQf3XRJ/HVn/r4TSu2n1mMQFOB9EfgNLeiVlMxYVyJpVQo
         Z14eo49PJn5mR7Ss+wlJIoGh2LN5M0yhXCaVui+d7SKM/xuZEpsEP+uMYpFcwbcyvATX
         SL223WKpoHDzfTuy2N0dAOKAnDBtknIT9YdOaKaoX0QjfRuJr6ORF0KbTFwdqoVMnxSN
         Z7mA==
X-Gm-Message-State: AC+VfDyYKV2cw01+gRZhjW1MA1rofdLsfsKImYgHcBN35KAJcAFAAWu7
	XkdU9TtW05ehAwI8HouzsAnrFu5VX8mRjSwhLiSOHw==
X-Google-Smtp-Source: ACHHUZ59LayDDuFa4x5N7le29MHxojRgO7APtJiUVFdDa51w0VW6AysowPj3x1sUV/AAwEyyH5BzRW2PlE3RH21PvtU=
X-Received: by 2002:a05:6e02:214e:b0:33b:3d94:afb5 with SMTP id
 d14-20020a056e02214e00b0033b3d94afb5mr58573ilv.25.1685669859279; Thu, 01 Jun
 2023 18:37:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230519005231.3027912-1-rananta@google.com> <20230519005231.3027912-4-rananta@google.com>
 <87v8gbjkzn.wl-maz@kernel.org> <CAJHc60x0iFWOFxcCYpH6bG+CinBM2TmYxvADKwOqDsUFJCr0AA@mail.gmail.com>
 <86zg5kc2ho.wl-maz@kernel.org>
In-Reply-To: <86zg5kc2ho.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 1 Jun 2023 18:37:28 -0700
Message-ID: <CAJHc60wKDbfQsjmxkv9A6h56NXtU=DapDynFLDtdvChX_ueQeA@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Ricardo Koller <ricarkol@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Colton Lewis <coltonlewis@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 31, 2023 at 1:46=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Tue, 30 May 2023 22:22:23 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > On Mon, May 29, 2023 at 7:00=E2=80=AFAM Marc Zyngier <maz@kernel.org> w=
rote:
> > >
> > > On Fri, 19 May 2023 01:52:28 +0100,
> > > Raghavendra Rao Ananta <rananta@google.com> wrote:
> > > >
> > > > Implement kvm_arch_flush_remote_tlbs_range() for arm64
> > > > to invalidate the given range in the TLB.
> > > >
> > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > > ---
> > > >  arch/arm64/include/asm/kvm_host.h |  3 +++
> > > >  arch/arm64/kvm/hyp/nvhe/tlb.c     |  4 +---
> > > >  arch/arm64/kvm/mmu.c              | 11 +++++++++++
> > > >  3 files changed, 15 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include=
/asm/kvm_host.h
> > > > index 81ab41b84f436..343fb530eea9c 100644
> > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > @@ -1081,6 +1081,9 @@ struct kvm *kvm_arch_alloc_vm(void);
> > > >  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> > > >  int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
> > > >
> > > > +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> > > > +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_=
gfn, u64 pages);
> > > > +
> > > >  static inline bool kvm_vm_is_protected(struct kvm *kvm)
> > > >  {
> > > >       return false;
> > > > diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvh=
e/tlb.c
> > > > index d4ea549c4b5c4..d2c7c1bc6d441 100644
> > > > --- a/arch/arm64/kvm/hyp/nvhe/tlb.c
> > > > +++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
> > > > @@ -150,10 +150,8 @@ void __kvm_tlb_flush_vmid_range(struct kvm_s2_=
mmu *mmu,
> > > >               return;
> > > >       }
> > > >
> > > > -     dsb(ishst);
> > > > -
> > > >       /* Switch to requested VMID */
> > > > -     __tlb_switch_to_guest(mmu, &cxt);
> > > > +     __tlb_switch_to_guest(mmu, &cxt, false);
> > >
> > > This hunk is in the wrong patch, isn't it?
> > >
> > Ah, you are right. It should be part of the previous patch. I think I
> > introduced it accidentally when I rebased the series. I'll remove it
> > in the next spin.
> >
> >
> > > >
> > > >       __flush_tlb_range_op(ipas2e1is, start, pages, stride, 0, 0, f=
alse);
> > > >
> > > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > > index d0a0d3dca9316..e3673b4c10292 100644
> > > > --- a/arch/arm64/kvm/mmu.c
> > > > +++ b/arch/arm64/kvm/mmu.c
> > > > @@ -92,6 +92,17 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
> > > >       return 0;
> > > >  }
> > > >
> > > > +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_=
gfn, u64 pages)
> > > > +{
> > > > +     phys_addr_t start, end;
> > > > +
> > > > +     start =3D start_gfn << PAGE_SHIFT;
> > > > +     end =3D (start_gfn + pages) << PAGE_SHIFT;
> > > > +
> > > > +     kvm_call_hyp(__kvm_tlb_flush_vmid_range, &kvm->arch.mmu, star=
t, end);
> > >
> > > So that's the point that I think is not right. It is the MMU code tha=
t
> > > should drive the invalidation method, and not the HYP code. The HYP
> > > code should be as dumb as possible, and the logic should be kept in
> > > the MMU code.
> > >
> > > So when a range invalidation is forwarded to HYP, it's a *valid* rang=
e
> > > invalidation. not something that can fallback to VMID-wide invalidati=
on.
> > >
> > I'm guessing that you are referring to patch-2. Do you recommend
> > moving the 'pages >=3D MAX_TLBI_RANGE_PAGES' logic here and simply
> > return an error? How about for the other check:
> > system_supports_tlb_range()?
> > The idea was for __kvm_tlb_flush_vmid_range() to also implement a
> > fallback mechanism in case the system doesn't support the range-based
> > instructions. But if we end up calling __kvm_tlb_flush_vmid_range()
> > from multiple cases, we'd end up duplicating the checks. WDYT?
>
> My take is that there should be a single helper deciding to issue
> either a number of range-based TLBIs depending on start/end, or a
> single VMID-based TLBI. Having multiple calling sites is not a
> problem, and even if that code gets duplicated, big deal.
>
Hypothetically, if I move the check to this patch and return an error
if this situation occurs, since I'm dependending on David's common MMU
code [1], kvm_main.c would end of calling kvm_flush_remote_tlbs() and
we'd be doing a VMID-based TLBI.
One idea would be to issue a WARN_ON() and return 0 so that we don't
issue any TLBIs. Thoughts?

> But a hypercall that falls back to global invalidation based on a
> range evaluation error (more than MAX_TLBI_RANGE_PAGES) is papering
> over a latent bug.
>
If I understand this correctly, MAX_TLBI_RANGE_PAGES is specifically
the capacity of the range-based instructions itself, isn't it? Is it
incorrect for the caller to request a higher range be invalidated even
on systems that do not support these instructions? Probably that's why
__flush_tlb_range() falls back to a global flush when the range
request is exceeded?

Thank you.
Raghavendra

[1]:  https://lore.kernel.org/linux-arm-kernel/20230126184025.2294823-7-dma=
tlack@google.com/


> There should be no logic whatsoever in any of the two tlb.c files.
> Only a switch to the correct context, and the requested invalidation,
> which *must* be architecturally correct.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
