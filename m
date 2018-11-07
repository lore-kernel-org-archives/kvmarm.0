From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [RFC PATCH] KVM: arm64: don't single-step for non-emulated faults
Date: Wed,  7 Nov 2018 17:10:31 +0000
Message-ID: <20181107171031.22573-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christoffer Dall <christoffer.dall@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Not all faults handled by handle_exit are instruction emulations. For
example a ESR_ELx_EC_IABT will result in the page tables being updated
but the instruction that triggered the fault hasn't actually executed
yet. We use the simple heuristic of checking for a changed PC before
seeing if kvm_arm_handle_step_debug wants to claim we stepped an
instruction.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 arch/arm64/kvm/handle_exit.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index e5e741bfffe1..b8252e72f882 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -214,6 +214,7 @@ static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
 static int handle_trap_exceptions(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	int handled;
+        unsigned long old_pc = *vcpu_pc(vcpu);
 
 	/*
 	 * See ARM ARM B1.14.1: "Hyp traps on instructions
@@ -233,7 +234,8 @@ static int handle_trap_exceptions(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	 * kvm_arm_handle_step_debug() sets the exit_reason on the kvm_run
 	 * structure if we need to return to userspace.
 	 */
-	if (handled > 0 && kvm_arm_handle_step_debug(vcpu, run))
+	if (handled > 0 && *vcpu_pc(vcpu) != old_pc &&
+	    kvm_arm_handle_step_debug(vcpu, run))
 		handled = 0;
 
 	return handled;
-- 
2.17.1
