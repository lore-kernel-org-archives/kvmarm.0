Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 609E714A619
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 13:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777641329; cv=none; b=B862M7cY6MSmC0T3b7ma/IsSMdZeceKwXs40KahhI1rkvp569Rlewo+SzjxA5t72QdDD1fBnffU5XRdYHQ+kMg56d65bhWU3nJFjvsnPb91gIibXNarg1uEW4RFpBpuUiVEfLz5Pp8E1T9j8jv5QQUKNz8g4+dvuOM1m9pxHmXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777641329; c=relaxed/simple;
	bh=rtObenOdQ8wqhsp4Fy1heo+C47dsP6ZRiDQgq9YzCbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fnsrHXEZjOJzqqKaogW/CH7dU05F3QDvaeWWlxtG3+doqPU3ACfwQZQzZQEdm+zfNlaE69IYeEQWUZVAZnGCNR2HCSuQv2ypWoshetVul0uFGBCCHDowuGf2VK5FmsRGDAWUrjFOfYLE0a/dcqulUofTJTRGMJMHdJLbYZiVcmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=X0qfOId7; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="X0qfOId7"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 68229176A;
	Fri,  1 May 2026 06:15:21 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AC1E83F62B;
	Fri,  1 May 2026 06:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777641326; bh=rtObenOdQ8wqhsp4Fy1heo+C47dsP6ZRiDQgq9YzCbc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X0qfOId7Bi5ntpNSoWqPYR5zTb26315+ZlOu3XYlWZKlzACsSssvI/WEmYbJtg2ta
	 DVX3+c4G0IOwtOZ0EXqgEQqb9mSrDxvxteyvXD3TlJg4sdRP2j8VMSPBMJ2lNPv9PS
	 /mQWZHYkqYnC+0xEEtP8eUh0+1yI/Mbfyy7KLzTE=
Date: Fri, 1 May 2026 14:15:14 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, Andrew Jones <andrew.jones@linux.dev>,
	Eric Auger <eric.auger@redhat.com>,
	"open list:ARM" <kvmarm@lists.linux.dev>,
	"open list:Default mailing list" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH] arm: add wfx test case
Message-ID: <afSnVJLe7HrB6ISS@raptor>
References: <20260427130045.3669851-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260427130045.3669851-1-alex.bennee@linaro.org>

Hi Alex,

On Mon, Apr 27, 2026 at 02:00:45PM +0100, Alex Bennée wrote:
> This is based on a similar test case I wrote for QEMU's tcg tests although
> obviously able to take advantage of kvm-unit-tests additional plumbing for
> dealing with the GIC and IRQs.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  arm/Makefile.arm64        |   1 +
>  lib/arm64/asm/processor.h |   7 ++
>  lib/arm64/asm/sysreg.h    |   3 +
>  arm/wfx.c                 | 137 ++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg         |   5 ++
>  5 files changed, 153 insertions(+)
>  create mode 100644 arm/wfx.c
> 
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index a40c830d..52b3f35d 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -64,6 +64,7 @@ tests += $(TEST_DIR)/cache.$(exe)
>  tests += $(TEST_DIR)/debug.$(exe)
>  tests += $(TEST_DIR)/fpu.$(exe)
>  tests += $(TEST_DIR)/mte.$(exe)
> +tests += $(TEST_DIR)/wfx.$(exe)
>  
>  include $(SRCDIR)/$(TEST_DIR)/Makefile.common
>  
> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> index 32ddc1b3..2104036d 100644
> --- a/lib/arm64/asm/processor.h
> +++ b/lib/arm64/asm/processor.h
> @@ -173,5 +173,12 @@ static inline bool system_supports_rndr(void)
>  	return ((id_aa64isar0_el1 >> ID_AA64ISAR0_EL1_RNDR_SHIFT) & 0xf) != 0;
>  }
>  
> +static inline bool system_supports_wfxt(void)
> +{
> +	u64 id_aa64isar2_el1 = read_sysreg_s(ID_AA64ISAR2_EL1);
> +
> +	return ((id_aa64isar2_el1 >> ID_AA64ISAR2_EL1_WFxT_SHIFT) & 0xf) != 0;
> +}
> +
>  #endif /* !__ASSEMBLER__ */
>  #endif /* _ASMARM64_PROCESSOR_H_ */
> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
> index f2d05018..cb96a649 100644
> --- a/lib/arm64/asm/sysreg.h
> +++ b/lib/arm64/asm/sysreg.h
> @@ -77,6 +77,9 @@ asm(
>  #define ID_AA64ISAR0_EL1_RNDR_SHIFT	60
>  #define ID_AA64PFR1_EL1_MTE_SHIFT	8
>  
> +#define ID_AA64ISAR2_EL1		sys_reg(3, 0, 0, 6, 2)
> +#define ID_AA64ISAR2_EL1_WFxT_SHIFT	0
> +
>  #define ID_AA64MMFR0_EL1_FGT_SHIFT	56
>  #define ID_AA64MMFR0_EL1_FGT_FGT2	0x2
>  
> diff --git a/arm/wfx.c b/arm/wfx.c
> new file mode 100644
> index 00000000..912e50e6
> --- /dev/null
> +++ b/arm/wfx.c
> @@ -0,0 +1,137 @@
> +/*
> + * WFX Instructions Test (WFI, WFE, WFIT, WFET)
> + *
> + * Copyright (c) 2026 Linaro Ltd
> + *
> + * SPDX-License-Identifier: GPL-2.0-or-later
> + */
> +
> +#include <libcflat.h>
> +#include <asm/processor.h>
> +#include <asm/gic.h>
> +#include <asm/timer.h>
> +#include <asm/io.h>
> +
> +#define TIMEOUT 200000
> +
> +#define sev() asm volatile("sev" : : : "memory")
> +#define sevl() asm volatile("sevl" : : : "memory")
> +#define wfi() asm volatile("wfi" : : : "memory")
> +#define wfe() asm volatile("wfe" : : : "memory")
> +
> +#define wfit(reg) \
> +	asm volatile(".arch armv8.7-a\n\twfit %0" : : "r" (reg) : "memory")
> +#define wfet(reg) \
> +	asm volatile(".arch armv8.7-a\n\twfet %0" : : "r" (reg) : "memory")
> +
> +static void timer_handler(struct pt_regs *regs)
> +{
> +	/* Disable timer to stop IRQ from re-firing */
> +	write_sysreg(0, cntv_ctl_el0);
> +}

It is customary for the interrupt handler to ack the interrupt at the GIC level.

> +
> +static bool check_elapsed(uint64_t start, uint64_t threshold, const char *test, bool more)
> +{
> +	uint64_t end = read_sysreg(cntvct_el0);
> +	uint64_t elapsed = end - start;
> +	bool pass = more ? elapsed >= threshold : elapsed <= threshold;
> +
> +	report(pass, "%s (%ld ticks)", test, elapsed);
> +
> +	if (!pass) {
> +		report_info("%s %s", test, more ? "woke too early" : "slept despite SEV");
> +	}
> +	return pass;
> +}
> +
> +static void test_wfi(void)
> +{
> +	uint64_t start;
> +
> +	report_info("Testing WFI...");
> +
> +	start = read_sysreg(cntvct_el0);
> +	write_sysreg(TIMEOUT, cntv_tval_el0);
> +	write_sysreg(1, cntv_ctl_el0); /* Enable timer, no mask */
> +	isb();
> +
> +	local_irq_enable();
> +	wfi();

Consider this scenario:

	local_irq_enable();
	// CPU takes the interrupt, handles it and returns.
	wfi(); <- CPU now waits forever for an interrupt that will never come

The proper way to do it on baremetal would be:

	local_irq_disable();
	// Program timer to fire
	wfi();
	// Timer fires, GIC asserts the interrupt, WFI completes
	local_irq_enable();
	// CPU handles the interrupt
	check_elapsed(..)

But this is not baremetal. KVM can decide not to trap WFI (look at
arch/arm64/kvm/arm.c::kvm_arch_vcpu_load() -> kvm_vpcu_should_clear_twi()). In
that case, the WFI might complete due a host interrupt, and check_elapsed() will
fail because the timer hasn't yet fired.

> +	local_irq_disable();
> +
> +	check_elapsed(start, TIMEOUT, "WFI", true);
> +}
> +
> +static void test_wfe(void)
> +{
> +	uint64_t start;
> +
> +	report_info("Testing WFE/SEV...");
> +	sev();
> +	start = read_sysreg(cntvct_el0);
> +	wfe();
> +	check_elapsed(start, TIMEOUT, "WFE/SEV", false);
> +
> +	report_info("Testing WFE/SEVL...");
> +	sevl();
> +	start = read_sysreg(cntvct_el0);
> +	wfe();
> +	check_elapsed(start, TIMEOUT, "WFE/SEVL", false);
> +}

I haven't thought about this too much, but it looks to me like the same
situation with WFI can happen with WFE

Also, kvm-unit-tests() makes use of WFE and SEV for multithreading, and the fact
that multithreaded tests work at all might be taken as proof enough that the two
instructions are correctly implemented.

Thanks,
Alex

> +
> +static void test_wfit(void)
> +{
> +	uint64_t start, timeout;
> +
> +	report_info("Testing WFIT...");
> +	start = read_sysreg(cntvct_el0);
> +	timeout = start + TIMEOUT;
> +	wfit(timeout);
> +	check_elapsed(start, TIMEOUT, "WFIT", true);
> +}
> +
> +static void test_wfet(void)
> +{
> +	uint64_t start, timeout;
> +
> +	report_info("Testing WFET...");
> +	/* Ensure no pending events */
> +	sev();
> +	wfe();
> +
> +	start = read_sysreg(cntvct_el0);
> +	timeout = start + TIMEOUT;
> +	wfet(timeout);
> +	check_elapsed(start, TIMEOUT, "WFET", true);
> +}
> +
> +int main(void)
> +{
> +
> +	if (gic_init() < 0) {
> +		report_abort("GIC init failed");
> +		return 1;
> +	}
> +
> +	/* Install timer handler for WFI wake-up */
> +	install_irq_handler(EL1H_IRQ, timer_handler);
> +	gic_enable_defaults();
> +
> +	/* Enable Virtual Timer PPI */
> +	gic_irq_set_clr_enable(27, true);
> +
> +	report_prefix_push("WFx");
> +	test_wfi();
> +	test_wfe();
> +	report_prefix_pop();
> +
> +	if (system_supports_wfxt()) {
> +		report_prefix_push("WFxT");
> +		test_wfit();
> +		test_wfet();
> +	} else {
> +		report_skip("WFxT instructions not supported");
> +	}
> +
> +	return report_summary();
> +}
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index 12fc4468..7adf96f2 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -339,3 +339,8 @@ groups = mte
>  test_args = asymm
>  qemu_params = -machine mte=on
>  arch = arm64
> +
> +[wfx]
> +file = wfx.flat
> +groups = wfx
> +arch = arm64
> -- 
> 2.47.3
> 
