From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v4 05/21] KVM: ARM64: Add reset and access handlers for PMSELR register
Date: Fri, 30 Oct 2015 14:21:47 +0800
Message-ID: <1446186123-11548-6-git-send-email-zhaoshenglong@huawei.com>
References: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

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
index 5b591d6..35d232e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -707,7 +707,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  trap_raz_wi },
 	/* PMSELR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b101),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_unknown, PMSELR_EL0 },
 	/* PMCEID0_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b110),
 	  trap_raz_wi },
@@ -998,7 +998,8 @@ static const struct sys_reg_desc cp15_regs[] = {
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
2.0.4


