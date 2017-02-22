From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 3/8] arm64: KVM: Refactor pmu_*_el0_disabled
Date: Wed, 22 Feb 2017 11:47:23 +0000
Message-ID: <20170222114728.2472-4-marc.zyngier@arm.com>
References: <20170222114728.2472-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170222114728.2472-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Shannon Zhao <shannon.zhao@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

There is a lot of duplication in the pmu_*_el0_disabled helpers,
and as we're going to modify them shortly, let's move all the
common stuff in a single function.

No functionnal change.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 33bad02c0a00..0ebf27f40f98 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -460,35 +460,32 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	vcpu_sys_reg(vcpu, PMCR_EL0) = val;
 }
 
-static bool pmu_access_el0_disabled(struct kvm_vcpu *vcpu)
+static bool check_disabled(struct kvm_vcpu *vcpu, u64 flags)
 {
 	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
+	bool cond = (reg & flags) || vcpu_mode_priv(vcpu);
 
-	return !((reg & ARMV8_PMU_USERENR_EN) || vcpu_mode_priv(vcpu));
+	return !cond;
 }
 
-static bool pmu_write_swinc_el0_disabled(struct kvm_vcpu *vcpu)
+static bool pmu_access_el0_disabled(struct kvm_vcpu *vcpu)
 {
-	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
+	return check_disabled(vcpu, ARMV8_PMU_USERENR_EN);
+}
 
-	return !((reg & (ARMV8_PMU_USERENR_SW | ARMV8_PMU_USERENR_EN))
-		 || vcpu_mode_priv(vcpu));
+static bool pmu_write_swinc_el0_disabled(struct kvm_vcpu *vcpu)
+{
+	return check_disabled(vcpu, ARMV8_PMU_USERENR_SW | ARMV8_PMU_USERENR_EN);
 }
 
 static bool pmu_access_cycle_counter_el0_disabled(struct kvm_vcpu *vcpu)
 {
-	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
-
-	return !((reg & (ARMV8_PMU_USERENR_CR | ARMV8_PMU_USERENR_EN))
-		 || vcpu_mode_priv(vcpu));
+	return check_disabled(vcpu, ARMV8_PMU_USERENR_CR | ARMV8_PMU_USERENR_EN);
 }
 
 static bool pmu_access_event_counter_el0_disabled(struct kvm_vcpu *vcpu)
 {
-	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
-
-	return !((reg & (ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_EN))
-		 || vcpu_mode_priv(vcpu));
+	return check_disabled(vcpu, ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_EN);
 }
 
 static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
-- 
2.11.0
