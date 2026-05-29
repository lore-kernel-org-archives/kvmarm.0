Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 173943A3E90
	for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 14:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780063966; cv=none; b=M4Ms3m/XBXt3v1v8OIqP63Us6W6ZCJ2SVQC79ELOo7LU09Dle1dKthRUvR39bMoAYX0kdirt6lo79wZ64lJHJ3yRx+QlyHYnQGyfgpwJH4YNULFqA5X7oqK8rzFXcaVKYgYgfhW0EIt5AlAYyvrJyAQZFHq+0E4OLxzW7UVDIL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780063966; c=relaxed/simple;
	bh=MVV/jLs3MIsHo/5E7w96SpLAX/S4NGPHkgxwR2bR/Ko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pAeURnBay8TXTdnJ9swHKuk8zWuV2N+OHL0hIDtAa8UsXwIkrmqQNdwbI5+uCkEWZTV3wqhPzH5Hosy9U3Ag2EDKdHb3yKResohkG/d+ZyCMg8Ny/SQMmzkmBTK1UUrj5IYhssmOGzNnwmQjpZ81vOHxFzeAgvpL8+49ZgEX1aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OQrVUh8o; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OQrVUh8o"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 835901516;
	Fri, 29 May 2026 07:12:39 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 768473F905;
	Fri, 29 May 2026 07:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780063964; bh=MVV/jLs3MIsHo/5E7w96SpLAX/S4NGPHkgxwR2bR/Ko=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OQrVUh8oeIs8LKDtlpTqC8vWm9+PI5fa26ZL4T0qm/YwZI1PkOva6d8HKXGfmRkTX
	 wIxnvnZD7tNzUHNAX6GHaALvEuz115URctUT+OMHZSoSNNbzIBh6REmwYDsoicxPuw
	 wpvOzsb3ZYS50kmb6+zwbST6yNd4JU6XYruApTEA=
Date: Fri, 29 May 2026 15:12:32 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, Andrew Jones <andrew.jones@linux.dev>,
	Eric Auger <eric.auger@redhat.com>,
	"open list:ARM" <kvmarm@lists.linux.dev>,
	"open list:Default mailing list" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v2] arm: add wfx test case
Message-ID: <ahme0HOEcQW9Sok-@raptor>
References: <20260527111822.1563679-1-alex.bennee@linaro.org>
 <ahmdci3dLMyaaZn8@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ahmdci3dLMyaaZn8@raptor>

Hi Alex,

On Fri, May 29, 2026 at 03:06:42PM +0100, Alexandru Elisei wrote:
> Hi Alex,
> 
> When I tried to run the test this is what I got:
> 
> $ ./run_tests.sh wfx
> FAIL wfx (5 tests, 1 unexpected failures)
> $ cat logs/wfx.log
> timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64 -nodefaults -machine virt -accel tcg -cpu max -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel arm/wfx.flat -smp 1 # -initrd /tmp/tmp.s0dfiRPbNO
> INFO: WFx: Testing WFI...
> PASS: WFx: WFI (10441943 ticks / 10441 ns)
> INFO: WFx: Testing WFE/SEV...
> PASS: WFx: WFE/SEV (8636 ticks / 8 ns)
> INFO: WFx: Testing WFE/SEVL...
> PASS: WFx: WFE/SEVL (5461 ticks / 5 ns)
> INFO: WFxT: Testing WFIT...
> PASS: WFxT: WFIT (10135025 ticks / 10135 ns)
> INFO: WFxT: Testing WFET...
> FAIL: WFxT: WFET (19391 ticks / 19 ns)
> INFO: WFxT: WFET woke too early
> SUMMARY: 5 tests, 1 unexpected failures
> 
> EXIT: STATUS=3
> 
> $ /usr/bin/qemu-system-aarch64 --version
> QEMU emulator version 11.0.0
> Copyright (c) 2003-2026 Fabrice Bellard and the QEMU Project developers
> 
> Any idea what I might be doing wrong?
> 
> On Wed, May 27, 2026 at 12:18:21PM +0100, Alex Bennée wrote:
> > This is based on a similar test case I wrote for QEMU's tcg tests although
> > obviously able to take advantage of kvm-unit-tests additional plumbing for
> > dealing with the GIC and IRQs.
> > 
> > Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> > 
> > ---
> > v2
> >   - drop TIMEOUT in favour of computed 10ms timeout
> >   - add comments for each test
> >   - use sevl for local clearing
> >   - set gic irc depending on CurrentEL
> >   - EOI the GIC
> >   - display elapsed ns (no float to do ms ;-)
> >   - fix some style issues
> >   - make test TCG only
> > ---
> >  arm/Makefile.arm64        |   1 +
> >  lib/arm64/asm/processor.h |   7 ++
> >  lib/arm64/asm/sysreg.h    |   3 +
> >  arm/wfx.c                 | 187 ++++++++++++++++++++++++++++++++++++++
> >  arm/unittests.cfg         |   7 ++
> >  5 files changed, 205 insertions(+)
> >  create mode 100644 arm/wfx.c
> > 
> > diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> > index a40c830d..52b3f35d 100644
> > --- a/arm/Makefile.arm64
> > +++ b/arm/Makefile.arm64
> > @@ -64,6 +64,7 @@ tests += $(TEST_DIR)/cache.$(exe)
> >  tests += $(TEST_DIR)/debug.$(exe)
> >  tests += $(TEST_DIR)/fpu.$(exe)
> >  tests += $(TEST_DIR)/mte.$(exe)
> > +tests += $(TEST_DIR)/wfx.$(exe)
> >  
> >  include $(SRCDIR)/$(TEST_DIR)/Makefile.common
> >  
> > diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> > index 32ddc1b3..2104036d 100644
> > --- a/lib/arm64/asm/processor.h
> > +++ b/lib/arm64/asm/processor.h
> > @@ -173,5 +173,12 @@ static inline bool system_supports_rndr(void)
> >  	return ((id_aa64isar0_el1 >> ID_AA64ISAR0_EL1_RNDR_SHIFT) & 0xf) != 0;
> >  }
> >  
> > +static inline bool system_supports_wfxt(void)
> > +{
> > +	u64 id_aa64isar2_el1 = read_sysreg_s(ID_AA64ISAR2_EL1);
> > +
> > +	return ((id_aa64isar2_el1 >> ID_AA64ISAR2_EL1_WFxT_SHIFT) & 0xf) != 0;
> > +}
> > +
> >  #endif /* !__ASSEMBLER__ */
> >  #endif /* _ASMARM64_PROCESSOR_H_ */
> > diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
> > index f2d05018..cb96a649 100644
> > --- a/lib/arm64/asm/sysreg.h
> > +++ b/lib/arm64/asm/sysreg.h
> > @@ -77,6 +77,9 @@ asm(
> >  #define ID_AA64ISAR0_EL1_RNDR_SHIFT	60
> >  #define ID_AA64PFR1_EL1_MTE_SHIFT	8
> >  
> > +#define ID_AA64ISAR2_EL1		sys_reg(3, 0, 0, 6, 2)
> > +#define ID_AA64ISAR2_EL1_WFxT_SHIFT	0
> > +
> >  #define ID_AA64MMFR0_EL1_FGT_SHIFT	56
> >  #define ID_AA64MMFR0_EL1_FGT_FGT2	0x2
> >  
> > diff --git a/arm/wfx.c b/arm/wfx.c
> > new file mode 100644
> > index 00000000..0825c5cb
> > --- /dev/null
> > +++ b/arm/wfx.c
> > @@ -0,0 +1,187 @@
> > +/*
> > + * WFX Instructions Test (WFI, WFE, WFIT, WFET)
> > + *
> > + * Copyright (c) 2026 Linaro Ltd
> > + *
> > + * SPDX-License-Identifier: GPL-2.0-or-later
> > + */
> > +
> > +#include <libcflat.h>
> > +#include <asm/processor.h>
> > +#include <asm/gic.h>
> > +#include <asm/timer.h>
> > +#include <asm/io.h>
> > +
> > +#define sev() asm volatile("sev" : : : "memory")
> > +#define sevl() asm volatile("sevl" : : : "memory")
> > +#define wfi() asm volatile("wfi" : : : "memory")
> > +#define wfe() asm volatile("wfe" : : : "memory")
> > +
> > +#define wfit(reg) \
> > +	asm volatile(".arch armv8.7-a\n\twfit %0" : : "r" (reg) : "memory")
> > +#define wfet(reg) \
> > +	asm volatile(".arch armv8.7-a\n\twfet %0" : : "r" (reg) : "memory")
> > +
> > +uint64_t time_hz;
> > +uint64_t time_10ms;
> > +
> > +static void timer_handler(struct pt_regs *regs)
> > +{
> > +	u32 irqstat = gic_read_iar();
> > +	u32 irqnr = gic_iar_irqnr(irqstat);
> > +
> > +	/* Disable timer to stop IRQ from re-firing */
> > +	if (irqnr == TIMER_VTIMER_IRQ || irqnr == TIMER_HVTIMER_IRQ) {
> > +		write_sysreg(0, cntv_ctl_el0);
> > +		isb();
> > +	} else {
> > +		if (irqnr != GICC_INT_SPURIOUS)
> > +			gic_write_eoir(irqstat);
> > +		report_info("Unexpected interrupt: %d\n", irqnr);
> > +		return;
> > +	}
> > +
> > +	/* Also acknowledge EOI for the GIC */
> > +	gic_write_eoir(irqstat);
> > +}
> > +
> > +static bool check_elapsed(uint64_t start, uint64_t threshold, const char *test, bool more)
> > +{
> > +	uint64_t end = read_sysreg(cntvct_el0);
> > +	uint64_t elapsed = end - start;
> > +	bool pass = more ? elapsed >= threshold : elapsed <= threshold;
> > +
> > +	report(pass, "%s (%ld ticks / %ld ns)",
> > +	       test, elapsed, elapsed / (time_hz / 1000000));
> > +
> > +	if (!pass)
> > +		report_info("%s %s", test, more ? "woke too early" : "slept despite SEV");
> > +
> > +	return pass;
> > +}
> > +
> > +/*
> > + * Test WFI with timer interrupt
> > + *
> > + * WFI should wake up when the interrupt is pending. We unmask
> > + * interrupts here so they are taken and then check WFI actually
> > + * did sleep rather than return straight away.
> > + */
> > +static void test_wfi(void)
> > +{
> > +	uint64_t start;
> > +
> > +	report_info("Testing WFI...");
> > +
> > +	start = read_sysreg(cntvct_el0);
> > +	write_sysreg(time_10ms, cntv_tval_el0);
> > +	write_sysreg(1, cntv_ctl_el0); /* Enable timer, no mask */
> > +	isb();
> > +
> > +	local_irq_enable();
> 
> There's nothing to guarantee that the CPU won't handle the interrupt between
> local_irq_enable() above and the wfi() below, thus guaranteeing that the WFI
> will never complete.
> 
> The Arm ARM says that WFI will complete if there is a pending interrupt even if
> interrupts are **disabled** for the PE; this is also how Linux implements idle
> (it disables interrupt on the PE before doing WFI).
> 
> > +	wfi();
> > +	local_irq_disable();
> 
> So this code should probably be (untested):
> 
> diff --git a/arm/wfx.c b/arm/wfx.c
> index 0825c5cbfcec..522edd36af38 100644
> --- a/arm/wfx.c
> +++ b/arm/wfx.c
> @@ -78,8 +78,8 @@ static void test_wfi(void)
>         write_sysreg(1, cntv_ctl_el0); /* Enable timer, no mask */
>         isb();
> 
> -       local_irq_enable();
>         wfi();
> +       local_irq_enable();
>         local_irq_disable();
> 
>         check_elapsed(start, time_10ms, "WFI", true);
> 
> That is assuming that you want the timer interrupt handler to run, though it
> doesn't look to me like the interrupt handler is very useful from a testing
> perspective (i.e, the tests never check that the correct timer interrupt was
> asserted, or even that the timer interrupt fired at all).
> 
> If you don't care about the timer interrupt handler running, you can skip
> enabling the interrupt altogether, like the wfit test does; you know better than

Sorry, this was sloppy wording from my part, what I mean is that '[..] you
can skip enabling local interrupts (local_irq_enable()) altogether.'

Thanks,
Alex

> me what would be better.
> 
> > +
> > +	check_elapsed(start, time_10ms, "WFI", true);
> > +}
> > +
> > +/*
> > + * Test WFE and SEV[L]
> > + *
> > + * There are two SEV instructions, the normal one is a broadcast
> > + * from any PE on the system, the other is local only.
> > + * Functionally they have the same effect (setting the event
> > + * register) and should be immediately consumed by the WFE.
> > + *
> > + * As we want to detect an early exit the sense of the timeout
> > + * check is reversed.
> > + */
> > +static void test_wfe(void)
> > +{
> > +	uint64_t start;
> > +
> > +	report_info("Testing WFE/SEV...");
> > +	sev();
> > +	start = read_sysreg(cntvct_el0);
> > +	wfe();
> > +	check_elapsed(start, time_10ms, "WFE/SEV", false);
> > +
> > +	report_info("Testing WFE/SEVL...");
> > +	sevl();
> > +	start = read_sysreg(cntvct_el0);
> > +	wfe();
> > +	check_elapsed(start, time_10ms, "WFE/SEVL", false);
> > +}
> > +
> > +/*
> > + * Test WFIT
> > + *
> > + * With the timer disabled and no other IRQ sources firing the
> > + * WFIT instruction should timeout.
> > + */
> > +static void test_wfit(void)
> > +{
> > +	uint64_t start, timeout;
> > +
> > +	report_info("Testing WFIT...");
> > +	start = read_sysreg(cntvct_el0);
> > +	timeout = start + time_10ms;
> > +	wfit(timeout);
> > +	check_elapsed(start, time_10ms, "WFIT", true);
> > +}
> > +
> > +/*
> > + * Test WFET
> > + *
> > + * Much like WFIT there are no IRQs to wake us up. However the
> > + * event_register is a latch so we must first consume the event
> > + * register with a normal WFE before we do the timeout version.
> > + */
> > +static void test_wfet(void)
> > +{
> > +	uint64_t start, timeout;
> > +
> > +	report_info("Testing WFET...");
> > +	/* Ensure no pending events */
> > +	sevl();
> > +	wfe();
> > +
> > +	start = read_sysreg(cntvct_el0);
> > +	timeout = start + time_10ms;
> > +	wfet(timeout);
> > +	check_elapsed(start, time_10ms, "WFET", true);
> > +}
> > +
> > +int main(void)
> > +{
> > +	uint32_t irq = current_level() == CurrentEL_EL1 ? TIMER_VTIMER_IRQ : TIMER_HVTIMER_IRQ;
> > +
> > +	if (gic_init() < 0) {
> > +		report_abort("GIC init failed");
> > +		return 1;
> > +	}
> > +
> > +	/* Install timer handler for WFI wake-up */
> > +	install_irq_handler(EL1H_IRQ, timer_handler);
> > +	gic_enable_defaults();
> > +	time_hz = read_sysreg(cntfrq_el0);
> > +	time_10ms = time_hz / 100;
> > +
> > +	/* Enable Virtual Timer PPI */
> > +	gic_irq_set_clr_enable(irq, true);
> > +
> > +	report_prefix_push("WFx");
> > +	test_wfi();
> > +	test_wfe();
> > +	report_prefix_pop();
> > +
> > +	if (system_supports_wfxt()) {
> > +		report_prefix_push("WFxT");
> > +		test_wfit();
> > +		test_wfet();
> > +	} else {
> > +		report_skip("WFxT instructions not supported");
> > +	}
> 
> I think I'm nitpicking here, and I didn't test it. If the system supports WFxT
> the SUMMARY line shows 4 tests, but if the system doesn't have WFxT, the SUMMARY
> line shows 2 tests, and 1 skipped test, in total 3 tests, not 4. Might be
> confusing to users.
> 
> Thanks,
> Alex
> 
> > +
> > +	return report_summary();
> > +}
> > diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> > index 12fc4468..ae8b5534 100644
> > --- a/arm/unittests.cfg
> > +++ b/arm/unittests.cfg
> > @@ -339,3 +339,10 @@ groups = mte
> >  test_args = asymm
> >  qemu_params = -machine mte=on
> >  arch = arm64
> > +
> > +[wfx]
> > +file = wfx.flat
> > +groups = wfx
> > +arch = arm64
> > +# This test exercise CPU emulation so limit to TCG to avoid confusion
> > +accel = tcg
> > -- 
> > 2.47.3
> > 
> 
