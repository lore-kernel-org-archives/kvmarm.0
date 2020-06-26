Return-Path: <SRS0=8LgP=AH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C718C433E1
	for <kvmarm@archiver.kernel.org>; Fri, 26 Jun 2020 09:41:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1E46D21532
	for <kvmarm@archiver.kernel.org>; Fri, 26 Jun 2020 09:41:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E46D21532
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FD234B18C;
	Fri, 26 Jun 2020 05:41:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id voo3xLa2pW3G; Fri, 26 Jun 2020 05:41:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9956E4B166;
	Fri, 26 Jun 2020 05:41:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 537914B147
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jun 2020 05:41:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WpYo4JsGW-v6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Jun 2020 05:41:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A9DC4A551
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jun 2020 05:41:00 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 004CB1FB;
 Fri, 26 Jun 2020 02:41:00 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 49D623F71E;
 Fri, 26 Jun 2020 02:40:58 -0700 (PDT)
Subject: Re: [PATCH 2/2] irqchip/gic-v3: Support pseudo-NMIs when SCR_EL3.FIQ
 == 0
To: kernel test robot <lkp@intel.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20200625150026.867727-3-alexandru.elisei@arm.com>
 <202006260902.snscFOg0%lkp@intel.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <31059bad-54e1-58a7-6531-14e473950bc9@arm.com>
Date: Fri, 26 Jun 2020 10:41:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <202006260902.snscFOg0%lkp@intel.com>
Content-Language: en-US
Cc: kbuild-all@lists.01.org, jason@lakedaemon.net, maz@kernel.org,
 clang-built-linux@googlegroups.com, catalin.marinas@arm.com,
 tglx@linutronix.de, will@kernel.org
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

Hi,

On 6/26/20 2:51 AM, kernel test robot wrote:
> Hi Alexandru,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on arm64/for-next/core]
> [also build test WARNING on tip/irq/core v5.8-rc2 next-20200625]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use  as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/Alexandru-Elisei/irqchip-gic-v3-Support-pseudo-NMIs-when-SCR_EL3-FIQ-0/20200625-230144
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/core
> config: arm64-randconfig-r025-20200624 (attached as .config)
> compiler: clang version 11.0.0 (https://github.com/llvm/llvm-project 8911a35180c6777188fefe0954a2451a2b91deaf)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install arm64 cross compiling tool for clang build
>         # apt-get install binutils-aarch64-linux-gnu
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=arm64 

My mistake, I'll start compiling the kernel with clang too.

The register width for ICC_PMR_EL1 in the kernel is rather inconsistent: in
arch_gicv3.h, the accessors use 32 bits for the PMR value which gets casted to 64
bit by the {read,write}_sysreg_s macros anyway, in struct pt_regs the register is
64-bit, in __cpu_do_idle_irqprio it's declared as an unsigned long,
arch_local_irqs_{disable,enable} declares it as u32 and casts it to an unsigned
long when used by the inline assembly, the gicv3 irqchip driver uses it as a 32
bit variable.

I think the confusion stems from the fact that originally it was a 32 bit
register, but was changed to 64 bits in Arm IHI 0069E (January 2019).

I could cast it to an unsigned long in the inline assembly, but IMO that looks a
bit awkward. Before sending the patches I was considering changing it everywhere
to 64 bits, but Mark Rutland had a different idea. Mark, would you mind explaining
why keeping it 32 bit wide makes more sense?

Thanks,
Alex
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>    In file included from arch/arm64/kernel/asm-offsets.c:10:
>    In file included from include/linux/arm_sdei.h:8:
>    In file included from include/acpi/ghes.h:5:
>    In file included from include/acpi/apei.h:9:
>    In file included from include/linux/acpi.h:13:
>    In file included from include/linux/irqdomain.h:35:
>    In file included from include/linux/of.h:17:
>    In file included from include/linux/kobject.h:20:
>    In file included from include/linux/sysfs.h:16:
>    In file included from include/linux/kernfs.h:13:
>    In file included from include/linux/idr.h:15:
>    In file included from include/linux/radix-tree.h:15:
>    In file included from include/linux/rcupdate.h:26:
>    In file included from include/linux/irqflags.h:16:
>>> arch/arm64/include/asm/irqflags.h:45:10: warning: value size does not match register size specified by the constraint and modifier [-Wasm-operand-widths]
>                    : "r" (pmr_irqon)
>                           ^
>    arch/arm64/include/asm/irqflags.h:42:29: note: use constraint modifier "w"
>                    __msr_s(SYS_ICC_PMR_EL1, "%0"),
>                                              ^
>    arch/arm64/include/asm/irqflags.h:67:10: warning: value size does not match register size specified by the constraint and modifier [-Wasm-operand-widths]
>                    : "r" (pmr_irqoff)
>                           ^
>    arch/arm64/include/asm/irqflags.h:64:29: note: use constraint modifier "w"
>                    __msr_s(SYS_ICC_PMR_EL1, "%0"),
>                                              ^
>    2 warnings generated.
> --
>    In file included from drivers/power/supply/ltc2941-battery-gauge.c:12:
>    In file included from include/linux/module.h:13:
>    In file included from include/linux/stat.h:6:
>    In file included from arch/arm64/include/asm/stat.h:12:
>    In file included from include/linux/time.h:6:
>    In file included from include/linux/seqlock.h:36:
>    In file included from include/linux/spinlock.h:54:
>    In file included from include/linux/irqflags.h:16:
>>> arch/arm64/include/asm/irqflags.h:45:10: warning: value size does not match register size specified by the constraint and modifier [-Wasm-operand-widths]
>                    : "r" (pmr_irqon)
>                           ^
>    arch/arm64/include/asm/irqflags.h:42:29: note: use constraint modifier "w"
>                    __msr_s(SYS_ICC_PMR_EL1, "%0"),
>                                              ^
>    arch/arm64/include/asm/irqflags.h:67:10: warning: value size does not match register size specified by the constraint and modifier [-Wasm-operand-widths]
>                    : "r" (pmr_irqoff)
>                           ^
>    arch/arm64/include/asm/irqflags.h:64:29: note: use constraint modifier "w"
>                    __msr_s(SYS_ICC_PMR_EL1, "%0"),
>                                              ^
>    drivers/power/supply/ltc2941-battery-gauge.c:476:13: warning: cast to smaller integer type 'enum ltc294x_id' from 'const void *' [-Wvoid-pointer-to-enum-cast]
>            info->id = (enum ltc294x_id)of_device_get_match_data(&client->dev);
>                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    3 warnings generated.
> --
>    In file included from drivers/power/supply/goldfish_battery.c:11:
>    In file included from include/linux/module.h:13:
>    In file included from include/linux/stat.h:6:
>    In file included from arch/arm64/include/asm/stat.h:12:
>    In file included from include/linux/time.h:6:
>    In file included from include/linux/seqlock.h:36:
>    In file included from include/linux/spinlock.h:54:
>    In file included from include/linux/irqflags.h:16:
>>> arch/arm64/include/asm/irqflags.h:45:10: warning: value size does not match register size specified by the constraint and modifier [-Wasm-operand-widths]
>                    : "r" (pmr_irqon)
>                           ^
>    arch/arm64/include/asm/irqflags.h:42:29: note: use constraint modifier "w"
>                    __msr_s(SYS_ICC_PMR_EL1, "%0"),
>                                              ^
>    arch/arm64/include/asm/irqflags.h:67:10: warning: value size does not match register size specified by the constraint and modifier [-Wasm-operand-widths]
>                    : "r" (pmr_irqoff)
>                           ^
>    arch/arm64/include/asm/irqflags.h:64:29: note: use constraint modifier "w"
>                    __msr_s(SYS_ICC_PMR_EL1, "%0"),
>                                              ^
>    drivers/power/supply/goldfish_battery.c:269:36: warning: unused variable 'goldfish_battery_acpi_match' [-Wunused-const-variable]
>    static const struct acpi_device_id goldfish_battery_acpi_match[] = {
>                                       ^
>    3 warnings generated.
> --
>    In file included from drivers/power/supply/bq25890_charger.c:8:
>    In file included from include/linux/module.h:13:
>    In file included from include/linux/stat.h:6:
>    In file included from arch/arm64/include/asm/stat.h:12:
>    In file included from include/linux/time.h:6:
>    In file included from include/linux/seqlock.h:36:
>    In file included from include/linux/spinlock.h:54:
>    In file included from include/linux/irqflags.h:16:
>>> arch/arm64/include/asm/irqflags.h:45:10: warning: value size does not match register size specified by the constraint and modifier [-Wasm-operand-widths]
>                    : "r" (pmr_irqon)
>                           ^
>    arch/arm64/include/asm/irqflags.h:42:29: note: use constraint modifier "w"
>                    __msr_s(SYS_ICC_PMR_EL1, "%0"),
>                                              ^
>    arch/arm64/include/asm/irqflags.h:67:10: warning: value size does not match register size specified by the constraint and modifier [-Wasm-operand-widths]
>                    : "r" (pmr_irqoff)
>                           ^
>    arch/arm64/include/asm/irqflags.h:64:29: note: use constraint modifier "w"
>                    __msr_s(SYS_ICC_PMR_EL1, "%0"),
>                                              ^
>    drivers/power/supply/bq25890_charger.c:1060:36: warning: unused variable 'bq25890_acpi_match' [-Wunused-const-variable]
>    static const struct acpi_device_id bq25890_acpi_match[] = {
>                                       ^
>    3 warnings generated.
> --
>    In file included from drivers/power/reset/vexpress-poweroff.c:8:
>    In file included from include/linux/notifier.h:15:
>    In file included from include/linux/rwsem.h:16:
>    In file included from include/linux/spinlock.h:54:
>    In file included from include/linux/irqflags.h:16:
>>> arch/arm64/include/asm/irqflags.h:45:10: warning: value size does not match register size specified by the constraint and modifier [-Wasm-operand-widths]
>                    : "r" (pmr_irqon)
>                           ^
>    arch/arm64/include/asm/irqflags.h:42:29: note: use constraint modifier "w"
>                    __msr_s(SYS_ICC_PMR_EL1, "%0"),
>                                              ^
>    arch/arm64/include/asm/irqflags.h:67:10: warning: value size does not match register size specified by the constraint and modifier [-Wasm-operand-widths]
>                    : "r" (pmr_irqoff)
>                           ^
>    arch/arm64/include/asm/irqflags.h:64:29: note: use constraint modifier "w"
>                    __msr_s(SYS_ICC_PMR_EL1, "%0"),
>                                              ^
>    drivers/power/reset/vexpress-poweroff.c:124:10: warning: cast to smaller integer type 'enum vexpress_reset_func' from 'const void *' [-Wvoid-pointer-to-enum-cast]
>            switch ((enum vexpress_reset_func)match->data) {
>                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    3 warnings generated.
> --
>    In file included from arch/arm64/kernel/asm-offsets.c:10:
>    In file included from include/linux/arm_sdei.h:8:
>    In file included from include/acpi/ghes.h:5:
>    In file included from include/acpi/apei.h:9:
>    In file included from include/linux/acpi.h:13:
>    In file included from include/linux/irqdomain.h:35:
>    In file included from include/linux/of.h:17:
>    In file included from include/linux/kobject.h:20:
>    In file included from include/linux/sysfs.h:16:
>    In file included from include/linux/kernfs.h:13:
>    In file included from include/linux/idr.h:15:
>    In file included from include/linux/radix-tree.h:15:
>    In file included from include/linux/rcupdate.h:26:
>    In file included from include/linux/irqflags.h:16:
>>> arch/arm64/include/asm/irqflags.h:45:10: warning: value size does not match register size specified by the constraint and modifier [-Wasm-operand-widths]
>                    : "r" (pmr_irqon)
>                           ^
>    arch/arm64/include/asm/irqflags.h:42:29: note: use constraint modifier "w"
>                    __msr_s(SYS_ICC_PMR_EL1, "%0"),
>                                              ^
>    arch/arm64/include/asm/irqflags.h:67:10: warning: value size does not match register size specified by the constraint and modifier [-Wasm-operand-widths]
>                    : "r" (pmr_irqoff)
>                           ^
>    arch/arm64/include/asm/irqflags.h:64:29: note: use constraint modifier "w"
>                    __msr_s(SYS_ICC_PMR_EL1, "%0"),
>                                              ^
>    2 warnings generated.
>    arch/arm64/kernel/vdso/vgettimeofday.c:9:5: warning: no previous prototype for function '__kernel_clock_gettime' [-Wmissing-prototypes]
>    int __kernel_clock_gettime(clockid_t clock,
>        ^
>    arch/arm64/kernel/vdso/vgettimeofday.c:9:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
>    int __kernel_clock_gettime(clockid_t clock,
>    ^
>    static 
>    arch/arm64/kernel/vdso/vgettimeofday.c:15:5: warning: no previous prototype for function '__kernel_gettimeofday' [-Wmissing-prototypes]
>    int __kernel_gettimeofday(struct __kernel_old_timeval *tv,
>        ^
>    arch/arm64/kernel/vdso/vgettimeofday.c:15:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
>    int __kernel_gettimeofday(struct __kernel_old_timeval *tv,
>    ^
>    static 
>    arch/arm64/kernel/vdso/vgettimeofday.c:21:5: warning: no previous prototype for function '__kernel_clock_getres' [-Wmissing-prototypes]
>    int __kernel_clock_getres(clockid_t clock_id,
>        ^
>    arch/arm64/kernel/vdso/vgettimeofday.c:21:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
>    int __kernel_clock_getres(clockid_t clock_id,
>    ^
>    static 
>    3 warnings generated.
>
> vim +45 arch/arm64/include/asm/irqflags.h
>
>     12	
>     13	/*
>     14	 * Aarch64 has flags for masking: Debug, Asynchronous (serror), Interrupts and
>     15	 * FIQ exceptions, in the 'daif' register. We mask and unmask them in 'dai'
>     16	 * order:
>     17	 * Masking debug exceptions causes all other exceptions to be masked too/
>     18	 * Masking SError masks irq, but not debug exceptions. Masking irqs has no
>     19	 * side effects for other flags. Keeping to this order makes it easier for
>     20	 * entry.S to know which exceptions should be unmasked.
>     21	 *
>     22	 * FIQ is never expected, but we mask it when we disable debug exceptions, and
>     23	 * unmask it at all other times.
>     24	 */
>     25	
>     26	/*
>     27	 * CPU interrupt mask handling.
>     28	 */
>     29	static inline void arch_local_irq_enable(void)
>     30	{
>     31		u32 pmr_irqon = GIC_PRIO_IRQON;
>     32	
>     33		if (system_has_prio_mask_debugging()) {
>     34			u32 pmr = read_sysreg_s(SYS_ICC_PMR_EL1);
>     35			u32 pmr_irqoff = gic_prio_irqoff();
>     36	
>     37			WARN_ON_ONCE(pmr != pmr_irqon && pmr != pmr_irqoff);
>     38		}
>     39	
>     40		asm volatile(ALTERNATIVE(
>     41			"msr	daifclr, #2		// arch_local_irq_enable",
>     42			__msr_s(SYS_ICC_PMR_EL1, "%0"),
>     43			ARM64_HAS_IRQ_PRIO_MASKING)
>     44			:
>   > 45			: "r" (pmr_irqon)
>     46			: "memory");
>     47	
>     48		pmr_sync();
>     49	}
>     50	
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
