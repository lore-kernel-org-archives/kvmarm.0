Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6CC3C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  8 Mar 2022 23:09:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CB8849ED0;
	Tue,  8 Mar 2022 18:09:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C7uPfpk+EOr1; Tue,  8 Mar 2022 18:09:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D112649EC4;
	Tue,  8 Mar 2022 18:09:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5939549EBE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Mar 2022 18:09:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MtufiNdRiAAd for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Mar 2022 18:09:31 -0500 (EST)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
 [209.85.221.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 23FC549EBD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Mar 2022 18:09:31 -0500 (EST)
Received: by mail-wr1-f47.google.com with SMTP id j26so434621wrb.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Mar 2022 15:09:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=1f5gPcrqfy750U/J52Wg+Mj+0/UcxsK3pfUKBKWLDR0=;
 b=rY724zyNQvt0W7k77uJ6mdsljpHhmPedp6A01Ybgi4ape+kd29m4bzWSt+PlFv6VGk
 5F64VH7NbTfh9lbiAtg/QqctdXYwNeto4qq8ILBsk1UjKlgBgsCMQeBPoPLONRLpHghE
 cWdsR0etuAIMnRL3KlwUvfLr789Koi+WEO7RwGW0jHeOJ70GUKcFjnSzplqBRUYBRhT6
 QP8IEuX2CtkcOTNnpXBR5MGZ0IWr8YG+CglWc/j5+G1oi8Hir+ky5riHmAiBgpzzzCL3
 WDmeIljWzrU1rFQ9e3oINeWI9gqLxDH39hU6jNdl97UeioJbJwXvtYXCCKepzEEDLGHC
 BVFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=1f5gPcrqfy750U/J52Wg+Mj+0/UcxsK3pfUKBKWLDR0=;
 b=2QXRjuaT8pIAFnhLw/EpRJyoEnKjAruzyyW7AurJlPdy9psqNAlu4Xx7oK6O+46SOg
 qc3oKjaKsxeaJmTAHsQsE0NZhYqURHSJuslHV+xI8CoqP+A49sYJz+wWPqqvl4qcemJb
 KJ9qDlflKnG3kggt/sWCideWivk7OMh65VQG6oLtVzKi0s1GkRfgNTEYOIyPguBrMR+j
 PLxumwHHIY2+TY5bjRWe2oPAQTCuYZy37nTgWEvJ5KZEMVYSVqX1keLH/RDkpzIkaqby
 et4iL6y+v3kTurNu5uKbjHZ713Q6PjAycy1hhfiQJCT+eCFkqkndXkCN3KAIq1wBk9Qb
 VN4g==
X-Gm-Message-State: AOAM531aR5e5e0eYrjEn7YUVAgjOXc+jBQ22o+RmOq2PnvGQteEVIgGB
 tpLT9ghUzHaac7hCQHOnimb7XmqBWSbgi9SzYWFLwA==
X-Google-Smtp-Source: ABdhPJwNHy+VN+JXLWCDADBmqbJunnYlm8shlOKM3wtyDi3l0Nvo++c+lLHsCuWeoJlsi7IJiccAZFbP2qFwzcnxW0Q=
X-Received: by 2002:adf:eb86:0:b0:1e6:8c92:af6b with SMTP id
 t6-20020adfeb86000000b001e68c92af6bmr13872277wrn.116.1646780969857; Tue, 08
 Mar 2022 15:09:29 -0800 (PST)
MIME-Version: 1.0
References: <20220307184935.1704614-1-kaleshsingh@google.com>
 <20220307184935.1704614-2-kaleshsingh@google.com>
 <CAE-0n52LmVRkrSNN=eJf+TYYnmesVjFv99nnetYvRWshm82rOg@mail.gmail.com>
In-Reply-To: <CAE-0n52LmVRkrSNN=eJf+TYYnmesVjFv99nnetYvRWshm82rOg@mail.gmail.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Tue, 8 Mar 2022 15:09:18 -0800
Message-ID: <CAC_TJvc6LYp95BXQc0DSBBBAZpYpixa+NyHKMLFWsBADD5Ubhg@mail.gmail.com>
Subject: Re: [PATCH v5 1/8] KVM: arm64: Introduce hyp_alloc_private_va_range()
To: Stephen Boyd <swboyd@chromium.org>
Cc: "Cc: Android Kernel" <kernel-team@android.com>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, Will Deacon <will@kernel.org>,
 Peter Collingbourne <pcc@google.com>, Marc Zyngier <maz@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, kvmarm <kvmarm@lists.cs.columbia.edu>
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

On Tue, Mar 8, 2022 at 12:21 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
HI Stephen. Thanks for the review.

> Quoting Kalesh Singh (2022-03-07 10:48:59)
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index bc2aba953299..ccb2847ee2f4 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -457,22 +457,17 @@ int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
> >         return 0;
> >  }
> >
> > -static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
> > -                                       unsigned long *haddr,
> > -                                       enum kvm_pgtable_prot prot)
> > +
> > +/**
> > + * hyp_alloc_private_va_range - Allocates a private VA range.
> > + * @size:      The size of the VA range to reserve.
> > + *
> > + * The private VA range is allocated below io_map_base and
> > + * aligned based on the order of @size.
>
> Add what it returns?
>
> Return: Start address of allocated VA range or some error value... (I don't
> understand this part).
>
> It may also be a good idea to write out what VA is in the description:
>
> The private virtual address (VA) range is allocated below io_map_base
>

Ack

> > + */
> > +unsigned long hyp_alloc_private_va_range(size_t size)
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
> > @@ -484,29 +479,53 @@ static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
> >          *
> >          * The allocated size is always a multiple of PAGE_SIZE.
> >          */
> > -       size = PAGE_ALIGN(size + offset_in_page(phys_addr));
> > -       base = io_map_base - size;
> > +       base = io_map_base - PAGE_ALIGN(size);
> > +
> > +       /* Align the allocation based on the order of its size */
> > +       base = ALIGN_DOWN(base, PAGE_SIZE << get_order(size));
> >
> >         /*
> >          * Verify that BIT(VA_BITS - 1) hasn't been flipped by
> >          * allocating the new area, as it would indicate we've
> >          * overflowed the idmap/IO address range.
> >          */
> > -       if ((base ^ io_map_base) & BIT(VA_BITS - 1))
> > -               ret = -ENOMEM;
> > +       if (!base || (base ^ io_map_base) & BIT(VA_BITS - 1))
> > +               base = (unsigned long)ERR_PTR(-ENOMEM);
>
> It looks odd to use an error pointer casted to unsigned long to return
> from an address allocation function. Why not pass a pointer for base
> like the function was written before and return an int from this
> function with 0 for success and negative error value?Otherwise some
> sort of define should made like DMA_MAPPING_ERROR and that can be used
> to indicate to the caller that the allocation failed, or a simple zero
> may work?

I wanted to keep consistent between the pkvm and traditional nvhe
code. I will refactor both *alloc_private_va_range() functions to take
a pointer and return an int error if that's preferred. There would
still be a case of this kind of cast in
__pkvm_create_private_mapping() which does return an unsigned long
address or ERR_PTR(...). It looks like it was made to return the
address to facilitate use as a hypercall (@Quentin CMIW).

>
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
> > +static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
> > +                                       unsigned long *haddr,
> > +                                       enum kvm_pgtable_prot prot)
> > +{
> > +       unsigned long addr;
> > +       int ret = 0;
> > +
> > +       if (!kvm_host_owns_hyp_mappings()) {
> > +               addr = kvm_call_hyp_nvhe(__pkvm_create_private_mapping,
> > +                                        phys_addr, size, prot);
> > +               if (IS_ERR((void *)addr))
>
> IS_ERR_VALUE()?

Good idea, will remove the extra cast.

>
> > +                       return PTR_ERR((void *)addr);
> > +               *haddr = addr;
> > +
> > +               return 0;
> > +       }
> > +
> > +       size += offset_in_page(phys_addr);
> > +       addr = hyp_alloc_private_va_range(size);
> > +       if (IS_ERR((void *)addr))
>
> IS_ERR_VALUE()?

Ack

>
> > +               return PTR_ERR((void *)addr);
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
>
> Would be simpler to remove the goto, or return early.
>
>         if (!ret)
>                 *haddr = addr + offset_in_page(phys_addr);
>
>         return ret;

Agreed, I'll remove the goto in the next version.

Thanks,
Kalesh
>
> >  }
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
