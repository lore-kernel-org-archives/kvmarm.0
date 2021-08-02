Return-Path: <SRS0=xqRQ=MZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60EA8C4320A
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 15:37:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D5B0E610FD
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 15:37:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D5B0E610FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 409F94A1B0;
	Mon,  2 Aug 2021 11:37:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KGdgthtgSPgj; Mon,  2 Aug 2021 11:37:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E3154A49C;
	Mon,  2 Aug 2021 11:37:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E62C4A1B0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 11:37:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E2ZyzktqYOmV for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Aug 2021 11:37:15 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8894B49FB7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 11:37:15 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02B5A610A8;
 Mon,  2 Aug 2021 15:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1627918634;
 bh=KbDcPFeTY6MZZybLD6Q3+qK9vhOUrcFoqm0L4COvzKY=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=SDR1PWPIhKnU7k6XlsLHL5m+lr3GGEFKMTZ9HbvB+P0DySQEGSfLTP0Eu3OSNiN7f
 j6jF6WKW7Y0YjQHtslIucDoRj1//G6hYyimo/ePkifEkZ8R9Ea0sdaKeL1HbfArRBd
 KqvWJx+vNRi4FkgSjRB/wJCOUpKGHxzyiFoPz1EjlpyHV6YS0oP/UZNiGgrWjCle5L
 CLeodhdVI2VMvA/JGiIZkJfrvH8K4t/n8KLcrb6yomn3lFLBXFhUhJeh5rn2SshGDL
 vNrUW4HYSVbCz9Ni4upPqcjj6uuvh/wvfglyZloXgX6r3TiWk6t0DqX78cXKpR/fP5
 8yeD+9fiPzJ1g==
Date: Mon, 2 Aug 2021 18:37:00 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v2] memblock: make memblock_find_in_range method private
Message-ID: <YQgRHNLt+8Swein9@kernel.org>
References: <20210802063737.22733-1-rppt@kernel.org>
 <CAL_Jsq+i17C=+9bg=XPattuHe+M8NE3B29+FCg4p3-bPDgSaKw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+i17C=+9bg=XPattuHe+M8NE3B29+FCg4p3-bPDgSaKw@mail.gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "open list:MIPS" <linux-mips@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
 Will Deacon <will@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
 linux-riscv <linux-riscv@lists.infradead.org>,
 Frank Rowand <frowand.list@gmail.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, linux-s390@vger.kernel.org,
 "open list:ACPI FOR ARM64 \(ACPI/arm64\)" <linux-acpi@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, X86 ML <x86@kernel.org>,
 Russell King <linux@armlinux.org.uk>, Mike Rapoport <rppt@linux.ibm.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Ingo Molnar <mingo@redhat.com>,
 Len Brown <lenb@kernel.org>, devicetree@vger.kernel.org,
 Albert Ou <aou@eecs.berkeley.edu>, Vasily Gorbik <gor@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Borislav Petkov <bp@alien8.de>,
 Andy Lutomirski <luto@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 "Kirill A. Shutemov" <kirill@shutemov.name>,
 Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rjw@rjwysocki.net>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Andrew Morton <akpm@linux-foundation.org>
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

Hi Rob,

On Mon, Aug 02, 2021 at 08:55:57AM -0600, Rob Herring wrote:
> On Mon, Aug 2, 2021 at 12:37 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > From: Mike Rapoport <rppt@linux.ibm.com>
> >
> > There are a lot of uses of memblock_find_in_range() along with
> > memblock_reserve() from the times memblock allocation APIs did not exist.
> >
> > memblock_find_in_range() is the very core of memblock allocations, so any
> > future changes to its internal behaviour would mandate updates of all the
> > users outside memblock.
> >
> > Replace the calls to memblock_find_in_range() with an equivalent calls to
> > memblock_phys_alloc() and memblock_phys_alloc_range() and make
> > memblock_find_in_range() private method of memblock.
> >
> > This simplifies the callers, ensures that (unlikely) errors in
> > memblock_reserve() are handled and improves maintainability of
> > memblock_find_in_range().
> >
> > Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> > ---
> > v2: don't change error message in arm::reserve_crashkernel(), per Russell
> > v1: https://lore.kernel.org/lkml/20210730104039.7047-1-rppt@kernel.org
> >
> >  arch/arm/kernel/setup.c           | 18 +++++--------
> >  arch/arm64/kvm/hyp/reserved_mem.c |  9 +++----
> >  arch/arm64/mm/init.c              | 36 ++++++++-----------------
> >  arch/mips/kernel/setup.c          | 14 +++++-----
> >  arch/riscv/mm/init.c              | 44 ++++++++++---------------------
> >  arch/s390/kernel/setup.c          | 10 ++++---
> >  arch/x86/kernel/aperture_64.c     |  5 ++--
> >  arch/x86/mm/init.c                | 21 +++++++++------
> >  arch/x86/mm/numa.c                |  5 ++--
> >  arch/x86/mm/numa_emulation.c      |  5 ++--
> >  arch/x86/realmode/init.c          |  2 +-
> >  drivers/acpi/tables.c             |  5 ++--
> >  drivers/base/arch_numa.c          |  5 +---
> >  drivers/of/of_reserved_mem.c      | 12 ++++++---
> >  include/linux/memblock.h          |  2 --
> >  mm/memblock.c                     |  2 +-
> >  16 files changed, 78 insertions(+), 117 deletions(-)
> >
> > diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> > index f97eb2371672..67f5421b2af7 100644
> > --- a/arch/arm/kernel/setup.c
> > +++ b/arch/arm/kernel/setup.c
> > @@ -1012,31 +1012,25 @@ static void __init reserve_crashkernel(void)
> >                 unsigned long long lowmem_max = __pa(high_memory - 1) + 1;
> >                 if (crash_max > lowmem_max)
> >                         crash_max = lowmem_max;
> > -               crash_base = memblock_find_in_range(CRASH_ALIGN, crash_max,
> > -                                                   crash_size, CRASH_ALIGN);
> > +
> > +               crash_base = memblock_phys_alloc_range(crash_size, CRASH_ALIGN,
> > +                                                      CRASH_ALIGN, crash_max);
> >                 if (!crash_base) {
> >                         pr_err("crashkernel reservation failed - No suitable area found.\n");
> >                         return;
> >                 }
> >         } else {
> > +               unsigned long long crash_max = crash_base + crash_size;
> >                 unsigned long long start;
> >
> > -               start = memblock_find_in_range(crash_base,
> > -                                              crash_base + crash_size,
> > -                                              crash_size, SECTION_SIZE);
> > +               start = memblock_phys_alloc_range(crash_size, SECTION_SIZE,
> > +                                                 crash_base, crash_max);
> >                 if (start != crash_base) {
> 
> If this is true and start is non-zero, then you need an
> memblock_free(). However, since the range is equal to the size, then
> that can never happen and just checking !start is sufficient.

Agree. Will update.
 
> >                         pr_err("crashkernel reservation failed - memory is in use.\n");
> >                         return;
> >                 }
> >         }
> >
> > -       ret = memblock_reserve(crash_base, crash_size);
> > -       if (ret < 0) {
> > -               pr_warn("crashkernel reservation failed - memory is in use (0x%lx)\n",
> > -                       (unsigned long)crash_base);
> > -               return;
> > -       }
> > -
> >         pr_info("Reserving %ldMB of memory at %ldMB for crashkernel (System RAM: %ldMB)\n",
> >                 (unsigned long)(crash_size >> 20),
> >                 (unsigned long)(crash_base >> 20),
> > diff --git a/arch/arm64/kvm/hyp/reserved_mem.c b/arch/arm64/kvm/hyp/reserved_mem.c
> > index d654921dd09b..578670e3f608 100644
> > --- a/arch/arm64/kvm/hyp/reserved_mem.c
> > +++ b/arch/arm64/kvm/hyp/reserved_mem.c
> > @@ -92,12 +92,10 @@ void __init kvm_hyp_reserve(void)
> >          * this is unmapped from the host stage-2, and fallback to PAGE_SIZE.
> >          */
> >         hyp_mem_size = hyp_mem_pages << PAGE_SHIFT;
> > -       hyp_mem_base = memblock_find_in_range(0, memblock_end_of_DRAM(),
> > -                                             ALIGN(hyp_mem_size, PMD_SIZE),
> > -                                             PMD_SIZE);
> > +       hyp_mem_base = memblock_phys_alloc(ALIGN(hyp_mem_size, PMD_SIZE),
> > +                                          PMD_SIZE);
> >         if (!hyp_mem_base)
> > -               hyp_mem_base = memblock_find_in_range(0, memblock_end_of_DRAM(),
> > -                                                     hyp_mem_size, PAGE_SIZE);
> > +               hyp_mem_base = memblock_phys_alloc(hyp_mem_size, PAGE_SIZE);
> >         else
> >                 hyp_mem_size = ALIGN(hyp_mem_size, PMD_SIZE);
> >
> > @@ -105,7 +103,6 @@ void __init kvm_hyp_reserve(void)
> >                 kvm_err("Failed to reserve hyp memory\n");
> >                 return;
> >         }
> > -       memblock_reserve(hyp_mem_base, hyp_mem_size);
> >
> >         kvm_info("Reserved %lld MiB at 0x%llx\n", hyp_mem_size >> 20,
> >                  hyp_mem_base);
> > diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> > index 8490ed2917ff..d566478a06dd 100644
> > --- a/arch/arm64/mm/init.c
> > +++ b/arch/arm64/mm/init.c
> > @@ -74,6 +74,7 @@ phys_addr_t arm64_dma_phys_limit __ro_after_init;
> >  static void __init reserve_crashkernel(void)
> >  {
> >         unsigned long long crash_base, crash_size;
> > +       unsigned long crash_max = arm64_dma_phys_limit;
> 
> It all works out to the same size, but it doesn't make sense that
> crash_base and crash_size are long long and crash_max is long.

Indeed, thanks.
 
> >         int ret;
> >
> >         ret = parse_crashkernel(boot_command_line, memblock_phys_mem_size(),
> > @@ -84,33 +85,18 @@ static void __init reserve_crashkernel(void)
> >
> >         crash_size = PAGE_ALIGN(crash_size);
> >
> > -       if (crash_base == 0) {
> > -               /* Current arm64 boot protocol requires 2MB alignment */
> > -               crash_base = memblock_find_in_range(0, arm64_dma_phys_limit,
> > -                               crash_size, SZ_2M);
> > -               if (crash_base == 0) {
> > -                       pr_warn("cannot allocate crashkernel (size:0x%llx)\n",
> > -                               crash_size);
> > -                       return;
> > -               }
> > -       } else {
> > -               /* User specifies base address explicitly. */
> > -               if (!memblock_is_region_memory(crash_base, crash_size)) {
> > -                       pr_warn("cannot reserve crashkernel: region is not memory\n");
> > -                       return;
> > -               }
> > +       /* User specifies base address explicitly. */
> > +       if (crash_base)
> > +               crash_max = crash_base + crash_size;
> >
> > -               if (memblock_is_region_reserved(crash_base, crash_size)) {
> > -                       pr_warn("cannot reserve crashkernel: region overlaps reserved memory\n");
> > -                       return;
> > -               }
> > -
> > -               if (!IS_ALIGNED(crash_base, SZ_2M)) {
> > -                       pr_warn("cannot reserve crashkernel: base address is not 2MB aligned\n");
> > -                       return;
> 
> We've lost the alignment check.
> 
> Perhaps memblock_phys_alloc_range() should check that the start
> matches the alignment. That would simplify the return handling as it
> seems NULL is not the only error case.

We only lost pr_warn() about the alignment check. When crash_base != 0, we
are trying to allocate the exact [base, base + size) region aligned at 2M.
If it is free we get the address, if not we get 0.
 
> > -               }
> > +       /* Current arm64 boot protocol requires 2MB alignment */
> > +       crash_base = memblock_phys_alloc_range(crash_size, SZ_2M,
> > +                                              crash_base, crash_max);
> > +       if (!crash_base) {
> > +               pr_warn("cannot allocate crashkernel (size:0x%llx)\n",
> > +                       crash_size);
> > +               return;
> >         }
> > -       memblock_reserve(crash_base, crash_size);
> >
> >         pr_info("crashkernel reserved: 0x%016llx - 0x%016llx (%lld MB)\n",
> >                 crash_base, crash_base + crash_size, crash_size >> 20);
> 
> [...]
> 
> > diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
> > index 6534c92d0f83..31b5856010cb 100644
> > --- a/arch/x86/realmode/init.c
> > +++ b/arch/x86/realmode/init.c
> > @@ -28,7 +28,7 @@ void __init reserve_real_mode(void)
> >         WARN_ON(slab_is_available());
> >
> >         /* Has to be under 1M so we can execute real-mode AP code. */
> > -       mem = memblock_find_in_range(0, 1<<20, size, PAGE_SIZE);
> > +       mem = memblock_phys_alloc_range(size, PAGE_SIZE, 0, 1<<20);
> >         if (!mem)
> >                 pr_info("No sub-1M memory is available for the trampoline\n");
> >         else
> 
> Don't you need to drop the memblock_reserve() after this?

Nope, it reserves the entire first 1M, which is more than we allocated
here. The call to memblock_reserve() in memblock_phys_alloc_range() will be
redundant here, but IMHO it's clearer this way.

-- 
Sincerely yours,
Mike.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
