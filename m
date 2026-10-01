Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BFDC2F7EE8
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 15:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790867825; cv=none; b=VNFCpH4BPixdUErBqz4GooN3DdoLxNf7H1jHKrkJRhpT20zJP4+sr8OdMZKdxkA+xJ+4gALPbrbo6xrZN+tGOPBp0FJET9KPmZm51M7Z7is+BH/W8hzBsfBBZgVVhesY1QslEUZOrroNW/R02hB4OsJFRrY0ZTuQ8BdcMFTdysc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790867825; c=relaxed/simple;
	bh=ZwqvOf30dvHuoHcl0G2h9uYoD7h3KkHbMLfvtXdIuHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMefjrN8HFI8oGjndbBv2pwsoG0dvExi2/KhaQiP3Ge2CEBwNtVRrZ8xEkMeIX3uvNG4B5PxU8BHiYJyRgYalCZM/7sWEdEuxh+hIZMT8HKSnsqTjh1OsGULZLELzyNmMJyjGZOSd80G+ocnZCy3AO1/HQdB2IR47A90F79EI/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=P9+lEU8K; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="P9+lEU8K"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 85B44497;
	Thu,  1 Oct 2026 08:16:59 -0700 (PDT)
Received: from e143914.cambridge.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9DAFA3F86F;
	Thu,  1 Oct 2026 08:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790867822; bh=ZwqvOf30dvHuoHcl0G2h9uYoD7h3KkHbMLfvtXdIuHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P9+lEU8KOdVSI+D5+lb16HE5UIj77xNyupQn1mCMibdH8JhvFZ4SMBBywFydV3CH8
	 bviPqSu2ICIwH2eQyahPWx0M7i/cPJSIGS0w2rlFpQpIK91LE9yqI9J2ARs/HBDIxV
	 chrnqf0ScLKyHLZII63S7lnd54MbymxWl4QgravA=
From: Joey Gouly <joey.gouly@arm.com>
To: kvmarm@lists.linux.dev
Cc: Jing Zhang <jingzhangos@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	andrew.jones@linux.dev,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH v3 4/8] lib: arm64: Add foundational guest execution framework
Date: Thu,  1 Oct 2026 16:16:41 +0100
Message-ID: <20261001151645.2427065-5-joey.gouly@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261001151645.2427065-1-joey.gouly@arm.com>
References: <20261001151645.2427065-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jing Zhang <jingzhangos@google.com>

Introduce the infrastructure to manage and execute guest when running at
EL2.

The framework includes:
- 'struct guest': Encapsulates vCPU state (GPRs, EL1/EL2 sysregs) and
  Stage-2 MMU context.
- guest_create() / guest_destroy(): Handle lifecycle management and
  Stage-2 MMU setup.
- guest_create_identity(): helper to create a guest and setup some
  mappings.
- guest_run(): entry point that saves host callee-saved
  registers, caches the guest context pointer in TPIDR_EL2, and
  performs the exception return (ERET) to the guest.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/Makefile.arm64      |   2 +
 lib/arm64/asm-offsets.c |   4 ++
 lib/arm64/asm/guest.h   |  53 +++++++++++++++++
 lib/arm64/asm/sysreg.h  |   6 ++
 lib/arm64/guest.c       | 127 ++++++++++++++++++++++++++++++++++++++++
 lib/arm64/guest_arch.S  |  51 ++++++++++++++++
 6 files changed, 243 insertions(+)
 create mode 100644 lib/arm64/asm/guest.h
 create mode 100644 lib/arm64/guest.c
 create mode 100644 lib/arm64/guest_arch.S

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 5e50f5ba..9026fd71 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -41,6 +41,8 @@ cflatobjs += lib/arm64/processor.o
 cflatobjs += lib/arm64/spinlock.o
 cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
 cflatobjs += lib/arm64/stage2_mmu.o
+cflatobjs += lib/arm64/guest.o
+cflatobjs += lib/arm64/guest_arch.o
 
 ifeq ($(CONFIG_EFI),y)
 cflatobjs += lib/acpi.o
diff --git a/lib/arm64/asm-offsets.c b/lib/arm64/asm-offsets.c
index 80de023c..c55e4bb9 100644
--- a/lib/arm64/asm-offsets.c
+++ b/lib/arm64/asm-offsets.c
@@ -8,6 +8,7 @@
 #include <libcflat.h>
 #include <kbuild.h>
 #include <asm/ptrace.h>
+#include <asm/guest.h>
 
 int main(void)
 {
@@ -30,5 +31,8 @@ int main(void)
 	DEFINE(S_FP, sizeof(struct pt_regs));
 	DEFINE(S_FRAME_SIZE, (sizeof(struct pt_regs) + 16));
 
+	OFFSET(GUEST_X_OFFSET, guest, x);
+	OFFSET(GUEST_HCR_OFFSET, guest, hcr_el2);
+
 	return 0;
 }
diff --git a/lib/arm64/asm/guest.h b/lib/arm64/asm/guest.h
new file mode 100644
index 00000000..50fc3338
--- /dev/null
+++ b/lib/arm64/asm/guest.h
@@ -0,0 +1,53 @@
+/*
+ * Copyright (C) 2026, Google LLC.
+ * Author: Jing Zhang <jingzhangos@google.com>
+ *
+ * SPDX-License-Identifier: LGPL-2.0-or-later
+ */
+#ifndef _ASMARM64_GUEST_H_
+#define _ASMARM64_GUEST_H_
+
+#include <libcflat.h>
+#include <asm/processor.h>
+#include <asm/stage2_mmu.h>
+
+#define HCR_GUEST_FLAGS (HCR_EL2_VM | HCR_EL2_FMO | HCR_EL2_IMO | \
+			 HCR_EL2_AMO | HCR_EL2_RW | HCR_EL2_E2H)
+/* Guest stack size */
+#define GUEST_STACK_SIZE		SZ_64K
+
+struct guest {
+	/* General Purpose Registers */
+	unsigned long x[31]; /* x0..x30 */
+
+	/* Execution State */
+	unsigned long elr_el2;
+	unsigned long spsr_el2;
+
+	/* Control Registers */
+	unsigned long hcr_el2;
+	unsigned long sctlr_el1;
+	unsigned long sp_el1;
+
+	/* Exit Information */
+	unsigned long esr_el2;
+	unsigned long far_el2;
+	unsigned long hpfar_el2;
+	unsigned long exit_code;
+
+	struct s2_mmu *s2mmu;
+	void *guest_stack;
+};
+
+/*
+ * Create a guest from a stage-2 context and entry IPA.
+ */
+struct guest *guest_create(struct s2_mmu *s2mmu, unsigned long entry_ipa);
+
+/* Helper for tests using identity-mapped host code and a stack. */
+struct guest *guest_create_identity(int vmid, void (*guest_func)(void),
+				    enum s2_granule granule);
+void guest_destroy(struct guest *guest);
+void guest_run(struct guest *guest);
+
+#endif /* _ASMARM64_GUEST_H_ */
diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index 72767cf0..b3b7e221 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -147,6 +147,10 @@ asm(
 #define VTTBR_EL2_VMID_SHIFT	48
 #define VTTBR_EL2_VMID_MASK	GENMASK_ULL(63, 48)
 
+#define HCR_EL2_VM		_BITULL(0)
+#define HCR_EL2_FMO		_BITULL(3)
+#define HCR_EL2_IMO		_BITULL(4)
+#define HCR_EL2_AMO		_BITULL(5)
 #define HCR_EL2_TGE		_BITULL(27)
 #define HCR_EL2_RW		_BITULL(31)
 #define HCR_EL2_E2H		_BITULL(34)
@@ -161,6 +165,8 @@ asm(
 #define SYS_HFGWTR2_EL2		sys_reg(3, 4, 3, 1, 3)
 #define SYS_HFGITR2_EL2		sys_reg(3, 4, 3, 1, 7)
 
+#define SYS_SCTLR_EL12		sys_reg(3, 5, 1, 0, 0)
+
 #define INIT_SCTLR_EL1_MMU_OFF	\
 			(SCTLR_EL1_ITD | SCTLR_EL1_SED | SCTLR_EL1_EOS | \
 			 SCTLR_EL1_TSCXT | SCTLR_EL1_EIS | SCTLR_EL1_SPAN | \
diff --git a/lib/arm64/guest.c b/lib/arm64/guest.c
new file mode 100644
index 00000000..b348e628
--- /dev/null
+++ b/lib/arm64/guest.c
@@ -0,0 +1,127 @@
+/*
+ * Copyright (C) 2026, Google LLC.
+ * Author: Jing Zhang <jingzhangos@google.com>
+ *
+ * SPDX-License-Identifier: LGPL-2.0-or-later
+ */
+#include <libcflat.h>
+#include <asm/guest.h>
+#include <asm/io.h>
+#include <asm/sysreg.h>
+#include <asm/barrier.h>
+#include <alloc_page.h>
+#include <alloc.h>
+
+extern void __guest_switch_regs(struct guest *guest);
+
+static void guest_restore_state(const struct guest *guest)
+{
+	write_sysreg(guest->elr_el2, elr_el2);
+	write_sysreg(guest->spsr_el2, spsr_el2);
+	write_sysreg_s(guest->sctlr_el1, SYS_SCTLR_EL12);
+	write_sysreg(guest->sp_el1, sp_el1);
+}
+
+static void guest_arch_enter(struct guest *guest)
+{
+	s2mmu_load(guest->s2mmu);
+	guest_restore_state(guest);
+	__guest_switch_regs(guest);
+}
+
+void guest_run(struct guest *guest)
+{
+	guest_arch_enter(guest);
+}
+
+struct guest *guest_create(struct s2_mmu *s2_ctx, unsigned long entry_ipa)
+{
+	struct guest *guest;
+
+	if (!s2_ctx)
+		return NULL;
+
+	guest = calloc(1, sizeof(*guest));
+	if (!guest)
+		return NULL;
+
+	guest->elr_el2 = entry_ipa;
+	guest->spsr_el2 = PSR_MODE_EL1h |
+		PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT;
+	guest->hcr_el2 = HCR_GUEST_FLAGS;
+
+	guest->sctlr_el1 = read_sysreg_s(SYS_SCTLR_EL12);
+	/* Disable guest stage 1 translation */
+	guest->sctlr_el1 &= ~(SCTLR_EL1_M | SCTLR_EL1_C);
+	guest->sctlr_el1 |= SCTLR_EL1_I;
+
+	guest->s2mmu = s2_ctx;
+
+	return guest;
+}
+
+struct guest *guest_create_identity(int vmid, void (*guest_func)(void),
+				    enum s2_granule granule)
+{
+	unsigned long guest_pa, code_base, stack_pa;
+	unsigned long *stack_page;
+	struct guest *guest;
+	struct s2_mmu *ctx;
+	int ret;
+
+	ctx = s2mmu_init(vmid, granule, true);
+	if (!ctx)
+		return NULL;
+
+	/*
+	 * Map the Host's code segment Identity Mapped (IPA=PA).
+	 * To be safe, we map a large chunk (e.g., 2MB) around the function
+	 * to capture any helper functions the compiler might generate calls to.
+	 */
+	guest_pa = virt_to_phys((void *)guest_func);
+	code_base = guest_pa & ~(SZ_2M - 1);
+	ret = s2mmu_map(ctx, code_base, code_base, SZ_2M, S2_MAP_RW);
+	if (ret)
+		goto destroy_s2;
+
+	/*
+	 * Map Stack
+	 * Allocate 16 pages (64K) in Host, get its PA, and map it for Guest.
+	 */
+	stack_page = alloc_pages(get_order(GUEST_STACK_SIZE >> PAGE_SHIFT));
+	if (!stack_page)
+		goto destroy_s2;
+	stack_pa = virt_to_phys(stack_page);
+	/* Identity Map it (IPA = PA) */
+	ret = s2mmu_map(ctx, stack_pa, stack_pa, GUEST_STACK_SIZE, S2_MAP_RW);
+	if (ret)
+		goto free_stack;
+
+	/* Create Guest */
+	/* Entry point is the PA of the function (Identity Mapped) */
+	guest = guest_create(ctx, guest_pa);
+	if (!guest)
+		goto free_stack;
+
+	/*
+	 * Setup Guest Stack Pointer
+	 * Must match where we mapped the stack + Offset
+	 */
+	guest->sp_el1 = stack_pa + GUEST_STACK_SIZE;
+	guest->guest_stack = stack_page;
+
+	return guest;
+
+free_stack:
+	free_pages(stack_page);
+destroy_s2:
+	s2mmu_destroy(ctx);
+	return NULL;
+}
+
+void guest_destroy(struct guest *guest)
+{
+	s2mmu_destroy(guest->s2mmu);
+	free_pages(guest->guest_stack);
+	free(guest);
+}
diff --git a/lib/arm64/guest_arch.S b/lib/arm64/guest_arch.S
new file mode 100644
index 00000000..16b95835
--- /dev/null
+++ b/lib/arm64/guest_arch.S
@@ -0,0 +1,51 @@
+/*
+ * Copyright (C) 2026, Google LLC.
+ * Author: Jing Zhang <jingzhangos@google.com>
+ *
+ * SPDX-License-Identifier: LGPL-2.0-or-later
+ */
+#define __ASSEMBLY__
+#include <asm/asm-offsets.h>
+#include <asm/sysreg.h>
+
+#define GUEST_XREG_OFFSET(x)	(GUEST_X_OFFSET + 8 * (x))
+
+.global __guest_switch_regs
+__guest_switch_regs:
+	/* x0 = struct guest pointer */
+
+	/* Save Host Callee-Saved Regs */
+	stp	x29, x30, [sp, #-16]!
+	stp	x27, x28, [sp, #-16]!
+	stp	x25, x26, [sp, #-16]!
+	stp	x23, x24, [sp, #-16]!
+	stp	x21, x22, [sp, #-16]!
+	stp	x19, x20, [sp, #-16]!
+
+	/*
+	 * Commit the guest EL2 state only after the world-switch frame is valid.
+	 */
+	ldr	x1, [x0, #GUEST_HCR_OFFSET]
+	msr	tpidr_el2, x0
+	msr	hcr_el2, x1
+	isb
+
+	/* Load Guest GPRs */
+	ldp	x1, x2, [x0, #GUEST_XREG_OFFSET(1)]
+	ldp	x3, x4, [x0, #GUEST_XREG_OFFSET(3)]
+	ldp	x5, x6, [x0, #GUEST_XREG_OFFSET(5)]
+	ldp	x7, x8, [x0, #GUEST_XREG_OFFSET(7)]
+	ldp	x9, x10, [x0, #GUEST_XREG_OFFSET(9)]
+	ldp	x11, x12, [x0, #GUEST_XREG_OFFSET(11)]
+	ldp	x13, x14, [x0, #GUEST_XREG_OFFSET(13)]
+	ldp	x15, x16, [x0, #GUEST_XREG_OFFSET(15)]
+	ldp	x17, x18, [x0, #GUEST_XREG_OFFSET(17)]
+	ldp	x19, x20, [x0, #GUEST_XREG_OFFSET(19)]
+	ldp	x21, x22, [x0, #GUEST_XREG_OFFSET(21)]
+	ldp	x23, x24, [x0, #GUEST_XREG_OFFSET(23)]
+	ldp	x25, x26, [x0, #GUEST_XREG_OFFSET(25)]
+	ldp	x27, x28, [x0, #GUEST_XREG_OFFSET(27)]
+	ldp	x29, x30, [x0, #GUEST_XREG_OFFSET(29)]
+	ldr	x0, [x0, #GUEST_XREG_OFFSET(0)]
+
+	eret
-- 
2.43.0

