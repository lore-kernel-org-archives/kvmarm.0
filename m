From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v2 4/4] KVM: arm64: Avoid mistaken attempts to save SVE state
 for vcpus
Date: Fri, 15 Jun 2018 16:47:26 +0100
Message-ID: <1529077646-2848-5-git-send-email-Dave.Martin@arm.com>
References: <1529077646-2848-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DAFD4A0C7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jun 2018 11:37:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gNisBIO+XtqI for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jun 2018 11:36:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A2634A0D3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jun 2018 11:36:46 -0400 (EDT)
In-Reply-To: <1529077646-2848-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Commit e6b673b ("KVM: arm64: Optimise FPSIMD handling to reduce
guest/host thrashing") uses fpsimd_save() to save the FPSIMD state
for a vcpu when scheduling the vcpu out.  However, currently
current's value of TIF_SVE is restored before calling fpsimd_save()
which means that fpsimd_save() may erroneously attempt to save SVE
state from the vcpu.  This enables current's vector state to be
polluted with guest data.  current->thread.sve_state may be
unallocated or not large enough, so this can also trigger a NULL
dereference or buffer overrun.

Instead of this, TIF_SVE should be configured properly for the
guest when calling fpsimd_save() with the vcpu context loaded.

This patch ensures this by delaying restoration of current's
TIF_SVE until after the call to fpsimd_save().

Fixes: e6b673b741ea ("KVM: arm64: Optimise FPSIMD handling to reduce guest/host thrashing")
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/kvm/fpsimd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 98d19d1..aac7808 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -103,9 +103,6 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 
 	local_irq_save(flags);
 
-	update_thread_flag(TIF_SVE,
-			   vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE);
-
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
 		/* Clean guest FP state to memory and invalidate cpu view */
 		fpsimd_save();
@@ -124,5 +121,8 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 			sysreg_clear_set(CPACR_EL1, CPACR_EL1_ZEN_EL0EN, 0);
 	}
 
+	update_thread_flag(TIF_SVE,
+			   vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE);
+
 	local_irq_restore(flags);
 }
-- 
2.1.4
