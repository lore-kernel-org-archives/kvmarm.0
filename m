Return-Path: <SRS0=5+eb=MG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D95C07E9C
	for <kvmarm@archiver.kernel.org>; Wed, 14 Jul 2021 09:55:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 36CCD613AF
	for <kvmarm@archiver.kernel.org>; Wed, 14 Jul 2021 09:55:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36CCD613AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D059C4AEF8;
	Wed, 14 Jul 2021 05:55:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YERtTUcNlUfm; Wed, 14 Jul 2021 05:55:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D01BE407F1;
	Wed, 14 Jul 2021 05:55:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B4FE4A5A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Jul 2021 05:55:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ixLmmVCUOYsF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Jul 2021 05:55:11 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADB084B087
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Jul 2021 05:55:11 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 396BC11D4;
 Wed, 14 Jul 2021 02:55:11 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 083423F774;
 Wed, 14 Jul 2021 02:55:09 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH 3/5] KVM: arm64: Rename __vcpu_sys_reg -> vcpu_sys_reg
Date: Wed, 14 Jul 2021 10:55:59 +0100
Message-Id: <20210714095601.184854-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210714095601.184854-1-alexandru.elisei@arm.com>
References: <20210714095601.184854-1-alexandru.elisei@arm.com>
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

There are two macros to access a specific system register from a known
kvm_cpu_context: __ctxt_sys_reg(), which returns a pointer to the register,
and ctxt_sys_reg(), which deferences the pointer returned by
__ctxt_sys_reg().

__vcpu_sys_reg() serves a similar purpose, with the difference being that
it takes a struct kvm_vcpu as a parameter. __vcpu_sys_reg(), although it
looks like __ctxt_sys_reg(), it dereferences the pointer to the register,
like ctxt_sys_reg() does, and indeed it is defined as an abstraction over
ctxt_sys_reg().

Let's remove this naming inconsistency by renaming __vcpu_sys_reg() to
vcpu_sys_reg(), to make it clear it behaves like ctxt_sys_reg(), and not
like __ctxt_sys_reg().

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_host.h          |  4 +-
 arch/arm64/kvm/arch_timer.c                | 20 ++++----
 arch/arm64/kvm/arm.c                       |  3 +-
 arch/arm64/kvm/fpsimd.c                    |  2 +-
 arch/arm64/kvm/hyp/exception.c             |  4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h    |  6 +--
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 12 ++---
 arch/arm64/kvm/pmu-emul.c                  | 58 +++++++++++-----------
 arch/arm64/kvm/sys_regs.c                  | 54 ++++++++++----------
 arch/arm64/kvm/sys_regs.h                  |  4 +-
 10 files changed, 83 insertions(+), 84 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e6bdf1feb922..76efede8beae 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -459,7 +459,7 @@ struct kvm_vcpu_arch {
 #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.regs)
 
 /*
- * Only use __vcpu_sys_reg/ctxt_sys_reg if you know you want the
+ * Only use vcpu_sys_reg/ctxt_sys_reg if you know you want the
  * memory backed version of a register, and not the one most recently
  * accessed by a running VCPU.  For example, for userspace access or
  * for system registers that are never context switched, but only
@@ -469,7 +469,7 @@ struct kvm_vcpu_arch {
 
 #define ctxt_sys_reg(c,r)	(*__ctxt_sys_reg(c,r))
 
-#define __vcpu_sys_reg(v,r)	(ctxt_sys_reg(&(v)->arch.ctxt, (r)))
+#define vcpu_sys_reg(v,r)	(ctxt_sys_reg(&(v)->arch.ctxt, (r)))
 
 u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg);
 void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg);
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 3df67c127489..b928a70c01d2 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -58,9 +58,9 @@ u32 timer_get_ctl(struct arch_timer_context *ctxt)
 
 	switch(arch_timer_ctx_index(ctxt)) {
 	case TIMER_VTIMER:
-		return __vcpu_sys_reg(vcpu, CNTV_CTL_EL0);
+		return vcpu_sys_reg(vcpu, CNTV_CTL_EL0);
 	case TIMER_PTIMER:
-		return __vcpu_sys_reg(vcpu, CNTP_CTL_EL0);
+		return vcpu_sys_reg(vcpu, CNTP_CTL_EL0);
 	default:
 		WARN_ON(1);
 		return 0;
@@ -73,9 +73,9 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)
 
 	switch(arch_timer_ctx_index(ctxt)) {
 	case TIMER_VTIMER:
-		return __vcpu_sys_reg(vcpu, CNTV_CVAL_EL0);
+		return vcpu_sys_reg(vcpu, CNTV_CVAL_EL0);
 	case TIMER_PTIMER:
-		return __vcpu_sys_reg(vcpu, CNTP_CVAL_EL0);
+		return vcpu_sys_reg(vcpu, CNTP_CVAL_EL0);
 	default:
 		WARN_ON(1);
 		return 0;
@@ -88,7 +88,7 @@ static u64 timer_get_offset(struct arch_timer_context *ctxt)
 
 	switch(arch_timer_ctx_index(ctxt)) {
 	case TIMER_VTIMER:
-		return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
+		return vcpu_sys_reg(vcpu, CNTVOFF_EL2);
 	default:
 		return 0;
 	}
@@ -100,10 +100,10 @@ static void timer_set_ctl(struct arch_timer_context *ctxt, u32 ctl)
 
 	switch(arch_timer_ctx_index(ctxt)) {
 	case TIMER_VTIMER:
-		__vcpu_sys_reg(vcpu, CNTV_CTL_EL0) = ctl;
+		vcpu_sys_reg(vcpu, CNTV_CTL_EL0) = ctl;
 		break;
 	case TIMER_PTIMER:
-		__vcpu_sys_reg(vcpu, CNTP_CTL_EL0) = ctl;
+		vcpu_sys_reg(vcpu, CNTP_CTL_EL0) = ctl;
 		break;
 	default:
 		WARN_ON(1);
@@ -116,10 +116,10 @@ static void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
 
 	switch(arch_timer_ctx_index(ctxt)) {
 	case TIMER_VTIMER:
-		__vcpu_sys_reg(vcpu, CNTV_CVAL_EL0) = cval;
+		vcpu_sys_reg(vcpu, CNTV_CVAL_EL0) = cval;
 		break;
 	case TIMER_PTIMER:
-		__vcpu_sys_reg(vcpu, CNTP_CVAL_EL0) = cval;
+		vcpu_sys_reg(vcpu, CNTP_CVAL_EL0) = cval;
 		break;
 	default:
 		WARN_ON(1);
@@ -132,7 +132,7 @@ static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
 
 	switch(arch_timer_ctx_index(ctxt)) {
 	case TIMER_VTIMER:
-		__vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
+		vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
 		break;
 	default:
 		WARN(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 646c7b003a59..04c722e4eca0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -700,8 +700,7 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 		}
 
 		if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
-			kvm_pmu_handle_pmcr(vcpu,
-					    __vcpu_sys_reg(vcpu, PMCR_EL0));
+			kvm_pmu_handle_pmcr(vcpu, vcpu_sys_reg(vcpu, PMCR_EL0));
 	}
 }
 
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 5621020b28de..3fea05c7f49d 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -122,7 +122,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
 		if (guest_has_sve) {
-			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
+			vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
 
 			/* Restore the VL that was saved when bound to the CPU */
 			if (!has_vhe())
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 0418399e0a20..89b5cdc850f5 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -25,7 +25,7 @@ static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 	if (__vcpu_read_sys_reg_from_cpu(reg, &val))
 		return val;
 
-	return __vcpu_sys_reg(vcpu, reg);
+	return vcpu_sys_reg(vcpu, reg);
 }
 
 static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
@@ -33,7 +33,7 @@ static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 	if (__vcpu_write_sys_reg_to_cpu(val, reg))
 		return;
 
-	 __vcpu_sys_reg(vcpu, reg) = val;
+	 vcpu_sys_reg(vcpu, reg) = val;
 }
 
 static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e4a2f295a394..cc0ab79edcd9 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -57,7 +57,7 @@ static inline void __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu)
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
-	__vcpu_sys_reg(vcpu, FPEXC32_EL2) = read_sysreg(fpexc32_el2);
+	vcpu_sys_reg(vcpu, FPEXC32_EL2) = read_sysreg(fpexc32_el2);
 }
 
 static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
@@ -218,7 +218,7 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
 	__sve_restore_state(vcpu_sve_pffr(vcpu),
 			    &vcpu->arch.ctxt.fp_regs.fpsr);
-	write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
+	write_sysreg_el1(vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
 }
 
 /* Check for an FPSIMD/SVE trap and handle as appropriate */
@@ -280,7 +280,7 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 
 	/* Skip restoring fpexc32 for AArch64 guests */
 	if (!(read_sysreg(hcr_el2) & HCR_RW))
-		write_sysreg(__vcpu_sys_reg(vcpu, FPEXC32_EL2), fpexc32_el2);
+		write_sysreg(vcpu_sys_reg(vcpu, FPEXC32_EL2), fpexc32_el2);
 
 	vcpu->arch.flags |= KVM_ARM64_FP_ENABLED;
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index de7e14c862e6..c50e7462adff 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -187,11 +187,11 @@ static inline void __sysreg32_save_state(struct kvm_vcpu *vcpu)
 	vcpu->arch.ctxt.spsr_irq = read_sysreg(spsr_irq);
 	vcpu->arch.ctxt.spsr_fiq = read_sysreg(spsr_fiq);
 
-	__vcpu_sys_reg(vcpu, DACR32_EL2) = read_sysreg(dacr32_el2);
-	__vcpu_sys_reg(vcpu, IFSR32_EL2) = read_sysreg(ifsr32_el2);
+	vcpu_sys_reg(vcpu, DACR32_EL2) = read_sysreg(dacr32_el2);
+	vcpu_sys_reg(vcpu, IFSR32_EL2) = read_sysreg(ifsr32_el2);
 
 	if (has_vhe() || vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY)
-		__vcpu_sys_reg(vcpu, DBGVCR32_EL2) = read_sysreg(dbgvcr32_el2);
+		vcpu_sys_reg(vcpu, DBGVCR32_EL2) = read_sysreg(dbgvcr32_el2);
 }
 
 static inline void __sysreg32_restore_state(struct kvm_vcpu *vcpu)
@@ -204,11 +204,11 @@ static inline void __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 	write_sysreg(vcpu->arch.ctxt.spsr_irq, spsr_irq);
 	write_sysreg(vcpu->arch.ctxt.spsr_fiq, spsr_fiq);
 
-	write_sysreg(__vcpu_sys_reg(vcpu, DACR32_EL2), dacr32_el2);
-	write_sysreg(__vcpu_sys_reg(vcpu, IFSR32_EL2), ifsr32_el2);
+	write_sysreg(vcpu_sys_reg(vcpu, DACR32_EL2), dacr32_el2);
+	write_sysreg(vcpu_sys_reg(vcpu, IFSR32_EL2), ifsr32_el2);
 
 	if (has_vhe() || vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY)
-		write_sysreg(__vcpu_sys_reg(vcpu, DBGVCR32_EL2), dbgvcr32_el2);
+		write_sysreg(vcpu_sys_reg(vcpu, DBGVCR32_EL2), dbgvcr32_el2);
 }
 
 #endif /* __ARM64_KVM_HYP_SYSREG_SR_H__ */
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index f33825c995cb..f53e1a2d6df5 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -43,7 +43,7 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
 static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
 {
 	return (select_idx == ARMV8_PMU_CYCLE_IDX &&
-		__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
+		vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
 }
 
 static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
@@ -115,7 +115,7 @@ static bool kvm_pmu_idx_has_chain_evtype(struct kvm_vcpu *vcpu, u64 select_idx)
 		return false;
 
 	reg = PMEVTYPER0_EL0 + select_idx;
-	eventsel = __vcpu_sys_reg(vcpu, reg) & kvm_pmu_event_mask(vcpu->kvm);
+	eventsel = vcpu_sys_reg(vcpu, reg) & kvm_pmu_event_mask(vcpu->kvm);
 
 	return eventsel == ARMV8_PMUV3_PERFCTR_CHAIN;
 }
@@ -134,14 +134,14 @@ static u64 kvm_pmu_get_pair_counter_value(struct kvm_vcpu *vcpu,
 		pmc = kvm_pmu_get_canonical_pmc(pmc);
 		reg = PMEVCNTR0_EL0 + pmc->idx;
 
-		counter = __vcpu_sys_reg(vcpu, reg);
-		counter_high = __vcpu_sys_reg(vcpu, reg + 1);
+		counter = vcpu_sys_reg(vcpu, reg);
+		counter_high = vcpu_sys_reg(vcpu, reg + 1);
 
 		counter = lower_32_bits(counter) | (counter_high << 32);
 	} else {
 		reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
 		      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
-		counter = __vcpu_sys_reg(vcpu, reg);
+		counter = vcpu_sys_reg(vcpu, reg);
 	}
 
 	/*
@@ -189,7 +189,7 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 
 	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
 	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
-	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
+	vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
 
 	/* Recreate the perf event to reflect the updated sample_period */
 	kvm_pmu_create_perf_event(vcpu, select_idx);
@@ -233,10 +233,10 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
 		val = lower_32_bits(counter);
 	}
 
-	__vcpu_sys_reg(vcpu, reg) = val;
+	vcpu_sys_reg(vcpu, reg) = val;
 
 	if (kvm_pmu_pmc_is_chained(pmc))
-		__vcpu_sys_reg(vcpu, reg + 1) = upper_32_bits(counter);
+		vcpu_sys_reg(vcpu, reg + 1) = upper_32_bits(counter);
 
 	kvm_pmu_release_perf_event(pmc);
 }
@@ -289,7 +289,7 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 {
-	u64 val = __vcpu_sys_reg(vcpu, PMCR_EL0) >> ARMV8_PMU_PMCR_N_SHIFT;
+	u64 val = vcpu_sys_reg(vcpu, PMCR_EL0) >> ARMV8_PMU_PMCR_N_SHIFT;
 
 	val &= ARMV8_PMU_PMCR_N_MASK;
 	if (val == 0)
@@ -311,7 +311,7 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	struct kvm_pmc *pmc;
 
-	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) || !val)
+	if (!(vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) || !val)
 		return;
 
 	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
@@ -369,10 +369,10 @@ static u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
 {
 	u64 reg = 0;
 
-	if ((__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E)) {
-		reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
-		reg &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
-		reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
+	if ((vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E)) {
+		reg = vcpu_sys_reg(vcpu, PMOVSSET_EL0);
+		reg &= vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
+		reg &= vcpu_sys_reg(vcpu, PMINTENSET_EL1);
 		reg &= kvm_pmu_valid_counter_mask(vcpu);
 	}
 
@@ -493,7 +493,7 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
 	perf_event->attr.sample_period = period;
 	perf_event->hw.sample_period = period;
 
-	__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(idx);
+	vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(idx);
 
 	if (kvm_pmu_overflow_status(vcpu)) {
 		kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
@@ -517,11 +517,11 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	int i;
 
-	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
+	if (!(vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
 		return;
 
 	/* Weed out disabled counters */
-	val &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
+	val &= vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 
 	for (i = 0; i < ARMV8_PMU_CYCLE_IDX; i++) {
 		u64 type, reg;
@@ -530,29 +530,29 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
 			continue;
 
 		/* PMSWINC only applies to ... SW_INC! */
-		type = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
+		type = vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
 		type &= kvm_pmu_event_mask(vcpu->kvm);
 		if (type != ARMV8_PMUV3_PERFCTR_SW_INCR)
 			continue;
 
 		/* increment this even SW_INC counter */
-		reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
+		reg = vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
 		reg = lower_32_bits(reg);
-		__vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
+		vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
 
 		if (reg) /* no overflow on the low part */
 			continue;
 
 		if (kvm_pmu_pmc_is_chained(&pmu->pmc[i])) {
 			/* increment the high counter */
-			reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i + 1) + 1;
+			reg = vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i + 1) + 1;
 			reg = lower_32_bits(reg);
-			__vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i + 1) = reg;
+			vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i + 1) = reg;
 			if (!reg) /* mark overflow on the high counter */
-				__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i + 1);
+				vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i + 1);
 		} else {
 			/* mark overflow on low counter */
-			__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i);
+			vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i);
 		}
 	}
 }
@@ -569,7 +569,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 
 	if (val & ARMV8_PMU_PMCR_E) {
 		kvm_pmu_enable_counter_mask(vcpu,
-		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask);
+		       vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask);
 	} else {
 		kvm_pmu_disable_counter_mask(vcpu, mask);
 	}
@@ -586,8 +586,8 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 
 static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
 {
-	return (__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) &&
-	       (__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & BIT(select_idx));
+	return (vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) &&
+	       (vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & BIT(select_idx));
 }
 
 /**
@@ -612,7 +612,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 
 	reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
 	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + pmc->idx;
-	data = __vcpu_sys_reg(vcpu, reg);
+	data = vcpu_sys_reg(vcpu, reg);
 
 	kvm_pmu_stop_counter(vcpu, pmc);
 	if (pmc->idx == ARMV8_PMU_CYCLE_IDX)
@@ -734,7 +734,7 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
 	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
 
-	__vcpu_sys_reg(vcpu, reg) = data & mask;
+	vcpu_sys_reg(vcpu, reg) = data & mask;
 
 	kvm_pmu_update_pmc_chained(vcpu, select_idx);
 	kvm_pmu_create_perf_event(vcpu, select_idx);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f6f126eb6ac1..a3c6419f1df6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -76,7 +76,7 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 	    __vcpu_read_sys_reg_from_cpu(reg, &val))
 		return val;
 
-	return __vcpu_sys_reg(vcpu, reg);
+	return vcpu_sys_reg(vcpu, reg);
 }
 
 void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
@@ -85,7 +85,7 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 	    __vcpu_write_sys_reg_to_cpu(val, reg))
 		return;
 
-	 __vcpu_sys_reg(vcpu, reg) = val;
+	 vcpu_sys_reg(vcpu, reg) = val;
 }
 
 /* 3 bits per cache level, as per CLIDR, but non-existent caches always 0 */
@@ -620,12 +620,12 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	       | (ARMV8_PMU_PMCR_MASK & 0xdecafbad)) & (~ARMV8_PMU_PMCR_E);
 	if (!system_supports_32bit_el0())
 		val |= ARMV8_PMU_PMCR_LC;
-	__vcpu_sys_reg(vcpu, r->reg) = val;
+	vcpu_sys_reg(vcpu, r->reg) = val;
 }
 
 static bool check_pmu_access_disabled(struct kvm_vcpu *vcpu, u64 flags)
 {
-	u64 reg = __vcpu_sys_reg(vcpu, PMUSERENR_EL0);
+	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
 	bool enabled = (reg & flags) || vcpu_mode_priv(vcpu);
 
 	if (!enabled)
@@ -664,17 +664,17 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 	if (p->is_write) {
 		/* Only update writeable bits of PMCR */
-		val = __vcpu_sys_reg(vcpu, PMCR_EL0);
+		val = vcpu_sys_reg(vcpu, PMCR_EL0);
 		val &= ~ARMV8_PMU_PMCR_MASK;
 		val |= p->regval & ARMV8_PMU_PMCR_MASK;
 		if (!system_supports_32bit_el0())
 			val |= ARMV8_PMU_PMCR_LC;
-		__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
+		vcpu_sys_reg(vcpu, PMCR_EL0) = val;
 		kvm_pmu_handle_pmcr(vcpu, val);
 		kvm_vcpu_pmu_restore_guest(vcpu);
 	} else {
 		/* PMCR.P & PMCR.C are RAZ */
-		val = __vcpu_sys_reg(vcpu, PMCR_EL0)
+		val = vcpu_sys_reg(vcpu, PMCR_EL0)
 		      & ~(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C);
 		p->regval = val;
 	}
@@ -689,10 +689,10 @@ static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		return false;
 
 	if (p->is_write)
-		__vcpu_sys_reg(vcpu, PMSELR_EL0) = p->regval;
+		vcpu_sys_reg(vcpu, PMSELR_EL0) = p->regval;
 	else
 		/* return PMSELR.SEL field */
-		p->regval = __vcpu_sys_reg(vcpu, PMSELR_EL0)
+		p->regval = vcpu_sys_reg(vcpu, PMSELR_EL0)
 			    & ARMV8_PMU_COUNTER_MASK;
 
 	return true;
@@ -723,7 +723,7 @@ static bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
 {
 	u64 pmcr, val;
 
-	pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
+	pmcr = vcpu_sys_reg(vcpu, PMCR_EL0);
 	val = (pmcr >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
 	if (idx >= val && idx != ARMV8_PMU_CYCLE_IDX) {
 		kvm_inject_undefined(vcpu);
@@ -745,7 +745,7 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 			if (pmu_access_event_counter_el0_disabled(vcpu))
 				return false;
 
-			idx = __vcpu_sys_reg(vcpu, PMSELR_EL0)
+			idx = vcpu_sys_reg(vcpu, PMSELR_EL0)
 			      & ARMV8_PMU_COUNTER_MASK;
 		} else if (r->Op2 == 0) {
 			/* PMCCNTR_EL0 */
@@ -796,7 +796,7 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 	if (r->CRn == 9 && r->CRm == 13 && r->Op2 == 1) {
 		/* PMXEVTYPER_EL0 */
-		idx = __vcpu_sys_reg(vcpu, PMSELR_EL0) & ARMV8_PMU_COUNTER_MASK;
+		idx = vcpu_sys_reg(vcpu, PMSELR_EL0) & ARMV8_PMU_COUNTER_MASK;
 		reg = PMEVTYPER0_EL0 + idx;
 	} else if (r->CRn == 14 && (r->CRm & 12) == 12) {
 		idx = ((r->CRm & 3) << 3) | (r->Op2 & 7);
@@ -814,10 +814,10 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 	if (p->is_write) {
 		kvm_pmu_set_counter_event_type(vcpu, p->regval, idx);
-		__vcpu_sys_reg(vcpu, reg) = p->regval & ARMV8_PMU_EVTYPE_MASK;
+		vcpu_sys_reg(vcpu, reg) = p->regval & ARMV8_PMU_EVTYPE_MASK;
 		kvm_vcpu_pmu_restore_guest(vcpu);
 	} else {
-		p->regval = __vcpu_sys_reg(vcpu, reg) & ARMV8_PMU_EVTYPE_MASK;
+		p->regval = vcpu_sys_reg(vcpu, reg) & ARMV8_PMU_EVTYPE_MASK;
 	}
 
 	return true;
@@ -836,16 +836,16 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		val = p->regval & mask;
 		if (r->Op2 & 0x1) {
 			/* accessing PMCNTENSET_EL0 */
-			__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) |= val;
+			vcpu_sys_reg(vcpu, PMCNTENSET_EL0) |= val;
 			kvm_pmu_enable_counter_mask(vcpu, val);
 			kvm_vcpu_pmu_restore_guest(vcpu);
 		} else {
 			/* accessing PMCNTENCLR_EL0 */
-			__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) &= ~val;
+			vcpu_sys_reg(vcpu, PMCNTENSET_EL0) &= ~val;
 			kvm_pmu_disable_counter_mask(vcpu, val);
 		}
 	} else {
-		p->regval = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
+		p->regval = vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
 	}
 
 	return true;
@@ -864,12 +864,12 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 		if (r->Op2 & 0x1)
 			/* accessing PMINTENSET_EL1 */
-			__vcpu_sys_reg(vcpu, PMINTENSET_EL1) |= val;
+			vcpu_sys_reg(vcpu, PMINTENSET_EL1) |= val;
 		else
 			/* accessing PMINTENCLR_EL1 */
-			__vcpu_sys_reg(vcpu, PMINTENSET_EL1) &= ~val;
+			vcpu_sys_reg(vcpu, PMINTENSET_EL1) &= ~val;
 	} else {
-		p->regval = __vcpu_sys_reg(vcpu, PMINTENSET_EL1) & mask;
+		p->regval = vcpu_sys_reg(vcpu, PMINTENSET_EL1) & mask;
 	}
 
 	return true;
@@ -886,12 +886,12 @@ static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (p->is_write) {
 		if (r->CRm & 0x2)
 			/* accessing PMOVSSET_EL0 */
-			__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= (p->regval & mask);
+			vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= (p->regval & mask);
 		else
 			/* accessing PMOVSCLR_EL0 */
-			__vcpu_sys_reg(vcpu, PMOVSSET_EL0) &= ~(p->regval & mask);
+			vcpu_sys_reg(vcpu, PMOVSSET_EL0) &= ~(p->regval & mask);
 	} else {
-		p->regval = __vcpu_sys_reg(vcpu, PMOVSSET_EL0) & mask;
+		p->regval = vcpu_sys_reg(vcpu, PMOVSSET_EL0) & mask;
 	}
 
 	return true;
@@ -922,10 +922,10 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			return false;
 		}
 
-		__vcpu_sys_reg(vcpu, PMUSERENR_EL0) =
+		vcpu_sys_reg(vcpu, PMUSERENR_EL0) =
 			       p->regval & ARMV8_PMU_USERENR_MASK;
 	} else {
-		p->regval = __vcpu_sys_reg(vcpu, PMUSERENR_EL0)
+		p->regval = vcpu_sys_reg(vcpu, PMUSERENR_EL0)
 			    & ARMV8_PMU_USERENR_MASK;
 	}
 
@@ -2635,7 +2635,7 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if (r->get_user)
 		return (r->get_user)(vcpu, r, reg, uaddr);
 
-	return reg_to_user(uaddr, &__vcpu_sys_reg(vcpu, r->reg), reg->id);
+	return reg_to_user(uaddr, &vcpu_sys_reg(vcpu, r->reg), reg->id);
 }
 
 int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
@@ -2660,7 +2660,7 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 	if (r->set_user)
 		return (r->set_user)(vcpu, r, reg, uaddr);
 
-	return reg_from_user(&__vcpu_sys_reg(vcpu, r->reg), uaddr, reg->id);
+	return reg_from_user(&vcpu_sys_reg(vcpu, r->reg), uaddr, reg->id);
 }
 
 static unsigned int num_demux_regs(void)
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 9d0621417c2a..7840d657ab09 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -105,14 +105,14 @@ static inline void reset_unknown(struct kvm_vcpu *vcpu,
 {
 	BUG_ON(!r->reg);
 	BUG_ON(r->reg >= NR_SYS_REGS);
-	__vcpu_sys_reg(vcpu, r->reg) = 0x1de7ec7edbadc0deULL;
+	vcpu_sys_reg(vcpu, r->reg) = 0x1de7ec7edbadc0deULL;
 }
 
 static inline void reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	BUG_ON(!r->reg);
 	BUG_ON(r->reg >= NR_SYS_REGS);
-	__vcpu_sys_reg(vcpu, r->reg) = r->val;
+	vcpu_sys_reg(vcpu, r->reg) = r->val;
 }
 
 static inline bool sysreg_hidden(const struct kvm_vcpu *vcpu,
-- 
2.32.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
