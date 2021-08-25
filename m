Return-Path: <SRS0=u4Cy=NQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A763C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:19:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D310E6115A
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:19:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D310E6115A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 89C4F49E93;
	Wed, 25 Aug 2021 12:19:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hlq8PwqdBO-Z; Wed, 25 Aug 2021 12:19:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A193F4B2EA;
	Wed, 25 Aug 2021 12:18:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 666C340291
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:18:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jG6CDfvUUvoC for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Aug 2021 12:18:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A91424B21E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:18:02 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 76C01D6E;
 Wed, 25 Aug 2021 09:18:02 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2524D3F66F;
 Wed, 25 Aug 2021 09:18:01 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 31/39] KVM: arm64: VHE: Context switch SPE state if
 VCPU has SPE
Date: Wed, 25 Aug 2021 17:18:07 +0100
Message-Id: <20210825161815.266051-32-alexandru.elisei@arm.com>
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

Similar to the non-VHE case, save and restore the SPE register state at
each world switch for VHE enabled systems if the VCPU has the SPE
feature.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h |  24 +++++-
 arch/arm64/include/asm/sysreg.h  |   2 +
 arch/arm64/kvm/hyp/vhe/Makefile  |   1 +
 arch/arm64/kvm/hyp/vhe/spe-sr.c  | 128 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c  |   8 ++
 5 files changed, 161 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/vhe/spe-sr.c

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 06e77a739458..03bc51049996 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -106,8 +106,28 @@ static inline void __spe_restore_host_state_nvhe(struct kvm_vcpu *vcpu,
 					struct kvm_cpu_context *host_ctxt) {}
 static inline void __spe_restore_guest_state_nvhe(struct kvm_vcpu *vcpu,
 					struct kvm_cpu_context *guest_ctxt) {}
-#endif
-#endif
+#endif /* CONFIG_KVM_ARM_SPE */
+#else
+#ifdef CONFIG_KVM_ARM_SPE
+void __spe_save_host_state_vhe(struct kvm_vcpu *vcpu,
+			       struct kvm_cpu_context *host_ctxt);
+void __spe_save_guest_state_vhe(struct kvm_vcpu *vcpu,
+				struct kvm_cpu_context *guest_ctxt);
+void __spe_restore_host_state_vhe(struct kvm_vcpu *vcpu,
+				  struct kvm_cpu_context *host_ctxt);
+void __spe_restore_guest_state_vhe(struct kvm_vcpu *vcpu,
+				   struct kvm_cpu_context *guest_ctxt);
+#else
+static inline void __spe_save_host_state_vhe(struct kvm_vcpu *vcpu,
+					struct kvm_cpu_context *host_ctxt) {}
+static inline void __spe_save_guest_state_vhe(struct kvm_vcpu *vcpu,
+					struct kvm_cpu_context *guest_ctxt) {}
+static inline void __spe_restore_host_state_vhe(struct kvm_vcpu *vcpu,
+					struct kvm_cpu_context *host_ctxt) {}
+static inline void __spe_restore_guest_state_vhe(struct kvm_vcpu *vcpu,
+					struct kvm_cpu_context *guest_ctxt) {}
+#endif /* CONFIG_KVM_ARM_SPE */
+#endif /* __KVM_NVHE_HYPERVISOR__ */
 
 void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 7b9c3acba684..b2d691bc1049 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -267,6 +267,8 @@
 #define SYS_PMSCR_EL1_TS_SHIFT		5
 #define SYS_PMSCR_EL1_PCT_SHIFT		6
 
+#define SYS_PMSCR_EL12			sys_reg(3, 5, 9, 9, 0)
+
 #define SYS_PMSCR_EL2			sys_reg(3, 4, 9, 9, 0)
 #define SYS_PMSCR_EL2_E0HSPE_SHIFT	0
 #define SYS_PMSCR_EL2_E2SPE_SHIFT	1
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makefile
index 96bec0ecf9dd..7cb4a9e5ceb0 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -7,5 +7,6 @@ asflags-y := -D__KVM_VHE_HYPERVISOR__
 ccflags-y := -D__KVM_VHE_HYPERVISOR__
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o
+obj-$(CONFIG_KVM_ARM_SPE) += spe-sr.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o
diff --git a/arch/arm64/kvm/hyp/vhe/spe-sr.c b/arch/arm64/kvm/hyp/vhe/spe-sr.c
new file mode 100644
index 000000000000..00eab9e2ec60
--- /dev/null
+++ b/arch/arm64/kvm/hyp/vhe/spe-sr.c
@@ -0,0 +1,128 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021 - ARM Ltd
+ */
+
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_hyp.h>
+#include <asm/kprobes.h>
+
+#include <hyp/spe-sr.h>
+
+/*
+ * Disable host profiling, drain the buffer and save the host SPE context.
+ * Extra care must be taken because profiling might be in progress.
+ */
+void __spe_save_host_state_vhe(struct kvm_vcpu *vcpu,
+			       struct kvm_cpu_context *host_ctxt)
+{
+	u64 pmblimitr, pmscr_el2;
+
+	/* Disable profiling while the SPE context is being switched. */
+	pmscr_el2 = read_sysreg_el2(SYS_PMSCR);
+	write_sysreg_el2(0, SYS_PMSCR);
+	isb();
+
+	pmblimitr = read_sysreg_s(SYS_PMBLIMITR_EL1);
+	if (pmblimitr & BIT(SYS_PMBLIMITR_EL1_E_SHIFT)) {
+		psb_csync();
+		dsb(nsh);
+		/* Ensure hardware updates to PMBPTR_EL1 are visible. */
+		isb();
+	}
+
+	ctxt_sys_reg(host_ctxt, PMBPTR_EL1) = read_sysreg_s(SYS_PMBPTR_EL1);
+	ctxt_sys_reg(host_ctxt, PMBSR_EL1) = read_sysreg_s(SYS_PMBSR_EL1);
+	ctxt_sys_reg(host_ctxt, PMBLIMITR_EL1) = pmblimitr;
+	ctxt_sys_reg(host_ctxt, PMSCR_EL2) = pmscr_el2;
+
+	__spe_save_common_state(host_ctxt);
+}
+NOKPROBE_SYMBOL(__spe_save_host_state_vhe);
+
+/*
+ * Drain the guest's buffer and save the SPE state. Profiling is disabled
+ * because we're at EL2 and the buffer owning exceptions level is EL1.
+ */
+void __spe_save_guest_state_vhe(struct kvm_vcpu *vcpu,
+				struct kvm_cpu_context *guest_ctxt)
+{
+	u64 pmblimitr;
+
+	/*
+	 * We're at EL2 and the buffer owning regime is EL1, which means that
+	 * profiling is disabled. After we disable traps and restore the host's
+	 * MDCR_EL2, profiling will remain disabled because we've disabled it
+	 * via PMSCR_EL2 when we saved the host's SPE state. All it's needed
+	 * here is to drain the buffer.
+	 */
+	pmblimitr = read_sysreg_s(SYS_PMBLIMITR_EL1);
+	if (pmblimitr & BIT(SYS_PMBLIMITR_EL1_E_SHIFT)) {
+		psb_csync();
+		dsb(nsh);
+		/* Ensure hardware updates to PMBPTR_EL1 are visible. */
+		isb();
+	}
+
+	ctxt_sys_reg(guest_ctxt, PMBPTR_EL1) = read_sysreg_s(SYS_PMBPTR_EL1);
+	ctxt_sys_reg(guest_ctxt, PMBSR_EL1) = read_sysreg_s(SYS_PMBSR_EL1);
+	/* PMBLIMITR_EL1 is updated only on a trapped write. */
+	ctxt_sys_reg(guest_ctxt, PMSCR_EL1) = read_sysreg_el1(SYS_PMSCR);
+
+	__spe_save_common_state(guest_ctxt);
+}
+NOKPROBE_SYMBOL(__spe_save_guest_state_vhe);
+
+/*
+ * Restore the host SPE context. Special care must be taken because we're
+ * potentially resuming a profiling session which was stopped when we saved the
+ * host SPE register state.
+ */
+void __spe_restore_host_state_vhe(struct kvm_vcpu *vcpu,
+				  struct kvm_cpu_context *host_ctxt)
+{
+	__spe_restore_common_state(host_ctxt);
+
+	write_sysreg_s(ctxt_sys_reg(host_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
+	write_sysreg_s(ctxt_sys_reg(host_ctxt, PMBLIMITR_EL1), SYS_PMBLIMITR_EL1);
+	write_sysreg_s(ctxt_sys_reg(host_ctxt, PMBSR_EL1), SYS_PMBSR_EL1);
+
+	/*
+	 * Make sure buffer pointer and limit is updated first, so we don't end
+	 * up in a situation where profiling is enabled and the buffer uses the
+	 * values programmed by the guest.
+	 *
+	 * This also serves to make sure the write to MDCR_EL2 which changes the
+	 * buffer owning Exception level is visible.
+	 *
+	 * After the synchronization, profiling is still disabled at EL2,
+	 * because we cleared PMSCR_EL2 when we saved the host context.
+	 */
+	isb();
+
+	write_sysreg_el2(ctxt_sys_reg(host_ctxt, PMSCR_EL2), SYS_PMSCR);
+}
+NOKPROBE_SYMBOL(__spe_restore_host_state_vhe);
+
+/*
+ * Restore the guest SPE context while profiling is disabled at EL2.
+ */
+void __spe_restore_guest_state_vhe(struct kvm_vcpu *vcpu,
+				   struct kvm_cpu_context *guest_ctxt)
+{
+	__spe_restore_common_state(guest_ctxt);
+
+	/*
+	 * No synchronization needed here. Profiling is disabled at EL2 because
+	 * PMSCR_EL2 has been cleared when saving the host's context, and the
+	 * buffer has already been drained.
+	 */
+
+	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
+	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBSR_EL1), SYS_PMBSR_EL1);
+	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBLIMITR_EL1), SYS_PMBLIMITR_EL1);
+	write_sysreg_el1(ctxt_sys_reg(guest_ctxt, PMSCR_EL1), SYS_PMSCR);
+	/* PMSCR_EL2 has been cleared when saving the host state. */
+}
+NOKPROBE_SYMBOL(__spe_restore_guest_state_vhe);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index ec4e179d56ae..46da018f4a5a 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -135,6 +135,8 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	guest_ctxt = &vcpu->arch.ctxt;
 
 	sysreg_save_host_state_vhe(host_ctxt);
+	if (kvm_vcpu_has_spe(vcpu))
+		__spe_save_host_state_vhe(vcpu, host_ctxt);
 
 	/*
 	 * ARM erratum 1165522 requires us to configure both stage 1 and
@@ -153,6 +155,8 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	__kvm_adjust_pc(vcpu);
 
 	sysreg_restore_guest_state_vhe(guest_ctxt);
+	if (kvm_vcpu_has_spe(vcpu))
+		__spe_restore_guest_state_vhe(vcpu, guest_ctxt);
 	__debug_switch_to_guest(vcpu);
 
 	do {
@@ -163,10 +167,14 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
 	sysreg_save_guest_state_vhe(guest_ctxt);
+	if (kvm_vcpu_has_spe(vcpu))
+		__spe_save_guest_state_vhe(vcpu, guest_ctxt);
 
 	__deactivate_traps(vcpu);
 
 	sysreg_restore_host_state_vhe(host_ctxt);
+	if (kvm_vcpu_has_spe(vcpu))
+		__spe_restore_host_state_vhe(vcpu, host_ctxt);
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
 		__fpsimd_save_fpexc32(vcpu);
-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
