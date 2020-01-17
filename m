Return-Path: <SRS0=hOah=3G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6791EC33CB3
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jan 2020 22:51:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EF9BC21D56
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jan 2020 22:51:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VYiJCWdn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF9BC21D56
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53A074B1B8;
	Fri, 17 Jan 2020 17:51:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VbEUmUqbN+FY; Fri, 17 Jan 2020 17:51:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D23484B189;
	Fri, 17 Jan 2020 17:51:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B2C14B167
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jan 2020 17:51:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SpB2NXK46p9V for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jan 2020 17:51:33 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 81B874B161
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jan 2020 17:51:33 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id y17so24208728wrh.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jan 2020 14:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id;
 bh=rB/I9wTlZsluZ1pWX0XXmWdx5P73UU2DmRV579b2vuw=;
 b=VYiJCWdnIHWee70AS79QYdTXalM9reMJXFRUMUIz+KHfdoqVgiKO4Rd6Kgl3zbWfaL
 E5ADDew7elU/ZkL2S2L+DEDhQFVfi2kcbdLvXT+neW4p023EohibYylTyGj3VG4bhvw4
 K75kh+4aCp6TDR3zzqMbFtCMGOuHomba7lkTo8zIseuQBduZk6dfH3KnLHREo8sgjIsU
 NrAhOwUmyrSxGfy0/mtYNEeg7+jE6ULrt0Z96o+Y17PE6dsDOAIf1IPMSHD635rmPXUg
 gv8jEXKhjgeqFMlnsVaWTVBgUAjR40E/E1HkCMC+e5i9m/W69XW9YV9C7I1JtNDGqvJL
 t+9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id;
 bh=rB/I9wTlZsluZ1pWX0XXmWdx5P73UU2DmRV579b2vuw=;
 b=ej3fVvAakTkGIdm7wyb0Jffc8GJxzHKSApaQWBi5UHe05YNr89W1zjRCd5vzwZVFtH
 EUrm7j/RscPqKI/VrzZprpfs7hSzSWVuRzrXumnQbO2ZXyaGP1lZZvo/76pff0ZqH6CS
 p7UelMWOhba/UTUCnS3XQTRlkyEk6UP8GLCq0v+jidk1yntnnAwbGsCfYWODpqYYCXJM
 nSBQPsAYgIpCEHhPiaxfEiuKLWm/2Iea9BuUHW1TF0KEwZ5pA6Faku0FaeuNwuWBQ0RH
 2WfZCXLP0to+SX8HpwcCi/dDOser1Icvdp7+JUMdzOUKxORlesw8NtFm5m7JlHjAVQK6
 Y37g==
X-Gm-Message-State: APjAAAV4OvV+UUlUZaRXTWwGwE9tHfwTs1k/82BZY0UgLAQyuXDwDv+v
 sSkenCziCBiPZmRx2djtIfQ=
X-Google-Smtp-Source: APXvYqxRjtvkqXGDBZw4rTboBAaOnX0y/AavOd24vu+Daqy2qWUzWWeZe6HEeDL4lyVBAX/r4CgkAg==
X-Received: by 2002:adf:e40f:: with SMTP id g15mr5286688wrm.223.1579301492262; 
 Fri, 17 Jan 2020 14:51:32 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
 by smtp.gmail.com with ESMTPSA id l3sm32829387wrt.29.2020.01.17.14.51.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Jan 2020 14:51:31 -0800 (PST)
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH v7 0/7] KASan for arm
Date: Fri, 17 Jan 2020 14:48:32 -0800
Message-Id: <20200117224839.23531-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Cc: alexandre.belloni@bootlin.com, mhocko@suse.com, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, dhowells@redhat.com,
 yamada.masahiro@socionext.com, ryabinin.a.a@gmail.com, glider@google.com,
 kvmarm@lists.cs.columbia.edu, Florian Fainelli <f.fainelli@gmail.com>,
 corbet@lwn.net, liuwenliang@huawei.com, daniel.lezcano@linaro.org,
 linux@armlinux.org.uk, kasan-dev@googlegroups.com,
 bcm-kernel-feedback-list@broadcom.com, geert@linux-m68k.org,
 keescook@chromium.org, arnd@arndb.de, marc.zyngier@arm.com,
 andre.przywara@arm.com, philip@cog.systems, jinb.park7@gmail.com,
 tglx@linutronix.de, dvyukov@google.com, nico@fluxnic.net,
 gregkh@linuxfoundation.org, ard.biesheuvel@linaro.org,
 linux-doc@vger.kernel.org, rob@landley.net, pombredanne@nexb.com,
 akpm@linux-foundation.org, thgarnie@google.com,
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi all,

Abbott submitted a v5 about a year ago here:

and the series was not picked up since then, so I rebased it against
v5.2-rc4 and re-tested it on a Brahma-B53 (ARMv8 running AArch32 mode)
and Brahma-B15, both LPAE and test-kasan is consistent with the ARM64
counter part.

We were in a fairly good shape last time with a few different people
having tested it, so I am hoping we can get that included for 5.4 if
everything goes well.

Changelog:

v7 - v7
- add Linus' Tested-by for the following platforms:

Tested systems:

QEMU ARM RealView PBA8
QEMU ARM RealView PBX A9
QEMU ARM Versatile AB
Hardware Integrator CP
Hardware Versatile AB with IB2

- define CONFIG_KASAN_SHADOW_OFFSET

v6 - v5
- Resolve conflicts during rebase, and updated to make use of
  kasan_early_shadow_pte instead of kasan_zero_pte

v5 - v4
- Modify Andrey Ryabinin's email address.

v4 - v3
- Remove the fix of type conversion in kasan_cache_create because it has
  been fix in the latest version in:
  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
- Change some Reviewed-by tag into Reported-by tag to avoid misleading.
  ---Reported by: Marc Zyngier <marc.zyngier@arm.com>
                  Russell King - ARM Linux <linux@armlinux.org.uk>
- Disable instrumentation for arch/arm/mm/physaddr.c

v3 - v2
- Remove this patch: 2 1-byte checks more safer for memory_is_poisoned_16
  because a unaligned load/store of 16 bytes is rare on arm, and this
  patch is very likely to affect the performance of modern CPUs.
  ---Acked by: Russell King - ARM Linux <linux@armlinux.org.uk>
- Fixed some link error which kasan_pmd_populate,kasan_pte_populate and
  kasan_pud_populate are in section .meminit.text but the function
  kasan_alloc_block which is called by kasan_pmd_populate,
  kasan_pte_populate and kasan_pud_populate is in section .init.text. So
  we need change kasan_pmd_populate,kasan_pte_populate and
  kasan_pud_populate into the section .init.text.
  ---Reported by: Florian Fainelli <f.fainelli@gmail.com>
- Fixed some compile error which caused by the wrong access instruction in
  arch/arm/kernel/entry-common.S.
  ---Reported by: kbuild test robot <lkp@intel.com>
- Disable instrumentation for arch/arm/kvm/hyp/*.
  ---Acked by: Marc Zyngier <marc.zyngier@arm.com>
- Update the set of supported architectures in
  Documentation/dev-tools/kasan.rst.
  ---Acked by:Dmitry Vyukov <dvyukov@google.com>
- The version 2 is tested by:
  Florian Fainelli <f.fainelli@gmail.com> (compile test)
  kbuild test robot <lkp@intel.com>       (compile test)
  Joel Stanley <joel@jms.id.au>           (on ASPEED ast2500(ARMv5))

v2 - v1
- Fixed some compiling error which happens on changing kernel compression
  mode to lzma/xz/lzo/lz4.
  ---Reported by: Florian Fainelli <f.fainelli@gmail.com>,
             Russell King - ARM Linux <linux@armlinux.org.uk>
- Fixed a compiling error cause by some older arm instruction set(armv4t)
  don't suppory movw/movt which is reported by kbuild.
- Changed the pte flag from _L_PTE_DEFAULT | L_PTE_DIRTY | L_PTE_XN to
  pgprot_val(PAGE_KERNEL).
  ---Reported by: Russell King - ARM Linux <linux@armlinux.org.uk>
- Moved Enable KASan patch as the last one.
  ---Reported by: Florian Fainelli <f.fainelli@gmail.com>,
     Russell King - ARM Linux <linux@armlinux.org.uk>
- Moved the definitions of cp15 registers from
  arch/arm/include/asm/kvm_hyp.h to arch/arm/include/asm/cp15.h.
  ---Asked by: Mark Rutland <mark.rutland@arm.com>
- Merge the following commits into the commit
  Define the virtual space of KASan's shadow region:
  1) Define the virtual space of KASan's shadow region;
  2) Avoid cleaning the KASan shadow area's mapping table;
  3) Add KASan layout;
- Merge the following commits into the commit
  Initialize the mapping of KASan shadow memory:
  1) Initialize the mapping of KASan shadow memory;
  2) Add support arm LPAE;
  3) Don't need to map the shadow of KASan's shadow memory;
     ---Reported by: Russell King - ARM Linux <linux@armlinux.org.uk>
  4) Change mapping of kasan_zero_page int readonly.
- The version 1 is tested by Florian Fainelli <f.fainelli@gmail.com>
  on a Cortex-A5 (no LPAE).

Hi,all:
   These patches add arch specific code for kernel address sanitizer
(see Documentation/kasan.txt).

   1/8 of kernel addresses reserved for shadow memory. There was no
big enough hole for this, so virtual addresses for shadow were
stolen from user space.

   At early boot stage the whole shadow region populated with just
one physical page (kasan_zero_page). Later, this page reused
as readonly zero shadow for some memory that KASan currently
don't track (vmalloc).

  After mapping the physical memory, pages for shadow memory are
allocated and mapped.

  KASan's stack instrumentation significantly increases stack's
consumption, so CONFIG_KASAN doubles THREAD_SIZE.

  Functions like memset/memmove/memcpy do a lot of memory accesses.
If bad pointer passed to one of these function it is important
to catch this. Compiler's instrumentation cannot do this since
these functions are written in assembly.

  KASan replaces memory functions with manually instrumented variants.
Original functions declared as weak symbols so strong definitions
in mm/kasan/kasan.c could replace them. Original functions have aliases
with '__' prefix in name, so we could call non-instrumented variant
if needed.

  Some files built without kasan instrumentation (e.g. mm/slub.c).
Original mem* function replaced (via #define) with prefixed variants
to disable memory access checks for such files.

  On arm LPAE architecture,  the mapping table of KASan shadow memory(if
PAGE_OFFSET is 0xc0000000, the KASan shadow memory's virtual space is
0xb6e000000~0xbf000000) can't be filled in do_translation_fault function,
because kasan instrumentation maybe cause do_translation_fault function
accessing KASan shadow memory. The accessing of KASan shadow memory in
do_translation_fault function maybe cause dead circle. So the mapping table
of KASan shadow memory need be copyed in pgd_alloc function.

Most of the code comes from:
https://github.com/aryabinin/linux/commit/0b54f17e70ff50a902c4af05bb92716eb95acefe

These patches are tested on vexpress-ca15, vexpress-ca9

Abbott Liu (2):
  ARM: Add TTBR operator for kasan_init
  ARM: Define the virtual space of KASan's shadow region

Andrey Ryabinin (4):
  ARM: Disable instrumentation for some code
  ARM: Replace memory function for kasan
  ARM: Initialize the mapping of KASan shadow memory
  ARM: Enable KASan for ARM

Florian Fainelli (1):
  ARM: Moved CP15 definitions from kvm_hyp.h to cp15.h

 Documentation/dev-tools/kasan.rst     |   4 +-
 arch/arm/Kconfig                      |   9 +
 arch/arm/boot/compressed/Makefile     |   2 +
 arch/arm/include/asm/cp15.h           | 107 +++++++++
 arch/arm/include/asm/kasan.h          |  35 +++
 arch/arm/include/asm/kasan_def.h      |  63 ++++++
 arch/arm/include/asm/kvm_hyp.h        |  54 -----
 arch/arm/include/asm/memory.h         |   5 +
 arch/arm/include/asm/pgalloc.h        |   9 +-
 arch/arm/include/asm/string.h         |  17 ++
 arch/arm/include/asm/thread_info.h    |   4 +
 arch/arm/kernel/entry-armv.S          |   5 +-
 arch/arm/kernel/entry-common.S        |   9 +-
 arch/arm/kernel/head-common.S         |   7 +-
 arch/arm/kernel/setup.c               |   2 +
 arch/arm/kernel/unwind.c              |   6 +-
 arch/arm/kvm/hyp/cp15-sr.c            |  12 +-
 arch/arm/kvm/hyp/switch.c             |   6 +-
 arch/arm/lib/memcpy.S                 |   3 +
 arch/arm/lib/memmove.S                |   5 +-
 arch/arm/lib/memset.S                 |   3 +
 arch/arm/mm/Makefile                  |   4 +
 arch/arm/mm/kasan_init.c              | 302 ++++++++++++++++++++++++++
 arch/arm/mm/mmu.c                     |   7 +-
 arch/arm/mm/pgd.c                     |  14 ++
 arch/arm/vdso/Makefile                |   2 +
 drivers/firmware/efi/libstub/Makefile |   3 +-
 27 files changed, 621 insertions(+), 78 deletions(-)
 create mode 100644 arch/arm/include/asm/kasan.h
 create mode 100644 arch/arm/include/asm/kasan_def.h
 create mode 100644 arch/arm/mm/kasan_init.c

-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
