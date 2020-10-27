Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 863F2C55179
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:26:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 045252225E
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:26:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 045252225E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C8B44B4B1;
	Tue, 27 Oct 2020 13:26:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K0SkVP3OcVGO; Tue, 27 Oct 2020 13:26:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 596554B448;
	Tue, 27 Oct 2020 13:26:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56FE44B3DB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:26:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ckpivg++SnZE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 13:26:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 098BA4B3D5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:26:16 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AF7D3150C;
 Tue, 27 Oct 2020 10:26:15 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B53D3F719;
 Tue, 27 Oct 2020 10:26:14 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH v3 01/16] KVM: arm64: Initialize VCPU mdcr_el2 before
 loading it
Date: Tue, 27 Oct 2020 17:26:50 +0000
Message-Id: <20201027172705.15181-2-alexandru.elisei@arm.com>
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

When a VCPU is created, the kvm_vcpu struct is initialized to zero in
kvm_vm_ioctl_create_vcpu(). On VHE systems, the first time
vcpu.arch.mdcr_el2 is loaded on hardware is in vcpu_load(), before it is
set to a sensible value in kvm_arm_setup_debug() later in the run loop. The
result is that KVM executes for a short time with MDCR_EL2 set to zero.

This is mostly harmless as we don't need to trap debug and SPE register
accesses from EL1 (we're still running in the host at EL2), but we do set
MDCR_EL2.HPMN to 0 which is constrained unpredictable according to ARM DDI
0487F.b, page D13-3620; the required behavior from the hardware in this
case is to reserve an unkown number of registers for EL2 and EL3 exclusive
use.

Initialize mdcr_el2 in kvm_vcpu_vcpu_first_run_init(), so we can avoid the
constrained unpredictable behavior and to ensure that the MDCR_EL2 register
has the same value after each vcpu_load(), including the first time the
VCPU is run.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              |  3 +-
 arch/arm64/kvm/debug.c            | 81 +++++++++++++++++++++----------
 3 files changed, 58 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0aecbab6a7fb..25d326aecded 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -597,6 +597,7 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
 void kvm_arm_init_debug(void);
+void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f56122eedffc..e51d8f328c7e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -544,6 +544,8 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 		static_branch_inc(&userspace_irqchip_in_use);
 	}
 
+	kvm_arm_vcpu_init_debug(vcpu);
+
 	ret = kvm_timer_enable(vcpu);
 	if (ret)
 		return ret;
@@ -739,7 +741,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		}
 
 		kvm_arm_setup_debug(vcpu);
-
 		/**************************************************************
 		 * Enter the guest
 		 */
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 7a7e425616b5..22ee448aee2b 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -68,6 +68,59 @@ void kvm_arm_init_debug(void)
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
@@ -83,12 +136,7 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
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
@@ -100,27 +148,14 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
 
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
 
@@ -174,7 +209,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 
 			vcpu->arch.debug_ptr = &vcpu->arch.external_debug_state;
 			vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
-			trap_debug = true;
 
 			trace_kvm_arm_set_regset("BKPTS", get_num_brps(),
 						&vcpu->arch.debug_ptr->dbg_bcr[0],
@@ -189,10 +223,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 	BUG_ON(!vcpu->guest_debug &&
 		vcpu->arch.debug_ptr != &vcpu->arch.vcpu_debug_state);
 
-	/* Trap debug register access */
-	if (trap_debug)
-		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
-
 	/* If KDE or MDE are set, perform a full save/restore cycle. */
 	if (vcpu_read_sys_reg(vcpu, MDSCR_EL1) & (DBG_MDSCR_KDE | DBG_MDSCR_MDE))
 		vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
@@ -201,7 +231,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 	if (has_vhe() && orig_mdcr_el2 != vcpu->arch.mdcr_el2)
 		write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 
-	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
 	trace_kvm_arm_set_dreg32("MDSCR_EL1", vcpu_read_sys_reg(vcpu, MDSCR_EL1));
 }
 
-- 
2.29.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
