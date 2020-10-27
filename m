Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A3BC4363A
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:26:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 79E1621D24
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:26:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 79E1621D24
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12FB14B453;
	Tue, 27 Oct 2020 13:26:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kp1xBpDu96DP; Tue, 27 Oct 2020 13:26:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 131314B57F;
	Tue, 27 Oct 2020 13:26:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB6B64B3DB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:26:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N7B+0+jUlTHV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 13:26:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BF654B3D3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:26:33 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 132DC139F;
 Tue, 27 Oct 2020 10:26:33 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0C94C3F719;
 Tue, 27 Oct 2020 10:26:31 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH v3 14/16] KVM: arm64: Emulate SPE buffer management
 interrupt
Date: Tue, 27 Oct 2020 17:27:03 +0000
Message-Id: <20201027172705.15181-15-alexandru.elisei@arm.com>
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

A profiling buffer management interrupt is asserted when the buffer fills,
on a fault or on an external abort. The service bit, PMBSR_EL1.S, is set as
long as SPE asserts this interrupt. SPE can also assert the interrupt
following a direct write to PMBSR_EL1 that sets the bit. The SPE hardware
stops asserting the interrupt only when the service bit is cleared.

KVM emulates the interrupt by reading the value of the service bit on each
guest exit to determine if the SPE hardware asserted the interrupt (for
example, if the buffer was full). Writes to the buffer registers are
trapped, to determine when the interrupt should be cleared or when the
guest wants to explicitely assert the interrupt by setting the service bit.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/sysreg.h  |   3 +
 arch/arm64/kvm/arm.c             |   3 +
 arch/arm64/kvm/hyp/nvhe/spe-sr.c |  20 +++++-
 arch/arm64/kvm/hyp/vhe/spe-sr.c  |  19 +++++-
 arch/arm64/kvm/spe.c             | 101 +++++++++++++++++++++++++++++++
 include/kvm/arm_spe.h            |   4 ++
 6 files changed, 146 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 20159af17578..0398bcba83a6 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -299,6 +299,7 @@
 #define SYS_PMBLIMITR_EL1_FM_SHIFT	1
 #define SYS_PMBLIMITR_EL1_FM_MASK	0x3UL
 #define SYS_PMBLIMITR_EL1_FM_STOP_IRQ	(0 << SYS_PMBLIMITR_EL1_FM_SHIFT)
+#define SYS_PMBLIMITR_EL1_RES0		0xfffffffffffff007UL
 
 #define SYS_PMBPTR_EL1			sys_reg(3, 0, 9, 10, 1)
 
@@ -323,6 +324,8 @@
 
 #define SYS_PMBSR_EL1_BUF_BSC_FULL	(0x1UL << SYS_PMBSR_EL1_BUF_BSC_SHIFT)
 
+#define SYS_PMBSR_EL1_RES0		0x00000000fc0fffffUL
+
 /*** End of Statistical Profiling Extension ***/
 
 #define SYS_PMINTENSET_EL1		sys_reg(3, 0, 9, 14, 1)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2d98248f2c66..c6a675aba71e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -775,6 +775,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		kvm_vgic_sync_hwstate(vcpu);
 
+		if (vcpu_has_spe(vcpu))
+			kvm_arm_spe_sync_hwstate(vcpu);
+
 		/*
 		 * Sync the timer hardware state before enabling interrupts as
 		 * we don't want vtimer interrupts to race with syncing the
diff --git a/arch/arm64/kvm/hyp/nvhe/spe-sr.c b/arch/arm64/kvm/hyp/nvhe/spe-sr.c
index a73ee820b27f..2794a7c7fcd9 100644
--- a/arch/arm64/kvm/hyp/nvhe/spe-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/spe-sr.c
@@ -47,6 +47,14 @@ void __sysreg_save_spe_host_state_nvhe(struct kvm_cpu_context *ctxt)
 void __sysreg_restore_spe_guest_state_nvhe(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
+	struct kvm_spe_cpu *spe_cpu = &vcpu->arch.spe_cpu;
+	u64 pmblimitr;
+
+	/* Disable guest profiling when the interrupt is asserted. */
+	if (spe_cpu->irq_level)
+		pmblimitr = 0;
+	else
+		pmblimitr = ctxt_sys_reg(guest_ctxt, PMBLIMITR_EL1);
 
 	__sysreg_restore_spe_state_common(guest_ctxt);
 
@@ -54,16 +62,24 @@ void __sysreg_restore_spe_guest_state_nvhe(struct kvm_vcpu *vcpu)
 	isb();
 
 	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
-	/* The guest buffer management event interrupt is always virtual. */
+	/* The guest buffer management interrupt is always virtual. */
 	write_sysreg_s(0, SYS_PMBSR_EL1);
-	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBLIMITR_EL1), SYS_PMBLIMITR_EL1);
+	write_sysreg_s(pmblimitr, SYS_PMBLIMITR_EL1);
 	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMSCR_EL1), SYS_PMSCR_EL1);
 }
 
 void __sysreg_save_spe_guest_state_nvhe(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
+	struct kvm_spe_cpu *spe_cpu = &vcpu->arch.spe_cpu;
 	u64 pmblimitr = read_sysreg_s(SYS_PMBLIMITR_EL1);
+	u64 pmbsr = read_sysreg_s(SYS_PMBSR_EL1);
+
+	/* Update guest PMBSR_EL1 only when SPE asserts an interrupt. */
+	if (pmbsr & BIT(SYS_PMBSR_EL1_S_SHIFT)) {
+		ctxt_sys_reg(guest_ctxt, PMBSR_EL1) = pmbsr;
+		spe_cpu->pmbirq_asserted = true;
+	}
 
 	if (pmblimitr & BIT(SYS_PMBLIMITR_EL1_E_SHIFT)) {
 		psb_csync();
diff --git a/arch/arm64/kvm/hyp/vhe/spe-sr.c b/arch/arm64/kvm/hyp/vhe/spe-sr.c
index dd947e9f249c..24173f838bb1 100644
--- a/arch/arm64/kvm/hyp/vhe/spe-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/spe-sr.c
@@ -44,6 +44,8 @@ NOKPROBE_SYMBOL(sysreg_save_spe_host_state_vhe);
 void sysreg_restore_spe_guest_state_vhe(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
+	struct kvm_spe_cpu *spe_cpu = &vcpu->arch.spe_cpu;
+	u64 pmblimitr;
 
 	/*
 	 * Make sure the write to MDCR_EL2 which changes the buffer owning
@@ -51,6 +53,12 @@ void sysreg_restore_spe_guest_state_vhe(struct kvm_vcpu *vcpu)
 	 */
 	isb();
 
+	/* Disable guest profiling when the interrupt is asserted. */
+	if (spe_cpu->irq_level)
+		pmblimitr = 0;
+	else
+		pmblimitr = ctxt_sys_reg(guest_ctxt, PMBLIMITR_EL1);
+
 	/*
 	 * Order doesn't matter because sampling is disabled at EL2. However,
 	 * restore guest registers in the same program order as the host for
@@ -59,9 +67,9 @@ void sysreg_restore_spe_guest_state_vhe(struct kvm_vcpu *vcpu)
 	__sysreg_restore_spe_state_common(guest_ctxt);
 
 	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
-	/* The guest buffer management event interrupt is always virtual. */
+	/* The guest buffer management interrupt is always virtual. */
 	write_sysreg_s(0, SYS_PMBSR_EL1);
-	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBLIMITR_EL1), SYS_PMBLIMITR_EL1);
+	write_sysreg_s(pmblimitr, SYS_PMBLIMITR_EL1);
 	write_sysreg_el1(ctxt_sys_reg(guest_ctxt, PMSCR_EL1), SYS_PMSCR);
 }
 NOKPROBE_SYMBOL(sysreg_restore_spe_guest_state_vhe);
@@ -69,8 +77,15 @@ NOKPROBE_SYMBOL(sysreg_restore_spe_guest_state_vhe);
 void sysreg_save_spe_guest_state_vhe(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
+	struct kvm_spe_cpu *spe_cpu = &vcpu->arch.spe_cpu;
 	u64 pmblimitr = read_sysreg_s(SYS_PMBLIMITR_EL1);
+	u64 pmbsr = read_sysreg_s(SYS_PMBSR_EL1);
 
+	/* Update guest PMBSR_EL1 only when SPE asserts an interrupt. */
+	if (pmbsr & BIT(SYS_PMBSR_EL1_S_SHIFT)) {
+		ctxt_sys_reg(guest_ctxt, PMBSR_EL1) = pmbsr;
+		spe_cpu->pmbirq_asserted = true;
+	}
 	/*
 	 * We're going to switch buffer owning Exception level when we restore
 	 * the host MDCR_EL2 value, make sure the buffer is disabled until we
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index ba80f2716a11..243fd621d640 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -12,11 +12,112 @@
 #include <kvm/arm_vgic.h>
 
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_host.h>
+
+static void kvm_arm_spe_update_irq(struct kvm_vcpu *vcpu, bool new_level)
+{
+	struct kvm_spe_cpu *spe_cpu = &vcpu->arch.spe_cpu;
+	int ret;
+
+	spe_cpu->irq_level = new_level;
+	ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id, spe_cpu->irq_num,
+				  new_level, spe_cpu);
+	WARN_ON(ret);
+}
+
+void kvm_arm_spe_sync_hwstate(struct kvm_vcpu *vcpu)
+{
+	struct kvm_spe_cpu *spe_cpu = &vcpu->arch.spe_cpu;
+	u64 pmbsr, pmbsr_ec;
+
+	if (!spe_cpu->pmbirq_asserted)
+		return;
+	spe_cpu->pmbirq_asserted = false;
+
+	pmbsr = __vcpu_sys_reg(vcpu, PMBSR_EL1);
+	pmbsr_ec = pmbsr & (SYS_PMBSR_EL1_EC_MASK << SYS_PMBSR_EL1_EC_SHIFT);
+
+	if (pmbsr & BIT(SYS_PMBSR_EL1_EA_SHIFT)) {
+		/*
+		 * The guest managed to trigger an external abort, something is
+		 * very definitely broken and there is no way for us to recover.
+		 * Treat it like we would if the external abort generated an
+		 * SError and panic now.
+		 */
+		panic("KVM SPE External Abort\n");
+		cpu_park_loop();
+		unreachable();
+	}
+
+	switch (pmbsr_ec) {
+	case SYS_PMBSR_EL1_EC_FAULT_S2:
+		/*
+		 * If we see this then either the guest memory isn't pinned
+		 * correctly (KVM bug or userspace got it wrong), or the guest
+		 * programmed the buffer pointer with a bogus address.
+		 * PMBPTR_El1 will point to the guest VA that triggered the
+		 * DABT, print it as it might be useful for debugging.
+		 */
+		pr_warn_ratelimited("KVM SPE Stage 2 Data Abort, pmbsr=0x%llx, pmbptr=0x%llx\n",
+				pmbsr, __vcpu_sys_reg(vcpu, PMBPTR_EL1));
+		/*
+		 * Convert the stage 2 DABT into a guest SPE buffer synchronous
+		 * external abort.
+		 */
+		__vcpu_sys_reg(vcpu, PMBSR_EL1) = BIT(SYS_PMBSR_EL1_S_SHIFT) |
+						  BIT(SYS_PMBSR_EL1_EA_SHIFT);
+	case SYS_PMBSR_EL1_EC_FAULT_S1:
+	case SYS_PMBSR_EL1_EC_BUF:
+		break;
+	default:
+		pr_warn_ratelimited("KVM SPE Unknown buffer syndrome, pmbsr=0x%llx, pmbptr=0x%llx\n",
+				pmbsr, __vcpu_sys_reg(vcpu, PMBPTR_EL1));
+		__vcpu_sys_reg(vcpu, PMBSR_EL1) = BIT(SYS_PMBSR_EL1_S_SHIFT) |
+						  BIT(SYS_PMBSR_EL1_EA_SHIFT);
+	}
+
+	if (spe_cpu->irq_level)
+		return;
+
+	kvm_arm_spe_update_irq(vcpu, true);
+}
+
+static u64 kvm_arm_spe_get_reg_mask(int reg)
+{
+	switch (reg) {
+	case PMBLIMITR_EL1:
+		return SYS_PMBLIMITR_EL1_RES0;
+	case PMBPTR_EL1:
+		return ~0UL;
+	case PMBSR_EL1:
+		return SYS_PMBSR_EL1_RES0;
+	default:
+		return 0UL;
+	}
+}
 
 void kvm_arm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
 {
+	struct kvm_spe_cpu *spe_cpu = &vcpu->arch.spe_cpu;
+	bool irq_level;
+
 	WARN(reg < PMBLIMITR_EL1, "Unexpected trap to SPE register\n");
+
+	val &= kvm_arm_spe_get_reg_mask(reg);
 	__vcpu_sys_reg(vcpu, reg) = val;
+
+	if (reg != PMBSR_EL1)
+		return;
+
+	irq_level = val & BIT(SYS_PMBSR_EL1_S_SHIFT);
+	/*
+	 * The VGIC configures PPIs as level-sensitive, we need to update the
+	 * interrupt state if it changes.
+	 */
+	if (spe_cpu->irq_level == irq_level)
+		return;
+
+	kvm_arm_spe_update_irq(vcpu, irq_level);
 }
 
 u64 kvm_arm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg)
diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
index a2429edc4483..d45c17dd157d 100644
--- a/include/kvm/arm_spe.h
+++ b/include/kvm/arm_spe.h
@@ -16,6 +16,7 @@ struct kvm_spe_cpu {
 	int irq_num; 		/* Guest visibile INTID */
 	bool irq_level; 	/* 'true' if interrupt is asserted to the VGIC */
 	bool initialized; 	/* Feature is initialized on VCPU */
+	bool pmbirq_asserted;	/* Hardware asserted PMBIRQ */
 };
 
 struct kvm_spe {
@@ -41,6 +42,7 @@ void kvm_arm_spe_notify_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_arm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val);
 u64 kvm_arm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg);
 
+void kvm_arm_spe_sync_hwstate(struct kvm_vcpu *vcpu);
 #else
 #define kvm_arm_supports_spe()	false
 
@@ -96,5 +98,7 @@ static inline u64 kvm_arm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg)
 	return 0;
 }
 
+static inline void kvm_arm_spe_sync_hwstate(struct kvm_vcpu *vcpu) {}
+
 #endif /* CONFIG_KVM_ARM_SPE */
 #endif /* __ASM_ARM_KVM_SPE_H */
-- 
2.29.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
