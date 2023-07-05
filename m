Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED36B134CD
	for <kvmarm@lists.linux.dev>; Wed,  5 Jul 2023 18:22:04 +0000 (UTC)
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-401d1d967beso43021cf.0
        for <kvmarm@lists.linux.dev>; Wed, 05 Jul 2023 11:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688581324; x=1691173324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=avVYCKbHiJhOupBox2rPu3Kc3oLm07Y5UrCkryiPEfc=;
        b=ZBle+FGiI/+oKmppf7TF2BlE3mHVYEEHBOSoaMyMq/1IB7NyglPEJeLCEksV/f7bMR
         v0aTI8mTCu26TlHwJ/px2joHn0PTI2lWl6CPqUsQ0jJL2SUXrYd4QCJkY7MaNQEiICgt
         +BW2fOuGGwZ27VczohQG+Xa0J3qaNZ9dmGF+s9rMq6mHSGYk31M5EJs9nHSoAI6AMhfr
         IKx6FY9J+vVFHCGH2NOFBtcH6QYx0ZE1WLlIoaVwiorlQH8RDgR8AISMFunkqpx7TVzG
         t8+XFq90GU+Nw3fh1h8SRDVE9ahoViZoUISAXbZgltqc1fLiXzyT2PAH7bubi5Mqsmio
         WteA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688581324; x=1691173324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=avVYCKbHiJhOupBox2rPu3Kc3oLm07Y5UrCkryiPEfc=;
        b=K3R/KG4PhtBG8Jana52nH3l8vtVhJBzIzFHqZZW1YXHbfyaecgthj5vzorrAHJRHa7
         GAtJ8JlUWV9X+0mxkLS2iHqrHiUGvMFqDxBHtTcH+O1cIC+vNebRPRSN5z81DGqZCktl
         pfaxGOn1e1x3gOv1ABhbKg/9XwhM66kanjDV86mEjEI9NcKo4aobPT/1IBwjfsTUX+oS
         FUei85MQA3ZiAncDEtxOmOHE3zc+FGP+c/8fDoO57GCuynty4DNn1YDYTB4gzUBtRV+O
         KcniF2Utx61pHqJ9H1S7OKfmpK07L5iMOJ2rXZlVnCwOSXWcsu9bsZLKXX5WJgFguudI
         JTHw==
X-Gm-Message-State: ABy/qLZFGPDp81z8yRJNC8ct1ATelUjnWalUCv/pV/rm6MFcEdaWBLXv
	kzXfIJ6M/3SmisGiXYY3MkEHAWKNQJoSeHVRoRG9dA==
X-Google-Smtp-Source: APBJJlGTHlkEBqKKQUQxAS0nn1n5NO03cH8n26ikVQ910595sciQNU2NHkrkdt17W6roe0R7ewsHN5CFcaRdRu9AAGs=
X-Received: by 2002:ac8:5ac7:0:b0:3f0:af20:1a37 with SMTP id
 d7-20020ac85ac7000000b003f0af201a37mr15460qtd.15.1688581323594; Wed, 05 Jul
 2023 11:22:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230621175002.2832640-1-rananta@google.com> <20230621175002.2832640-6-rananta@google.com>
 <9f9906b5-cdae-273c-06a3-5e100fe2ccd8@redhat.com>
In-Reply-To: <9f9906b5-cdae-273c-06a3-5e100fe2ccd8@redhat.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Wed, 5 Jul 2023 11:21:52 -0700
Message-ID: <CAJHc60zU3iqf9bse2Hm=ZF2xLY68_Xf30oxYs23PW8fHT09cQQ@mail.gmail.com>
Subject: Re: [RESEND PATCH v5 05/11] arm64: tlb: Refactor the core flush
 algorithm of __flush_tlb_range
To: Gavin Shan <gshan@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 4, 2023 at 5:11=E2=80=AFPM Gavin Shan <gshan@redhat.com> wrote:
>
> On 6/22/23 03:49, Raghavendra Rao Ananta wrote:
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
> > ---
> >   arch/arm64/include/asm/tlbflush.h | 108 +++++++++++++++--------------=
-
> >   1 file changed, 55 insertions(+), 53 deletions(-)
> >
>
> With the following nits addressed:
>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
>
> > diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm=
/tlbflush.h
> > index 412a3b9a3c25d..4775378b6da1b 100644
> > --- a/arch/arm64/include/asm/tlbflush.h
> > +++ b/arch/arm64/include/asm/tlbflush.h
> > @@ -278,14 +278,61 @@ static inline void flush_tlb_page(struct vm_area_=
struct *vma,
> >    */
> >   #define MAX_TLBI_OPS        PTRS_PER_PTE
> >
> > +/* When the CPU does not support TLB range operations, flush the TLB
> > + * entries one by one at the granularity of 'stride'. If the TLB
> > + * range ops are supported, then:
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
> > +                             asid, tlb_level, tlbi_user) do {        \
> > +     int num =3D 0;                                                   =
 \
> > +     int scale =3D 0;                                                 =
 \
> > +     unsigned long addr;                                             \
> > +                                                                     \
> > +     while (pages > 0) {                                             \
> > +             if (!system_supports_tlb_range() ||                     \
> > +                 pages % 2 =3D=3D 1) {                                =
   \
> > +                     addr =3D __TLBI_VADDR(start, asid);              =
 \
> > +                     __tlbi_level(op, addr, tlb_level);              \
> > +                     if (tlbi_user)                                  \
> > +                             __tlbi_user_level(op, addr, tlb_level); \
> > +                     start +=3D stride;                               =
 \
> > +                     pages -=3D stride >> PAGE_SHIFT;                 =
 \
> > +                     continue;                                       \
> > +             }                                                       \
> > +                                                                     \
> > +             num =3D __TLBI_RANGE_NUM(pages, scale);                  =
 \
> > +             if (num >=3D 0) {                                        =
 \
> > +                     addr =3D __TLBI_VADDR_RANGE(start, asid, scale,  =
 \
> > +                                               num, tlb_level);      \
> > +                     __tlbi(r##op, addr);                            \
> > +                     if (tlbi_user)                                  \
> > +                             __tlbi_user(r##op, addr);               \
> > +                     start +=3D __TLBI_RANGE_PAGES(num, scale) << PAGE=
_SHIFT; \
> > +                     pages -=3D __TLBI_RANGE_PAGES(num, scale);       =
 \
> > +             }                                                       \
> > +             scale++;                                                \
> > +     }                                                               \
> > +} while (0)
> > +
>
> There is a warning reported from 'checkpatch.pl'.
>
>      WARNING: suspect code indent for conditional statements (32, 8)
>      #52: FILE: arch/arm64/include/asm/tlbflush.h:299:
>      +                          asid, tlb_level, tlbi_user) do {        \
>      [...]
>      +  unsigned long addr;                                             \
>
>      total: 0 errors, 1 warnings, 125 lines checked
>
> You probably need to tweak it as below, to avoid the warning.
>
>      #define __flush_tlb_range_op(op, start, pages, stride,              =
  \
>                                   asid, tlb_level, tlbi_user)            =
  \
>      do {                                                                =
  \
>
Thanks for the suggestion, Gavin. I'll fix this.

- Raghavendra
>
> >   static inline void __flush_tlb_range(struct vm_area_struct *vma,
> >                                    unsigned long start, unsigned long e=
nd,
> >                                    unsigned long stride, bool last_leve=
l,
> >                                    int tlb_level)
> >   {
> > -     int num =3D 0;
> > -     int scale =3D 0;
> > -     unsigned long asid, addr, pages;
> > +     unsigned long asid, pages;
> >
> >       start =3D round_down(start, stride);
> >       end =3D round_up(end, stride);
> > @@ -307,56 +354,11 @@ static inline void __flush_tlb_range(struct vm_ar=
ea_struct *vma,
> >       dsb(ishst);
> >       asid =3D ASID(vma->vm_mm);
> >
> > -     /*
> > -      * When the CPU does not support TLB range operations, flush the =
TLB
> > -      * entries one by one at the granularity of 'stride'. If the TLB
> > -      * range ops are supported, then:
> > -      *
> > -      * 1. If 'pages' is odd, flush the first page through non-range
> > -      *    operations;
> > -      *
> > -      * 2. For remaining pages: the minimum range granularity is decid=
ed
> > -      *    by 'scale', so multiple range TLBI operations may be requir=
ed.
> > -      *    Start from scale =3D 0, flush the corresponding number of p=
ages
> > -      *    ((num+1)*2^(5*scale+1) starting from 'addr'), then increase=
 it
> > -      *    until no pages left.
> > -      *
> > -      * Note that certain ranges can be represented by either num =3D =
31 and
> > -      * scale or num =3D 0 and scale + 1. The loop below favours the l=
atter
> > -      * since num is limited to 30 by the __TLBI_RANGE_NUM() macro.
> > -      */
> > -     while (pages > 0) {
> > -             if (!system_supports_tlb_range() ||
> > -                 pages % 2 =3D=3D 1) {
> > -                     addr =3D __TLBI_VADDR(start, asid);
> > -                     if (last_level) {
> > -                             __tlbi_level(vale1is, addr, tlb_level);
> > -                             __tlbi_user_level(vale1is, addr, tlb_leve=
l);
> > -                     } else {
> > -                             __tlbi_level(vae1is, addr, tlb_level);
> > -                             __tlbi_user_level(vae1is, addr, tlb_level=
);
> > -                     }
> > -                     start +=3D stride;
> > -                     pages -=3D stride >> PAGE_SHIFT;
> > -                     continue;
> > -             }
> > -
> > -             num =3D __TLBI_RANGE_NUM(pages, scale);
> > -             if (num >=3D 0) {
> > -                     addr =3D __TLBI_VADDR_RANGE(start, asid, scale,
> > -                                               num, tlb_level);
> > -                     if (last_level) {
> > -                             __tlbi(rvale1is, addr);
> > -                             __tlbi_user(rvale1is, addr);
> > -                     } else {
> > -                             __tlbi(rvae1is, addr);
> > -                             __tlbi_user(rvae1is, addr);
> > -                     }
> > -                     start +=3D __TLBI_RANGE_PAGES(num, scale) << PAGE=
_SHIFT;
> > -                     pages -=3D __TLBI_RANGE_PAGES(num, scale);
> > -             }
> > -             scale++;
> > -     }
> > +     if (last_level)
> > +             __flush_tlb_range_op(vale1is, start, pages, stride, asid,=
 tlb_level, true);
> > +     else
> > +             __flush_tlb_range_op(vae1is, start, pages, stride, asid, =
tlb_level, true);
> > +
> >       dsb(ish);
> >   }
> >
>
> Thanks,
> Gavin
>
