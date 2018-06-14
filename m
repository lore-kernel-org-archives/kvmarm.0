From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 2/4] KVM: arm64: Don't mask softirq with IRQs disabled in
 vcpu_put()
Date: Thu, 14 Jun 2018 12:42:24 +0100
Message-ID: <1528976546-25999-2-git-send-email-Dave.Martin@arm.com>
References: <1528976039-25826-1-git-send-email-Dave.Martin@arm.com>
 <1528976546-25999-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D6754028A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jun 2018 07:31:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id opaiLBrB4Cfl for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jun 2018 07:31:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43FDC49F8B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jun 2018 07:31:02 -0400 (EDT)
In-Reply-To: <1528976546-25999-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Commit e6b673b ("KVM: arm64: Optimise FPSIMD handling to reduce
guest/host thrashing") introduces a specific helper
kvm_arch_vcpu_put_fp() for saving the vcpu FPSIMD state during
vcpu_put().

This function uses local_bh_disable()/_enable() to protect the
FPSIMD context manipulation from interruption by softirqs.

This approach is not correct, because vcpu_put() can be invoked
either from the KVM host vcpu thread (when exiting the vcpu run
loop), or via a preempt notifier.  In the former case, only
preemption is disabled.  In the latter case, the function is called
from inside __schedule(), which means that IRQs are disabled.

Use of local_bh_disable()/_enable() with IRQs disabled is considerd
an error, resulting in lockdep splats while running VMs if lockdep
is enabled.

It is probably possible in theory to relax this restriction on
local_bh_disable()/_enable() usage, but for now this patch takes
the simple approach of managing softirq masking only if IRQs happen
to be enabled when kvm_arch_vcpu_put_fp() is called.

Fixes: e6b673b741ea ("KVM: arm64: Optimise FPSIMD handling to reduce guest/host thrashing")
Reported-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/kvm/fpsimd.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index dc6ecfa..b51ff80 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -90,10 +90,8 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
  * disappears and another task or vcpu appears that recycles the same
  * struct fpsimd_state.
  */
-void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
+static void __kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 {
-	local_bh_disable();
-
 	update_thread_flag(TIF_SVE,
 			   vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE);
 
@@ -105,6 +103,16 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 		/* Ensure user trap controls are correctly restored */
 		fpsimd_bind_task_to_cpu();
 	}
+}
+
 
-	local_bh_enable();
+void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
+{
+	if (irqs_disabled())
+		__kvm_arch_vcpu_put_fp(vcpu);
+	else {
+		local_bh_disable();
+		__kvm_arch_vcpu_put_fp(vcpu);
+		local_bh_enable();
+	}
 }
-- 
2.1.4
