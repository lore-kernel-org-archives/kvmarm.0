Return-Path: <SRS0=MyuK=ZH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C629FC432C3
	for <kvmarm@archiver.kernel.org>; Fri, 15 Nov 2019 08:15:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4BE2B20729
	for <kvmarm@archiver.kernel.org>; Fri, 15 Nov 2019 08:15:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4BE2B20729
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86CDE4AEFB;
	Fri, 15 Nov 2019 03:15:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i8fSKnNuSUiM; Fri, 15 Nov 2019 03:15:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 209014AF05;
	Fri, 15 Nov 2019 03:15:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B89004AF74
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Nov 2019 13:13:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ebfcY7smt+4h for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Nov 2019 13:13:10 -0500 (EST)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de
 [85.220.165.71])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C0A14AF67
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Nov 2019 13:13:10 -0500 (EST)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
 by metis.ext.pengutronix.de with esmtps
 (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <mfe@pengutronix.de>)
 id 1iVJc0-0000jD-Rz; Thu, 14 Nov 2019 19:12:56 +0100
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
 (envelope-from <mfe@pengutronix.de>)
 id 1iVJbo-00011h-3P; Thu, 14 Nov 2019 19:12:44 +0100
Date: Thu, 14 Nov 2019 19:12:43 +0100
From: Marco Felsch <m.felsch@pengutronix.de>
To: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v6 0/6] KASan for arm
Message-ID: <20191114181243.q37rxoo3seds6oxy@pengutronix.de>
References: <20190617221134.9930-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190617221134.9930-1-f.fainelli@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:55:45 up 181 days, 13 min, 127 users, load average: 0.09, 0.08, 
 0.06
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de);
 SAEximRunCond expanded to false
X-PTX-Original-Recipient: kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Fri, 15 Nov 2019 03:15:36 -0500
Cc: alexandre.belloni@bootlin.com, mhocko@suse.com, catalin.marinas@arm.com,
 dhowells@redhat.com, yamada.masahiro@socionext.com, ryabinin.a.a@gmail.com,
 glider@google.com, kvmarm@lists.cs.columbia.edu, corbet@lwn.net,
 liuwenliang@huawei.com, daniel.lezcano@linaro.org, linux@armlinux.org.uk,
 kasan-dev@googlegroups.com, geert@linux-m68k.org, dvyukov@google.com,
 bcm-kernel-feedback-list@broadcom.com, keescook@chromium.org, arnd@arndb.de,
 marc.zyngier@arm.com, andre.przywara@arm.com, pombredanne@nexb.com,
 jinb.park7@gmail.com, tglx@linutronix.de, kernel@pengutronix.de,
 linux-arm-kernel@lists.infradead.org, nico@fluxnic.net,
 gregkh@linuxfoundation.org, ard.biesheuvel@linaro.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, rob@landley.net,
 philip@cog.systems, akpm@linux-foundation.org, thgarnie@google.com,
 kirill.shutemov@linux.intel.com
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

Hi Florian,

first of all, many thanks for your work on this series =) I picked your
and Arnd patches to make it compilable. Now it's compiling but my imx6q
board didn't boot anymore. I debugged the code and found that the branch
to 'start_kernel' won't be reached

8<------- arch/arm/kernel/head-common.S -------
....

#ifdef CONFIG_KASAN
        bl      kasan_early_init
#endif
	mov     lr, #0
	b       start_kernel
ENDPROC(__mmap_switched)

....
8<----------------------------------------------

Now, I found also that 'KASAN_SHADOW_OFFSET' isn't set due to missing
'CONFIG_KASAN_SHADOW_OFFSET' and so no '-fasan-shadow-offset=xxxxx' is
added. Can that be the reason why my board isn't booted anymore?

Thanks for your reply.

Regards,
  Marco

On 19-06-17 15:11, Florian Fainelli wrote:
> Hi all,
> 
> Abbott submitted a v5 about a year ago here:
> 
> and the series was not picked up since then, so I rebased it against
> v5.2-rc4 and re-tested it on a Brahma-B53 (ARMv8 running AArch32 mode)
> and Brahma-B15, both LPAE and test-kasan is consistent with the ARM64
> counter part.
> 
> We were in a fairly good shape last time with a few different people
> having tested it, so I am hoping we can get that included for 5.4 if
> everything goes well.
> 
> Changelog:
> 
> v6 - v5
> - Resolve conflicts during rebase, and updated to make use of
>   kasan_early_shadow_pte instead of kasan_zero_pte
> 
> v5 - v4
> - Modify Andrey Ryabinin's email address.
> 
> v4 - v3
> - Remove the fix of type conversion in kasan_cache_create because it has
>   been fix in the latest version in:
>   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> - Change some Reviewed-by tag into Reported-by tag to avoid misleading.
>   ---Reported by: Marc Zyngier <marc.zyngier@arm.com>
>                   Russell King - ARM Linux <linux@armlinux.org.uk>
> - Disable instrumentation for arch/arm/mm/physaddr.c
> 
> v3 - v2
> - Remove this patch: 2 1-byte checks more safer for memory_is_poisoned_16
>   because a unaligned load/store of 16 bytes is rare on arm, and this
>   patch is very likely to affect the performance of modern CPUs.
>   ---Acked by: Russell King - ARM Linux <linux@armlinux.org.uk>
> - Fixed some link error which kasan_pmd_populate,kasan_pte_populate and
>   kasan_pud_populate are in section .meminit.text but the function
>   kasan_alloc_block which is called by kasan_pmd_populate,
>   kasan_pte_populate and kasan_pud_populate is in section .init.text. So
>   we need change kasan_pmd_populate,kasan_pte_populate and
>   kasan_pud_populate into the section .init.text.
>   ---Reported by: Florian Fainelli <f.fainelli@gmail.com>
> - Fixed some compile error which caused by the wrong access instruction in
>   arch/arm/kernel/entry-common.S.
>   ---Reported by: kbuild test robot <lkp@intel.com>
> - Disable instrumentation for arch/arm/kvm/hyp/*.
>   ---Acked by: Marc Zyngier <marc.zyngier@arm.com>
> - Update the set of supported architectures in
>   Documentation/dev-tools/kasan.rst.
>   ---Acked by:Dmitry Vyukov <dvyukov@google.com>
> - The version 2 is tested by:
>   Florian Fainelli <f.fainelli@gmail.com> (compile test)
>   kbuild test robot <lkp@intel.com>       (compile test)
>   Joel Stanley <joel@jms.id.au>           (on ASPEED ast2500(ARMv5))
> 
> v2 - v1
> - Fixed some compiling error which happens on changing kernel compression
>   mode to lzma/xz/lzo/lz4.
>   ---Reported by: Florian Fainelli <f.fainelli@gmail.com>,
>              Russell King - ARM Linux <linux@armlinux.org.uk>
> - Fixed a compiling error cause by some older arm instruction set(armv4t)
>   don't suppory movw/movt which is reported by kbuild.
> - Changed the pte flag from _L_PTE_DEFAULT | L_PTE_DIRTY | L_PTE_XN to
>   pgprot_val(PAGE_KERNEL).
>   ---Reported by: Russell King - ARM Linux <linux@armlinux.org.uk>
> - Moved Enable KASan patch as the last one.
>   ---Reported by: Florian Fainelli <f.fainelli@gmail.com>,
>      Russell King - ARM Linux <linux@armlinux.org.uk>
> - Moved the definitions of cp15 registers from
>   arch/arm/include/asm/kvm_hyp.h to arch/arm/include/asm/cp15.h.
>   ---Asked by: Mark Rutland <mark.rutland@arm.com>
> - Merge the following commits into the commit
>   Define the virtual space of KASan's shadow region:
>   1) Define the virtual space of KASan's shadow region;
>   2) Avoid cleaning the KASan shadow area's mapping table;
>   3) Add KASan layout;
> - Merge the following commits into the commit
>   Initialize the mapping of KASan shadow memory:
>   1) Initialize the mapping of KASan shadow memory;
>   2) Add support arm LPAE;
>   3) Don't need to map the shadow of KASan's shadow memory;
>      ---Reported by: Russell King - ARM Linux <linux@armlinux.org.uk>
>   4) Change mapping of kasan_zero_page int readonly.
> - The version 1 is tested by Florian Fainelli <f.fainelli@gmail.com>
>   on a Cortex-A5 (no LPAE).
> 
> Hi,all:
>    These patches add arch specific code for kernel address sanitizer
> (see Documentation/kasan.txt).
> 
>    1/8 of kernel addresses reserved for shadow memory. There was no
> big enough hole for this, so virtual addresses for shadow were
> stolen from user space.
> 
>    At early boot stage the whole shadow region populated with just
> one physical page (kasan_zero_page). Later, this page reused
> as readonly zero shadow for some memory that KASan currently
> don't track (vmalloc).
> 
>   After mapping the physical memory, pages for shadow memory are
> allocated and mapped.
> 
>   KASan's stack instrumentation significantly increases stack's
> consumption, so CONFIG_KASAN doubles THREAD_SIZE.
> 
>   Functions like memset/memmove/memcpy do a lot of memory accesses.
> If bad pointer passed to one of these function it is important
> to catch this. Compiler's instrumentation cannot do this since
> these functions are written in assembly.
> 
>   KASan replaces memory functions with manually instrumented variants.
> Original functions declared as weak symbols so strong definitions
> in mm/kasan/kasan.c could replace them. Original functions have aliases
> with '__' prefix in name, so we could call non-instrumented variant
> if needed.
> 
>   Some files built without kasan instrumentation (e.g. mm/slub.c).
> Original mem* function replaced (via #define) with prefixed variants
> to disable memory access checks for such files.
> 
>   On arm LPAE architecture,  the mapping table of KASan shadow memory(if
> PAGE_OFFSET is 0xc0000000, the KASan shadow memory's virtual space is
> 0xb6e000000~0xbf000000) can't be filled in do_translation_fault function,
> because kasan instrumentation maybe cause do_translation_fault function
> accessing KASan shadow memory. The accessing of KASan shadow memory in
> do_translation_fault function maybe cause dead circle. So the mapping table
> of KASan shadow memory need be copyed in pgd_alloc function.
> 
> Most of the code comes from:
> https://github.com/aryabinin/linux/commit/0b54f17e70ff50a902c4af05bb92716eb95acefe
> 
> These patches are tested on vexpress-ca15, vexpress-ca9
> 
> 
> Abbott Liu (2):
>   ARM: Add TTBR operator for kasan_init
>   ARM: Define the virtual space of KASan's shadow region
> 
> Andrey Ryabinin (4):
>   ARM: Disable instrumentation for some code
>   ARM: Replace memory function for kasan
>   ARM: Initialize the mapping of KASan shadow memory
>   ARM: Enable KASan for arm
> 
>  Documentation/dev-tools/kasan.rst     |   4 +-
>  arch/arm/Kconfig                      |   1 +
>  arch/arm/boot/compressed/Makefile     |   1 +
>  arch/arm/boot/compressed/decompress.c |   2 +
>  arch/arm/boot/compressed/libfdt_env.h |   2 +
>  arch/arm/include/asm/cp15.h           | 106 +++++++++
>  arch/arm/include/asm/kasan.h          |  35 +++
>  arch/arm/include/asm/kasan_def.h      |  64 ++++++
>  arch/arm/include/asm/kvm_hyp.h        |  54 -----
>  arch/arm/include/asm/memory.h         |   5 +
>  arch/arm/include/asm/pgalloc.h        |   7 +-
>  arch/arm/include/asm/string.h         |  17 ++
>  arch/arm/include/asm/thread_info.h    |   4 +
>  arch/arm/kernel/entry-armv.S          |   5 +-
>  arch/arm/kernel/entry-common.S        |   9 +-
>  arch/arm/kernel/head-common.S         |   7 +-
>  arch/arm/kernel/setup.c               |   2 +
>  arch/arm/kernel/unwind.c              |   3 +-
>  arch/arm/kvm/hyp/cp15-sr.c            |  12 +-
>  arch/arm/kvm/hyp/switch.c             |   6 +-
>  arch/arm/lib/memcpy.S                 |   3 +
>  arch/arm/lib/memmove.S                |   5 +-
>  arch/arm/lib/memset.S                 |   3 +
>  arch/arm/mm/Makefile                  |   4 +
>  arch/arm/mm/kasan_init.c              | 301 ++++++++++++++++++++++++++
>  arch/arm/mm/mmu.c                     |   7 +-
>  arch/arm/mm/pgd.c                     |  14 ++
>  arch/arm/vdso/Makefile                |   2 +
>  28 files changed, 608 insertions(+), 77 deletions(-)
>  create mode 100644 arch/arm/include/asm/kasan.h
>  create mode 100644 arch/arm/include/asm/kasan_def.h
>  create mode 100644 arch/arm/mm/kasan_init.c
> 
> -- 
> 2.17.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
