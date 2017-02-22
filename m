From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 5/8] arm64: KVM: PMU: Inject UNDEF on non-privileged accesses
Date: Wed, 22 Feb 2017 11:47:25 +0000
Message-ID: <20170222114728.2472-6-marc.zyngier@arm.com>
References: <20170222114728.2472-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170222114728.2472-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Shannon Zhao <shannon.zhao@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

access_pminten() and access_pmuserenr() can only be accessed when
the CPU is in a priviledged mode. If it is not, let's inject an
UNDEF exception.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index eec543906e21..cbe966658d5e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -715,8 +715,10 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (!kvm_arm_pmu_v3_ready(vcpu))
 		return trap_raz_wi(vcpu, p, r);
 
-	if (!vcpu_mode_priv(vcpu))
-		return false;
+	if (!vcpu_mode_priv(vcpu)) {
+		pend_undef(vcpu);
+		return true;
+	}
 
 	if (p->is_write) {
 		u64 val = p->regval & mask;
@@ -786,8 +788,10 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		return trap_raz_wi(vcpu, p, r);
 
 	if (p->is_write) {
-		if (!vcpu_mode_priv(vcpu))
-			return false;
+		if (!vcpu_mode_priv(vcpu)) {
+			pend_undef(vcpu);
+			return true;
+		}
 
 		vcpu_sys_reg(vcpu, PMUSERENR_EL0) = p->regval
 						    & ARMV8_PMU_USERENR_MASK;
-- 
2.11.0
