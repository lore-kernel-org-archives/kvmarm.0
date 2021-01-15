Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48543C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 15:28:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AF8382388B
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 15:28:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF8382388B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4917A4B1DF;
	Fri, 15 Jan 2021 10:28:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GUb31imG60jw; Fri, 15 Jan 2021 10:28:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B95214B1B3;
	Fri, 15 Jan 2021 10:28:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B3354B1AA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 10:28:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c0b7zQ3ngujE for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 10:28:25 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A65E74B1B6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 10:28:24 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DEAAA11B3;
 Fri, 15 Jan 2021 07:28:23 -0800 (PST)
Received: from e112269-lin.arm.com (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2AC903F70D;
 Fri, 15 Jan 2021 07:28:21 -0800 (PST)
From: Steven Price <steven.price@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
Subject: [PATCH v7 1/3] arm64: kvm: Save/restore MTE registers
Date: Fri, 15 Jan 2021 15:28:09 +0000
Message-Id: <20210115152811.8398-2-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210115152811.8398-1-steven.price@arm.com>
References: <20210115152811.8398-1-steven.price@arm.com>
MIME-Version: 1.0
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Dave Martin <Dave.Martin@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Steven Price <steven.price@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Define the new system registers that MTE introduces and context switch
them. The MTE feature is still hidden from the ID register as it isn't
supported in a VM yet.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_host.h          |  4 ++
 arch/arm64/include/asm/kvm_mte.h           | 74 ++++++++++++++++++++++
 arch/arm64/include/asm/sysreg.h            |  3 +-
 arch/arm64/kernel/asm-offsets.c            |  3 +
 arch/arm64/kvm/hyp/entry.S                 |  7 ++
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  4 ++
 arch/arm64/kvm/sys_regs.c                  | 14 ++--
 7 files changed, 104 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_mte.h

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 11beda85ee7e..51590a397e4b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -148,6 +148,8 @@ enum vcpu_sysreg {
 	SCTLR_EL1,	/* System Control Register */
 	ACTLR_EL1,	/* Auxiliary Control Register */
 	CPACR_EL1,	/* Coprocessor Access Control */
+	RGSR_EL1,	/* Random Allocation Tag Seed Register */
+	GCR_EL1,	/* Tag Control Register */
 	ZCR_EL1,	/* SVE Control */
 	TTBR0_EL1,	/* Translation Table Base Register 0 */
 	TTBR1_EL1,	/* Translation Table Base Register 1 */
@@ -164,6 +166,8 @@ enum vcpu_sysreg {
 	TPIDR_EL1,	/* Thread ID, Privileged */
 	AMAIR_EL1,	/* Aux Memory Attribute Indirection Register */
 	CNTKCTL_EL1,	/* Timer Control Register (EL1) */
+	TFSRE0_EL1,	/* Tag Fault Status Register (EL0) */
+	TFSR_EL1,	/* Tag Fault Stauts Register (EL1) */
 	PAR_EL1,	/* Physical Address Register */
 	MDSCR_EL1,	/* Monitor Debug System Control Register */
 	MDCCINT_EL1,	/* Monitor Debug Comms Channel Interrupt Enable Reg */
diff --git a/arch/arm64/include/asm/kvm_mte.h b/arch/arm64/include/asm/kvm_mte.h
new file mode 100644
index 000000000000..62bbfae77f33
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_mte.h
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2020 ARM Ltd.
+ */
+#ifndef __ASM_KVM_MTE_H
+#define __ASM_KVM_MTE_H
+
+#ifdef __ASSEMBLY__
+
+#include <asm/sysreg.h>
+
+#ifdef CONFIG_ARM64_MTE
+
+.macro mte_switch_to_guest g_ctxt, h_ctxt, reg1
+alternative_if_not ARM64_MTE
+	b	.L__skip_switch\@
+alternative_else_nop_endif
+	mrs	\reg1, hcr_el2
+	and	\reg1, \reg1, #(HCR_ATA)
+	cbz	\reg1, .L__skip_switch\@
+
+	mrs_s	\reg1, SYS_RGSR_EL1
+	str	\reg1, [\h_ctxt, #CPU_RGSR_EL1]
+	mrs_s	\reg1, SYS_GCR_EL1
+	str	\reg1, [\h_ctxt, #CPU_GCR_EL1]
+	mrs_s	\reg1, SYS_TFSRE0_EL1
+	str	\reg1, [\h_ctxt, #CPU_TFSRE0_EL1]
+
+	ldr	\reg1, [\g_ctxt, #CPU_RGSR_EL1]
+	msr_s	SYS_RGSR_EL1, \reg1
+	ldr	\reg1, [\g_ctxt, #CPU_GCR_EL1]
+	msr_s	SYS_GCR_EL1, \reg1
+	ldr	\reg1, [\g_ctxt, #CPU_TFSRE0_EL1]
+	msr_s	SYS_TFSRE0_EL1, \reg1
+
+.L__skip_switch\@:
+.endm
+
+.macro mte_switch_to_hyp g_ctxt, h_ctxt, reg1
+alternative_if_not ARM64_MTE
+	b	.L__skip_switch\@
+alternative_else_nop_endif
+	mrs	\reg1, hcr_el2
+	and	\reg1, \reg1, #(HCR_ATA)
+	cbz	\reg1, .L__skip_switch\@
+
+	mrs_s	\reg1, SYS_RGSR_EL1
+	str	\reg1, [\g_ctxt, #CPU_RGSR_EL1]
+	mrs_s	\reg1, SYS_GCR_EL1
+	str	\reg1, [\g_ctxt, #CPU_GCR_EL1]
+	mrs_s	\reg1, SYS_TFSRE0_EL1
+	str	\reg1, [\g_ctxt, #CPU_TFSRE0_EL1]
+
+	ldr	\reg1, [\h_ctxt, #CPU_RGSR_EL1]
+	msr_s	SYS_RGSR_EL1, \reg1
+	ldr	\reg1, [\h_ctxt, #CPU_GCR_EL1]
+	msr_s	SYS_GCR_EL1, \reg1
+	ldr	\reg1, [\h_ctxt, #CPU_TFSRE0_EL1]
+	msr_s	SYS_TFSRE0_EL1, \reg1
+
+.L__skip_switch\@:
+.endm
+
+#else /* CONFIG_ARM64_MTE */
+
+.macro mte_switch_to_guest g_ctxt, h_ctxt, reg1
+.endm
+
+.macro mte_switch_to_hyp g_ctxt, h_ctxt, reg1
+.endm
+
+#endif /* CONFIG_ARM64_MTE */
+#endif /* __ASSEMBLY__ */
+#endif /* __ASM_KVM_MTE_H */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 8b5e7e5c3cc8..0a01975d331d 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -574,7 +574,8 @@
 #define SCTLR_ELx_M	(BIT(0))
 
 #define SCTLR_ELx_FLAGS	(SCTLR_ELx_M  | SCTLR_ELx_A | SCTLR_ELx_C | \
-			 SCTLR_ELx_SA | SCTLR_ELx_I | SCTLR_ELx_IESB)
+			 SCTLR_ELx_SA | SCTLR_ELx_I | SCTLR_ELx_IESB | \
+			 SCTLR_ELx_ITFSB)
 
 /* SCTLR_EL2 specific flags. */
 #define SCTLR_EL2_RES1	((BIT(4))  | (BIT(5))  | (BIT(11)) | (BIT(16)) | \
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index f42fd9e33981..801531e1fa5c 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -105,6 +105,9 @@ int main(void)
   DEFINE(VCPU_WORKAROUND_FLAGS,	offsetof(struct kvm_vcpu, arch.workaround_flags));
   DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
   DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_cpu_context, regs));
+  DEFINE(CPU_RGSR_EL1,		offsetof(struct kvm_cpu_context, sys_regs[RGSR_EL1]));
+  DEFINE(CPU_GCR_EL1,		offsetof(struct kvm_cpu_context, sys_regs[GCR_EL1]));
+  DEFINE(CPU_TFSRE0_EL1,	offsetof(struct kvm_cpu_context, sys_regs[TFSRE0_EL1]));
   DEFINE(CPU_APIAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIAKEYLO_EL1]));
   DEFINE(CPU_APIBKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIBKEYLO_EL1]));
   DEFINE(CPU_APDAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APDAKEYLO_EL1]));
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index b0afad7a99c6..c67582c6dd55 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -13,6 +13,7 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_mte.h>
 #include <asm/kvm_ptrauth.h>
 
 	.text
@@ -51,6 +52,9 @@ alternative_else_nop_endif
 
 	add	x29, x0, #VCPU_CONTEXT
 
+	// mte_switch_to_guest(g_ctxt, h_ctxt, tmp1)
+	mte_switch_to_guest x29, x1, x2
+
 	// Macro ptrauth_switch_to_guest format:
 	// 	ptrauth_switch_to_guest(guest cxt, tmp1, tmp2, tmp3)
 	// The below macro to restore guest keys is not implemented in C code
@@ -140,6 +144,9 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 	// when this feature is enabled for kernel code.
 	ptrauth_switch_to_hyp x1, x2, x3, x4, x5
 
+	// mte_switch_to_hyp(g_ctxt, h_ctxt, reg1)
+	mte_switch_to_hyp x1, x2, x3
+
 	// Restore hyp's sp_el0
 	restore_sp_el0 x2, x3
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index cce43bfe158f..94d9736f0133 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -45,6 +45,8 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt_sys_reg(ctxt, CNTKCTL_EL1)	= read_sysreg_el1(SYS_CNTKCTL);
 	ctxt_sys_reg(ctxt, PAR_EL1)	= read_sysreg_par();
 	ctxt_sys_reg(ctxt, TPIDR_EL1)	= read_sysreg(tpidr_el1);
+	if (system_supports_mte())
+		ctxt_sys_reg(ctxt, TFSR_EL1) = read_sysreg_el1(SYS_TFSR);
 
 	ctxt_sys_reg(ctxt, SP_EL1)	= read_sysreg(sp_el1);
 	ctxt_sys_reg(ctxt, ELR_EL1)	= read_sysreg_el1(SYS_ELR);
@@ -106,6 +108,8 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 	write_sysreg_el1(ctxt_sys_reg(ctxt, CNTKCTL_EL1), SYS_CNTKCTL);
 	write_sysreg(ctxt_sys_reg(ctxt, PAR_EL1),	par_el1);
 	write_sysreg(ctxt_sys_reg(ctxt, TPIDR_EL1),	tpidr_el1);
+	if (system_supports_mte())
+		write_sysreg_el1(ctxt_sys_reg(ctxt, TFSR_EL1), SYS_TFSR);
 
 	if (!has_vhe() &&
 	    cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT) &&
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3313dedfa505..88d4f360949e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1281,6 +1281,12 @@ static bool access_ccsidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
+				   const struct sys_reg_desc *rd)
+{
+	return REG_HIDDEN;
+}
+
 /* sys_reg_desc initialiser for known cpufeature ID registers */
 #define ID_SANITISED(name) {			\
 	SYS_DESC(SYS_##name),			\
@@ -1449,8 +1455,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_ACTLR_EL1), access_actlr, reset_actlr, ACTLR_EL1 },
 	{ SYS_DESC(SYS_CPACR_EL1), NULL, reset_val, CPACR_EL1, 0 },
 
-	{ SYS_DESC(SYS_RGSR_EL1), undef_access },
-	{ SYS_DESC(SYS_GCR_EL1), undef_access },
+	{ SYS_DESC(SYS_RGSR_EL1), undef_access, reset_unknown, RGSR_EL1, .visibility = mte_visibility },
+	{ SYS_DESC(SYS_GCR_EL1), undef_access, reset_unknown, GCR_EL1, .visibility = mte_visibility },
 
 	{ SYS_DESC(SYS_ZCR_EL1), NULL, reset_val, ZCR_EL1, 0, .visibility = sve_visibility },
 	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
@@ -1476,8 +1482,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_ERXMISC0_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_ERXMISC1_EL1), trap_raz_wi },
 
-	{ SYS_DESC(SYS_TFSR_EL1), undef_access },
-	{ SYS_DESC(SYS_TFSRE0_EL1), undef_access },
+	{ SYS_DESC(SYS_TFSR_EL1), undef_access, reset_unknown, TFSR_EL1, .visibility = mte_visibility },
+	{ SYS_DESC(SYS_TFSRE0_EL1), undef_access, reset_unknown, TFSRE0_EL1, .visibility = mte_visibility },
 
 	{ SYS_DESC(SYS_FAR_EL1), access_vm_reg, reset_unknown, FAR_EL1 },
 	{ SYS_DESC(SYS_PAR_EL1), NULL, reset_unknown, PAR_EL1 },
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
