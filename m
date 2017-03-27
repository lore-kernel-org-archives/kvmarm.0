From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 2/9] arm64: KVM: PMU: Inject UNDEF exception on illegal
 register access
Date: Mon, 27 Mar 2017 17:03:38 +0100
Message-ID: <20170327160345.12402-3-marc.zyngier@arm.com>
References: <20170327160345.12402-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3D1140C2F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 12:02:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KzhzwqwRQBtg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 12:02:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE5B840A66
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 12:02:04 -0400 (EDT)
In-Reply-To: <20170327160345.12402-1-marc.zyngier@arm.com>
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
on the validity of an access, but only return a boolean indicating
if the access is valid or not.

Let's allow these functions to also inject an UNDEF exception if
the access was illegal.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7e1d673304d5..d98ce9a52291 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -465,6 +465,9 @@ static bool check_disabled(struct kvm_vcpu *vcpu, u64 flags)
 	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
 	bool cond = (reg & flags) || vcpu_mode_priv(vcpu);
 
+	if (!cond)
+		kvm_inject_undefined(vcpu);
+
 	return !cond;
 }
 
@@ -564,8 +567,10 @@ static bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
 
 	pmcr = vcpu_sys_reg(vcpu, PMCR_EL0);
 	val = (pmcr >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
-	if (idx >= val && idx != ARMV8_PMU_CYCLE_IDX)
+	if (idx >= val && idx != ARMV8_PMU_CYCLE_IDX) {
+		kvm_inject_undefined(vcpu);
 		return false;
+	}
 
 	return true;
 }
-- 
2.11.0
