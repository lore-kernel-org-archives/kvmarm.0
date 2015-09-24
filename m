From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: [PATCH v3 05/20] KVM: ARM64: Add reset and access handlers for PMSELR register
Date: Thu, 24 Sep 2015 15:31:10 -0700
Message-ID: <1443133885-3366-6-git-send-email-shannon.zhao@linaro.org>
References: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, will.deacon@arm.com, wei@redhat.com, alex.bennee@linaro.org, peter.huangpeng@huawei.com, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Since the reset value of PMSELR_EL0 is UNKNOWN, use reset_unknown for
its reset handler. As it doesn't need to deal with the acsessing action
specially, it uses default case to emulate writing and reading PMSELR
register.

Add a helper for CP15 registers reset to UNKNOWN.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 5 +++--
 arch/arm64/kvm/sys_regs.h | 8 ++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 60c0842..f73aea9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -700,7 +700,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  trap_raz_wi },
 	/* PMSELR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b101),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_unknown, PMSELR_EL0 },
 	/* PMCEID0_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b110),
 	  trap_raz_wi },
@@ -980,7 +980,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmu_cp15_regs,
+	  reset_unknown_cp15, c9_PMSELR },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), trap_raz_wi },
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index eaa324e..8afeff7 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -110,6 +110,14 @@ static inline void reset_unknown(struct kvm_vcpu *vcpu,
 	vcpu_sys_reg(vcpu, r->reg) = 0x1de7ec7edbadc0deULL;
 }
 
+static inline void reset_unknown_cp15(struct kvm_vcpu *vcpu,
+				      const struct sys_reg_desc *r)
+{
+	BUG_ON(!r->reg);
+	BUG_ON(r->reg >= NR_COPRO_REGS);
+	vcpu_cp15(vcpu, r->reg) = 0xdecafbad;
+}
+
 static inline void reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	BUG_ON(!r->reg);
-- 
2.1.4

