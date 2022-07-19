Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5804C43334
	for <kvmarm@archiver.kernel.org>; Tue, 19 Jul 2022 14:10:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52D424CD72;
	Tue, 19 Jul 2022 10:10:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p1KmBl4UjNBW; Tue, 19 Jul 2022 10:10:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18F024CD6D;
	Tue, 19 Jul 2022 10:10:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3C724CD5C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 10:10:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QpSSgEtETsRf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jul 2022 10:10:14 -0400 (EDT)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com
 [209.85.218.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9612A4CD53
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 10:10:14 -0400 (EDT)
Received: by mail-ej1-f42.google.com with SMTP id sz17so27386731ejc.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 07:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=rSlBICGVylQNfGLNPy9PcFvdIoXz1R8fiwEJrPtfAT8=;
 b=XI6uSXUUjHP4PxFP5xtI0lE1OxcEFTh9vaN9aWV9RZ51ng7YLS5mO9TfIiszL4L5Qf
 AseH24Z1sqYGSshg4DJd/XzBR8Ehvo2fV0qc4MtFJ5zWYaHnAXTshxaV3VL0YikisBhF
 821e9V1aqdKAVukcv4xQC5hepaYsb/akXGKKC5bU2dWao6u7Sp/DHVODcRtZGgU2K/BI
 SdGfvVDDyMhavlds0k1Y/OHnrm/9Kh+kF+/mfkYdUcdBXKdwSzKhMr9lzpP4ih3fEXwv
 +0qP99nG85AZX2XooIANOJFWtIwud4s60gcgn3sjt+fONIqQs7DVSDk5LtVQHAMSt2gn
 izUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=rSlBICGVylQNfGLNPy9PcFvdIoXz1R8fiwEJrPtfAT8=;
 b=RKByCq0PzREZsOcUkfqHlZtAyv5e81rzKAPp8+e5WeBX0kDWucDaFsdcdnfsDRUKG8
 DQbpiYiHskwaMwnEUKR+WKTskAqtmReeH0H7ls2nFOrscX3RNkrWJMY/K4F1Dm620ovz
 N7SGgzxOVjgC37/GsuUYHOV6j4sOgX7KMTriBzneMRcCh/JjAMPj/YeQ08k/O/M1fdLO
 5aJYvzjwaqr4RVxYfGFmiSYn3j38kcDou5FUHK4L12Fg5/LF0/2ovyntcPQ5FPHM7Hsh
 DV3qFm+gAqp8QwhUwHP4sKkPrn+LqfJux0WPTuIV929xFUO3Sd6Q/iC0GQ5SpTlepNMB
 vegQ==
X-Gm-Message-State: AJIora+zOcMkbNeOjW8a8nQ+NvMTwqmx3a3kE7ACBklOF0hsB2p2VYXx
 jg/onuTSxoHR34UZrd0OmFcyPKCn3alHUAaVzEOIgQ==
X-Google-Smtp-Source: AGRyM1uhnS6OmS6G6f2PH0IaO4r/qi0XSl/Nk0fx26ErgePmSPQkUlX7XZWXly4+HDqhv3dWwKf2eceBB6JNbEF2i5g=
X-Received: by 2002:a17:907:2bf4:b0:72b:3336:ca9e with SMTP id
 gv52-20020a1709072bf400b0072b3336ca9emr30580182ejc.341.1658239813388; Tue, 19
 Jul 2022 07:10:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220630135747.26983-1-will@kernel.org>
 <20220630135747.26983-15-will@kernel.org>
 <Ytax6L2BUt5ON1Dp@google.com>
 <CAPwzONn3oNqKo+OMJiF1+Bx0JRiKhHnMOjbkSCwTeHoT5pAyWg@mail.gmail.com>
In-Reply-To: <CAPwzONn3oNqKo+OMJiF1+Bx0JRiKhHnMOjbkSCwTeHoT5pAyWg@mail.gmail.com>
From: Quentin Perret <qperret@google.com>
Date: Tue, 19 Jul 2022 16:10:02 +0200
Message-ID: <CAPwzONkiZ92JKicg6rh+bBQdRG=LKvVET83o8PLKTJbbfLsjUg@mail.gmail.com>
Subject: Re: [PATCH v2 14/24] KVM: arm64: Add pcpu fixmap infrastructure at EL2
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Oliver Upton <oliver.upton@linux.dev>, Andy Lutomirski <luto@amacapital.net>,
 linux-arm-kernel@lists.infradead.org, Michael Roth <michael.roth@amd.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On Tue, Jul 19, 2022 at 4:09 PM Quentin Perret <qperret@google.com> wrote:
>
> On Tue, Jul 19, 2022 at 3:30 PM Vincent Donnefort <vdonnefort@google.com> wrote:
> >
> > >  static struct hyp_pool host_s2_pool;
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> > > index d3a3b47181de..17d689483ec4 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> > > @@ -14,6 +14,7 @@
> > >  #include <nvhe/early_alloc.h>
> > >  #include <nvhe/gfp.h>
> > >  #include <nvhe/memory.h>
> > > +#include <nvhe/mem_protect.h>
> > >  #include <nvhe/mm.h>
> > >  #include <nvhe/spinlock.h>
> > >
> > > @@ -24,6 +25,7 @@ struct memblock_region hyp_memory[HYP_MEMBLOCK_REGIONS];
> > >  unsigned int hyp_memblock_nr;
> > >
> > >  static u64 __io_map_base;
> > > +static DEFINE_PER_CPU(void *, hyp_fixmap_base);
> > >
> > >  static int __pkvm_create_mappings(unsigned long start, unsigned long size,
> > >                                 unsigned long phys, enum kvm_pgtable_prot prot)
> > > @@ -212,6 +214,76 @@ int hyp_map_vectors(void)
> > >       return 0;
> > >  }
> > >
> > > +void *hyp_fixmap_map(phys_addr_t phys)
> > > +{
> > > +     void *addr = *this_cpu_ptr(&hyp_fixmap_base);
> > > +     int ret = kvm_pgtable_hyp_map(&pkvm_pgtable, (u64)addr, PAGE_SIZE,
> > > +                                   phys, PAGE_HYP);
> > > +     return ret ? NULL : addr;
> > > +}
> > > +
> > > +int hyp_fixmap_unmap(void)
> > > +{
> > > +     void *addr = *this_cpu_ptr(&hyp_fixmap_base);
> > > +     int ret = kvm_pgtable_hyp_unmap(&pkvm_pgtable, (u64)addr, PAGE_SIZE);
> > > +
> > > +     return (ret != PAGE_SIZE) ? -EINVAL : 0;
> > > +}
> > > +
> >
> > I probably missed something but as the pagetable pages for this mapping are
> > pined, it seems impossible (currently) for this call to fail. Maybe a WARN_ON
> > would be more appropriate, especially the callers in the subsequent patches do
> > not seem to check for this function return value?
>
> Right, I think that wouldn't hurt. And while looking at this, I
> actually think we could get rid of these calls to the map/unmap
> functions entirely by keeping the pointers to the reserved PTEs
> directly in addition to the VA to which they correspond in the percpu
> table. That way we could manipulate the PTEs directly and avoid
> unnecessary pgtable walks. Bits [63:1] can probably remain untouched,

 Well, the address bits need to change too obviously, but rest can stay.

> and {un}mapping is then only a matter of flipping bit 0 in the PTE
> (and TLBI on the unmap path). I'll have a go at it.
>
> Cheers,
> Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
