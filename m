From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/2] arm: KVM: Do not update PC if the trap handler has updated it
Date: Tue, 22 Dec 2015 09:55:17 +0000
Message-ID: <1450778118-12715-2-git-send-email-marc.zyngier@arm.com>
References: <1450778118-12715-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450778118-12715-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Shannon Zhao <shannon.zhao@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Assuming we trap a coprocessor access, and decide that the access
is illegal, we will inject an exception in the guest. In this
case, we shouldn't increment the PC, or the vcpu will miss the
first instruction of the handler, leading to a mildly confused
guest.

Solve this by snapshoting PC before the access is performed,
and checking if it has moved or not before incrementing it.

Reported-by: Shannon Zhao <shannon.zhao@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/coproc.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index f3d88dc..f4ad2f2 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -447,12 +447,22 @@ static int emulate_cp15(struct kvm_vcpu *vcpu,
 		r = find_reg(params, cp15_regs, ARRAY_SIZE(cp15_regs));
 
 	if (likely(r)) {
+		unsigned long pc = *vcpu_pc(vcpu);
+
 		/* If we don't have an accessor, we should never get here! */
 		BUG_ON(!r->access);
 
 		if (likely(r->access(vcpu, params, r))) {
-			/* Skip instruction, since it was emulated */
-			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+			/*
+			 * Skip the instruction if it was emulated
+			 * without PC having changed. This allows us
+			 * to detect a fault being injected
+			 * (incrementing the PC here would cause the
+			 * vcpu to skip the first instruction of its
+			 * fault handler).
+			 */
+			if (pc == *vcpu_pc(vcpu))
+				kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
 			return 1;
 		}
 		/* If access function fails, it should complain. */
-- 
2.1.4

