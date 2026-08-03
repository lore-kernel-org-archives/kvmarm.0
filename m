Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27D6381AE5;
	Mon,  3 Aug 2026 23:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785798875; cv=none; b=i4gbK9WhnSsr7K66fy4TxQEuazNsql+2Fb877QL+eUbgTFrg690O24cIhbv98jAAGSTXYGDoPxSTbL/Eli3jDX5lWlm/icj1Pf1SO8EI5VVxJDl2H63GAw+AaklAZK4yFMORJ3wrG89IAnKKikeUTt+U6UmI21Kkf+vM23Ad/Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785798875; c=relaxed/simple;
	bh=DwJtjT1vSlZeZxuU+9RDgebOB5WNzjn6/ElXQEH8V8M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=otWFHNPuj4Y3QBfMjuP0Ss216XatuSVwtBSOy1YBmMh5ulcuEgmbExHBU/81bqoLmsdox1LERj4+AkJP7MERvJGWnmGbxSQmZnS8qoLW+P+F65IHAu1/g3BWU+xB2m2XOFrbc7zMdj1NufjUdoKMAOvsdpc7Ykh3Noj4TRW7c5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S6Cgizc/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S6Cgizc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA751F00A3E;
	Mon,  3 Aug 2026 23:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785798869;
	bh=rSLVHAhxiSgANRKTbzv5cRB5sohf+4NfYORirm8Wnl4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=S6Cgizc/xuEu3XPUrMCe8dJhDOEf3e8WJr0K0iePNYmTVx6WaGc4XtBsGyu4qdZe5
	 heOyVxteeYXwQu1tVPO/CWh8qWYH8OWsVf/4dNtZ4XgzvGmtVsPmpIdkV6sVvo8kip
	 tnvT8UqGxAx5LU/+DM8JTGA7U1F00w4Y7GPG2+ZNX/eGsxEIB/atOhQbhyHA4Z/y9i
	 XhtWD0FaNiF1A5KoB6kECsAa/k76WuvzCZKCUoM1hsMrTS8htd2qq8TeJlxdz71RZn
	 kHs9nHE2EH1UUnBm6YIeB3PQEUSfjMsG4Cl6kqkZS7GMDDDQXlf01UmjrCTLENmg9y
	 MqgwwgI4tN1rg==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 03 Aug 2026 23:56:59 +0100
Subject: [PATCH v18 14/14] KVM: selftests: arm64: Add GCS EXLOCK exception
 emulation test
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260803-arm64-gcs-v18-14-fd8c40f5ad88@kernel.org>
References: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
In-Reply-To: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=11852; i=broonie@kernel.org;
 h=from:subject:message-id; bh=DwJtjT1vSlZeZxuU+9RDgebOB5WNzjn6/ElXQEH8V8M=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqcSCk4kCYwz6yfjuB2x3RXs3Sy7VZa4/+VjKXJ
 bbDK+mMk7CJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCanEgpAAKCRAk1otyXVSH
 0ElcB/sEnyxe2G2Js4rRGKRrrnYGFBC57xu9oCaEnTnIWDaNPIu8fkYcjoDm3WFdjOV9J8bvuaR
 u+0k3Sl+GMhpsV2u1JK3pkLYG75LVbHLZJ7QZwgqvef3UX16cG1AlU7oaC5W3SonJVgqDAZJGS9
 VVqd8NcMzt1AwtrPntE+HIiDtkUUR/b6CK3Vu8Xri1buEqljIoHTi1+E1roRoW+bFzk2VfhcR8K
 dsSDnLaWcqbyU476eJ7VpkYVxG3FT+WR+q8pGxv5EQWswZFcJf9KshY3Ng64llX97d1ZjF5hkyA
 fM1kBioIF5jNuLtVS2swlO6DhaPOpKsaxTRXJVgjF0wULOYd
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
---
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 tools/testing/selftests/kvm/arm64/gcs_exceptions.c | 346 +++++++++++++++++++++
 2 files changed, 347 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 6fc34e9bf8e1..0200dd477ffe 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -174,6 +174,7 @@ TEST_GEN_PROGS_arm64 += arm64/hello_el2
 TEST_GEN_PROGS_arm64 += arm64/host_sve
 TEST_GEN_PROGS_arm64 += arm64/hypercalls
 TEST_GEN_PROGS_arm64 += arm64/external_aborts
+TEST_GEN_PROGS_arm64 += arm64/gcs_exceptions
 TEST_GEN_PROGS_arm64 += arm64/mmio_sign_ext
 TEST_GEN_PROGS_arm64 += arm64/page_fault_test
 TEST_GEN_PROGS_arm64 += arm64/psci_test
diff --git a/tools/testing/selftests/kvm/arm64/gcs_exceptions.c b/tools/testing/selftests/kvm/arm64/gcs_exceptions.c
new file mode 100644
index 000000000000..de5bc6590727
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/gcs_exceptions.c
@@ -0,0 +1,346 @@
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
+	/* Force ERET directly through the slow emulation path as well. */
+	sysreg_clear_set_s(SYS_HFGITR_EL2, 0, HFGITR_EL2_ERET);
+	isb();
+
+	test_udf_exception(false);
+
+	test_udf_exception(true);
+
+	sysreg_clear_set_s(SYS_HFGITR_EL2, HFGITR_EL2_ERET, 0);
+	isb();
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

