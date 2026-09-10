Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16AFD4FB9C9
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 17:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789060859; cv=none; b=STJCF/JXP7TECX2i4Hc1K7r1TcUtfEIpezlnfhtLl46cTQaBQR09OGYfWtxyC1p0yiaNgljzMsxHdgOjTilzylnDVeZO8nUOkA9JOEJOfa3MmXCX68S5CnHW4KHqRKFeFVmUbfrgjjpwPyxuIFTWQNSuLFauoevwZNp/So7epuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789060859; c=relaxed/simple;
	bh=On3RzrtMuST+P6UOEpazXCXmp06+AvInEz19sMd7mHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=HLJ0qQs9IsYv3r8NSil+ZlHma/Si+cHNgaV8YU1i2ELeAprauZEyAM7/p8SwZ7BPawrdxudQJZTlLOdLszlgKt1vEDKaVZ2f9ZJG/H7Yh4dTPcdVcGhUZRUvyHZ059F7Yy63nqwtRy2bRIoFm9ejICSF6vyja7UfWRQHWxFI+pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NIkJP13v; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NIkJP13v"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F9B822C8;
	Thu, 10 Sep 2026 10:20:35 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C824B3F59E;
	Thu, 10 Sep 2026 10:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789060838; bh=On3RzrtMuST+P6UOEpazXCXmp06+AvInEz19sMd7mHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NIkJP13vMwgWuA8pY6Byn4L+t3sch+R32k1IpiZZiCeTpdbg3AqX/4q++xC01ygAz
	 fm7XgBkKel3wM78k8yrifS3zOCdX9YfiBNRm15a1aBiC6Dj9+EXITie3kr3IejRqBA
	 6rdtMYH3WJLbad37l7xxVUUxX4vfkIPXwe1UpXKk=
From: Leonardo Bras <leo.bras@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Peter Maydell <peter.maydell@linaro.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v20 14/14] KVM: selftests: arm64: Add GCS EXLOCK exception emulation test
Date: Thu, 10 Sep 2026 18:20:30 +0100
Message-ID: <aqLm3qT755sXH_D9@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901-arm64-gcs-v20-14-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org> <20260901-arm64-gcs-v20-14-f31750bdfadb@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Sep 01, 2026 at 10:47:12PM +0100, Mark Brown wrote:
> When running in vEL2 ERET is emulated, this means that we must emulate
> the behaviour of GCSCR_EL2.EXLOCKEN. Add a test that validates the
> behaviour.
> 
> As per DDI0487 R_WTXBY PSTATE.EXLOCK is set to the value of
> GCSCR_ELx.EXLOCKEN when taking an exception to the same exception level.
> As per DDI0487 R_TYTWB if on exception return to the same EL
> GCSCR_ELx.EXLOCKEN is 1 and PSTATE.EXLOCK is not 1 then the exception
> return is illegal.
> 
> We nest handling of two UDFs to allow us to both observe and modify
> PSTATE.EXLOCK, checking that expected exceptions are generated for ERET.
> We also repeat the UDF tests having enabled fine grained traps for ERET
> to try to ensure that the slow paths are taken.
> 
> We also attempt to write to both SPSR_ELx and ELR_ELx, again using a UDF
> handler to control PSTATE.EXLOCK. We do all this both with and without
> having enabled EXLOCKEN, though only for code running at EL2 due to
> framework limitations.
> 
> For completeness we also inject a data abort from EL0 to EL2 with
> GCSCR_EL2.EXLOCKEN set, ensuring that PSTATE.EXLOCK is not set.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  tools/testing/selftests/kvm/Makefile.kvm           |   1 +
>  tools/testing/selftests/kvm/arm64/gcs_exceptions.c | 346 +++++++++++++++++++++
>  2 files changed, 347 insertions(+)
> 

Hi Mark,

Maybe because I am new to this type of selftest (i.e. the helpers), or 
maybe because I don't understand some of the used mechanisms here, but this 
selftest felt hard to understand, even though the commit message made 
it sound very simple.

So I will try to cover what I could understand, so please let me know if I 
got something wrong.

From both tests, the lower_el() one is the simplest: if the features are 
there, you set TGE, EXLOCKEN and EXLOCK, and then do an KVM_SET_VCPU_EVENTS 
ioctl which injects a dabt and commit_pending_events(). It should change 
the PSTATE which you read and make sure EXLOCK=0.
(This should be about the last sentence in your commit msg)

For same_el(), 3 exception handlers are assigned to the vcpu: unknown, 
ilegal, and GCS. You then run the guest once, and exit. Then you check the 
exit reason.

In the guest code, you run a few tests for EXTLOCK={0,1} by basically 
counting and checking how many times each handler was called, and if the 
expected EXLOCK/EXLOCKEN states are correct. (Relying on R_WTXBY)

When you run test_udf_exception() it will cause an udf(COLLECT) that will 
itself cause an udf(VALIDATE), and if EXLOCKEN=1, it will cause an illegal 
exception, which will by itself cause an udf(REPAIR). On EXLOCKEN=0, 
setting EXLOCK=0 should not take an exception, and thus there should be no 
illegal++, an just 2 undef. None should cause a gcs exception.
That makes sense with the tests you do after the udf, as well as deciding 
to check IL based on EXLOCKEN status.

As for test_sysreg(), it will run for 4 tested registers with both EXLOCKEN 
states. What it does it take an udf(reg), which will read then write that 
read value to that register. If EXLOCKEN=1 it's expected to cause a gcs 
fault. That makes sense with the gcs and udf counters check in the bottom.

The part of re-running test_udf_exception() with HFGITR_EL2 set, IIUC, it 
that part of fine-grained traps. It seems correct, although I am not seeing 
any tests of the EC syndrome being 0x1A to make sure it's in use. 

There are also a lot of expect_exlock being used as an int, even if it's a 
bool. I understand the idea of summing it as we expect it to be 1 on true 
or 0 on false, but is it really ok?
Maybe we could change it to int, so we just set it when we enter 
test_sysreg() or test_udf_exception() like:

-	expect_exlock = enable_exlock;
+	expect_exlock = enable_exlock ? 1 : 0;

If I got the workings right, and both above suggestions (0x1A and 
bool->int) are either fixed or considered not an issue, then:

Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo

> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index 96bab7002d39..0286453ab223 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -179,6 +179,7 @@ TEST_GEN_PROGS_arm64 += arm64/hello_el2
>  TEST_GEN_PROGS_arm64 += arm64/host_sve
>  TEST_GEN_PROGS_arm64 += arm64/hypercalls
>  TEST_GEN_PROGS_arm64 += arm64/external_aborts
> +TEST_GEN_PROGS_arm64 += arm64/gcs_exceptions
>  TEST_GEN_PROGS_arm64 += arm64/mmio_sign_ext
>  TEST_GEN_PROGS_arm64 += arm64/page_fault_test
>  TEST_GEN_PROGS_arm64 += arm64/psci_test
> diff --git a/tools/testing/selftests/kvm/arm64/gcs_exceptions.c b/tools/testing/selftests/kvm/arm64/gcs_exceptions.c
> new file mode 100644
> index 000000000000..de5bc6590727
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/arm64/gcs_exceptions.c
> @@ -0,0 +1,346 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Test KVM's handling of Guarded Control Stack exception state.
> + */
> +
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "test_util.h"
> +#include "ucall.h"
> +
> +#include <asm/ptrace.h>
> +#include <asm/sysreg.h>
> +
> +#define PSTATE_IL_BIT	BIT(20)
> +
> +static void require_guest_gcs(struct kvm_vcpu *vcpu)
> +{
> +	u64 pfr1 = vcpu_get_reg(vcpu,
> +				KVM_ARM64_SYS_REG(SYS_ID_AA64PFR1_EL1));
> +
> +	TEST_REQUIRE(SYS_FIELD_GET(ID_AA64PFR1_EL1, GCS, pfr1) >=
> +		     ID_AA64PFR1_EL1_GCS_IMP);
> +}
> +
> +static bool expect_exlock;
> +static unsigned int undef_count;
> +static unsigned int illegal_count;
> +static unsigned int gcs_count;
> +static u64 handler_pstate;
> +static u64 illegal_pstate;
> +
> +static u64 expected_illegal_pc;
> +static enum udf_mode {
> +	UDF_COLLECT,	/* Initial UDF we collect PSTATE from */
> +	UDF_VALIDATE,	/* Secondary UDF that collects and validates */
> +	UDF_REPAIR,	/* UDF to clear EXLOCK */
> +	UDF_ELR_EL1,	/* Write to ELR_EL1 with EXLOCK */
> +	UDF_ELR_EL2,	/* Write to ELR_EL2 with EXLOCK */
> +	UDF_SPSR_EL1,	/* Write to SPSR_EL1 with EXLOCK */
> +	UDF_SPSR_EL2,	/* Write to SPSR_EL2 with EXLOCK */
> +} udf_mode;
> +
> +static void guest_undef_handler(struct ex_regs *regs)
> +{
> +	u64 esr = read_sysreg(esr_el2);
> +	u64 val;
> +
> +	undef_count++;
> +
> +	/* Just skip the instruction either way. */
> +	GUEST_ASSERT_EQ(esr, ESR_ELx_IL);
> +	regs->pc += 4;
> +
> +	switch (udf_mode) {
> +	case UDF_COLLECT:
> +		GUEST_ASSERT_EQ(read_sysreg_s(SYS_GCSCR_EL2) & GCSCR_ELx_EXLOCKEN,
> +				expect_exlock ? GCSCR_ELx_EXLOCKEN : 0);
> +
> +		/*
> +		 * If we want the nested exception handler to change
> +		 * PSTATE it can't have EXLOCK set.
> +		 */
> +		write_sysreg_s(0, SYS_GCSCR_EL2);
> +		isb();
> +
> +		/*
> +		 * Take another exception without returning so we can
> +		 * collect the EXLOCK state we're seeing here and make
> +		 * our return illegal.
> +		 */
> +		expected_illegal_pc = regs->pc;
> +		udf_mode = UDF_VALIDATE;
> +		asm volatile("udf #0" ::: "memory");
> +
> +		/* Reenable so PSTATE.EXLOCK is checked */
> +		write_sysreg_s(expect_exlock ? GCSCR_ELx_EXLOCKEN : 0,
> +			       SYS_GCSCR_EL2);
> +		isb();
> +		break;
> +
> +	case UDF_VALIDATE:
> +		GUEST_ASSERT_EQ(read_sysreg_s(SYS_GCSCR_EL2) & GCSCR_ELx_EXLOCKEN,
> +				0);
> +
> +		/* Validate the EXLOCK of the original exception. */
> +		handler_pstate = regs->pstate;
> +		GUEST_ASSERT_EQ(!!(regs->pstate & PSR_EXLOCK_BIT),
> +				expect_exlock);
> +
> +		/* Clearing PSTATE.EXLOCK triggers an illegal ERET. */
> +		regs->pstate &= ~PSR_EXLOCK_BIT;
> +		break;
> +
> +	case UDF_REPAIR:
> +		GUEST_ASSERT_EQ(read_sysreg_s(SYS_GCSCR_EL2) & GCSCR_ELx_EXLOCKEN,
> +				0);
> +
> +		/* Disable EXLOCK for the requesting context */
> +		regs->pstate &= ~PSR_EXLOCK_BIT;
> +		break;
> +
> +	case UDF_ELR_EL1:
> +		GUEST_ASSERT_EQ(read_sysreg_s(SYS_GCSCR_EL2) & GCSCR_ELx_EXLOCKEN,
> +				expect_exlock ? GCSCR_ELx_EXLOCKEN : 0);
> +
> +		asm volatile("mrs %0, elr_el1   \n\
> +	                      msr elr_el1, %0"
> +			     : "=r"(val) :: "memory");
> +		break;
> +
> +	case UDF_ELR_EL2:
> +		GUEST_ASSERT_EQ(read_sysreg_s(SYS_GCSCR_EL2) & GCSCR_ELx_EXLOCKEN,
> +				expect_exlock ? GCSCR_ELx_EXLOCKEN : 0);
> +
> +		asm volatile("mrs %0, elr_el2   \n\
> +	                      msr elr_el2, %0"
> +			     : "=r"(val) :: "memory");
> +		break;
> +
> +	case UDF_SPSR_EL1:
> +		GUEST_ASSERT_EQ(read_sysreg_s(SYS_GCSCR_EL2) & GCSCR_ELx_EXLOCKEN,
> +				expect_exlock ? GCSCR_ELx_EXLOCKEN : 0);
> +
> +		asm volatile("mrs %0, spsr_el1   \n\
> +			      msr spsr_el1, %0"
> +			     : "=r"(val) :: "memory");
> +		break;
> +
> +	case UDF_SPSR_EL2:
> +		GUEST_ASSERT_EQ(read_sysreg_s(SYS_GCSCR_EL2) & GCSCR_ELx_EXLOCKEN,
> +				expect_exlock ? GCSCR_ELx_EXLOCKEN : 0);
> +
> +		asm volatile("mrs %0, spsr_el2   \n\
> +			      msr spsr_el2, %0"
> +			     : "=r"(val) :: "memory");
> +		break;
> +
> +	default:
> +		GUEST_FAIL("Invalid udf_mode");
> +	}
> +}
> +
> +static void guest_illegal_handler(struct ex_regs *regs)
> +{
> +	u64 esr = read_sysreg(esr_el2);
> +
> +	illegal_count++;
> +	illegal_pstate = regs->pstate;
> +
> +	GUEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_ILL);
> +	GUEST_ASSERT(esr & ESR_ELx_IL);
> +	GUEST_ASSERT(regs->pstate & PSTATE_IL_BIT);
> +	GUEST_ASSERT(!(regs->pstate & PSR_EXLOCK_BIT));
> +	GUEST_ASSERT_EQ(regs->pc, expected_illegal_pc);
> +
> +	/* Disable exception locking so we can repair the return state. */
> +	write_sysreg_s(0, SYS_GCSCR_EL2);
> +	isb();
> +
> +	/* We need our own EXLOCK clearing so we can repair the original */
> +	udf_mode = UDF_REPAIR;
> +	asm volatile("udf #0" ::: "memory");
> +
> +	/* Disable EXLOCK for the generating context, making things legal */
> +	regs->pstate &= ~(PSTATE_IL_BIT | PSR_EXLOCK_BIT);
> +}
> +
> +static void guest_gcs_handler(struct ex_regs *regs)
> +{
> +	u64 esr = read_sysreg(esr_el2);
> +
> +	gcs_count++;
> +
> +	GUEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_GCS);
> +	GUEST_ASSERT_EQ(FIELD_GET(ESR_ELx_ExType_MASK, esr),
> +			ESR_ELx_ExType_EXLOCK);
> +
> +	/* Disabling EXLOCKEN makes sysreg writes legal. */
> +	write_sysreg_s(0, SYS_GCSCR_EL2);
> +	isb();
> +}
> +
> +static noinline void test_udf_exception(bool enable_exlock)
> +{
> +	unsigned int initial_undef = undef_count;
> +	unsigned int initial_illegal = illegal_count;
> +	unsigned int initial_gcs = gcs_count;
> +
> +	expect_exlock = enable_exlock;
> +	write_sysreg_s(enable_exlock ? GCSCR_ELx_EXLOCKEN : 0,
> +		       SYS_GCSCR_EL2);
> +	isb();
> +
> +	udf_mode = UDF_COLLECT;
> +	asm volatile("udf #0" ::: "memory");
> +
> +	/* Leave GCS disabled even if a broken ERET skipped the ILL handler. */
> +	write_sysreg_s(0, SYS_GCSCR_EL2);
> +	isb();
> +
> +	GUEST_ASSERT_EQ(undef_count, initial_undef + 2 + enable_exlock);
> +	GUEST_ASSERT_EQ(illegal_count, initial_illegal + enable_exlock);
> +	GUEST_ASSERT_EQ(!!(handler_pstate & PSR_EXLOCK_BIT), enable_exlock);
> +	if (enable_exlock)
> +		GUEST_ASSERT(illegal_pstate & PSTATE_IL_BIT);
> +	GUEST_ASSERT_EQ(initial_gcs, gcs_count);
> +}
> +
> +static noinline void test_sysreg(enum udf_mode reg, bool enable_exlock)
> +{
> +	unsigned int initial_undef = undef_count;
> +	unsigned int initial_gcs = gcs_count;
> +
> +	expect_exlock = enable_exlock;
> +
> +	write_sysreg_s(enable_exlock ? GCSCR_ELx_EXLOCKEN : 0,
> +		       SYS_GCSCR_EL2);
> +	isb();
> +
> +	udf_mode = reg;
> +	asm volatile("udf #0" ::: "memory");
> +
> +	/* Ensure EXLOCK is disabled */
> +	write_sysreg_s(0, SYS_GCSCR_EL2);
> +	isb();
> +
> +	GUEST_ASSERT_EQ(gcs_count, initial_gcs + expect_exlock);
> +	GUEST_ASSERT_EQ(undef_count, initial_undef + 1);
> +}
> +
> +static void guest_code(void)
> +{
> +	GUEST_ASSERT_EQ(get_current_el(), 2);
> +
> +	/*
> +	 * Try straightforwardly generating an exception without and
> +	 * with EXLOCK.
> +	 */
> +	test_udf_exception(false);
> +	test_sysreg(UDF_ELR_EL1, false);
> +	test_sysreg(UDF_ELR_EL2, false);
> +	test_sysreg(UDF_SPSR_EL1, false);]
> +	test_sysreg(UDF_SPSR_EL2, false);
> +
> +	test_udf_exception(true);
> +	test_sysreg(UDF_ELR_EL1, true);
> +	test_sysreg(UDF_ELR_EL2, true);
> +	test_sysreg(UDF_SPSR_EL1, true);
> +	test_sysreg(UDF_SPSR_EL2, true);
> +
> +	/* Force ERET directly through the slow emulation path as well. */
> +	sysreg_clear_set_s(SYS_HFGITR_EL2, 0, HFGITR_EL2_ERET);
> +	isb();
> +
> +	test_udf_exception(false);
> +
> +	test_udf_exception(true);
> +
> +	sysreg_clear_set_s(SYS_HFGITR_EL2, HFGITR_EL2_ERET, 0);
> +	isb();
> +	GUEST_DONE();
> +}
> +
> +static void test_exception_from_same_el(void)
> +{
> +	struct kvm_vcpu_init init;
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	struct ucall uc;
> +
> +	vm = vm_create(1);
> +	kvm_get_default_vcpu_target(vm, &init);
> +	init.features[0] |= BIT(KVM_ARM_VCPU_HAS_EL2);
> +	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
> +	require_guest_gcs(vcpu);
> +
> +	vm_init_descriptor_tables(vm);
> +	vcpu_init_descriptor_tables(vcpu);
> +	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
> +				ESR_ELx_EC_UNKNOWN, guest_undef_handler);
> +	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
> +				ESR_ELx_EC_ILL, guest_illegal_handler);
> +	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
> +				ESR_ELx_EC_GCS, guest_gcs_handler);
> +	kvm_arch_vm_finalize_vcpus(vm);
> +
> +	vcpu_run(vcpu);
> +	switch (get_ucall(vcpu, &uc)) {
> +	case UCALL_DONE:
> +		break;
> +	case UCALL_ABORT:
> +		REPORT_GUEST_ASSERT(uc);
> +		break;
> +	default:
> +		TEST_FAIL("Unhandled ucall: %ld", uc.cmd);
> +	}
> +
> +	kvm_vm_free(vm);
> +}
> +
> +static void test_exception_from_lower_el(void)
> +{
> +	struct kvm_vcpu_events events = {};
> +	struct kvm_vcpu_init init;
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	u64 pstate;
> +
> +	vm = vm_create(1);
> +	kvm_get_default_vcpu_target(vm, &init);
> +	init.features[0] |= BIT(KVM_ARM_VCPU_HAS_EL2);
> +	vcpu = aarch64_vcpu_add(vm, 0, &init, NULL);
> +	require_guest_gcs(vcpu);
> +	kvm_arch_vm_finalize_vcpus(vm);
> +
> +	/*
> +	 * Inject an EL0 data abort to vEL2 with EXLOCK enabled for
> +	 * vEL2.
> +	 */
> +	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2),
> +		     vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2)) |
> +		     HCR_EL2_TGE);
> +	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_GCSCR_EL2),
> +		     GCSCR_ELx_EXLOCKEN);
> +	vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pstate),
> +		     PSR_MODE_EL0t | PSR_EXLOCK_BIT);
> +
> +	events.exception.ext_dabt_pending = true;
> +	vcpu_events_set(vcpu, &events);
> +
> +	pstate = vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pstate));
> +	TEST_ASSERT_EQ(pstate & PSR_MODE_MASK, PSR_MODE_EL2h);
> +	TEST_ASSERT(!(pstate & PSR_EXLOCK_BIT),
> +		    "EXLOCK set on exception from a lower EL");
> +
> +	kvm_vm_free(vm);
> +}
> +
> +int main(void)
> +{
> +	TEST_REQUIRE(kvm_check_cap(KVM_CAP_ARM_EL2));
> +	test_exception_from_same_el();
> +	test_exception_from_lower_el();
> +
> +	return 0;
> +}
> 
> -- 
> 2.47.3
> 



