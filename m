Received: from mta1.migadu.com (out-229.mta1.migadu.com [95.215.58.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9203FE36C
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 19:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.229
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790708712; cv=none; b=HrvgZ0CnHJUUMZKNqTMbKzp/4Nhmt0GY2WmkgDyKU0BQATos8AgmlWqP2ReHTOUrpReZn0uDmsYsSo+BuArrcukDXZ71BgTU8n+tT6WUHR5vYbigCx6dsKymx2KGY8KYlednBydaUcFD3ww3FnP4tbMv+XPSdH4wLttwMaYDWtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790708712; c=relaxed/simple;
	bh=247TbFGHZJJ6jE6PJiCoKslPH4RF0ptzt/+kBBrIMSQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KiidY8pwAM5jgpRxlSkKEHn+aRb/jMTM2p7zgEVB3DrdBTneVf+T8Q7lLeywjeJzgsCV0Y0cKVfSKMnm43No17cvFS+Jsmr0tenuIWH08ppYWa4ZbA/Pi+rfoXMB8/ZUgNXZTsBQqJU8vk59QyLUTJ1eZUN5cHxCZ2NFyrHnc2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IswLt6Ce; arc=none smtp.client-ip=95.215.58.229
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IswLt6Ce"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=247TbFGHZJJ6jE6PJiCoKslPH4RF0ptzt/+kBBrIMSQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790708708; v=1; x=1791313508;
 b=IswLt6Ce+LHvQVDnTbAfk/Ubd/zvoY+lQbB0n/CSxs4zUj/KcVSF+x6Nm/sAfo959y+N+PhY
 7NrGef+vH/BJfftKb0bVkqcanY4aBGJ3GOC2oNCVeuW2u4teEE/wGlPiks2PztQ1l2kWxjRIJ/Y
 aPanQpKbk3vOvpZKriUmPpXU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 2d3e416b882e3143;
	Tue, 29 Sep 2026 19:05:07 +0000
X-Mizu-Trace-ID: 2d3e416b882e3143
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Yuchao Zhang <ndaugoing@gmail.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v1 2/2] KVM: arm64: selftests: Add an ITS MOVALL test
Date: Tue, 29 Sep 2026 20:04:52 +0100
Message-Id: <e6bf4bc51a311df19866a0ee3e27970846257b70.1790708299.git.fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1790708299.git.fuad.tabba@linux.dev>
References: <20260929093548.3598547-1-maz@kernel.org> <cover.1790708299.git.fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Map LPI A to vCPU0's collection and LPI B to vCPU1's, remap vCPU0's
collection to vCPU2 and MOVALL vCPU0's LPIs there, then inject both. A
must be taken on vCPU2 and B on vCPU1. KVM's MAPC handling already moves
A to vCPU2, so only MOVALL handling can move B: without "KVM: arm64:
vgic-its: Fix MOVALL handling of source redistributor", it moves B to
vCPU2 as well.

Assisted-by: LLM
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/vgic_its_movall.c     | 341 ++++++++++++++++++
 2 files changed, 342 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/vgic_its_movall.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 908bdc7cf4f58..fb0bc99242975 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -190,6 +190,7 @@ TEST_GEN_PROGS_arm64 += arm64/stage2_block_transitions
 TEST_GEN_PROGS_arm64 += arm64/vcpu_width_config
 TEST_GEN_PROGS_arm64 += arm64/vgic_init
 TEST_GEN_PROGS_arm64 += arm64/vgic_irq
+TEST_GEN_PROGS_arm64 += arm64/vgic_its_movall
 TEST_GEN_PROGS_arm64 += arm64/vgic_its_save
 TEST_GEN_PROGS_arm64 += arm64/vgic_lpi_stress
 TEST_GEN_PROGS_arm64 += arm64/vgic_v5
diff --git a/tools/testing/selftests/kvm/arm64/vgic_its_movall.c b/tools/testing/selftests/kvm/arm64/vgic_its_movall.c
new file mode 100644
index 0000000000000..41918576bdf63
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/vgic_its_movall.c
@@ -0,0 +1,341 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * vgic_its_movall - MOVALL does not move the LPIs of other redistributors.
+ *
+ * Two LPIs, A and B, target two different redistributors. A's collection is
+ * remapped to a third redistributor with MAPC, followed by MOVALL from the
+ * first redistributor to the third. Both LPIs are then injected. A must be
+ * taken on the third redistributor, and B must stay on its own, which is not
+ * MOVALL's source.
+ *
+ * Copyright (c) 2026 Google LLC
+ * Author: Fuad Tabba <fuad.tabba@linux.dev>
+ */
+
+#include <linux/sizes.h>
+#include <pthread.h>
+#include <stdatomic.h>
+
+#include "kvm_util.h"
+#include "gic.h"
+#include "gic_v3.h"
+#include "gic_v3_its.h"
+#include "processor.h"
+#include "ucall.h"
+#include "vgic.h"
+
+#define TEST_MEMSLOT_INDEX	1
+
+#define GIC_LPI_OFFSET		8192
+#define NR_VCPUS		3
+#define NR_LPIS			2
+#define DEVICE_ID		0
+
+/* LPI A (event 0) starts on vCPU0 and moves to vCPU2; B (event 1) stays on vCPU1 */
+#define LPI_A_COLL		0
+#define LPI_B_COLL		1
+#define MOVALL_FROM		0
+#define MOVALL_TO		2
+#define LPI_B_VCPU		1
+
+#define LPI_PROP_DEFAULT_PRIO	0xa0
+
+static gpa_t gpa_base;
+
+static struct kvm_vm *vm;
+static struct kvm_vcpu *vcpus[NR_VCPUS];
+static int its_fd;
+
+static struct test_data {
+	bool		request_vcpus_stop;
+
+	gpa_t		device_table;
+	gpa_t		collection_table;
+	gpa_t		cmdq_base;
+	void		*cmdq_base_va;
+	gpa_t		itt_table;
+
+	gpa_t		lpi_prop_table;
+	gpa_t		lpi_pend_tables;
+} test_data;
+
+static atomic_uint lpi_taken[NR_VCPUS][NR_LPIS];
+
+static void guest_irq_handler(struct ex_regs *regs)
+{
+	u32 intid = gic_get_and_ack_irq();
+
+	if (intid == IAR_SPURIOUS)
+		return;
+
+	GUEST_ASSERT(intid >= GIC_LPI_OFFSET && intid < GIC_LPI_OFFSET + NR_LPIS);
+	atomic_fetch_add(&lpi_taken[guest_get_vcpuid()][intid - GIC_LPI_OFFSET], 1);
+	gic_set_eoi(intid);
+}
+
+static void guest_setup_its(void)
+{
+	void *cmdq = test_data.cmdq_base_va;
+	u32 i;
+
+	its_init(test_data.collection_table, SZ_64K,
+		 test_data.device_table, SZ_64K,
+		 test_data.cmdq_base, SZ_64K);
+
+	for (i = 0; i < NR_VCPUS; i++)
+		its_send_mapc_cmd(cmdq, i, i, true);
+
+	its_send_mapd_cmd(cmdq, DEVICE_ID, test_data.itt_table, SZ_64K, true);
+	its_send_mapti_cmd(cmdq, DEVICE_ID, 0, LPI_A_COLL, GIC_LPI_OFFSET);
+	its_send_mapti_cmd(cmdq, DEVICE_ID, 1, LPI_B_COLL, GIC_LPI_OFFSET + 1);
+
+	for (i = 0; i < NR_VCPUS; i++)
+		its_send_invall_cmd(cmdq, i);
+
+	for (i = 0; i < NR_VCPUS; i++)
+		its_send_sync_cmd(cmdq, i);
+}
+
+static void guest_move_lpi_a(void)
+{
+	void *cmdq = test_data.cmdq_base_va;
+
+	its_send_mapc_cmd(cmdq, MOVALL_TO, LPI_A_COLL, true);
+	/* The GICv3 spec requires a SYNC to the old redistributor before MOVALL. */
+	its_send_sync_cmd(cmdq, MOVALL_FROM);
+	its_send_movall_cmd(cmdq, MOVALL_FROM, MOVALL_TO);
+	its_send_sync_cmd(cmdq, MOVALL_TO);
+}
+
+static void guest_code(void)
+{
+	static atomic_int nr_cpus_ready;
+	u32 cpuid = guest_get_vcpuid();
+
+	gic_init(GIC_V3, NR_VCPUS);
+	gic_rdist_enable_lpis(test_data.lpi_prop_table, SZ_64K,
+			      test_data.lpi_pend_tables + (cpuid * SZ_64K));
+
+	atomic_fetch_add(&nr_cpus_ready, 1);
+
+	if (cpuid == 0) {
+		while (atomic_load(&nr_cpus_ready) < NR_VCPUS)
+			cpu_relax();
+
+		guest_setup_its();
+		guest_move_lpi_a();
+	}
+
+	local_irq_enable();
+
+	GUEST_SYNC(0);
+
+	/*
+	 * Don't use WFI here to avoid blocking the vCPU thread indefinitely and
+	 * never getting the stop signal.
+	 */
+	while (!READ_ONCE(test_data.request_vcpus_stop))
+		cpu_relax();
+
+	GUEST_DONE();
+}
+
+static void setup_memslot(void)
+{
+	size_t pages;
+	size_t sz;
+
+	/*
+	 * For the ITS: device table, collection table, command queue and one
+	 * ITT. For the redistributors: the LPI configuration table and an LPI
+	 * pending table per vCPU.
+	 */
+	sz = (5 + NR_VCPUS) * SZ_64K;
+
+	pages = sz / vm->page_size;
+	gpa_base = ((vm_compute_max_gfn(vm) + 1) * vm->page_size) - sz;
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, gpa_base,
+				    TEST_MEMSLOT_INDEX, pages, 0);
+}
+
+static void configure_lpis(void)
+{
+	u8 *tbl = addr_gpa2hva(vm, test_data.lpi_prop_table);
+	int i;
+
+	for (i = 0; i < NR_LPIS; i++)
+		tbl[i] = LPI_PROP_DEFAULT_PRIO | LPI_PROP_GROUP1 | LPI_PROP_ENABLED;
+}
+
+static gpa_t alloc_64k(size_t nr)
+{
+	size_t pages_per_64k = vm_calc_num_guest_pages(vm->mode, SZ_64K);
+
+	return vm_phy_pages_alloc(vm, pages_per_64k * nr, gpa_base, TEST_MEMSLOT_INDEX);
+}
+
+static void setup_test_data(void)
+{
+	size_t pages_per_64k = vm_calc_num_guest_pages(vm->mode, SZ_64K);
+
+	test_data.device_table = alloc_64k(1);
+	test_data.collection_table = alloc_64k(1);
+
+	test_data.cmdq_base = alloc_64k(1);
+	virt_map(vm, test_data.cmdq_base, test_data.cmdq_base, pages_per_64k);
+	test_data.cmdq_base_va = (void *)test_data.cmdq_base;
+
+	test_data.itt_table = alloc_64k(1);
+
+	test_data.lpi_prop_table = alloc_64k(1);
+	configure_lpis();
+
+	test_data.lpi_pend_tables = alloc_64k(NR_VCPUS);
+
+	sync_global_to_guest(vm, test_data);
+}
+
+static void signal_lpi(u32 event_id)
+{
+	gpa_t db_addr = GITS_BASE_GPA + GITS_TRANSLATER;
+
+	struct kvm_msi msi = {
+		.address_lo	= db_addr,
+		.address_hi	= db_addr >> 32,
+		.data		= event_id,
+		.devid		= DEVICE_ID,
+		.flags		= KVM_MSI_VALID_DEVID,
+	};
+
+	TEST_ASSERT(__vm_ioctl(vm, KVM_SIGNAL_MSI, &msi) == 1,
+		    "KVM_SIGNAL_MSI ioctl failed");
+}
+
+static pthread_barrier_t test_setup_barrier;
+
+static void *vcpu_worker_thread(void *data)
+{
+	struct kvm_vcpu *vcpu = data;
+	struct ucall uc;
+
+	while (true) {
+		vcpu_run(vcpu);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			pthread_barrier_wait(&test_setup_barrier);
+			continue;
+		case UCALL_DONE:
+			return NULL;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		default:
+			TEST_FAIL("Unknown ucall: %lu", uc.cmd);
+		}
+	}
+
+	return NULL;
+}
+
+static unsigned int lpi_taken_on(atomic_uint (*taken)[NR_LPIS], int vcpu, int lpi)
+{
+	return atomic_load(&taken[vcpu][lpi]);
+}
+
+static void wait_for_lpis(atomic_uint (*taken)[NR_LPIS])
+{
+	int lpi, vcpu, i;
+
+	for (i = 0; i < 10000; i++) {
+		unsigned int nr = 0;
+
+		for (lpi = 0; lpi < NR_LPIS; lpi++)
+			for (vcpu = 0; vcpu < NR_VCPUS; vcpu++)
+				nr += !!lpi_taken_on(taken, vcpu, lpi);
+
+		if (nr == NR_LPIS)
+			return;
+
+		usleep(1000);
+	}
+
+	TEST_FAIL("LPIs not taken after 10s");
+}
+
+static void check_movall(atomic_uint (*taken)[NR_LPIS])
+{
+	int vcpu;
+
+	for (vcpu = 0; vcpu < NR_VCPUS; vcpu++) {
+		TEST_ASSERT(!lpi_taken_on(taken, vcpu, 0) == (vcpu != MOVALL_TO),
+			    "LPI A taken %u times on vCPU%d, expected only on vCPU%d",
+			    lpi_taken_on(taken, vcpu, 0), vcpu, MOVALL_TO);
+		TEST_ASSERT(!lpi_taken_on(taken, vcpu, 1) == (vcpu != LPI_B_VCPU),
+			    "LPI B taken %u times on vCPU%d, expected only on vCPU%d",
+			    lpi_taken_on(taken, vcpu, 1), vcpu, LPI_B_VCPU);
+	}
+}
+
+static void run_test(void)
+{
+	atomic_uint (*taken)[NR_LPIS] = addr_gva2hva(vm, (gva_t)lpi_taken);
+	pthread_t vcpu_threads[NR_VCPUS];
+	size_t i;
+
+	pthread_barrier_init(&test_setup_barrier, NULL, NR_VCPUS + 1);
+
+	for (i = 0; i < NR_VCPUS; i++)
+		kvm_pthread_create(&vcpu_threads[i], NULL, vcpu_worker_thread, vcpus[i]);
+
+	pthread_barrier_wait(&test_setup_barrier);
+
+	signal_lpi(0);
+	signal_lpi(1);
+	wait_for_lpis(taken);
+
+	write_guest_global(vm, test_data.request_vcpus_stop, true);
+
+	for (i = 0; i < NR_VCPUS; i++)
+		kvm_pthread_join(vcpu_threads[i], NULL);
+
+	check_movall(taken);
+}
+
+static void setup_vm(void)
+{
+	int i;
+
+	vm = vm_create_with_vcpus(NR_VCPUS, guest_code, vcpus);
+
+	vm_init_descriptor_tables(vm);
+	for (i = 0; i < NR_VCPUS; i++)
+		vcpu_init_descriptor_tables(vcpus[i]);
+
+	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT, guest_irq_handler);
+
+	setup_memslot();
+
+	its_fd = vgic_its_setup(vm);
+
+	setup_test_data();
+}
+
+static void destroy_vm(void)
+{
+	close(its_fd);
+	kvm_vm_free(vm);
+}
+
+int main(void)
+{
+	TEST_REQUIRE(kvm_supports_vgic_v3());
+
+	setup_vm();
+
+	run_test();
+
+	destroy_vm();
+
+	return 0;
+}
-- 
2.39.5

