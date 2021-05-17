Return-Path: <SRS0=zR8f=KM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A73BC433B4
	for <kvmarm@archiver.kernel.org>; Mon, 17 May 2021 14:26:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BD5C4619D5
	for <kvmarm@archiver.kernel.org>; Mon, 17 May 2021 14:26:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD5C4619D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 507994B4AE;
	Mon, 17 May 2021 10:26:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tdbani-tT64L; Mon, 17 May 2021 10:26:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8654E4B340;
	Mon, 17 May 2021 10:26:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9A544B281
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 May 2021 10:26:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OUh5rFHEZCK1 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 May 2021 10:26:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D74B4B27D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 May 2021 10:26:34 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A045139F;
 Mon, 17 May 2021 07:26:34 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1339D3F73B;
 Mon, 17 May 2021 07:26:32 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: stable@vger.kernel.org, maz@kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH for-stable-5.4] KVM: arm64: Initialize VCPU mdcr_el2 before
 loading it
Date: Mon, 17 May 2021 15:27:13 +0100
Message-Id: <20210517142713.400651-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.31.1
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

[ Upstream commit 263d6287da1433aba11c5b4046388f2cdf49675c ]

When a VCPU is created, the kvm_vcpu struct is initialized to zero in
kvm_vm_ioctl_create_vcpu(). On VHE systems, the first time
vcpu.arch.mdcr_el2 is loaded on hardware is in vcpu_load(), before it is
set to a sensible value in kvm_arm_setup_debug() later in the run loop. The
result is that KVM executes for a short time with MDCR_EL2 set to zero.

This has several unintended consequences:

* Setting MDCR_EL2.HPMN to 0 is constrained unpredictable according to ARM
  DDI 0487G.a, page D13-3820. The behavior specified by the architecture
  in this case is for the PE to behave as if MDCR_EL2.HPMN is set to a
  value less than or equal to PMCR_EL0.N, which means that an unknown
  number of counters are now disabled by MDCR_EL2.HPME, which is zero.

* The host configuration for the other debug features controlled by
  MDCR_EL2 is temporarily lost. This has been harmless so far, as Linux
  doesn't use the other fields, but that might change in the future.

Let's avoid both issues by initializing the VCPU's mdcr_el2 field in
kvm_vcpu_vcpu_first_run_init(), thus making sure that the MDCR_EL2 register
has a consistent value after each vcpu_load().

[ v5.4 backport: added stub for KVM/arm that fixes compilation errors ]

Fixes: d5a21bcc2995 ("KVM: arm64: Move common VHE/non-VHE trap config in separate functions")
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210407144857.199746-3-alexandru.elisei@arm.com
---
 arch/arm/include/asm/kvm_host.h   |  1 +
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/debug.c            | 88 +++++++++++++++++++++----------
 virt/kvm/arm/arm.c                |  2 +
 4 files changed, 64 insertions(+), 28 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index dd03d5e01a94..32564b017ba0 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -335,6 +335,7 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
 static inline void kvm_arm_init_debug(void) {}
+static inline void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index dfa6dc4575be..697702a1a1ff 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -552,6 +552,7 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
 void kvm_arm_init_debug(void);
+void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index dbc890511631..2484b2cca74b 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -68,6 +68,64 @@ void kvm_arm_init_debug(void)
 	__this_cpu_write(mdcr_el2, kvm_call_hyp_ret(__kvm_get_mdcr_el2));
 }
 
+/**
+ * kvm_arm_setup_mdcr_el2 - configure vcpu mdcr_el2 value
+ *
+ * @vcpu:	the vcpu pointer
+ *
+ * This ensures we will trap access to:
+ *  - Performance monitors (MDCR_EL2_TPM/MDCR_EL2_TPMCR)
+ *  - Debug ROM Address (MDCR_EL2_TDRA)
+ *  - OS related registers (MDCR_EL2_TDOSA)
+ *  - Statistical profiler (MDCR_EL2_TPMS/MDCR_EL2_E2PB)
+ *  - Self-hosted Trace Filter controls (MDCR_EL2_TTRF)
+ */
+static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * This also clears MDCR_EL2_E2PB_MASK to disable guest access
+	 * to the profiling buffer.
+	 */
+	vcpu->arch.mdcr_el2 = __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
+	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
+				MDCR_EL2_TPMS |
+				MDCR_EL2_TTRF |
+				MDCR_EL2_TPMCR |
+				MDCR_EL2_TDRA |
+				MDCR_EL2_TDOSA);
+
+	/* Is the VM being debugged by userspace? */
+	if (vcpu->guest_debug)
+		/* Route all software debug exceptions to EL2 */
+		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDE;
+
+	/*
+	 * Trap debug register access when one of the following is true:
+	 *  - Userspace is using the hardware to debug the guest
+	 *  (KVM_GUESTDBG_USE_HW is set).
+	 *  - The guest is not using debug (KVM_ARM64_DEBUG_DIRTY is clear).
+	 */
+	if ((vcpu->guest_debug & KVM_GUESTDBG_USE_HW) ||
+	    !(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
+		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
+
+	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
+}
+
+/**
+ * kvm_arm_vcpu_init_debug - setup vcpu debug traps
+ *
+ * @vcpu:	the vcpu pointer
+ *
+ * Set vcpu initial mdcr_el2 value.
+ */
+void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu)
+{
+	preempt_disable();
+	kvm_arm_setup_mdcr_el2(vcpu);
+	preempt_enable();
+}
+
 /**
  * kvm_arm_reset_debug_ptr - reset the debug ptr to point to the vcpu state
  */
@@ -83,13 +141,7 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
  * @vcpu:	the vcpu pointer
  *
  * This is called before each entry into the hypervisor to setup any
- * debug related registers. Currently this just ensures we will trap
- * access to:
- *  - Performance monitors (MDCR_EL2_TPM/MDCR_EL2_TPMCR)
- *  - Debug ROM Address (MDCR_EL2_TDRA)
- *  - OS related registers (MDCR_EL2_TDOSA)
- *  - Statistical profiler (MDCR_EL2_TPMS/MDCR_EL2_E2PB)
- *  - Self-hosted Trace Filter controls (MDCR_EL2_TTRF)
+ * debug related registers.
  *
  * Additionally, KVM only traps guest accesses to the debug registers if
  * the guest is not actively using them (see the KVM_ARM64_DEBUG_DIRTY
@@ -101,28 +153,14 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
 
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 {
-	bool trap_debug = !(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY);
 	unsigned long mdscr, orig_mdcr_el2 = vcpu->arch.mdcr_el2;
 
 	trace_kvm_arm_setup_debug(vcpu, vcpu->guest_debug);
 
-	/*
-	 * This also clears MDCR_EL2_E2PB_MASK to disable guest access
-	 * to the profiling buffer.
-	 */
-	vcpu->arch.mdcr_el2 = __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
-	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
-				MDCR_EL2_TPMS |
-				MDCR_EL2_TTRF |
-				MDCR_EL2_TPMCR |
-				MDCR_EL2_TDRA |
-				MDCR_EL2_TDOSA);
+	kvm_arm_setup_mdcr_el2(vcpu);
 
 	/* Is Guest debugging in effect? */
 	if (vcpu->guest_debug) {
-		/* Route all software debug exceptions to EL2 */
-		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDE;
-
 		/* Save guest debug state */
 		save_guest_debug_regs(vcpu);
 
@@ -176,7 +214,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 
 			vcpu->arch.debug_ptr = &vcpu->arch.external_debug_state;
 			vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
-			trap_debug = true;
 
 			trace_kvm_arm_set_regset("BKPTS", get_num_brps(),
 						&vcpu->arch.debug_ptr->dbg_bcr[0],
@@ -191,10 +228,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 	BUG_ON(!vcpu->guest_debug &&
 		vcpu->arch.debug_ptr != &vcpu->arch.vcpu_debug_state);
 
-	/* Trap debug register access */
-	if (trap_debug)
-		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
-
 	/* If KDE or MDE are set, perform a full save/restore cycle. */
 	if (vcpu_read_sys_reg(vcpu, MDSCR_EL1) & (DBG_MDSCR_KDE | DBG_MDSCR_MDE))
 		vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
@@ -203,7 +236,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 	if (has_vhe() && orig_mdcr_el2 != vcpu->arch.mdcr_el2)
 		write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 
-	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
 	trace_kvm_arm_set_dreg32("MDSCR_EL1", vcpu_read_sys_reg(vcpu, MDSCR_EL1));
 }
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 2e7d2b3f2907..4af85605730e 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -579,6 +579,8 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.has_run_once = true;
 
+	kvm_arm_vcpu_init_debug(vcpu);
+
 	if (likely(irqchip_in_kernel(kvm))) {
 		/*
 		 * Map the VGIC hardware resources before running a vcpu the
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
