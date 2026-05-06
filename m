Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 750C4326939
	for <kvmarm@lists.linux.dev>; Wed,  6 May 2026 09:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778058012; cv=none; b=BzJ4lZwJNFGYKcMzJ5CxembKUAiKupP2RB3AymaWhNJjiX4GY5hnJvGfC6Kz3sLllq221zjK2CqdXSCq/7WVEtPBUIXX0yX9EYNecrq5jzsJdXrs8F/74sf5qe4FNSz5vT3nRIdk97aBwqJmyxb2QvL5bhBm//Z6mNSF7x9C2KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778058012; c=relaxed/simple;
	bh=bLe/QX5/0o/d4nlfDaO/xQf9oT1VeInhFRblscbUl8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f1rnsYSygE1TQeHV6AKJdqbBRlrhnRp+VZItq/LKo3mJ5UmZRH0H/OQmuyjCDZiZbHn8rEI9WY/e4PHHirrcJcHf9BuZgL+P89AEl5N2QFMr5TgILCGwRwsdg++Ng2+16PMP/oTqif758mEulzDMyfZbWyTFwRJB1NY2ITZCeDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FFLM80pf; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FFLM80pf"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5AEC61A25;
	Wed,  6 May 2026 02:00:05 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 43E523F836;
	Wed,  6 May 2026 02:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778058010; bh=bLe/QX5/0o/d4nlfDaO/xQf9oT1VeInhFRblscbUl8Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FFLM80pfAJPlpvnWuIusIk6eU/BnLbm+MpfnEX2p3YteXEKJdHmIezKISdJ8ywsId
	 KKy2jmtbaDjQVhrytJNskHFAmuHC1nyrI7M5PlsYMTufxgjfE4OAA0B1M/T+J5DUVv
	 ZmUAbkNUSOqLPxHb4MeyAFCPBbzV44ESHJKtP/ZU=
Date: Wed, 6 May 2026 10:00:05 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, Andrew Jones <andrew.jones@linux.dev>,
	Eric Auger <eric.auger@redhat.com>,
	"open list:ARM" <kvmarm@lists.linux.dev>,
	"open list:Default mailing list" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH] arm: add wfx test case
Message-ID: <afsDFUaOUBknpo1Q@raptor>
References: <20260427130045.3669851-1-alex.bennee@linaro.org>
 <afSnVJLe7HrB6ISS@raptor>
 <87zf2jcisg.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87zf2jcisg.fsf@draig.linaro.org>

Hi,

On Fri, May 01, 2026 at 03:21:19PM +0100, Alex Bennée wrote:
> Alexandru Elisei <alexandru.elisei@arm.com> writes:
> 
> > Hi Alex,
> >
> > On Mon, Apr 27, 2026 at 02:00:45PM +0100, Alex Bennée wrote:
> >> This is based on a similar test case I wrote for QEMU's tcg tests although
> >> obviously able to take advantage of kvm-unit-tests additional plumbing for
> >> dealing with the GIC and IRQs.
> >> 
> >> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> >> ---
> >>  arm/Makefile.arm64        |   1 +
> >>  lib/arm64/asm/processor.h |   7 ++
> >>  lib/arm64/asm/sysreg.h    |   3 +
> >>  arm/wfx.c                 | 137 ++++++++++++++++++++++++++++++++++++++
> >>  arm/unittests.cfg         |   5 ++
> >>  5 files changed, 153 insertions(+)
> >>  create mode 100644 arm/wfx.c
> >> 
> >> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> >> index a40c830d..52b3f35d 100644
> >> --- a/arm/Makefile.arm64
> >> +++ b/arm/Makefile.arm64
> >> @@ -64,6 +64,7 @@ tests += $(TEST_DIR)/cache.$(exe)
> >>  tests += $(TEST_DIR)/debug.$(exe)
> >>  tests += $(TEST_DIR)/fpu.$(exe)
> >>  tests += $(TEST_DIR)/mte.$(exe)
> >> +tests += $(TEST_DIR)/wfx.$(exe)
> >>  
> >>  include $(SRCDIR)/$(TEST_DIR)/Makefile.common
> >>  
> >> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> >> index 32ddc1b3..2104036d 100644
> >> --- a/lib/arm64/asm/processor.h
> >> +++ b/lib/arm64/asm/processor.h
> >> @@ -173,5 +173,12 @@ static inline bool system_supports_rndr(void)
> >>  	return ((id_aa64isar0_el1 >> ID_AA64ISAR0_EL1_RNDR_SHIFT) & 0xf) != 0;
> >>  }
> >>  
> >> +static inline bool system_supports_wfxt(void)
> >> +{
> >> +	u64 id_aa64isar2_el1 = read_sysreg_s(ID_AA64ISAR2_EL1);
> >> +
> >> +	return ((id_aa64isar2_el1 >> ID_AA64ISAR2_EL1_WFxT_SHIFT) & 0xf) != 0;
> >> +}
> >> +
> >>  #endif /* !__ASSEMBLER__ */
> >>  #endif /* _ASMARM64_PROCESSOR_H_ */
> >> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
> >> index f2d05018..cb96a649 100644
> >> --- a/lib/arm64/asm/sysreg.h
> >> +++ b/lib/arm64/asm/sysreg.h
> >> @@ -77,6 +77,9 @@ asm(
> >>  #define ID_AA64ISAR0_EL1_RNDR_SHIFT	60
> >>  #define ID_AA64PFR1_EL1_MTE_SHIFT	8
> >>  
> >> +#define ID_AA64ISAR2_EL1		sys_reg(3, 0, 0, 6, 2)
> >> +#define ID_AA64ISAR2_EL1_WFxT_SHIFT	0
> >> +
> >>  #define ID_AA64MMFR0_EL1_FGT_SHIFT	56
> >>  #define ID_AA64MMFR0_EL1_FGT_FGT2	0x2
> >>  
> >> diff --git a/arm/wfx.c b/arm/wfx.c
> >> new file mode 100644
> >> index 00000000..912e50e6
> >> --- /dev/null
> >> +++ b/arm/wfx.c
> >> @@ -0,0 +1,137 @@
> >> +/*
> >> + * WFX Instructions Test (WFI, WFE, WFIT, WFET)
> >> + *
> >> + * Copyright (c) 2026 Linaro Ltd
> >> + *
> >> + * SPDX-License-Identifier: GPL-2.0-or-later
> >> + */
> >> +
> >> +#include <libcflat.h>
> >> +#include <asm/processor.h>
> >> +#include <asm/gic.h>
> >> +#include <asm/timer.h>
> >> +#include <asm/io.h>
> >> +
> >> +#define TIMEOUT 200000
> >> +
> >> +#define sev() asm volatile("sev" : : : "memory")
> >> +#define sevl() asm volatile("sevl" : : : "memory")
> >> +#define wfi() asm volatile("wfi" : : : "memory")
> >> +#define wfe() asm volatile("wfe" : : : "memory")
> >> +
> >> +#define wfit(reg) \
> >> +	asm volatile(".arch armv8.7-a\n\twfit %0" : : "r" (reg) : "memory")
> >> +#define wfet(reg) \
> >> +	asm volatile(".arch armv8.7-a\n\twfet %0" : : "r" (reg) : "memory")
> >> +
> >> +static void timer_handler(struct pt_regs *regs)
> >> +{
> >> +	/* Disable timer to stop IRQ from re-firing */
> >> +	write_sysreg(0, cntv_ctl_el0);
> >> +}
> >
> > It is customary for the interrupt handler to ack the interrupt at the GIC level.
> >
> >> +
> >> +static bool check_elapsed(uint64_t start, uint64_t threshold, const char *test, bool more)
> >> +{
> >> +	uint64_t end = read_sysreg(cntvct_el0);
> >> +	uint64_t elapsed = end - start;
> >> +	bool pass = more ? elapsed >= threshold : elapsed <= threshold;
> >> +
> >> +	report(pass, "%s (%ld ticks)", test, elapsed);
> >> +
> >> +	if (!pass) {
> >> +		report_info("%s %s", test, more ? "woke too early" : "slept despite SEV");
> >> +	}
> >> +	return pass;
> >> +}
> >> +
> >> +static void test_wfi(void)
> >> +{
> >> +	uint64_t start;
> >> +
> >> +	report_info("Testing WFI...");
> >> +
> >> +	start = read_sysreg(cntvct_el0);
> >> +	write_sysreg(TIMEOUT, cntv_tval_el0);
> >> +	write_sysreg(1, cntv_ctl_el0); /* Enable timer, no mask */
> >> +	isb();
> >> +
> >> +	local_irq_enable();
> >> +	wfi();
> >
> > Consider this scenario:
> >
> > 	local_irq_enable();
> > 	// CPU takes the interrupt, handles it and returns.
> > 	wfi(); <- CPU now waits forever for an interrupt that will never come
> >
> > The proper way to do it on baremetal would be:
> >
> > 	local_irq_disable();
> > 	// Program timer to fire
> > 	wfi();
> > 	// Timer fires, GIC asserts the interrupt, WFI completes
> > 	local_irq_enable();
> > 	// CPU handles the interrupt
> > 	check_elapsed(..)
> >
> > But this is not baremetal. KVM can decide not to trap WFI (look at
> > arch/arm64/kvm/arm.c::kvm_arch_vcpu_load() -> kvm_vpcu_should_clear_twi()). In
> > that case, the WFI might complete due a host interrupt, and check_elapsed() will
> > fail because the timer hasn't yet fired.
> >
> >> +	local_irq_disable();
> >> +
> >> +	check_elapsed(start, TIMEOUT, "WFI", true);
> >> +}
> >> +
> >> +static void test_wfe(void)
> >> +{
> >> +	uint64_t start;
> >> +
> >> +	report_info("Testing WFE/SEV...");
> >> +	sev();
> >> +	start = read_sysreg(cntvct_el0);
> >> +	wfe();
> >> +	check_elapsed(start, TIMEOUT, "WFE/SEV", false);
> >> +
> >> +	report_info("Testing WFE/SEVL...");
> >> +	sevl();
> >> +	start = read_sysreg(cntvct_el0);
> >> +	wfe();
> >> +	check_elapsed(start, TIMEOUT, "WFE/SEVL", false);
> >> +}
> >
> > I haven't thought about this too much, but it looks to me like the same
> > situation with WFI can happen with WFE
> >
> > Also, kvm-unit-tests() makes use of WFE and SEV for multithreading, and the fact
> > that multithreaded tests work at all might be taken as proof enough that the two
> > instructions are correctly implemented.
> 
> So I'm using kvm-unit-test to exercise QEMU's TCG modelling of the
> instructions, see:
> 
>   Message-ID: <20260430104434.1482407-1-alex.bennee@linaro.org>
>   Date: Thu, 30 Apr 2026 11:44:27 +0100
>   Subject: [PATCH v4 0/7] target/arm: fully model WFxT instructions for A-profile
> 
> So while I'm confident the current modelling doesn't cause issues
> (because we basically treat it as a NOP) I wanted to check the various
> modes behave as they should with the above patches.
> 
> I can limit the test to TCG only if it is likely to fail under KVM.

I think that would be best. But please also ack the interrupt in the timer
IRQ handler, as that is what software would do (you can have a look at
arm/timer.c::irq_handler() for an example).

Thanks,
Alex
