From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v12 04/21] KVM: ARM64: Add access handler for PMCR register
Date: Mon, 22 Feb 2016 17:37:40 +0800
Message-ID: <1456133877-9584-5-git-send-email-zhaoshenglong@huawei.com>
References: <1456133877-9584-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1456133877-9584-1-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

Add reset handler which gets host value of PMCR_EL0 and make writable
bits architecturally UNKNOWN except PMCR.E which is zero. Add an access
handler for PMCR.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/sys_regs.c | 42 ++++++++++++++++++++++++++++++++++++++++--
 include/kvm/arm_pmu.h     |  4 ++++
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index eec3598..7ee4d5e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -34,6 +34,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
 #include <asm/kvm_mmu.h>
+#include <asm/perf_event.h>
 
 #include <trace/events/kvm.h>
 
@@ -439,6 +440,43 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	vcpu_sys_reg(vcpu, MPIDR_EL1) = (1ULL << 31) | mpidr;
 }
 
+static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u64 pmcr, val;
+
+	asm volatile("mrs %0, pmcr_el0\n" : "=r" (pmcr));
+	/* Writable bits of PMCR_EL0 (ARMV8_PMU_PMCR_MASK) is reset to UNKNOWN
+	 * except PMCR.E resetting to zero.
+	 */
+	val = ((pmcr & ~ARMV8_PMU_PMCR_MASK)
+	       | (ARMV8_PMU_PMCR_MASK & 0xdecafbad)) & (~ARMV8_PMU_PMCR_E);
+	vcpu_sys_reg(vcpu, PMCR_EL0) = val;
+}
+
+static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			const struct sys_reg_desc *r)
+{
+	u64 val;
+
+	if (!kvm_arm_pmu_v3_ready(vcpu))
+		return trap_raz_wi(vcpu, p, r);
+
+	if (p->is_write) {
+		/* Only update writeable bits of PMCR */
+		val = vcpu_sys_reg(vcpu, PMCR_EL0);
+		val &= ~ARMV8_PMU_PMCR_MASK;
+		val |= p->regval & ARMV8_PMU_PMCR_MASK;
+		vcpu_sys_reg(vcpu, PMCR_EL0) = val;
+	} else {
+		/* PMCR.P & PMCR.C are RAZ */
+		val = vcpu_sys_reg(vcpu, PMCR_EL0)
+		      & ~(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C);
+		p->regval = val;
+	}
+
+	return true;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	/* DBGBVRn_EL1 */						\
@@ -623,7 +661,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* PMCR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b000),
-	  trap_raz_wi },
+	  access_pmcr, reset_pmcr, },
 	/* PMCNTENSET_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b001),
 	  trap_raz_wi },
@@ -885,7 +923,7 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 7), CRm(14), Op2( 2), access_dcsw },
 
 	/* PMU */
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 0), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 0), access_pmcr },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 3c2fd56..8157fe5 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -34,9 +34,13 @@ struct kvm_pmu {
 	struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
 	bool ready;
 };
+
+#define kvm_arm_pmu_v3_ready(v)		((v)->arch.pmu.ready)
 #else
 struct kvm_pmu {
 };
+
+#define kvm_arm_pmu_v3_ready(v)		(false)
 #endif
 
 #endif
-- 
2.0.4


