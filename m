Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81585200BC
	for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 21:22:35 +0000 (UTC)
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-33baee0235cso19495ab.1
        for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 14:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685481754; x=1688073754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jYWGHENv8zybDdaEJH6tmDMPpV6HDylna2LuYPkQz90=;
        b=utiJnvqO5LQbYUs2KvkRBvD+rdL3UUtmYQDdEcGZmxA4W34/p9G/E0QMhRZ6w1Dbz2
         7sJZ15VbabKqPv2CtaUcdF0SnWI+zAWV4R0USBdoShANZmu2mPjAMKyuTPbB/JvU+8BC
         A6C5lxH5v82vOfY/hBSJmgZUBZUOZSQWdi/NwRdfkGAmzbxjHAON66foarJqgzcgX0Jz
         ruP9yxFejGiHArv1WllUChi3T/6zY3kzPpjuE3nHOWEQi5HCg+akMTi8aiZvzCyHKUB5
         H4qHTHqHaxbGjMyrd/xOVKTOrSvjBsVI5ZBpbE+5jENDObUKakf+C6f/nUyoa78FxHRN
         +1DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685481754; x=1688073754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jYWGHENv8zybDdaEJH6tmDMPpV6HDylna2LuYPkQz90=;
        b=NKXqE9Npxc3zYCZcWxIPzZ9TImsfJR8djT60wBopPWwN09HL5hi1mQ4taeg2rT3yhN
         VJLLPHxNPrkonTA2O9ECzm/plcAfoYiGblMSytezP8KtlhbzqYWpPHJJOu7tGOt8AtGy
         BBranC9UNC8aCeZAblKHe3WK3D2nWiPl2BLboFDdcJc/rcxYD/+ZioSWbkQzJOk+F4p2
         6iC1RxLOfgISRWWDA4+FCpYQ4dXmO7NMwUTEVNOj7Yb4tyQhEdR7FbTszIxMJ8HJmj90
         KXi4zaDiIbi8q3hlaz6S4+Z9BktmCL+ZPZ7W5rGE8abFol9QmsOYmof1CpnF6dZs6Zwy
         0Clw==
X-Gm-Message-State: AC+VfDwsNIaHytOkVFGrtQZMQ4VXGhDoGiRoisYWsDEZM+lhs1IEL0w+
	7k3I6zaXZQ6irdvEDkLBiFbGI+9+S/wLS/xRq80FdQ==
X-Google-Smtp-Source: ACHHUZ79g66ZY7C9FY4DInfxll0iOglDkWH3MDSs5ouUxNpRff1YYDmAepJA6yxLXjQdVa0YaQS8C4MWJDCtrTGIolA=
X-Received: by 2002:a05:6e02:170c:b0:335:6626:9f38 with SMTP id
 u12-20020a056e02170c00b0033566269f38mr40933ill.0.1685481754376; Tue, 30 May
 2023 14:22:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230519005231.3027912-1-rananta@google.com> <20230519005231.3027912-4-rananta@google.com>
 <87v8gbjkzn.wl-maz@kernel.org>
In-Reply-To: <87v8gbjkzn.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 30 May 2023 14:22:23 -0700
Message-ID: <CAJHc60x0iFWOFxcCYpH6bG+CinBM2TmYxvADKwOqDsUFJCr0AA@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Ricardo Koller <ricarkol@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Colton Lewis <coltonlewis@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 29, 2023 at 7:00=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Fri, 19 May 2023 01:52:28 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > Implement kvm_arch_flush_remote_tlbs_range() for arm64
> > to invalidate the given range in the TLB.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  3 +++
> >  arch/arm64/kvm/hyp/nvhe/tlb.c     |  4 +---
> >  arch/arm64/kvm/mmu.c              | 11 +++++++++++
> >  3 files changed, 15 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index 81ab41b84f436..343fb530eea9c 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1081,6 +1081,9 @@ struct kvm *kvm_arch_alloc_vm(void);
> >  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> >  int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
> >
> > +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> > +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,=
 u64 pages);
> > +
> >  static inline bool kvm_vm_is_protected(struct kvm *kvm)
> >  {
> >       return false;
> > diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tl=
b.c
> > index d4ea549c4b5c4..d2c7c1bc6d441 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/tlb.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
> > @@ -150,10 +150,8 @@ void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu =
*mmu,
> >               return;
> >       }
> >
> > -     dsb(ishst);
> > -
> >       /* Switch to requested VMID */
> > -     __tlb_switch_to_guest(mmu, &cxt);
> > +     __tlb_switch_to_guest(mmu, &cxt, false);
>
> This hunk is in the wrong patch, isn't it?
>
Ah, you are right. It should be part of the previous patch. I think I
introduced it accidentally when I rebased the series. I'll remove it
in the next spin.


> >
> >       __flush_tlb_range_op(ipas2e1is, start, pages, stride, 0, 0, false=
);
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index d0a0d3dca9316..e3673b4c10292 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -92,6 +92,17 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
> >       return 0;
> >  }
> >
> > +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,=
 u64 pages)
> > +{
> > +     phys_addr_t start, end;
> > +
> > +     start =3D start_gfn << PAGE_SHIFT;
> > +     end =3D (start_gfn + pages) << PAGE_SHIFT;
> > +
> > +     kvm_call_hyp(__kvm_tlb_flush_vmid_range, &kvm->arch.mmu, start, e=
nd);
>
> So that's the point that I think is not right. It is the MMU code that
> should drive the invalidation method, and not the HYP code. The HYP
> code should be as dumb as possible, and the logic should be kept in
> the MMU code.
>
> So when a range invalidation is forwarded to HYP, it's a *valid* range
> invalidation. not something that can fallback to VMID-wide invalidation.
>
I'm guessing that you are referring to patch-2. Do you recommend
moving the 'pages >=3D MAX_TLBI_RANGE_PAGES' logic here and simply
return an error? How about for the other check:
system_supports_tlb_range()?
The idea was for __kvm_tlb_flush_vmid_range() to also implement a
fallback mechanism in case the system doesn't support the range-based
instructions. But if we end up calling __kvm_tlb_flush_vmid_range()
from multiple cases, we'd end up duplicating the checks. WDYT?


> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
