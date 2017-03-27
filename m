From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 5/9] arm64: KVM: PMU: Inject UNDEF on read access to
 PMSWINC_EL0
Date: Mon, 27 Mar 2017 17:03:41 +0100
Message-ID: <20170327160345.12402-6-marc.zyngier@arm.com>
References: <20170327160345.12402-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5427C40C90
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 12:02:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AnKUyXxo6N0c for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 12:02:08 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CAA140C28
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 12:02:08 -0400 (EDT)
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

PMSWINC_EL0 is a WO register, so let's UNDEF when reading from it
(in the highly hypothetical case where this doesn't UNDEF at EL1).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 19a036b4f6ac..f80a61af5e88 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -772,16 +772,15 @@ static bool access_pmswinc(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (!kvm_arm_pmu_v3_ready(vcpu))
 		return trap_raz_wi(vcpu, p, r);
 
+	if (!p->is_write)
+		return read_from_write_only(vcpu, p);
+
 	if (pmu_write_swinc_el0_disabled(vcpu))
 		return false;
 
-	if (p->is_write) {
-		mask = kvm_pmu_valid_counter_mask(vcpu);
-		kvm_pmu_software_increment(vcpu, p->regval & mask);
-		return true;
-	}
-
-	return false;
+	mask = kvm_pmu_valid_counter_mask(vcpu);
+	kvm_pmu_software_increment(vcpu, p->regval & mask);
+	return true;
 }
 
 static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
-- 
2.11.0
