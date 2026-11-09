Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.68
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794214180;
	b=TToxn66eH6D3v7RxC4umwtp17lxyfjZONVj9Fip130fVNZtAFEfcj0Ck43EK6dObr6jn
	 433mxb9oOjlXhLwti44gw1ymo83W/xFFgtbUE9iF8fwT4TKUvvjen2ubF05adbNfYHbZF
	 3BexbsCITegnMUViW/yU+ngwYezAY4XavVtsFFgOEY+VLfcOjTsqKG35twpLPWQYJaoyR
	 rp2EX4i3zp0zB11EJAS7gLzSyQWb5Ux+sd4l5Hw60Cg+Jsw8+2br+NCh0wpBs3jcScD5/
	 Lm5bUNog+Cko6aLuD6LadYCQg0zy3O2uyvF2iYSOZn18yav4MYi8YR8LGTwEp919eBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794214180;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=uWThlNDxx8k9coc2dZrQvIwrgPoJzUnjIpsnGUgbQxc=;
	b=EppmwEPDby5QoK3uotcf+UmAIuTJu4iuQm8qLkOEHH+9M6EOgrN6vmnIIBHQSklT7b8n
	 RQwJpkxXKNtpDFT5ft74wufQlrrOiN8rh/Zav2hIPyls7leM5TVwc1J705A0vu+9iOyke
	 3ddH5vhurCML0hZppc3Lf1uOeqF1/yeyIP1iLCW3eFkWOm1YWS4crFJ7BFSGJlPNcB6dq
	 qYB6yAK9SMX+MRIXA8Ti8X6QbE/UK9byJtyjVmEQDFadvcoc8viZh7XFEkfw01Tn5p6l8
	 GuuPIi52vEzBMft4lx2KzuxNicjuBZH2lzBbymiCWrYFnBgfqwWinFdJKgDteEqSLEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cJxh6rnL;
	arc=none smtp.remote-ip=91.218.175.68
Received: from mta0.migadu.com (out-68.mta0.migadu.com [91.218.175.68])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E256B60A2604
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:49:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E256B60A2604
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cJxh6rnL
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=tieCJB5xPHFID0PWIkTmfQAHSOPwOh5HA6tVxBq05s0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794214178; v=1; x=1794818978;
 b=cJxh6rnLXbxCuZPqeeBmne21czp+pycWMjO0JRGvpH6KqJB+PFnvqTX8giIRVm/+DKCn3PR0
 STh/LXHDuWfcyuZgmU4tR0QKv68PXP1N748qHX3nsQC3d6J+uEU3BA1yxbpyV9VDHCnl+69UENT
 sWp1j76O+mDnUvM24J3XKB7U=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 7e8d9e8db2fd6fbd;
	Mon, 09 Nov 2026 08:49:37 +0000
X-Mizu-Trace-ID: 7e8d9e8db2fd6fbd
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 14/19] KVM: arm64: selftests: Add pkvm_irq interrupt test
Date: Mon,  9 Nov 2026 08:48:49 +0000
Message-ID: <20261109084854.840576-15-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261109084854.840576-1-fuad.tabba@linux.dev>
References: <20261109084854.840576-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The host emulates a protected guest's vGIC, so EL2 copies the list
registers to and from the host each time the host runs the vCPU. EL2
also keeps its own copy of the guest's virtual timer state, which the
host can't change.

Check that the virtual timer's PPI arrives exactly once, with CVAL and
CTL kept across exits, that SGIs pass between two vCPUs, and that the
timer wakes a vCPU in WFI.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm     |   1 +
 tools/testing/selftests/kvm/arm64/pkvm_irq.c | 268 +++++++++++++++++++
 2 files changed, 269 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_irq.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 1e40e793aa6f3..13998964facd5 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -192,6 +192,7 @@ TEST_GEN_PROGS_arm64 += arm64/mmio_sign_ext
 TEST_GEN_PROGS_arm64 += arm64/page_fault_test
 TEST_GEN_PROGS_arm64 += arm64/pkvm_host_abi
 TEST_GEN_PROGS_arm64 += arm64/pkvm_id_regs
+TEST_GEN_PROGS_arm64 += arm64/pkvm_irq
 TEST_GEN_PROGS_arm64 += arm64/pkvm_mem_share
 TEST_GEN_PROGS_arm64 += arm64/pkvm_psci
 TEST_GEN_PROGS_arm64 += arm64/pkvm_smccc
diff --git a/tools/testing/selftests/kvm/arm64/pkvm_irq.c b/tools/testing/selftests/kvm/arm64/pkvm_irq.c
new file mode 100644
index 0000000000000..f92fa6f0de8de
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/pkvm_irq.c
@@ -0,0 +1,268 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pkvm_irq - the virtual timer's PPI and SGIs in a protected VM.
+ *
+ * Copyright (C) 2026 Google LLC
+ * Author: Fuad Tabba <fuad.tabba@linux.dev>
+ */
+
+#include <pthread.h>
+
+#include <linux/bitfield.h>
+#include <linux/psci.h>
+#include <asm/cputype.h>
+
+#include "arch_timer.h"
+#include "gic.h"
+#include "gic_v3.h"
+#include "kvm_util.h"
+#include "pkvm.h"
+#include "processor.h"
+#include "test_util.h"
+
+#define TIMER_MS	10
+#define WAIT_MS		30000
+#define NR_EXITS	16
+#define SGI_ROUNDS	16
+
+#define SGI_PING	1
+#define SGI_PONG	2
+
+/* Set in the guest's copy by the host before the first run. */
+static u32 vtimer_irq;
+static u64 boot_entry;
+static u64 vcpu_mpidr[2];
+static u64 vcpu_ctx[2];
+
+static u32 irqs[2];
+static u32 last_intid[2];
+static u32 ready;
+
+#define wait_until(cond)							\
+do {										\
+	u64 __end = timer_get_cntct(VIRTUAL) + msec_to_cycles(WAIT_MS);	\
+										\
+	while (!(cond))								\
+		__GUEST_ASSERT(timer_get_cntct(VIRTUAL) < __end,		\
+			       "timed out waiting for %s", #cond);		\
+} while (0)
+
+static void guest_irq_handler(struct ex_regs *regs)
+{
+	u32 intid = gic_get_and_ack_irq();
+	u32 cpu = guest_get_vcpuid();
+
+	if (intid == IAR_SPURIOUS)
+		return;
+
+	if (intid == vtimer_irq) {
+		__GUEST_ASSERT(timer_get_ctl(VIRTUAL) & CTL_ISTATUS, "CNTV_CTL 0x%x",
+			       timer_get_ctl(VIRTUAL));
+		GUEST_ASSERT(timer_get_cntct(VIRTUAL) >= timer_get_cval(VIRTUAL));
+		/* Mask the timer before the EOI, or its level-sensitive PPI is taken again. */
+		timer_set_ctl(VIRTUAL, CTL_IMASK);
+	}
+
+	WRITE_ONCE(last_intid[cpu], intid);
+	gic_set_eoi(intid);
+	WRITE_ONCE(irqs[cpu], irqs[cpu] + 1);
+}
+
+static void guest_irq_init(unsigned int nr_cpus)
+{
+	local_irq_disable();
+	pkvm_guest_init();
+	gic_init(GIC_V3, nr_cpus);
+}
+
+static u64 start_vtimer(void)
+{
+	u64 cval = timer_get_cntct(VIRTUAL) + msec_to_cycles(TIMER_MS);
+
+	gic_irq_enable(vtimer_irq);
+	timer_set_cval(VIRTUAL, cval);
+	timer_set_ctl(VIRTUAL, CTL_ENABLE);
+	return cval;
+}
+
+static void guest_vtimer(void)
+{
+	u64 cval;
+	int i;
+
+	guest_irq_init(1);
+	cval = start_vtimer();
+
+	/* Exits before the timer fires, then with its interrupt pending but masked. */
+	for (i = 0; i < NR_EXITS; i++)
+		GUEST_SYNC(i);
+	wait_until(timer_get_ctl(VIRTUAL) & CTL_ISTATUS);
+	for (i = 0; i < NR_EXITS; i++)
+		GUEST_SYNC(i);
+
+	GUEST_ASSERT_EQ(timer_get_cval(VIRTUAL), cval);
+	GUEST_ASSERT_EQ(timer_get_ctl(VIRTUAL), CTL_ENABLE | CTL_ISTATUS);
+	GUEST_ASSERT_EQ(READ_ONCE(irqs[0]), 0);
+
+	local_irq_enable();
+	wait_until(READ_ONCE(irqs[0]));
+
+	/* The EOI must reach the host, or it presents the interrupt again. */
+	for (i = 0; i < NR_EXITS; i++)
+		GUEST_SYNC(i);
+	local_irq_disable();
+
+	GUEST_ASSERT_EQ(READ_ONCE(irqs[0]), 1);
+	GUEST_ASSERT_EQ(READ_ONCE(last_intid[0]), vtimer_irq);
+	GUEST_DONE();
+}
+
+static void send_sgi(int id, u32 intid)
+{
+	u64 mpidr = vcpu_mpidr[id];
+
+	/* The target reads this vCPU's counters once it has taken the SGI. */
+	dsb(ishst);
+	write_sysreg_s(FIELD_PREP(ICC_SGI1R_SGI_ID_MASK, intid) |
+		       FIELD_PREP(ICC_SGI1R_AFFINITY_1_MASK, MPIDR_AFFINITY_LEVEL(mpidr, 1)) |
+		       FIELD_PREP(ICC_SGI1R_TARGET_LIST_MASK, BIT(MPIDR_AFFINITY_LEVEL(mpidr, 0))),
+		       SYS_ICC_SGI1R_EL1);
+	isb();
+}
+
+static void guest_sgi_primary(void)
+{
+	u32 k;
+
+	guest_irq_init(2);
+	gic_irq_enable(SGI_PONG);
+
+	GUEST_ASSERT_EQ(pkvm_hvc(PSCI_0_2_FN64_CPU_ON, vcpu_mpidr[1], boot_entry, vcpu_ctx[1]),
+			PSCI_RET_SUCCESS);
+	wait_until(READ_ONCE(ready));
+
+	local_irq_enable();
+	for (k = 1; k <= SGI_ROUNDS; k++) {
+		send_sgi(1, SGI_PING);
+
+		/* vCPU 1 sends PONG only once it has taken PING, so neither is in flight. */
+		wait_until(READ_ONCE(irqs[0]) >= k);
+		GUEST_ASSERT_EQ(READ_ONCE(irqs[0]), k);
+		GUEST_ASSERT_EQ(READ_ONCE(irqs[1]), k);
+		GUEST_ASSERT_EQ(READ_ONCE(last_intid[0]), SGI_PONG);
+		GUEST_ASSERT_EQ(READ_ONCE(last_intid[1]), SGI_PING);
+	}
+	local_irq_disable();
+
+	GUEST_DONE();
+}
+
+/* The primary's guest_irq_init() set up ucall and the distributor. */
+static void guest_sgi_secondary(void)
+{
+	u32 k;
+
+	gic_init(GIC_V3, 2);
+	gic_irq_enable(SGI_PING);
+	local_irq_enable();
+	WRITE_ONCE(ready, 1);
+
+	for (k = 1; k <= SGI_ROUNDS; k++) {
+		wait_until(READ_ONCE(irqs[1]) >= k);
+		send_sgi(0, SGI_PONG);
+	}
+	local_irq_disable();
+
+	GUEST_DONE();
+}
+
+static void guest_wfi(void)
+{
+	guest_irq_init(1);
+	start_vtimer();
+
+	/* WFI can complete before the timer fires, so wait in it until the handler has run. */
+	while (!READ_ONCE(irqs[0])) {
+		wfi();
+		local_irq_enable();
+		isb(); /* handle IRQ */
+		local_irq_disable();
+	}
+
+	GUEST_ASSERT_EQ(READ_ONCE(irqs[0]), 1);
+	GUEST_ASSERT_EQ(READ_ONCE(last_intid[0]), vtimer_irq);
+	GUEST_DONE();
+}
+
+static void irq_vm_setup(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT, guest_irq_handler);
+	write_guest_global(vm, vtimer_irq, vcpu_get_vtimer_irq(vcpu));
+}
+
+static void test_one_vcpu(void *guest_code)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = pkvm_vm_create_with_one_vcpu(&vcpu, guest_code);
+	irq_vm_setup(vm, vcpu);
+
+	pkvm_run_loop(vcpu, NULL);
+
+	kvm_vm_free(vm);
+}
+
+static void wire_mpidr(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+	u64 mpidr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1));
+
+	write_guest_global(vm, vcpu_mpidr[vcpu->id], mpidr & MPIDR_HWID_BITMASK);
+}
+
+static void *vcpu_thread(void *vcpu)
+{
+	pkvm_run_loop(vcpu, NULL);
+	return NULL;
+}
+
+static void test_sgi(void)
+{
+	struct kvm_vcpu *vcpus[2];
+	pthread_t thread;
+	struct kvm_vm *vm;
+	gpa_t ctx;
+
+	vm = pkvm_vm_create(2, 0, vcpus);
+	irq_vm_setup(vm, vcpus[0]);
+
+	pkvm_vcpu_setup_boot(vcpus[0], guest_sgi_primary);
+	wire_mpidr(vm, vcpus[0]);
+	wire_mpidr(vm, vcpus[1]);
+	write_guest_global(vm, boot_entry, pkvm_idmap_gpa(vm));
+	ctx = pkvm_vcpu_setup_boot_secondary(vcpus[1], guest_sgi_secondary);
+	write_guest_global(vm, vcpu_ctx[1], ctx);
+
+	pthread_create(&thread, NULL, vcpu_thread, vcpus[1]);
+	pkvm_run_loop(vcpus[0], NULL);
+	pthread_join(thread, NULL);
+
+	kvm_vm_free(vm);
+}
+
+int main(void)
+{
+	TEST_REQUIRE(pkvm_supported());
+
+	ksft_print_header();
+	ksft_set_plan(3);
+
+	test_one_vcpu(guest_vtimer);
+	ksft_test_result_pass("virtual timer PPI across exits\n");
+	test_sgi();
+	ksft_test_result_pass("SGIs between two vCPUs: %d rounds\n", SGI_ROUNDS);
+	test_one_vcpu(guest_wfi);
+	ksft_test_result_pass("the virtual timer wakes a vCPU waiting in WFI\n");
+
+	ksft_finished();
+}
-- 
2.47.3

