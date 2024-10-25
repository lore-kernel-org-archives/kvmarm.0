Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A42D21443E
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 20:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729888286; cv=none; b=Ky53JbaVaHj404V9B+PDwyXKyupAwWibf9xdNP+EAnhfaHgls2xkta0E2G+GthC8B3OHxkOQV7B1BpQAZL5ig3TQo+xgYBxsrDcpau/P5eXFtvKn/rGQLr2eL1Pg51g4As6m6j8D9QYytp0D2bIi5uo4MIm+5CpdUpaEoNhAeio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729888286; c=relaxed/simple;
	bh=J1z6BJX+e2Ui0O3aCmEHW5KdDVvfgENDAtxgoh0Lk7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIt2d3d3ly+5CIlDCLIAwQnj2k4dXw7a2XJyNOzc8u5wQsN1ATLf7NT95d3ju4vwiQVo3XfLAiceoioI5lIgHTWCI3PsMCflMp8xivBX/JjbIqobrabYSEWMyJIkCdbWXD9G5kBlY+ojeUhvro4T8Toz5kgBOO1zRs6fC7Zr1d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OHfOsaT9; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OHfOsaT9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729888282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iuadspXVMOh3Pam3DlhhqVgk1VOTyFtbXJwKvw8+pWY=;
	b=OHfOsaT9nMN3OtfAUJTHF+WyEu+GGLbfHvvWbnhTUb8ICp2MQbSmrmDw7pAPsS5mntCg6D
	q7YXSk7fSFUORj5gW89hXoPSnkN+XPueDB4B8OJjhIQ2f0iQAeIQfT70TsdhsR5tezC5TH
	o0k70wHQ0/dBsMRiJFiRf3fD9er5cb4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 3/4] KVM: arm64: selftests: Convert to kernel's ESR terminology
Date: Fri, 25 Oct 2024 20:31:05 +0000
Message-ID: <20241025203106.3529261-4-oliver.upton@linux.dev>
In-Reply-To: <20241025203106.3529261-1-oliver.upton@linux.dev>
References: <20241025203106.3529261-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Drop the KVM selftests specific flavoring of ESR in favor of the kernel
header.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../selftests/kvm/aarch64/debug-exceptions.c      | 10 +++++-----
 tools/testing/selftests/kvm/aarch64/no-vgic-v3.c  |  2 +-
 .../selftests/kvm/aarch64/page_fault_test.c       |  4 ++--
 .../selftests/kvm/aarch64/vpmu_counter_access.c   | 12 ++++++------
 .../selftests/kvm/include/aarch64/processor.h     | 15 ++-------------
 .../testing/selftests/kvm/lib/aarch64/processor.c |  6 +++---
 6 files changed, 19 insertions(+), 30 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 2582c49e525a..ff7a949fc96a 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -433,15 +433,15 @@ static void test_guest_debug_exceptions(uint8_t bpn, uint8_t wpn, uint8_t ctx_bp
 	vcpu_init_descriptor_tables(vcpu);
 
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
-				ESR_EC_BRK_INS, guest_sw_bp_handler);
+				ESR_ELx_EC_BRK64, guest_sw_bp_handler);
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
-				ESR_EC_HW_BP_CURRENT, guest_hw_bp_handler);
+				ESR_ELx_EC_BREAKPT_CUR, guest_hw_bp_handler);
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
-				ESR_EC_WP_CURRENT, guest_wp_handler);
+				ESR_ELx_EC_WATCHPT_CUR, guest_wp_handler);
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
-				ESR_EC_SSTEP_CURRENT, guest_ss_handler);
+				ESR_ELx_EC_SOFTSTP_CUR, guest_ss_handler);
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
-				ESR_EC_SVC64, guest_svc_handler);
+				ESR_ELx_EC_SVC64, guest_svc_handler);
 
 	/* Specify bpn/wpn/ctx_bpn to be tested */
 	vcpu_args_set(vcpu, 3, bpn, wpn, ctx_bpn);
diff --git a/tools/testing/selftests/kvm/aarch64/no-vgic-v3.c b/tools/testing/selftests/kvm/aarch64/no-vgic-v3.c
index 943d65fc6b0b..58304bbc2036 100644
--- a/tools/testing/selftests/kvm/aarch64/no-vgic-v3.c
+++ b/tools/testing/selftests/kvm/aarch64/no-vgic-v3.c
@@ -150,7 +150,7 @@ static void test_guest_no_gicv3(void)
 	vcpu_init_descriptor_tables(vcpu);
 
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
-				ESR_EC_UNKNOWN, guest_undef_handler);
+				ESR_ELx_EC_UNKNOWN, guest_undef_handler);
 
 	test_run_vcpu(vcpu);
 
diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index d29b08198b42..ec33a8f9c908 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -544,9 +544,9 @@ static void setup_abort_handlers(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 	vcpu_init_descriptor_tables(vcpu);
 
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
-				ESR_EC_DABT, no_dabt_handler);
+				ESR_ELx_EC_DABT_CUR, no_dabt_handler);
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
-				ESR_EC_IABT, no_iabt_handler);
+				ESR_ELx_EC_IABT_CUR, no_iabt_handler);
 }
 
 static void setup_gva_maps(struct kvm_vm *vm)
diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
index d31b9f64ba14..f9c0c86d7e85 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -300,7 +300,7 @@ static void guest_sync_handler(struct ex_regs *regs)
 	uint64_t esr, ec;
 
 	esr = read_sysreg(esr_el1);
-	ec = (esr >> ESR_EC_SHIFT) & ESR_EC_MASK;
+	ec = ESR_ELx_EC(esr);
 
 	__GUEST_ASSERT(expected_ec == ec,
 			"PC: 0x%lx; ESR: 0x%lx; EC: 0x%lx; EC expected: 0x%lx",
@@ -338,10 +338,10 @@ static void test_access_invalid_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
 	 * Reading/writing the event count/type registers should cause
 	 * an UNDEFINED exception.
 	 */
-	TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->read_cntr(pmc_idx));
-	TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->write_cntr(pmc_idx, 0));
-	TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->read_typer(pmc_idx));
-	TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->write_typer(pmc_idx, 0));
+	TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->read_cntr(pmc_idx));
+	TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->write_cntr(pmc_idx, 0));
+	TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->read_typer(pmc_idx));
+	TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->write_typer(pmc_idx, 0));
 	/*
 	 * The bit corresponding to the (unimplemented) counter in
 	 * {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers should be RAZ.
@@ -425,7 +425,7 @@ static void create_vpmu_vm(void *guest_code)
 
 	vpmu_vm.vm = vm_create(1);
 	vm_init_descriptor_tables(vpmu_vm.vm);
-	for (ec = 0; ec < ESR_EC_NUM; ec++) {
+	for (ec = 0; ec < ESR_ELx_EC_MAX + 1; ec++) {
 		vm_install_sync_handler(vpmu_vm.vm, VECTOR_SYNC_CURRENT, ec,
 					guest_sync_handler);
 	}
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index de977d131082..1e8d0d531fbd 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -12,6 +12,8 @@
 
 #include <linux/stringify.h>
 #include <linux/types.h>
+#include <asm/brk-imm.h>
+#include <asm/esr.h>
 #include <asm/sysreg.h>
 
 
@@ -100,19 +102,6 @@ enum {
 			   (v) == VECTOR_SYNC_LOWER_64    || \
 			   (v) == VECTOR_SYNC_LOWER_32)
 
-#define ESR_EC_NUM		64
-#define ESR_EC_SHIFT		26
-#define ESR_EC_MASK		(ESR_EC_NUM - 1)
-
-#define ESR_EC_UNKNOWN		0x0
-#define ESR_EC_SVC64		0x15
-#define ESR_EC_IABT		0x21
-#define ESR_EC_DABT		0x25
-#define ESR_EC_HW_BP_CURRENT	0x31
-#define ESR_EC_SSTEP_CURRENT	0x33
-#define ESR_EC_WP_CURRENT	0x35
-#define ESR_EC_BRK_INS		0x3c
-
 /* Access flag */
 #define PTE_AF			(1ULL << 10)
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index fe4dc3693112..698e34f39241 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -450,7 +450,7 @@ void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
 }
 
 struct handlers {
-	handler_fn exception_handlers[VECTOR_NUM][ESR_EC_NUM];
+	handler_fn exception_handlers[VECTOR_NUM][ESR_ELx_EC_MAX + 1];
 };
 
 void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu)
@@ -469,7 +469,7 @@ void route_exception(struct ex_regs *regs, int vector)
 	switch (vector) {
 	case VECTOR_SYNC_CURRENT:
 	case VECTOR_SYNC_LOWER_64:
-		ec = (read_sysreg(esr_el1) >> ESR_EC_SHIFT) & ESR_EC_MASK;
+		ec = ESR_ELx_EC(read_sysreg(esr_el1));
 		valid_ec = true;
 		break;
 	case VECTOR_IRQ_CURRENT:
@@ -508,7 +508,7 @@ void vm_install_sync_handler(struct kvm_vm *vm, int vector, int ec,
 
 	assert(VECTOR_IS_SYNC(vector));
 	assert(vector < VECTOR_NUM);
-	assert(ec < ESR_EC_NUM);
+	assert(ec <= ESR_ELx_EC_MAX);
 	handlers->exception_handlers[vector][ec] = handler;
 }
 
-- 
2.47.0.163.g1226f6d8fa-goog

