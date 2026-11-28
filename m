Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795828543;
	b=z30zdYdREQCXEj4wywpWtPscIKx6RwoiCt58NhBnAGrTm96Dqo+xyzzhwmKJj4rYtf8g
	 DA4d44g1DRhaPx9EGV2QXVu5DB60w/IBzY1Io7KN7SegNpWdRTXR0zpOjv6MUeJiFb2B4
	 ETOfzDz4R2k3Mr0LGlzWA376+9YihMHm8XwXFaYMJ4cUDtQ6DEC2WWParxRp/YVxVzoIL
	 OG9/mE7/W8C0cZVIHpXuFV0XVz07LJDwFLjBJjPAxhpXJotXBVD82iVlTIFxCDzh6FNRB
	 0npakaW2qZTdPupn1TuVkx48+5pmYR3VpqbJ+3vxjWP4qur4Id1c/F9tQR7mutoVH/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795828543;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wG2fppSN3bOHhjJa8gnr78h7a8vh0Jg4/WFbJqP4S6g=;
	b=5mYTssNHyaNCPVkGsIZRgO7KnFvQbSP+ugNcEJRuXoDs7ziSt3fXml5pEdoux42eU4Gg
	 eXL9jG9nbXdWy/qw4a5LfhvLCByFnPicnAb82u4FpS52pfXS3qtj6IcFT19x7lN6O69hW
	 r0HoiIdPZnQ4MR0ZDFe3Qe+oDehAx6RM6lKgVvc9YlCDXs8hVmnNsnPwt4igIpc92d+aO
	 lOTxvLusKlz59vUTfvtvpq00hrp0urgwYXqZEAUZ9QxlhkZJvSHcsyUIvrK0djuv6lmo0
	 TUx9LuWvbAI6lnvEnUrjxlgczRr8k9GAIeVJauGEjsPGafdGyUzPInlokGEA4PRyKGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=EeweemOq;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EBCF606A31C
	for <kvmarm@lists.linux.dev>; Sat, 28 Nov 2026 01:15:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9EBCF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=EeweemOq
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35CA81575;
	Fri, 27 Nov 2026 17:15:39 -0800 (PST)
Received: from entos-yitian-01.Arm.com (unknown [10.168.196.233])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BBBF53F632;
	Fri, 27 Nov 2026 17:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795828542; bh=fF6/t2/sZ1LQB5KzH8D06Rg4oPYv0fwbe3SDyWDyba0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EeweemOq66MHd5Zzu3nuVp9ua/hnfOck/s+5Jvirtb9YT0pXuzxVZ6E8ktcQeXOB5
	 ZWUfzI5vHCQ8lebvSICaArBSiyu2j4BbhTYTvYN+slbIFry/bDiYd3Eoz7kkkxVGQQ
	 R6Rzr3HsdZKT1OVViex+dpX+GyWzVvyUtZUEK54M=
From: Jia He <justin.he@arm.com>
To: maz@kernel.org,
	oupton@kernel.org
Cc: fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	shuah@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jia He <justin.he@arm.com>
Subject: [PATCH v3 3/4] KVM: arm64: selftests: Add a test for VNCR_EL2 translation faults
Date: Sat, 28 Nov 2026 01:14:46 +0000
Message-Id: <20261128011447.3588988-4-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261128011447.3588988-1-justin.he@arm.com>
References: <20261128011447.3588988-1-justin.he@arm.com>
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

Add a test where the guest hypervisor enters a nested context with
HCR_EL2.{NV,NV2} set and reads VTTBR_EL2, which FEAT_NV2 turns into a
load from the VNCR page. The last-level table that maps the VNCR page is
placed in a read-only memslot, and TCR_EL2.HA is set.

With the access flag set, KVM maps the VNCR page and the read returns
the value in that page. With the access flag clear, KVM cannot update the
descriptor and must inject an SEA on translation table walk into the
guest hypervisor. A control case with the table in a writable memslot
checks that KVM sets the access flag and maps the page.

The VNCR page is mapped at a VA whose bits [15:12] differ from those of
its PA. On a host with 16K or 64K pages, this also checks that KVM
locates the VNCR page in the host page from its PA.

Signed-off-by: Jia He <justin.he@arm.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/nv_vncr_abort.c       | 221 ++++++++++++++++++
 2 files changed, 222 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/nv_vncr_abort.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 17a4256e9081..2cf70b585c03 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -185,6 +185,7 @@ TEST_GEN_PROGS_arm64 += arm64/hello_el2
 TEST_GEN_PROGS_arm64 += arm64/host_sve
 TEST_GEN_PROGS_arm64 += arm64/hypercalls
 TEST_GEN_PROGS_arm64 += arm64/nv_pre_fault_memory_test
+TEST_GEN_PROGS_arm64 += arm64/nv_vncr_abort
 TEST_GEN_PROGS_arm64 += arm64/external_aborts
 TEST_GEN_PROGS_arm64 += arm64/mmio_sign_ext
 TEST_GEN_PROGS_arm64 += arm64/page_fault_test
diff --git a/tools/testing/selftests/kvm/arm64/nv_vncr_abort.c b/tools/testing/selftests/kvm/arm64/nv_vncr_abort.c
new file mode 100644
index 000000000000..0279a9990d28
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/nv_vncr_abort.c
@@ -0,0 +1,221 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * nv_vncr_abort - Test KVM's handling of VNCR_EL2 translation faults.
+ *
+ * The guest hypervisor enters a nested context with HCR_EL2.{NV,NV2} set
+ * and reads VTTBR_EL2, which FEAT_NV2 turns into a load from the VNCR page.
+ * KVM translates VNCR_EL2 with its software stage-1 walker. The last-level
+ * table for the VNCR page is placed in a read-only memslot, optionally with
+ * the access flag clear. With TCR_EL2.HA set, KVM then cannot update the
+ * descriptor and must inject an SEA on translation table walk into the
+ * guest hypervisor.
+ *
+ * The VNCR page is mapped at a VA whose bits [15:12] differ from those of
+ * its PA, so that on a host with 16K or 64K pages KVM has to locate the
+ * VNCR page in the host page from its PA.
+ */
+#include <signal.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+#include "ucall.h"
+
+#include <asm/sysreg.h>
+
+#define VNCR_BASE_VA	0x80000000UL
+#define RO_PT_GPA	0x100000000UL
+#define RO_PT_SLOT	10
+#define VNCR_VTTBR_EL2	0x20
+#define VNCR_MAGIC	0x5a5a1234a5a5beefUL
+#define TIMEOUT_SEC	5
+
+enum test_mode {
+	RW_PT_AF_CLEAR,	/* AF set by KVM, VNCR page mapped */
+	RO_PT_AF_SET,	/* nothing to update, VNCR page mapped */
+	RO_PT_AF_CLEAR,	/* AF update fails, SEA expected */
+};
+
+static const char * const mode_name[] = {
+	[RW_PT_AF_CLEAR]	= "read-write table, AF clear",
+	[RO_PT_AF_SET]		= "read-only table, AF set",
+	[RO_PT_AF_CLEAR]	= "read-only table, AF clear",
+};
+
+static bool expect_sea;
+static u64 vncr_va;
+
+#define copy_el2_to_el1(reg)						\
+	write_sysreg_s(read_sysreg_s(SYS_##reg##_EL1), SYS_##reg##_EL12)
+
+/*
+ * Runs in the nested context. No stack: SP_EL1 is not set up. The read of
+ * VTTBR_EL2 is redirected to the VNCR page by FEAT_NV2, and its value is
+ * handed back to the guest hypervisor through HVC.
+ */
+asm(".pushsection .text, \"ax\"\n"
+	".global l2_code\n"
+	"l2_code:\n"
+	"	mrs	x0, S3_4_C2_C1_0\n"	/* VTTBR_EL2 */
+	"	hvc	#0\n"
+	"	b	.\n"
+	".popsection\n");
+extern char l2_code[];
+
+static void hvc_handler(struct ex_regs *regs)
+{
+	__GUEST_ASSERT(!expect_sea, "expected SEA, VNCR read returned %lx",
+		       regs->regs[0]);
+	GUEST_ASSERT_EQ(regs->regs[0], VNCR_MAGIC);
+	GUEST_DONE();
+}
+
+static void dabt_handler(struct ex_regs *regs)
+{
+	u64 esr = read_sysreg(esr_el1);
+
+	__GUEST_ASSERT(expect_sea, "unexpected data abort, esr %lx", esr);
+	__GUEST_ASSERT(esr & ESR_ELx_VNCR, "not a VNCR abort, esr %lx", esr);
+	__GUEST_ASSERT((esr & ESR_ELx_FSC) == ESR_ELx_FSC_SEA_TTW(3),
+		       "unexpected FSC, esr %lx", esr);
+	GUEST_DONE();
+}
+
+static void guest_code(void)
+{
+	sysreg_clear_set(tcr_el1, 0, TCR_HA);
+	isb();
+
+	/* Reuse the stage-1 MMU context from EL2 in the nested context */
+	copy_el2_to_el1(SCTLR);
+	copy_el2_to_el1(MAIR);
+	copy_el2_to_el1(TCR);
+	copy_el2_to_el1(TTBR0);
+	copy_el2_to_el1(TTBR1);
+
+	write_sysreg_s(vncr_va, SYS_VNCR_EL2);
+	write_sysreg(0, vtcr_el2);
+	write_sysreg(0, vttbr_el2);
+	sysreg_clear_set(hcr_el2, HCR_EL2_TGE | HCR_EL2_VM,
+			 HCR_EL2_NV | HCR_EL2_NV2);
+
+	write_sysreg((u64)l2_code, elr_el2);
+	write_sysreg(PSR_MODE_EL1h | PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT,
+		     spsr_el2);
+	isb();
+	asm volatile("eret");
+
+	GUEST_FAIL("ERET to the nested context returned");
+}
+
+/*
+ * Map the VNCR page and move its last-level table to a read-only memslot.
+ * The guest never accesses vncr_va itself, so only KVM walks that table.
+ */
+static void setup_vncr_page(struct kvm_vm *vm, enum test_mode mode)
+{
+	u64 oa_mask = GENMASK_ULL(47, 12);
+	gpa_t data_gpa, table_gpa;
+	u64 *l2e, *table;
+	int idx;
+
+	data_gpa = vm_phy_page_alloc(vm, MEM_REGION_DATA);
+	vncr_va = VNCR_BASE_VA | ((data_gpa + 0x1000) & GENMASK_ULL(15, 12));
+	idx = (vncr_va >> 12) & 511;
+	virt_pg_map(vm, vncr_va, data_gpa);
+	*(u64 *)(addr_gpa2hva(vm, data_gpa) + VNCR_VTTBR_EL2) = VNCR_MAGIC;
+
+	l2e = virt_get_pte_hva_at_level(vm, vncr_va, 2);
+	TEST_ASSERT((*l2e & 3) == 3, "level 2 entry is not a table: %lx", *l2e);
+	table_gpa = *l2e & oa_mask;
+	table = addr_gpa2hva(vm, table_gpa);
+
+	if (mode == RW_PT_AF_CLEAR) {
+		table[idx] &= ~PTE_AF;
+		return;
+	}
+
+	/* A memslot must cover whole host pages */
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, RO_PT_GPA, RO_PT_SLOT,
+				    vm_adjust_num_guest_pages(vm->mode, 1),
+				    KVM_MEM_READONLY);
+	memcpy(addr_gpa2hva(vm, RO_PT_GPA), table, vm->page_size);
+	if (mode == RO_PT_AF_CLEAR)
+		((u64 *)addr_gpa2hva(vm, RO_PT_GPA))[idx] &= ~PTE_AF;
+
+	*l2e = (*l2e & ~oa_mask) | RO_PT_GPA;
+}
+
+static void sigalrm_handler(int sig)
+{
+}
+
+static void run_test(enum test_mode mode)
+{
+	struct kvm_vcpu_init init;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	u64 mmfr1;
+	int ret;
+
+	vm = vm_create(1);
+	kvm_get_default_vcpu_target(vm, &init);
+	init.features[0] |= BIT(KVM_ARM_VCPU_HAS_EL2);
+	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
+	kvm_arch_vm_finalize_vcpus(vm);
+
+	mmfr1 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR1_EL1));
+	__TEST_REQUIRE(SYS_FIELD_GET(ID_AA64MMFR1_EL1, HAFDBS, mmfr1),
+		       "Hardware AF management not supported");
+	TEST_REQUIRE(vm->page_size == 4096);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+	vm_install_sync_handler(vm, VECTOR_SYNC_LOWER_64, ESR_ELx_EC_HVC64,
+				hvc_handler);
+	vm_install_sync_handler(vm, VECTOR_SYNC_LOWER_64, ESR_ELx_EC_DABT_LOW,
+				dabt_handler);
+	vm_install_sync_handler(vm, VECTOR_SYNC_LOWER_64, ESR_ELx_EC_DABT_CUR,
+				dabt_handler);
+
+	expect_sea = mode == RO_PT_AF_CLEAR;
+	sync_global_to_guest(vm, expect_sea);
+	setup_vncr_page(vm, mode);
+	sync_global_to_guest(vm, vncr_va);
+
+	alarm(TIMEOUT_SEC);
+	ret = __vcpu_run(vcpu);
+	alarm(0);
+	TEST_ASSERT(!ret || errno != EINTR,
+		    "%s: vCPU made no progress in %ds (%lu exits)",
+		    mode_name[mode], TIMEOUT_SEC, vcpu_get_stat(vcpu, exits));
+	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_RUN, ret));
+
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_DONE:
+		pr_info("%s: ok\n", mode_name[mode]);
+		break;
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+		break;
+	default:
+		TEST_FAIL("%s: unexpected ucall %lu", mode_name[mode], uc.cmd);
+	}
+
+	kvm_vm_free(vm);
+}
+
+int main(void)
+{
+	struct sigaction sa = { .sa_handler = sigalrm_handler };
+
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_ARM_EL2));
+	TEST_ASSERT(!sigaction(SIGALRM, &sa, NULL), "sigaction failed");
+
+	run_test(RW_PT_AF_CLEAR);
+	run_test(RO_PT_AF_SET);
+	run_test(RO_PT_AF_CLEAR);
+
+	return 0;
+}
-- 
2.34.1

