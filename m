From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v10 15/18] KVM: arm64: Remove eager host SVE state saving
Date: Tue, 22 May 2018 17:05:16 +0100
Message-ID: <1527005119-6842-16-git-send-email-Dave.Martin@arm.com>
References: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 671364A0C3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 May 2018 11:56:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id efWRj+pmpUhE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 May 2018 11:56:12 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A857D4A115
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 May 2018 11:55:54 -0400 (EDT)
In-Reply-To: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
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

Now that the host SVE context can be saved on demand from Hyp,
there is no longer any need to save this state in advance before
entering the guest.

This patch removes the relevant call to
kvm_fpsimd_flush_cpu_state().

Since the problem that function was intended to solve now no longer
exists, the function and its dependencies are also deleted.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/kvm_host.h   |  3 ---
 arch/arm64/include/asm/kvm_host.h | 10 ----------
 arch/arm64/kernel/fpsimd.c        | 21 ---------------------
 virt/kvm/arm/arm.c                |  3 ---
 4 files changed, 37 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 3b85bbb..f079a20 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -312,9 +312,6 @@ static inline void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu) {}
 
-/* All host FP/SIMD state is restored on guest exit, so nothing to save: */
-static inline void kvm_fpsimd_flush_cpu_state(void) {}
-
 static inline void kvm_arm_vhe_guest_enter(void) {}
 static inline void kvm_arm_vhe_guest_exit(void) {}
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 06d5a61..ce7ed92 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -457,16 +457,6 @@ static inline int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 }
 #endif
 
-/*
- * All host FP/SIMD state is restored on guest exit, so nothing needs
- * doing here except in the SVE case:
-*/
-static inline void kvm_fpsimd_flush_cpu_state(void)
-{
-	if (system_supports_sve())
-		sve_flush_cpu_state();
-}
-
 static inline void kvm_arm_vhe_guest_enter(void)
 {
 	local_daif_mask();
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index f39d3b0..ea5d780 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -120,7 +120,6 @@
  */
 struct fpsimd_last_state_struct {
 	struct user_fpsimd_state *st;
-	bool sve_in_use;
 };
 
 static DEFINE_PER_CPU(struct fpsimd_last_state_struct, fpsimd_last_state);
@@ -1003,7 +1002,6 @@ void fpsimd_bind_task_to_cpu(void)
 		this_cpu_ptr(&fpsimd_last_state);
 
 	last->st = &current->thread.uw.fpsimd_state;
-	last->sve_in_use = test_thread_flag(TIF_SVE);
 	current->thread.fpsimd_cpu = smp_processor_id();
 
 	if (system_supports_sve()) {
@@ -1025,7 +1023,6 @@ void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st)
 	WARN_ON(!in_softirq() && !irqs_disabled());
 
 	last->st = st;
-	last->sve_in_use = false;
 }
 
 /*
@@ -1086,24 +1083,6 @@ void fpsimd_flush_cpu_state(void)
 	set_thread_flag(TIF_FOREIGN_FPSTATE);
 }
 
-/*
- * Invalidate any task SVE state currently held in this CPU's regs.
- *
- * This is used to prevent the kernel from trying to reuse SVE register data
- * that is detroyed by KVM guest enter/exit.  This function should go away when
- * KVM SVE support is implemented.  Don't use it for anything else.
- */
-#ifdef CONFIG_ARM64_SVE
-void sve_flush_cpu_state(void)
-{
-	struct fpsimd_last_state_struct const *last =
-		this_cpu_ptr(&fpsimd_last_state);
-
-	if (last->st && last->sve_in_use)
-		fpsimd_flush_cpu_state();
-}
-#endif /* CONFIG_ARM64_SVE */
-
 #ifdef CONFIG_KERNEL_MODE_NEON
 
 DEFINE_PER_CPU(bool, kernel_neon_busy);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index ce7c6f3..39e7771 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -682,9 +682,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 */
 		preempt_disable();
 
-		/* Flush FP/SIMD state that can't survive guest entry/exit */
-		kvm_fpsimd_flush_cpu_state();
-
 		kvm_pmu_flush_hwstate(vcpu);
 
 		local_irq_disable();
-- 
2.1.4
