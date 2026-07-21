Received: from confino.investici.org (confino.investici.org [93.190.126.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1914368277
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 11:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.190.126.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784632983; cv=none; b=fvuKugJH3aGHwCPkOvII9olvr0Fesie2kQaUSxAKUCHS5PVXYHEf/hrB9KN+0b+y80PMV9VNe/jqrrs3W33odYyvebK2IWE5T8ErVfs9Xi577nO6MX4MXJBlDDpkHW7IHxRe665hdmT9TQKnEs7znBfAb6lFEFCDOL3igvLJyV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784632983; c=relaxed/simple;
	bh=kIEpfRlrrCK2sR4T4ELJHCj3Pm6tkg5hwWj73yTHdQE=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=cQkGoESiCiXLRdBJj+/jbtGrn0wNSS8vTnB/WALJ3RCjzqFGRlzxA7NZpDzfR9gQN6BsMWT/Xmfe2qRBUS2iLdvqjkzL0PPLABul/kynX8w5+QiyBziRkGcRlID6XrBIGpUgmKTCp3lal3IUc53QSgmxNcW7zLJwrHRM4Nuf1NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net; spf=pass smtp.mailfrom=grrlz.net; dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b=rnOFMLS4; arc=none smtp.client-ip=93.190.126.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=grrlz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b="rnOFMLS4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1784632979;
	bh=bkKgiSgwNo+GMAJd6HXm6DP5HPK0+MJe7fajjldXVB0=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=rnOFMLS4B/nYuiwF7hbFwE+ZnonROF7fdM5tr6kScLHUSBebN4Szmv4f7z+Ax+hTm
	 TpbW8d2z0GXeCvcO4B/SzusMY9p0Wj55QrdXtlsGFxv4CWcDSw1eNeJIXk5h+eRCUK
	 PYWqPcQF5eeqXAj0fAQ9E7N5JDqzUpatq8up87Rk=
Received: from mx1.investici.org (unknown [127.0.0.1])
	by confino.investici.org (Postfix) with ESMTP id 4h4FNz0Chlz10s7;
	Tue, 21 Jul 2026 11:22:59 +0000 (UTC)
Received: by mx1.investici.org (Postfix) id 4h4FNx60mCz10s2;
	Tue, 21 Jul 2026 11:22:57 +0000 (UTC)
Date: Tue, 21 Jul 2026 12:22:56 +0100
From: Bradley Morgan <include@grrlz.net>
To: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>
CC: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Shuah Khan <shuah@kernel.org>, Quentin Perret <qperret@google.com>,
 Vincent Donnefort <vdonnefort@google.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>, Gavin Shan <gshan@redhat.com>,
 Dev Jain <dev.jain@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v5_7/7=5D_KVM=3A_arm64=3A_selfte?=
 =?US-ASCII?Q?sts=3A_Add_stage-2_block_transition_test?=
In-Reply-To: <20260717130317.1953574-8-fuad.tabba@linux.dev>
References: <20260717130317.1953574-1-fuad.tabba@linux.dev> <20260717130317.1953574-8-fuad.tabba@linux.dev>
Message-ID: <73450F8F-7C0E-43C4-ABFE-90C3265399B0@grrlz.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On July 17, 2026 2:03:17 PM GMT+01:00, Fuad Tabba <fuad.tabba@linux.dev>
wrote:
>Add a test for the two stage-2 granularity changes dirty logging forces
>at fault time, asserting the guest completes with no KVM_RUN error. The
>first scenario collapses a page into a hugetlb-backed block: it writes
>under logging, re-write-protects the page via GET_DIRTY_LOG, then writes
>again with logging off. The second splits blocks: it faults in several
>non-executable 2M blocks, enables logging, then executes in each block so
>an execute permission fault splits it. It is skipped when CTR_EL0.DIC is
>set, since mappings are then executable and no execute fault occurs.
>
>Both paths make the fault handler allocate under mmu_lock, so a backend
>that fails to stage that memory returns a KVM_RUN error or crashes the
>host. The property holds on any host. On a pKVM host, where a
>non-protected guest uses the pkvm_pgtable_*() backend, it also guards
>that backend's fault-time staging.
>
>Assisted-by: Antigravity:gemini-3.1-pro
>Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Tested-by: Bradley Morgan <include@grrlz.net> # On QEMU arm64 host




>---
> tools/testing/selftests/kvm/Makefile.kvm      |   1 +
> .../kvm/arm64/stage2_block_transitions.c      | 226 ++++++++++++++++++
> 2 files changed, 227 insertions(+)
> create mode 100644
> tools/testing/selftests/kvm/arm64/stage2_block_transitions.c
>
>diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
>index d28a057fa6c2..ed2877825eee 100644
>--- a/tools/testing/selftests/kvm/Makefile.kvm
>+++ b/tools/testing/selftests/kvm/Makefile.kvm
>@@ -179,6 +179,7 @@ TEST_GEN_PROGS_arm64 += arm64/psci_test
> TEST_GEN_PROGS_arm64 += arm64/sea_to_user
> TEST_GEN_PROGS_arm64 += arm64/set_id_regs
> TEST_GEN_PROGS_arm64 += arm64/smccc_filter
>+TEST_GEN_PROGS_arm64 += arm64/stage2_block_transitions
> TEST_GEN_PROGS_arm64 += arm64/vcpu_width_config
> TEST_GEN_PROGS_arm64 += arm64/vgic_init
> TEST_GEN_PROGS_arm64 += arm64/vgic_irq
>diff --git a/tools/testing/selftests/kvm/arm64/stage2_block_transitions.c b/tools/testing/selftests/kvm/arm64/stage2_block_transitions.c
>new file mode 100644
>index 000000000000..5fd47f4ada1f
>--- /dev/null
>+++ b/tools/testing/selftests/kvm/arm64/stage2_block_transitions.c
>@@ -0,0 +1,226 @@
>+// SPDX-License-Identifier: GPL-2.0-only
>+/*
>+ * Copyright (c) 2026 Google LLC
>+ * Author: Fuad Tabba <fuad.tabba@linux.dev>
>+ *
>+ * stage2_block_transitions - Exercise stage-2 block/page granularity changes
>+ * that dirty logging forces at fault time, and assert the guest completes.
>+ *
>+ * Both scenarios need the fault handler to allocate at fault time (a fresh
>+ * mapping and/or page-table pages while holding mmu_lock), so a fault path
>+ * that fails to stage that memory manifests as a KVM_RUN error or, worse, a
>+ * host crash. The asserted property is host-agnostic: the guest runs the
>+ * sequence to completion and every KVM_RUN succeeds. On a pKVM host, where a
>+ * non-protected guest's stage-2 faults are serviced by the pkvm_pgtable_*()
>+ * backend, the same sequences also guard that backend's fault-time staging.
>+ *
>+ * Scenario 1 - block collapse on dirty-logging disable:
>+ *   A write under dirty logging installs a 4K page; GET_DIRTY_LOG
>+ *   re-write-protects it; logging is disabled; a second write takes a
>+ *   permission fault that collapses the page into a hugetlb-backed block,
>+ *   which requires a fresh mapping object under mmu_lock.
>+ *
>+ * Scenario 2 - block split under dirty logging:
>+ *   Several hugetlb-backed blocks are faulted in as non-executable blocks,
>+ *   dirty logging is enabled (write-protect only), then the guest executes
>+ *   into each block. Each instruction fetch takes an execute permission
>+ *   fault that must split the block into pages during logging, draining
>+ *   page-table pages. Skipped on CTR_EL0.DIC hardware, where mappings are
>+ *   made executable eagerly and the execute fault never occurs.
>+ */
>+#include <linux/bitfield.h>
>+#include <linux/bitmap.h>
>+#include <linux/mman.h>
>+#include <linux/sizes.h>
>+#include <sys/mman.h>
>+
>+#include <asm/sysreg.h>
>+
>+#include "kvm_util.h"
>+#include "processor.h"
>+#include "test_util.h"
>+#include "ucall.h"
>+
>+#define DATA_SLOT		1
>+#define TEST_GVA		0xc0000000UL
>+#define BLOCK_SIZE		SZ_2M
>+
>+/* AArch64 "ret" (ret x30): a self-contained, returnable executable payload. */
>+#define RET_INSN		0xd65f03c0U
>+
>+/*
>+ * A non-protected guest's per-VM stage-2 pool is seeded only with the PGD
>+ * donation, which stage-2 init immediately consumes, so the page-table budget
>+ * for a fault that does not top up is just the handful (~2x the stage-2 min
>+ * pages) of memcache leftovers. Executing into this many distinct blocks
>+ * demands far more than that budget: a fault path that tops up on every fault
>+ * completes all of them, one that skips non-write faults runs out mid-sequence.
>+ */
>+#define NR_BLOCKS		16
>+
>+/* Scenario 2 guest -> host sync stages. */
>+#define STAGE_SKIP_DIC		1
>+#define STAGE_BLOCKS_READY	2
>+
>+static void collapse_guest_code(u64 gva)
>+{
>+	u64 *data = (u64 *)gva;
>+
>+	/* Under dirty logging: install a 4K writable page. */
>+	WRITE_ONCE(*data, 0x1);
>+	GUEST_SYNC(1);
>+
>+	/* Logging disabled: a permission fault collapses the page into a block. */
>+	WRITE_ONCE(*data, 0x2);
>+	GUEST_SYNC(2);
>+
>+	GUEST_DONE();
>+}
>+
>+static void test_block_collapse(void)
>+{
>+	struct kvm_vcpu *vcpu;
>+	unsigned long *bmap;
>+	struct kvm_vm *vm;
>+	struct ucall uc;
>+	size_t npages;
>+	u64 gpa;
>+
>+	vm = vm_create_with_one_vcpu(&vcpu, collapse_guest_code);
>+	npages = BLOCK_SIZE / vm->page_size;
>+
>+	gpa = (vm_compute_max_gfn(vm) * vm->page_size) - BLOCK_SIZE;
>+	gpa = align_down(gpa, BLOCK_SIZE);
>+
>+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB_2MB, gpa,
>+				    DATA_SLOT, npages, KVM_MEM_LOG_DIRTY_PAGES);
>+	virt_map(vm, TEST_GVA, gpa, npages);
>+	vcpu_args_set(vcpu, 1, TEST_GVA);
>+
>+	bmap = bitmap_zalloc(BLOCK_SIZE / getpagesize());
>+
>+	vcpu_run(vcpu);
>+	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_SYNC && uc.args[1] == 1,
>+		    "Expected first sync, got cmd %lu arg %lu", uc.cmd, uc.args[1]);
>+
>+	/* GET_DIRTY_LOG re-write-protects the dirtied page; then stop logging. */
>+	kvm_vm_get_dirty_log(vm, DATA_SLOT, bmap);
>+	vm_mem_region_set_flags(vm, DATA_SLOT, 0);
>+
>+	/* The collapsing permission fault: a broken fault path faults here. */
>+	vcpu_run(vcpu);
>+	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_SYNC && uc.args[1] == 2,
>+		    "Expected second sync, got cmd %lu arg %lu", uc.cmd, uc.args[1]);
>+
>+	vcpu_run(vcpu);
>+	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_DONE,
>+		    "Expected done, got cmd %lu", uc.cmd);
>+
>+	free(bmap);
>+	kvm_vm_free(vm);
>+}
>+
>+static void guest_sync_insn(u64 va)
>+{
>+	/* Make the just-written instruction coherent for execution (!DIC). */
>+	asm volatile("dc cvau, %0\n"
>+		     "dsb ish\n"
>+		     "ic ivau, %0\n"
>+		     "dsb ish\n"
>+		     "isb\n"
>+		     :: "r" (va) : "memory");
>+}
>+
>+static void split_guest_code(u64 base_gva, u64 nblocks)
>+{
>+	u64 i, va;
>+
>+	if (FIELD_GET(CTR_EL0_DIC_MASK, read_sysreg(ctr_el0))) {
>+		GUEST_SYNC(STAGE_SKIP_DIC);
>+		GUEST_DONE();
>+		return;
>+	}
>+
>+	/* Fault in each block (non-executable) and stage an executable payload. */
>+	for (i = 0; i < nblocks; i++) {
>+		va = base_gva + i * BLOCK_SIZE;
>+		WRITE_ONCE(*(u32 *)va, RET_INSN);
>+		guest_sync_insn(va);
>+	}
>+	GUEST_SYNC(STAGE_BLOCKS_READY);
>+
>+	/* Logging is now on: executing into each block splits it into pages. */
>+	for (i = 0; i < nblocks; i++) {
>+		va = base_gva + i * BLOCK_SIZE;
>+		((void (*)(void))va)();
>+	}
>+
>+	GUEST_DONE();
>+}
>+
>+static void test_exec_split_drain(void)
>+{
>+	struct kvm_vcpu *vcpu;
>+	struct kvm_vm *vm;
>+	struct ucall uc;
>+	size_t npages;
>+	u64 gpa;
>+
>+	vm = vm_create_with_one_vcpu(&vcpu, split_guest_code);
>+	npages = NR_BLOCKS * (BLOCK_SIZE / vm->page_size);
>+
>+	gpa = (vm_compute_max_gfn(vm) * vm->page_size) - NR_BLOCKS * BLOCK_SIZE;
>+	gpa = align_down(gpa, BLOCK_SIZE);
>+
>+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB_2MB, gpa,
>+				    DATA_SLOT, npages, 0);
>+	virt_map(vm, TEST_GVA, gpa, npages);
>+	vcpu_args_set(vcpu, 2, TEST_GVA, (u64)NR_BLOCKS);
>+
>+	vcpu_run(vcpu);
>+	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_SYNC,
>+		    "Expected sync, got cmd %lu", uc.cmd);
>+	if (uc.args[1] == STAGE_SKIP_DIC) {
>+		ksft_print_msg("SKIP block split: CTR_EL0.DIC == 1\n");
>+		kvm_vm_free(vm);
>+		return;
>+	}
>+	TEST_ASSERT(uc.args[1] == STAGE_BLOCKS_READY,
>+		    "Expected blocks-ready sync, got arg %lu", uc.args[1]);
>+
>+	/* Write-protect the blocks; the guest then splits them by executing. */
>+	vm_mem_region_set_flags(vm, DATA_SLOT, KVM_MEM_LOG_DIRTY_PAGES);
>+
>+	vcpu_run(vcpu);
>+	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_DONE,
>+		    "Expected done, got cmd %lu", uc.cmd);
>+
>+	kvm_vm_free(vm);
>+}
>+
>+/*
>+ * The explicit-size hugetlb backing hard-fails region creation if the pages
>+ * are not already reserved, so probe here and skip rather than abort. The
>+ * peak reservation is scenario 2's; the two scenarios run and free in turn.
>+ */
>+static void require_hugepages(size_t bytes)
>+{
>+	void *mem = mmap(NULL, bytes, PROT_READ | PROT_WRITE,
>+			 MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_HUGE_2MB,
>+			 -1, 0);
>+
>+	if (mem == MAP_FAILED)
>+		ksft_exit_skip("Need %zu bytes of reserved 2M hugepages\n", bytes);
>+	munmap(mem, bytes);
>+}
>+
>+int main(void)
>+{
>+	require_hugepages(NR_BLOCKS * BLOCK_SIZE);
>+
>+	test_block_collapse();
>+	test_exec_split_drain();
>+
>+	ksft_print_msg("All ok!\n");
>+	return 0;
>+}
>

Thanks!
