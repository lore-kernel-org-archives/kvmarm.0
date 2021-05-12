Return-Path: <SRS0=saMt=KH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D9EC433B4
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 07:59:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6B745611BF
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 07:59:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B745611BF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D40E44B6E9;
	Wed, 12 May 2021 03:59:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aNj9XAc8xfBz; Wed, 12 May 2021 03:59:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85B0A4B721;
	Wed, 12 May 2021 03:59:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 943744B703
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 03:59:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TYdeVNqgLI98 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 May 2021 03:59:46 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3E1764B2E5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 03:59:46 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF30C613C2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 07:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1620806385;
 bh=/jbrQezTL8G/ui6Q5vjZ+00LR2hUCslIdKJk+xNCZgY=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=dqUIkOHH4A0b11/IJHaaCwCI3sbOltoRHV8RLoBhbUg9wrc3JeVK66bUge4gOmfTd
 VI27E3h4zuKvm1vDW0+zxiofKuQ5ewAAf7whkg5H0wHe/Rr13KUwFx49LunR1lpJWH
 iatdg7FSlp5qY1qV+R9Vfn0MyaSWy4MM0N8zLi5FuezPQ7Ji/m2F8aQaQWpzuFGTxb
 BcPUKT2uSJ79VOF0N/OUYEHCrFcO3bcmUlSnDIBL4fj8feXm7pmQLlU04VX3TaSatn
 vBLdvuXGKRD6MC93+ifGXhhJqUOwpgbvDAht5+lfPUDjGxGLeCh7HnIwzHJt9zn5Js
 kuGyGnp6XjrdA==
Received: by mail-oi1-f177.google.com with SMTP id n184so21473599oia.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 00:59:44 -0700 (PDT)
X-Gm-Message-State: AOAM5311g9m4OnKGtlUaWdp52oASTUfJLXFWHgbwPMOhAaKjereWCc3H
 TNg23CT67r7y/26ZZsFatGNUShMhgP4gtPs5R/Y=
X-Google-Smtp-Source: ABdhPJwiXQK1n/wBurFk/qMzA9zSmBQYyMp/smLZRpZ5mb6HG5OLIvzlMqKlDQM6+S8vLVEBuAav/8FG2yoiJ7+A87A=
X-Received: by 2002:aca:4056:: with SMTP id n83mr6713227oia.47.1620806384150; 
 Wed, 12 May 2021 00:59:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210511100550.28178-1-rppt@kernel.org>
 <CAMj1kXFHLkmgZKEb8BtgGt6GQ93Qd+yv6NtiCvtgX0ex9wSeyw@mail.gmail.com>
 <YJuE5O8nWNc1TGZ6@linux.ibm.com>
In-Reply-To: <YJuE5O8nWNc1TGZ6@linux.ibm.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 12 May 2021 09:59:33 +0200
X-Gmail-Original-Message-ID: <CAMj1kXE3G5v=1HFvGoW9weArBLpR_rDyAj0TZxTsZfdrNfgpyw@mail.gmail.com>
Message-ID: <CAMj1kXE3G5v=1HFvGoW9weArBLpR_rDyAj0TZxTsZfdrNfgpyw@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] arm64: drop pfn_valid_within() and simplify
 pfn_valid()
To: Mike Rapoport <rppt@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>,
 Mike Rapoport <rppt@kernel.org>
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

On Wed, 12 May 2021 at 09:34, Mike Rapoport <rppt@linux.ibm.com> wrote:
>
> On Wed, May 12, 2021 at 09:00:02AM +0200, Ard Biesheuvel wrote:
> > On Tue, 11 May 2021 at 12:05, Mike Rapoport <rppt@kernel.org> wrote:
> > >
> > > From: Mike Rapoport <rppt@linux.ibm.com>
> > >
> > > Hi,
> > >
> > > These patches aim to remove CONFIG_HOLES_IN_ZONE and essentially hardwire
> > > pfn_valid_within() to 1.
> > >
> > > The idea is to mark NOMAP pages as reserved in the memory map and restore
> > > the intended semantics of pfn_valid() to designate availability of struct
> > > page for a pfn.
> > >
> > > With this the core mm will be able to cope with the fact that it cannot use
> > > NOMAP pages and the holes created by NOMAP ranges within MAX_ORDER blocks
> > > will be treated correctly even without the need for pfn_valid_within.
> > >
> > > The patches are boot tested on qemu-system-aarch64.
> > >
> >
> > Did you use EFI boot when testing this? The memory map is much more
> > fragmented in that case, so this would be a good data point.
>
> Right, something like this:
>

Yes, although it is not always that bad.

> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x0000000040000000-0x00000000ffffbfff]
> [    0.000000]   node   0: [mem 0x00000000ffffc000-0x00000000ffffffff]

This is allocated below 4 GB by the firmware, for reasons that are
only valid on x86 (where some of the early boot chain is IA32 only)

> [    0.000000]   node   0: [mem 0x0000000100000000-0x00000004386fffff]
> [    0.000000]   node   0: [mem 0x0000000438700000-0x000000043899ffff]
> [    0.000000]   node   0: [mem 0x00000004389a0000-0x00000004389bffff]
> [    0.000000]   node   0: [mem 0x00000004389c0000-0x0000000438b5ffff]
> [    0.000000]   node   0: [mem 0x0000000438b60000-0x000000043be3ffff]
> [    0.000000]   node   0: [mem 0x000000043be40000-0x000000043becffff]
> [    0.000000]   node   0: [mem 0x000000043bed0000-0x000000043bedffff]
> [    0.000000]   node   0: [mem 0x000000043bee0000-0x000000043bffffff]
> [    0.000000]   node   0: [mem 0x000000043c000000-0x000000043fffffff]
>
> This is a pity really, because I don't see a fundamental reason for those
> tiny holes all over the place.
>

There is a config option in the firmware build that allows these
regions to be preallocated using larger windows, which greatly reduces
the fragmentation.
> I know that EFI/ACPI mandates "IO style" memory access for those regions,
> but I fail to get why...
>

Not sure what you mean by 'IO style memory access'.



> > > I beleive it would be best to route these via mmotm tree.
> > >
> > > v4:
> > > * rebase on v5.13-rc1
> > >
> > > v3: Link: https://lore.kernel.org/lkml/20210422061902.21614-1-rppt@kernel.org
> > > * Fix minor issues found by Anshuman
> > > * Freshen up the declaration of pfn_valid() to make it consistent with
> > >   pfn_is_map_memory()
> > > * Add more Acked-by and Reviewed-by tags, thanks Anshuman and David
> > >
> > > v2: Link: https://lore.kernel.org/lkml/20210421065108.1987-1-rppt@kernel.org
> > > * Add check for PFN overflow in pfn_is_map_memory()
> > > * Add Acked-by and Reviewed-by tags, thanks David.
> > >
> > > v1: Link: https://lore.kernel.org/lkml/20210420090925.7457-1-rppt@kernel.org
> > > * Add comment about the semantics of pfn_valid() as Anshuman suggested
> > > * Extend comments about MEMBLOCK_NOMAP, per Anshuman
> > > * Use pfn_is_map_memory() name for the exported wrapper for
> > >   memblock_is_map_memory(). It is still local to arch/arm64 in the end
> > >   because of header dependency issues.
> > >
> > > rfc: Link: https://lore.kernel.org/lkml/20210407172607.8812-1-rppt@kernel.org
> > >
> > > Mike Rapoport (4):
> > >   include/linux/mmzone.h: add documentation for pfn_valid()
> > >   memblock: update initialization of reserved pages
> > >   arm64: decouple check whether pfn is in linear map from pfn_valid()
> > >   arm64: drop pfn_valid_within() and simplify pfn_valid()
> > >
> > >  arch/arm64/Kconfig              |  3 ---
> > >  arch/arm64/include/asm/memory.h |  2 +-
> > >  arch/arm64/include/asm/page.h   |  3 ++-
> > >  arch/arm64/kvm/mmu.c            |  2 +-
> > >  arch/arm64/mm/init.c            | 14 +++++++++++++-
> > >  arch/arm64/mm/ioremap.c         |  4 ++--
> > >  arch/arm64/mm/mmu.c             |  2 +-
> > >  include/linux/memblock.h        |  4 +++-
> > >  include/linux/mmzone.h          | 11 +++++++++++
> > >  mm/memblock.c                   | 28 ++++++++++++++++++++++++++--
> > >  10 files changed, 60 insertions(+), 13 deletions(-)
> > >
> > >
> > > base-commit: 6efb943b8616ec53a5e444193dccf1af9ad627b5
> > > --
> > > 2.28.0
> > >
>
> --
> Sincerely yours,
> Mike.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
