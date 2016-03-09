From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 21/95] ARM: KVM: Change kvm_call_hyp return type to unsigned long
Date: Wed,  9 Mar 2016 07:30:15 +0000
Message-ID: <1457508689-19672-22-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Having u64 as the kvm_call_hyp return type is problematic, as
it forces all kind of tricks for the return values from HYP
to be promoted to 64bit (LE has the LSB in r0, and BE has them
in r1).

Since the only user of the return value is perfectly happy with
a 32bit value, let's make kvm_call_hyp return an unsigned long,
which is 32bit on ARM.

This solves yet another headache.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_host.h |  2 +-
 arch/arm/kvm/interrupts.S       | 10 ++--------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 02932ba..c62d717 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -165,7 +165,7 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu);
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
 int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
-u64 kvm_call_hyp(void *hypfn, ...);
+unsigned long kvm_call_hyp(void *hypfn, ...);
 void force_vm_exit(const cpumask_t *mask);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
index 7bfb289..01eb169 100644
--- a/arch/arm/kvm/interrupts.S
+++ b/arch/arm/kvm/interrupts.S
@@ -207,20 +207,14 @@ after_vfp_restore:
 
 	restore_host_regs
 	clrex				@ Clear exclusive monitor
-#ifndef CONFIG_CPU_ENDIAN_BE8
 	mov	r0, r1			@ Return the return code
-	mov	r1, #0			@ Clear upper bits in return value
-#else
-	@ r1 already has return code
-	mov	r0, #0			@ Clear upper bits in return value
-#endif /* CONFIG_CPU_ENDIAN_BE8 */
 	bx	lr			@ return to IOCTL
 
 /********************************************************************
  *  Call function in Hyp mode
  *
  *
- * u64 kvm_call_hyp(void *hypfn, ...);
+ * unsigned long kvm_call_hyp(void *hypfn, ...);
  *
  * This is not really a variadic function in the classic C-way and care must
  * be taken when calling this to ensure parameters are passed in registers
@@ -231,7 +225,7 @@ after_vfp_restore:
  * passed as r0, r1, and r2 (a maximum of 3 arguments in addition to the
  * function pointer can be passed).  The function being called must be mapped
  * in Hyp mode (see init_hyp_mode in arch/arm/kvm/arm.c).  Return values are
- * passed in r0 and r1.
+ * passed in r0 (strictly 32bit).
  *
  * A function pointer with a value of 0xffffffff has a special meaning,
  * and is used to implement __hyp_get_vectors in the same way as in
-- 
2.1.4

