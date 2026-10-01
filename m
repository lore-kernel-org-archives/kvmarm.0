Received: from mta0.migadu.com (out-36.mta0.migadu.com [91.218.175.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044894825DB
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 07:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790838688; cv=none; b=Bllsr39ctOn4nSbksJf31gceTR+PeDQfy4dC3mfqk4DRlTOJMj3ZslM77bzkxBhBbA1bx86yU1sBMbnq2Tswsm8srDRqfEj+CIsnQqSuUYkTwDSysjzw0NENCO1IrD50BxDgqxDRY5H8ZPcaYW4I68Rulz/IMHC27ecAioxn70k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790838688; c=relaxed/simple;
	bh=0fdzi4w6NDM5XZeIYDDwPOGLo0wFnn9EExdi4wfE9fo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O6nGJZRdoqvxcReNgw6mnDsR65AkcrAxyZTxeHY2KX763GTDJZ4yvtZZ//IRMYKyr0mUnCZy99Ivc29CtTRwY833gw7djkZ9lykSxn2CR6/Cd1PmALE7i8B7jupPGd5LQsubrUOTwBtxQjtZbkbcBnEqdskfJQ6oOXuxB+5EBiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=j4k2xSHQ; arc=none smtp.client-ip=91.218.175.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="j4k2xSHQ"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=0fdzi4w6NDM5XZeIYDDwPOGLo0wFnn9EExdi4wfE9fo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790838679; v=1; x=1791443479;
 b=j4k2xSHQSjMQBPTn8C2JTTY/HBr4xnZ5QGUKz+/vjEgH+NV4cnDkIdXH2uGhusmr+js3gfG4
 OKLJjt/azF9evPsDdAPkJvNzC/By3+UbXeeGRaQnEWX448pZdjkvqyHXvAjntNBdFPKyT90tPXm
 z0WuxzJyuAuaCcXRnfj2Rhdk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id bb15fffe5c6f27f0;
	Thu, 01 Oct 2026 07:11:19 +0000
X-Mizu-Trace-ID: bb15fffe5c6f27f0
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Yuchao Zhang <ndaugoing@gmail.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 3/3] KVM: arm64: selftests: Test MOVI and MOVALL on a pending LPI
Date: Thu,  1 Oct 2026 08:11:00 +0100
Message-Id: <20261001071100.190013-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261001071100.190013-1-fuad.tabba@linux.dev>
References: <20261001071100.190013-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MOVI and MOVALL move the pending state of LPIs between redistributors,
so a test of either has to make its LPI pending before the move.

Add one to vgic_lpi_stress. vCPU0 and vCPU1 keep IRQs masked while LPI
A is signalled to vCPU0 and LPI B to vCPU1, and each waits until
ICC_HPPIR1_EL1 shows its LPI pending at the CPU interface. vCPU1 then
moves A to vCPU2, with MOVI or with MAPC and MOVALL of vCPU0's
collection. Once unmasked, A must be taken on vCPU2 only and B on vCPU1
only.

KVM retargets A at the MAPC already, so the MOVALL case catches a
MOVALL that moves too much: without commit 751f4641560b ("KVM: arm64:
vgic-its: Fix MOVALL handling of source redistributor"), B goes to
vCPU2 as well. vCPU1 issues the commands, so its own ITS accesses,
which exit to KVM, move a wrongly retargeted B off it before it
unmasks.

Both cases run after the stress test, so a kernel that fails them
still gets the stress run, and the command-line options still configure
only the stress test.

Assisted-by: LLM
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 .../selftests/kvm/arm64/vgic_lpi_stress.c     | 196 +++++++++++++++++-
 1 file changed, 195 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
index 63c725b6b156c..8e4047fa0b6ab 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * vgic_lpi_stress - Stress test for KVM's ITS emulation
+ * vgic_lpi_stress - Tests for KVM's ITS emulation
  *
  * Copyright (c) 2024 Google LLC
  */
@@ -29,11 +29,17 @@ static struct kvm_vm *vm;
 static struct kvm_vcpu **vcpus;
 static int its_fd;
 
+enum move_cmd {
+	MOVE_MOVI,
+	MOVE_MAPC_MOVALL,
+};
+
 struct test_data {
 	bool		request_vcpus_stop;
 	u32		nr_cpus;
 	u32		nr_devices;
 	u32		nr_event_ids;
+	enum move_cmd	move_cmd;
 
 	gpa_t		device_table;
 	gpa_t		collection_table;
@@ -383,6 +389,191 @@ static void test_lpi_stress(void)
 	destroy_vm();
 }
 
+/*
+ * Pending move: A is pending at vCPU0's CPU interface and B at vCPU1's, both
+ * vCPUs with IRQs masked, when vCPU1 moves A to vCPU2. Once unmasked, A must
+ * be taken on vCPU2 only, and B on vCPU1 only.
+ */
+#define MOVE_NR_VCPUS		3
+#define MOVE_NR_LPIS		2
+#define MOVE_DEVICE		0
+
+/* guest_setup_its_mappings() maps event N to vCPU N's collection */
+#define LPI_A			0
+#define LPI_B			1
+#define SRC_VCPU		0
+#define B_VCPU			1
+#define DST_VCPU		2
+
+static atomic_uint lpi_taken[MOVE_NR_VCPUS][MOVE_NR_LPIS];
+static atomic_bool lpi_a_pending, lpi_a_moved, vcpu_unmasked[MOVE_NR_VCPUS];
+
+static void guest_count_irq_handler(struct ex_regs *regs)
+{
+	u32 intid = gic_get_and_ack_irq();
+
+	if (intid == IAR_SPURIOUS)
+		return;
+
+	GUEST_ASSERT(intid >= GIC_LPI_OFFSET && intid < GIC_LPI_OFFSET + MOVE_NR_LPIS);
+	atomic_fetch_add(&lpi_taken[guest_get_vcpuid()][intid - GIC_LPI_OFFSET], 1);
+	gic_set_eoi(intid);
+}
+
+/* HPPIR shows an LPI pending at this CPU interface even with IRQs masked */
+static bool guest_lpi_pending(u32 lpi)
+{
+	return (read_sysreg_s(SYS_ICC_HPPIR1_EL1) & GENMASK(23, 0)) == GIC_LPI_OFFSET + lpi;
+}
+
+static void guest_wait_pending(u32 lpi)
+{
+	while (!guest_lpi_pending(lpi))
+		cpu_relax();
+}
+
+/* An LPI still pending here is taken before the host is told to check */
+static void guest_unmask(u32 lpi)
+{
+	local_irq_enable();
+
+	while (guest_lpi_pending(lpi))
+		cpu_relax();
+
+	atomic_store(&vcpu_unmasked[guest_get_vcpuid()], true);
+}
+
+static void guest_move_lpi_a(void)
+{
+	void *cmdq = test_data.cmdq_base_va;
+
+	if (test_data.move_cmd == MOVE_MOVI) {
+		its_send_movi_cmd(cmdq, MOVE_DEVICE, LPI_A, DST_VCPU);
+	} else {
+		its_send_mapc_cmd(cmdq, DST_VCPU, SRC_VCPU, true);
+		/* The GICv3 spec's MAPC description requires this SYNC before MOVALL */
+		its_send_sync_cmd(cmdq, SRC_VCPU);
+		its_send_movall_cmd(cmdq, SRC_VCPU, DST_VCPU);
+	}
+
+	/* Complete the move at both redistributors before vCPU0 unmasks */
+	its_send_sync_cmd(cmdq, SRC_VCPU);
+	its_send_sync_cmd(cmdq, DST_VCPU);
+}
+
+static void guest_pending_move_code(void)
+{
+	u32 cpuid = guest_get_vcpuid();
+
+	guest_setup_gic();
+
+	if (cpuid == DST_VCPU)
+		local_irq_enable();
+
+	GUEST_SYNC(0);
+
+	if (cpuid == SRC_VCPU) {
+		guest_wait_pending(LPI_A);
+		atomic_store(&lpi_a_pending, true);
+
+		while (!atomic_load(&lpi_a_moved))
+			cpu_relax();
+		guest_unmask(LPI_A);
+	} else if (cpuid == B_VCPU) {
+		guest_wait_pending(LPI_B);
+
+		while (!atomic_load(&lpi_a_pending))
+			cpu_relax();
+		guest_move_lpi_a();
+		atomic_store(&lpi_a_moved, true);
+		guest_unmask(LPI_B);
+	}
+
+	guest_wait_for_stop();
+}
+
+static unsigned int nr_lpis_taken(atomic_uint (*taken)[MOVE_NR_LPIS])
+{
+	unsigned int nr = 0;
+	int vcpu, lpi;
+
+	for (vcpu = 0; vcpu < MOVE_NR_VCPUS; vcpu++)
+		for (lpi = 0; lpi < MOVE_NR_LPIS; lpi++)
+			nr += atomic_load(&taken[vcpu][lpi]);
+
+	return nr;
+}
+
+static bool pending_move_done(atomic_uint (*taken)[MOVE_NR_LPIS], atomic_bool *unmasked)
+{
+	return nr_lpis_taken(taken) >= MOVE_NR_LPIS &&
+	       atomic_load(&unmasked[SRC_VCPU]) && atomic_load(&unmasked[B_VCPU]);
+}
+
+static void check_lpi_taken(atomic_uint (*taken)[MOVE_NR_LPIS], int lpi, int want_vcpu)
+{
+	const char *cmd = test_data.move_cmd == MOVE_MOVI ? "MOVI" : "MAPC+MOVALL";
+	unsigned int nr[MOVE_NR_VCPUS];
+	bool ok = true;
+	int vcpu;
+
+	for (vcpu = 0; vcpu < MOVE_NR_VCPUS; vcpu++) {
+		nr[vcpu] = atomic_load(&taken[vcpu][lpi]);
+		ok &= nr[vcpu] == (vcpu == want_vcpu);
+	}
+
+	TEST_ASSERT(ok, "%s: LPI %c taken %u/%u/%u times on vCPU0/1/2, expected once on vCPU%d",
+		    cmd, 'A' + lpi, nr[0], nr[1], nr[2], want_vcpu);
+}
+
+static void run_pending_move_test(void)
+{
+	atomic_uint (*taken)[MOVE_NR_LPIS] = addr_gva2hva(vm, (gva_t)lpi_taken);
+	atomic_bool *unmasked = addr_gva2hva(vm, (gva_t)vcpu_unmasked);
+	pthread_t vcpu_threads[MOVE_NR_VCPUS];
+	int i;
+
+	pthread_barrier_init(&test_setup_barrier, NULL, MOVE_NR_VCPUS + 1);
+
+	for (i = 0; i < MOVE_NR_VCPUS; i++)
+		kvm_pthread_create(&vcpu_threads[i], NULL, vcpu_worker_thread, vcpus[i]);
+
+	pthread_barrier_wait(&test_setup_barrier);
+
+	signal_lpi(MOVE_DEVICE, LPI_A);
+	signal_lpi(MOVE_DEVICE, LPI_B);
+
+	for (i = 0; i < 10000 && !pending_move_done(taken, unmasked); i++)
+		usleep(1000);
+
+	/* Check first: a vCPU still waiting for its LPI never sees the stop */
+	check_lpi_taken(taken, LPI_A, DST_VCPU);
+	check_lpi_taken(taken, LPI_B, B_VCPU);
+
+	write_guest_global(vm, test_data.request_vcpus_stop, true);
+
+	for (i = 0; i < MOVE_NR_VCPUS; i++)
+		kvm_pthread_join(vcpu_threads[i], NULL);
+
+	pthread_barrier_destroy(&test_setup_barrier);
+}
+
+static void test_pending_move(enum move_cmd move_cmd)
+{
+	test_data = (struct test_data) {
+		.nr_cpus	= MOVE_NR_VCPUS,
+		.nr_devices	= 1,
+		.nr_event_ids	= MOVE_NR_LPIS,
+		.move_cmd	= move_cmd,
+	};
+
+	setup_vm(guest_pending_move_code, guest_count_irq_handler);
+
+	run_pending_move_test();
+
+	destroy_vm();
+}
+
 static void pr_usage(const char *name)
 {
 	pr_info("%s [-v NR_VCPUS] [-d NR_DEVICES] [-e NR_EVENTS] [-i ITERS] -h\n", name);
@@ -427,5 +618,8 @@ int main(int argc, char **argv)
 
 	test_lpi_stress();
 
+	test_pending_move(MOVE_MOVI);
+	test_pending_move(MOVE_MAPC_MOVALL);
+
 	return 0;
 }
-- 
2.39.5

