Return-Path: <SRS0=u4Cy=NQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D863FC4338F
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:20:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 618D86113A
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:20:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 618D86113A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17F3B4B26B;
	Wed, 25 Aug 2021 12:20:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SObRFVcsp8+4; Wed, 25 Aug 2021 12:19:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F02B54B2E9;
	Wed, 25 Aug 2021 12:18:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85D544B2CA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:18:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YH7IUTJ2w8LH for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Aug 2021 12:18:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 793A04B262
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:18:07 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 46C231476;
 Wed, 25 Aug 2021 09:18:07 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB9613F66F;
 Wed, 25 Aug 2021 09:18:05 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 34/39] KVM: arm64: Emulate SPE buffer management
 interrupt
Date: Wed, 25 Aug 2021 17:18:10 +0100
Message-Id: <20210825161815.266051-35-alexandru.elisei@arm.com>
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

A profiling buffer management interrupt is asserted when the buffer fills,
on a fault or on an external abort. The service bit, PMBSR_EL1.S, is set as
long as SPE asserts this interrupt. The interrupt can also be asserted
following a direct write to PMBSR_EL1 that sets the bit. The SPE hardware
stops asserting the interrupt only when the service bit is cleared.

KVM emulates the interrupt by reading the value of the service bit on
each guest exit to determine if the SPE hardware asserted the interrupt
(for example, if the buffer was full). Writes to the buffer registers are
trapped, to determine when the interrupt should be cleared or when the
guest wants to explicitely assert the interrupt by setting the service bit.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_spe.h |  4 ++
 arch/arm64/kvm/arm.c             |  3 ++
 arch/arm64/kvm/hyp/nvhe/spe-sr.c | 28 +++++++++++--
 arch/arm64/kvm/hyp/vhe/spe-sr.c  | 17 ++++++--
 arch/arm64/kvm/spe.c             | 72 ++++++++++++++++++++++++++++++++
 5 files changed, 117 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index 272f1eec64f2..d7d7b9e243de 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -19,6 +19,8 @@ static __always_inline bool kvm_supports_spe(void)
 struct kvm_vcpu_spe {
 	bool initialized;	/* SPE initialized for the VCPU */
 	int irq_num;		/* Buffer management interrut number */
+	bool irq_level;		/* 'true' if the interrupt is asserted at the VGIC */
+	bool hwirq_level;	/* 'true' if the SPE hardware is asserting the interrupt */
 };
 
 struct kvm_spe {
@@ -28,6 +30,7 @@ struct kvm_spe {
 void kvm_spe_init_supported_cpus(void);
 void kvm_spe_vm_init(struct kvm *kvm);
 int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu);
+void kvm_spe_sync_hwstate(struct kvm_vcpu *vcpu);
 
 void kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val);
 u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg);
@@ -51,6 +54,7 @@ struct kvm_spe {
 static inline void kvm_spe_init_supported_cpus(void) {}
 static inline void kvm_spe_vm_init(struct kvm *kvm) {}
 static inline int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu) { return -ENOEXEC; }
+static inline void kvm_spe_sync_hwstate(struct kvm_vcpu *vcpu) {}
 
 static inline void kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val) {}
 static inline u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg) { return 0; }
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index cd64894b286e..ec449bc5f811 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -949,6 +949,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		kvm_pmu_sync_hwstate(vcpu);
 
+		if (kvm_supports_spe() && kvm_vcpu_has_spe(vcpu))
+			kvm_spe_sync_hwstate(vcpu);
+
 		/*
 		 * Sync the vgic state before syncing the timer state because
 		 * the timer code needs to know if the virtual timer
diff --git a/arch/arm64/kvm/hyp/nvhe/spe-sr.c b/arch/arm64/kvm/hyp/nvhe/spe-sr.c
index 4f6579daddb5..b74131486a75 100644
--- a/arch/arm64/kvm/hyp/nvhe/spe-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/spe-sr.c
@@ -47,6 +47,8 @@ void __spe_save_host_state_nvhe(struct kvm_vcpu *vcpu,
 void __spe_save_guest_state_nvhe(struct kvm_vcpu *vcpu,
 				 struct kvm_cpu_context *guest_ctxt)
 {
+	u64 pmbsr;
+
 	if (read_sysreg_s(SYS_PMBLIMITR_EL1) & BIT(SYS_PMBLIMITR_EL1_E_SHIFT)) {
 		psb_csync();
 		dsb(nsh);
@@ -55,7 +57,22 @@ void __spe_save_guest_state_nvhe(struct kvm_vcpu *vcpu,
 	}
 
 	ctxt_sys_reg(guest_ctxt, PMBPTR_EL1) = read_sysreg_s(SYS_PMBPTR_EL1);
-	ctxt_sys_reg(guest_ctxt, PMBSR_EL1) = read_sysreg_s(SYS_PMBSR_EL1);
+	/*
+	 * We need to differentiate between the hardware asserting the interrupt
+	 * and the guest setting the service bit as a result of a direct
+	 * register write, hence the extra field in the spe struct.
+	 *
+	 * The PMBSR_EL1 register is not directly accessed by the guest, KVM
+	 * needs to update the in-memory copy when the hardware asserts the
+	 * interrupt as that's the only case when KVM will show the guest a
+	 * value which is different from what the guest last wrote to the
+	 * register.
+	 */
+	pmbsr = read_sysreg_s(SYS_PMBSR_EL1);
+	if (pmbsr & BIT(SYS_PMBSR_EL1_S_SHIFT)) {
+		ctxt_sys_reg(guest_ctxt, PMBSR_EL1) = pmbsr;
+		vcpu->arch.spe.hwirq_level = true;
+	}
 	/* PMBLIMITR_EL1 is updated only on a trapped write. */
 	ctxt_sys_reg(guest_ctxt, PMSCR_EL1) = read_sysreg_s(SYS_PMSCR_EL1);
 
@@ -80,8 +97,13 @@ void __spe_restore_guest_state_nvhe(struct kvm_vcpu *vcpu,
 	__spe_restore_common_state(guest_ctxt);
 
 	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
-	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBSR_EL1), SYS_PMBSR_EL1);
-	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBLIMITR_EL1), SYS_PMBLIMITR_EL1);
+	/* The buffer management interrupt is virtual. */
+	write_sysreg_s(0, SYS_PMBSR_EL1);
+	/* The buffer is disabled when the interrupt is asserted. */
+	if (vcpu->arch.spe.irq_level)
+		write_sysreg_s(0, SYS_PMBLIMITR_EL1);
+	else
+		write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBLIMITR_EL1), SYS_PMBLIMITR_EL1);
 	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMSCR_EL1), SYS_PMSCR_EL1);
 	write_sysreg_el2(ctxt_sys_reg(guest_ctxt, PMSCR_EL2), SYS_PMSCR);
 }
diff --git a/arch/arm64/kvm/hyp/vhe/spe-sr.c b/arch/arm64/kvm/hyp/vhe/spe-sr.c
index f557ac64a1cc..ea4b3b69bb32 100644
--- a/arch/arm64/kvm/hyp/vhe/spe-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/spe-sr.c
@@ -48,7 +48,7 @@ NOKPROBE_SYMBOL(__spe_save_host_state_vhe);
 void __spe_save_guest_state_vhe(struct kvm_vcpu *vcpu,
 				struct kvm_cpu_context *guest_ctxt)
 {
-	u64 pmblimitr;
+	u64 pmblimitr, pmbsr;
 
 	/*
 	 * We're at EL2 and the buffer owning regime is EL1, which means that
@@ -66,7 +66,11 @@ void __spe_save_guest_state_vhe(struct kvm_vcpu *vcpu,
 	}
 
 	ctxt_sys_reg(guest_ctxt, PMBPTR_EL1) = read_sysreg_s(SYS_PMBPTR_EL1);
-	ctxt_sys_reg(guest_ctxt, PMBSR_EL1) = read_sysreg_s(SYS_PMBSR_EL1);
+	pmbsr = read_sysreg_s(SYS_PMBSR_EL1);
+	if (pmbsr & BIT(SYS_PMBSR_EL1_S_SHIFT)) {
+		ctxt_sys_reg(guest_ctxt, PMBSR_EL1) = pmbsr;
+		vcpu->arch.spe.hwirq_level = true;
+	}
 	/* PMBLIMITR_EL1 is updated only on a trapped write. */
 	ctxt_sys_reg(guest_ctxt, PMSCR_EL1) = read_sysreg_el1(SYS_PMSCR);
 
@@ -120,8 +124,13 @@ void __spe_restore_guest_state_vhe(struct kvm_vcpu *vcpu,
 	 */
 
 	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
-	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBSR_EL1), SYS_PMBSR_EL1);
-	write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBLIMITR_EL1), SYS_PMBLIMITR_EL1);
+	/* The buffer management interrupt is virtual. */
+	write_sysreg_s(0, SYS_PMBSR_EL1);
+	/* The buffer is disabled when the interrupt is asserted. */
+	if (vcpu->arch.spe.irq_level)
+		write_sysreg_s(0, SYS_PMBLIMITR_EL1);
+	else
+		write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBLIMITR_EL1), SYS_PMBLIMITR_EL1);
 	write_sysreg_el1(ctxt_sys_reg(guest_ctxt, PMSCR_EL1), SYS_PMSCR);
 	/* PMSCR_EL2 has been cleared when saving the host state. */
 }
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 054bb16bbd79..5b69501dc3da 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -71,9 +71,81 @@ int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static void kvm_spe_update_irq(struct kvm_vcpu *vcpu, bool level)
+{
+	struct kvm_vcpu_spe *spe = &vcpu->arch.spe;
+	int ret;
+
+	if (spe->irq_level == level)
+		return;
+
+	spe->irq_level = level;
+	ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id, spe->irq_num,
+				  level, spe);
+	WARN_ON(ret);
+}
+
+static __printf(2, 3)
+void print_buf_warn(struct kvm_vcpu *vcpu, char *fmt, ...)
+{
+	va_list va;
+
+	va_start(va, fmt);
+	kvm_warn_ratelimited("%pV [PMBSR=0x%016llx, PMBPTR=0x%016llx, PMBLIMITR=0x%016llx]\n",
+			    &(struct va_format){ fmt, &va },
+			    __vcpu_sys_reg(vcpu, PMBSR_EL1),
+			    __vcpu_sys_reg(vcpu, PMBPTR_EL1),
+			    __vcpu_sys_reg(vcpu, PMBLIMITR_EL1));
+	va_end(va);
+}
+
+static void kvm_spe_inject_ext_abt(struct kvm_vcpu *vcpu)
+{
+	__vcpu_sys_reg(vcpu, PMBSR_EL1) = BIT(SYS_PMBSR_EL1_EA_SHIFT) |
+					  BIT(SYS_PMBSR_EL1_S_SHIFT);
+	__vcpu_sys_reg(vcpu, PMBSR_EL1) |= SYS_PMBSR_EL1_EC_FAULT_S1;
+	/* Synchronous External Abort, not on translation table walk. */
+	__vcpu_sys_reg(vcpu, PMBSR_EL1) |= 0x10 << SYS_PMBSR_EL1_FAULT_FSC_SHIFT;
+}
+
+void kvm_spe_sync_hwstate(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_spe *spe = &vcpu->arch.spe;
+	u64 pmbsr, pmbsr_ec;
+
+	if (!spe->hwirq_level)
+		return;
+	spe->hwirq_level = false;
+
+	pmbsr = __vcpu_sys_reg(vcpu, PMBSR_EL1);
+	pmbsr_ec = pmbsr & (SYS_PMBSR_EL1_EC_MASK << SYS_PMBSR_EL1_EC_SHIFT);
+
+	switch (pmbsr_ec) {
+	case SYS_PMBSR_EL1_EC_FAULT_S2:
+		print_buf_warn(vcpu, "SPE stage 2 data abort");
+		kvm_spe_inject_ext_abt(vcpu);
+		break;
+	case SYS_PMBSR_EL1_EC_FAULT_S1:
+	case SYS_PMBSR_EL1_EC_BUF:
+		/*
+		 * These two exception syndromes are entirely up to the guest to
+		 * figure out, leave PMBSR_EL1 unchanged.
+		 */
+		break;
+	default:
+		print_buf_warn(vcpu, "SPE unknown buffer syndrome");
+		kvm_spe_inject_ext_abt(vcpu);
+	}
+
+	kvm_spe_update_irq(vcpu, true);
+}
+
 void kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
 {
 	__vcpu_sys_reg(vcpu, reg) = val;
+
+	if (reg == PMBSR_EL1)
+		kvm_spe_update_irq(vcpu, val & BIT(SYS_PMBSR_EL1_S_SHIFT));
 }
 
 u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg)
-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
