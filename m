From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v10 15/21] KVM: ARM64: Add access handler for PMUSERENR
 register
Date: Wed, 27 Jan 2016 11:51:43 +0800
Message-ID: <1453866709-20324-16-git-send-email-zhaoshenglong@huawei.com>
References: <1453866709-20324-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29EC04053F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 22:49:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dleqkTX9OmDE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2016 22:49:37 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A02740F90
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 22:49:20 -0500 (EST)
In-Reply-To: <1453866709-20324-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

This register resets as unknown in 64bit mode while it resets as zero
in 32bit mode. Here we choose to reset it as zero for consistency.

PMUSERENR_EL0 holds some bits which decide whether PMU registers can be
accessed from EL0. Add some check helpers to handle the access from EL0.

When these bits are zero, only reading PMUSERENR will trap to EL2 and
writing PMUSERENR or reading/writing other PMU registers will trap to
EL1 other than EL2 when HCR.TGE==0. To current KVM configuration
(HCR.TGE==0) there is no way to get these traps. Here we write 0xf to
physical PMUSERENR register on VM entry, so that it will trap PMU access
from EL0 to EL2. Within the register access handler we check the real
value of guest PMUSERENR register to decide whether this access is
allowed. If not allowed, return false to inject UND to guest.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/include/asm/pmu.h |   9 ++++
 arch/arm64/kvm/hyp/hyp.h     |   1 +
 arch/arm64/kvm/hyp/switch.c  |   3 ++
 arch/arm64/kvm/sys_regs.c    | 100 ++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 107 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/pmu.h b/arch/arm64/include/asm/pmu.h
index 6f14a01..eb3dc88 100644
--- a/arch/arm64/include/asm/pmu.h
+++ b/arch/arm64/include/asm/pmu.h
@@ -69,4 +69,13 @@
 #define	ARMV8_EXCLUDE_EL0	(1 << 30)
 #define	ARMV8_INCLUDE_EL2	(1 << 27)
 
+/*
+ * PMUSERENR: user enable reg
+ */
+#define ARMV8_USERENR_MASK	0xf		/* Mask for writable bits */
+#define ARMV8_USERENR_EN	(1 << 0) /* PMU regs can be accessed at EL0 */
+#define ARMV8_USERENR_SW	(1 << 1) /* PMSWINC can be written at EL0 */
+#define ARMV8_USERENR_CR	(1 << 2) /* Cycle counter can be read at EL0 */
+#define ARMV8_USERENR_ER	(1 << 3) /* Event counter can be read at EL0 */
+
 #endif /* __ASM_PMU_H */
diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
index fb27517..9a28b7bd8 100644
--- a/arch/arm64/kvm/hyp/hyp.h
+++ b/arch/arm64/kvm/hyp/hyp.h
@@ -22,6 +22,7 @@
 #include <linux/kvm_host.h>
 #include <asm/kvm_mmu.h>
 #include <asm/sysreg.h>
+#include <asm/pmu.h>
 
 #define __hyp_text __section(.hyp.text) notrace
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index ca8f5a5..1a7d679 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -37,6 +37,8 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
 	write_sysreg(1 << 15, hstr_el2);
 	write_sysreg(CPTR_EL2_TTA | CPTR_EL2_TFP, cptr_el2);
+	/* Make sure we trap PMU access from EL0 to EL2 */
+	write_sysreg(ARMV8_USERENR_MASK, pmuserenr_el0);
 	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 }
 
@@ -45,6 +47,7 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 	write_sysreg(HCR_RW, hcr_el2);
 	write_sysreg(0, hstr_el2);
 	write_sysreg(read_sysreg(mdcr_el2) & MDCR_EL2_HPMN_MASK, mdcr_el2);
+	write_sysreg(0, pmuserenr_el0);
 	write_sysreg(0, cptr_el2);
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index eefc60a..084e527 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -453,6 +453,37 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	vcpu_sys_reg(vcpu, PMCR_EL0) = val;
 }
 
+static bool pmu_access_el0_disabled(struct kvm_vcpu *vcpu)
+{
+	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
+
+	return !((reg & ARMV8_USERENR_EN) || vcpu_mode_priv(vcpu));
+}
+
+static bool pmu_write_swinc_el0_disabled(struct kvm_vcpu *vcpu)
+{
+	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
+
+	return !((reg & (ARMV8_USERENR_SW | ARMV8_USERENR_EN))
+		 || vcpu_mode_priv(vcpu));
+}
+
+static bool pmu_access_cycle_counter_el0_disabled(struct kvm_vcpu *vcpu)
+{
+	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
+
+	return !((reg & (ARMV8_USERENR_CR | ARMV8_USERENR_EN))
+		 || vcpu_mode_priv(vcpu));
+}
+
+static bool pmu_access_event_counter_el0_disabled(struct kvm_vcpu *vcpu)
+{
+	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
+
+	return !((reg & (ARMV8_USERENR_ER | ARMV8_USERENR_EN))
+		 || vcpu_mode_priv(vcpu));
+}
+
 static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
 {
@@ -461,6 +492,9 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (!kvm_arm_pmu_v3_ready(vcpu))
 		return trap_raz_wi(vcpu, p, r);
 
+	if (pmu_access_el0_disabled(vcpu))
+		return false;
+
 	if (p->is_write) {
 		/* Only update writeable bits of PMCR */
 		val = vcpu_sys_reg(vcpu, PMCR_EL0);
@@ -484,6 +518,9 @@ static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (!kvm_arm_pmu_v3_ready(vcpu))
 		return trap_raz_wi(vcpu, p, r);
 
+	if (pmu_access_event_counter_el0_disabled(vcpu))
+		return false;
+
 	if (p->is_write)
 		vcpu_sys_reg(vcpu, PMSELR_EL0) = p->regval;
 	else
@@ -501,7 +538,7 @@ static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (!kvm_arm_pmu_v3_ready(vcpu))
 		return trap_raz_wi(vcpu, p, r);
 
-	if (p->is_write)
+	if (p->is_write || pmu_access_el0_disabled(vcpu))
 		return false;
 
 	if (!(p->Op2 & 1))
@@ -534,6 +571,9 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (!kvm_arm_pmu_v3_ready(vcpu))
 		return trap_raz_wi(vcpu, p, r);
 
+	if (pmu_access_el0_disabled(vcpu))
+		return false;
+
 	if (r->CRn == 9 && r->CRm == 13 && r->Op2 == 1) {
 		/* PMXEVTYPER_EL0 */
 		idx = vcpu_sys_reg(vcpu, PMSELR_EL0) & ARMV8_COUNTER_MASK;
@@ -574,11 +614,17 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 	if (r->CRn == 9 && r->CRm == 13) {
 		if (r->Op2 == 2) {
 			/* PMXEVCNTR_EL0 */
+			if (pmu_access_event_counter_el0_disabled(vcpu))
+				return false;
+
 			idx = vcpu_sys_reg(vcpu, PMSELR_EL0)
 			      & ARMV8_COUNTER_MASK;
 			reg = PMEVCNTR0_EL0 + idx;
 		} else if (r->Op2 == 0) {
 			/* PMCCNTR_EL0 */
+			if (pmu_access_cycle_counter_el0_disabled(vcpu))
+				return false;
+
 			idx = ARMV8_CYCLE_IDX;
 			reg = PMCCNTR_EL0;
 		} else {
@@ -586,6 +632,9 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 		}
 	} else if (r->CRn == 14 && (r->CRm & 12) == 8) {
 		/* PMEVCNTRn_EL0 */
+		if (pmu_access_event_counter_el0_disabled(vcpu))
+			return false;
+
 		idx = ((r->CRm & 3) << 3) | (r->Op2 & 7);
 		reg = PMEVCNTR0_EL0 + idx;
 	} else {
@@ -596,10 +645,14 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 		return false;
 
 	val = kvm_pmu_get_counter_value(vcpu, idx);
-	if (p->is_write)
+	if (p->is_write) {
+		if (pmu_access_el0_disabled(vcpu))
+			return false;
+
 		vcpu_sys_reg(vcpu, reg) += (s64)p->regval - val;
-	else
+	} else {
 		p->regval = val;
+	}
 
 	return true;
 }
@@ -612,6 +665,9 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (!kvm_arm_pmu_v3_ready(vcpu))
 		return trap_raz_wi(vcpu, p, r);
 
+	if (pmu_access_el0_disabled(vcpu))
+		return false;
+
 	mask = kvm_pmu_valid_counter_mask(vcpu);
 	if (p->is_write) {
 		val = p->regval & mask;
@@ -639,6 +695,9 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (!kvm_arm_pmu_v3_ready(vcpu))
 		return trap_raz_wi(vcpu, p, r);
 
+	if (!vcpu_mode_priv(vcpu))
+		return false;
+
 	if (p->is_write) {
 		if (r->Op2 & 0x1)
 			/* accessing PMINTENSET_EL1 */
@@ -663,6 +722,9 @@ static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (!kvm_arm_pmu_v3_ready(vcpu))
 		return trap_raz_wi(vcpu, p, r);
 
+	if (pmu_access_el0_disabled(vcpu))
+		return false;
+
 	if (p->is_write) {
 		if (r->CRm & 0x2)
 			/* accessing PMOVSSET_EL0 */
@@ -685,6 +747,9 @@ static bool access_pmswinc(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (!kvm_arm_pmu_v3_ready(vcpu))
 		return trap_raz_wi(vcpu, p, r);
 
+	if (pmu_write_swinc_el0_disabled(vcpu))
+		return false;
+
 	if (p->is_write) {
 		mask = kvm_pmu_valid_counter_mask(vcpu);
 		kvm_pmu_software_increment(vcpu, p->regval & mask);
@@ -694,6 +759,26 @@ static bool access_pmswinc(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return false;
 }
 
+static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			     const struct sys_reg_desc *r)
+{
+	if (!kvm_arm_pmu_v3_ready(vcpu))
+		return trap_raz_wi(vcpu, p, r);
+
+	if (p->is_write) {
+		if (!vcpu_mode_priv(vcpu))
+			return false;
+
+		vcpu_sys_reg(vcpu, PMUSERENR_EL0) = p->regval
+						    & ARMV8_USERENR_MASK;
+	} else {
+		p->regval = vcpu_sys_reg(vcpu, PMUSERENR_EL0)
+			    & ARMV8_USERENR_MASK;
+	}
+
+	return true;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	/* DBGBVRn_EL1 */						\
@@ -923,9 +1008,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	/* PMXEVCNTR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b010),
 	  access_pmu_evcntr },
-	/* PMUSERENR_EL0 */
+	/* PMUSERENR_EL0
+	 * This register resets as unknown in 64bit mode while it resets as zero
+	 * in 32bit mode. Here we choose to reset it as zero for consistency.
+	 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b000),
-	  trap_raz_wi },
+	  access_pmuserenr, reset_val, PMUSERENR_EL0, 0 },
 	/* PMOVSSET_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b011),
 	  access_pmovs, reset_unknown, PMOVSSET_EL0 },
@@ -1250,7 +1338,7 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), access_pmu_evcntr },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), access_pmu_evtyper },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), access_pmu_evcntr },
-	{ Op1( 0), CRn( 9), CRm(14), Op2( 0), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(14), Op2( 0), access_pmuserenr },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), access_pminten },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), access_pminten },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 3), access_pmovs },
-- 
2.0.4
