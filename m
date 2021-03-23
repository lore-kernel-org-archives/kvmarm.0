Return-Path: <SRS0=T+on=IV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F09C7C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 23 Mar 2021 18:00:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6AF5E619C0
	for <kvmarm@archiver.kernel.org>; Tue, 23 Mar 2021 18:00:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6AF5E619C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D29574B3E5;
	Tue, 23 Mar 2021 14:00:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ltE2VxL6ETp7; Tue, 23 Mar 2021 14:00:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B76D4B3AC;
	Tue, 23 Mar 2021 14:00:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A52C4B218
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Mar 2021 14:00:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b1HlgewmH6yl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Mar 2021 14:00:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFB8D4B213
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Mar 2021 14:00:36 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 64DE51042;
 Tue, 23 Mar 2021 11:00:36 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A9323F718;
 Tue, 23 Mar 2021 11:00:35 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2] KVM: arm64: Initialize VCPU mdcr_el2 before loading it
Date: Tue, 23 Mar 2021 18:00:57 +0000
Message-Id: <20210323180057.263356-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.31.0
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

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
Found by code inspection. Based on v5.12-rc4.

Tested on an odroid-c4 with VHE. vcpu->arch.mdcr_el2 is calculated to be
0x4e66. Without this patch, reading MDCR_EL2 after the first vcpu_load() in
kvm_arch_vcpu_ioctl_run() returns 0; with this patch it returns the correct
value, 0xe66 (FEAT_SPE is not implemented by the PE).

This patch was initially part of the KVM SPE series [1], but those patches
haven't seen much activity, so I thought it would be a good idea to send
this patch separately to draw more attention to it.

Changes in v2:
* Moved kvm_arm_vcpu_init_debug() earlier in kvm_vcpu_first_run_init() so
  vcpu->arch.mdcr_el2 is calculated even if kvm_vgic_map_resources() fails.
* Added comment to kvm_arm_setup_mdcr_el2 to explain what testing
  vcpu->guest_debug means.

[1] https://www.spinics.net/lists/kvm-arm/msg42959.html

 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              |  3 +-
 arch/arm64/kvm/debug.c            | 82 +++++++++++++++++++++----------
 3 files changed, 59 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3d10e6527f7d..858c2fcfc043 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -713,6 +713,7 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
 void kvm_arm_init_debug(void);
+void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7f06ba76698d..7088d8fe7186 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -580,6 +580,8 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.has_run_once = true;
 
+	kvm_arm_vcpu_init_debug(vcpu);
+
 	if (likely(irqchip_in_kernel(kvm))) {
 		/*
 		 * Map the VGIC hardware resources before running a vcpu the
@@ -791,7 +793,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		}
 
 		kvm_arm_setup_debug(vcpu);
-
 		/**************************************************************
 		 * Enter the guest
 		 */
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 7a7e425616b5..3626d03354f6 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -68,6 +68,60 @@ void kvm_arm_init_debug(void)
 	__this_cpu_write(mdcr_el2, kvm_call_hyp_ret(__kvm_get_mdcr_el2));
 }
 
+/**
+ * kvm_arm_setup_mdcr_el2 - configure vcpu mdcr_el2 value
+ *
+ * @vcpu:	the vcpu pointer
+ * @host_mdcr:  host mdcr_el2 value
+ *
+ * This ensures we will trap access to:
+ *  - Performance monitors (MDCR_EL2_TPM/MDCR_EL2_TPMCR)
+ *  - Debug ROM Address (MDCR_EL2_TDRA)
+ *  - OS related registers (MDCR_EL2_TDOSA)
+ *  - Statistical profiler (MDCR_EL2_TPMS/MDCR_EL2_E2PB)
+ */
+static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu, u32 host_mdcr)
+{
+	bool trap_debug = !(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY);
+
+	/*
+	 * This also clears MDCR_EL2_E2PB_MASK to disable guest access
+	 * to the profiling buffer.
+	 */
+	vcpu->arch.mdcr_el2 = host_mdcr & MDCR_EL2_HPMN_MASK;
+	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
+				MDCR_EL2_TPMS |
+				MDCR_EL2_TPMCR |
+				MDCR_EL2_TDRA |
+				MDCR_EL2_TDOSA);
+
+	/* Is the VM being debugged by userspace? */
+	if (vcpu->guest_debug) {
+		/* Route all software debug exceptions to EL2 */
+		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDE;
+		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW)
+			trap_debug = true;
+	}
+
+	/* Trap debug register access */
+	if (trap_debug)
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
+	kvm_arm_setup_mdcr_el2(vcpu, this_cpu_read(mdcr_el2));
+}
+
 /**
  * kvm_arm_reset_debug_ptr - reset the debug ptr to point to the vcpu state
  */
@@ -83,12 +137,7 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
  * @vcpu:	the vcpu pointer
  *
  * This is called before each entry into the hypervisor to setup any
- * debug related registers. Currently this just ensures we will trap
- * access to:
- *  - Performance monitors (MDCR_EL2_TPM/MDCR_EL2_TPMCR)
- *  - Debug ROM Address (MDCR_EL2_TDRA)
- *  - OS related registers (MDCR_EL2_TDOSA)
- *  - Statistical profiler (MDCR_EL2_TPMS/MDCR_EL2_E2PB)
+ * debug related registers.
  *
  * Additionally, KVM only traps guest accesses to the debug registers if
  * the guest is not actively using them (see the KVM_ARM64_DEBUG_DIRTY
@@ -100,27 +149,14 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
 
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
-				MDCR_EL2_TPMCR |
-				MDCR_EL2_TDRA |
-				MDCR_EL2_TDOSA);
+	kvm_arm_setup_mdcr_el2(vcpu, __this_cpu_read(mdcr_el2));
 
 	/* Is Guest debugging in effect? */
 	if (vcpu->guest_debug) {
-		/* Route all software debug exceptions to EL2 */
-		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDE;
-
 		/* Save guest debug state */
 		save_guest_debug_regs(vcpu);
 
@@ -174,7 +210,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 
 			vcpu->arch.debug_ptr = &vcpu->arch.external_debug_state;
 			vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
-			trap_debug = true;
 
 			trace_kvm_arm_set_regset("BKPTS", get_num_brps(),
 						&vcpu->arch.debug_ptr->dbg_bcr[0],
@@ -189,10 +224,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 	BUG_ON(!vcpu->guest_debug &&
 		vcpu->arch.debug_ptr != &vcpu->arch.vcpu_debug_state);
 
-	/* Trap debug register access */
-	if (trap_debug)
-		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
-
 	/* If KDE or MDE are set, perform a full save/restore cycle. */
 	if (vcpu_read_sys_reg(vcpu, MDSCR_EL1) & (DBG_MDSCR_KDE | DBG_MDSCR_MDE))
 		vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
@@ -201,7 +232,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 	if (has_vhe() && orig_mdcr_el2 != vcpu->arch.mdcr_el2)
 		write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 
-	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
 	trace_kvm_arm_set_dreg32("MDSCR_EL1", vcpu_read_sys_reg(vcpu, MDSCR_EL1));
 }
 
-- 
2.31.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
