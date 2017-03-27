From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 3/9] arm64: KVM: PMU: Inject UNDEF on non-privileged
 accesses
Date: Mon, 27 Mar 2017 17:03:39 +0100
Message-ID: <20170327160345.12402-4-marc.zyngier@arm.com>
References: <20170327160345.12402-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E678840C8C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 12:02:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9O-1LG5Ha-QM for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 12:02:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0702A40C32
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 12:02:06 -0400 (EDT)
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

access_pminten() and access_pmuserenr() can only be accessed when
the CPU is in a priviledged mode. If it is not, let's inject an
UNDEF exception.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d98ce9a52291..5e3ce7890b35 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -709,8 +709,10 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (!kvm_arm_pmu_v3_ready(vcpu))
 		return trap_raz_wi(vcpu, p, r);
 
-	if (!vcpu_mode_priv(vcpu))
+	if (!vcpu_mode_priv(vcpu)) {
+		kvm_inject_undefined(vcpu);
 		return false;
+	}
 
 	if (p->is_write) {
 		u64 val = p->regval & mask;
@@ -780,8 +782,10 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		return trap_raz_wi(vcpu, p, r);
 
 	if (p->is_write) {
-		if (!vcpu_mode_priv(vcpu))
+		if (!vcpu_mode_priv(vcpu)) {
+			kvm_inject_undefined(vcpu);
 			return false;
+		}
 
 		vcpu_sys_reg(vcpu, PMUSERENR_EL0) = p->regval
 						    & ARMV8_PMU_USERENR_MASK;
-- 
2.11.0
