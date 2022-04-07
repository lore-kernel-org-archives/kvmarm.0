Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5F36C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  7 Apr 2022 16:23:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 281B34B0BA;
	Thu,  7 Apr 2022 12:23:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1hl9Cbp6xDXZ; Thu,  7 Apr 2022 12:23:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E38D949EEF;
	Thu,  7 Apr 2022 12:23:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D92B4A7FD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 12:23:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IaxLBYWpbmIp for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2022 12:23:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D22D49F29
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 12:23:41 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F90215BF;
 Thu,  7 Apr 2022 09:23:41 -0700 (PDT)
Received: from e121798.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D85A63F73B;
 Thu,  7 Apr 2022 09:23:39 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: catalin.marinas@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org, james.morse@arm.com,
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu, mark.rutland@arm.com
Subject: [PATCH 4/5] KVM: arm64: Treat ESR_EL2 as a 64-bit register
Date: Thu,  7 Apr 2022 17:23:26 +0100
Message-Id: <20220407162327.396183-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407162327.396183-1-alexandru.elisei@arm.com>
References: <20220407162327.396183-1-alexandru.elisei@arm.com>
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

ESR_EL2 was defined as a 32-bit register in the initial release of the
ARM Architecture Manual for Armv8-A, and was later extended to 64 bits,
with bits [63:32] RES0. ARMv8.7 introduced FEAT_LS64, which makes use of
bits [36:32].

KVM treats ESR_EL1 as a 64-bit register when saving and restoring the
guest context, but ESR_EL2 is handled as a 32-bit register. Start
treating ESR_EL2 as a 64-bit register to allow KVM to make use of the
most significant 32 bits in the future.

The type chosen to represent ESR_EL2 is u64, as that is consistent with the
notation KVM overwhelmingly uses today (u32), and how the rest of the
registers are declared.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_emulate.h    |  6 +++---
 arch/arm64/include/asm/kvm_host.h       |  2 +-
 arch/arm64/include/asm/kvm_ras.h        |  2 +-
 arch/arm64/kvm/handle_exit.c            | 14 +++++++-------
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c      |  2 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c         |  4 ++--
 arch/arm64/kvm/inject_fault.c           |  4 ++--
 arch/arm64/kvm/sys_regs.c               |  4 ++--
 9 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index d62405ce3e6d..05b73a168fbc 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -224,14 +224,14 @@ static inline bool vcpu_mode_priv(const struct kvm_vcpu *vcpu)
 	return mode != PSR_MODE_EL0t;
 }
 
-static __always_inline u32 kvm_vcpu_get_esr(const struct kvm_vcpu *vcpu)
+static __always_inline u64 kvm_vcpu_get_esr(const struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.fault.esr_el2;
 }
 
 static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
 {
-	u32 esr = kvm_vcpu_get_esr(vcpu);
+	u64 esr = kvm_vcpu_get_esr(vcpu);
 
 	if (esr & ESR_ELx_CV)
 		return (esr & ESR_ELx_COND_MASK) >> ESR_ELx_COND_SHIFT;
@@ -362,7 +362,7 @@ static __always_inline bool kvm_vcpu_abt_issea(const struct kvm_vcpu *vcpu)
 
 static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
 {
-	u32 esr = kvm_vcpu_get_esr(vcpu);
+	u64 esr = kvm_vcpu_get_esr(vcpu);
 	return ESR_ELx_SYS64_ISS_RT(esr);
 }
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e3b25dc6c367..91f6564f5ab8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -143,7 +143,7 @@ struct kvm_arch {
 };
 
 struct kvm_vcpu_fault_info {
-	u32 esr_el2;		/* Hyp Syndrom Register */
+	u64 esr_el2;		/* Hyp Syndrom Register */
 	u64 far_el2;		/* Hyp Fault Address Register */
 	u64 hpfar_el2;		/* Hyp IPA Fault Address Register */
 	u64 disr_el1;		/* Deferred [SError] Status Register */
diff --git a/arch/arm64/include/asm/kvm_ras.h b/arch/arm64/include/asm/kvm_ras.h
index 8ac6ee77437c..87e10d9a635b 100644
--- a/arch/arm64/include/asm/kvm_ras.h
+++ b/arch/arm64/include/asm/kvm_ras.h
@@ -14,7 +14,7 @@
  * Was this synchronous external abort a RAS notification?
  * Returns '0' for errors handled by some RAS subsystem, or -ENOENT.
  */
-static inline int kvm_handle_guest_sea(phys_addr_t addr, unsigned int esr)
+static inline int kvm_handle_guest_sea(phys_addr_t addr, u64 esr)
 {
 	/* apei_claim_sea(NULL) expects to mask interrupts itself */
 	lockdep_assert_irqs_enabled();
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 97fe14aab1a3..93d92130d36c 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -26,7 +26,7 @@
 
 typedef int (*exit_handle_fn)(struct kvm_vcpu *);
 
-static void kvm_handle_guest_serror(struct kvm_vcpu *vcpu, u32 esr)
+static void kvm_handle_guest_serror(struct kvm_vcpu *vcpu, u64 esr)
 {
 	if (!arm64_is_ras_serror(esr) || arm64_is_fatal_ras_serror(NULL, esr))
 		kvm_inject_vabt(vcpu);
@@ -117,10 +117,10 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
-	u32 esr = kvm_vcpu_get_esr(vcpu);
+	u64 esr = kvm_vcpu_get_esr(vcpu);
 
 	run->exit_reason = KVM_EXIT_DEBUG;
-	run->debug.arch.hsr = esr;
+	run->debug.arch.hsr = lower_32_bits(esr);
 
 	if (ESR_ELx_EC(esr) == ESR_ELx_EC_WATCHPT_LOW)
 		run->debug.arch.far = vcpu->arch.fault.far_el2;
@@ -130,9 +130,9 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
 
 static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu)
 {
-	u32 esr = kvm_vcpu_get_esr(vcpu);
+	u64 esr = kvm_vcpu_get_esr(vcpu);
 
-	kvm_pr_unimpl("Unknown exception class: esr: %#08x -- %s\n",
+	kvm_pr_unimpl("Unknown exception class: esr: %#016llx -- %s\n",
 		      esr, esr_get_class_string(esr));
 
 	kvm_inject_undefined(vcpu);
@@ -187,7 +187,7 @@ static exit_handle_fn arm_exit_handlers[] = {
 
 static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
 {
-	u32 esr = kvm_vcpu_get_esr(vcpu);
+	u64 esr = kvm_vcpu_get_esr(vcpu);
 	u8 esr_ec = ESR_ELx_EC(esr);
 
 	return arm_exit_handlers[esr_ec];
@@ -334,6 +334,6 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 	 */
 	kvm_err("Hyp Offset: 0x%llx\n", hyp_offset);
 
-	panic("HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%016lx\n",
+	panic("HYP panic:\nPS:%08llx PC:%016llx ESR:%016llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%016lx\n",
 	      spsr, elr_virt, esr, far, hpfar, par, vcpu);
 }
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 5d31f6c64c8c..37d9f211c200 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -266,7 +266,7 @@ static inline bool handle_tx2_tvm(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-static inline bool esr_is_ptrauth_trap(u32 esr)
+static inline bool esr_is_ptrauth_trap(u64 esr)
 {
 	switch (esr_sys64_to_sysreg(esr)) {
 	case SYS_APIAKEYLO_EL1:
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 33f5181af330..619f94fc95fa 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -33,7 +33,7 @@ u64 id_aa64mmfr2_el1_sys_val;
  */
 static void inject_undef64(struct kvm_vcpu *vcpu)
 {
-	u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
+	u64 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
 
 	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
 	*vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 4fb419f7b8b6..6cb638b184b1 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -473,7 +473,7 @@ static int __vgic_v3_bpr_min(void)
 
 static int __vgic_v3_get_group(struct kvm_vcpu *vcpu)
 {
-	u32 esr = kvm_vcpu_get_esr(vcpu);
+	u64 esr = kvm_vcpu_get_esr(vcpu);
 	u8 crm = (esr & ESR_ELx_SYS64_ISS_CRM_MASK) >> ESR_ELx_SYS64_ISS_CRM_SHIFT;
 
 	return crm != 8;
@@ -1016,7 +1016,7 @@ static void __vgic_v3_write_ctlr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 {
 	int rt;
-	u32 esr;
+	u64 esr;
 	u32 vmcr;
 	void (*fn)(struct kvm_vcpu *, u32, int);
 	bool is_read;
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index b47df73e98d7..3664e30f5694 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -18,7 +18,7 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 {
 	unsigned long cpsr = *vcpu_cpsr(vcpu);
 	bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
-	u32 esr = 0;
+	u64 esr = 0;
 
 	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA64_EL1		|
 			     KVM_ARM64_EXCEPT_AA64_ELx_SYNC	|
@@ -50,7 +50,7 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 
 static void inject_undef64(struct kvm_vcpu *vcpu)
 {
-	u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
+	u64 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
 
 	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA64_EL1		|
 			     KVM_ARM64_EXCEPT_AA64_ELx_SYNC	|
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7b45c040cc27..2bde95662bbf 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2304,7 +2304,7 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
 			    size_t nr_global)
 {
 	struct sys_reg_params params;
-	u32 esr = kvm_vcpu_get_esr(vcpu);
+	u64 esr = kvm_vcpu_get_esr(vcpu);
 	int Rt = kvm_vcpu_sys_get_rt(vcpu);
 	int Rt2 = (esr >> 10) & 0x1f;
 
@@ -2354,7 +2354,7 @@ static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
 			    size_t nr_global)
 {
 	struct sys_reg_params params;
-	u32 esr = kvm_vcpu_get_esr(vcpu);
+	u64 esr = kvm_vcpu_get_esr(vcpu);
 	int Rt  = kvm_vcpu_sys_get_rt(vcpu);
 
 	params.CRm = (esr >> 1) & 0xf;
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
