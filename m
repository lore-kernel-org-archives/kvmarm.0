From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v7 12/19] KVM: ARM64: Add access handler for PMOVSSET and PMOVSCLR register
Date: Tue, 15 Dec 2015 16:49:32 +0800
Message-ID: <1450169379-12336-13-git-send-email-zhaoshenglong@huawei.com>
References: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

Since the reset value of PMOVSSET and PMOVSCLR is UNKNOWN, use
reset_unknown for its reset handler. Add a handler to emulate writing
PMOVSSET or PMOVSCLR register.

When writing non-zero value to PMOVSSET, pend PMU interrupt.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 28 +++++++++++++++++++++++++---
 include/kvm/arm_pmu.h     |  2 ++
 virt/kvm/arm/pmu.c        | 20 ++++++++++++++++++++
 3 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 594e53f..d1926c4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -669,6 +669,27 @@ static bool access_pmintenset(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static bool access_pmovsset(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
+
+	if (p->is_write) {
+		if (r->CRm & 0x2) {
+			/* accessing PMOVSSET_EL0 */
+			kvm_pmu_overflow_set(vcpu, p->regval & mask);
+		} else {
+			/* accessing PMOVSCLR_EL0 */
+			vcpu_sys_reg(vcpu, r->reg) &= mask;
+			vcpu_sys_reg(vcpu, r->reg) &= ~p->regval;
+		}
+	} else {
+		p->regval = vcpu_sys_reg(vcpu, r->reg) & mask;
+	}
+
+	return true;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	/* DBGBVRn_EL1 */						\
@@ -876,7 +897,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmcntenset, NULL, PMCNTENSET_EL0 },
 	/* PMOVSCLR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b011),
-	  trap_raz_wi },
+	  access_pmovsset, NULL, PMOVSSET_EL0 },
 	/* PMSWINC_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b100),
 	  trap_raz_wi },
@@ -903,7 +924,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  trap_raz_wi },
 	/* PMOVSSET_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b011),
-	  trap_raz_wi },
+	  access_pmovsset, reset_unknown, PMOVSSET_EL0 },
 
 	/* TPIDR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1101), CRm(0b0000), Op2(0b010),
@@ -1217,7 +1238,7 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 0), access_pmcr },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), access_pmcntenset },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), access_pmcntenset },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), access_pmovsset },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmselr },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmceid },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmceid },
@@ -1227,6 +1248,7 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 0), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), access_pmintenset },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), access_pmintenset },
+	{ Op1( 0), CRn( 9), CRm(14), Op2( 3), access_pmovsset },
 
 	{ Op1( 0), CRn(10), CRm( 2), Op2( 0), access_vm_reg, NULL, c10_PRRR },
 	{ Op1( 0), CRn(10), CRm( 2), Op2( 1), access_vm_reg, NULL, c10_NMRR },
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 43c4117..93aea6a 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -38,6 +38,7 @@ struct kvm_pmu {
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
 void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val);
+void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx);
 #else
@@ -50,6 +51,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
 }
 void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val) {}
 void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val) {}
+void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val) {}
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx) {}
 #endif
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 94bff0e..861471d 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -130,6 +130,26 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val)
 }
 
 /**
+ * kvm_pmu_overflow_set - set PMU overflow interrupt
+ * @vcpu: The vcpu pointer
+ * @val: the value guest writes to PMOVSSET register
+ */
+void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val)
+{
+	u64 reg;
+
+	if (val == 0)
+		return;
+
+	vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= val;
+	reg = vcpu_sys_reg(vcpu, PMOVSSET_EL0)
+	      & vcpu_sys_reg(vcpu, PMCNTENSET_EL0)
+	      & vcpu_sys_reg(vcpu, PMINTENSET_EL1);
+	if (reg != 0)
+		kvm_vcpu_kick(vcpu);
+}
+
+/**
  * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
  * @vcpu: The vcpu pointer
  * @data: The data guest writes to PMXEVTYPER_EL0
-- 
2.0.4


