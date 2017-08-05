From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 00/15] ARM: add and use convenience macros for PC relative
 references
Date: Sat,  5 Aug 2017 21:52:07 +0100
Message-ID: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6308B49C19
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:51:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1Rl4hspzlV1B for <kvmarm@lists.cs.columbia.edu>;
 Sat,  5 Aug 2017 16:51:44 -0400 (EDT)
Received: from mail-wr0-f178.google.com (mail-wr0-f178.google.com
 [209.85.128.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E425849C18
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:51:43 -0400 (EDT)
Received: by mail-wr0-f178.google.com with SMTP id 33so27138201wrz.4
 for <kvmarm@lists.cs.columbia.edu>; Sat, 05 Aug 2017 13:53:07 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, linux-renesas-soc@vger.kernel.org, linux@armlinux.org.uk, linux-omap@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, krzk@kernel.org, jason@lakedaemon.net, arm@kernel.org, andrew@lunn.ch, gregory.clement@free-electrons.com, sebastian.hesselbarth@gmail.com, tony@atomide.com, baohua@kernel.org, horms@verge.net.au, magnus.damm@gmail.com, vireshk@kernel.org, shiraz.linux.kernel@gmail.com, patrice.chotard@st.com, nico@linaro.org, dave.martin@arm.com, marc.zyngier@arm.com
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Every year or so, I make an attempt at contributing assembler macros
that encapsulate PC-relative references, including loads and stores,
and updating existing assembler code to make it more readable and
concise.

Patch #1 implements adr_l, ldr_l and str_l macros that emit PC-relative
references with unlimited range. For v7 and later, relative movw/movt
pairs are used (avoiding the need for loading literals via the D-cache).
For older CPUs, a literal containing a relative offset wrt the instruction
that adds the value of PC is emitted into a subsection, which works around
the objections given last time around, regarding the limited range of
PC-relative group relocations, and the fact that they are EABI only. In
this case, the range is unlimited, although the subsection needs to be
emitted within 4 K of the ldr instruction. (This limit can be extended
but that is currently unnecessary: .text sizes of objects built from .S
files never exceed 4 K in size. Please refer to the list below, after
the diffstat, for the sizes of the .text sections of all such objects
that are built as part of a multi_v7_defconfig kernel)

All patches beyond #1 are independent, but obviously all depend on the
first one. I understand there may be concerns about churn, but some of
these cleanups are really quite nice so please don't dismiss the series
wholesale for that reason.

Ard Biesheuvel (15):
  ARM: assembler: introduce adr_l, ldr_l and str_l macros
  ARM: head-common.S: use PC-relative insn sequence for __proc_info
  ARM: head-common.S: use PC-relative insn sequence for __turn_mmu_on
  ARM: head.S: use PC-relative insn sequence for secondary_data
  ARM: head: use PC-relative insn sequence for __smp_alt
  ARM: sleep.S: use PC-relative insn sequence for
    sleep_save_sp/mpidr_hash
  ARM: head.S: use PC-relative insn sequences for __fixup_pv_table
  ARM: head.S: use PC relative insn sequence to calculate PHYS_OFFSET
  ARM: kvm: replace open coded VA->PA calculations with adr_l call
  arm-soc: exynos: replace open coded VA->PA conversions
  arm-soc: mvebu: replace open coded VA->PA conversion
  arm-soc: omap: replace open coded VA->PA calculations
  arm-soc: various: replace open coded VA->PA calculation of pen_release
  arm-soc: shmobile: replace open coded VA->PA calculation
  ARM: l2c: replace open coded VA->PA calculation

 arch/arm/boot/compressed/head.S    | 15 +---
 arch/arm/include/asm/assembler.h   | 70 +++++++++++++++++
 arch/arm/kernel/head-common.S      | 22 ++----
 arch/arm/kernel/head.S             | 80 +++++---------------
 arch/arm/kernel/hyp-stub.S         | 33 +++-----
 arch/arm/kernel/sleep.S            | 16 +---
 arch/arm/kvm/init.S                |  8 +-
 arch/arm/mach-exynos/headsmp.S     |  9 +--
 arch/arm/mach-exynos/sleep.S       | 26 ++-----
 arch/arm/mach-mvebu/coherency_ll.S |  8 +-
 arch/arm/mach-omap2/sleep34xx.S    | 21 +----
 arch/arm/mach-omap2/sleep44xx.S    | 12 +--
 arch/arm/mach-prima2/headsmp.S     | 11 +--
 arch/arm/mach-shmobile/headsmp.S   | 14 +---
 arch/arm/mach-spear/headsmp.S      | 11 +--
 arch/arm/mach-sti/headsmp.S        | 10 +--
 arch/arm/mm/l2c-l2x0-resume.S      |  7 +-
 arch/arm/plat-versatile/headsmp.S  |  9 +--
 18 files changed, 140 insertions(+)

-- 
2.11.0

   text	   data	    bss	    dec	    hex  filename
    240	      0	      0	    240	     f0  linux-arm-build/arch/arm/lib/div64.o
   1608	      0	      0	   1608	    648  linux-arm-build/arch/arm/lib/copy_to_user.o
    892	      0	      0	    892	    37c  linux-arm-build/arch/arm/lib/csumpartialcopy.o
    288	      0	      0	    288	    120  linux-arm-build/arch/arm/lib/io-writesb.o
     28	      0	      0	     28	     1c  linux-arm-build/arch/arm/lib/ashldi3.o
    104	      0	      0	    104	     68  linux-arm-build/arch/arm/lib/testclearbit.o
     44	      0	      0	     44	     2c  linux-arm-build/arch/arm/lib/ucmpdi2.o
    204	      0	      0	    204	     cc  linux-arm-build/arch/arm/lib/io-writesw-armv4.o
     52	      0	      0	     52	     34  linux-arm-build/arch/arm/lib/csumipv6.o
    900	      0	      0	    900	    384  linux-arm-build/arch/arm/lib/memmove.o
    764	      0	      0	    764	    2fc  linux-arm-build/arch/arm/lib/lib1funcs.o
     68	      0	      0	     68	     44  linux-arm-build/arch/arm/lib/changebit.o
    104	      0	      0	    104	     68  linux-arm-build/arch/arm/lib/testsetbit.o
    188	      0	      0	    188	     bc  linux-arm-build/arch/arm/lib/io-readsl.o
   1476	      0	      0	   1476	    5c4  linux-arm-build/arch/arm/lib/csumpartialcopyuser.o
     12	      0	      0	     12	      c  linux-arm-build/arch/arm/lib/bswapsdi2.o
     48	      0	      0	     48	     30  linux-arm-build/arch/arm/lib/delay-loop.o
    144	      0	      0	    144	     90  linux-arm-build/arch/arm/lib/putuser.o
     28	      0	      0	     28	     1c  linux-arm-build/arch/arm/lib/ashrdi3.o
    172	      0	      0	    172	     ac  linux-arm-build/arch/arm/lib/findbit.o
   1616	      0	      0	   1616	    650  linux-arm-build/arch/arm/lib/copy_from_user.o
    148	      0	      0	    148	     94  linux-arm-build/arch/arm/lib/getuser.o
    212	      0	      0	    212	     d4  linux-arm-build/arch/arm/lib/clear_user.o
    228	      0	      0	    228	     e4  linux-arm-build/arch/arm/lib/io-readsw-armv4.o
    176	      0	      0	    176	     b0  linux-arm-build/arch/arm/lib/memzero.o
      4	      0	      0	      4	      4  linux-arm-build/arch/arm/lib/backtrace.o
    104	      0	      0	    104	     68  linux-arm-build/arch/arm/lib/testchangebit.o
    232	      0	      0	    232	     e8  linux-arm-build/arch/arm/lib/csumpartial.o
     28	      0	      0	     28	     1c  linux-arm-build/arch/arm/lib/strrchr.o
    184	      0	      0	    184	     b8  linux-arm-build/arch/arm/lib/memset.o
     68	      0	      0	     68	     44  linux-arm-build/arch/arm/lib/setbit.o
     32	      0	      0	     32	     20  linux-arm-build/arch/arm/lib/strchr.o
     60	      0	      0	     60	     3c  linux-arm-build/arch/arm/lib/muldi3.o
     24	      0	      0	     24	     18  linux-arm-build/arch/arm/lib/memchr.o
    320	      0	      0	    320	    140  linux-arm-build/arch/arm/lib/io-readsb.o
     28	      0	      0	     28	     1c  linux-arm-build/arch/arm/lib/lshrdi3.o
     32	      0	      0	     32	     20  linux-arm-build/arch/arm/lib/call_with_stack.o
    112	      0	      0	    112	     70  linux-arm-build/arch/arm/lib/copy_page.o
    156	      0	      0	    156	     9c  linux-arm-build/arch/arm/lib/io-writesl.o
     68	      0	      0	     68	     44  linux-arm-build/arch/arm/lib/clearbit.o
    884	      0	      0	    884	    374  linux-arm-build/arch/arm/lib/memcpy.o
    104	      0	      0	    104	     68  linux-arm-build/arch/arm/common/vlock.o
    280	      0	    260	    540	    21c  linux-arm-build/arch/arm/common/mcpm_head.o
   2760	      0	   4096	   6856	   1ac8  linux-arm-build/arch/arm/boot/compressed/head.o
7324164	      0	      0	7324164	 6fc204  linux-arm-build/arch/arm/boot/compressed/piggy.o
      4	      0	      0	      4	      4  linux-arm-build/arch/arm/mach-berlin/headsmp.o
    116	      0	    192	    308	    134  linux-arm-build/arch/arm/mach-shmobile/headsmp.o
     32	      0	      0	     32	     20  linux-arm-build/arch/arm/mach-shmobile/headsmp-scu.o
     16	      0	      0	     16	     10  linux-arm-build/arch/arm/mach-exynos/exynos-smc.o
    168	      8	      0	    176	     b0  linux-arm-build/arch/arm/mach-exynos/sleep.o
     28	      0	      0	     28	     1c  linux-arm-build/arch/arm/mach-exynos/headsmp.o
     12	      0	      0	     12	      c  linux-arm-build/arch/arm/mach-keystone/smc.o
    676	      0	      0	    676	    2a4  linux-arm-build/arch/arm/mach-at91/pm_suspend.o
      8	      0	      0	      8	      8  linux-arm-build/arch/arm/mach-zynq/headsmp.o
     20	      0	      0	     20	     14  linux-arm-build/arch/arm/mach-highbank/smc.o
      0	     64	      0	     64	     40  linux-arm-build/arch/arm/mach-rockchip/sleep.o
      8	      0	      0	      8	      8  linux-arm-build/arch/arm/mach-rockchip/headsmp.o
     24	      0	      0	     24	     18  linux-arm-build/arch/arm/mm/abort-ev7.o
    792	     44	      0	    836	    344  linux-arm-build/arch/arm/mm/cache-v7.o
   1672	    192	     28	   1892	    764  linux-arm-build/arch/arm/mm/proc-v7.o
    140	      0	      0	    140	     8c  linux-arm-build/arch/arm/mm/tlb-v7.o
     12	      0	      0	     12	      c  linux-arm-build/arch/arm/mm/pabort-v7.o
     88	      0	      0	     88	     58  linux-arm-build/arch/arm/mm/l2c-l2x0-resume.o
     28	      0	      0	     28	     1c  linux-arm-build/arch/arm/mach-sti/headsmp.o
    164	      0	      0	    164	     a4  linux-arm-build/arch/arm/mach-imx/suspend-imx53.o
    648	      0	      0	    648	    288  linux-arm-build/arch/arm/mach-imx/suspend-imx6.o
     24	      0	      0	     24	     18  linux-arm-build/arch/arm/mach-imx/headsmp.o
    148	      0	      0	    148	     94  linux-arm-build/arch/arm/mach-omap2/omap-smc.o
    148	      0	      0	    148	     94  linux-arm-build/arch/arm/mach-omap2/omap-headsmp.o
    864	    124	      0	    988	    3dc  linux-arm-build/arch/arm/mach-omap2/sleep34xx.o
    748	     12	      0	    760	    2f8  linux-arm-build/arch/arm/mach-omap2/sleep44xx.o
     28	      0	      0	     28	     1c  linux-arm-build/arch/arm/plat-versatile/headsmp.o
   1156	      0	      0	   1156	    484  linux-arm-build/arch/arm/mach-tegra/sleep-tegra20.o
    640	      0	      0	    640	    280  linux-arm-build/arch/arm/mach-tegra/reset-handler.o
   2308	      0	      0	   2308	    904  linux-arm-build/arch/arm/mach-tegra/sleep-tegra30.o
    284	      0	      0	    284	    11c  linux-arm-build/arch/arm/mach-tegra/sleep.o
     76	      0	      0	     76	     4c  linux-arm-build/arch/arm/mach-mvebu/pmsu_ll.o
    192	      0	      0	    192	     c0  linux-arm-build/arch/arm/mach-mvebu/coherency_ll.o
      8	      0	      0	      8	      8  linux-arm-build/arch/arm/mach-mvebu/headsmp-a9.o
     12	      0	      0	     12	      c  linux-arm-build/arch/arm/mach-mvebu/headsmp.o
     32	      0	      0	     32	     20  linux-arm-build/arch/arm/mach-socfpga/headsmp.o
     40	      0	      0	     40	     28  linux-arm-build/arch/arm/mach-spear/headsmp.o
    100	      0	      0	    100	     64  linux-arm-build/arch/arm/mach-prima2/sleep.o
     28	      0	      0	     28	     1c  linux-arm-build/arch/arm/mach-prima2/headsmp.o
     24	      0	      0	     24	     18  linux-arm-build/arch/arm/vdso/datapage.o
      0	   4096	      0	   4096	   1000  linux-arm-build/arch/arm/vdso/vdso.o
     36	      0	      0	     36	     24  linux-arm-build/arch/arm/vfp/entry.o
   1296	      0	      0	   1296	    510  linux-arm-build/arch/arm/vfp/vfphw.o
    356	      4	      0	    360	    168  linux-arm-build/arch/arm/kernel/hyp-stub.o
   1096	     16	      0	   1112	    458  linux-arm-build/arch/arm/kernel/head.o
   3308	     12	      0	   3320	    cf8  linux-arm-build/arch/arm/kernel/entry-armv.o
    644	      4	      0	    648	    288  linux-arm-build/arch/arm/kernel/iwmmxt.o
     28	      0	      0	     28	     1c  linux-arm-build/arch/arm/kernel/sigreturn_codes.o
   2148	      0	      0	   2148	    864  linux-arm-build/arch/arm/kernel/entry-common.o
     64	      0	      0	     64	     40  linux-arm-build/arch/arm/kernel/smccc-call.o
    328	      8	      0	    336	    150  linux-arm-build/arch/arm/kernel/sleep.o
    104	      0	      0	    104	     68  linux-arm-build/arch/arm/kernel/relocate_kernel.o
