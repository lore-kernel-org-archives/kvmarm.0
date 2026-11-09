Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.195
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794214160;
	b=2CdfifNSgBP+ai89su+Pqi//P0GkiA8qZQCOt/Rs8C/I45PpnWYx88c/lHM9+r+LYgEg
	 A3VhXKSmcRYgLG68Ef6k855dvzKB0n+w02K2Gd9ibvygqSdBMh97VBMd4wXhQSs+xzdZ2
	 FqlQN2wKnCIsni+8TbipJVBSW/ojCyrZg6Fo/Q+4RMTIcuSI2JCiWDOkNdYwMCnx5wpN7
	 JyZoqid85mfZ76gv4C0NrH8yj196Fij/pNKxoznXsR4EFAc/zwtRrS7EpwCLWMX6JBH/5
	 GHraYjtiez1oB1cTTDQrm0AOZcOgw9ZaZDZDDk+JXgNB5Yp7fmUsYDAcGxw3vOI6FZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794214160;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=PScvHOQ3ffdnb6c8tcOkC4y8umwsL2e755PwQfDoa90=;
	b=fitQpI7D3fPa1EQtllwINCxCpVRga1OMRz4aQbAYR5e+hpF99/NJbYG3WxR02p+DeiXt
	 xd0YC8bn7yu5kC/2ck++MBLfeLVxN8gqP2T7W81+BGaJIz9LNcV6QhwCKAjgPsXTS66oS
	 Z1IrXZcA0GkSVZUwC4tmxQuSfZsL+uu8X2RNaq7RQFdhMk03sCXQdt1cxfRzwEusINov4
	 YfG39BuksIrm6gPPlbl011lQqpeqwEnKi+K793SmmPjKwUMIpMSBzWCXTamOH/i+PpZEQ
	 xrmlaokMnE2mpkvJBQPeSGVFnl99wl6/yW4TUfyN9OaGU04ih94hx+Ifp976/eAqcxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BgYzHjFk;
	arc=none smtp.remote-ip=95.215.58.195
Received: from mta1.migadu.com (out-195.mta1.migadu.com [95.215.58.195])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C836082BD3
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:49:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56C836082BD3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BgYzHjFk
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=QZWBvcDRGV/xtsKtLZc/xaZffVJhDyA/CSHexf6Hl2Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794214157; v=1; x=1794818957;
 b=BgYzHjFkgMl1oVo9PbSsXyiULI5GwrlTJgZ47e0tRodnnAduFiwKmNGauquNavrxZMaG4MtB
 4NV/sbgEEQTJJ8tuG7qPzD4i5scxRQPEfNb7osucc48cTVogOb92WJM0Az3UVf5bvdL0zCX8CT/
 m/9moOuq5+wZp3h2ELkLFuis=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id dfb0c0fa227caa98;
	Mon, 09 Nov 2026 08:49:17 +0000
X-Mizu-Trace-ID: dfb0c0fa227caa98
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
Subject: [PATCH v2 09/19] KVM: arm64: selftests: Add pkvm_psci multi-vCPU PSCI test
Date: Mon,  9 Nov 2026 08:48:44 +0000
Message-ID: <20261109084854.840576-10-fuad.tabba@linux.dev>
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

EL2 handles a protected guest's CPU_ON, CPU_OFF, PSCI_VERSION and
PSCI_FEATURES, and forwards the rest to the host. So only the guest
can power on its vCPUs.

Test each PSCI call, and that the host can't make a secondary runnable
without a CPU_ON from the guest. Run the secondaries on their own
threads to race CPU_ON against CPU_OFF and against another CPU_ON. A
CPU_ON of a vCPU that has called CPU_OFF returns ALREADY_ON until
the host powers it off.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 tools/testing/selftests/kvm/arm64/pkvm_psci.c | 632 ++++++++++++++++++
 2 files changed, 633 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_psci.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 42e530e0e573b..aa256fb66d226 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -191,6 +191,7 @@ TEST_GEN_PROGS_arm64 += arm64/external_aborts
 TEST_GEN_PROGS_arm64 += arm64/mmio_sign_ext
 TEST_GEN_PROGS_arm64 += arm64/page_fault_test
 TEST_GEN_PROGS_arm64 += arm64/pkvm_host_abi
+TEST_GEN_PROGS_arm64 += arm64/pkvm_psci
 TEST_GEN_PROGS_arm64 += arm64/psci_test
 TEST_GEN_PROGS_arm64 += arm64/sea_to_user
 TEST_GEN_PROGS_arm64 += arm64/set_id_regs
diff --git a/tools/testing/selftests/kvm/arm64/pkvm_psci.c b/tools/testing/selftests/kvm/arm64/pkvm_psci.c
new file mode 100644
index 0000000000000..07a50af9c9ad9
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/pkvm_psci.c
@@ -0,0 +1,632 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pkvm_psci - PSCI in a protected VM, including CPU_ON racing CPU_OFF and CPU_ON.
+ *
+ * Copyright (C) 2025 Google LLC
+ * Author: Fuad Tabba <fuad.tabba@linux.dev>
+ */
+
+#include <pthread.h>
+
+#include <linux/bitfield.h>
+#include <linux/psci.h>
+#include <asm/barrier.h>
+#include <asm/cputype.h>
+
+#include "arch_timer.h"
+#include "kvm_util.h"
+#include "pkvm.h"
+#include "processor.h"
+#include "test_util.h"
+
+#define MAX_VCPUS	3
+
+/* A well-formed MPIDR with no matching vCPU. */
+#define BOGUS_MPIDR	0xf
+
+/* The primary's GUEST_SYNC: the host runs the secondary, then resumes the primary. */
+#define SYNC_RUN_SECONDARY	1
+
+#define STRESS_BOOTS	50
+#define ALT_BOOTS	50
+#define HANDSHAKE_CYCLES	50
+#define RACE_ROUNDS	10
+
+#define WAIT_MS		30000
+
+/* An identity-mapped page for the boot context the primary writes. */
+#define ALT_MEMSLOT	(PKVM_IDMAP_MEMSLOT + 1)
+#define ALT_CTX		BIT_ULL(30)
+
+/* Set in the guest's copy by the host before the first run. */
+static u64 boot_entry;
+static u64 vcpu_mpidr[MAX_VCPUS];
+static u64 vcpu_ctx[MAX_VCPUS];
+
+static u32 boots;
+static u64 expected_ctx;
+static u64 booted_ctx;
+static u32 go_off;
+
+static u32 race_ready;
+static u32 race_go;
+static u32 race_done;
+static unsigned long race_ret[2];
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
+static unsigned long __psci_cpu_on(u64 mpidr, u64 entry, u64 ctx)
+{
+	return pkvm_hvc(PSCI_0_2_FN64_CPU_ON, mpidr, entry, ctx);
+}
+
+static unsigned long psci_cpu_on(int id)
+{
+	return __psci_cpu_on(vcpu_mpidr[id], boot_entry, vcpu_ctx[id]);
+}
+
+static unsigned long psci_affinity_info(int id)
+{
+	return pkvm_hvc(PSCI_0_2_FN64_AFFINITY_INFO, vcpu_mpidr[id], 0, 0);
+}
+
+static void psci_cpu_off(void)
+{
+	pkvm_hvc(PSCI_0_2_FN_CPU_OFF, 0, 0, 0);
+	GUEST_ASSERT(0);
+}
+
+static void guest_primary(void)
+{
+	pkvm_guest_init();
+
+	GUEST_ASSERT_EQ(pkvm_hvc(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0), PSCI_VERSION(1, 1));
+	GUEST_ASSERT_EQ(pkvm_hvc(PSCI_1_0_FN_PSCI_FEATURES, PSCI_0_2_FN64_CPU_ON, 0, 0),
+			PSCI_RET_SUCCESS);
+	GUEST_ASSERT_EQ(pkvm_hvc(PSCI_1_0_FN_PSCI_FEATURES, PSCI_0_2_FN_MIGRATE, 0, 0),
+			PSCI_RET_NOT_SUPPORTED);
+
+	GUEST_ASSERT_EQ(psci_affinity_info(1), PSCI_0_2_AFFINITY_LEVEL_OFF);
+	GUEST_ASSERT_EQ(psci_cpu_on(1), PSCI_RET_SUCCESS);
+
+	/* The host handles AFFINITY_INFO, and returns ON for a CPU_ON target. */
+	GUEST_ASSERT_EQ(psci_affinity_info(1), PSCI_0_2_AFFINITY_LEVEL_ON);
+	GUEST_ASSERT_EQ(psci_cpu_on(1), PSCI_RET_ON_PENDING);
+
+	GUEST_SYNC(SYNC_RUN_SECONDARY);
+
+	GUEST_ASSERT_EQ(psci_affinity_info(1), PSCI_0_2_AFFINITY_LEVEL_ON);
+	GUEST_ASSERT_EQ(psci_cpu_on(1), PSCI_RET_ALREADY_ON);
+
+	GUEST_ASSERT_EQ(__psci_cpu_on(BOGUS_MPIDR, boot_entry, 0), PSCI_RET_INVALID_PARAMS);
+
+	GUEST_DONE();
+}
+
+/* The primary's pkvm_guest_init() set up ucall for the whole VM. */
+static void guest_secondary(void)
+{
+	GUEST_DONE();
+}
+
+static void guest_cpu_on_unregistered(void)
+{
+	pkvm_guest_init();
+	GUEST_ASSERT_EQ(psci_cpu_on(1), PSCI_RET_INVALID_PARAMS);
+	GUEST_DONE();
+}
+
+static void guest_boot_and_done(void)
+{
+	pkvm_guest_init();
+	GUEST_DONE();
+}
+
+static void guest_system_off(void)
+{
+	pkvm_hvc(PSCI_0_2_FN_SYSTEM_OFF, 0, 0, 0);
+	GUEST_ASSERT(0);
+}
+
+static void guest_system_reset(void)
+{
+	pkvm_hvc(PSCI_0_2_FN_SYSTEM_RESET, 0, 0, 0);
+	GUEST_ASSERT(0);
+}
+
+static void guest_system_reset2_smc32(void)
+{
+	pkvm_hvc(PSCI_1_1_FN_SYSTEM_RESET2, PSCI_1_1_RESET_TYPE_SYSTEM_WARM_RESET, 0, 0);
+	GUEST_ASSERT(0);
+}
+
+static void guest_system_reset2_smc64(void)
+{
+	pkvm_hvc(PSCI_1_1_FN64_SYSTEM_RESET2, PSCI_1_1_RESET_TYPE_SYSTEM_WARM_RESET, 0, 0);
+	GUEST_ASSERT(0);
+}
+
+static void guest_stress_primary(void)
+{
+	unsigned long successes = 0;
+
+	pkvm_guest_init();
+	while (READ_ONCE(boots) < STRESS_BOOTS) {
+		unsigned long ret = psci_cpu_on(1);
+
+		__GUEST_ASSERT(ret == PSCI_RET_SUCCESS || ret == PSCI_RET_ALREADY_ON ||
+			       ret == PSCI_RET_ON_PENDING, "CPU_ON 0x%lx", ret);
+		successes += ret == PSCI_RET_SUCCESS;
+	}
+
+	/*
+	 * SUCCESS means the secondary ran. The last boot has completed and the
+	 * secondary stays on after it, so no CPU_ON and no boot is in flight.
+	 */
+	GUEST_ASSERT_EQ(successes, STRESS_BOOTS);
+	GUEST_DONE();
+}
+
+static void guest_stress_secondary(void)
+{
+	u32 k = READ_ONCE(boots) + 1;
+
+	WRITE_ONCE(boots, k);
+	if (k == STRESS_BOOTS)
+		GUEST_DONE();
+	psci_cpu_off();
+}
+
+static void alt_boot(u64 ctx)
+{
+	u32 k = READ_ONCE(boots) + 1;
+
+	GUEST_ASSERT_EQ(ctx, READ_ONCE(expected_ctx));
+	WRITE_ONCE(booted_ctx, ctx);
+	/* Publishes booted_ctx, and the primary changes expected_ctx only once it sees this. */
+	smp_store_release(&boots, k);
+	if (k == ALT_BOOTS)
+		GUEST_DONE();
+	psci_cpu_off();
+}
+
+static void guest_alt_secondary_host_ctx(void)
+{
+	alt_boot(vcpu_ctx[1]);
+}
+
+static void guest_alt_secondary_guest_ctx(void)
+{
+	alt_boot(ALT_CTX);
+}
+
+static void clean_to_poc(void *p, size_t size)
+{
+	u64 line = 4UL << SYS_FIELD_GET(CTR_EL0, DminLine, read_sysreg(ctr_el0));
+	u64 addr;
+
+	for (addr = (u64)p & ~(line - 1); addr < (u64)p + size; addr += line)
+		asm volatile("dc cvac, %0" : : "r"(addr) : "memory");
+	dsb(sy);
+}
+
+static void guest_alt_primary(void)
+{
+	struct pvm_boot_args *alt = (struct pvm_boot_args *)ALT_CTX;
+	bool guest_ctx = true;
+	unsigned long ret;
+	u64 ctx;
+	u32 k;
+
+	pkvm_guest_init();
+
+	/* The trampoline reads the context with the MMU off. */
+	*alt = *(struct pvm_boot_args *)vcpu_ctx[1];
+	alt->jump_tgt = (u64)guest_alt_secondary_guest_ctx;
+	clean_to_poc(alt, sizeof(*alt));
+
+	for (k = 1; k <= ALT_BOOTS; k++) {
+		/*
+		 * CPU_ON returns ALREADY_ON until the host has powered the secondary off.
+		 * Each attempt passes the other context, so a boot from the previous attempt's
+		 * context fails alt_boot()'s check.
+		 */
+		do {
+			guest_ctx = !guest_ctx;
+			ctx = guest_ctx ? ALT_CTX : vcpu_ctx[1];
+			WRITE_ONCE(expected_ctx, ctx);
+			ret = __psci_cpu_on(vcpu_mpidr[1], boot_entry, ctx);
+			__GUEST_ASSERT(ret == PSCI_RET_SUCCESS || ret == PSCI_RET_ALREADY_ON,
+				       "CPU_ON 0x%lx", ret);
+		} while (ret != PSCI_RET_SUCCESS);
+
+		/* Only the primary powers the secondary on, so no other boot is in flight. */
+		wait_until(smp_load_acquire(&boots) >= k);
+		GUEST_ASSERT_EQ(READ_ONCE(boots), k);
+		GUEST_ASSERT_EQ(READ_ONCE(booted_ctx), ctx);
+	}
+
+	GUEST_DONE();
+}
+
+static void guest_handshake_secondary(void)
+{
+	u32 k = READ_ONCE(boots) + 1;
+
+	WRITE_ONCE(boots, k);
+	if (k > HANDSHAKE_CYCLES)
+		GUEST_DONE();
+	wait_until(READ_ONCE(go_off) == k);
+	psci_cpu_off();
+}
+
+/* The secondary is ON until it has called CPU_OFF. */
+static bool is_off(int id)
+{
+	unsigned long ret = psci_affinity_info(id);
+
+	__GUEST_ASSERT(ret == PSCI_0_2_AFFINITY_LEVEL_ON || ret == PSCI_0_2_AFFINITY_LEVEL_OFF,
+		       "AFFINITY_INFO 0x%lx", ret);
+	return ret == PSCI_0_2_AFFINITY_LEVEL_OFF;
+}
+
+static void guest_handshake_primary(void)
+{
+	u32 k;
+
+	pkvm_guest_init();
+
+	for (k = 1; k <= HANDSHAKE_CYCLES; k++) {
+		GUEST_ASSERT_EQ(psci_cpu_on(1), PSCI_RET_SUCCESS);
+
+		/* The secondary has booted and waits for go_off, so it is still ON. */
+		wait_until(READ_ONCE(boots) >= k);
+		GUEST_ASSERT_EQ(psci_affinity_info(1), PSCI_0_2_AFFINITY_LEVEL_ON);
+
+		WRITE_ONCE(go_off, k);
+
+		/* It is OFF and only the primary powers it on, so no boot is in flight. */
+		wait_until(is_off(1));
+		GUEST_ASSERT_EQ(READ_ONCE(boots), k);
+	}
+
+	/* One more boot lets the secondary finish instead of powering off. */
+	GUEST_ASSERT_EQ(psci_cpu_on(1), PSCI_RET_SUCCESS);
+	GUEST_DONE();
+}
+
+static void guest_race_caller(void)
+{
+	WRITE_ONCE(race_ready, 1);
+	wait_until(READ_ONCE(race_go));
+	race_ret[1] = psci_cpu_on(2);
+	/* Publishes race_ret[1] to the primary. */
+	smp_store_release(&race_done, 1);
+	GUEST_DONE();
+}
+
+/* No CPU_OFF: a target that powered off would let the loser win too. */
+static void guest_race_target(void)
+{
+	WRITE_ONCE(boots, READ_ONCE(boots) + 1);
+	GUEST_DONE();
+}
+
+static void guest_race_primary(void)
+{
+	unsigned long loser;
+	int winner;
+
+	pkvm_guest_init();
+
+	/* vCPU 1 has never been on, and the primary is its only caller. */
+	GUEST_ASSERT_EQ(psci_cpu_on(1), PSCI_RET_SUCCESS);
+	wait_until(READ_ONCE(race_ready));
+
+	WRITE_ONCE(race_go, 1);
+	race_ret[0] = psci_cpu_on(2);
+
+	/* Both callers have returned, and vCPU 2 has booted and stays on. */
+	wait_until(smp_load_acquire(&race_done));
+	wait_until(READ_ONCE(boots));
+	GUEST_ASSERT_EQ(READ_ONCE(boots), 1);
+
+	winner = race_ret[0] == PSCI_RET_SUCCESS ? 0 : 1;
+	loser = race_ret[!winner];
+	GUEST_ASSERT_EQ(race_ret[winner], PSCI_RET_SUCCESS);
+	__GUEST_ASSERT(loser == PSCI_RET_ON_PENDING || loser == PSCI_RET_ALREADY_ON,
+		       "losing CPU_ON 0x%lx", loser);
+
+	GUEST_SYNC(loser);
+	GUEST_DONE();
+}
+
+static struct kvm_vcpu *secondary_vcpu;
+static u64 sync_arg;
+
+static void run_secondary_on_sync(struct kvm_vcpu *vcpu, struct ucall *uc)
+{
+	if (uc->args[1] == SYNC_RUN_SECONDARY)
+		pkvm_run_loop(secondary_vcpu, NULL);
+}
+
+static void wire_target(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+	u64 mpidr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1));
+
+	write_guest_global(vm, vcpu_mpidr[vcpu->id], mpidr & MPIDR_HWID_BITMASK);
+	write_guest_global(vm, boot_entry, pkvm_idmap_gpa(vm));
+}
+
+static void wire_secondary(struct kvm_vm *vm, struct kvm_vcpu *vcpu, void *guest_code)
+{
+	gpa_t ctx;
+
+	wire_target(vm, vcpu);
+	ctx = pkvm_vcpu_setup_boot_secondary(vcpu, guest_code);
+	write_guest_global(vm, vcpu_ctx[vcpu->id], ctx);
+}
+
+static void test_protocol(void)
+{
+	struct kvm_vcpu *vcpus[2];
+	struct kvm_vm *vm;
+
+	vm = pkvm_vm_create(2, 0, vcpus);
+	secondary_vcpu = vcpus[1];
+
+	pkvm_vcpu_setup_boot(vcpus[0], guest_primary);
+	wire_secondary(vm, vcpus[1], guest_secondary);
+
+	pkvm_run_loop(vcpus[0], run_secondary_on_sync);
+
+	kvm_vm_free(vm);
+}
+
+/* vCPU 1 exists but never runs, so EL2 never creates its hyp vCPU. */
+static void test_cpu_on_unregistered(void)
+{
+	struct kvm_vcpu *vcpus[2];
+	struct kvm_vm *vm;
+
+	vm = pkvm_vm_create(2, 0, vcpus);
+
+	pkvm_vcpu_setup_boot(vcpus[0], guest_cpu_on_unregistered);
+	wire_target(vm, vcpus[1]);
+
+	pkvm_run_loop(vcpus[0], NULL);
+
+	kvm_vm_free(vm);
+}
+
+static void assert_system_event(void *guest_code, u32 type, u64 flags)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+
+	vm = pkvm_vm_create(1, 0, &vcpu);
+	pkvm_vcpu_setup_boot(vcpu, guest_code);
+
+	run = vcpu->run;
+	vcpu_run(vcpu);
+
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_SYSTEM_EVENT);
+	TEST_ASSERT_EQ(run->system_event.type, type);
+	TEST_ASSERT_EQ(run->system_event.data[0], flags);
+
+	kvm_vm_free(vm);
+}
+
+/* Only one vCPU may be RUNNABLE when EL2 creates its hyp vCPU: the primary. */
+static void assert_second_runnable_rejected(struct kvm_vcpu *vcpu)
+{
+	int ret = _vcpu_run(vcpu);
+
+	TEST_ASSERT(ret == -1 && errno == EINVAL,
+		    "second RUNNABLE vCPU: expected -1/EINVAL, got %d/%d", ret, errno);
+}
+
+static void test_forged_runnable(void)
+{
+	struct kvm_mp_state mps = { .mp_state = KVM_MP_STATE_RUNNABLE };
+	struct kvm_vcpu *vcpus[2];
+	struct kvm_vm *vm;
+
+	vm = pkvm_vm_create(2, 0, vcpus);
+	pkvm_vcpu_setup_boot(vcpus[0], guest_boot_and_done);
+	pkvm_run_loop(vcpus[0], NULL);
+
+	vcpu_mp_state_set(vcpus[1], &mps);
+	assert_second_runnable_rejected(vcpus[1]);
+
+	kvm_vm_free(vm);
+}
+
+static void test_second_primary(void)
+{
+	struct kvm_vcpu *vcpus[2];
+	struct kvm_vcpu_init init;
+	struct kvm_vm *vm;
+
+	vm = pkvm_vm_create(2, 0, vcpus);
+	pkvm_vcpu_setup_boot(vcpus[0], guest_boot_and_done);
+	pkvm_run_loop(vcpus[0], NULL);
+
+	/* Re-INIT without POWER_OFF also leaves the vCPU RUNNABLE. */
+	kvm_get_default_vcpu_target(vm, &init);
+	init.features[0] |= BIT(KVM_ARM_VCPU_PSCI_0_2);
+	vcpu_ioctl(vcpus[1], KVM_ARM_VCPU_INIT, &init);
+	assert_second_runnable_rejected(vcpus[1]);
+
+	kvm_vm_free(vm);
+}
+
+/* Once EL2 holds a secondary's hyp vCPU off, the host rejects powering it on. */
+static void test_run_gate_off(void)
+{
+	struct kvm_mp_state mps = { .mp_state = KVM_MP_STATE_RUNNABLE };
+	struct kvm_vcpu *vcpus[2];
+	struct kvm_vm *vm;
+	int ret;
+
+	vm = pkvm_vm_create(2, 0, vcpus);
+
+	pkvm_vcpu_setup_boot_secondary(vcpus[1], guest_boot_and_done);
+
+	ret = __vcpu_ioctl(vcpus[1], KVM_SET_MP_STATE, &mps);
+	TEST_ASSERT(ret == -1 && errno == EPERM,
+		    "forged RUNNABLE: expected -1/EPERM, got %d/%d", ret, errno);
+	mps.mp_state = KVM_MP_STATE_SUSPENDED;
+	ret = __vcpu_ioctl(vcpus[1], KVM_SET_MP_STATE, &mps);
+	TEST_ASSERT(ret == -1 && errno == EPERM,
+		    "forged SUSPENDED: expected -1/EPERM, got %d/%d", ret, errno);
+
+	kvm_vm_free(vm);
+}
+
+static void *vcpu_thread(void *vcpu)
+{
+	pkvm_run_loop(vcpu, NULL);
+	return NULL;
+}
+
+static void record_sync(struct kvm_vcpu *vcpu, struct ucall *uc)
+{
+	sync_arg = uc->args[1];
+}
+
+/* The secondary runs on its own thread, so a CPU_ON can race its CPU_OFF. */
+static void run_threaded(struct kvm_vcpu *vcpus[])
+{
+	pthread_t thread;
+
+	pthread_create(&thread, NULL, vcpu_thread, vcpus[1]);
+	pkvm_run_loop(vcpus[0], record_sync);
+	pthread_join(thread, NULL);
+}
+
+static void test_stress(void)
+{
+	struct kvm_vcpu *vcpus[2];
+	struct kvm_vm *vm;
+
+	vm = pkvm_vm_create(2, 0, vcpus);
+
+	pkvm_vcpu_setup_boot(vcpus[0], guest_stress_primary);
+	wire_secondary(vm, vcpus[1], guest_stress_secondary);
+
+	run_threaded(vcpus);
+
+	kvm_vm_free(vm);
+}
+
+static void test_alternating_ctx(void)
+{
+	struct kvm_vcpu *vcpus[2];
+	struct kvm_vm *vm;
+
+	vm = pkvm_vm_create(2, 0, vcpus);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ALT_CTX, ALT_MEMSLOT,
+				    vm_adjust_num_guest_pages(vm->mode, 1), 0);
+	virt_map(vm, ALT_CTX, ALT_CTX, 1);
+
+	pkvm_vcpu_setup_boot(vcpus[0], guest_alt_primary);
+	wire_secondary(vm, vcpus[1], guest_alt_secondary_host_ctx);
+
+	run_threaded(vcpus);
+
+	kvm_vm_free(vm);
+}
+
+static void test_handshake(void)
+{
+	struct kvm_vcpu *vcpus[2];
+	struct kvm_vm *vm;
+
+	vm = pkvm_vm_create(2, 0, vcpus);
+
+	pkvm_vcpu_setup_boot(vcpus[0], guest_handshake_primary);
+	wire_secondary(vm, vcpus[1], guest_handshake_secondary);
+
+	run_threaded(vcpus);
+
+	kvm_vm_free(vm);
+}
+
+/* Returns the number of rounds whose loser got ON_PENDING: its CPU_ON overlapped the winner's. */
+static int test_concurrent_cpu_on(void)
+{
+	int i, on_pending = 0;
+
+	for (i = 0; i < RACE_ROUNDS; i++) {
+		struct kvm_vcpu *vcpus[3];
+		pthread_t target;
+		struct kvm_vm *vm;
+
+		vm = pkvm_vm_create(3, 0, vcpus);
+
+		pkvm_vcpu_setup_boot(vcpus[0], guest_race_primary);
+		wire_secondary(vm, vcpus[1], guest_race_caller);
+		wire_secondary(vm, vcpus[2], guest_race_target);
+
+		pthread_create(&target, NULL, vcpu_thread, vcpus[2]);
+		run_threaded(vcpus);
+		pthread_join(target, NULL);
+
+		kvm_vm_free(vm);
+
+		on_pending += sync_arg == PSCI_RET_ON_PENDING;
+	}
+
+	return on_pending;
+}
+
+int main(void)
+{
+	int on_pending;
+
+	TEST_REQUIRE(pkvm_supported());
+
+	ksft_print_header();
+	ksft_set_plan(13);
+
+	test_protocol();
+	ksft_test_result_pass("PSCI protocol and CPU_ON boot\n");
+	test_cpu_on_unregistered();
+	ksft_test_result_pass("CPU_ON of a vCPU with no hyp vCPU\n");
+	assert_system_event(guest_system_off, KVM_SYSTEM_EVENT_SHUTDOWN, 0);
+	ksft_test_result_pass("SYSTEM_OFF\n");
+	assert_system_event(guest_system_reset, KVM_SYSTEM_EVENT_RESET, 0);
+	ksft_test_result_pass("SYSTEM_RESET\n");
+	assert_system_event(guest_system_reset2_smc32, KVM_SYSTEM_EVENT_RESET,
+			    KVM_SYSTEM_EVENT_RESET_FLAG_PSCI_RESET2);
+	ksft_test_result_pass("SYSTEM_RESET2 (SMC32)\n");
+	assert_system_event(guest_system_reset2_smc64, KVM_SYSTEM_EVENT_RESET,
+			    KVM_SYSTEM_EVENT_RESET_FLAG_PSCI_RESET2);
+	ksft_test_result_pass("SYSTEM_RESET2 (SMC64)\n");
+	test_forged_runnable();
+	ksft_test_result_pass("forged RUNNABLE rejected at hyp vCPU creation\n");
+	test_second_primary();
+	ksft_test_result_pass("second RUNNABLE vCPU rejected\n");
+	test_run_gate_off();
+	ksft_test_result_pass("forged RUNNABLE and SUSPENDED of an OFF vCPU rejected\n");
+	test_stress();
+	ksft_test_result_pass("CPU_ON/CPU_OFF race: %d boots\n", STRESS_BOOTS);
+	test_alternating_ctx();
+	ksft_test_result_pass("CPU_ON alternating context: %d boots\n", ALT_BOOTS);
+	test_handshake();
+	ksft_test_result_pass("CPU_OFF/CPU_ON handshake: %d cycles\n", HANDSHAKE_CYCLES);
+	on_pending = test_concurrent_cpu_on();
+	ksft_test_result_pass("concurrent CPU_ON: one winner in %d rounds, %d ON_PENDING losers\n",
+			      RACE_ROUNDS, on_pending);
+
+	ksft_finished();
+}
-- 
2.47.3

