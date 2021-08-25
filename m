Return-Path: <SRS0=u4Cy=NQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD312C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:20:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 531A66115A
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:20:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 531A66115A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 076094B2A5;
	Wed, 25 Aug 2021 12:20:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h4LWPBPlTBfT; Wed, 25 Aug 2021 12:20:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2497C4B2F7;
	Wed, 25 Aug 2021 12:19:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0F0A4B2A2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:18:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rtv7Wyh5JqsK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Aug 2021 12:18:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AAE274B2CE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:18:10 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A5391480;
 Wed, 25 Aug 2021 09:18:10 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2AD273F66F;
 Wed, 25 Aug 2021 09:18:09 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 36/39] KVM: arm64: Implement userspace API to stop a
 VCPU profiling
Date: Wed, 25 Aug 2021 17:18:12 +0100
Message-Id: <20210825161815.266051-37-alexandru.elisei@arm.com>
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

When userspace requests that a VCPU is not allowed to profile anymore via the
KVM_ARM_VCPU_SPE_STOP attribute, keep all the register state in memory and
trap all registers, not just the buffer registers, and don't copy any of
this shadow state on the hardware.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h   |  2 +
 arch/arm64/include/asm/kvm_spe.h   | 14 +++++++
 arch/arm64/include/uapi/asm/kvm.h  |  3 ++
 arch/arm64/kvm/arm.c               |  9 ++++
 arch/arm64/kvm/debug.c             | 13 ++++--
 arch/arm64/kvm/hyp/nvhe/debug-sr.c |  4 +-
 arch/arm64/kvm/hyp/nvhe/spe-sr.c   | 24 +++++++++++
 arch/arm64/kvm/hyp/vhe/spe-sr.c    | 56 +++++++++++++++++++++++++
 arch/arm64/kvm/spe.c               | 67 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c          |  2 +-
 10 files changed, 188 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 03bc51049996..ce365427b483 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -86,8 +86,10 @@ void __debug_switch_to_host(struct kvm_vcpu *vcpu);
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu,
 				    struct kvm_cpu_context *host_ctxt);
+void __debug_save_spe(u64 *pmscr_el1);
 void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu,
 				       struct kvm_cpu_context *host_ctxt);
+void __debug_restore_spe(u64 pmscr_el1);
 #ifdef CONFIG_KVM_ARM_SPE
 void __spe_save_host_state_nvhe(struct kvm_vcpu *vcpu,
 				struct kvm_cpu_context *host_ctxt);
diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index d7d7b9e243de..f51561e3b43f 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -16,13 +16,23 @@ static __always_inline bool kvm_supports_spe(void)
 	return static_branch_likely(&kvm_spe_available);
 }
 
+/* Guest profiling disabled by the user. */
+#define KVM_VCPU_SPE_STOP_USER		(1 << 0)
+/* Stop profiling and exit to userspace when guest starts profiling. */
+#define KVM_VCPU_SPE_STOP_USER_EXIT	(1 << 1)
+
 struct kvm_vcpu_spe {
 	bool initialized;	/* SPE initialized for the VCPU */
 	int irq_num;		/* Buffer management interrut number */
 	bool irq_level;		/* 'true' if the interrupt is asserted at the VGIC */
 	bool hwirq_level;	/* 'true' if the SPE hardware is asserting the interrupt */
+	u64 flags;
 };
 
+#define kvm_spe_profiling_stopped(vcpu)					\
+	(((vcpu)->arch.spe.flags & KVM_VCPU_SPE_STOP_USER) ||		\
+	 ((vcpu)->arch.spe.flags & KVM_VCPU_SPE_STOP_USER_EXIT))	\
+
 struct kvm_spe {
 	bool perfmon_capable;	/* Is the VM perfmon_capable()? */
 };
@@ -31,6 +41,7 @@ void kvm_spe_init_supported_cpus(void);
 void kvm_spe_vm_init(struct kvm *kvm);
 int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu);
 void kvm_spe_sync_hwstate(struct kvm_vcpu *vcpu);
+bool kvm_spe_exit_to_user(struct kvm_vcpu *vcpu);
 
 void kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val);
 u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg);
@@ -48,6 +59,8 @@ int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 struct kvm_vcpu_spe {
 };
 
+#define kvm_spe_profiling_stopped(vcpu)		(false)
+
 struct kvm_spe {
 };
 
@@ -55,6 +68,7 @@ static inline void kvm_spe_init_supported_cpus(void) {}
 static inline void kvm_spe_vm_init(struct kvm *kvm) {}
 static inline int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu) { return -ENOEXEC; }
 static inline void kvm_spe_sync_hwstate(struct kvm_vcpu *vcpu) {}
+static inline bool kvm_spe_exit_to_user(struct kvm_vcpu *vcpu) { return false; }
 
 static inline void kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val) {}
 static inline u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg) { return 0; }
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 75a5113f610e..63599ee39a7b 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -376,6 +376,9 @@ struct kvm_arm_copy_mte_tags {
 #define     KVM_ARM_VCPU_SPE_STOP_EXIT		(1 << 1)
 #define     KVM_ARM_VCPU_SPE_RESUME		(1 << 2)
 
+/* run->fail_entry.hardware_entry_failure_reason codes. */
+#define KVM_EXIT_FAIL_ENTRY_SPE		(1 << 0)
+
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_VCPU2_SHIFT		28
 #define KVM_ARM_IRQ_VCPU2_MASK		0xf
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ec449bc5f811..b7aae25bb9da 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -873,6 +873,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			continue;
 		}
 
+		if (unlikely(kvm_spe_exit_to_user(vcpu))) {
+			run->exit_reason = KVM_EXIT_FAIL_ENTRY;
+			run->fail_entry.hardware_entry_failure_reason
+				= KVM_EXIT_FAIL_ENTRY_SPE;
+			ret = -EAGAIN;
+			preempt_enable();
+			continue;
+		}
+
 		kvm_pmu_flush_hwstate(vcpu);
 
 		local_irq_disable();
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 6e5fc1887215..6a4277a23bbb 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -96,11 +96,18 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 	if (kvm_supports_spe() && kvm_vcpu_has_spe(vcpu)) {
 		/*
 		 * Use EL1&0 for the profiling buffer translation regime and
-		 * trap accesses to the buffer control registers; leave
-		 * MDCR_EL2.TPMS unset and do not trap accesses to the profiling
-		 * control registers.
+		 * trap accesses to the buffer control registers; if profiling
+		 * is stopped, also set MSCR_EL2.TMPS to trap accesses to the
+		 * rest of the registers, otherwise leave it clear.
+		 *
+		 * Leaving MDCR_EL2.E2P unset, like we do when the VCPU does not
+		 * have SPE, means that the PMBIDR_EL1.P (which KVM does not
+		 * trap) will be set and the guest will detect SPE as being
+		 * unavailable.
 		 */
 		vcpu->arch.mdcr_el2 |= MDCR_EL2_E2PB_EL1_TRAP << MDCR_EL2_E2PB_SHIFT;
+		if (kvm_spe_profiling_stopped(vcpu))
+			vcpu->arch.mdcr_el2 |= MDCR_EL2_TPMS;
 	} else {
 		/*
 		 * Trap accesses to the profiling control registers; leave
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 1622615954b2..944972de0944 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -14,7 +14,7 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
-static void __debug_save_spe(u64 *pmscr_el1)
+void __debug_save_spe(u64 *pmscr_el1)
 {
 	u64 reg;
 
@@ -40,7 +40,7 @@ static void __debug_save_spe(u64 *pmscr_el1)
 	dsb(nsh);
 }
 
-static void __debug_restore_spe(u64 pmscr_el1)
+void __debug_restore_spe(u64 pmscr_el1)
 {
 	if (!pmscr_el1)
 		return;
diff --git a/arch/arm64/kvm/hyp/nvhe/spe-sr.c b/arch/arm64/kvm/hyp/nvhe/spe-sr.c
index b74131486a75..8ed03aa4f965 100644
--- a/arch/arm64/kvm/hyp/nvhe/spe-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/spe-sr.c
@@ -23,6 +23,11 @@ void __spe_save_host_state_nvhe(struct kvm_vcpu *vcpu,
 {
 	u64 pmblimitr;
 
+	if (kvm_spe_profiling_stopped(vcpu)) {
+		__debug_save_spe(__ctxt_sys_reg(host_ctxt, PMSCR_EL1));
+		return;
+	}
+
 	pmblimitr = read_sysreg_s(SYS_PMBLIMITR_EL1);
 	if (pmblimitr & BIT(SYS_PMBLIMITR_EL1_E_SHIFT)) {
 		psb_csync();
@@ -49,6 +54,13 @@ void __spe_save_guest_state_nvhe(struct kvm_vcpu *vcpu,
 {
 	u64 pmbsr;
 
+	/*
+	 * Profiling is stopped and all register accesses are trapped, nothing
+	 * to save here.
+	 */
+	if (kvm_spe_profiling_stopped(vcpu))
+		return;
+
 	if (read_sysreg_s(SYS_PMBLIMITR_EL1) & BIT(SYS_PMBLIMITR_EL1_E_SHIFT)) {
 		psb_csync();
 		dsb(nsh);
@@ -82,6 +94,11 @@ void __spe_save_guest_state_nvhe(struct kvm_vcpu *vcpu,
 void __spe_restore_host_state_nvhe(struct kvm_vcpu *vcpu,
 				   struct kvm_cpu_context *host_ctxt)
 {
+	if (kvm_spe_profiling_stopped(vcpu)) {
+		__debug_restore_spe(ctxt_sys_reg(host_ctxt, PMSCR_EL1));
+		return;
+	}
+
 	__spe_restore_common_state(host_ctxt);
 
 	write_sysreg_s(ctxt_sys_reg(host_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
@@ -94,6 +111,13 @@ void __spe_restore_host_state_nvhe(struct kvm_vcpu *vcpu,
 void __spe_restore_guest_state_nvhe(struct kvm_vcpu *vcpu,
 				    struct kvm_cpu_context *guest_ctxt)
 {
+	/*
+	 * Profiling is stopped and all register accesses are trapped, nothing
+	 * to restore here.
+	 */
+	if (kvm_spe_profiling_stopped(vcpu))
+		return;
+
 	__spe_restore_common_state(guest_ctxt);
 
 	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
diff --git a/arch/arm64/kvm/hyp/vhe/spe-sr.c b/arch/arm64/kvm/hyp/vhe/spe-sr.c
index ea4b3b69bb32..024a4c0618cc 100644
--- a/arch/arm64/kvm/hyp/vhe/spe-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/spe-sr.c
@@ -10,6 +10,34 @@
 
 #include <hyp/spe-sr.h>
 
+static void __spe_save_host_buffer(u64 *pmscr_el2)
+{
+	u64 pmblimitr;
+
+	/* Disable guest profiling. */
+	write_sysreg_el1(0, SYS_PMSCR);
+
+	pmblimitr = read_sysreg_s(SYS_PMBLIMITR_EL1);
+	if (!(pmblimitr & BIT(SYS_PMBLIMITR_EL1_E_SHIFT))) {
+		*pmscr_el2 = 0;
+		return;
+	}
+
+	*pmscr_el2 = read_sysreg_el2(SYS_PMSCR);
+
+	/* Disable profiling at EL2 so we can drain the buffer. */
+	write_sysreg_el2(0, SYS_PMSCR);
+	isb();
+
+	/*
+	 * We're going to change the buffer owning exception level when we
+	 * activate traps, drain the buffer now.
+	 */
+	psb_csync();
+	dsb(nsh);
+}
+NOKPROBE_SYMBOL(__spe_save_host_buffer);
+
 /*
  * Disable host profiling, drain the buffer and save the host SPE context.
  * Extra care must be taken because profiling might be in progress.
@@ -19,6 +47,11 @@ void __spe_save_host_state_vhe(struct kvm_vcpu *vcpu,
 {
 	u64 pmblimitr, pmscr_el2;
 
+	if (kvm_spe_profiling_stopped(vcpu)) {
+		__spe_save_host_buffer(__ctxt_sys_reg(host_ctxt, PMSCR_EL2));
+		return;
+	}
+
 	/* Disable profiling while the SPE context is being switched. */
 	pmscr_el2 = read_sysreg_el2(SYS_PMSCR);
 	write_sysreg_el2(__vcpu_sys_reg(vcpu, PMSCR_EL2), SYS_PMSCR);
@@ -50,6 +83,9 @@ void __spe_save_guest_state_vhe(struct kvm_vcpu *vcpu,
 {
 	u64 pmblimitr, pmbsr;
 
+	if (kvm_spe_profiling_stopped(vcpu))
+		return;
+
 	/*
 	 * We're at EL2 and the buffer owning regime is EL1, which means that
 	 * profiling is disabled. After we disable traps and restore the host's
@@ -78,6 +114,18 @@ void __spe_save_guest_state_vhe(struct kvm_vcpu *vcpu,
 }
 NOKPROBE_SYMBOL(__spe_save_guest_state_vhe);
 
+static void __spe_restore_host_buffer(u64 pmscr_el2)
+{
+	if (!pmscr_el2)
+		return;
+
+	/* Synchronize MDCR_EL2 write. */
+	isb();
+
+	write_sysreg_el2(pmscr_el2, SYS_PMSCR);
+}
+NOKPROBE_SYMBOL(__spe_restore_host_buffer);
+
 /*
  * Restore the host SPE context. Special care must be taken because we're
  * potentially resuming a profiling session which was stopped when we saved the
@@ -86,6 +134,11 @@ NOKPROBE_SYMBOL(__spe_save_guest_state_vhe);
 void __spe_restore_host_state_vhe(struct kvm_vcpu *vcpu,
 				  struct kvm_cpu_context *host_ctxt)
 {
+	if (kvm_spe_profiling_stopped(vcpu)) {
+		__spe_restore_host_buffer(ctxt_sys_reg(host_ctxt, PMSCR_EL2));
+		return;
+	}
+
 	__spe_restore_common_state(host_ctxt);
 
 	write_sysreg_s(ctxt_sys_reg(host_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
@@ -115,6 +168,9 @@ NOKPROBE_SYMBOL(__spe_restore_host_state_vhe);
 void __spe_restore_guest_state_vhe(struct kvm_vcpu *vcpu,
 				   struct kvm_cpu_context *guest_ctxt)
 {
+	if (kvm_spe_profiling_stopped(vcpu))
+		return;
+
 	__spe_restore_common_state(guest_ctxt);
 
 	/*
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 2630e777fe1d..69ca731ba9d3 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -140,6 +140,28 @@ void kvm_spe_sync_hwstate(struct kvm_vcpu *vcpu)
 	kvm_spe_update_irq(vcpu, true);
 }
 
+static bool kvm_spe_buffer_enabled(struct kvm_vcpu *vcpu)
+{
+	return !vcpu->arch.spe.irq_level  &&
+		(__vcpu_sys_reg(vcpu, PMBLIMITR_EL1) & BIT(SYS_PMBLIMITR_EL1_E_SHIFT));
+}
+
+bool kvm_spe_exit_to_user(struct kvm_vcpu *vcpu)
+{
+	u64 pmscr_enabled_mask = BIT(SYS_PMSCR_EL1_E0SPE_SHIFT) |
+				 BIT(SYS_PMSCR_EL1_E1SPE_SHIFT);
+
+	if (!(vcpu->arch.spe.flags & KVM_VCPU_SPE_STOP_USER_EXIT))
+		return false;
+
+	/*
+	 * We don't trap the guest dropping to EL0, so exit even if profiling is
+	 * disabled at EL1, but enabled at EL0.
+	 */
+	return kvm_spe_buffer_enabled(vcpu) &&
+		(__vcpu_sys_reg(vcpu, PMSCR_EL1) & pmscr_enabled_mask);
+}
+
 void kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
 {
 	__vcpu_sys_reg(vcpu, reg) = val;
@@ -215,6 +237,31 @@ static bool kvm_spe_irq_is_valid(struct kvm *kvm, int irq)
 	return true;
 }
 
+static int kvm_spe_stop_user(struct kvm_vcpu *vcpu, int flags)
+{
+	struct kvm_vcpu_spe *spe = &vcpu->arch.spe;
+
+	if (flags & KVM_ARM_VCPU_SPE_STOP_TRAP) {
+		if (flags & ~KVM_ARM_VCPU_SPE_STOP_TRAP)
+			return -EINVAL;
+		spe->flags = KVM_VCPU_SPE_STOP_USER;
+	}
+
+	if (flags & KVM_ARM_VCPU_SPE_STOP_EXIT) {
+		if (flags & ~KVM_ARM_VCPU_SPE_STOP_EXIT)
+			return -EINVAL;
+		spe->flags = KVM_VCPU_SPE_STOP_USER_EXIT;
+	}
+
+	if (flags & KVM_ARM_VCPU_SPE_RESUME) {
+		if (flags & ~KVM_ARM_VCPU_SPE_RESUME)
+			return -EINVAL;
+		spe->flags = 0;
+	}
+
+	return 0;
+}
+
 int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
 	if (!kvm_vcpu_supports_spe(vcpu))
@@ -268,6 +315,8 @@ int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 		if (!flags)
 			return -EINVAL;
+
+		return kvm_spe_stop_user(vcpu, flags);
 	}
 	}
 
@@ -293,6 +342,24 @@ int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 		return 0;
 	}
+	case KVM_ARM_VCPU_SPE_STOP: {
+		int __user *uaddr = (int __user *)(long)attr->addr;
+		struct kvm_vcpu_spe *spe = &vcpu->arch.spe;
+		int flag = 0;
+
+		if (!vcpu->arch.spe.initialized)
+			return -EAGAIN;
+
+		if (spe->flags & KVM_VCPU_SPE_STOP_USER)
+			flag = KVM_ARM_VCPU_SPE_STOP_TRAP;
+		else if (spe->flags & KVM_VCPU_SPE_STOP_USER_EXIT)
+			flag = KVM_ARM_VCPU_SPE_STOP_EXIT;
+
+		if (put_user(flag, uaddr))
+			return -EFAULT;
+
+		return 0;
+	}
 	}
 
 	return -ENXIO;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 064742cee425..cc711b081f31 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -608,7 +608,7 @@ static bool access_spe_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {	int reg = r->reg;
 	u64 val = p->regval;
 
-	if (reg < PMBLIMITR_EL1) {
+	if (reg < PMBLIMITR_EL1 && !kvm_spe_profiling_stopped(vcpu)) {
 		print_sys_reg_msg(p, "Unsupported guest SPE register access at: %lx [%08lx]\n",
 				  *vcpu_pc(vcpu), *vcpu_cpsr(vcpu));
 	}
-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
