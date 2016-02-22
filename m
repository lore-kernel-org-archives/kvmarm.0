From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v12 08/21] KVM: ARM64: Add access handler for event type
 register
Date: Mon, 22 Feb 2016 17:37:44 +0800
Message-ID: <1456133877-9584-9-git-send-email-zhaoshenglong@huawei.com>
References: <1456133877-9584-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D168E496C2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Feb 2016 04:34:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wop08Of43eKP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Feb 2016 04:34:10 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 32A1B48912
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Feb 2016 04:34:07 -0500 (EST)
In-Reply-To: <1456133877-9584-1-git-send-email-zhaoshenglong@huawei.com>
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
Cc: kvm@vger.kernel.org, will.deacon@arm.com, shannon.zhao@linaro.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

These kind of registers include PMEVTYPERn, PMCCFILTR and PMXEVTYPER
which is mapped to PMEVTYPERn or PMCCFILTR.

The access handler translates all aarch32 register offsets to aarch64
ones and uses vcpu_sys_reg() to access their values to avoid taking care
of big endian.

When writing to these registers, create a perf_event for the selected
event type.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/sys_regs.c | 140 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 138 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 27afa0b..7c6212a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -513,6 +513,54 @@ static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
+{
+	u64 pmcr, val;
+
+	pmcr = vcpu_sys_reg(vcpu, PMCR_EL0);
+	val = (pmcr >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
+	if (idx >= val && idx != ARMV8_PMU_CYCLE_IDX)
+		return false;
+
+	return true;
+}
+
+static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			       const struct sys_reg_desc *r)
+{
+	u64 idx, reg;
+
+	if (!kvm_arm_pmu_v3_ready(vcpu))
+		return trap_raz_wi(vcpu, p, r);
+
+	if (r->CRn == 9 && r->CRm == 13 && r->Op2 == 1) {
+		/* PMXEVTYPER_EL0 */
+		idx = vcpu_sys_reg(vcpu, PMSELR_EL0) & ARMV8_PMU_COUNTER_MASK;
+		reg = PMEVTYPER0_EL0 + idx;
+	} else if (r->CRn == 14 && (r->CRm & 12) == 12) {
+		idx = ((r->CRm & 3) << 3) | (r->Op2 & 7);
+		if (idx == ARMV8_PMU_CYCLE_IDX)
+			reg = PMCCFILTR_EL0;
+		else
+			/* PMEVTYPERn_EL0 */
+			reg = PMEVTYPER0_EL0 + idx;
+	} else {
+		BUG();
+	}
+
+	if (!pmu_counter_idx_valid(vcpu, idx))
+		return false;
+
+	if (p->is_write) {
+		kvm_pmu_set_counter_event_type(vcpu, p->regval, idx);
+		vcpu_sys_reg(vcpu, reg) = p->regval & ARMV8_PMU_EVTYPE_MASK;
+	} else {
+		p->regval = vcpu_sys_reg(vcpu, reg) & ARMV8_PMU_EVTYPE_MASK;
+	}
+
+	return true;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	/* DBGBVRn_EL1 */						\
@@ -528,6 +576,13 @@ static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b111),	\
 	  trap_wcr, reset_wcr, n, 0,  get_wcr, set_wcr }
 
+/* Macro to expand the PMEVTYPERn_EL0 register */
+#define PMU_PMEVTYPER_EL0(n)						\
+	/* PMEVTYPERn_EL0 */						\
+	{ Op0(0b11), Op1(0b011), CRn(0b1110),				\
+	  CRm((0b1100 | (((n) >> 3) & 0x3))), Op2(((n) & 0x7)),		\
+	  access_pmu_evtyper, reset_unknown, (PMEVTYPER0_EL0 + n), }
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -724,7 +779,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  trap_raz_wi },
 	/* PMXEVTYPER_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b001),
-	  trap_raz_wi },
+	  access_pmu_evtyper },
 	/* PMXEVCNTR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b010),
 	  trap_raz_wi },
@@ -742,6 +797,45 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ Op0(0b11), Op1(0b011), CRn(0b1101), CRm(0b0000), Op2(0b011),
 	  NULL, reset_unknown, TPIDRRO_EL0 },
 
+	/* PMEVTYPERn_EL0 */
+	PMU_PMEVTYPER_EL0(0),
+	PMU_PMEVTYPER_EL0(1),
+	PMU_PMEVTYPER_EL0(2),
+	PMU_PMEVTYPER_EL0(3),
+	PMU_PMEVTYPER_EL0(4),
+	PMU_PMEVTYPER_EL0(5),
+	PMU_PMEVTYPER_EL0(6),
+	PMU_PMEVTYPER_EL0(7),
+	PMU_PMEVTYPER_EL0(8),
+	PMU_PMEVTYPER_EL0(9),
+	PMU_PMEVTYPER_EL0(10),
+	PMU_PMEVTYPER_EL0(11),
+	PMU_PMEVTYPER_EL0(12),
+	PMU_PMEVTYPER_EL0(13),
+	PMU_PMEVTYPER_EL0(14),
+	PMU_PMEVTYPER_EL0(15),
+	PMU_PMEVTYPER_EL0(16),
+	PMU_PMEVTYPER_EL0(17),
+	PMU_PMEVTYPER_EL0(18),
+	PMU_PMEVTYPER_EL0(19),
+	PMU_PMEVTYPER_EL0(20),
+	PMU_PMEVTYPER_EL0(21),
+	PMU_PMEVTYPER_EL0(22),
+	PMU_PMEVTYPER_EL0(23),
+	PMU_PMEVTYPER_EL0(24),
+	PMU_PMEVTYPER_EL0(25),
+	PMU_PMEVTYPER_EL0(26),
+	PMU_PMEVTYPER_EL0(27),
+	PMU_PMEVTYPER_EL0(28),
+	PMU_PMEVTYPER_EL0(29),
+	PMU_PMEVTYPER_EL0(30),
+	/* PMCCFILTR_EL0
+	 * This register resets as unknown in 64bit mode while it resets as zero
+	 * in 32bit mode. Here we choose to reset it as zero for consistency.
+	 */
+	{ Op0(0b11), Op1(0b011), CRn(0b1110), CRm(0b1111), Op2(0b111),
+	  access_pmu_evtyper, reset_val, PMCCFILTR_EL0, 0 },
+
 	/* DACR32_EL2 */
 	{ Op0(0b11), Op1(0b100), CRn(0b0011), CRm(0b0000), Op2(0b000),
 	  NULL, reset_unknown, DACR32_EL2 },
@@ -931,6 +1025,13 @@ static const struct sys_reg_desc cp14_64_regs[] = {
 	{ Op1( 0), CRm( 2), .access = trap_raz_wi },
 };
 
+/* Macro to expand the PMEVTYPERn register */
+#define PMU_PMEVTYPER(n)						\
+	/* PMEVTYPERn */						\
+	{ Op1(0), CRn(0b1110),						\
+	  CRm((0b1100 | (((n) >> 3) & 0x3))), Op2(((n) & 0x7)),		\
+	  access_pmu_evtyper }
+
 /*
  * Trapped cp15 registers. TTBR0/TTBR1 get a double encoding,
  * depending on the way they are accessed (as a 32bit or a 64bit
@@ -967,7 +1068,7 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmceid },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmceid },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), trap_raz_wi },
-	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), access_pmu_evtyper },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 0), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), trap_raz_wi },
@@ -982,6 +1083,41 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn(12), CRm(12), Op2( 5), trap_raz_wi },
 
 	{ Op1( 0), CRn(13), CRm( 0), Op2( 1), access_vm_reg, NULL, c13_CID },
+
+	/* PMEVTYPERn */
+	PMU_PMEVTYPER(0),
+	PMU_PMEVTYPER(1),
+	PMU_PMEVTYPER(2),
+	PMU_PMEVTYPER(3),
+	PMU_PMEVTYPER(4),
+	PMU_PMEVTYPER(5),
+	PMU_PMEVTYPER(6),
+	PMU_PMEVTYPER(7),
+	PMU_PMEVTYPER(8),
+	PMU_PMEVTYPER(9),
+	PMU_PMEVTYPER(10),
+	PMU_PMEVTYPER(11),
+	PMU_PMEVTYPER(12),
+	PMU_PMEVTYPER(13),
+	PMU_PMEVTYPER(14),
+	PMU_PMEVTYPER(15),
+	PMU_PMEVTYPER(16),
+	PMU_PMEVTYPER(17),
+	PMU_PMEVTYPER(18),
+	PMU_PMEVTYPER(19),
+	PMU_PMEVTYPER(20),
+	PMU_PMEVTYPER(21),
+	PMU_PMEVTYPER(22),
+	PMU_PMEVTYPER(23),
+	PMU_PMEVTYPER(24),
+	PMU_PMEVTYPER(25),
+	PMU_PMEVTYPER(26),
+	PMU_PMEVTYPER(27),
+	PMU_PMEVTYPER(28),
+	PMU_PMEVTYPER(29),
+	PMU_PMEVTYPER(30),
+	/* PMCCFILTR */
+	{ Op1(0), CRn(14), CRm(15), Op2(7), access_pmu_evtyper },
 };
 
 static const struct sys_reg_desc cp15_64_regs[] = {
-- 
2.0.4
