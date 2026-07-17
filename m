Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EAE3FF1CB
	for <kvmarm@lists.linux.dev>; Fri, 17 Jul 2026 13:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784293457; cv=none; b=ZYEObHPrNt2r7Sjy/EU1nhplHIidbu/eiumkRVLJbumUG7hA9B3xEyf3wcLJHxVep4koZLRJuQuTM9/S7AU8m7ThogTtWK9AuJhv0aOqy5BHHEYFMlCrlNQx625NaPft8Rg2I8nm6SZ1lkIn68LMZzrT7GSB53YxlCellzz4t0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784293457; c=relaxed/simple;
	bh=7z5FGVOAfSolooaQgQMq2u00zHDHxGUneImlxsVYphQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eV4CPnTtvWkCLi3eaYFF48XEY/QW4AKVE/Kz8IbibnO0T/tVTSlVhiIEgLpipmItobS4w6NesQ9blSjq9v7Czb6a844+Mjigd9j7L3DS4ZUvz8101YDr0eRbBD2P/xkOIIPFVl/CD/Th+P9KMRDXgDevqYv9ROpE+uz7PGGhW24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IKq3ZohP; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IKq3ZohP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784293453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZSov26SoNzFoDbQjfVuL51TE+LmJwc4x9zfxixe6C8U=;
	b=IKq3ZohPaJOeF+j9hraLAzAOKhLZYJH53ntijnNYC+nqxylG9cyara1oELMIlARuR++bqL
	6czgAMP6YsoasbgSfLMqTB+73C3857pFILaD7ODjjxlUaNvwFlxTlKo0hVqLtj/4T3HvSu
	CkdEgv6AqtFLpmCCV2ZsvJc1IK5d8ko=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	Bradley Morgan <include@grrlz.net>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 7/7] KVM: arm64: selftests: Add stage-2 block transition test
Date: Fri, 17 Jul 2026 14:03:17 +0100
Message-Id: <20260717130317.1953574-8-fuad.tabba@linux.dev>
In-Reply-To: <20260717130317.1953574-1-fuad.tabba@linux.dev>
References: <20260717130317.1953574-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add a test for the two stage-2 granularity changes dirty logging forces
at fault time, asserting the guest completes with no KVM_RUN error. The
first scenario collapses a page into a hugetlb-backed block: it writes
under logging, re-write-protects the page via GET_DIRTY_LOG, then writes
again with logging off. The second splits blocks: it faults in several
non-executable 2M blocks, enables logging, then executes in each block so
an execute permission fault splits it. It is skipped when CTR_EL0.DIC is
set, since mappings are then executable and no execute fault occurs.

Both paths make the fault handler allocate under mmu_lock, so a backend
that fails to stage that memory returns a KVM_RUN error or crashes the
host. The property holds on any host. On a pKVM host, where a
non-protected guest uses the pkvm_pgtable_*() backend, it also guards
that backend's fault-time staging.

Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../kvm/arm64/stage2_block_transitions.c      | 226 ++++++++++++++++++
 2 files changed, 227 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/stage2_block_transitions.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index d28a057fa6c2..ed2877825eee 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -179,6 +179,7 @@ TEST_GEN_PROGS_arm64 += arm64/psci_test
 TEST_GEN_PROGS_arm64 += arm64/sea_to_user
 TEST_GEN_PROGS_arm64 += arm64/set_id_regs
 TEST_GEN_PROGS_arm64 += arm64/smccc_filter
+TEST_GEN_PROGS_arm64 += arm64/stage2_block_transitions
 TEST_GEN_PROGS_arm64 += arm64/vcpu_width_config
 TEST_GEN_PROGS_arm64 += arm64/vgic_init
 TEST_GEN_PROGS_arm64 += arm64/vgic_irq
diff --git a/tools/testing/selftests/kvm/arm64/stage2_block_transitions.c b/tools/testing/selftests/kvm/arm64/stage2_block_transitions.c
new file mode 100644
index 000000000000..5fd47f4ada1f
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/stage2_block_transitions.c
@@ -0,0 +1,226 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2026 Google LLC
+ * Author: Fuad Tabba <fuad.tabba@linux.dev>
+ *
+ * stage2_block_transitions - Exercise stage-2 block/page granularity changes
+ * that dirty logging forces at fault time, and assert the guest completes.
+ *
+ * Both scenarios need the fault handler to allocate at fault time (a fresh
+ * mapping and/or page-table pages while holding mmu_lock), so a fault path
+ * that fails to stage that memory manifests as a KVM_RUN error or, worse, a
+ * host crash. The asserted property is host-agnostic: the guest runs the
+ * sequence to completion and every KVM_RUN succeeds. On a pKVM host, where a
+ * non-protected guest's stage-2 faults are serviced by the pkvm_pgtable_*()
+ * backend, the same sequences also guard that backend's fault-time staging.
+ *
+ * Scenario 1 - block collapse on dirty-logging disable:
+ *   A write under dirty logging installs a 4K page; GET_DIRTY_LOG
+ *   re-write-protects it; logging is disabled; a second write takes a
+ *   permission fault that collapses the page into a hugetlb-backed block,
+ *   which requires a fresh mapping object under mmu_lock.
+ *
+ * Scenario 2 - block split under dirty logging:
+ *   Several hugetlb-backed blocks are faulted in as non-executable blocks,
+ *   dirty logging is enabled (write-protect only), then the guest executes
+ *   into each block. Each instruction fetch takes an execute permission
+ *   fault that must split the block into pages during logging, draining
+ *   page-table pages. Skipped on CTR_EL0.DIC hardware, where mappings are
+ *   made executable eagerly and the execute fault never occurs.
+ */
+#include <linux/bitfield.h>
+#include <linux/bitmap.h>
+#include <linux/mman.h>
+#include <linux/sizes.h>
+#include <sys/mman.h>
+
+#include <asm/sysreg.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+#include "ucall.h"
+
+#define DATA_SLOT		1
+#define TEST_GVA		0xc0000000UL
+#define BLOCK_SIZE		SZ_2M
+
+/* AArch64 "ret" (ret x30): a self-contained, returnable executable payload. */
+#define RET_INSN		0xd65f03c0U
+
+/*
+ * A non-protected guest's per-VM stage-2 pool is seeded only with the PGD
+ * donation, which stage-2 init immediately consumes, so the page-table budget
+ * for a fault that does not top up is just the handful (~2x the stage-2 min
+ * pages) of memcache leftovers. Executing into this many distinct blocks
+ * demands far more than that budget: a fault path that tops up on every fault
+ * completes all of them, one that skips non-write faults runs out mid-sequence.
+ */
+#define NR_BLOCKS		16
+
+/* Scenario 2 guest -> host sync stages. */
+#define STAGE_SKIP_DIC		1
+#define STAGE_BLOCKS_READY	2
+
+static void collapse_guest_code(u64 gva)
+{
+	u64 *data = (u64 *)gva;
+
+	/* Under dirty logging: install a 4K writable page. */
+	WRITE_ONCE(*data, 0x1);
+	GUEST_SYNC(1);
+
+	/* Logging disabled: a permission fault collapses the page into a block. */
+	WRITE_ONCE(*data, 0x2);
+	GUEST_SYNC(2);
+
+	GUEST_DONE();
+}
+
+static void test_block_collapse(void)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long *bmap;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	size_t npages;
+	u64 gpa;
+
+	vm = vm_create_with_one_vcpu(&vcpu, collapse_guest_code);
+	npages = BLOCK_SIZE / vm->page_size;
+
+	gpa = (vm_compute_max_gfn(vm) * vm->page_size) - BLOCK_SIZE;
+	gpa = align_down(gpa, BLOCK_SIZE);
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB_2MB, gpa,
+				    DATA_SLOT, npages, KVM_MEM_LOG_DIRTY_PAGES);
+	virt_map(vm, TEST_GVA, gpa, npages);
+	vcpu_args_set(vcpu, 1, TEST_GVA);
+
+	bmap = bitmap_zalloc(BLOCK_SIZE / getpagesize());
+
+	vcpu_run(vcpu);
+	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_SYNC && uc.args[1] == 1,
+		    "Expected first sync, got cmd %lu arg %lu", uc.cmd, uc.args[1]);
+
+	/* GET_DIRTY_LOG re-write-protects the dirtied page; then stop logging. */
+	kvm_vm_get_dirty_log(vm, DATA_SLOT, bmap);
+	vm_mem_region_set_flags(vm, DATA_SLOT, 0);
+
+	/* The collapsing permission fault: a broken fault path faults here. */
+	vcpu_run(vcpu);
+	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_SYNC && uc.args[1] == 2,
+		    "Expected second sync, got cmd %lu arg %lu", uc.cmd, uc.args[1]);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_DONE,
+		    "Expected done, got cmd %lu", uc.cmd);
+
+	free(bmap);
+	kvm_vm_free(vm);
+}
+
+static void guest_sync_insn(u64 va)
+{
+	/* Make the just-written instruction coherent for execution (!DIC). */
+	asm volatile("dc cvau, %0\n"
+		     "dsb ish\n"
+		     "ic ivau, %0\n"
+		     "dsb ish\n"
+		     "isb\n"
+		     :: "r" (va) : "memory");
+}
+
+static void split_guest_code(u64 base_gva, u64 nblocks)
+{
+	u64 i, va;
+
+	if (FIELD_GET(CTR_EL0_DIC_MASK, read_sysreg(ctr_el0))) {
+		GUEST_SYNC(STAGE_SKIP_DIC);
+		GUEST_DONE();
+		return;
+	}
+
+	/* Fault in each block (non-executable) and stage an executable payload. */
+	for (i = 0; i < nblocks; i++) {
+		va = base_gva + i * BLOCK_SIZE;
+		WRITE_ONCE(*(u32 *)va, RET_INSN);
+		guest_sync_insn(va);
+	}
+	GUEST_SYNC(STAGE_BLOCKS_READY);
+
+	/* Logging is now on: executing into each block splits it into pages. */
+	for (i = 0; i < nblocks; i++) {
+		va = base_gva + i * BLOCK_SIZE;
+		((void (*)(void))va)();
+	}
+
+	GUEST_DONE();
+}
+
+static void test_exec_split_drain(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	size_t npages;
+	u64 gpa;
+
+	vm = vm_create_with_one_vcpu(&vcpu, split_guest_code);
+	npages = NR_BLOCKS * (BLOCK_SIZE / vm->page_size);
+
+	gpa = (vm_compute_max_gfn(vm) * vm->page_size) - NR_BLOCKS * BLOCK_SIZE;
+	gpa = align_down(gpa, BLOCK_SIZE);
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB_2MB, gpa,
+				    DATA_SLOT, npages, 0);
+	virt_map(vm, TEST_GVA, gpa, npages);
+	vcpu_args_set(vcpu, 2, TEST_GVA, (u64)NR_BLOCKS);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_SYNC,
+		    "Expected sync, got cmd %lu", uc.cmd);
+	if (uc.args[1] == STAGE_SKIP_DIC) {
+		ksft_print_msg("SKIP block split: CTR_EL0.DIC == 1\n");
+		kvm_vm_free(vm);
+		return;
+	}
+	TEST_ASSERT(uc.args[1] == STAGE_BLOCKS_READY,
+		    "Expected blocks-ready sync, got arg %lu", uc.args[1]);
+
+	/* Write-protect the blocks; the guest then splits them by executing. */
+	vm_mem_region_set_flags(vm, DATA_SLOT, KVM_MEM_LOG_DIRTY_PAGES);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_DONE,
+		    "Expected done, got cmd %lu", uc.cmd);
+
+	kvm_vm_free(vm);
+}
+
+/*
+ * The explicit-size hugetlb backing hard-fails region creation if the pages
+ * are not already reserved, so probe here and skip rather than abort. The
+ * peak reservation is scenario 2's; the two scenarios run and free in turn.
+ */
+static void require_hugepages(size_t bytes)
+{
+	void *mem = mmap(NULL, bytes, PROT_READ | PROT_WRITE,
+			 MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_HUGE_2MB,
+			 -1, 0);
+
+	if (mem == MAP_FAILED)
+		ksft_exit_skip("Need %zu bytes of reserved 2M hugepages\n", bytes);
+	munmap(mem, bytes);
+}
+
+int main(void)
+{
+	require_hugepages(NR_BLOCKS * BLOCK_SIZE);
+
+	test_block_collapse();
+	test_exec_split_drain();
+
+	ksft_print_msg("All ok!\n");
+	return 0;
+}
-- 
2.39.5

