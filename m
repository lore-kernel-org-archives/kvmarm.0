Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=139.138.36.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792656692;
	b=1ayXpkkh0IPH0i4IaYx57JtF8/LYsANoL5GiPWDONckNsPQMTkD1ojaD4znB/kUSYQRx
	 vZWsHjAlTQ5QRp1y9Z10EymvX0f2ib+oD07I+x3tv9XCGtJXHCJljwn4NX0LsRuZ9v6na
	 +4Be2wdfGHNxyNfatKaiKWYO2DIv8rWzwkCP0Ixw9rx+fHjSxBLdyhY8HPfOCKO/xyto9
	 rtU1HdCpYzIpOogqZv+SdHfU4V6YAUtbDmPKiqq+a6wknp600tEhI/1EdcMynCocrSTT9
	 0VhtIWyo8ltWiZo06q2GcRGlV7OAhf6ujKvAIl3lrHuqujvdlnOmef0VClI1zD7p42w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792656692;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:From:
	 Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=thsWnFdh4n3JhHmMbTZXSIeNEKp9gDnd9mJPsgdDwqw=;
	b=s/k+8vUIS9LcercyPa9iTg8wnCkCE3D37gGhzxi/6D0qVFTwYbFi5yuEz+rEt5Lono8f
	 J4NPm3i4UGCNhm9MaZKSHKXoqdV/JZIjzNTwrazI9+dL3srbp+DCYDxjIodlKDwNAxP+o
	 5h5KSDOzBKmgMUQK+dolfaDho0TR7oDaBpaXUzMJaC+MK/VWUZwpVrwEqj76GEJFA/Jz/
	 DBdxKttcMRtKULi00tLfHt2ltSTV4K2yccS3MYmY3igwBCbp/3Bo5NdECK3EunQf2V4i8
	 fEqR9ZSPIfKXDsR5UWuomqnpIdZijA64nH5heqErXKygunkSOe1i91+0HkPVlPZKHAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b="a/dDVr8O";
	arc=none smtp.remote-ip=139.138.36.225
Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6E1606A319
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 08:11:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB6E1606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=a/dDVr8O
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1792656698; x=1824192698;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:to:cc;
  bh=2R7ReUxr0LJZyOrHIF3pnSnWDPoZuBEmJOs39JEz+kk=;
  b=a/dDVr8OC7PO32ObcLRCaeNPW/FxdG+02t6AkdNN3mfWXHjhiXJVyRGR
   vrMWatragQT9oV/XKpKcIsjzswu5h2gT6tn/kgLKxFUZfWNxkfCjg/Cz6
   xrOi7TonAE/Jjv7LZG938p27cq376OKw7gdLukCBgduRqjp27BytzwxRS
   DMp9/dv6PYYNbdpGNhyN8XpSmTg4juJx9ASj/v8rF8Le+ObLR8LvKgsZN
   5GC9Mm72fJxe9UGmLX3Nf66swRcuRXGU2eBC+fQcKZKFAi2POr5npVr8i
   g9DUPRG4dWFqD8w53Xq/FPn6cJxBmZA/PCbXu3HxR+Wylp8HXvXub4rGr
   g==;
X-CSE-ConnectionGUID: 6gBafKUWSk+bTX+shTQLTA==
X-CSE-MsgGUID: 6wW5DQcMQj279doOS6pC1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11942"; a="245286995"
X-IronPort-AV: E=Sophos;i="6.27,171,1786978800"; 
   d="scan'208";a="245286995"
Received: from gmgwnl01.global.fujitsu.com (HELO mgmgwnl01.global.fujitsu.com) ([52.143.17.124])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2026 17:11:36 +0900
Received: from az2nlsmgm3.fujitsu.com (unknown [10.150.26.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mgmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 55B3181E4
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 08:11:30 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm3.fujitsu.com (Postfix) with ESMTPS id 127651802AEC
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 08:11:30 +0000 (UTC)
Received: from [127.0.1.1] (unknown [10.124.178.20])
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTP id C2DA1408085;
	Thu, 22 Oct 2026 08:11:24 +0000 (UTC)
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Date: Thu, 22 Oct 2026 17:11:18 +0900
Subject: [PATCH v2] KVM: arm64: selftests: Test VNCR translation
 invalidation
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261022-b4-vncr-mapping-test-v2-1-033e63ee055d@fujitsu.com>
X-B4-Tracking: v=1; b=H4sIACXF2WoC/4WNQQ6CMBBFr0Jm7RhagYgr72FYtGWAIaE0bWk0h
 LsLeACXL3n//RUCeaYAj2wFT4kDz3YHecnADMr2hNzuDDKXlcilRF1gssbjpJxj22OkEPGmxN3
 oolaSJOxT56nj95l9NT8Oix7JxKN1GAOHOPvP+ZvE4f25SAIFUq3asmjLvNL07JaRY1iuZp6g2
 bbtC8vc3qrMAAAA
X-Change-ID: 20261022-b4-vncr-mapping-test-3a18cb49a2e2
To: Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, Itaru Kitayama <itaru.kitayama@fujitsu.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792656684; l=10261;
 i=itaru.kitayama@fujitsu.com; s=20260825; h=from:subject:message-id;
 bh=2R7ReUxr0LJZyOrHIF3pnSnWDPoZuBEmJOs39JEz+kk=;
 b=Det27zPbheZBaH5/1pCeSRVHqaOa6GUsbVkrsFrcOSe5y2LfwCECrkmcFRLV7WcgAr5lzGP9m
 7g0LO5Z0RCmB0oNUxo79UjH0h8qMVb5mNgiymkfoQ2ifKDyOz63Rcah
X-Developer-Key: i=itaru.kitayama@fujitsu.com; a=ed25519;
 pk=g9bTnr9giRP7JwNSZHy+OMLQZBEUtSE9tUnXso0hH1Y=

Add a standalone KVM selftest that checks VNCR accesses after L1
updates its stage-1 mapping and issues a TLBI.

Keep VNCR_EL2 unchanged while remapping its backing page A to B then
again to A. At each step, L2 reads and writes TPIDR_EL2, and L1
verifies that the accesses reach the selected page while leaving the
other page unchanged.

The test runs with L1-managed stage-2 translation disabled.

Signed-off-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
---
Changes in v2:
- Fix inverted page-frame and page-offset masks when mapping
  the page-table descriptor, as reported by sashiko-bot
- Link to v1: https://patch.msgid.link/20261022-b4-vncr-mapping-test-v1-1-e9ad54d506be@fujitsu.com
---
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 .../selftests/kvm/arm64/nv_vncr_tlbi_test.c        | 303 +++++++++++++++++++++
 2 files changed, 304 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index f43549a56f0b..9f0af6ef54ba 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -181,6 +181,7 @@ TEST_GEN_PROGS_arm64 += arm64/host_sve
 TEST_GEN_PROGS_arm64 += arm64/hypercalls
 TEST_GEN_PROGS_arm64 += arm64/external_aborts
 TEST_GEN_PROGS_arm64 += arm64/mmio_sign_ext
+TEST_GEN_PROGS_arm64 += arm64/nv_vncr_tlbi_test
 TEST_GEN_PROGS_arm64 += arm64/page_fault_test
 TEST_GEN_PROGS_arm64 += arm64/psci_test
 TEST_GEN_PROGS_arm64 += arm64/sea_to_user
diff --git a/tools/testing/selftests/kvm/arm64/nv_vncr_tlbi_test.c b/tools/testing/selftests/kvm/arm64/nv_vncr_tlbi_test.c
new file mode 100644
index 000000000000..283e03bb007b
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/nv_vncr_tlbi_test.c
@@ -0,0 +1,303 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Check VNCR translation invalidation through observable memory effects.
+ *
+ * L1 keeps VNCR_EL2 unchanged while remapping its virtual address:
+ *
+ *     VNCR VA -> page A -> page B -> page A
+ *
+ * L2 reads and writes TPIDR_EL2 with HCR_EL2.{NV2,NV} == {1,1}.
+ * These accesses use the TPIDR_EL2 slot at VNCR offset 0x090.
+ *
+ * After each L2 HVC, L1 checks:
+ *   - the value returned by the redirected register read;
+ *   - the value written to the selected backing page;
+ *   - that the other backing page remains unchanged.
+ *
+ * No L3 and no L1-managed stage-2 translation are needed.
+ */
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+#include "ucall_common.h"
+
+#define VNCR_TPIDR_OFFSET	0x090
+
+#define SEED_A			0x1111222233334444ULL
+#define SEED_B			0x5555666677778888ULL
+#define WRITE_A			0xaaaabbbbccccddddULL
+#define WRITE_B			0x123456789abcdef0ULL
+#define WRITE_A_AGAIN		0xfedcba9876543210ULL
+
+#define L1_HCR			(HCR_EL2_RW | HCR_EL2_E2H | \
+				 HCR_EL2_NV | HCR_EL2_NV2)
+#define L2_PSTATE		(PSR_MODE_EL1h | PSR_D_BIT | PSR_A_BIT | \
+				 PSR_I_BIT | PSR_F_BIT)
+
+static struct test_config {
+	u64 vncr_va;
+	u64 *vncr_ptep;
+	u64 pte_a;
+	u64 pte_b;
+	u64 *slot_a;
+	u64 *slot_b;
+	u64 l2_sp;
+} cfg;
+
+static unsigned int round_nr;
+
+extern void l2_probe(void);
+extern char l2_after_hvc[];
+
+/*
+ * x1: value to write.
+ * x0: value read, observed by L1's HVC handler.
+ *
+ * No stack accesses or C calls in L2.
+ * Use the SMCCC convention of a zero HVC immediate.
+ */
+asm(
+".pushsection .text,\"ax\"\n"
+".balign 4\n"
+".global l2_probe\n"
+".type l2_probe, %function\n"
+"l2_probe:\n"
+"	mrs	x0, tpidr_el2\n"
+"	msr	tpidr_el2, x1\n"
+"	dsb	ish\n"
+"	hvc	#0\n"
+".global l2_after_hvc\n"
+"l2_after_hvc:\n"
+"	brk	#0\n"
+".size l2_probe, . - l2_probe\n"
+".popsection\n"
+);
+
+static void remap_vncr(u64 new_pte)
+{
+	u64 hcr = read_sysreg(hcr_el2);
+	u64 operand = cfg.vncr_va >> 12;
+
+	/*
+	 * Use the VHE host translation regime for the EL1 TLBI
+	 * instruction: HCR_EL2.{E2H,TGE} == {1,1}.
+	 */
+	write_sysreg(hcr | HCR_EL2_TGE, hcr_el2);
+	isb();
+
+	/* Break before make. VNCR_EL2 itself is never rewritten. */
+	WRITE_ONCE(*cfg.vncr_ptep, 0);
+	dsb(ishst);
+
+	asm volatile("tlbi vaae1is, %0" : : "r" (operand) : "memory");
+	dsb(ish);
+	isb();
+
+	WRITE_ONCE(*cfg.vncr_ptep, new_pte);
+	dsb(ishst);
+	isb();
+
+	/* Permit return to L2 at EL1. */
+	write_sysreg(hcr, hcr_el2);
+	isb();
+}
+
+static void handle_l2_hvc(struct ex_regs *regs)
+{
+	u64 esr = read_sysreg(esr_el1);
+
+	GUEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_HVC64);
+	GUEST_ASSERT_EQ(esr & 0xffff, 0x0);
+	GUEST_ASSERT_EQ(regs->pc, (u64)l2_after_hvc);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_VNCR_EL2), cfg.vncr_va);
+
+	dsb(ish);
+
+	switch (round_nr) {
+	case 0:
+		/* Warmed translation: VNCR VA -> A. */
+		GUEST_ASSERT_EQ(regs->regs[0], SEED_A);
+		GUEST_ASSERT_EQ(READ_ONCE(*cfg.slot_a), WRITE_A);
+		GUEST_ASSERT_EQ(READ_ONCE(*cfg.slot_b), SEED_B);
+
+		remap_vncr(cfg.pte_b);
+		regs->regs[1] = WRITE_B;
+		break;
+
+	case 1:
+		/* Following TLBI, reads and writes must now use B. */
+		GUEST_ASSERT_EQ(regs->regs[0], SEED_B);
+		GUEST_ASSERT_EQ(READ_ONCE(*cfg.slot_b), WRITE_B);
+		GUEST_ASSERT_EQ(READ_ONCE(*cfg.slot_a), WRITE_A);
+
+		remap_vncr(cfg.pte_a);
+		regs->regs[1] = WRITE_A_AGAIN;
+		break;
+
+	case 2:
+		/* Check invalidation again, with the mapping reversed. */
+		GUEST_ASSERT_EQ(regs->regs[0], WRITE_A);
+		GUEST_ASSERT_EQ(READ_ONCE(*cfg.slot_a), WRITE_A_AGAIN);
+		GUEST_ASSERT_EQ(READ_ONCE(*cfg.slot_b), WRITE_B);
+
+		GUEST_DONE();
+	default:
+		GUEST_FAIL("Unexpected round %u", round_nr);
+		return;
+	}
+
+	round_nr++;
+	regs->pc = (u64)l2_probe;
+	regs->pstate = L2_PSTATE;
+}
+
+static void guest_code(void)
+{
+	GUEST_ASSERT_EQ(get_current_el(), 2);
+	GUEST_ASSERT(read_sysreg(hcr_el2) & HCR_EL2_E2H);
+
+	/*
+	 * With E2H=1, these EL1 accessors read L1's own configuration.
+	 * EL12 accessors configure the EL1 context used to execute L2.
+	 */
+	write_sysreg_s(read_sysreg(tcr_el1), SYS_TCR_EL12);
+	write_sysreg_s(read_sysreg(ttbr0_el1), SYS_TTBR0_EL12);
+	write_sysreg_s(read_sysreg(mair_el1), SYS_MAIR_EL12);
+	write_sysreg_s(read_sysreg(cpacr_el1), SYS_CPACR_EL12);
+	write_sysreg_s(read_sysreg(vbar_el1), SYS_VBAR_EL12);
+	write_sysreg_s(read_sysreg(sctlr_el1), SYS_SCTLR_EL12);
+	write_sysreg(cfg.l2_sp, sp_el1);
+	isb();
+
+	/*
+	 * These aliases remain mapped throughout the test. They allow
+	 * inspection of both backing pages independently of VNCR VA.
+	 */
+	WRITE_ONCE(*cfg.slot_a, SEED_A);
+	WRITE_ONCE(*cfg.slot_b, SEED_B);
+	dsb(ish);
+
+	/* Program the VNCR address exactly once. */
+	write_sysreg_s(cfg.vncr_va, SYS_VNCR_EL2);
+
+	/* VM=0, TGE=0; enable nested register redirection for L2. */
+	write_sysreg(L1_HCR, hcr_el2);
+	isb();
+
+	GUEST_ASSERT_EQ(read_sysreg(hcr_el2) &
+			(HCR_EL2_NV | HCR_EL2_NV2),
+			HCR_EL2_NV | HCR_EL2_NV2);
+	GUEST_ASSERT(!(read_sysreg(hcr_el2) & HCR_EL2_VM));
+
+	write_sysreg((u64)l2_probe, elr_el2);
+	write_sysreg(L2_PSTATE, spsr_el2);
+	isb();
+
+	asm volatile(
+		"mov x1, %0\n"
+		"eret\n"
+		:
+		: "r" (WRITE_A)
+		: "x1", "memory");
+
+	__builtin_unreachable();
+}
+
+/* Add a guest virtual alias for an existing guest physical page. */
+static u64 map_alias(struct kvm_vm *vm, u64 gpa)
+{
+	u64 va = vm_unused_gva_gap(vm, vm->page_size,
+				  KVM_UTIL_MIN_VADDR);
+
+	virt_map(vm, va, gpa, 1);
+	return va;
+}
+
+static void prepare_memory(struct kvm_vm *vm)
+{
+	u64 a = vm_alloc_page(vm);
+	u64 b = vm_alloc_page(vm);
+	u64 page_offset_mask = (u64)vm->page_size - 1;
+	u64 stack = vm_alloc_pages(vm, DEFAULT_STACK_PGS);
+	u64 ptep_gpa, ptep_alias;
+	u64 *ptep;
+
+	cfg.slot_a = (u64 *)(a + VNCR_TPIDR_OFFSET);
+	cfg.slot_b = (u64 *)(b + VNCR_TPIDR_OFFSET);
+	cfg.l2_sp = stack + DEFAULT_STACK_PGS * vm->page_size;
+
+	/* Initially, the separate VNCR virtual address maps page A. */
+	cfg.vncr_va = map_alias(vm, addr_gva2gpa(vm, a));
+
+	ptep = virt_get_pte_hva(vm, cfg.vncr_va);
+	cfg.pte_a = *ptep;
+	cfg.pte_b = *virt_get_pte_hva(vm, b);
+
+	TEST_ASSERT(cfg.pte_a != cfg.pte_b,
+		    "Backing pages must have different descriptors");
+	TEST_ASSERT((cfg.pte_a & (PTE_VALID | PTE_TYPE_PAGE)) ==
+		    (PTE_VALID | PTE_TYPE_PAGE),
+		    "VNCR mapping must use a leaf page descriptor");
+
+	/*
+	 * Map the page containing the descriptor into L1, so L1 can
+	 * perform its own page-table update and architectural TLBI.
+	 */
+	ptep_gpa = addr_hva2gpa(vm, ptep);
+	ptep_alias = map_alias(vm, ptep_gpa & ~page_offset_mask);
+	cfg.vncr_ptep = (u64 *)(ptep_alias + (ptep_gpa & page_offset_mask));
+
+	sync_global_to_guest(vm, cfg);
+}
+
+int main(void)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	struct ucall uc;
+	u64 mmfr4, cmd;
+
+	TEST_REQUIRE(test_supports_el2());
+
+	vm = __vm_create_with_one_vcpu(&vcpu, 32, guest_code);
+	TEST_REQUIRE(vcpu_has_el2(vcpu));
+
+	/*
+	 * Target KVM's exposed NV2-only-or-later nested capability.
+	 * Merely having a virtual EL2 is insufficient for this test.
+	 */
+	mmfr4 = vcpu_get_reg(vcpu,
+			    KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR4_EL1));
+	TEST_REQUIRE(FIELD_GET(ID_AA64MMFR4_EL1_NV_frac, mmfr4) >=
+		     ID_AA64MMFR4_EL1_NV_frac_NV2_ONLY);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+	vm_install_sync_handler(vm, VECTOR_SYNC_LOWER_64,
+				ESR_ELx_EC_HVC64, handle_l2_hvc);
+
+	prepare_memory(vm);
+
+	for (;;) {
+		vcpu_run(vcpu);
+		cmd = get_ucall(vcpu, &uc);
+
+		switch (cmd) {
+		case UCALL_PRINTF:
+			REPORT_GUEST_PRINTF(uc);
+			break;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_DONE:
+			pr_info("PASS: VNCR accesses followed A -> B -> A mappings; "
+		"inactive backing slots remained unchanged\n");
+			kvm_vm_free(vm);
+			return 0;
+		default:
+			TEST_FAIL("Unexpected ucall %lu, KVM exit reason %u",
+				  cmd, vcpu->run->exit_reason);
+		}
+	}
+}

---
base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
change-id: 20261022-b4-vncr-mapping-test-3a18cb49a2e2

Best regards,
--  
Itaru Kitayama <itaru.kitayama@fujitsu.com>

