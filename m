Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794214179;
	b=RmrkMBkKlFdHOEaNB1FFT8JYvK4wmhWnWqID4yCHA95xrIfUCFsX1Sr6/Ha/4AxIv8UR
	 1YzPFgypoFYiP/FP+GGZhDNA6NQv8afTTfAd5g9ojcoydOAfAe0YTU+8stRa4/ROqXhNw
	 ZC/89zGIyWHna92gCrOMCMdbcMI7Ep0gGYOT2RBx/wKDZbRHw2nTSqQJ5XL9RPnN67NG+
	 xaoGf3AeSPyMsaWfowSEYJ5SObT+N8OjFGvSTeLyuUNu7YZkUKIYPkK/baWN4kZQ6yxA/
	 h4++p+cBJw7i6oF+AHl04zh0keMQmsXS1IelGahgsNC1IDWLhkY+mCTt+g9f300Bh5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794214179;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7iweW5GoTcP706REDgNFToDsAhXoQhAArYAefRFkkUc=;
	b=Q6traRlKWsl4a/AaTKoR86sQsvV5FKnK8jJ4d2L5VDH1jEBAxeBf/HmWJWQcjpHD6bbS
	 diWu5w9b81+GeMcMfwOvRD7AwpEtcQKHhRG0lAgxLz9Qdec1i30AONRW+hT8ix2szO5GL
	 10AfFXLsr0QwSvun+9LlyGavUfLqqtA/DLsL90d3xkDI3ijTzEaOS2Oms4dga26hsKkFz
	 eVIL1GruuDnhnwGG0d5W890xALao75NUYBu9KPFPYuoVitAVbMAZqy2iwmyesRuA/KUsi
	 7NBcnaN3NNaAPauB3TqOwYi9oB3XiKvc66bJmCubmWAYh/+l3OiJyjgq4q3OZ3u/zlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jEELN9hY;
	arc=none smtp.remote-ip=91.218.175.58
Received: from mta0.migadu.com (out-58.mta0.migadu.com [91.218.175.58])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E28D6083620
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:49:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E28D6083620
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jEELN9hY
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=p+xWksjeoXpzrp3cJV/q8UTKqd62IB33+o9bUnV4MQM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794214176; v=1; x=1794818976;
 b=jEELN9hYSchpHcUEj3UjwtI+enzkA4BYDeiDaa2ZSukK1dCFYjeMnzhnCUQdtEgn1xtra/em
 Sl/78aSn3lqGUO6xW7bOe/1xcs4G5mWj5sJ41b/060hltHto8Xp2NKol3beiuQcAMg7cVcMG1AA
 V1dyrDNOlP65nhg8iV05aB5A=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 77b1a00e8c42b39e;
	Mon, 09 Nov 2026 08:49:35 +0000
X-Mizu-Trace-ID: 77b1a00e8c42b39e
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
Subject: [PATCH v2 12/19] KVM: arm64: selftests: Add pkvm_id_regs register and trap test
Date: Mon,  9 Nov 2026 08:48:47 +0000
Message-ID: <20261109084854.840576-13-fuad.tabba@linux.dev>
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

pKVM gives a protected guest its own view of the ID registers,
hiding the features pKVM doesn't support. Their registers UNDEF,
except some hidden debug registers, which are RAZ/WI.

Test that view and those UNDEFs from the guest, and the
registers EL2 emulates with fixed values. The debug checks follow
ID_AA64DFR0_EL1.DebugVer. The PtrAuth and SVE cases run when a
protected VM's fd reports the capability, and the SVE case also
compares ID_AA64ZFR0_EL1 with what host userspace reads.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/pkvm_id_regs.c        | 324 ++++++++++++++++++
 2 files changed, 325 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_id_regs.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 6bb436bd36205..8855c9abb2fd0 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -191,6 +191,7 @@ TEST_GEN_PROGS_arm64 += arm64/external_aborts
 TEST_GEN_PROGS_arm64 += arm64/mmio_sign_ext
 TEST_GEN_PROGS_arm64 += arm64/page_fault_test
 TEST_GEN_PROGS_arm64 += arm64/pkvm_host_abi
+TEST_GEN_PROGS_arm64 += arm64/pkvm_id_regs
 TEST_GEN_PROGS_arm64 += arm64/pkvm_mem_share
 TEST_GEN_PROGS_arm64 += arm64/pkvm_psci
 TEST_GEN_PROGS_arm64 += arm64/pkvm_smccc
diff --git a/tools/testing/selftests/kvm/arm64/pkvm_id_regs.c b/tools/testing/selftests/kvm/arm64/pkvm_id_regs.c
new file mode 100644
index 0000000000000..93ed557a30bc6
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/pkvm_id_regs.c
@@ -0,0 +1,324 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pkvm_id_regs - the ID registers a protected VM sees, and which of its
+ * register accesses UNDEF.
+ *
+ * Copyright (C) 2025 Google LLC
+ * Author: Fuad Tabba <fuad.tabba@linux.dev>
+ */
+
+#include <linux/bitfield.h>
+#include <linux/bits.h>
+
+#include "gic_v3.h"
+#include "kvm_util.h"
+#include "pkvm.h"
+#include "processor.h"
+#include "test_util.h"
+
+/* vCPU 0's MPIDR: Aff0=0, bit31=1, MT=0. */
+#define MPIDR_VCPU0	0x80000000UL
+
+/* Hidden fields with a non-zero Not-Implemented encoding. */
+#define PVM_ID_AA64DFR0_NI	(					\
+	SYS_FIELD_PREP_ENUM(ID_AA64DFR0_EL1, DoubleLock, NI) |		\
+	SYS_FIELD_PREP_ENUM(ID_AA64DFR0_EL1, MTPMU, NI))
+#define PVM_ID_AA64MMFR4_NI	SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, E2H0, NI)
+
+/* What self-hosted debug exposes: DebugVer and the breakpoint, watchpoint and CTX counts. */
+#define PVM_ID_AA64DFR0_DEBUG	(ID_AA64DFR0_EL1_DebugVer_MASK | ID_AA64DFR0_EL1_BRPs_MASK | \
+				 ID_AA64DFR0_EL1_WRPs_MASK | ID_AA64DFR0_EL1_CTX_CMPs_MASK)
+
+/* Breakpoint and watchpoint 0 controls with E clear: every byte, EL1, loads and stores. */
+#define DBGBCR_VAL	((0xfUL << 5) | (1UL << 1))
+#define DBGWCR_VAL	((0xffUL << 5) | (3UL << 3) | (1UL << 1))
+
+extern unsigned char brk_insn;
+
+static volatile bool undef_seen;
+static volatile u64 brk_pc;
+
+static void undef_handler(struct ex_regs *regs)
+{
+	undef_seen = true;
+	regs->pc += 4;
+}
+
+static void brk_handler(struct ex_regs *regs)
+{
+	brk_pc = regs->pc;
+	regs->pc += 4;
+}
+
+/* Access @expr must make the guest take an UNDEF (EC_UNKNOWN). */
+#define GUEST_ASSERT_UNDEF(expr) do {	\
+	undef_seen = false;		\
+	expr;				\
+	GUEST_ASSERT(undef_seen);	\
+} while (0)
+
+/* @reg reads back @pattern with no UNDEF. */
+#define GUEST_ASSERT_RW(reg, pattern) do {		\
+	u64 __saved = read_sysreg_s(reg);		\
+	undef_seen = false;				\
+	write_sysreg_s(pattern, reg);			\
+	GUEST_ASSERT_EQ(read_sysreg_s(reg), pattern);	\
+	write_sysreg_s(__saved, reg);			\
+	GUEST_ASSERT(!undef_seen);			\
+} while (0)
+
+static void assert_aarch32_id_raz(void)
+{
+	/* AArch32 is unsupported for protected guests: its ID block reads 0. */
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_PFR0_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_PFR1_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_DFR0_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_AFR0_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_MMFR0_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_MMFR1_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_MMFR2_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_MMFR3_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_ISAR0_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_ISAR1_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_ISAR2_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_ISAR3_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_ISAR4_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_ISAR5_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_MMFR4_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_ISAR6_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_MVFR0_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_MVFR1_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_MVFR2_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(sys_reg(3, 0, 0, 3, 3)), 0);	/* unallocated */
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_PFR2_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_DFR1_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_MMFR5_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(sys_reg(3, 0, 0, 3, 7)), 0);	/* unallocated */
+}
+
+/* A zero DebugVer means EL2 hides self-hosted debug from the guest. */
+static bool debug_exposed(void)
+{
+	return SYS_FIELD_GET(ID_AA64DFR0_EL1, DebugVer, read_sysreg_s(SYS_ID_AA64DFR0_EL1));
+}
+
+static void assert_id_regs(void)
+{
+	u64 pfr0 = read_sysreg_s(SYS_ID_AA64PFR0_EL1);
+	u64 dfr0 = read_sysreg_s(SYS_ID_AA64DFR0_EL1);
+
+	if (debug_exposed()) {
+		u64 debugver = SYS_FIELD_GET(ID_AA64DFR0_EL1, DebugVer, dfr0);
+		u64 brps = SYS_FIELD_GET(ID_AA64DFR0_EL1, BRPs, dfr0);
+
+		/* Exposed debug: at most v8.8, and at least two breakpoints and two watchpoints. */
+		GUEST_ASSERT_EQ(dfr0 & ~PVM_ID_AA64DFR0_DEBUG, PVM_ID_AA64DFR0_NI);
+		GUEST_ASSERT(debugver >= ID_AA64DFR0_EL1_DebugVer_IMP);
+		GUEST_ASSERT(debugver <= ID_AA64DFR0_EL1_DebugVer_V8P8);
+		GUEST_ASSERT(brps >= 1);
+		GUEST_ASSERT(SYS_FIELD_GET(ID_AA64DFR0_EL1, WRPs, dfr0) >= 1);
+		GUEST_ASSERT(SYS_FIELD_GET(ID_AA64DFR0_EL1, CTX_CMPs, dfr0) <= brps);
+	} else {
+		/* Debug and PMU are hidden: DFR0 has a fixed value, no breakpoints. */
+		GUEST_ASSERT_EQ(dfr0, PVM_ID_AA64DFR0_NI);
+	}
+
+	/* With no vCPU features, SVE, ZFR0 and PtrAuth read 0. */
+	GUEST_ASSERT_EQ(SYS_FIELD_GET(ID_AA64PFR0_EL1, SVE, pfr0), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_AA64ZFR0_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_AA64ISAR1_EL1) &
+			(ID_AA64ISAR1_EL1_APA_MASK | ID_AA64ISAR1_EL1_API_MASK |
+			 ID_AA64ISAR1_EL1_GPA_MASK | ID_AA64ISAR1_EL1_GPI_MASK), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_AA64ISAR2_EL1) &
+			(ID_AA64ISAR2_EL1_APA3_MASK | ID_AA64ISAR2_EL1_GPA3_MASK), 0);
+
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_AA64DFR1_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_AA64AFR0_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_AA64AFR1_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_AA64SMFR0_EL1), 0);
+	GUEST_ASSERT_EQ(SYS_FIELD_GET(ID_AA64PFR1_EL1, MTE, read_sysreg_s(SYS_ID_AA64PFR1_EL1)), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_AA64MMFR4_EL1), PVM_ID_AA64MMFR4_NI);
+
+	assert_aarch32_id_raz();
+}
+
+static void assert_debug_raz_wi(void)
+{
+	/* Breakpoint/watchpoint 0, MDSCR and OS-lock regs are RAZ/WI, with no UNDEF. */
+	undef_seen = false;
+	write_sysreg_s(~0UL, SYS_DBGBVRn_EL1(0));
+	write_sysreg_s(~0UL, SYS_DBGBCRn_EL1(0));
+	write_sysreg_s(~0UL, SYS_DBGWVRn_EL1(0));
+	write_sysreg_s(~0UL, SYS_DBGWCRn_EL1(0));
+	write_sysreg_s(~0UL, SYS_MDSCR_EL1);
+	write_sysreg_s(~0UL, SYS_OSLAR_EL1);
+	write_sysreg_s(~0UL, SYS_OSDLR_EL1);
+	isb();
+
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_DBGBVRn_EL1(0)), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_DBGBCRn_EL1(0)), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_DBGWVRn_EL1(0)), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_DBGWCRn_EL1(0)), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_MDSCR_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_OSLSR_EL1), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_OSDLR_EL1), 0);
+	GUEST_ASSERT(!undef_seen);
+
+	/* Breakpoint/watchpoint indices above 0 are not implemented. */
+	GUEST_ASSERT_UNDEF((void)read_sysreg_s(SYS_DBGBVRn_EL1(1)));
+	GUEST_ASSERT_UNDEF((void)read_sysreg_s(SYS_DBGWVRn_EL1(1)));
+}
+
+static void assert_debug_regs(void)
+{
+	u64 addr = (u64)&brk_insn;
+
+	/* Breakpoint/watchpoint 0 hold what the guest writes. */
+	GUEST_ASSERT_RW(SYS_DBGBVRn_EL1(0), addr);
+	GUEST_ASSERT_RW(SYS_DBGBCRn_EL1(0), DBGBCR_VAL);
+	GUEST_ASSERT_RW(SYS_DBGWVRn_EL1(0), addr & ~7UL);
+	GUEST_ASSERT_RW(SYS_DBGWCRn_EL1(0), DBGWCR_VAL);
+
+	/*
+	 * MDSCR doesn't UNDEF. The OS lock is implemented. The OS double lock isn't,
+	 * so OSDLR is RAZ/WI.
+	 */
+	undef_seen = false;
+	write_sysreg_s(read_sysreg_s(SYS_MDSCR_EL1), SYS_MDSCR_EL1);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_OSLSR_EL1) & OSLSR_EL1_OSLM_MASK,
+			OSLSR_EL1_OSLM_IMPLEMENTED);
+	write_sysreg_s(~0UL, SYS_OSDLR_EL1);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_OSDLR_EL1), 0);
+	GUEST_ASSERT(!undef_seen);
+}
+
+static void assert_undef_regs(void)
+{
+	/* The PMU is hidden, and its registers UNDEF. */
+	GUEST_ASSERT_UNDEF((void)read_sysreg_s(SYS_PMCR_EL0));
+	GUEST_ASSERT_UNDEF((void)read_sysreg_s(SYS_PMCNTENSET_EL0));
+	GUEST_ASSERT_UNDEF((void)read_sysreg_s(SYS_PMUSERENR_EL0));
+
+	/* Limited-ordering region registers UNDEF. */
+	GUEST_ASSERT_UNDEF((void)read_sysreg_s(SYS_LORID_EL1));
+
+	/* AMU and MTE are hidden, and so are the PtrAuth keys without the PtrAuth vCPU features. */
+	GUEST_ASSERT_UNDEF((void)read_sysreg_s(SYS_AMCNTENSET0_EL0));
+	GUEST_ASSERT_UNDEF((void)read_sysreg_s(SYS_GCR_EL1));
+	GUEST_ASSERT_UNDEF((void)read_sysreg_s(SYS_APIAKEYLO_EL1));
+
+	/*
+	 * Nor is SVE, so an SVE instruction UNDEFs even with CPACR_EL1.ZEN set. On a CPU
+	 * with SME but no SVE, SMEN gates it instead, so set that too.
+	 */
+	write_sysreg(read_sysreg(cpacr_el1) | CPACR_EL1_ZEN_EL1EN | CPACR_EL1_SMEN_EL1EN,
+		     cpacr_el1);
+	isb();
+	GUEST_ASSERT_UNDEF(asm volatile(".arch_extension sve\n rdvl x0, #1" : : : "x0"));
+}
+
+static void assert_host_handled(void)
+{
+	/* Host-handled registers reach the guest with no UNDEF. */
+	undef_seen = false;
+	(void)read_sysreg_s(SYS_CTR_EL0);
+	(void)read_sysreg_s(SYS_CLIDR_EL1);
+	GUEST_ASSERT(!undef_seen);
+}
+
+static void guest_baseline(void)
+{
+	pkvm_guest_init();
+
+	assert_id_regs();
+	if (debug_exposed())
+		assert_debug_regs();
+	else
+		assert_debug_raz_wi();
+	assert_undef_regs();
+	assert_host_handled();
+
+	asm volatile("brk_insn: brk #0");
+	GUEST_ASSERT_EQ(brk_pc, (u64)&brk_insn);
+
+	/* EL2 emulates ICC_SRE_EL1 with a fixed value. */
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ICC_SRE_EL1),
+			ICC_SRE_EL1_DIB | ICC_SRE_EL1_DFB | ICC_SRE_EL1_SRE);
+
+	GUEST_ASSERT_EQ(read_sysreg(mpidr_el1), MPIDR_VCPU0);
+
+	GUEST_DONE();
+}
+
+/* The host implements one of QARMA5, an IMP DEF algorithm or QARMA3: any may appear. */
+static void guest_ptrauth(void)
+{
+	pkvm_guest_init();
+	GUEST_ASSERT((read_sysreg_s(SYS_ID_AA64ISAR1_EL1) &
+		      (ID_AA64ISAR1_EL1_APA_MASK | ID_AA64ISAR1_EL1_API_MASK)) |
+		     (read_sysreg_s(SYS_ID_AA64ISAR2_EL1) &
+		      (ID_AA64ISAR2_EL1_APA3_MASK | ID_AA64ISAR2_EL1_GPA3_MASK)));
+	GUEST_DONE();
+}
+
+/* Set in the guest's copy by the host: ID_AA64ZFR0_EL1 as host userspace reads it. */
+static u64 host_zfr0;
+
+static void guest_sve(void)
+{
+	pkvm_guest_init();
+	GUEST_ASSERT_EQ(SYS_FIELD_GET(ID_AA64PFR0_EL1, SVE, read_sysreg_s(SYS_ID_AA64PFR0_EL1)),
+			ID_AA64PFR0_EL1_SVE_IMP);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_AA64ZFR0_EL1), host_zfr0);
+	GUEST_DONE();
+}
+
+static void run_guest(u32 features, void *guest_code)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = pkvm_vm_create(1, features, &vcpu);
+	if (features & BIT(KVM_ARM_VCPU_SVE)) {
+		int feature = KVM_ARM_VCPU_SVE;
+
+		vcpu_ioctl(vcpu, KVM_ARM_VCPU_FINALIZE, &feature);
+		host_zfr0 = read_sysreg_s(SYS_ID_AA64ZFR0_EL1);
+		sync_global_to_guest(vm, host_zfr0);
+	}
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT, ESR_ELx_EC_UNKNOWN, undef_handler);
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT, ESR_ELx_EC_BRK64, brk_handler);
+
+	pkvm_vcpu_setup_boot(vcpu, guest_code);
+	pkvm_run_loop(vcpu, NULL);
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
+	run_guest(0, guest_baseline);
+	ksft_test_result_pass("baseline ID view and UNDEF matrix\n");
+
+	if (pkvm_has_cap(KVM_CAP_ARM_SVE)) {
+		run_guest(BIT(KVM_ARM_VCPU_SVE), guest_sve);
+		ksft_test_result_pass("SVE ID delta\n");
+	} else {
+		ksft_test_result_skip("SVE ID delta: SVE unavailable to a protected VM\n");
+	}
+
+	if (pkvm_has_cap(KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
+	    pkvm_has_cap(KVM_CAP_ARM_PTRAUTH_GENERIC)) {
+		run_guest(BIT(KVM_ARM_VCPU_PTRAUTH_ADDRESS) |
+			  BIT(KVM_ARM_VCPU_PTRAUTH_GENERIC), guest_ptrauth);
+		ksft_test_result_pass("PtrAuth ID delta\n");
+	} else {
+		ksft_test_result_skip("PtrAuth ID delta: PtrAuth unavailable\n");
+	}
+
+	ksft_finished();
+}
-- 
2.47.3

