From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v7 13/16] KVM: arm64: Remove eager host SVE state saving
Date: Wed,  9 May 2018 17:13:02 +0100
Message-ID: <1525882385-29181-14-git-send-email-Dave.Martin@arm.com>
References: <1525882385-29181-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1525882385-29181-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@kernel.org>, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
---
 arch/arm/include/asm/kvm_host.h   |  3 ---
 arch/arm64/include/asm/kvm_host.h | 10 ----------
 arch/arm64/kernel/fpsimd.c        | 21 ---------------------
 virt/kvm/arm/arm.c                |  3 ---
 4 files changed, 37 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 4cac8d1..39f051f 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -311,9 +311,6 @@ static inline void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_park_fp(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu) {}
 
-/* All host FP/SIMD state is restored on guest exit, so nothing to save: */
-static inline void kvm_fpsimd_flush_cpu_state(void) {}
-
 static inline void kvm_arm_vhe_guest_enter(void) {}
 static inline void kvm_arm_vhe_guest_exit(void) {}
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b3fe730..2629093 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -444,16 +444,6 @@ static inline int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
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
index 13fa681..32898a8 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -120,7 +120,6 @@
  */
 struct fpsimd_last_state_struct {
 	struct user_fpsimd_state *st;
-	bool sve_in_use;
 };
 
 static DEFINE_PER_CPU(struct fpsimd_last_state_struct, fpsimd_last_state);
@@ -1010,7 +1009,6 @@ void fpsimd_bind_task_to_cpu(void)
 		this_cpu_ptr(&fpsimd_last_state);
 
 	last->st = &current->thread.uw.fpsimd_state;
-	last->sve_in_use = test_thread_flag(TIF_SVE);
 	current->thread.fpsimd_cpu = smp_processor_id();
 
 	if (system_supports_sve()) {
@@ -1032,7 +1030,6 @@ void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st)
 	WARN_ON(!in_softirq() && !irqs_disabled());
 
 	last->st = st;
-	last->sve_in_use = false;
 }
 
 /*
@@ -1092,24 +1089,6 @@ void fpsimd_flush_cpu_state(void)
 	__this_cpu_write(fpsimd_last_state.st, NULL);
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
index 379e8a9..9cef525 100644
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
