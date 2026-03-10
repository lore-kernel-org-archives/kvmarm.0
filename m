Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC7EA3A6B6F
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 16:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773158922; cv=none; b=lu47jD7rynYDLTpud11K/SmsZWgbhb72A9jMeflg3kRS9c+1u17w9FFjoktfIYVAgV5dyorQ7Dp+5oy8aVGGOpupn1Q+zP9KTxXDymm3PJ9auGXbjxO+jqo5OUqOg6agGSLUfYQpt8FttAOx71GZE848Tsg0X8BFrVTdzq2h5Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773158922; c=relaxed/simple;
	bh=ImTi4vHGQu1Zr9WBTXLoa4IyqwJkiSHUGFAKhP6eL3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K3bnEjCnOqW3lQfEPaNlLSFkS2XjRv2l056vNJPoaCwXG2SEZrMlg+O62uU33/E4p6IpIekSCG+SUQxRRufDUCbjNRdBxfwaGF1ozzKgtKuL2dy4d530X2t8lfEAiCFy6FY/G4FXuGF3M7XKHt64pXuKSxSLk5P6/1a0/sR90qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A45C1596;
	Tue, 10 Mar 2026 09:08:34 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C6F563F73B;
	Tue, 10 Mar 2026 09:08:38 -0700 (PDT)
Date: Tue, 10 Mar 2026 16:08:26 +0000
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev
Cc: andrew.jones@linux.dev, alexandru.elisei@arm.com, 
	Marc Zyngier <maz@kernel.org>
Subject: Re: [kvm-unit-tests PATCH v1 5/5] arm64: add hypervisor trapping test
Message-ID: <focbteiop6htrljl3al2364x6sxeigrjfdcczemgvlfrubohfj@bsypzbn6562l>
References: <20260306142656.2775185-1-joey.gouly@arm.com>
 <20260306142656.2775185-6-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306142656.2775185-6-joey.gouly@arm.com>

Hi Joey,

I only have some suggestions on the function names:

On Fri, Mar 06, 2026 at 02:26:56PM +0000, Joey Gouly wrote:
> Add a test that sets various EL2 and EL1 trapping bits, and accesses CTR_EL0
> from EL1 and EL0.
> 
> There are two test that will run at EL1, to ensure the guest code is not too
> EL2 specific.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>  arm/Makefile.arm64     |   1 +
>  arm/hyp-test.c         | 139 +++++++++++++++++++++++++++++++++++++++++
>  lib/arm64/asm/sysreg.h |   4 ++
>  3 files changed, 144 insertions(+)
>  create mode 100644 arm/hyp-test.c
> 
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index c7a39945..7582dad5 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -65,6 +65,7 @@ tests += $(TEST_DIR)/cache.$(exe)
>  tests += $(TEST_DIR)/debug.$(exe)
>  tests += $(TEST_DIR)/fpu.$(exe)
>  tests += $(TEST_DIR)/mte.$(exe)
> +tests += $(TEST_DIR)/hyp-test.$(exe)
>  
>  include $(SRCDIR)/$(TEST_DIR)/Makefile.common
>  
> diff --git a/arm/hyp-test.c b/arm/hyp-test.c
> new file mode 100644
> index 00000000..17af29ee
> --- /dev/null
> +++ b/arm/hyp-test.c
> @@ -0,0 +1,139 @@
> +#include <asm/processor.h>
> +#include <asm/guest.h>
> +
> +bool current_el_undef_taken = false;
> +
> +static void elx_und(struct pt_regs *regs, unsigned int esr)

Do you think undef_handler() is better?

> +{
> +	current_el_undef_taken = true;
> +	step_trapped_instruction(regs);
> +	return;
> +}
> +
> +static int read_current_el(void) {
> +	return (int)current_level();
> +}
> +
> +static int current_el0_at_el0(void) {

Did you mean to say current_el_at_el0()?

> +	install_exception_handler(EL0_SYNC_64, ESR_EL1_EC_UNKNOWN, elx_und);
> +	current_el_undef_taken = false;
> +	run_in_el0(read_current_el);
> +	report(current_el_undef_taken == true, "CurrentEL undef taken at EL0");
> +	install_exception_handler(EL0_SYNC_64, ESR_EL1_EC_UNKNOWN, NULL);
> +
> +	return 0;
> +}
> +
> +static void current_el_trap(void) {
> +	if (current_level() == CurrentEL_EL2) {
> +		write_sysreg(read_sysreg(HCR_EL2) & ~HCR_EL2_TGE, HCR_EL2);
> +		run_in_el1(current_el0_at_el0);
> +	} else {
> +		current_el0_at_el0();
> +	}
> +}
> +
> +bool ctr_trap_taken = false;
> +int ctr_trap_el = 0;
> +
> +static void ctr_elx_sys(struct pt_regs *regs, unsigned int esr)

sys64_handler()?

> +{
> +	ctr_trap_taken = true;
> +	ctr_trap_el = current_level() >> 2;
> +	step_trapped_instruction(regs);
> +	return;
> +}
> +
> +static int read_ctr_el0(void) {
> +	asm volatile("mrs x0, ctr_el0");
> +	return 0;
> +}
> +
> +static int ctr_el0_trap_el1_el0(void) {

read_ctr_el0_and_trap()?

> +	install_exception_handler(EL0_SYNC_64, ESR_EL1_EC_SYS64, ctr_elx_sys);
> +	run_in_el0(read_ctr_el0);
> +	install_exception_handler(EL0_SYNC_64, ESR_EL1_EC_SYS64, NULL);
> +
> +	return 0;
> +}
> +
> +static void ctr_el0_trap_el1_only(void)
> +{
> +     u64 sctlr_el1 = read_sysreg(sctlr_el1);
> +
> +     ctr_trap_taken = 0;
> +     ctr_trap_el = 0;
> +     write_sysreg(sctlr_el1 & ~SCTLR_EL1_UCT, sctlr_el1);
> +     ctr_el0_trap_el1_el0();
> +     report(ctr_trap_taken && ctr_trap_el == 1,
> +            "CTR_EL0 trap taken to EL1, UCT=0");
> +
> +     ctr_trap_taken = 0;
> +     ctr_trap_el = 0;
> +     write_sysreg(sctlr_el1 | SCTLR_EL1_UCT, sctlr_el1);
> +     ctr_el0_trap_el1_el0();
> +     report(!ctr_trap_taken && ctr_trap_el == 0,
> +            "CTR_EL0 trap not taken, UCT=1");
> +
> +     write_sysreg(sctlr_el1, sctlr_el1);
> +     isb();
> +}
> +
> +static void ctr_el0_trap(void) {
> +	ctr_trap_taken = 0;
> +	ctr_trap_el = 0;
> +	write_sysreg(read_sysreg(HCR_EL2) & ~HCR_EL2_TID2, HCR_EL2);
> +	write_sysreg(read_sysreg(HCR_EL2) & ~HCR_EL2_TGE, HCR_EL2);
> +	write_sysreg(read_sysreg(SCTLR_EL2) & ~SCTLR_EL2_UCT, SCTLR_EL2);
> +	run_in_el1(ctr_el0_trap_el1_el0);
> +	assert(current_level() == CurrentEL_EL2);
> +	report(ctr_trap_taken && ctr_trap_el == 1, "CTR_EL0 trap taken to EL1, TID2=0, UCT=0");
> +
> +	ctr_trap_taken = 0;
> +	ctr_trap_el = 0;
> +	write_sysreg(read_sysreg(HCR_EL2) & ~HCR_EL2_TID2, HCR_EL2);
> +	write_sysreg(read_sysreg(SCTLR_EL2) | SCTLR_EL2_UCT, SCTLR_EL2);
> +	run_in_el1(ctr_el0_trap_el1_el0);
> +	report(!ctr_trap_taken && ctr_trap_el == 0, "CTR_EL0 trap not taken, TID2=0, UCT=1");
> +
> +	ctr_trap_taken = 0;
> +	ctr_trap_el = 0;
> +	write_sysreg(read_sysreg(HCR_EL2) | HCR_EL2_TID2, HCR_EL2);
> +	write_sysreg(read_sysreg(HCR_EL2) & ~HCR_EL2_TGE, HCR_EL2);
> +	write_sysreg(read_sysreg(SCTLR_EL2) | SCTLR_EL2_UCT, SCTLR_EL2);
> +	install_exception_handler(EL0_SYNC_64, ESR_EL1_EC_SYS64, ctr_elx_sys);
> +	run_in_el1(ctr_el0_trap_el1_el0);
> +	install_exception_handler(EL0_SYNC_64, ESR_EL1_EC_SYS64, NULL);
> +	report(ctr_trap_taken && ctr_trap_el == 2, "CTR_EL0 trap taken to EL2, TID2=1, UCT=1");
> +
> +	ctr_trap_taken = 0;
> +	ctr_trap_el = 0;
> +	write_sysreg(read_sysreg(HCR_EL2) | HCR_EL2_TID2, HCR_EL2);
> +	write_sysreg(read_sysreg(HCR_EL2) & ~HCR_EL2_TGE, HCR_EL2);
> +	write_sysreg(read_sysreg(SCTLR_EL2) & ~SCTLR_EL2_UCT, SCTLR_EL2);
> +	run_in_el1(ctr_el0_trap_el1_el0);
> +	report(ctr_trap_taken && ctr_trap_el == 1, "CTR_EL0 trap taken to EL2, TID2=1, UCT=0");
> +
> +	ctr_trap_taken = 0;
> +	ctr_trap_el = 0;
> +	write_sysreg(read_sysreg(HCR_EL2) | HCR_EL2_TID2, HCR_EL2);
> +	write_sysreg(read_sysreg(SCTLR_EL2) & ~SCTLR_EL2_UCT, SCTLR_EL2);
> +	write_sysreg(read_sysreg(HCR_EL2) | HCR_EL2_TID2 | HCR_EL2_TGE, HCR_EL2);
> +	ctr_el0_trap_el1_el0();
> +	write_sysreg(read_sysreg(HCR_EL2) & ~HCR_EL2_TGE, HCR_EL2);
> +	report(ctr_trap_taken && ctr_trap_el == 2, "CTR_EL0 trap taken (VHE), EL2, TID2=1, UCT=0");
> +}
> +
> +int main(void) {
> +	current_el_trap();
> +
> +	if (current_level() != CurrentEL_EL2) {
> +		ctr_el0_trap_el1_only();
> +		report_skip("EL2-only trap routing tests skipped at EL1");
> +		return report_summary();
> +	}
> +
> +	ctr_el0_trap();

I also suggest adding a test_ prefix to these top level test functions.

Sorry if this sounds nitpicky! I didn't have the easiest time getting
the rough purpose of these functions while reading their names.

Thanks,
Wei-Lin Chang

> +
> +	return report_summary();
> +}
> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
> index 498eef4e..298e8b7a 100644
> --- a/lib/arm64/asm/sysreg.h
> +++ b/lib/arm64/asm/sysreg.h
> @@ -102,6 +102,7 @@ asm(
>  #define SCTLR_EL1_EIS		_BITULL(22)
>  #define SCTLR_EL1_TSCXT		_BITULL(20)
>  #define SCTLR_EL1_WXN		_BITULL(19)
> +#define SCTLR_EL1_UCT		_BITULL(15)
>  #define SCTLR_EL1_I		_BITULL(12)
>  #define SCTLR_EL1_EOS		_BITULL(11)
>  #define SCTLR_EL1_SED		_BITULL(8)
> @@ -118,6 +119,9 @@ asm(
>  #define SCTLR_EL1_TCF0_SHIFT	38
>  #define SCTLR_EL1_TCF0_MASK	GENMASK_ULL(39, 38)
>  
> +#define SCTLR_EL2_UCT _BITULL(15)
> +
> +#define HCR_EL2_TID2		_BITULL(17)
>  #define HCR_EL2_TGE		_BITULL(27)
>  #define HCR_EL2_RW		_BITULL(31)
>  #define HCR_EL2_E2H		_BITULL(34)
> -- 
> 2.25.1
> 
