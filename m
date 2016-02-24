From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v13 03/20] KVM: ARM64: Add access handler for PMCR register
Date: Wed, 24 Feb 2016 13:08:23 +0800
Message-ID: <1456290520-10012-4-git-send-email-zhaoshenglong@huawei.com>
References: <1456290520-10012-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26B2D412ED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2016 00:03:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LFQ7MPJGs6N3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Feb 2016 00:03:30 -0500 (EST)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [119.145.14.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2163A412F3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2016 00:03:28 -0500 (EST)
In-Reply-To: <1456290520-10012-1-git-send-email-zhaoshenglong@huawei.com>
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

Add reset handler which gets host value of PMCR_EL0 and make writable
bits architecturally UNKNOWN except PMCR.E which is zero. Add an access
handler for PMCR.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/sys_regs.c         | 42 +++++++++++++++++++++++++++++++++++++--
 include/kvm/arm_pmu.h             |  4 ++++
 3 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6f0241f..1f3ca98 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -115,6 +115,9 @@ enum vcpu_sysreg {
 	MDSCR_EL1,	/* Monitor Debug System Control Register */
 	MDCCINT_EL1,	/* Monitor Debug Comms Channel Interrupt Enable Reg */
 
+	/* Performance Monitors Registers */
+	PMCR_EL0,	/* Control Register */
+
 	/* 32bit specific registers. Keep them at the end of the range */
 	DACR32_EL2,	/* Domain Access Control Register */
 	IFSR32_EL2,	/* Instruction Fault Status Register */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2e90371..e88ae2d 100644
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
