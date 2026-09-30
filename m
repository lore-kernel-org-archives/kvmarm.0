Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F9F524B0A;
	Wed, 30 Sep 2026 21:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804991; cv=none; b=AvdJ2EpUGxQOnN7o2pkXW8IbIFfwdk0HajiZIES88+Tt8VVVItVVWxKfkRAl2vaeIS3bYOwc4Keg7n722LA9JCPpI40zrWojTAmVYAipyESl8z3FpUi8FiV42acSf38AqQJ6x3SRgC06hMuXvPHOerRaX/gq7jKQ/yF2pSiv4SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804991; c=relaxed/simple;
	bh=Ap5WYMP/jFZxgMJJY0WLriB9g9iNEKwHzXZCFBgXX8g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tDuZfodBB/hM9Yl9anXVApKqkMliXAPSl2Sc/xgYDBpvY+WOC9FkxpEDWIvitjtzGxAc+AFqwbToJoyIyNwsXrgmMlHaebmLDjcQ6ibIkgVH0qiuHB/MdFSKmmc1cDvZ30O75yCJdZ3x5jcOWQhVlylD+Bfjr4bjkEShKIn9fUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OwGs2+Qt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OwGs2+Qt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF691F00898;
	Wed, 30 Sep 2026 21:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790804990;
	bh=gbRjCKyJEsfaoYs0uz6FNo90W1JB3dsyqZL+XpcN78I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OwGs2+Qte/WJVkJC7eXFmL3seluTWGH9nBh5a9LwiH5jB0L6/5phQIHqvo8Bpb+82
	 AXE4zlkxy8GLprGm0rF7mKD38zv9G2T90yn12m6pIRAP5wd7COEEuZLuOJWgFSiKtw
	 dyuBTnGbEJ2nIidwJYnfyt4YGbS+UmO86TsepFPkOKfZzRabgodN/R/zYUbHnY4y4u
	 8SGhQHp2VfCJuyALo0cBMT/LF1sANXa3yvOz0n15RFOKsemD8CYPnW3bURv3da5IaX
	 fGog4zVAlx5x0D9nbqL81KTrx9bXrTjmzUDUeil/UA1sbsPraUAJV9m+6kG/OPZifM
	 M/ZzIUWybsvow==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 30 Sep 2026 22:48:25 +0100
Subject: [PATCH v21 15/15] KVM: selftests: arm64: Add GCS EXLOCK exception
 emulation test
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-arm64-gcs-v21-15-3556644cd927@kernel.org>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
In-Reply-To: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
 Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=11623; i=broonie@kernel.org;
 h=from:subject:message-id; bh=Ap5WYMP/jFZxgMJJY0WLriB9g9iNEKwHzXZCFBgXX8g=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqvYO/DYTBT/N2pQqG7Bv+IyjaOkfEiUG/sCG5L
 7fcU9ofqfeJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCar2DvwAKCRAk1otyXVSH
 0JsXCACFAaYDC8+8EAqUWrRXksRRQB75PpQu1oB5tCF0YP5tiZQ/ba7op4SbpKXQLXuwUDt8dE4
 hckx9kLXtI2gM9d6Pd1z09PL3QpogQixNANCGXJDcHRdgdX6zr2aZPtYoZs1ueNYwOW8k3b6d86
 hlCQ6qwAqGdMU1hxWy/+yfGZsNWArzHU8ce29zej5938WR8FWR6Nop0C3Qn1NAN3YLk3U4GR0YO
 hRIfmOewl63cPW373CJRv4Lg+dA7hVlFyVP5MmZ1in+hXrzqnpIm2EfBbOGcYXNzwZQFTJb2YV6
 vPRSLAG7qyyXiENYkZD8/tLL5VeML75QEq7At1rX3nyyuBfc
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

When running in vEL2 ERET is emulated, this means that we must emulate
the behaviour of GCSCR_EL2.EXLOCKEN. Add a test that validates the
behaviour.

As per DDI0487 R_WTXBY PSTATE.EXLOCK is set to the value of
GCSCR_ELx.EXLOCKEN when taking an exception to the same exception level.
As per DDI0487 R_TYTWB if on exception return to the same EL
GCSCR_ELx.EXLOCKEN is 1 and PSTATE.EXLOCK is not 1 then the exception
return is illegal.

We nest handling of two UDFs to allow us to both observe and modify
PSTATE.EXLOCK, checking that expected exceptions are generated for ERET.
We also repeat the UDF tests having enabled fine grained traps for ERET
to try to ensure that the slow paths are taken.

We also attempt to write to both SPSR_ELx and ELR_ELx, again using a UDF
handler to control PSTATE.EXLOCK. We do all this both with and without
having enabled EXLOCKEN, though only for code running at EL2 due to
framework limitations.

For completeness we also inject a data abort from EL0 to EL2 with
GCSCR_EL2.EXLOCKEN set, ensuring that PSTATE.EXLOCK is not set.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Leonardo Bras <leo.bras@arm.com>
---
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 tools/testing/selftests/kvm/arm64/gcs_exceptions.c | 336 +++++++++++++++++++++
 2 files changed, 337 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 96bab7002d39..0286453ab223 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -179,6 +179,7 @@ TEST_GEN_PROGS_arm64 += arm64/hello_el2
 TEST_GEN_PROGS_arm64 += arm64/host_sve
 TEST_GEN_PROGS_arm64 += arm64/hypercalls
 TEST_GEN_PROGS_arm64 += arm64/external_aborts
+TEST_GEN_PROGS_arm64 += arm64/gcs_exceptions
 TEST_GEN_PROGS_arm64 += arm64/mmio_sign_ext
 TEST_GEN_PROGS_arm64 += arm64/page_fault_test
 TEST_GEN_PROGS_arm64 += arm64/psci_test
diff --git a/tools/testing/selftests/kvm/arm64/gcs_exceptions.c b/tools/testing/selftests/kvm/arm64/gcs_exceptions.c
new file mode 100644
index 000000000000..c127904108e1
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/gcs_exceptions.c
@@ -0,0 +1,336 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Test KVM's handling of Guarded Control Stack exception state.
+ */
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+#include "ucall.h"
+
+#include <asm/ptrace.h>
+#include <asm/sysreg.h>
+
+#define PSTATE_IL_BIT	BIT(20)
+
+static void require_guest_gcs(struct kvm_vcpu *vcpu)
+{
+	u64 pfr1 = vcpu_get_reg(vcpu,
+				KVM_ARM64_SYS_REG(SYS_ID_AA64PFR1_EL1));
+
+	TEST_REQUIRE(SYS_FIELD_GET(ID_AA64PFR1_EL1, GCS, pfr1) >=
+		     ID_AA64PFR1_EL1_GCS_IMP);
+}
+
+static bool expect_exlock;
+static unsigned int undef_count;
+static unsigned int illegal_count;
+static unsigned int gcs_count;
+static u64 handler_pstate;
+static u64 illegal_pstate;
+
+static u64 expected_illegal_pc;
+static enum udf_mode {
+	UDF_COLLECT,	/* Initial UDF we collect PSTATE from */
+	UDF_VALIDATE,	/* Secondary UDF that collects and validates */
+	UDF_REPAIR,	/* UDF to clear EXLOCK */
+	UDF_ELR_EL1,	/* Write to ELR_EL1 with EXLOCK */
+	UDF_ELR_EL2,	/* Write to ELR_EL2 with EXLOCK */
+	UDF_SPSR_EL1,	/* Write to SPSR_EL1 with EXLOCK */
+	UDF_SPSR_EL2,	/* Write to SPSR_EL2 with EXLOCK */
+} udf_mode;
+
+static void guest_undef_handler(struct ex_regs *regs)
+{
+	u64 esr = read_sysreg(esr_el2);
+	u64 val;
+
+	undef_count++;
+
+	/* Just skip the instruction either way. */
+	GUEST_ASSERT_EQ(esr, ESR_ELx_IL);
+	regs->pc += 4;
+
+	switch (udf_mode) {
+	case UDF_COLLECT:
+		GUEST_ASSERT_EQ(read_sysreg_s(SYS_GCSCR_EL2) & GCSCR_ELx_EXLOCKEN,
+				expect_exlock ? GCSCR_ELx_EXLOCKEN : 0);
+
+		/*
+		 * If we want the nested exception handler to change
+		 * PSTATE it can't have EXLOCK set.
+		 */
+		write_sysreg_s(0, SYS_GCSCR_EL2);
+		isb();
+
+		/*
+		 * Take another exception without returning so we can
+		 * collect the EXLOCK state we're seeing here and make
+		 * our return illegal.
+		 */
+		expected_illegal_pc = regs->pc;
+		udf_mode = UDF_VALIDATE;
+		asm volatile("udf #0" ::: "memory");
+
+		/* Reenable so PSTATE.EXLOCK is checked */
+		write_sysreg_s(expect_exlock ? GCSCR_ELx_EXLOCKEN : 0,
+			       SYS_GCSCR_EL2);
+		isb();
+		break;
+
+	case UDF_VALIDATE:
+		GUEST_ASSERT_EQ(read_sysreg_s(SYS_GCSCR_EL2) & GCSCR_ELx_EXLOCKEN,
+				0);
+
+		/* Validate the EXLOCK of the original exception. */
+		handler_pstate = regs->pstate;
+		GUEST_ASSERT_EQ(!!(regs->pstate & PSR_EXLOCK_BIT),
+				expect_exlock);
+
+		/* Clearing PSTATE.EXLOCK triggers an illegal ERET. */
+		regs->pstate &= ~PSR_EXLOCK_BIT;
+		break;
+
+	case UDF_REPAIR:
+		GUEST_ASSERT_EQ(read_sysreg_s(SYS_GCSCR_EL2) & GCSCR_ELx_EXLOCKEN,
+				0);
+
+		/* Disable EXLOCK for the requesting context */
+		regs->pstate &= ~PSR_EXLOCK_BIT;
+		break;
+
+	case UDF_ELR_EL1:
+		GUEST_ASSERT_EQ(read_sysreg_s(SYS_GCSCR_EL2) & GCSCR_ELx_EXLOCKEN,
+				expect_exlock ? GCSCR_ELx_EXLOCKEN : 0);
+
+		asm volatile("mrs %0, elr_el1   \n\
+	                      msr elr_el1, %0"
+			     : "=r"(val) :: "memory");
+		break;
+
+	case UDF_ELR_EL2:
+		GUEST_ASSERT_EQ(read_sysreg_s(SYS_GCSCR_EL2) & GCSCR_ELx_EXLOCKEN,
+				expect_exlock ? GCSCR_ELx_EXLOCKEN : 0);
+
+		asm volatile("mrs %0, elr_el2   \n\
+	                      msr elr_el2, %0"
+			     : "=r"(val) :: "memory");
+		break;
+
+	case UDF_SPSR_EL1:
+		GUEST_ASSERT_EQ(read_sysreg_s(SYS_GCSCR_EL2) & GCSCR_ELx_EXLOCKEN,
+				expect_exlock ? GCSCR_ELx_EXLOCKEN : 0);
+
+		asm volatile("mrs %0, spsr_el1   \n\
+			      msr spsr_el1, %0"
+			     : "=r"(val) :: "memory");
+		break;
+
+	case UDF_SPSR_EL2:
+		GUEST_ASSERT_EQ(read_sysreg_s(SYS_GCSCR_EL2) & GCSCR_ELx_EXLOCKEN,
+				expect_exlock ? GCSCR_ELx_EXLOCKEN : 0);
+
+		asm volatile("mrs %0, spsr_el2   \n\
+			      msr spsr_el2, %0"
+			     : "=r"(val) :: "memory");
+		break;
+
+	default:
+		GUEST_FAIL("Invalid udf_mode");
+	}
+}
+
+static void guest_illegal_handler(struct ex_regs *regs)
+{
+	u64 esr = read_sysreg(esr_el2);
+
+	illegal_count++;
+	illegal_pstate = regs->pstate;
+
+	GUEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_ILL);
+	GUEST_ASSERT(esr & ESR_ELx_IL);
+	GUEST_ASSERT(regs->pstate & PSTATE_IL_BIT);
+	GUEST_ASSERT(!(regs->pstate & PSR_EXLOCK_BIT));
+	GUEST_ASSERT_EQ(regs->pc, expected_illegal_pc);
+
+	/* Disable exception locking so we can repair the return state. */
+	write_sysreg_s(0, SYS_GCSCR_EL2);
+	isb();
+
+	/* We need our own EXLOCK clearing so we can repair the original */
+	udf_mode = UDF_REPAIR;
+	asm volatile("udf #0" ::: "memory");
+
+	/* Disable EXLOCK for the generating context, making things legal */
+	regs->pstate &= ~(PSTATE_IL_BIT | PSR_EXLOCK_BIT);
+}
+
+static void guest_gcs_handler(struct ex_regs *regs)
+{
+	u64 esr = read_sysreg(esr_el2);
+
+	gcs_count++;
+
+	GUEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_GCS);
+	GUEST_ASSERT_EQ(FIELD_GET(ESR_ELx_ExType_MASK, esr),
+			ESR_ELx_ExType_EXLOCK);
+
+	/* Disabling EXLOCKEN makes sysreg writes legal. */
+	write_sysreg_s(0, SYS_GCSCR_EL2);
+	isb();
+}
+
+static noinline void test_udf_exception(bool enable_exlock)
+{
+	unsigned int initial_undef = undef_count;
+	unsigned int initial_illegal = illegal_count;
+	unsigned int initial_gcs = gcs_count;
+
+	expect_exlock = enable_exlock;
+	write_sysreg_s(enable_exlock ? GCSCR_ELx_EXLOCKEN : 0,
+		       SYS_GCSCR_EL2);
+	isb();
+
+	udf_mode = UDF_COLLECT;
+	asm volatile("udf #0" ::: "memory");
+
+	/* Leave GCS disabled even if a broken ERET skipped the ILL handler. */
+	write_sysreg_s(0, SYS_GCSCR_EL2);
+	isb();
+
+	GUEST_ASSERT_EQ(undef_count, initial_undef + 2 + enable_exlock);
+	GUEST_ASSERT_EQ(illegal_count, initial_illegal + enable_exlock);
+	GUEST_ASSERT_EQ(!!(handler_pstate & PSR_EXLOCK_BIT), enable_exlock);
+	if (enable_exlock)
+		GUEST_ASSERT(illegal_pstate & PSTATE_IL_BIT);
+	GUEST_ASSERT_EQ(initial_gcs, gcs_count);
+}
+
+static noinline void test_sysreg(enum udf_mode reg, bool enable_exlock)
+{
+	unsigned int initial_undef = undef_count;
+	unsigned int initial_gcs = gcs_count;
+
+	expect_exlock = enable_exlock;
+
+	write_sysreg_s(enable_exlock ? GCSCR_ELx_EXLOCKEN : 0,
+		       SYS_GCSCR_EL2);
+	isb();
+
+	udf_mode = reg;
+	asm volatile("udf #0" ::: "memory");
+
+	/* Ensure EXLOCK is disabled */
+	write_sysreg_s(0, SYS_GCSCR_EL2);
+	isb();
+
+	GUEST_ASSERT_EQ(gcs_count, initial_gcs + expect_exlock);
+	GUEST_ASSERT_EQ(undef_count, initial_undef + 1);
+}
+
+static void guest_code(void)
+{
+	GUEST_ASSERT_EQ(get_current_el(), 2);
+
+	/*
+	 * Try straightforwardly generating an exception without and
+	 * with EXLOCK.
+	 */
+	test_udf_exception(false);
+	test_sysreg(UDF_ELR_EL1, false);
+	test_sysreg(UDF_ELR_EL2, false);
+	test_sysreg(UDF_SPSR_EL1, false);
+	test_sysreg(UDF_SPSR_EL2, false);
+
+	test_udf_exception(true);
+	test_sysreg(UDF_ELR_EL1, true);
+	test_sysreg(UDF_ELR_EL2, true);
+	test_sysreg(UDF_SPSR_EL1, true);
+	test_sysreg(UDF_SPSR_EL2, true);
+
+	GUEST_DONE();
+}
+
+static void test_exception_from_same_el(void)
+{
+	struct kvm_vcpu_init init;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	vm = vm_create(1);
+	kvm_get_default_vcpu_target(vm, &init);
+	init.features[0] |= BIT(KVM_ARM_VCPU_HAS_EL2);
+	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
+	require_guest_gcs(vcpu);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_ELx_EC_UNKNOWN, guest_undef_handler);
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_ELx_EC_ILL, guest_illegal_handler);
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_ELx_EC_GCS, guest_gcs_handler);
+	kvm_arch_vm_finalize_vcpus(vm);
+
+	vcpu_run(vcpu);
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_DONE:
+		break;
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+		break;
+	default:
+		TEST_FAIL("Unhandled ucall: %ld", uc.cmd);
+	}
+
+	kvm_vm_free(vm);
+}
+
+static void test_exception_from_lower_el(void)
+{
+	struct kvm_vcpu_events events = {};
+	struct kvm_vcpu_init init;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	u64 pstate;
+
+	vm = vm_create(1);
+	kvm_get_default_vcpu_target(vm, &init);
+	init.features[0] |= BIT(KVM_ARM_VCPU_HAS_EL2);
+	vcpu = aarch64_vcpu_add(vm, 0, &init, NULL);
+	require_guest_gcs(vcpu);
+	kvm_arch_vm_finalize_vcpus(vm);
+
+	/*
+	 * Inject an EL0 data abort to vEL2 with EXLOCK enabled for
+	 * vEL2.
+	 */
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2),
+		     vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2)) |
+		     HCR_EL2_TGE);
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_GCSCR_EL2),
+		     GCSCR_ELx_EXLOCKEN);
+	vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pstate),
+		     PSR_MODE_EL0t | PSR_EXLOCK_BIT);
+
+	events.exception.ext_dabt_pending = true;
+	vcpu_events_set(vcpu, &events);
+
+	pstate = vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pstate));
+	TEST_ASSERT_EQ(pstate & PSR_MODE_MASK, PSR_MODE_EL2h);
+	TEST_ASSERT(!(pstate & PSR_EXLOCK_BIT),
+		    "EXLOCK set on exception from a lower EL");
+
+	kvm_vm_free(vm);
+}
+
+int main(void)
+{
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_ARM_EL2));
+	test_exception_from_same_el();
+	test_exception_from_lower_el();
+
+	return 0;
+}

-- 
2.47.3

