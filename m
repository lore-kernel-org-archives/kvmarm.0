From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v2 2/4] KVM: arm64: Don't mask softirq with IRQs disabled in
 vcpu_put()
Date: Fri, 15 Jun 2018 16:47:24 +0100
Message-ID: <1529077646-2848-3-git-send-email-Dave.Martin@arm.com>
References: <1529077646-2848-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAA8B4A0C7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jun 2018 11:37:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UhnQSc6lj0TA for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jun 2018 11:36:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F3D540672
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jun 2018 11:36:43 -0400 (EDT)
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

This patch disables IRQs instead of attempting to disable softirqs,
avoiding the problem of calling local_bh_enable() with IRQs
disabled in the __schedule() path.  This creates an additional
interrupt blackout during vcpu run loop exit, but this is the rare
case and the blackout latency is still less than that of
__schedule().

Fixes: e6b673b741ea ("KVM: arm64: Optimise FPSIMD handling to reduce guest/host thrashing")
Reported-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>

---

Changes since v1:

Requested by Marc Zyngier:

 * Disable IRQs unconditionally instead of attempting to conditionally
   disable softirqs.  This creates an additional interrupt blackout
   during vcpu run loop exit.  This is the rare case, and the blackout
   latency is still less than that of __schedule().
---
 arch/arm64/kvm/fpsimd.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index dc6ecfa..f9d0931 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -5,7 +5,7 @@
  * Copyright 2018 Arm Limited
  * Author: Dave Martin <Dave.Martin@arm.com>
  */
-#include <linux/bottom_half.h>
+#include <linux/irqflags.h>
 #include <linux/sched.h>
 #include <linux/thread_info.h>
 #include <linux/kvm_host.h>
@@ -92,7 +92,9 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
  */
 void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 {
-	local_bh_disable();
+	unsigned long flags;
+
+	local_irq_save(flags);
 
 	update_thread_flag(TIF_SVE,
 			   vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE);
@@ -106,5 +108,5 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 		fpsimd_bind_task_to_cpu();
 	}
 
-	local_bh_enable();
+	local_irq_restore(flags);
 }
-- 
2.1.4
