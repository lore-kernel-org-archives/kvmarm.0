Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F183344CF54
	for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 13:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777382828; cv=none; b=kvPKx24atNWUIhRUae7qZepQRL0zqUSnxratq8KNJ1pzJAW4Kd6ISyKfTY49/DFuMoTsT30iiU3rXzyuYxw+d+DQIld3vNd7w5ubgvby4T8BjcHAbF72rx2D7/j/dBttwoe7A5dDuF40z+tr0SN+c1xBi7KdhidU6AwOAFgcqBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777382828; c=relaxed/simple;
	bh=IyapETfcrA5bdzogS0BMgrPXC9c/KLCTS2PzVSSlXMo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R2d1OEnh4Ml2oHiLbHrKq7BONr357MW8/QeaVTR4mLgtMiMqZMM84q+b8kvMP6DT196x5zOsPrvuNsYYXrWsUpLvBNClHsVeAmVhMSfDswCBfAHQOdjOpqd1+mYnCd9dSeS/Hw7qfvuYXeZ39+DGQuh0l8xYPUWR3c6wNJRdciQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cMe7uZnX; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cMe7uZnX"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E2C0B497;
	Tue, 28 Apr 2026 06:27:00 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0B23B3F62B;
	Tue, 28 Apr 2026 06:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777382826; bh=IyapETfcrA5bdzogS0BMgrPXC9c/KLCTS2PzVSSlXMo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cMe7uZnXRS3E8eiaXBZbf/31/9iUxv+ImqQ6FjohOPE8MehQgU634Hpr6XSuDjIpo
	 igQNg12C5u3+RpzYi2ngwf9eqHo5924XcBQ1KN36+NNo3TPokhBaVJEBqBumQzpe0i
	 U/xwFwL5j/3UvcdUvyenH7P8iTzIyRS4oF2HdjvE=
Date: Tue, 28 Apr 2026 14:26:57 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, Andrew Jones <andrew.jones@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	"open list:ARM" <kvmarm@lists.linux.dev>,
	"open list:Default mailing list" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH] arm: add wfx test case
Message-ID: <20260428132657.GA591628@e124191.cambridge.arm.com>
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

Hi,

Few small comments.

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

Instead of a hardcoded TIMEOUT, what about something similar to arm/timer.c:

	u64 time_10ms = read_sysreg(cntfrq_el0) / 100;

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
> +	local_irq_disable();
> +
> +	check_elapsed(start, TIMEOUT, "WFI", true);
> +}
> +
> +static void test_wfe(void)
> +{
> +	uint64_t start;
> +

I think a comment here would be good, just to say it's testing that a wfe
doesn't sleep for a 'long' period with no pending events, or something like
that?

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

Could this just be sevl here? Not that it really matters.

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

Instead of hardcoding 27 here, you can use:

	u32 irq = current_level() == CurrentEL_EL1 ? TIMER_VTIMER_IRQ : TIMER_HVTIMER_IRQ;                                                                     
	gic_irq_set_clr_enable(irq, true);

Which also allows the test to run at EL2.

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

Thanks,
Joey
