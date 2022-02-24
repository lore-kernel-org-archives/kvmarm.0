Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 240F3C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 14:59:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87E2D4BAAE;
	Fri, 25 Feb 2022 09:59:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id avIqPQzv0uix; Fri, 25 Feb 2022 09:59:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05F874BA24;
	Fri, 25 Feb 2022 09:59:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0BEB4BD83
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 12:20:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J4IioiwD-YjB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 12:20:45 -0500 (EST)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com
 [209.85.128.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CEBDB4BD62
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 12:20:45 -0500 (EST)
Received: by mail-wm1-f46.google.com with SMTP id
 v2-20020a7bcb42000000b0037b9d960079so254817wmj.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 09:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=utvkfVXnWSLnKdSa+6GF8/PEjrYoBqu8Fn7jPDqt4C8=;
 b=szYIf+QYV3bkFqska1K1C7UKOpPo41TzN2e6+y2rvl1hoZ9nWrJLNybL6rXfgMa+Oy
 jYdPkUB7BHGYklKB6fxLUc3o/7OEeG3fUNVf//99pRNztv57dfPpkYQvSop97SBXHOuC
 rMEo+RCm4Mfxj0YHxHJpkETG7GqP0nbNwSgC6MRjdIYo1CIFADFwVE1jkaPROu8f5lkG
 gQd/pTij053kUAh299u3QTXvthJzAlOeRlG8eoKBnRVQDs6Jh81P0hCaP/PD9iZVCM5Y
 vi+tuuypxe+UCJk1KkQQdGul6BVp9pwgH2S+qo+9+iOM/aX1gCUkK8eWIRjMdoKIWaEl
 HxnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=utvkfVXnWSLnKdSa+6GF8/PEjrYoBqu8Fn7jPDqt4C8=;
 b=NBIEGeVKeAig8Pr47/oUKH0RalRfSkV0Evn8u86Bp5tGaaKPklp5mwrOByAMvUs68B
 bb8Epj8FSd9eOYpkIjUUkFBWwU+qMFmp86+Gqi9f+sIFcHyWk/gFSwcikW3kxsqzfbs7
 cs2MknpabzpspokiK5hlan+9UZ4zOr+ENHpAZNWY645MC50Wp0CGyfsnCkDpZmZCMids
 ZIFIPR4Wx4/MiTORdnMQqlKE+42pkK4UO//BfzoS9QZMdP8Q9geraRlnN24G18fnTQfI
 W6AOICK59yhCnsXU5p9kdm2ypZjKVjM1uHTsGJ2Kfxcv4KZgOIqZF56OXW44xX2oKE36
 ISdA==
X-Gm-Message-State: AOAM531tFr/H6svs5Bn59SatNrdz5b9msBfHn0kixkiPat931KzZE6cQ
 9A61W+m8KYSRmm87fYPwnj8C65KIxCpVsQjMNlOiAw==
X-Google-Smtp-Source: ABdhPJyYTMT7ZHiCXg3C7vYinlc/deu0CArrWe4sGJ5a7HqhVEUUgHUB6YfQBKFlcXs+aoYupAJ+EG7p0iyKX3/K2QI=
X-Received: by 2002:a05:600c:4fc4:b0:37c:9116:ef3d with SMTP id
 o4-20020a05600c4fc400b0037c9116ef3dmr3102577wmq.167.1645723244554; Thu, 24
 Feb 2022 09:20:44 -0800 (PST)
MIME-Version: 1.0
References: <20220224051439.640768-1-kaleshsingh@google.com>
 <20220224051439.640768-2-kaleshsingh@google.com>
 <CA+EHjTzkmPuqtpRQRRfRnC2n-ah_jnPiqfa2kg55YESGSjN6OA@mail.gmail.com>
In-Reply-To: <CA+EHjTzkmPuqtpRQRRfRnC2n-ah_jnPiqfa2kg55YESGSjN6OA@mail.gmail.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 24 Feb 2022 09:20:33 -0800
Message-ID: <CAC_TJvdTqiK87iT86JngJbtB-JfRDbuJREcLXvuEg3pqTEzcCQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/8] KVM: arm64: Introduce hyp_alloc_private_va_range()
To: Fuad Tabba <tabba@google.com>
X-Mailman-Approved-At: Fri, 25 Feb 2022 09:59:45 -0500
Cc: "Cc: Android Kernel" <kernel-team@android.com>,
 Will Deacon <will@kernel.org>, Peter Collingbourne <pcc@google.com>,
 Marc Zyngier <maz@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 kvmarm@lists.cs.columbia.edu,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Feb 24, 2022 at 4:25 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Kalesh,
>
> On Thu, Feb 24, 2022 at 5:16 AM Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> > hyp_alloc_private_va_range() can be used to reserve private VA ranges
> > in the nVHE hypervisor. Also update  __create_hyp_private_mapping()
> > to allow specifying an alignment for the private VA mapping.
> >
> > These will be used to implement stack guard pages for KVM nVHE hypervisor
> > (nVHE Hyp mode / not pKVM), in a subsequent patch in the series.
> >
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >
> > Changes in v3:
> >   - Handle null ptr in IS_ERR_OR_NULL checks, per Mark
> >
> >  arch/arm64/include/asm/kvm_mmu.h |  4 +++
> >  arch/arm64/kvm/mmu.c             | 62 ++++++++++++++++++++------------
> >  2 files changed, 43 insertions(+), 23 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> > index 81839e9a8a24..0b0c71302b92 100644
> > --- a/arch/arm64/include/asm/kvm_mmu.h
> > +++ b/arch/arm64/include/asm/kvm_mmu.h
> > @@ -153,6 +153,10 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
> >  int kvm_share_hyp(void *from, void *to);
> >  void kvm_unshare_hyp(void *from, void *to);
> >  int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
> > +unsigned long hyp_alloc_private_va_range(size_t size, size_t align);
> > +int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
> > +                               size_t align, unsigned long *haddr,
> > +                               enum kvm_pgtable_prot prot);
> >  int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
> >                            void __iomem **kaddr,
> >                            void __iomem **haddr);
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index bc2aba953299..fc09536c8197 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -457,22 +457,16 @@ int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
> >         return 0;
> >  }
> >
> > -static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
> > -                                       unsigned long *haddr,
> > -                                       enum kvm_pgtable_prot prot)
> > +
> > +/*
> > + * Allocates a private VA range below io_map_base.
> > + *
> > + * @size:      The size of the VA range to reserve.
> > + * @align:     The required alignment for the allocation.
> > + */
>
> Many of the functions in this file use the kernel-doc format, and your
> added comments are close, but not quite conforment. If you want to use
> the kernel-doc for these you can refer to:
> https://www.kernel.org/doc/html/latest/doc-guide/kernel-doc.html

Hi Fuad,

Thanks for the pointer. I will update the function comments to match
when I send the next version.

>
> > +unsigned long hyp_alloc_private_va_range(size_t size, size_t align)
> >  {
> >         unsigned long base;
> > -       int ret = 0;
> > -
> > -       if (!kvm_host_owns_hyp_mappings()) {
> > -               base = kvm_call_hyp_nvhe(__pkvm_create_private_mapping,
> > -                                        phys_addr, size, prot);
> > -               if (IS_ERR_OR_NULL((void *)base))
> > -                       return PTR_ERR((void *)base);
> > -               *haddr = base;
> > -
> > -               return 0;
> > -       }
> >
> >         mutex_lock(&kvm_hyp_pgd_mutex);
> >
> > @@ -484,8 +478,8 @@ static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
> >          *
> >          * The allocated size is always a multiple of PAGE_SIZE.
> >          */
> > -       size = PAGE_ALIGN(size + offset_in_page(phys_addr));
> > -       base = io_map_base - size;
> > +       base = io_map_base - PAGE_ALIGN(size);
> > +       base = ALIGN_DOWN(base, align);
> >
> >         /*
> >          * Verify that BIT(VA_BITS - 1) hasn't been flipped by
> > @@ -493,20 +487,42 @@ static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
> >          * overflowed the idmap/IO address range.
> >          */
> >         if ((base ^ io_map_base) & BIT(VA_BITS - 1))
> > -               ret = -ENOMEM;
> > +               base = (unsigned long)ERR_PTR(-ENOMEM);
> >         else
> >                 io_map_base = base;
> >
> >         mutex_unlock(&kvm_hyp_pgd_mutex);
> >
> > -       if (ret)
> > -               goto out;
> > +       return base;
> > +}
> > +
> > +int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
> > +                               size_t align, unsigned long *haddr,
> > +                               enum kvm_pgtable_prot prot)
> > +{
> > +       unsigned long addr;
> > +       int ret = 0;
> > +
> > +       if (!kvm_host_owns_hyp_mappings()) {
> > +               addr = kvm_call_hyp_nvhe(__pkvm_create_private_mapping,
> > +                                        phys_addr, size, prot);
> > +               if (IS_ERR_OR_NULL((void *)addr))
> > +                       return addr ? PTR_ERR((void *)addr) : -ENOMEM;
> > +               *haddr = addr;
> > +
> > +               return 0;
> > +       }
> > +
> > +       size += offset_in_page(phys_addr);
>
> You're not page-aligning the size, which was the behavior before this
> patch. However, looking at where it's being used it seems to be fine
> because the users of size would align it if necessary.

This is now done by hyp_alloc_private_va_range() when calculating the new base:
 ...
 * The allocated size is always a multiple of PAGE_SIZE.
 */
base = io_map_base - PAGE_ALIGN(size);
...

Thanks,
Kalesh

>
> Thanks,
> /fuad
>
>
>
> > +       addr = hyp_alloc_private_va_range(size, align);
> > +       if (IS_ERR_OR_NULL((void *)addr))
> > +               return addr ? PTR_ERR((void *)addr) : -ENOMEM;
> >
> > -       ret = __create_hyp_mappings(base, size, phys_addr, prot);
> > +       ret = __create_hyp_mappings(addr, size, phys_addr, prot);
> >         if (ret)
> >                 goto out;
> >
> > -       *haddr = base + offset_in_page(phys_addr);
> > +       *haddr = addr + offset_in_page(phys_addr);
> >  out:
> >         return ret;
> >  }
> > @@ -537,7 +553,7 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
> >                 return 0;
> >         }
> >
> > -       ret = __create_hyp_private_mapping(phys_addr, size,
> > +       ret = __create_hyp_private_mapping(phys_addr, size, PAGE_SIZE,
> >                                            &addr, PAGE_HYP_DEVICE);
> >         if (ret) {
> >                 iounmap(*kaddr);
> > @@ -564,7 +580,7 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
> >
> >         BUG_ON(is_kernel_in_hyp_mode());
> >
> > -       ret = __create_hyp_private_mapping(phys_addr, size,
> > +       ret = __create_hyp_private_mapping(phys_addr, size, PAGE_SIZE,
> >                                            &addr, PAGE_HYP_EXEC);
> >         if (ret) {
> >                 *haddr = NULL;
> > --
> > 2.35.1.473.g83b2b277ed-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
