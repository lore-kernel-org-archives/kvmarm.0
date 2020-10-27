Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 247E7C55178
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:26:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A00AB22258
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:26:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A00AB22258
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 354D24B4F3;
	Tue, 27 Oct 2020 13:26:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eMVsdhci-vJG; Tue, 27 Oct 2020 13:26:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB4C44B4AB;
	Tue, 27 Oct 2020 13:26:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44AED4B504
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:26:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dwS-6d9eoxn5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 13:26:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10F894B3DB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:26:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CCBAF15AB;
 Tue, 27 Oct 2020 10:26:31 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C5D8A3F719;
 Tue, 27 Oct 2020 10:26:30 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH v3 13/16] KVM: arm64: Switch SPE context on VM entry/exit
Date: Tue, 27 Oct 2020 17:27:02 +0000
Message-Id: <20201027172705.15181-14-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027172705.15181-1-alexandru.elisei@arm.com>
References: <20201027172705.15181-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: maz@kernel.org, will@kernel.org
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

When the host and the guest are using SPE at the same time, KVM will have
to save and restore the proper SPE context on VM entry (save host's,
restore guest's, and on VM exit (save guest's, restore host's).

On systems without VHE, the world switch happens at EL2, while both the
guest and the host execute at EL1, and according to ARM DDI 0487F.b, page
D9-2807, sampling is disabled in this case:

"If the PE takes an exception to an Exception level where the Statistical
Profiling Extension is disabled, no new operations are selected for
sampling."

We still have to disable the buffer before we switch translation regimes
because we don't want the SPE buffer to speculate memory accesses using a
stale buffer pointer.

On VHE systems, the world switch happens at EL2, with the host potentially
in the middle of a profiling session and we also need to explicitely
disable host sampling.

The buffer owning Exception level is determined by MDCR_EL2.E2PB. On
systems with VHE, this is the different between the guest (executes at EL1)
and the host (executes at EL2). The current behavior of perf is to profile
KVM until it drops to the guest at EL1. To preserve this behavior as much
as possible, KVM will defer changing the value of MDCR_EL2 until
__{activate,deactivate}_traps().

For the purposes of emulating the SPE buffer management interrupt, MDCR_EL2
is configured to trap accesses to the buffer control registers; the guest
can access the rest of the registers directly.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h        |   1 +
 arch/arm64/include/asm/kvm_hyp.h        |  28 +++++-
 arch/arm64/include/asm/sysreg.h         |   1 +
 arch/arm64/kvm/debug.c                  |  29 +++++-
 arch/arm64/kvm/hyp/include/hyp/spe-sr.h |  38 ++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |   1 -
 arch/arm64/kvm/hyp/nvhe/Makefile        |   1 +
 arch/arm64/kvm/hyp/nvhe/debug-sr.c      |  16 ++-
 arch/arm64/kvm/hyp/nvhe/spe-sr.c        |  93 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        |  12 +++
 arch/arm64/kvm/hyp/vhe/Makefile         |   1 +
 arch/arm64/kvm/hyp/vhe/spe-sr.c         | 124 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c         |  48 ++++++++-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c      |   2 +-
 arch/arm64/kvm/spe.c                    |   3 +
 arch/arm64/kvm/sys_regs.c               |   1 +
 16 files changed, 384 insertions(+), 15 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/spe-sr.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/spe-sr.c
 create mode 100644 arch/arm64/kvm/hyp/vhe/spe-sr.c

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 64ce29378467..033980a9b3fc 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -280,6 +280,7 @@
 #define MDCR_EL2_TPMS		(1 << 14)
 #define MDCR_EL2_E2PB_MASK	(UL(0x3))
 #define MDCR_EL2_E2PB_SHIFT	(UL(12))
+#define MDCR_EL2_E2PB_EL1_TRAP	(2 << MDCR_EL2_E2PB_SHIFT);
 #define MDCR_EL2_TDRA		(1 << 11)
 #define MDCR_EL2_TDOSA		(1 << 10)
 #define MDCR_EL2_TDA		(1 << 9)
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 6b664de5ec1f..4358cba6784a 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -79,6 +79,32 @@ void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt);
 void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt);
 #endif
 
+#ifdef CONFIG_KVM_ARM_SPE
+#ifdef __KVM_NVHE_HYPERVISOR__
+void __sysreg_save_spe_host_state_nvhe(struct kvm_cpu_context *ctxt);
+void __sysreg_restore_spe_host_state_nvhe(struct kvm_cpu_context *ctxt);
+void __sysreg_save_spe_guest_state_nvhe(struct kvm_vcpu *vcpu);
+void __sysreg_restore_spe_guest_state_nvhe(struct kvm_vcpu *vcpu);
+#else
+void sysreg_save_spe_host_state_vhe(struct kvm_cpu_context *ctxt);
+void sysreg_restore_spe_host_state_vhe(struct kvm_cpu_context *ctxt);
+void sysreg_save_spe_guest_state_vhe(struct kvm_vcpu *vcpu);
+void sysreg_restore_spe_guest_state_vhe(struct kvm_vcpu *vcpu);
+#endif
+#else	/* !CONFIG_KVM_ARM_SPE */
+#ifdef __KVM_NVHE_HYPERVISOR__
+void __sysreg_save_spe_host_state_nvhe(struct kvm_cpu_context *ctxt) {}
+void __sysreg_restore_spe_host_state_nvhe(struct kvm_cpu_context *ctxt) {}
+void __sysreg_save_spe_guest_state_nvhe(struct kvm_vcpu *vcpu) {}
+void __sysreg_restore_spe_guest_state_nvhe(struct kvm_vcpu *vcpu) {}
+#else
+void sysreg_save_spe_host_state_vhe(struct kvm_cpu_context *ctxt) {}
+void sysreg_restore_spe_host_state_vhe(struct kvm_cpu_context *ctxt) {}
+void sysreg_save_spe_guest_state_vhe(struct kvm_vcpu *vcpu) {}
+void sysreg_restore_spe_guest_state_vhe(struct kvm_vcpu *vcpu) {}
+#endif
+#endif /* CONFIG_KVM_ARM_SPE */
+
 void __debug_switch_to_guest(struct kvm_vcpu *vcpu);
 void __debug_switch_to_host(struct kvm_vcpu *vcpu);
 
@@ -87,7 +113,7 @@ void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
 
 #ifndef __KVM_NVHE_HYPERVISOR__
 void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
-void deactivate_traps_vhe_put(void);
+void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu);
 #endif
 
 u64 __guest_enter(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index d52c1b3ce589..20159af17578 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -255,6 +255,7 @@
 
 /* Sampling controls */
 #define SYS_PMSCR_EL1			sys_reg(3, 0, 9, 9, 0)
+#define SYS_PMSCR_EL12			sys_reg(3, 5, 9, 9, 0)
 #define SYS_PMSCR_EL1_E0SPE_SHIFT	0
 #define SYS_PMSCR_EL1_E1SPE_SHIFT	1
 #define SYS_PMSCR_EL1_CX_SHIFT		3
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 22ee448aee2b..892ce9cc4079 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -84,17 +84,28 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu, u32 host_mdcr)
 {
 	bool trap_debug = !(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY);
 
-	/*
-	 * This also clears MDCR_EL2_E2PB_MASK to disable guest access
-	 * to the profiling buffer.
-	 */
 	vcpu->arch.mdcr_el2 = host_mdcr & MDCR_EL2_HPMN_MASK;
 	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
-				MDCR_EL2_TPMS |
 				MDCR_EL2_TPMCR |
 				MDCR_EL2_TDRA |
 				MDCR_EL2_TDOSA);
 
+	if (vcpu_has_spe(vcpu)) {
+		/*
+		 * Use EL1&0 translation regime, trap accesses to the buffer
+		 * control registers, allow guest direct access to the
+		 * statistical profiling control registers by leaving the TPMS
+		 * bit clear.
+		 */
+		vcpu->arch.mdcr_el2 |= MDCR_EL2_E2PB_EL1_TRAP;
+	} else {
+		/*
+		 * Disable buffer by leaving E2PB zero, trap accesses to all SPE
+		 * registers.
+		 */
+		vcpu->arch.mdcr_el2 |= MDCR_EL2_TPMS;
+	}
+
 	if (vcpu->guest_debug) {
 		/* Route all software debug exceptions to EL2 */
 		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDE;
@@ -227,10 +238,18 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 	if (vcpu_read_sys_reg(vcpu, MDSCR_EL1) & (DBG_MDSCR_KDE | DBG_MDSCR_MDE))
 		vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
 
+	/*
+	 * On VHE systems, when the guest has SPE, MDCR_EL2 write is deferred
+	 * until __activate_traps().
+	 */
+	if (has_vhe() && vcpu_has_spe(vcpu))
+		goto out;
+
 	/* Write mdcr_el2 changes since vcpu_load on VHE systems */
 	if (has_vhe() && orig_mdcr_el2 != vcpu->arch.mdcr_el2)
 		write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 
+out:
 	trace_kvm_arm_set_dreg32("MDSCR_EL1", vcpu_read_sys_reg(vcpu, MDSCR_EL1));
 }
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/spe-sr.h b/arch/arm64/kvm/hyp/include/hyp/spe-sr.h
new file mode 100644
index 000000000000..00ed684c117c
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/hyp/spe-sr.h
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 - ARM Ltd
+ * Author: Alexandru Elisei <alexandru.elisei@arm.com>
+ */
+
+#ifndef __ARM64_KVM_HYP_SPE_SR_H__
+#define __ARM64_KVM_HYP_SPE_SR_H__
+
+#include <linux/kvm_host.h>
+
+#include <asm/sysreg.h>
+
+#ifdef CONFIG_KVM_ARM_SPE
+static inline void __sysreg_save_spe_state_common(struct kvm_cpu_context *ctxt)
+{
+	ctxt_sys_reg(ctxt, PMSICR_EL1) = read_sysreg_s(SYS_PMSICR_EL1);
+	ctxt_sys_reg(ctxt, PMSIRR_EL1) = read_sysreg_s(SYS_PMSIRR_EL1);
+	ctxt_sys_reg(ctxt, PMSFCR_EL1) = read_sysreg_s(SYS_PMSFCR_EL1);
+	ctxt_sys_reg(ctxt, PMSEVFR_EL1) = read_sysreg_s(SYS_PMSEVFR_EL1);
+	ctxt_sys_reg(ctxt, PMSLATFR_EL1) = read_sysreg_s(SYS_PMSLATFR_EL1);
+}
+
+
+static inline void __sysreg_restore_spe_state_common(struct kvm_cpu_context *ctxt)
+{
+	write_sysreg_s(ctxt_sys_reg(ctxt, PMSICR_EL1), SYS_PMSICR_EL1);
+	write_sysreg_s(ctxt_sys_reg(ctxt, PMSIRR_EL1), SYS_PMSIRR_EL1);
+	write_sysreg_s(ctxt_sys_reg(ctxt, PMSFCR_EL1), SYS_PMSFCR_EL1);
+	write_sysreg_s(ctxt_sys_reg(ctxt, PMSEVFR_EL1), SYS_PMSEVFR_EL1);
+	write_sysreg_s(ctxt_sys_reg(ctxt, PMSLATFR_EL1), SYS_PMSLATFR_EL1);
+}
+#else
+static inline void __sysreg_save_spe_state_common(struct kvm_cpu_context *ctxt) {}
+static inline void __sysreg_restore_spe_state_common(struct kvm_cpu_context *ctxt) {}
+
+#endif /* CONFIG_KVM_ARM_SPE */
+#endif /* __ARM64_KVM_HYP_SPE_SR_H__ */
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 313a8fa3c721..c88a40eeb171 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -90,7 +90,6 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	 */
 	write_sysreg(0, pmselr_el0);
 	write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
-	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 }
 
 static inline void __deactivate_traps_common(void)
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index ddde15fe85f2..fcc33b682a45 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -7,6 +7,7 @@ asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o hyp-main.o
+obj-$(CONFIG_KVM_ARM_SPE) += spe-sr.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o
 
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 91a711aa8382..af65afca479a 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -60,14 +60,24 @@ static void __debug_restore_spe(u64 pmscr_el1)
 
 void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 {
-	/* Disable and flush SPE data generation */
-	__debug_save_spe(&vcpu->arch.host_debug_state.pmscr_el1);
+	/*
+	 * If the guest is using SPE, host SPE was disabled when the host state
+	 * was saved.
+	 */
+	if (!vcpu_has_spe(vcpu))
+		/* Disable and flush SPE data generation */
+		__debug_save_spe(&vcpu->arch.host_debug_state.pmscr_el1);
 	__debug_switch_to_guest_common(vcpu);
 }
 
 void __debug_switch_to_host(struct kvm_vcpu *vcpu)
 {
-	__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
+	/*
+	 * Host SPE state was restored with the rest of the host registers when
+	 * the guest is using SPE.
+	 */
+	if (!vcpu_has_spe(vcpu))
+		__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
 	__debug_switch_to_host_common(vcpu);
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/spe-sr.c b/arch/arm64/kvm/hyp/nvhe/spe-sr.c
new file mode 100644
index 000000000000..a73ee820b27f
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/spe-sr.c
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 - ARM Ltd
+ * Author: Alexandru Elisei <alexandru.elisei@arm.com>
+ */
+
+#include <hyp/spe-sr.h>
+
+#include <linux/kvm_host.h>
+
+#include <asm/kprobes.h>
+#include <asm/kvm_hyp.h>
+
+/*
+ * The SPE profiling buffer acts like a separate observer in the system, and we
+ * need to make sure it's disabled before switching translation regimes (host to
+ * guest and vice versa).
+ *
+ * Sampling is disabled when we're at an higher exception level than the owning
+ * exception level, and we don't disable sampling on save/restore, like we do in
+ * the VHE case, where the host is profiling at EL2.
+ *
+ * Profiling is enabled when both sampling and the buffer are enabled, as a
+ * result we don't have to worry about PMBPTR_EL1 restrictions with regard to
+ * PMBLIMITR_EL1.LIMIT.
+ */
+
+void __sysreg_save_spe_host_state_nvhe(struct kvm_cpu_context *ctxt)
+{
+	u64 pmblimitr = read_sysreg_s(SYS_PMBLIMITR_EL1);
+
+	if (pmblimitr & BIT(SYS_PMBLIMITR_EL1_E_SHIFT)) {
+		psb_csync();
+		dsb(nsh);
+		write_sysreg_s(0, SYS_PMBLIMITR_EL1);
+		isb();
+	}
+
+	ctxt_sys_reg(ctxt, PMBPTR_EL1) = read_sysreg_s(SYS_PMBPTR_EL1);
+	ctxt_sys_reg(ctxt, PMBSR_EL1) = read_sysreg_s(SYS_PMBSR_EL1);
+	ctxt_sys_reg(ctxt, PMBLIMITR_EL1) = pmblimitr;
+	ctxt_sys_reg(ctxt, PMSCR_EL1) = read_sysreg_s(SYS_PMSCR_EL1);
+
+	__sysreg_save_spe_state_common(ctxt);
+}
+
+void __sysreg_restore_spe_guest_state_nvhe(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
+
+	__sysreg_restore_spe_state_common(guest_ctxt);
+
+	/* Make sure the switch to the guest's stage 1 + stage 2 is visible */
+	isb();
+
+	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
+	/* The guest buffer management event interrupt is always virtual. */
+	write_sysreg_s(0, SYS_PMBSR_EL1);
+	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBLIMITR_EL1), SYS_PMBLIMITR_EL1);
+	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMSCR_EL1), SYS_PMSCR_EL1);
+}
+
+void __sysreg_save_spe_guest_state_nvhe(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
+	u64 pmblimitr = read_sysreg_s(SYS_PMBLIMITR_EL1);
+
+	if (pmblimitr & BIT(SYS_PMBLIMITR_EL1_E_SHIFT)) {
+		psb_csync();
+		dsb(nsh);
+		write_sysreg_s(0, SYS_PMBLIMITR_EL1);
+		isb();
+	}
+
+	ctxt_sys_reg(guest_ctxt, PMBPTR_EL1) = read_sysreg_s(SYS_PMBPTR_EL1);
+	ctxt_sys_reg(guest_ctxt, PMSCR_EL1) = read_sysreg_s(SYS_PMSCR_EL1);
+	/* PMBLIMITR_EL1 is updated only on trap. */
+
+	__sysreg_save_spe_state_common(guest_ctxt);
+}
+
+void __sysreg_restore_spe_host_state_nvhe(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_restore_spe_state_common(ctxt);
+
+	/* Make sure the switch to host's stage 1 is visible */
+	isb();
+
+	write_sysreg_s(ctxt_sys_reg(ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
+	write_sysreg_s(ctxt_sys_reg(ctxt, PMBSR_EL1), SYS_PMBSR_EL1);
+	write_sysreg_s(ctxt_sys_reg(ctxt, PMBLIMITR_EL1), SYS_PMBLIMITR_EL1);
+	write_sysreg_s(ctxt_sys_reg(ctxt, PMSCR_EL1), SYS_PMSCR_EL1);
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index a457a0306e03..4fde45c4c805 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -39,6 +39,8 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 	___activate_traps(vcpu);
 	__activate_traps_common(vcpu);
 
+	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
+
 	val = CPTR_EL2_DEFAULT;
 	val |= CPTR_EL2_TTA | CPTR_EL2_TZ | CPTR_EL2_TAM;
 	if (!update_fp_enabled(vcpu)) {
@@ -188,6 +190,8 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
 
 	__sysreg_save_state_nvhe(host_ctxt);
+	if (vcpu_has_spe(vcpu))
+		__sysreg_save_spe_host_state_nvhe(host_ctxt);
 
 	/*
 	 * We must restore the 32-bit state before the sysregs, thanks
@@ -203,6 +207,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__load_guest_stage2(kern_hyp_va(vcpu->arch.hw_mmu));
 	__activate_traps(vcpu);
 
+	if (vcpu_has_spe(vcpu))
+		__sysreg_restore_spe_guest_state_nvhe(vcpu);
+
 	__hyp_vgic_restore_state(vcpu);
 	__timer_enable_traps(vcpu);
 
@@ -216,6 +223,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
 	__sysreg_save_state_nvhe(guest_ctxt);
+	if (vcpu_has_spe(vcpu))
+		__sysreg_save_spe_guest_state_nvhe(vcpu);
+
 	__sysreg32_save_state(vcpu);
 	__timer_disable_traps(vcpu);
 	__hyp_vgic_save_state(vcpu);
@@ -224,6 +234,8 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__load_host_stage2();
 
 	__sysreg_restore_state_nvhe(host_ctxt);
+	if (vcpu_has_spe(vcpu))
+		__sysreg_restore_spe_host_state_nvhe(host_ctxt);
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
 		__fpsimd_save_fpexc32(vcpu);
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makefile
index 461e97c375cc..daff3119c359 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -7,5 +7,6 @@ asflags-y := -D__KVM_VHE_HYPERVISOR__
 ccflags-y := -D__KVM_VHE_HYPERVISOR__
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o
+obj-$(CONFIG_KVM_ARM_SPE) += spe-sr.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o
diff --git a/arch/arm64/kvm/hyp/vhe/spe-sr.c b/arch/arm64/kvm/hyp/vhe/spe-sr.c
new file mode 100644
index 000000000000..dd947e9f249c
--- /dev/null
+++ b/arch/arm64/kvm/hyp/vhe/spe-sr.c
@@ -0,0 +1,124 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 - ARM Ltd
+ * Author: Alexandru Elisei <alexandru.elisei@arm.com>
+ */
+
+#include <hyp/spe-sr.h>
+
+#include <linux/kvm_host.h>
+
+#include <asm/kprobes.h>
+#include <asm/kvm_hyp.h>
+
+void sysreg_save_spe_host_state_vhe(struct kvm_cpu_context *ctxt)
+{
+	u64 pmblimitr = read_sysreg_s(SYS_PMBLIMITR_EL1);
+	u64 pmscr_el2 = read_sysreg_el2(SYS_PMSCR);
+
+	/* Allow guest to select timestamp source, disable sampling. */
+	write_sysreg_el2(BIT(SYS_PMSCR_EL1_PCT_SHIFT), SYS_PMSCR);
+	if (pmscr_el2 & BIT(SYS_PMSCR_EL1_E1SPE_SHIFT))
+		isb();
+
+	if (pmblimitr & BIT(SYS_PMBLIMITR_EL1_E_SHIFT)) {
+		psb_csync();
+		dsb(nsh);
+		write_sysreg_s(0, SYS_PMBLIMITR_EL1);
+		isb();
+	}
+
+	ctxt_sys_reg(ctxt, PMBPTR_EL1) = read_sysreg_s(SYS_PMBPTR_EL1);
+	ctxt_sys_reg(ctxt, PMBSR_EL1) = read_sysreg_s(SYS_PMBSR_EL1);
+	ctxt_sys_reg(ctxt, PMBLIMITR_EL1) = pmblimitr;
+	/*
+	 * We abuse the context register PMSCR_EL1 to save the host's PMSCR,
+	 * which is actually PMSCR_EL2 because KVM is running at EL2.
+	 */
+	ctxt_sys_reg(ctxt, PMSCR_EL1) = pmscr_el2;
+
+	__sysreg_save_spe_state_common(ctxt);
+}
+NOKPROBE_SYMBOL(sysreg_save_spe_host_state_vhe);
+
+void sysreg_restore_spe_guest_state_vhe(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
+
+	/*
+	 * Make sure the write to MDCR_EL2 which changes the buffer owning
+	 * Exception level is visible.
+	 */
+	isb();
+
+	/*
+	 * Order doesn't matter because sampling is disabled at EL2. However,
+	 * restore guest registers in the same program order as the host for
+	 * consistency.
+	 */
+	__sysreg_restore_spe_state_common(guest_ctxt);
+
+	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
+	/* The guest buffer management event interrupt is always virtual. */
+	write_sysreg_s(0, SYS_PMBSR_EL1);
+	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBLIMITR_EL1), SYS_PMBLIMITR_EL1);
+	write_sysreg_el1(ctxt_sys_reg(guest_ctxt, PMSCR_EL1), SYS_PMSCR);
+}
+NOKPROBE_SYMBOL(sysreg_restore_spe_guest_state_vhe);
+
+void sysreg_save_spe_guest_state_vhe(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
+	u64 pmblimitr = read_sysreg_s(SYS_PMBLIMITR_EL1);
+
+	/*
+	 * We're going to switch buffer owning Exception level when we restore
+	 * the host MDCR_EL2 value, make sure the buffer is disabled until we
+	 * restore the host registers.
+	 *
+	 * Sampling at EL2 was disabled when we saved the host's SPE state, no
+	 * need to disable it again.
+	 */
+	if (pmblimitr & BIT(SYS_PMBLIMITR_EL1_E_SHIFT)) {
+		/*
+		 * We don't an ISB before PSB CSYNC because exception entry is a
+		 * context synchronization event.
+		 */
+		psb_csync();
+		dsb(nsh);
+		write_sysreg_s(0, SYS_PMBLIMITR_EL1);
+		isb();
+	}
+
+	ctxt_sys_reg(guest_ctxt, PMBPTR_EL1) = read_sysreg_s(SYS_PMBPTR_EL1);
+	ctxt_sys_reg(guest_ctxt, PMSCR_EL1) = read_sysreg_el1(SYS_PMSCR);
+	/* PMBLIMITR_EL1 is updated only on trap, skip saving it. */
+
+	__sysreg_save_spe_state_common(guest_ctxt);
+}
+NOKPROBE_SYMBOL(sysreg_save_spe_guest_state_vhe);
+
+void sysreg_restore_spe_host_state_vhe(struct kvm_cpu_context *ctxt)
+{
+	/*
+	 * Order matters now because we're possibly restarting profiling.
+	 * Restore common state first so PMSICR_EL1 is updated before PMSCR_EL2.
+	 */
+	__sysreg_restore_spe_state_common(ctxt);
+
+	write_sysreg_s(ctxt_sys_reg(ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
+	/*
+	 * Make sure PMBPTR_EL1 update is seen first, so we don't end up in a
+	 * situation where the buffer is enabled and the pointer passes
+	 * the value of PMBLIMITR_EL1.LIMIT programmed by the guest.
+	 *
+	 * This also serves to make sure the write to MDCR_EL2 which changes the
+	 * buffer owning Exception level is visible; the buffer is still
+	 * disabled until the write to PMBLIMITR_EL1.
+	 */
+	isb();
+	write_sysreg_s(ctxt_sys_reg(ctxt, PMBSR_EL1), SYS_PMBSR_EL1);
+	write_sysreg_s(ctxt_sys_reg(ctxt, PMBLIMITR_EL1), SYS_PMBLIMITR_EL1);
+	write_sysreg_el2(ctxt_sys_reg(ctxt, PMSCR_EL1), SYS_PMSCR);
+}
+NOKPROBE_SYMBOL(sysreg_restore_host_state_vhe);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 3f4db1fa388b..c7f3c8a004b6 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -64,6 +64,9 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 	write_sysreg(val, cpacr_el1);
 
+	if (vcpu_has_spe(vcpu))
+		write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
+
 	write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el1);
 }
 NOKPROBE_SYMBOL(__activate_traps);
@@ -84,6 +87,13 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
 
 	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
+	if (vcpu_has_spe(vcpu)) {
+		u64 mdcr_el2 = read_sysreg(mdcr_el2);
+
+		mdcr_el2 &= MDCR_EL2_HPMN_MASK | MDCR_EL2_TPMS;
+
+		write_sysreg(mdcr_el2, mdcr_el2);
+	}
 	write_sysreg(vectors, vbar_el1);
 }
 NOKPROBE_SYMBOL(__deactivate_traps);
@@ -91,15 +101,36 @@ NOKPROBE_SYMBOL(__deactivate_traps);
 void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
 {
 	__activate_traps_common(vcpu);
+	/*
+	 * When the guest is using SPE, vcpu->arch.mdcr_el2 configures the
+	 * profiling buffer to use the EL1&0 translation regime. If that's
+	 * loaded on the hardware and host has profiling enabled, the SPE buffer
+	 * will start using the guest's EL1&0 translation regime, but without
+	 * stage 2 enabled. That's bad.
+	 *
+	 * We cannot rely on checking here that profiling is enabled because
+	 * perf might install an event on the CPU via an IPI before we
+	 * deactivate interrupts. Instead, we defer loading the guest mdcr_el2
+	 * until __activate_traps().
+	 */
+	if (vcpu_has_spe(vcpu))
+		return;
+	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 }
 
-void deactivate_traps_vhe_put(void)
+void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
 {
-	u64 mdcr_el2 = read_sysreg(mdcr_el2);
+	/*
+	 * When the guest is using SPE, we load the host MDCR_EL2 value early,
+	 * in __deactivate_traps(). to allow perf to profile KVM.
+	 */
+	if (!vcpu_has_spe(vcpu)) {
+		u64 mdcr_el2 = read_sysreg(mdcr_el2);
 
-	mdcr_el2 &= MDCR_EL2_HPMN_MASK | MDCR_EL2_TPMS;
+		mdcr_el2 &= MDCR_EL2_HPMN_MASK | MDCR_EL2_TPMS;
 
-	write_sysreg(mdcr_el2, mdcr_el2);
+		write_sysreg(mdcr_el2, mdcr_el2);
+	}
 
 	__deactivate_traps_common();
 }
@@ -116,6 +147,8 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	guest_ctxt = &vcpu->arch.ctxt;
 
 	sysreg_save_host_state_vhe(host_ctxt);
+	if (vcpu_has_spe(vcpu))
+		sysreg_save_spe_host_state_vhe(host_ctxt);
 
 	/*
 	 * ARM erratum 1165522 requires us to configure both stage 1 and
@@ -132,6 +165,9 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	__activate_traps(vcpu);
 
 	sysreg_restore_guest_state_vhe(guest_ctxt);
+	if (vcpu_has_spe(vcpu))
+		sysreg_restore_spe_guest_state_vhe(vcpu);
+
 	__debug_switch_to_guest(vcpu);
 
 	do {
@@ -142,10 +178,14 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
 	sysreg_save_guest_state_vhe(guest_ctxt);
+	if (vcpu_has_spe(vcpu))
+		sysreg_save_spe_guest_state_vhe(vcpu);
 
 	__deactivate_traps(vcpu);
 
 	sysreg_restore_host_state_vhe(host_ctxt);
+	if (vcpu_has_spe(vcpu))
+		sysreg_restore_spe_host_state_vhe(host_ctxt);
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
 		__fpsimd_save_fpexc32(vcpu);
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 2a0b8c88d74f..007a12dd4351 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -101,7 +101,7 @@ void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *host_ctxt;
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
-	deactivate_traps_vhe_put();
+	deactivate_traps_vhe_put(vcpu);
 
 	__sysreg_save_el1_state(guest_ctxt);
 	__sysreg_save_user_state(guest_ctxt);
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 0e365a51cac7..ba80f2716a11 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2019 ARM Ltd.
  */
 
+#include <linux/bug.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/uaccess.h>
@@ -14,11 +15,13 @@
 
 void kvm_arm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
 {
+	WARN(reg < PMBLIMITR_EL1, "Unexpected trap to SPE register\n");
 	__vcpu_sys_reg(vcpu, reg) = val;
 }
 
 u64 kvm_arm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg)
 {
+	WARN(reg < PMBLIMITR_EL1, "Unexpected trap to SPE register\n");
 	return __vcpu_sys_reg(vcpu, reg);
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2871484993ec..3a0687602839 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -254,6 +254,7 @@ static bool access_spe_reg(struct kvm_vcpu *vcpu,
 			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
 
 	if (sr == SYS_PMSIDR_EL1) {
+		WARN(true, "Unexpected trap to SPE register\n");
 		/* Ignore writes. */
 		if (!p->is_write)
 			p->regval = read_sysreg_s(SYS_PMSIDR_EL1);
-- 
2.29.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
