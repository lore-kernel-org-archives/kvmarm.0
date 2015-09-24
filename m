From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: [PATCH v3 14/20] KVM: ARM64: Add reset and access handlers for PMUSERENR register
Date: Thu, 24 Sep 2015 15:31:19 -0700
Message-ID: <1443133885-3366-15-git-send-email-shannon.zhao@linaro.org>
References: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, will.deacon@arm.com, wei@redhat.com, alex.bennee@linaro.org, peter.huangpeng@huawei.com, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

The reset value of PMUSERENR_EL0 is UNKNOWN, use reset_unknown. While
the reset value of PMUSERENR is zero, use reset_val_cp15 with zero for
its reset handler.

Add a helper for CP15 registers reset to specified value.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 5 +++--
 arch/arm64/kvm/sys_regs.h | 8 ++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6f76dc8..749e1e2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -805,7 +805,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmu_regs, reset_unknown, PMXEVCNTR_EL0 },
 	/* PMUSERENR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b000),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_unknown, PMUSERENR_EL0 },
 	/* PMOVSSET_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b011),
 	  access_pmu_regs, reset_unknown, PMOVSSET_EL0 },
@@ -1156,7 +1156,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 	  reset_unknown_cp15, c9_PMXEVTYPER },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), access_pmu_cp15_regs,
 	  reset_unknown_cp15, c9_PMXEVCNTR },
-	{ Op1( 0), CRn( 9), CRm(14), Op2( 0), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(14), Op2( 0), access_pmu_cp15_regs,
+	  reset_val_cp15,  c9_PMUSERENR, 0 },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), access_pmu_cp15_regs,
 	  reset_unknown_cp15, c9_PMINTENSET },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), access_pmu_cp15_regs,
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 8afeff7..aba997d 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -125,6 +125,14 @@ static inline void reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r
 	vcpu_sys_reg(vcpu, r->reg) = r->val;
 }
 
+static inline void reset_val_cp15(struct kvm_vcpu *vcpu,
+				  const struct sys_reg_desc *r)
+{
+	BUG_ON(!r->reg);
+	BUG_ON(r->reg >= NR_SYS_REGS);
+	vcpu_cp15(vcpu, r->reg) = r->val;
+}
+
 static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
 			      const struct sys_reg_desc *i2)
 {
-- 
2.1.4

