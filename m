Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B7218B18
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 17:36:59 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1bc0308d1e2so14865ad.0
        for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 10:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690825019; x=1691429819;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qqwUjf4srHS0GmV2PrhboWOP/pK2frD9PFN9eIO2JAw=;
        b=PW7uXs8te+DjBD/konvGzLWP8g1fMK7bveuEGlOTMiFVF5fJOURsOxjYwDa4V8/7PN
         GfxiTdGyn4gNxwwJEsgm5Sa3Z07XoIws8zOegDuEUNdgEakGsCpulFVJ68YDWRx8hG7J
         pHEIHY9NNGcOKqt3EcY+H5XjDJYzQb9r6s9KF29xhh5Zs48JdBGHLJzvx9IIdfAb6DL2
         uvolYf+4ofy8X/EQBFsrD9bL5wC/3Jo2GpoHAsbLgZmiKj7F/6zz+pRJOqtmGCUykUqb
         cXxdJcVUj2aUL7x0X6KpmqFqe34XSu2p4AB041J8zGtZ22s2J/6FLShweArcanRRNTIu
         x2gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690825019; x=1691429819;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qqwUjf4srHS0GmV2PrhboWOP/pK2frD9PFN9eIO2JAw=;
        b=UoJt+Qm+jwNQ0J9lZ6++d+bA/jCGXkxK4UyqRfYQTUKO0uU6Ugvdd51O6YtSJ0aSqX
         lfsxh1UpoH/EiaWjNzuv2+jsIn+xCdIiUXApH16CTgEM29kCezs18zkL1l0D4ahs0llb
         bENjefmB2J8L6RFsKGakQMYMSBR9XC47zLAhdECxXWlgZPIVFa/dgCmLCS2IV7/81RUC
         68o60dmDF2+MhHLKKKPPTQohhXAWm4fQMYQHY77cB02OsVcQHb9P5eGYFKUlx3O6SFLs
         qHeZ+xg66DwuEhdY1/PBOv3ALGS1ULeQNX6CYHh6GhIiLULlUFctNFmitFMPYK7C6chf
         5agA==
X-Gm-Message-State: ABy/qLagKB67V01QsAClzXJb1Uj5INT5TeKGaDjMau9dBRuMvkm9vocZ
	yOelHU9qMeBwnGmLAmokRab8fs8nrJLNrttE3fsLLg==
X-Google-Smtp-Source: APBJJlFkMuLyTHjACrkUI9ojOs57IF7oGguBdj8b71/dF8frxz4uOZLWejmA7Zhtt9x/0OUhO69yCloZOMPgYxPCZgE=
X-Received: by 2002:a17:902:c410:b0:1b8:82c6:9e11 with SMTP id
 k16-20020a170902c41000b001b882c69e11mr381793plk.0.1690825018566; Mon, 31 Jul
 2023 10:36:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-7-rananta@google.com>
 <87r0otr579.wl-maz@kernel.org>
In-Reply-To: <87r0otr579.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 31 Jul 2023 10:36:47 -0700
Message-ID: <CAJHc60zqOeWXf3kh5hKL6DL3g4znmHaH-TqC0QDcBrWPsHAEXQ@mail.gmail.com>
Subject: Re: [PATCH v7 06/12] arm64: tlb: Refactor the core flush algorithm of __flush_tlb_range
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Gavin Shan <gshan@redhat.com>, 
	Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 27, 2023 at 3:58=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Sat, 22 Jul 2023 03:22:45 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > Currently, the core TLB flush functionality of __flush_tlb_range()
> > hardcodes vae1is (and variants) for the flush operation. In the
> > upcoming patches, the KVM code reuses this core algorithm with
> > ipas2e1is for range based TLB invalidations based on the IPA.
> > Hence, extract the core flush functionality of __flush_tlb_range()
> > into its own macro that accepts an 'op' argument to pass any
> > TLBI operation, such that other callers (KVM) can benefit.
> >
> > No functional changes intended.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> > ---
> >  arch/arm64/include/asm/tlbflush.h | 109 +++++++++++++++---------------
> >  1 file changed, 56 insertions(+), 53 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm=
/tlbflush.h
> > index 412a3b9a3c25..f7fafba25add 100644
> > --- a/arch/arm64/include/asm/tlbflush.h
> > +++ b/arch/arm64/include/asm/tlbflush.h
> > @@ -278,14 +278,62 @@ static inline void flush_tlb_page(struct vm_area_=
struct *vma,
> >   */
> >  #define MAX_TLBI_OPS PTRS_PER_PTE
> >
> > +/* When the CPU does not support TLB range operations, flush the TLB
> > + * entries one by one at the granularity of 'stride'. If the TLB
> > + * range ops are supported, then:
>
> Comment format (the original was correct).
>
Isn't the format the same as original? Or are you referring to the
fact that it needs to be placed inside the macro definition?
> > + *
> > + * 1. If 'pages' is odd, flush the first page through non-range
> > + *    operations;
> > + *
> > + * 2. For remaining pages: the minimum range granularity is decided
> > + *    by 'scale', so multiple range TLBI operations may be required.
> > + *    Start from scale =3D 0, flush the corresponding number of pages
> > + *    ((num+1)*2^(5*scale+1) starting from 'addr'), then increase it
> > + *    until no pages left.
> > + *
> > + * Note that certain ranges can be represented by either num =3D 31 an=
d
> > + * scale or num =3D 0 and scale + 1. The loop below favours the latter
> > + * since num is limited to 30 by the __TLBI_RANGE_NUM() macro.
> > + */
> > +#define __flush_tlb_range_op(op, start, pages, stride,                =
       \
> > +                             asid, tlb_level, tlbi_user)             \
>
> If you make this a common macro, please document the parameters, and
> what the constraints are. For example, what does tlbi_user mean for an
> IPA invalidation?
>
Sure, I'll document the parameters. That'll be helpful.

- Raghavendra
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
