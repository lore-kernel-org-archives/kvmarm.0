From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v5 15/21] KVM: ARM64: Add reset and access handlers for
 PMSWINC register
Date: Thu, 3 Dec 2015 14:11:25 +0800
Message-ID: <1449123091-20252-16-git-send-email-zhaoshenglong@huawei.com>
References: <1449123091-20252-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7E87496AC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 01:14:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D8myBRQxXrH9 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2015 01:14:39 -0500 (EST)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [119.145.14.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D36D9496F5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 01:14:38 -0500 (EST)
In-Reply-To: <1449123091-20252-1-git-send-email-zhaoshenglong@huawei.com>
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

Add access handler which emulates writing and reading PMSWINC
register and add support for creating software increment event.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 18 +++++++++++++++++-
 include/kvm/arm_pmu.h     |  2 ++
 virt/kvm/arm/pmu.c        | 44 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index eb4fcf9..12f4806 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -567,6 +567,11 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 			kvm_pmu_overflow_clear(vcpu, *vcpu_reg(vcpu, p->Rt));
 			break;
 		}
+		case PMSWINC_EL0: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			kvm_pmu_software_increment(vcpu, val);
+			break;
+		}
 		case PMCR_EL0: {
 			/* Only update writeable bits of PMCR */
 			val = vcpu_sys_reg(vcpu, r->reg);
@@ -602,6 +607,8 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 			*vcpu_reg(vcpu, p->Rt) = val;
 			break;
 		}
+		case PMSWINC_EL0:
+			return read_zero(vcpu, p);
 		case PMCR_EL0: {
 			/* PMCR.P & PMCR.C are RAZ */
 			val = vcpu_sys_reg(vcpu, r->reg)
@@ -814,7 +821,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmu_regs, reset_unknown, PMOVSCLR_EL0 },
 	/* PMSWINC_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b100),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_unknown, PMSWINC_EL0 },
 	/* PMSELR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b101),
 	  access_pmu_regs, reset_unknown, PMSELR_EL0 },
@@ -1119,6 +1126,11 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 			kvm_pmu_overflow_clear(vcpu, *vcpu_reg(vcpu, p->Rt));
 			break;
 		}
+		case c9_PMSWINC: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			kvm_pmu_software_increment(vcpu, val);
+			break;
+		}
 		case c9_PMCR: {
 			/* Only update writeable bits of PMCR */
 			val = vcpu_cp15(vcpu, r->reg);
@@ -1154,6 +1166,8 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 			*vcpu_reg(vcpu, p->Rt) = val;
 			break;
 		}
+		case c9_PMSWINC:
+			return read_zero(vcpu, p);
 		case c9_PMCR: {
 			/* PMCR.P & PMCR.C are RAZ */
 			val = vcpu_cp15(vcpu, r->reg)
@@ -1206,6 +1220,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 	  NULL, c9_PMCNTENCLR },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), access_pmu_cp15_regs,
 	  NULL, c9_PMOVSCLR },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 4), access_pmu_cp15_regs,
+	  NULL, c9_PMSWINC },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmu_cp15_regs,
 	  NULL, c9_PMSELR },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmu_cp15_regs,
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 4f3154c..a54c391 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -44,6 +44,7 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val);
 void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val, bool all_enable);
 void kvm_pmu_overflow_clear(struct kvm_vcpu *vcpu, u32 val);
 void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u32 val);
+void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u32 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 				    u32 select_idx);
 #else
@@ -55,6 +56,7 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val) {}
 void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val, bool all_enable) {}
 void kvm_pmu_overflow_clear(struct kvm_vcpu *vcpu, u32 val) {}
 void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u32 val) {}
+void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u32 val) {}
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 				    u32 select_idx) {}
 #endif
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 296b4ad..d133909 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -206,6 +206,46 @@ void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u32 val)
 }
 
 /**
+ * kvm_pmu_software_increment - do software increment
+ * @vcpu: The vcpu pointer
+ * @val: the value guest writes to PMSWINC register
+ */
+void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u32 val)
+{
+	int i;
+	u32 type, enable, reg;
+
+	if (val == 0)
+		return;
+
+	for (i = 0; i < ARMV8_MAX_COUNTERS; i++) {
+		if (!((val >> i) & 0x1))
+			continue;
+		if (!vcpu_mode_is_32bit(vcpu)) {
+			type = vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i)
+			       & ARMV8_EVTYPE_EVENT;
+			enable = vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
+			if ((type == 0) && ((enable >> i) & 0x1)) {
+				vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i)++;
+				reg = vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i);
+				if ((reg & 0xFFFFFFFF) == 0)
+					kvm_pmu_overflow_set(vcpu, 1 >> i);
+			}
+		} else {
+			type = vcpu_cp15(vcpu, c14_PMEVTYPER0 + i)
+			       & ARMV8_EVTYPE_EVENT;
+			enable = vcpu_cp15(vcpu, c9_PMCNTENSET);
+			if ((type == 0) && ((enable >> i) & 0x1)) {
+				vcpu_cp15(vcpu, c14_PMEVCNTR0 + i)++;
+				reg = vcpu_cp15(vcpu, c14_PMEVCNTR0 + i);
+				if ((reg & 0xFFFFFFFF) == 0)
+					kvm_pmu_overflow_set(vcpu, 1 >> i);
+			}
+		}
+	}
+}
+
+/**
  * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
  * @vcpu: The vcpu pointer
  * @data: The data guest writes to PMXEVTYPER_EL0
@@ -228,6 +268,10 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 	kvm_pmu_stop_counter(pmc);
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
