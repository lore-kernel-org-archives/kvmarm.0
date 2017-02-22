From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 4/8] arm64: KVM: pmu: Inject UNDEF exception on illegal
 register access
Date: Wed, 22 Feb 2017 11:47:24 +0000
Message-ID: <20170222114728.2472-5-marc.zyngier@arm.com>
References: <20170222114728.2472-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 560B840C9F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Feb 2017 06:46:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EwPWmZwTKXXQ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Feb 2017 06:46:41 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F04E40C41
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Feb 2017 06:46:41 -0500 (EST)
In-Reply-To: <20170222114728.2472-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Shannon Zhao <shannon.zhao@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Both pmu_*_el0_disabled() and pmu_counter_idx_valid() perform checks
on the calidity of an access, but only return a boolean indicating
if the access is valid or not.

Let's allow these functions to also inject an UNDEF exception if
the access was illegal. This is where we start flagging a pending
exception.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0ebf27f40f98..eec543906e21 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -460,11 +460,20 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	vcpu_sys_reg(vcpu, PMCR_EL0) = val;
 }
 
+static void pend_undef(struct kvm_vcpu *vcpu)
+{
+	kvm_inject_undefined(vcpu);
+	vcpu->arch.sys_reg->exception_pending = true;
+}
+
 static bool check_disabled(struct kvm_vcpu *vcpu, u64 flags)
 {
 	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
 	bool cond = (reg & flags) || vcpu_mode_priv(vcpu);
 
+	if (!cond)
+		pend_undef(vcpu);
+
 	return !cond;
 }
 
@@ -564,8 +573,10 @@ static bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
 
 	pmcr = vcpu_sys_reg(vcpu, PMCR_EL0);
 	val = (pmcr >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
-	if (idx >= val && idx != ARMV8_PMU_CYCLE_IDX)
+	if (idx >= val && idx != ARMV8_PMU_CYCLE_IDX) {
+		pend_undef(vcpu);
 		return false;
+	}
 
 	return true;
 }
-- 
2.11.0
