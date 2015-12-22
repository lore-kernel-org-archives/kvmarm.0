From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v8 13/20] KVM: ARM64: Add access handler for PMSWINC register
Date: Tue, 22 Dec 2015 16:08:08 +0800
Message-ID: <1450771695-11948-14-git-send-email-zhaoshenglong@huawei.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3950348536
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2015 03:09:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9gdeDsvDK9yB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Dec 2015 03:09:50 -0500 (EST)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [119.145.14.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AF2B248532
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2015 03:09:47 -0500 (EST)
In-Reply-To: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
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

Add access handler which emulates writing and reading PMSWINC
register and add support for creating software increment event.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 18 +++++++++++++++++-
 include/kvm/arm_pmu.h     |  2 ++
 virt/kvm/arm/pmu.c        | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d61f271dd..92021dc 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -682,6 +682,21 @@ static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static bool access_pmswinc(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	u64 mask;
+
+	if (p->is_write) {
+		mask = kvm_pmu_valid_counter_mask(vcpu);
+		kvm_pmu_software_increment(vcpu, p->regval & mask);
+	} else {
+		kvm_inject_undefined(vcpu);
+	}
+
+	return true;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	/* DBGBVRn_EL1 */						\
@@ -892,7 +907,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmovs, NULL, PMOVSSET_EL0 },
 	/* PMSWINC_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b100),
-	  trap_raz_wi },
+	  access_pmswinc, reset_unknown, PMSWINC_EL0 },
 	/* PMSELR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b101),
 	  access_pmselr, reset_unknown, PMSELR_EL0 },
@@ -1231,6 +1246,7 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), access_pmcnten },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), access_pmcnten },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), access_pmovs },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 4), access_pmswinc },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmselr },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmceid },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmceid },
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 244970b..67d168c 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -40,6 +40,7 @@ u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu);
 void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val);
+void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx);
 #else
@@ -57,6 +58,7 @@ u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val) {}
 void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val) {}
 void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val) {}
+void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val) {}
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx) {}
 #endif
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index c23d57e..409f3c4 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -160,6 +160,35 @@ void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val)
 		kvm_vcpu_kick(vcpu);
 }
 
+/**
+ * kvm_pmu_software_increment - do software increment
+ * @vcpu: The vcpu pointer
+ * @val: the value guest writes to PMSWINC register
+ */
+void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
+{
+	int i;
+	u64 type, enable, reg;
+
+	if (val == 0)
+		return;
+
+	for (i = 0; i < ARMV8_CYCLE_IDX; i++) {
+		if (!(val & BIT(i)))
+			continue;
+		type = vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i)
+		       & ARMV8_EVTYPE_EVENT;
+		enable = vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
+		if ((type == 0) && (enable & BIT(i))) {
+			reg = vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
+			reg = lower_32_bits(reg);
+			vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
+			if (!reg)
+				kvm_pmu_overflow_set(vcpu, BIT(i));
+		}
+	}
+}
+
 static inline bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu,
 					      u64 select_idx)
 {
@@ -189,6 +218,10 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 	kvm_pmu_stop_counter(vcpu, pmc);
 	eventsel = data & ARMV8_EVTYPE_EVENT;
 
+	/* For software increment event it does't need to create perf event */
+	if (eventsel == 0)
+		return;
+
 	memset(&attr, 0, sizeof(struct perf_event_attr));
 	attr.type = PERF_TYPE_RAW;
 	attr.size = sizeof(attr);
-- 
2.0.4
