From: Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 05/13] arm64: KVM: add access handler for SPE system registers
Date: Thu, 28 Feb 2019 16:07:27 +0000
Message-ID: <20190228160737.3323-6-sudeep.holla@arm.com>
References: <20190228160737.3323-1-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6839C4A3A5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Feb 2019 11:08:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4GdwnKD7XGhD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Feb 2019 11:08:10 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 988FB4A461
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Feb 2019 11:08:09 -0500 (EST)
In-Reply-To: <20190228160737.3323-1-sudeep.holla@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Sudeep Holla <sudeep.holla@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

SPE Profiling Buffer owning EL is configurable and when MDCR_EL2.E2PB
is configured to provide buffer ownership to EL1, the control registers
are trapped.

Add access handlers for the Statistical Profiling Extension(SPE)
Profiling Buffer controls registers. This is need to support profiling
using SPE in the guests.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 13 ++++++++++++
 arch/arm64/kvm/sys_regs.c         | 35 +++++++++++++++++++++++++++++++
 include/kvm/arm_spe.h             | 14 +++++++++++++
 3 files changed, 62 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6714d6a0ef1e..d113b8271a75 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -133,6 +133,19 @@ enum vcpu_sysreg {
 	MDCCINT_EL1,	/* Monitor Debug Comms Channel Interrupt Enable Reg */
 	DISR_EL1,	/* Deferred Interrupt Status Register */
 
+	/* Statistical Profiling Extension Registers */
+
+	PMSCR_EL1,
+	PMSICR_EL1,
+	PMSIRR_EL1,
+	PMSFCR_EL1,
+	PMSEVFR_EL1,
+	PMSLATFR_EL1,
+	PMSIDR_EL1,
+	PMBLIMITR_EL1,
+	PMBPTR_EL1,
+	PMBSR_EL1,
+
 	/* Performance Monitors Registers */
 	PMCR_EL0,	/* Control Register */
 	PMSELR_EL0,	/* Event Counter Selection Register */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c936aa40c3f4..9a8571974df0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -646,6 +646,30 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
 }
 
+static bool access_pmsb_val(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		vcpu_write_sys_reg(vcpu, p->regval, r->reg);
+	else
+		p->regval = vcpu_read_sys_reg(vcpu, r->reg);
+
+	return true;
+}
+
+static void reset_pmsb_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	if (!kvm_arm_support_spe_v1()) {
+		__vcpu_sys_reg(vcpu, r->reg) = 0;
+		return;
+	}
+
+	if (r->reg == PMSIDR_EL1)
+		__vcpu_sys_reg(vcpu, r->reg) = read_sysreg_s(SYS_PMSIDR_EL1);
+	else
+		__vcpu_sys_reg(vcpu, r->reg) = 0;
+}
+
 static bool check_pmu_access_disabled(struct kvm_vcpu *vcpu, u64 flags)
 {
 	u64 reg = __vcpu_sys_reg(vcpu, PMUSERENR_EL0);
@@ -1344,6 +1368,17 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_FAR_EL1), access_vm_reg, reset_unknown, FAR_EL1 },
 	{ SYS_DESC(SYS_PAR_EL1), NULL, reset_unknown, PAR_EL1 },
 
+	{ SYS_DESC(SYS_PMSCR_EL1), access_pmsb_val, reset_pmsb_val, PMSCR_EL1 },
+	{ SYS_DESC(SYS_PMSICR_EL1), access_pmsb_val, reset_pmsb_val, PMSICR_EL1 },
+	{ SYS_DESC(SYS_PMSIRR_EL1), access_pmsb_val, reset_pmsb_val, PMSIRR_EL1 },
+	{ SYS_DESC(SYS_PMSFCR_EL1), access_pmsb_val, reset_pmsb_val, PMSFCR_EL1 },
+	{ SYS_DESC(SYS_PMSEVFR_EL1), access_pmsb_val, reset_pmsb_val, PMSEVFR_EL1},
+	{ SYS_DESC(SYS_PMSLATFR_EL1), access_pmsb_val, reset_pmsb_val, PMSLATFR_EL1 },
+	{ SYS_DESC(SYS_PMSIDR_EL1), access_pmsb_val, reset_pmsb_val, PMSIDR_EL1 },
+	{ SYS_DESC(SYS_PMBLIMITR_EL1), access_pmsb_val, reset_pmsb_val, PMBLIMITR_EL1 },
+	{ SYS_DESC(SYS_PMBPTR_EL1), access_pmsb_val, reset_pmsb_val, PMBPTR_EL1 },
+	{ SYS_DESC(SYS_PMBSR_EL1), access_pmsb_val, reset_pmsb_val, PMBSR_EL1 },
+
 	{ SYS_DESC(SYS_PMINTENSET_EL1), access_pminten, reset_unknown, PMINTENSET_EL1 },
 	{ SYS_DESC(SYS_PMINTENCLR_EL1), access_pminten, NULL, PMINTENSET_EL1 },
 
diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
index 8c96bdfad6ac..5678f80e1528 100644
--- a/include/kvm/arm_spe.h
+++ b/include/kvm/arm_spe.h
@@ -8,6 +8,7 @@
 
 #include <uapi/linux/kvm.h>
 #include <linux/kvm_host.h>
+#include <linux/cpufeature.h>
 
 struct kvm_spe {
 	int irq;
@@ -15,4 +16,17 @@ struct kvm_spe {
 	bool created; /* SPE KVM instance is created, may not be ready yet */
 };
 
+#ifdef CONFIG_KVM_ARM_SPE
+
+static inline bool kvm_arm_support_spe_v1(void)
+{
+	u64 dfr0 = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
+	return !!cpuid_feature_extract_unsigned_field(dfr0,
+						      ID_AA64DFR0_PMSVER_SHIFT);
+}
+#else
+
+#define kvm_arm_support_spe_v1()	(false)
+#endif /* CONFIG_KVM_ARM_SPE */
+
 #endif /* __ASM_ARM_KVM_SPE_H */
-- 
2.17.1
