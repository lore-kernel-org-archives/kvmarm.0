Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9122DC32D
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 17:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995727; cv=none; b=NXYU22AZ9jshtzTjaj8OpaxS6F0UqmiEIqqPmhghjMdeqYNrYKOcxKOlC6tYVKCnMYwyovOz2d2M81mWszwq3MC1T6WIcrFTI/FOoZLkDJEaFSUVGmPmt3QatBv5IJJk0xRdQNwoGktful8wvDm+e5JCOtV9cLJFVaJFfuh94CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995727; c=relaxed/simple;
	bh=1t3p4l6Ca4NgCN79EvfMhcFLuq7V+n8vmzZLHLakfA8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NOXcWz2npaJMKuFFWDoFgGwhTg3GwYbgtVAmpkcEti+nAmLPWDAwN9rCBFmmw/bRBCXOMgXytG3OVKs8dICudVHBiJciWxcVgRZE4wonbo1QXW3WAeF6HEV7q0owstE1GbFafu1FPD9GwuTScpQqsGagOPaI+ajaMa+BpvauipU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RD/75GII; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RD/75GII"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751995722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oknfUDXso6xuTHsjmBmW6bkQxs+2JmxGzd8yzwNRhjg=;
	b=RD/75GIIJ2ZjhHmbz9qNBY8LIcnzyzcYAkCff9KGhQvRnflAoxPcsgtn16Yh/GVpe9u8ew
	uHTq8jg02KRx2vSNExgga90YQP6w3g1AejJ4NJRM5KSWhCDYn0bn6DjJEdUQ/7E9rA//TF
	x8Ew4wb72D5S5l13xeOjVnf4MCTEuPg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 24/27] KVM: arm64: selftests: Add basic SError injection test
Date: Tue,  8 Jul 2025 10:25:29 -0700
Message-Id: <20250708172532.1699409-25-oliver.upton@linux.dev>
In-Reply-To: <20250708172532.1699409-1-oliver.upton@linux.dev>
References: <20250708172532.1699409-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add tests for SError injection considering KVM is more directly involved
in delivery:

 - Pending SErrors are taken at the first CSE after SErrors are unmasked

 - Pending SErrors aren't taken and remain pending if SErrors are masked

 - Unmasked SErrors are taken immediately when injected (implementation
   detail)

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +-
 .../arm64/{mmio_abort.c => external_aborts.c} | 117 ++++++++++++++++--
 .../selftests/kvm/include/arm64/processor.h   |  10 ++
 3 files changed, 121 insertions(+), 8 deletions(-)
 rename tools/testing/selftests/kvm/arm64/{mmio_abort.c => external_aborts.c} (60%)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 38b95998e1e6..ce817a975e50 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -156,7 +156,7 @@ TEST_GEN_PROGS_arm64 += arm64/arch_timer_edge_cases
 TEST_GEN_PROGS_arm64 += arm64/debug-exceptions
 TEST_GEN_PROGS_arm64 += arm64/host_sve
 TEST_GEN_PROGS_arm64 += arm64/hypercalls
-TEST_GEN_PROGS_arm64 += arm64/mmio_abort
+TEST_GEN_PROGS_arm64 += arm64/external_aborts
 TEST_GEN_PROGS_arm64 += arm64/page_fault_test
 TEST_GEN_PROGS_arm64 += arm64/psci_test
 TEST_GEN_PROGS_arm64 += arm64/set_id_regs
diff --git a/tools/testing/selftests/kvm/arm64/mmio_abort.c b/tools/testing/selftests/kvm/arm64/external_aborts.c
similarity index 60%
rename from tools/testing/selftests/kvm/arm64/mmio_abort.c
rename to tools/testing/selftests/kvm/arm64/external_aborts.c
index 8b7a80a51b1c..f49c98bda60e 100644
--- a/tools/testing/selftests/kvm/arm64/mmio_abort.c
+++ b/tools/testing/selftests/kvm/arm64/external_aborts.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * mmio_abort - Tests for userspace MMIO abort injection
+ * external_abort - Tests for userspace external abort injection
  *
  * Copyright (c) 2024 Google LLC
  */
@@ -41,7 +41,7 @@ static struct kvm_vm *vm_create_with_dabt_handler(struct kvm_vcpu **vcpu, void *
 	return vm;
 }
 
-static void vcpu_inject_extabt(struct kvm_vcpu *vcpu)
+static void vcpu_inject_sea(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_events events = {};
 
@@ -49,7 +49,15 @@ static void vcpu_inject_extabt(struct kvm_vcpu *vcpu)
 	vcpu_events_set(vcpu, &events);
 }
 
-static void vcpu_run_expect_done(struct kvm_vcpu *vcpu)
+static void vcpu_inject_serror(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_events events = {};
+
+	events.exception.serror_pending = true;
+	vcpu_events_set(vcpu, &events);
+}
+
+static void __vcpu_run_expect(struct kvm_vcpu *vcpu, unsigned int cmd)
 {
 	struct ucall uc;
 
@@ -58,13 +66,24 @@ static void vcpu_run_expect_done(struct kvm_vcpu *vcpu)
 	case UCALL_ABORT:
 		REPORT_GUEST_ASSERT(uc);
 		break;
-	case UCALL_DONE:
-		break;
 	default:
+		if (uc.cmd == cmd)
+			return;
+
 		TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
 	}
 }
 
+static void vcpu_run_expect_done(struct kvm_vcpu *vcpu)
+{
+	__vcpu_run_expect(vcpu, UCALL_DONE);
+}
+
+static void vcpu_run_expect_sync(struct kvm_vcpu *vcpu)
+{
+	__vcpu_run_expect(vcpu, UCALL_SYNC);
+}
+
 extern char test_mmio_abort_insn;
 
 static void test_mmio_abort_guest(void)
@@ -95,7 +114,7 @@ static void test_mmio_abort(void)
 	TEST_ASSERT_EQ(run->mmio.len, sizeof(unsigned long));
 	TEST_ASSERT(!run->mmio.is_write, "Expected MMIO read");
 
-	vcpu_inject_extabt(vcpu);
+	vcpu_inject_sea(vcpu);
 	vcpu_run_expect_done(vcpu);
 	kvm_vm_free(vm);
 }
@@ -146,7 +165,88 @@ static void test_mmio_nisv_abort(void)
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_ARM_NISV);
 	TEST_ASSERT_EQ(run->arm_nisv.fault_ipa, MMIO_ADDR);
 
-	vcpu_inject_extabt(vcpu);
+	vcpu_inject_sea(vcpu);
+	vcpu_run_expect_done(vcpu);
+	kvm_vm_free(vm);
+}
+
+static void unexpected_serror_handler(struct ex_regs *regs)
+{
+	GUEST_FAIL("Took unexpected SError exception");
+}
+
+static void test_serror_masked_guest(void)
+{
+	GUEST_ASSERT(read_sysreg(isr_el1) & ISR_EL1_A);
+
+	isb();
+
+	GUEST_DONE();
+}
+
+static void test_serror_masked(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm = vm_create_with_dabt_handler(&vcpu, test_serror_masked_guest,
+							unexpected_dabt_handler);
+
+	vm_install_exception_handler(vm, VECTOR_ERROR_CURRENT, unexpected_serror_handler);
+
+	vcpu_inject_serror(vcpu);
+	vcpu_run_expect_done(vcpu);
+	kvm_vm_free(vm);
+}
+
+static void expect_serror_handler(struct ex_regs *regs)
+{
+	GUEST_DONE();
+}
+
+static void test_serror_guest(void)
+{
+	GUEST_ASSERT(read_sysreg(isr_el1) & ISR_EL1_A);
+
+	local_serror_enable();
+	isb();
+	local_serror_disable();
+
+	GUEST_FAIL("Should've taken pending SError exception");
+}
+
+static void test_serror(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm = vm_create_with_dabt_handler(&vcpu, test_serror_guest,
+							unexpected_dabt_handler);
+
+	vm_install_exception_handler(vm, VECTOR_ERROR_CURRENT, expect_serror_handler);
+
+	vcpu_inject_serror(vcpu);
+	vcpu_run_expect_done(vcpu);
+	kvm_vm_free(vm);
+}
+
+static void test_serror_emulated_guest(void)
+{
+	GUEST_ASSERT(!(read_sysreg(isr_el1) & ISR_EL1_A));
+
+	local_serror_enable();
+	GUEST_SYNC(0);
+	local_serror_disable();
+
+	GUEST_FAIL("Should've taken unmasked SError exception");
+}
+
+static void test_serror_emulated(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm = vm_create_with_dabt_handler(&vcpu, test_serror_emulated_guest,
+							unexpected_dabt_handler);
+
+	vm_install_exception_handler(vm, VECTOR_ERROR_CURRENT, expect_serror_handler);
+
+	vcpu_run_expect_sync(vcpu);
+	vcpu_inject_serror(vcpu);
 	vcpu_run_expect_done(vcpu);
 	kvm_vm_free(vm);
 }
@@ -156,4 +256,7 @@ int main(void)
 	test_mmio_abort();
 	test_mmio_nisv();
 	test_mmio_nisv_abort();
+	test_serror();
+	test_serror_masked();
+	test_serror_emulated();
 }
diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index b0fc0f945766..255fed769a8a 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -254,6 +254,16 @@ static inline void local_irq_disable(void)
 	asm volatile("msr daifset, #3" : : : "memory");
 }
 
+static inline void local_serror_enable(void)
+{
+	asm volatile("msr daifclr, #4" : : : "memory");
+}
+
+static inline void local_serror_disable(void)
+{
+	asm volatile("msr daifset, #4" : : : "memory");
+}
+
 /**
  * struct arm_smccc_res - Result from SMC/HVC call
  * @a0-a3 result values from registers 0 to 3
-- 
2.39.5

