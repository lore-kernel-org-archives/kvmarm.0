From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v4 15/21] KVM: ARM64: Add reset and access handlers for PMSWINC register
Date: Fri, 30 Oct 2015 14:21:57 +0800
Message-ID: <1446186123-11548-16-git-send-email-zhaoshenglong@huawei.com>
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

Add access handler which emulates writing and reading PMSWINC
register and add support for creating software increment event.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 18 +++++++++++++++-
 include/kvm/arm_pmu.h     |  2 ++
 virt/kvm/arm/pmu.c        | 55 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c44c8e1..c86f8dd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -567,6 +567,11 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 			vcpu_sys_reg(vcpu, PMOVSSET_EL0) &= ~val;
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
@@ -596,6 +601,8 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 			*vcpu_reg(vcpu, p->Rt) = val;
 			break;
 		}
+		case PMSWINC_EL0:
+			return read_zero(vcpu, p);
 		case PMCR_EL0: {
 			/* PMCR.P & PMCR.C are RAZ */
 			val = vcpu_sys_reg(vcpu, r->reg)
@@ -808,7 +815,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmu_regs, reset_unknown, PMOVSCLR_EL0 },
 	/* PMSWINC_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b100),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_unknown, PMSWINC_EL0 },
 	/* PMSELR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b101),
 	  access_pmu_regs, reset_unknown, PMSELR_EL0 },
@@ -1113,6 +1120,11 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 			vcpu_cp15(vcpu, c9_PMOVSSET) &= ~val;
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
@@ -1142,6 +1154,8 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 			*vcpu_reg(vcpu, p->Rt) = val;
 			break;
 		}
+		case c9_PMSWINC:
+			return read_zero(vcpu, p);
 		case c9_PMCR: {
 			/* PMCR.P & PMCR.C are RAZ */
 			val = vcpu_cp15(vcpu, r->reg)
@@ -1194,6 +1208,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 	  reset_unknown_cp15, c9_PMCNTENCLR },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), access_pmu_cp15_regs,
 	  reset_unknown_cp15, c9_PMOVSCLR },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 4), access_pmu_cp15_regs,
+	  reset_unknown_cp15, c9_PMSWINC },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmu_cp15_regs,
 	  reset_unknown_cp15, c9_PMSELR },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmu_cp15_regs,
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index ff17578..d7de7f1 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -44,6 +44,7 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val);
 void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val, bool all_enable);
 void kvm_pmu_overflow_clear(struct kvm_vcpu *vcpu, u32 val, u32 reg);
 void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u32 val);
+void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u32 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 				    u32 select_idx);
 #else
@@ -55,6 +56,7 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val) {}
 void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val, bool all_enable) {}
 void kvm_pmu_overflow_clear(struct kvm_vcpu *vcpu, u32 val, u32 reg) {}
 void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u32 val) {}
+void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u32 val) {}
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 				    u32 select_idx) {}
 #endif
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 5761386..ae21089 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -151,6 +151,57 @@ void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u32 val)
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
+	for (i = 0; i < ARMV8_MAX_COUNTERS; i++) {
+		if ((val >> i) & 0x1) {
+			if (!vcpu_mode_is_32bit(vcpu)) {
+				type = vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i)
+				       & ARMV8_EVTYPE_EVENT;
+				enable = vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
+				if ((type == 0) && ((enable >> i) & 0x1)) {
+					vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i)++;
+					reg = vcpu_sys_reg(vcpu,
+							   PMEVCNTR0_EL0 + i);
+					if ((reg & 0xFFFFFFFF) == 0) {
+						__set_bit(i,
+			    (unsigned long *)&vcpu_sys_reg(vcpu, PMOVSSET_EL0));
+						__set_bit(i,
+			    (unsigned long *)&vcpu_sys_reg(vcpu, PMOVSCLR_EL0));
+						kvm_pmu_overflow_set(vcpu,
+					      vcpu_sys_reg(vcpu, PMOVSSET_EL0));
+					}
+				}
+			} else {
+				type = vcpu_cp15(vcpu, c14_PMEVTYPER0 + i)
+				       & ARMV8_EVTYPE_EVENT;
+				enable = vcpu_cp15(vcpu, c9_PMCNTENSET);
+				if ((type == 0) && ((enable >> i) & 0x1)) {
+					vcpu_cp15(vcpu, c14_PMEVCNTR0 + i)++;
+					reg = vcpu_cp15(vcpu,
+							c14_PMEVCNTR0 + i);
+					if ((reg & 0xFFFFFFFF) == 0) {
+						__set_bit(i,
+				(unsigned long *)&vcpu_cp15(vcpu, c9_PMOVSSET));
+						__set_bit(i,
+				(unsigned long *)&vcpu_cp15(vcpu, c9_PMOVSCLR));
+						kvm_pmu_overflow_set(vcpu,
+						  vcpu_cp15(vcpu, c9_PMOVSSET));
+					}
+				}
+			}
+		}
+	}
+}
+
+/**
  * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
  * @vcpu: The vcpu pointer
  * @data: The data guest writes to PMXEVTYPER_EL0
@@ -173,6 +224,10 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
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


