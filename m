Return-Path: <SRS0=u4Cy=NQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ABCCC4338F
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:19:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C83BA61153
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:19:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C83BA61153
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C6544B2A4;
	Wed, 25 Aug 2021 12:19:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8vGkFvbucDTL; Wed, 25 Aug 2021 12:19:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 838294B283;
	Wed, 25 Aug 2021 12:18:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0623A4029C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:18:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vOYeiXT82FMB for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Aug 2021 12:18:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D5BE4B1FD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:18:01 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D5A07143B;
 Wed, 25 Aug 2021 09:18:00 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 872583F66F;
 Wed, 25 Aug 2021 09:17:59 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 30/39] KVM: arm64: nVHE: Context switch SPE state if
 VCPU has SPE
Date: Wed, 25 Aug 2021 17:18:06 +0100
Message-Id: <20210825161815.266051-31-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210825161815.266051-1-alexandru.elisei@arm.com>
References: <20210825161815.266051-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

For non-VHE systems, make the SPE register state part of the context that
is saved and restored at each world switch. The SPE buffer management
interrupt will be handled in a later patch.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h        | 19 ++++++
 arch/arm64/kvm/hyp/include/hyp/spe-sr.h | 32 +++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile        |  1 +
 arch/arm64/kvm/hyp/nvhe/debug-sr.c      |  6 +-
 arch/arm64/kvm/hyp/nvhe/spe-sr.c        | 87 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        | 29 +++++++--
 6 files changed, 165 insertions(+), 9 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/spe-sr.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/spe-sr.c

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 48619c2c0dc6..06e77a739458 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -88,6 +88,25 @@ void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu,
 				    struct kvm_cpu_context *host_ctxt);
 void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu,
 				       struct kvm_cpu_context *host_ctxt);
+#ifdef CONFIG_KVM_ARM_SPE
+void __spe_save_host_state_nvhe(struct kvm_vcpu *vcpu,
+				struct kvm_cpu_context *host_ctxt);
+void __spe_save_guest_state_nvhe(struct kvm_vcpu *vcpu,
+				 struct kvm_cpu_context *guest_ctxt);
+void __spe_restore_host_state_nvhe(struct kvm_vcpu *vcpu,
+				   struct kvm_cpu_context *host_ctxt);
+void __spe_restore_guest_state_nvhe(struct kvm_vcpu *vcpu,
+				    struct kvm_cpu_context *guest_ctxt);
+#else
+static inline void __spe_save_host_state_nvhe(struct kvm_vcpu *vcpu,
+					struct kvm_cpu_context *host_ctxt) {}
+static inline void __spe_save_guest_state_nvhe(struct kvm_vcpu *vcpu,
+					struct kvm_cpu_context *guest_ctxt) {}
+static inline void __spe_restore_host_state_nvhe(struct kvm_vcpu *vcpu,
+					struct kvm_cpu_context *host_ctxt) {}
+static inline void __spe_restore_guest_state_nvhe(struct kvm_vcpu *vcpu,
+					struct kvm_cpu_context *guest_ctxt) {}
+#endif
 #endif
 
 void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
diff --git a/arch/arm64/kvm/hyp/include/hyp/spe-sr.h b/arch/arm64/kvm/hyp/include/hyp/spe-sr.h
new file mode 100644
index 000000000000..d5f8f3ffc7d4
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/hyp/spe-sr.h
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021 - ARM Ltd
+ * Author: Alexandru Elisei <alexandru.elisei@arm.com>
+ */
+
+#ifndef __ARM64_KVM_HYP_SPE_SR_H__
+#define __ARM64_KVM_HYP_SPE_SR_H__
+
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_asm.h>
+
+static inline void __spe_save_common_state(struct kvm_cpu_context *ctxt)
+{
+	ctxt_sys_reg(ctxt, PMSICR_EL1) = read_sysreg_s(SYS_PMSICR_EL1);
+	ctxt_sys_reg(ctxt, PMSIRR_EL1) = read_sysreg_s(SYS_PMSIRR_EL1);
+	ctxt_sys_reg(ctxt, PMSFCR_EL1) = read_sysreg_s(SYS_PMSFCR_EL1);
+	ctxt_sys_reg(ctxt, PMSEVFR_EL1) = read_sysreg_s(SYS_PMSEVFR_EL1);
+	ctxt_sys_reg(ctxt, PMSLATFR_EL1) = read_sysreg_s(SYS_PMSLATFR_EL1);
+}
+
+static inline void __spe_restore_common_state(struct kvm_cpu_context *ctxt)
+{
+	write_sysreg_s(ctxt_sys_reg(ctxt, PMSICR_EL1), SYS_PMSICR_EL1);
+	write_sysreg_s(ctxt_sys_reg(ctxt, PMSIRR_EL1), SYS_PMSIRR_EL1);
+	write_sysreg_s(ctxt_sys_reg(ctxt, PMSFCR_EL1), SYS_PMSFCR_EL1);
+	write_sysreg_s(ctxt_sys_reg(ctxt, PMSEVFR_EL1), SYS_PMSEVFR_EL1);
+	write_sysreg_s(ctxt_sys_reg(ctxt, PMSLATFR_EL1), SYS_PMSLATFR_EL1);
+}
+
+#endif /* __ARM64_KVM_HYP_SPE_SR_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 5df6193fc430..37dca45d85d5 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -15,6 +15,7 @@ lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o page_alloc.o \
 	 cache.o setup.o mm.o mem_protect.o
+obj-$(CONFIG_KVM_ARM_SPE) += spe-sr.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 obj-y += $(lib-objs)
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 186b90b5fd20..1622615954b2 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -85,7 +85,8 @@ void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu,
 				    struct kvm_cpu_context *host_ctxt)
 {
 	/* Disable and flush SPE data generation */
-	if (vcpu->arch.flags & KVM_ARM64_DEBUG_SAVE_SPE_BUFFER)
+	if (!kvm_vcpu_has_spe(vcpu) &&
+	    vcpu->arch.flags & KVM_ARM64_DEBUG_SAVE_SPE_BUFFER)
 		__debug_save_spe(__ctxt_sys_reg(host_ctxt, PMSCR_EL1));
 	/* Disable and flush Self-Hosted Trace generation */
 	if (vcpu->arch.flags & KVM_ARM64_DEBUG_SAVE_TRBE_BUFFER)
@@ -100,7 +101,8 @@ void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu,
 				       struct kvm_cpu_context *host_ctxt)
 {
-	if (vcpu->arch.flags & KVM_ARM64_DEBUG_SAVE_SPE_BUFFER)
+	if (!kvm_vcpu_has_spe(vcpu) &&
+	    vcpu->arch.flags & KVM_ARM64_DEBUG_SAVE_SPE_BUFFER)
 		__debug_restore_spe(ctxt_sys_reg(host_ctxt, PMSCR_EL1));
 	if (vcpu->arch.flags & KVM_ARM64_DEBUG_SAVE_TRBE_BUFFER)
 		__debug_restore_trace(vcpu->arch.host_debug_state.trfcr_el1);
diff --git a/arch/arm64/kvm/hyp/nvhe/spe-sr.c b/arch/arm64/kvm/hyp/nvhe/spe-sr.c
new file mode 100644
index 000000000000..46e47c9fd08f
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/spe-sr.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021 - ARM Ltd
+ * Author: Alexandru Elisei <alexandru.elisei@arm.com>
+ */
+
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_hyp.h>
+
+#include <hyp/spe-sr.h>
+
+/*
+ * The owning exception level remains unchange from EL1 during the world switch,
+ * which means that profiling is disabled for as long as we execute at EL2. KVM
+ * does not need to explicitely disable profiling, like it does when the VCPU
+ * does not have SPE and we change buffer owning exception level, nor does it
+ * need to do any synchronization around sysreg save/restore.
+ */
+
+void __spe_save_host_state_nvhe(struct kvm_vcpu *vcpu,
+				struct kvm_cpu_context *host_ctxt)
+{
+	u64 pmblimitr;
+
+	pmblimitr = read_sysreg_s(SYS_PMBLIMITR_EL1);
+	if (pmblimitr & BIT(SYS_PMBLIMITR_EL1_E_SHIFT)) {
+		psb_csync();
+		dsb(nsh);
+		/*
+		 * The buffer performs indirect writes to system registers, a
+		 * context synchronization event is needed before the new
+		 * PMBPTR_EL1 value is visible to subsequent direct reads.
+		 */
+		isb();
+	}
+
+	ctxt_sys_reg(host_ctxt, PMBPTR_EL1) = read_sysreg_s(SYS_PMBPTR_EL1);
+	ctxt_sys_reg(host_ctxt, PMBSR_EL1) = read_sysreg_s(SYS_PMBSR_EL1);
+	ctxt_sys_reg(host_ctxt, PMBLIMITR_EL1) = pmblimitr;
+	ctxt_sys_reg(host_ctxt, PMSCR_EL1) = read_sysreg_s(SYS_PMSCR_EL1);
+	ctxt_sys_reg(host_ctxt, PMSCR_EL2) = read_sysreg_el2(SYS_PMSCR);
+
+	__spe_save_common_state(host_ctxt);
+}
+
+void __spe_save_guest_state_nvhe(struct kvm_vcpu *vcpu,
+				 struct kvm_cpu_context *guest_ctxt)
+{
+	if (read_sysreg_s(SYS_PMBLIMITR_EL1) & BIT(SYS_PMBLIMITR_EL1_E_SHIFT)) {
+		psb_csync();
+		dsb(nsh);
+		/* Ensure hardware updates to PMBPTR_EL1 are visible. */
+		isb();
+	}
+
+	ctxt_sys_reg(guest_ctxt, PMBPTR_EL1) = read_sysreg_s(SYS_PMBPTR_EL1);
+	ctxt_sys_reg(guest_ctxt, PMBSR_EL1) = read_sysreg_s(SYS_PMBSR_EL1);
+	/* PMBLIMITR_EL1 is updated only on a trapped write. */
+	ctxt_sys_reg(guest_ctxt, PMSCR_EL1) = read_sysreg_s(SYS_PMSCR_EL1);
+
+	__spe_save_common_state(guest_ctxt);
+}
+
+void __spe_restore_host_state_nvhe(struct kvm_vcpu *vcpu,
+				   struct kvm_cpu_context *host_ctxt)
+{
+	__spe_restore_common_state(host_ctxt);
+
+	write_sysreg_s(ctxt_sys_reg(host_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
+	write_sysreg_s(ctxt_sys_reg(host_ctxt, PMBSR_EL1), SYS_PMBSR_EL1);
+	write_sysreg_s(ctxt_sys_reg(host_ctxt, PMBLIMITR_EL1), SYS_PMBLIMITR_EL1);
+	write_sysreg_s(ctxt_sys_reg(host_ctxt, PMSCR_EL1), SYS_PMSCR_EL1);
+	write_sysreg_el2(ctxt_sys_reg(host_ctxt, PMSCR_EL2), SYS_PMSCR);
+}
+
+void __spe_restore_guest_state_nvhe(struct kvm_vcpu *vcpu,
+				    struct kvm_cpu_context *guest_ctxt)
+{
+	__spe_restore_common_state(guest_ctxt);
+
+	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
+	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBSR_EL1), SYS_PMBSR_EL1);
+	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBLIMITR_EL1), SYS_PMBLIMITR_EL1);
+	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMSCR_EL1), SYS_PMSCR_EL1);
+	write_sysreg_el2(0, SYS_PMSCR);
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 04d654e71a6e..62ef2a5789ba 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -194,12 +194,16 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	__sysreg_save_state_nvhe(host_ctxt);
 	/*
-	 * We must flush and disable the SPE buffer for nVHE, as
-	 * the translation regime(EL1&0) is going to be loaded with
-	 * that of the guest. And we must do this before we change the
-	 * translation regime to EL2 (via MDCR_EL2_E2PB == 0) and
-	 * before we load guest Stage1.
+	 * If the VCPU has the SPE feature bit set, then we save the host's SPE
+	 * context.
+	 *
+	 * Otherwise, we only flush and disable the SPE buffer for nVHE, as the
+	 * translation regime(EL1&0) is going to be loaded with that of the
+	 * guest. And we must do this before we change the translation regime to
+	 * EL2 (via MDCR_EL2_E2PB == 0) and before we load guest Stage1.
 	 */
+	if (kvm_vcpu_has_spe(vcpu))
+		__spe_save_host_state_nvhe(vcpu, host_ctxt);
 	__debug_save_host_buffers_nvhe(vcpu, host_ctxt);
 
 	__kvm_adjust_pc(vcpu);
@@ -218,6 +222,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__load_guest_stage2(kern_hyp_va(vcpu->arch.hw_mmu));
 	__activate_traps(vcpu);
 
+	if (kvm_vcpu_has_spe(vcpu))
+		__spe_restore_guest_state_nvhe(vcpu, guest_ctxt);
+
 	__hyp_vgic_restore_state(vcpu);
 	__timer_enable_traps(vcpu);
 
@@ -232,6 +239,10 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	__sysreg_save_state_nvhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
+
+	if (kvm_vcpu_has_spe(vcpu))
+		__spe_save_guest_state_nvhe(vcpu, guest_ctxt);
+
 	__timer_disable_traps(vcpu);
 	__hyp_vgic_save_state(vcpu);
 
@@ -244,10 +255,14 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		__fpsimd_save_fpexc32(vcpu);
 
 	__debug_switch_to_host(vcpu);
+
 	/*
-	 * This must come after restoring the host sysregs, since a non-VHE
-	 * system may enable SPE here and make use of the TTBRs.
+	 * Restoring the host context must come after restoring the host
+	 * sysregs, since a non-VHE system may enable SPE here and make use of
+	 * the TTBRs.
 	 */
+	if (kvm_vcpu_has_spe(vcpu))
+		__spe_restore_host_state_nvhe(vcpu, host_ctxt);
 	__debug_restore_host_buffers_nvhe(vcpu, host_ctxt);
 
 	if (pmu_switch_needed)
-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
