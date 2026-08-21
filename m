Received: from mta1.migadu.com (out-48.mta1.migadu.com [95.215.58.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002DE2F5A12
	for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 06:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787294719; cv=none; b=p52UKD0AfnxACJKtRiiWaHg+OeAPE8eWo0oJrBlwKFEG6tilzS9Fhkhu1C3vTzWnk38OKFD8mlgWdhGu1Xw/BOeELIcVMQ48E9vakvH+WBE15UjUPLBF0odPjNFtKyI1YQY/6Eko/4fOkVnqnY0MEyfmQs51ijqpf9gUxULoE3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787294719; c=relaxed/simple;
	bh=gYzwu8KYItqSmkpSAUmRmzyO8SidQUvDXcKIjiUX++c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Sls6KDFhTQuIYzFVTMUyZ+Ap0fSRQnu+AG9XgtcSHKyjJ3RTn+1JdSrqKLPmBfpEsiCTsoWxS15zMtsawGHpHrFeVhj5mJ11ZMUowrKzXkxGd0QV7eHZtFxeGyD1LIxhliXfF9zqCh6bg0i5WG+0Wmv22tmmTUQLT26uWQn/Eo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NAOWpx5E; arc=none smtp.client-ip=95.215.58.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NAOWpx5E"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=gYzwu8KYItqSmkpSAUmRmzyO8SidQUvDXcKIjiUX++c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787294715; v=1; x=1787899515;
 b=NAOWpx5EDh9dJ7kuVhzEwnPhGNMkuawP0M2eh0Iz0gEeKI84sXQwkzAVdY5scVegw+0n3CSC
 6zlWHmCPDk2cinoyzXfG3H1W/Jryeb843NCLlBj5+k6XsEE1UV1eFeLvMoDgYcLH3aj6H6j5uf1
 n+JoTkhOlA3GPCho645lHIRg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.lan (37.156.72.212)
	by smtp.migadu.com with ESMTPS id fac3905a186fd2e2;
	Fri, 21 Aug 2026 06:45:14 +0000
X-Mizu-Trace-ID: fac3905a186fd2e2
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Eric Auger <eauger@redhat.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] KVM: arm64: selftests: Add ITS table save tests
Date: Fri, 21 Aug 2026 07:44:45 +0100
Message-Id: <20260821064445.615838-5-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260821064445.615838-1-fuad.tabba@linux.dev>
References: <20260821064445.615838-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cover the two ways a guest can leave a table that
KVM_DEV_ARM_ITS_SAVE_TABLES has to cope with: a GITS_BASER<coll> write
that changes the table, which drops the collections it described, and a
device whose L2 block the guest invalidated, which the save skips. Each
case then resets and restores, which is what the save exists for.

Both fail without the preceding patches. The first save returns -EINVAL,
and the second saves a DTE pointing 8192 entries ahead, at an entry the
save never wrote.

Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/vgic_its_save.c       | 441 ++++++++++++++++++
 2 files changed, 442 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/vgic_its_save.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 5f8d17ee5f677..67a18e6d13177 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -184,6 +184,7 @@ TEST_GEN_PROGS_arm64 += arm64/stage2_block_transitions
 TEST_GEN_PROGS_arm64 += arm64/vcpu_width_config
 TEST_GEN_PROGS_arm64 += arm64/vgic_init
 TEST_GEN_PROGS_arm64 += arm64/vgic_irq
+TEST_GEN_PROGS_arm64 += arm64/vgic_its_save
 TEST_GEN_PROGS_arm64 += arm64/vgic_lpi_stress
 TEST_GEN_PROGS_arm64 += arm64/vgic_v5
 TEST_GEN_PROGS_arm64 += arm64/vpmu_counter_access
diff --git a/tools/testing/selftests/kvm/arm64/vgic_its_save.c b/tools/testing/selftests/kvm/arm64/vgic_its_save.c
new file mode 100644
index 0000000000000..864da01539f3f
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/vgic_its_save.c
@@ -0,0 +1,441 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * vgic_its_save - KVM_DEV_ARM_ITS_SAVE_TABLES against tables a guest broke.
+ *
+ * Both cases are reachable by a guest on its own, and neither may fail a save
+ * that userspace has to be able to issue:
+ *
+ *  - Changing GITS_BASER<coll> drops the collections it described, so the save
+ *    writes nothing but the terminating invalid entry.
+ *  - A device the device table can no longer address is skipped, and the saved
+ *    DTE chain skips it too rather than pointing at an entry never written.
+ *
+ * Both cases then reset and restore, which is what the save exists for.
+ *
+ * Copyright (c) 2026 Google LLC
+ * Author: Fuad Tabba <fuad.tabba@linux.dev>
+ */
+
+#include <endian.h>
+#include <linux/align.h>
+#include <linux/bitfield.h>
+#include <linux/sizes.h>
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
+/* All three ITS table entry sizes are 8 bytes in ABI 0. */
+#define ESZ			8
+#define ENTRIES_PER_PAGE	(SZ_64K / ESZ)
+
+/* CTE and DTE layout, mirroring KVM's KVM_ITS_*  in arch/arm64/kvm/vgic/vgic.h */
+#define CTE_VALID_MASK		BIT_ULL(63)
+#define DTE_VALID_MASK		BIT_ULL(63)
+#define DTE_NEXT_SHIFT		49
+#define DTE_NEXT_MASK		GENMASK_ULL(62, 49)
+
+/* L1 entry of an indirect table: valid bit plus a 64K aligned L2 address. */
+#define L1E_VALID_MASK		BIT_ULL(63)
+#define L1E_ADDR_MASK		GENMASK_ULL(51, 16)
+
+#define GITS_BASER_PAGES_MASK	GENMASK_ULL(7, 0)
+
+#define POISON			0xdeadbeefdeadbeefULL
+
+/* The collection table starts at two pages and is shrunk to one. */
+#define COLL_TBL_PAGES		2
+#define COLL_TBL_SZ		(COLL_TBL_PAGES * SZ_64K)
+
+/* One more collection than the shrunken table can hold. */
+#define NR_COLLECTIONS		(ENTRIES_PER_PAGE + 1)
+
+/* Two devices, one per L2 block of the indirect device table. */
+#define DEVICE_A_ID		0
+#define DEVICE_B_ID		ENTRIES_PER_PAGE
+
+/*
+ * its_send_mapd_cmd() encodes ilog2(itt_size) - 1 as num_eventid_bits, and
+ * vgic_its_restore_itt() scans BIT_ULL(num_eventid_bits) * ESZ, so the size
+ * handed to MAPD has to match the ITT allocated for it.
+ */
+#define ITT_EVENTID_BITS	13
+#define ITT_MAPD_SIZE		BIT_ULL(ITT_EVENTID_BITS + 1)
+#define ITT_SZ			(BIT_ULL(ITT_EVENTID_BITS) * ESZ)
+
+static struct kvm_vm *vm;
+static struct kvm_vcpu *vcpu;
+static int its_fd;
+static gpa_t gpa_base;
+
+static struct test_data {
+	gpa_t		device_table;
+	gpa_t		collection_table;
+	gpa_t		cmdq_base;
+	void		*cmdq_base_va;
+
+	gpa_t		lpi_prop_table;
+	gpa_t		lpi_pend_table;
+
+	void		*device_l1_va;
+	gpa_t		device_l2[2];
+	gpa_t		itt_tables;
+} test_data;
+
+static unsigned long its_baser_offset(unsigned int type)
+{
+	int i;
+
+	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
+		unsigned long offset = GITS_BASER + (i * sizeof(u64));
+		u64 baser = readq_relaxed(GITS_BASE_GVA + offset);
+
+		if (GITS_BASER_TYPE(baser) == type)
+			return offset;
+	}
+
+	GUEST_FAIL("Couldn't find an ITS BASER of type %u", type);
+	return -1;
+}
+
+static void its_set_enable(bool enable)
+{
+	u32 ctlr = readl_relaxed(GITS_BASE_GVA + GITS_CTLR);
+
+	if (enable)
+		ctlr |= GITS_CTLR_ENABLE;
+	else
+		ctlr &= ~GITS_CTLR_ENABLE;
+
+	writel_relaxed(ctlr, GITS_BASE_GVA + GITS_CTLR);
+}
+
+/*
+ * Shrink the collection table to a single page, leaving VALID set. BASER
+ * writes are ignored while the ITS is enabled.
+ */
+static void guest_shrink_coll_table(void)
+{
+	unsigned long offset = its_baser_offset(GITS_BASER_TYPE_COLLECTION);
+	u64 baser;
+
+	its_set_enable(false);
+
+	baser = readq_relaxed(GITS_BASE_GVA + offset);
+	baser &= ~GITS_BASER_PAGES_MASK;
+	writeq_relaxed(baser, GITS_BASE_GVA + offset);
+}
+
+static void guest_baser_change(void)
+{
+	u32 coll_id;
+
+	gic_init(GIC_V3, 1);
+	gic_rdist_enable_lpis(test_data.lpi_prop_table, SZ_64K,
+			      test_data.lpi_pend_table);
+
+	its_init(test_data.collection_table, COLL_TBL_SZ,
+		 test_data.device_table, SZ_64K,
+		 test_data.cmdq_base, SZ_64K);
+
+	for (coll_id = 0; coll_id < NR_COLLECTIONS; coll_id++)
+		its_send_mapc_cmd(test_data.cmdq_base_va, 0, coll_id, true);
+
+	guest_shrink_coll_table();
+
+	GUEST_DONE();
+}
+
+/* Turn the already installed device table into an indirect one. */
+static void guest_make_device_table_indirect(void)
+{
+	unsigned long offset = its_baser_offset(GITS_BASER_TYPE_DEVICE);
+	u64 baser;
+
+	its_set_enable(false);
+
+	baser = readq_relaxed(GITS_BASE_GVA + offset);
+	writeq_relaxed(baser | GITS_BASER_INDIRECT, GITS_BASE_GVA + offset);
+
+	its_set_enable(true);
+}
+
+static void guest_unreachable_device(void)
+{
+	u64 *l1;
+
+	gic_init(GIC_V3, 1);
+	gic_rdist_enable_lpis(test_data.lpi_prop_table, SZ_64K,
+			      test_data.lpi_pend_table);
+
+	its_init(test_data.collection_table, SZ_64K,
+		 test_data.device_table, SZ_64K,
+		 test_data.cmdq_base, SZ_64K);
+
+	guest_make_device_table_indirect();
+
+	/* Both L2 blocks present, so both MAPDs are in range. */
+	l1 = test_data.device_l1_va;
+	l1[0] = L1E_VALID_MASK | (test_data.device_l2[0] & L1E_ADDR_MASK);
+	l1[1] = L1E_VALID_MASK | (test_data.device_l2[1] & L1E_ADDR_MASK);
+
+	its_send_mapd_cmd(test_data.cmdq_base_va, DEVICE_A_ID,
+			  test_data.itt_tables, ITT_MAPD_SIZE, true);
+	its_send_mapd_cmd(test_data.cmdq_base_va, DEVICE_B_ID,
+			  test_data.itt_tables + ITT_SZ, ITT_MAPD_SIZE, true);
+
+	/*
+	 * Drop the block holding device B. No ITS command and no GITS_BASER
+	 * write is involved, so nothing tells KVM the device is now
+	 * unreachable.
+	 */
+	l1[1] = 0;
+
+	GUEST_DONE();
+}
+
+static void run_guest(void)
+{
+	struct ucall uc;
+
+	vcpu_run(vcpu);
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_DONE:
+		break;
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+		break;
+	default:
+		TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
+	}
+}
+
+static int save_tables(void)
+{
+	return __kvm_device_attr_set(its_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				     KVM_DEV_ARM_ITS_SAVE_TABLES, NULL);
+}
+
+static u64 its_reg_get(unsigned long offset)
+{
+	u64 val;
+
+	kvm_device_attr_get(its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS, offset,
+			    &val);
+	return val;
+}
+
+static void its_reg_set(unsigned long offset, u64 val)
+{
+	kvm_device_attr_set(its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS, offset,
+			    &val);
+}
+
+/*
+ * What a migration target does with the saved tables, in the order
+ * Documentation/virt/kvm/devices/arm-vgic-its.rst gives: the GITS_ registers
+ * first, then the tables. The reset in between clears GITS_BASER<n>.Valid,
+ * which is why the registers have to be written back before the restore.
+ */
+static void reset_and_restore_tables(void)
+{
+	u64 baser[GITS_BASER_NR_REGS];
+	int ret, i;
+
+	for (i = 0; i < GITS_BASER_NR_REGS; i++)
+		baser[i] = its_reg_get(GITS_BASER + (i * sizeof(u64)));
+
+	ret = __kvm_device_attr_set(its_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				    KVM_DEV_ARM_ITS_CTRL_RESET, NULL);
+	TEST_ASSERT(!ret, "Expected the reset to succeed, got ret %d errno %d",
+		    ret, errno);
+
+	for (i = 0; i < GITS_BASER_NR_REGS; i++)
+		its_reg_set(GITS_BASER + (i * sizeof(u64)), baser[i]);
+
+	ret = __kvm_device_attr_set(its_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				    KVM_DEV_ARM_ITS_RESTORE_TABLES, NULL);
+	TEST_ASSERT(!ret, "Expected the restore to succeed, got ret %d errno %d",
+		    ret, errno);
+}
+
+static void poison_range(gpa_t base, size_t size)
+{
+	u64 *entry = addr_gpa2hva(vm, base);
+	size_t i;
+
+	for (i = 0; i < size / ESZ; i++)
+		entry[i] = POISON;
+}
+
+static void setup_memslot(size_t sz)
+{
+	size_t pages = sz / vm->page_size;
+
+	gpa_base = ((vm_compute_max_gfn(vm) + 1) * vm->page_size) - sz;
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, gpa_base,
+				    TEST_MEMSLOT_INDEX, pages, 0);
+}
+
+static gpa_t alloc_64k(size_t nr)
+{
+	size_t pages_per_64k = vm_calc_num_guest_pages(vm->mode, SZ_64K);
+	gpa_t gpa = vm_phy_pages_alloc(vm, nr * pages_per_64k, gpa_base,
+				       TEST_MEMSLOT_INDEX);
+
+	TEST_ASSERT(IS_ALIGNED(gpa, SZ_64K),
+		    "Allocation at 0x%lx is not 64K aligned, GITS_BASER cannot address it",
+		    gpa);
+	return gpa;
+}
+
+static void map_to_guest(gpa_t gpa, size_t nr)
+{
+	size_t pages_per_64k = vm_calc_num_guest_pages(vm->mode, SZ_64K);
+
+	virt_map(vm, gpa, gpa, nr * pages_per_64k);
+}
+
+static void setup_common(void)
+{
+	test_data.cmdq_base = alloc_64k(1);
+	map_to_guest(test_data.cmdq_base, 1);
+	test_data.cmdq_base_va = (void *)test_data.cmdq_base;
+
+	test_data.lpi_prop_table = alloc_64k(1);
+	test_data.lpi_pend_table = alloc_64k(1);
+}
+
+static void teardown(void)
+{
+	close(its_fd);
+	kvm_vm_free(vm);
+	memset(&test_data, 0, sizeof(test_data));
+}
+
+/*
+ * A GITS_BASER<coll> write that changes the table drops the collections it
+ * described. The save then has an empty list, so it writes the terminating
+ * invalid entry and nothing else.
+ */
+static void test_baser_change_drops_collections(void)
+{
+	u64 *cte;
+	int ret, i;
+
+	pr_info("Testing that a GITS_BASER change drops the collections\n");
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_baser_change);
+	setup_memslot((4 + COLL_TBL_PAGES) * SZ_64K);
+	its_fd = vgic_its_setup(vm);
+
+	test_data.device_table = alloc_64k(1);
+	test_data.collection_table = alloc_64k(COLL_TBL_PAGES);
+	setup_common();
+
+	sync_global_to_guest(vm, test_data);
+	run_guest();
+
+	/* Anything KVM writes is then the only thing that changed. */
+	poison_range(test_data.collection_table, COLL_TBL_SZ);
+
+	ret = save_tables();
+	TEST_ASSERT(!ret, "Expected the save to succeed, got %d errno %d",
+		    ret, errno);
+
+	cte = addr_gpa2hva(vm, test_data.collection_table);
+
+	/*
+	 * Finding the terminator at the head of the table is also what proves
+	 * the reads below landed in the saved table rather than elsewhere.
+	 */
+	TEST_ASSERT(le64toh(cte[0]) == 0,
+		    "CTE 0: expected the terminating invalid entry, got 0x%llx",
+		    (unsigned long long)le64toh(cte[0]));
+
+	for (i = 1; i < COLL_TBL_SZ / ESZ; i++)
+		TEST_ASSERT(cte[i] == POISON,
+			    "CTE %d: expected it untouched, got 0x%llx",
+			    i, (unsigned long long)cte[i]);
+
+	reset_and_restore_tables();
+
+	teardown();
+}
+
+/*
+ * A device whose L2 block the guest dropped is skipped by the save, and the
+ * DTE chain skips it too: left alone, the surviving device would point at an
+ * entry the save never wrote.
+ */
+static void test_unreachable_device_skipped(void)
+{
+	u64 dte;
+	int ret;
+
+	pr_info("Testing that an unreachable device is skipped by the save\n");
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_unreachable_device);
+	setup_memslot(9 * SZ_64K);
+	its_fd = vgic_its_setup(vm);
+
+	test_data.device_table = alloc_64k(1);
+	test_data.collection_table = alloc_64k(1);
+	test_data.device_l2[0] = alloc_64k(1);
+	test_data.device_l2[1] = alloc_64k(1);
+	test_data.itt_tables = alloc_64k(2);
+	setup_common();
+
+	map_to_guest(test_data.device_table, 1);
+	test_data.device_l1_va = (void *)test_data.device_table;
+
+	sync_global_to_guest(vm, test_data);
+	run_guest();
+
+	poison_range(test_data.device_l2[0], SZ_64K);
+	poison_range(test_data.device_l2[1], SZ_64K);
+
+	ret = save_tables();
+	TEST_ASSERT(!ret, "Expected the save to succeed, got %d errno %d",
+		    ret, errno);
+
+	dte = le64toh(*(u64 *)addr_gpa2hva(vm, test_data.device_l2[0]));
+
+	/* Device A is still reachable, so it is saved. */
+	TEST_ASSERT(dte & DTE_VALID_MASK,
+		    "Device A: expected a valid DTE, got 0x%llx",
+		    (unsigned long long)dte);
+
+	/*
+	 * Device B is the only device after it and was skipped, so nothing
+	 * follows A in the saved chain.
+	 */
+	TEST_ASSERT(FIELD_GET(DTE_NEXT_MASK, dte) == 0,
+		    "Device A: expected no next device, got offset %llu",
+		    (unsigned long long)FIELD_GET(DTE_NEXT_MASK, dte));
+
+	/* And nothing was written into the block the guest dropped. */
+	TEST_ASSERT(*(u64 *)addr_gpa2hva(vm, test_data.device_l2[1]) == POISON,
+		    "Device B: expected its entry untouched");
+
+	reset_and_restore_tables();
+
+	teardown();
+}
+
+int main(void)
+{
+	TEST_REQUIRE(kvm_supports_vgic_v3());
+
+	test_baser_change_drops_collections();
+	test_unreachable_device_skipped();
+
+	pr_info("All ok!\n");
+	return 0;
+}
-- 
2.39.5

