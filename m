Return-Path: <SRS0=x1Dw=SZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72EC3C282E1
	for <kvmarm@archiver.kernel.org>; Tue, 23 Apr 2019 04:43:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 31FB120B1F
	for <kvmarm@archiver.kernel.org>; Tue, 23 Apr 2019 04:43:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 31FB120B1F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CDFE74A4D1;
	Tue, 23 Apr 2019 00:43:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h2-Gho6MPWxv; Tue, 23 Apr 2019 00:43:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D08314A4C4;
	Tue, 23 Apr 2019 00:43:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EF1C4A48C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Apr 2019 00:43:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c7092im8Dv7Y for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Apr 2019 00:43:03 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20F4A4A49C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Apr 2019 00:43:03 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A4F1A78;
 Mon, 22 Apr 2019 21:43:02 -0700 (PDT)
Received: from a075553-lin.blr.arm.com (a075553-lin.blr.arm.com [10.162.0.144])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 255EB3F557;
 Mon, 22 Apr 2019 21:42:57 -0700 (PDT)
From: Amit Daniel Kachhap <amit.kachhap@arm.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH v10 2/5] KVM: arm/arm64: context-switch ptrauth registers
Date: Tue, 23 Apr 2019 10:12:35 +0530
Message-Id: <1555994558-26349-3-git-send-email-amit.kachhap@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1555994558-26349-1-git-send-email-amit.kachhap@arm.com>
References: <1555994558-26349-1-git-send-email-amit.kachhap@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu,
 Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>,
 Amit Daniel Kachhap <amit.kachhap@arm.com>, Dave Martin <Dave.Martin@arm.com>,
 linux-kernel@vger.kernel.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190423044235._nD0rlFmC6d469Vv9jjD0aH4BDqnR1OcF6t6CbstaQU@z>

From: Mark Rutland <mark.rutland@arm.com>

When pointer authentication is supported, a guest may wish to use it.
This patch adds the necessary KVM infrastructure for this to work, with
a semi-lazy context switch of the pointer auth state.

Pointer authentication feature is only enabled when VHE is built
in the kernel and present in the CPU implementation so only VHE code
paths are modified.

When we schedule a vcpu, we disable guest usage of pointer
authentication instructions and accesses to the keys. While these are
disabled, we avoid context-switching the keys. When we trap the guest
trying to use pointer authentication functionality, we change to eagerly
context-switching the keys, and enable the feature. The next time the
vcpu is scheduled out/in, we start again. However the host key save is
optimized and implemented inside ptrauth instruction/register access
trap.

Pointer authentication consists of address authentication and generic
authentication, and CPUs in a system might have varied support for
either. Where support for either feature is not uniform, it is hidden
from guests via ID register emulation, as a result of the cpufeature
framework in the host.

Unfortunately, address authentication and generic authentication cannot
be trapped separately, as the architecture provides a single EL2 trap
covering both. If we wish to expose one without the other, we cannot
prevent a (badly-written) guest from intermittently using a feature
which is not uniformly supported (when scheduled on a physical CPU which
supports the relevant feature). Hence, this patch expects both type of
authentication to be present in a cpu.

This switch of key is done from guest enter/exit assembly as preparation
for the upcoming in-kernel pointer authentication support. Hence, these
key switching routines are not implemented in C code as they may cause
pointer authentication key signing error in some situations.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
[Only VHE, key switch in full assembly, vcpu_has_ptrauth checks
, save host key in ptrauth exception trap]
Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
Changes since v9:

* Removed hardcoding of enum values[Mark Zyngier].
* Changed kvm_ptrauth_asm.h to kvm_ptrauth.h[Mark Zyngier].
* Removed macro __ptrauth_save_state and applied inline [Marc Zyngier].
* Moved kvm_arm_vcpu_ptrauth_setup_lazy, kvm_arm_vcpu_ptrauth_enable and
  kvm_arm_vcpu_ptrauth_disable from *.c to kvm_emulate.h file [Marc Zyngier].
* Added/Modified comments at few places [Marc Zyngier].

 arch/arm/include/asm/kvm_emulate.h   |   2 +
 arch/arm64/Kconfig                   |   5 +-
 arch/arm64/include/asm/kvm_emulate.h |  16 ++++++
 arch/arm64/include/asm/kvm_host.h    |  14 +++++
 arch/arm64/include/asm/kvm_ptrauth.h | 108 +++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/asm-offsets.c      |   6 ++
 arch/arm64/kvm/handle_exit.c         |  36 +++++++++---
 arch/arm64/kvm/hyp/entry.S           |  15 +++++
 arch/arm64/kvm/sys_regs.c            |  43 +++++++++++++-
 virt/kvm/arm/arm.c                   |   2 +
 10 files changed, 234 insertions(+), 13 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_ptrauth.h

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 8927cae..efb0e2c 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -343,4 +343,6 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
 	}
 }
 
+static inline void vcpu_ptrauth_setup_lazy(struct kvm_vcpu *vcpu) {}
+
 #endif /* __ARM_KVM_EMULATE_H__ */
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 7e34b9e..3cfe2eb 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1301,8 +1301,9 @@ config ARM64_PTR_AUTH
 	  context-switched along with the process.
 
 	  The feature is detected at runtime. If the feature is not present in
-	  hardware it will not be advertised to userspace nor will it be
-	  enabled.
+	  hardware it will not be advertised to userspace/KVM guest nor will it
+	  be enabled. However, KVM guest also require VHE mode and hence
+	  CONFIG_ARM64_VHE=y option to use this feature.
 
 endmenu
 
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index d384279..613427f 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -98,6 +98,22 @@ static inline void vcpu_set_wfe_traps(struct kvm_vcpu *vcpu)
 	vcpu->arch.hcr_el2 |= HCR_TWE;
 }
 
+static inline void vcpu_ptrauth_enable(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
+}
+
+static inline void vcpu_ptrauth_disable(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hcr_el2 &= ~(HCR_API | HCR_APK);
+}
+
+static inline void vcpu_ptrauth_setup_lazy(struct kvm_vcpu *vcpu)
+{
+	if (vcpu_has_ptrauth(vcpu))
+		vcpu_ptrauth_disable(vcpu);
+}
+
 static inline unsigned long vcpu_get_vsesr(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.vsesr_el2;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7ccac42..7eebea7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -161,6 +161,18 @@ enum vcpu_sysreg {
 	PMSWINC_EL0,	/* Software Increment Register */
 	PMUSERENR_EL0,	/* User Enable Register */
 
+	/* Pointer Authentication Registers in a strict increasing order. */
+	APIAKEYLO_EL1,
+	APIAKEYHI_EL1,
+	APIBKEYLO_EL1,
+	APIBKEYHI_EL1,
+	APDAKEYLO_EL1,
+	APDAKEYHI_EL1,
+	APDBKEYLO_EL1,
+	APDBKEYHI_EL1,
+	APGAKEYLO_EL1,
+	APGAKEYHI_EL1,
+
 	/* 32bit specific registers. Keep them at the end of the range */
 	DACR32_EL2,	/* Domain Access Control Register */
 	IFSR32_EL2,	/* Instruction Fault Status Register */
@@ -530,6 +542,8 @@ static inline bool kvm_arch_requires_vhe(void)
 	return false;
 }
 
+void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
+
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
diff --git a/arch/arm64/include/asm/kvm_ptrauth.h b/arch/arm64/include/asm/kvm_ptrauth.h
new file mode 100644
index 0000000..f337237
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_ptrauth.h
@@ -0,0 +1,108 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* arch/arm64/include/asm/kvm_ptrauth.h: Guest/host ptrauth save/restore
+ * Copyright 2019 Arm Limited
+ * Authors: Mark Rutland <mark.rutland@arm.com>
+ *         Amit Daniel Kachhap <amit.kachhap@arm.com>
+ */
+
+#ifndef __ASM_KVM_PTRAUTH_H
+#define __ASM_KVM_PTRAUTH_H
+
+#ifdef __ASSEMBLY__
+
+#include <asm/sysreg.h>
+
+#ifdef	CONFIG_ARM64_PTR_AUTH
+
+#define PTRAUTH_REG_OFFSET(x)	(x - CPU_APIAKEYLO_EL1)
+
+/*
+ * CPU_AP*_EL1 values exceed immediate offset range (512) for stp instruction
+ * so below macros takes CPU_APIAKEYLO_EL1 as base and calculates the offset of
+ * the keys from this base to avoid an extra add instruction. These macros
+ * assumes the keys offsets are aligned in a specific increasing order.
+ */
+.macro	ptrauth_save_state base, reg1, reg2
+	mrs_s	\reg1, SYS_APIAKEYLO_EL1
+	mrs_s	\reg2, SYS_APIAKEYHI_EL1
+	stp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APIAKEYLO_EL1)]
+	mrs_s	\reg1, SYS_APIBKEYLO_EL1
+	mrs_s	\reg2, SYS_APIBKEYHI_EL1
+	stp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APIBKEYLO_EL1)]
+	mrs_s	\reg1, SYS_APDAKEYLO_EL1
+	mrs_s	\reg2, SYS_APDAKEYHI_EL1
+	stp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APDAKEYLO_EL1)]
+	mrs_s	\reg1, SYS_APDBKEYLO_EL1
+	mrs_s	\reg2, SYS_APDBKEYHI_EL1
+	stp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APDBKEYLO_EL1)]
+	mrs_s	\reg1, SYS_APGAKEYLO_EL1
+	mrs_s	\reg2, SYS_APGAKEYHI_EL1
+	stp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APGAKEYLO_EL1)]
+.endm
+
+.macro	ptrauth_restore_state base, reg1, reg2
+	ldp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APIAKEYLO_EL1)]
+	msr_s	SYS_APIAKEYLO_EL1, \reg1
+	msr_s	SYS_APIAKEYHI_EL1, \reg2
+	ldp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APIBKEYLO_EL1)]
+	msr_s	SYS_APIBKEYLO_EL1, \reg1
+	msr_s	SYS_APIBKEYHI_EL1, \reg2
+	ldp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APDAKEYLO_EL1)]
+	msr_s	SYS_APDAKEYLO_EL1, \reg1
+	msr_s	SYS_APDAKEYHI_EL1, \reg2
+	ldp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APDBKEYLO_EL1)]
+	msr_s	SYS_APDBKEYLO_EL1, \reg1
+	msr_s	SYS_APDBKEYHI_EL1, \reg2
+	ldp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APGAKEYLO_EL1)]
+	msr_s	SYS_APGAKEYLO_EL1, \reg1
+	msr_s	SYS_APGAKEYHI_EL1, \reg2
+.endm
+
+/* Both ptrauth_switch_to_guest and ptrauth_switch_to_host macros will check for
+ * the presence of one of the cpufeature flag ARM64_HAS_ADDRESS_AUTH_ARCH or
+ * ARM64_HAS_ADDRESS_AUTH_IMP_DEF and then proceed ahead with the save/restore
+ * of Pointer Authentication key registers.
+ */
+.macro ptrauth_switch_to_guest g_ctxt, reg1, reg2, reg3
+alternative_if ARM64_HAS_ADDRESS_AUTH_ARCH
+	b	1000f
+alternative_else_nop_endif
+alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
+	b	1001f
+alternative_else_nop_endif
+1000:
+	ldr	\reg1, [\g_ctxt, #(VCPU_HCR_EL2 - VCPU_CONTEXT)]
+	and	\reg1, \reg1, #(HCR_API | HCR_APK)
+	cbz	\reg1, 1001f
+	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
+	ptrauth_restore_state	\reg1, \reg2, \reg3
+1001:
+.endm
+
+.macro ptrauth_switch_to_host g_ctxt, h_ctxt, reg1, reg2, reg3
+alternative_if ARM64_HAS_ADDRESS_AUTH_ARCH
+	b	2000f
+alternative_else_nop_endif
+alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
+	b	2001f
+alternative_else_nop_endif
+2000:
+	ldr	\reg1, [\g_ctxt, #(VCPU_HCR_EL2 - VCPU_CONTEXT)]
+	and	\reg1, \reg1, #(HCR_API | HCR_APK)
+	cbz	\reg1, 2001f
+	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
+	ptrauth_save_state	\reg1, \reg2, \reg3
+	add	\reg1, \h_ctxt, #CPU_APIAKEYLO_EL1
+	ptrauth_restore_state	\reg1, \reg2, \reg3
+	isb
+2001:
+.endm
+
+#else /* !CONFIG_ARM64_PTR_AUTH */
+.macro ptrauth_switch_to_guest g_ctxt, reg1, reg2, reg3
+.endm
+.macro ptrauth_switch_to_host g_ctxt, h_ctxt, reg1, reg2, reg3
+.endm
+#endif /* CONFIG_ARM64_PTR_AUTH */
+#endif /* __ASSEMBLY__ */
+#endif /* __ASM_KVM_PTRAUTH_H */
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 7f40dcb..8178330 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -125,7 +125,13 @@ int main(void)
   DEFINE(VCPU_CONTEXT,		offsetof(struct kvm_vcpu, arch.ctxt));
   DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.fault.disr_el1));
   DEFINE(VCPU_WORKAROUND_FLAGS,	offsetof(struct kvm_vcpu, arch.workaround_flags));
+  DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
   DEFINE(CPU_GP_REGS,		offsetof(struct kvm_cpu_context, gp_regs));
+  DEFINE(CPU_APIAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIAKEYLO_EL1]));
+  DEFINE(CPU_APIBKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIBKEYLO_EL1]));
+  DEFINE(CPU_APDAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APDAKEYLO_EL1]));
+  DEFINE(CPU_APDBKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APDBKEYLO_EL1]));
+  DEFINE(CPU_APGAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APGAKEYLO_EL1]));
   DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_regs, regs));
   DEFINE(HOST_CONTEXT_VCPU,	offsetof(struct kvm_cpu_context, __hyp_running_vcpu));
 #endif
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 0b79834..516aead 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -173,20 +173,40 @@ static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return 1;
 }
 
+#define __ptrauth_save_key(regs, key)						\
+({										\
+	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
+	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
+})
+
+/*
+ * Handle the guest trying to use a ptrauth instruction, or trying to access a
+ * ptrauth register.
+ */
+void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *ctxt;
+
+	if (vcpu_has_ptrauth(vcpu)) {
+		vcpu_ptrauth_enable(vcpu);
+		ctxt = vcpu->arch.host_cpu_context;
+		__ptrauth_save_key(ctxt->sys_regs, APIA);
+		__ptrauth_save_key(ctxt->sys_regs, APIB);
+		__ptrauth_save_key(ctxt->sys_regs, APDA);
+		__ptrauth_save_key(ctxt->sys_regs, APDB);
+		__ptrauth_save_key(ctxt->sys_regs, APGA);
+	} else {
+		kvm_inject_undefined(vcpu);
+	}
+}
+
 /*
  * Guest usage of a ptrauth instruction (which the guest EL1 did not turn into
  * a NOP).
  */
 static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
-	/*
-	 * We don't currently support ptrauth in a guest, and we mask the ID
-	 * registers to prevent well-behaved guests from trying to make use of
-	 * it.
-	 *
-	 * Inject an UNDEF, as if the feature really isn't present.
-	 */
-	kvm_inject_undefined(vcpu);
+	kvm_arm_vcpu_ptrauth_trap(vcpu);
 	return 1;
 }
 
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 675fdc1..93ba3d7 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -24,6 +24,7 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_ptrauth.h>
 
 #define CPU_GP_REG_OFFSET(x)	(CPU_GP_REGS + x)
 #define CPU_XREG_OFFSET(x)	CPU_GP_REG_OFFSET(CPU_USER_PT_REGS + 8*x)
@@ -64,6 +65,13 @@ ENTRY(__guest_enter)
 
 	add	x18, x0, #VCPU_CONTEXT
 
+	// Macro ptrauth_switch_to_guest format:
+	// 	ptrauth_switch_to_guest(guest cxt, tmp1, tmp2, tmp3)
+	// The below macro to restore guest keys is not implemented in C code
+	// as it may cause Pointer Authentication key signing mismatch errors
+	// when this feature is enabled for kernel code.
+	ptrauth_switch_to_guest x18, x0, x1, x2
+
 	// Restore guest regs x0-x17
 	ldp	x0, x1,   [x18, #CPU_XREG_OFFSET(0)]
 	ldp	x2, x3,   [x18, #CPU_XREG_OFFSET(2)]
@@ -118,6 +126,13 @@ ENTRY(__guest_exit)
 
 	get_host_ctxt	x2, x3
 
+	// Macro ptrauth_switch_to_guest format:
+	// 	ptrauth_switch_to_host(guest cxt, host cxt, tmp1, tmp2, tmp3)
+	// The below macro to save/restore keys is not implemented in C code
+	// as it may cause Pointer Authentication key signing mismatch errors
+	// when this feature is enabled for kernel code.
+	ptrauth_switch_to_host x1, x2, x3, x4, x5
+
 	// Now restore the host regs
 	restore_callee_saved_regs x2
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7046c76..7f06c2e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1007,6 +1007,35 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	{ SYS_DESC(SYS_PMEVTYPERn_EL0(n)),					\
 	  access_pmu_evtyper, reset_unknown, (PMEVTYPER0_EL0 + n), }
 
+static bool trap_ptrauth(struct kvm_vcpu *vcpu,
+			 struct sys_reg_params *p,
+			 const struct sys_reg_desc *rd)
+{
+	kvm_arm_vcpu_ptrauth_trap(vcpu);
+
+	/*
+	 * Return is false for both cases and PC remains same,
+	 * a) Re-execute the same key register access instruction after enabling
+	 *    ptrauth.
+	 * b) UNDEF is injected as ptrauth is not supported/enabled.
+	 */
+	return false;
+}
+
+static unsigned int ptrauth_visibility(const struct kvm_vcpu *vcpu,
+			const struct sys_reg_desc *rd)
+{
+	return vcpu_has_ptrauth(vcpu) ? 0 : REG_HIDDEN_USER | REG_HIDDEN_GUEST;
+}
+
+#define __PTRAUTH_KEY(k)						\
+	{ SYS_DESC(SYS_## k), trap_ptrauth, reset_unknown, k,		\
+	.visibility = ptrauth_visibility}
+
+#define PTRAUTH_KEY(k)							\
+	__PTRAUTH_KEY(k ## KEYLO_EL1),					\
+	__PTRAUTH_KEY(k ## KEYHI_EL1)
+
 static bool access_arch_timer(struct kvm_vcpu *vcpu,
 			      struct sys_reg_params *p,
 			      const struct sys_reg_desc *r)
@@ -1058,9 +1087,11 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 					 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
 					 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
 					 (0xfUL << ID_AA64ISAR1_GPI_SHIFT);
-		if (val & ptrauth_mask)
-			kvm_debug("ptrauth unsupported for guests, suppressing\n");
-		val &= ~ptrauth_mask;
+		if (!vcpu_has_ptrauth(vcpu)) {
+			if (val & ptrauth_mask)
+				kvm_debug("ptrauth unsupported for guests, suppressing\n");
+			val &= ~ptrauth_mask;
+		}
 	}
 
 	return val;
@@ -1460,6 +1491,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
 	{ SYS_DESC(SYS_TCR_EL1), access_vm_reg, reset_val, TCR_EL1, 0 },
 
+	PTRAUTH_KEY(APIA),
+	PTRAUTH_KEY(APIB),
+	PTRAUTH_KEY(APDA),
+	PTRAUTH_KEY(APDB),
+	PTRAUTH_KEY(APGA),
+
 	{ SYS_DESC(SYS_AFSR0_EL1), access_vm_reg, reset_unknown, AFSR0_EL1 },
 	{ SYS_DESC(SYS_AFSR1_EL1), access_vm_reg, reset_unknown, AFSR1_EL1 },
 	{ SYS_DESC(SYS_ESR_EL1), access_vm_reg, reset_unknown, ESR_EL1 },
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 7039c99c..156c09d 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -385,6 +385,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		vcpu_clear_wfe_traps(vcpu);
 	else
 		vcpu_set_wfe_traps(vcpu);
+
+	vcpu_ptrauth_setup_lazy(vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
-- 
2.7.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
