Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD50BCCA47F
	for <kvmarm@archiver.kernel.org>; Tue, 19 Jul 2022 14:09:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E26634CD12;
	Tue, 19 Jul 2022 10:09:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dSgog9UWjx4w; Tue, 19 Jul 2022 10:09:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABFBE4CD1A;
	Tue, 19 Jul 2022 10:09:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F12D64CD12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 10:09:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NlH89OLNA-uH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jul 2022 10:09:12 -0400 (EDT)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com
 [209.85.218.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A02014CD07
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 10:09:12 -0400 (EDT)
Received: by mail-ej1-f47.google.com with SMTP id bp15so27431468ejb.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 07:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=wop+H3MjB/5C9Ewbg3QxJp56HQLPnXIoMhIZnojQMEA=;
 b=P1YDBjnYh+1NRqEJ8i+WcfhDk7k0rVUu6Hd0mxClejxYWQzPVk/yzMn/Ymw+aS4kQM
 CJ42DyTuxyr4dw066TJyCFOsHv32M0w6p1pv+k9id/d3UKaySmszftqyQNAxCd2oziQe
 d2LTW392A2MO7qDx1Z5f+405JAkTAnXAk7ZAf2mz8XRDBP/y9uFQfHxQrLDnzP13a0i3
 DgY7544+N7h1pgdylXJopKKtkxaT8VDSYAHs9RsMSkzk/OgIenT1e2d6+FER7ysoI8zt
 6gkL54/ejURz42wWmx5wi9AeYVikA+ApZnchKJyze4LncMAXyRa98s6pBBaJDKJW3fRr
 zTIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=wop+H3MjB/5C9Ewbg3QxJp56HQLPnXIoMhIZnojQMEA=;
 b=0eECfYEV6IPlpyrP3b5KvUFspj8+a/egaQxS6JG/8c/DEQUXZbOMUw8lp7xj/y77TY
 7KN3SB4fbKMYDwNsUXWM/ZCI5maKEKM47ZLCFE9Cgfgob2p+0dpPMUAupu9yJUpHrOT5
 B5Cw47JhUEACvsTqw4wb07XtlXoR03MrBKdnOnyArxqnmeKLWdND2TK5iPb5VlLPjhxi
 eaQndQRwuxB5hKO8kJJbqR5lT7p/hYeO1cqU0tG8vCqBog0PftJe41l6lt958y89aYpY
 u7jgbjyigl+R9nUi3G2zNyiyHE/EfF6K7vfc8KkMTViAGPsPRFbYWp3CHDgc7AQWZK3r
 INIw==
X-Gm-Message-State: AJIora82xi6F4YxWSn59h6v9QeEC4B55Isp2IK/2ttN5pUVFepAwbEQK
 tJ6cbjfwKvP+rfXi6qmd4g13RXZw/Ci6L44rl9dbBQ==
X-Google-Smtp-Source: AGRyM1v4ah4+gXWYXcIXC8MgUfU+3eRgMMiQLvXxA7uAPfRkHkXhTADlxpW7PgeAZqEJ6DX2zQRsaGMAI78ydGtBtwM=
X-Received: by 2002:a17:907:60c6:b0:72f:4645:ead3 with SMTP id
 hv6-20020a17090760c600b0072f4645ead3mr6113608ejc.321.1658239751317; Tue, 19
 Jul 2022 07:09:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220630135747.26983-1-will@kernel.org>
 <20220630135747.26983-15-will@kernel.org>
 <Ytax6L2BUt5ON1Dp@google.com>
In-Reply-To: <Ytax6L2BUt5ON1Dp@google.com>
From: Quentin Perret <qperret@google.com>
Date: Tue, 19 Jul 2022 16:09:00 +0200
Message-ID: <CAPwzONn3oNqKo+OMJiF1+Bx0JRiKhHnMOjbkSCwTeHoT5pAyWg@mail.gmail.com>
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

On Tue, Jul 19, 2022 at 3:30 PM Vincent Donnefort <vdonnefort@google.com> wrote:
>
> >  static struct hyp_pool host_s2_pool;
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> > index d3a3b47181de..17d689483ec4 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> > @@ -14,6 +14,7 @@
> >  #include <nvhe/early_alloc.h>
> >  #include <nvhe/gfp.h>
> >  #include <nvhe/memory.h>
> > +#include <nvhe/mem_protect.h>
> >  #include <nvhe/mm.h>
> >  #include <nvhe/spinlock.h>
> >
> > @@ -24,6 +25,7 @@ struct memblock_region hyp_memory[HYP_MEMBLOCK_REGIONS];
> >  unsigned int hyp_memblock_nr;
> >
> >  static u64 __io_map_base;
> > +static DEFINE_PER_CPU(void *, hyp_fixmap_base);
> >
> >  static int __pkvm_create_mappings(unsigned long start, unsigned long size,
> >                                 unsigned long phys, enum kvm_pgtable_prot prot)
> > @@ -212,6 +214,76 @@ int hyp_map_vectors(void)
> >       return 0;
> >  }
> >
> > +void *hyp_fixmap_map(phys_addr_t phys)
> > +{
> > +     void *addr = *this_cpu_ptr(&hyp_fixmap_base);
> > +     int ret = kvm_pgtable_hyp_map(&pkvm_pgtable, (u64)addr, PAGE_SIZE,
> > +                                   phys, PAGE_HYP);
> > +     return ret ? NULL : addr;
> > +}
> > +
> > +int hyp_fixmap_unmap(void)
> > +{
> > +     void *addr = *this_cpu_ptr(&hyp_fixmap_base);
> > +     int ret = kvm_pgtable_hyp_unmap(&pkvm_pgtable, (u64)addr, PAGE_SIZE);
> > +
> > +     return (ret != PAGE_SIZE) ? -EINVAL : 0;
> > +}
> > +
>
> I probably missed something but as the pagetable pages for this mapping are
> pined, it seems impossible (currently) for this call to fail. Maybe a WARN_ON
> would be more appropriate, especially the callers in the subsequent patches do
> not seem to check for this function return value?

Right, I think that wouldn't hurt. And while looking at this, I
actually think we could get rid of these calls to the map/unmap
functions entirely by keeping the pointers to the reserved PTEs
directly in addition to the VA to which they correspond in the percpu
table. That way we could manipulate the PTEs directly and avoid
unnecessary pgtable walks. Bits [63:1] can probably remain untouched,
and {un}mapping is then only a matter of flipping bit 0 in the PTE
(and TLBI on the unmap path). I'll have a go at it.

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
