From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 5/5] arm64: KVM: Fix guest dead loop when register accessor returns false
Date: Thu, 28 Jan 2016 10:30:38 +0000
Message-ID: <1453977038-13516-6-git-send-email-marc.zyngier@arm.com>
References: <1453977038-13516-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1453977038-13516-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Shannon Zhao <shannon.zhao@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Gleb Natapov <gleb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

Currently emulate_cp will return 0 (Handled) no matter what the accessor
returns. If register accessor returns false, it will not skip current PC
while emulate_cp return handled. Then guest will stuck in a dead loop.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4048934..2e90371 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1007,10 +1007,9 @@ static int emulate_cp(struct kvm_vcpu *vcpu,
 		if (likely(r->access(vcpu, params, r))) {
 			/* Skip instruction, since it was emulated */
 			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+			/* Handled */
+			return 0;
 		}
-
-		/* Handled */
-		return 0;
 	}
 
 	/* Not handled */
-- 
2.1.4

