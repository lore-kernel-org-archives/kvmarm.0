From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v6 5/6] arm/arm64: KVM: Introduce armv8 fp/simd vcpu fields and
 helpers
Date: Sat, 26 Dec 2015 13:56:29 -0800
Message-ID: <1451166989-3754-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Mario Smarduch <m.smarduch@samsung.com>
List-Id: kvmarm@lists.cs.columbia.edu

Similar to armv7 add helper functions to enable access to fp/smid registers on 
guest entry. Save guest fpexc32_el2 on vcpu_put, check if guest is 32 bit.
Save guest and restore host registers from host kernel, and check 
if fp/simd registers are dirty, lastly add cptr_el2 vcpu field.

Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
---
 arch/arm/include/asm/kvm_emulate.h   | 12 ++++++++++++
 arch/arm64/include/asm/kvm_asm.h     |  5 +++++
 arch/arm64/include/asm/kvm_emulate.h | 26 ++++++++++++++++++++++++--
 arch/arm64/include/asm/kvm_host.h    | 12 +++++++++++-
 arch/arm64/kvm/hyp/hyp-entry.S       | 26 ++++++++++++++++++++++++++
 5 files changed, 78 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index d4d9da1..a434dc5 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -284,6 +284,12 @@ static inline bool vcpu_vfp_isdirty(struct kvm_vcpu *vcpu)
 {
 	return !(vcpu->arch.hcptr & (HCPTR_TCP(10) | HCPTR_TCP(11)));
 }
+
+static inline bool vcpu_guest_is_32bit(struct kvm_vcpu *vcpu)
+{
+	return true;
+}
+static inline void vcpu_save_fpexc(struct kvm_vcpu *vcpu) {}
 #else
 static inline void vcpu_trap_vfp_enable(struct kvm_vcpu *vcpu)
 {
@@ -295,6 +301,12 @@ static inline bool vcpu_vfp_isdirty(struct kvm_vcpu *vcpu)
 {
 	return false;
 }
+
+static inline bool vcpu_guest_is_32bit(struct kvm_vcpu *vcpu)
+{
+	return true;
+}
+static inline void vcpu_save_fpexc(struct kvm_vcpu *vcpu) {}
 #endif
 
 #endif /* __ARM_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 52b777b..ddae814 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -48,6 +48,11 @@ extern u64 __vgic_v3_get_ich_vtr_el2(void);
 
 extern u32 __kvm_get_mdcr_el2(void);
 
+extern void __fpsimd_prepare_fpexc32(void);
+extern void __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu);
+extern void __fpsimd_save_state(struct user_fpsimd_state *);
+extern void __fpsimd_restore_state(struct user_fpsimd_state *);
+
 #endif
 
 #endif /* __ARM_KVM_ASM_H__ */
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index ffe8ccf..f8203c7 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -299,12 +299,34 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
 	return data;		/* Leave LE untouched */
 }
 
-static inline void vcpu_trap_vfp_enable(struct kvm_vcpu *vcpu) {}
+static inline bool vcpu_guest_is_32bit(struct kvm_vcpu *vcpu)
+{
+	return !(vcpu->arch.hcr_el2 & HCR_RW);
+}
+
+static inline void vcpu_trap_vfp_enable(struct kvm_vcpu *vcpu)
+{
+	/* For 32 bit guest enable access to fp/simd registers */
+	if (vcpu_guest_is_32bit(vcpu))
+		vcpu_prepare_fpexc();
+
+	vcpu->arch.cptr_el2 = CPTR_EL2_TTA | CPTR_EL2_TFP;
+}
+
 static inline void vcpu_restore_host_fpexc(struct kvm_vcpu *vcpu) {}
 
 static inline bool vcpu_vfp_isdirty(struct kvm_vcpu *vcpu)
 {
-	return false;
+	return !(vcpu->arch.cptr_el2 & CPTR_EL2_TFP);
+}
+
+static inline void vcpu_restore_host_vfp_state(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *host_ctxt = vcpu->arch.host_cpu_context;
+	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
+
+	__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
+	__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
 }
 
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bfe4d4e..5d0c256 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -26,6 +26,7 @@
 #include <linux/kvm_types.h>
 #include <asm/kvm.h>
 #include <asm/kvm_mmio.h>
+#include <asm/kvm_asm.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
 
@@ -180,6 +181,7 @@ struct kvm_vcpu_arch {
 	/* HYP configuration */
 	u64 hcr_el2;
 	u32 mdcr_el2;
+	u32 cptr_el2;
 
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
@@ -338,7 +340,15 @@ static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 
-static inline void vcpu_restore_host_vfp_state(struct kvm_vcpu *vcpu) {}
+static inline void vcpu_prepare_fpexc(void)
+{
+	kvm_call_hyp(__fpsimd_prepare_fpexc32);
+}
+
+static inline void vcpu_save_fpexc(struct kvm_vcpu *vcpu)
+{
+	kvm_call_hyp(__fpsimd_save_fpexc32, vcpu);
+}
 
 void kvm_arm_init_debug(void);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 93e8d983..a9235e2 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -164,6 +164,32 @@ ENTRY(__hyp_do_panic)
 	eret
 ENDPROC(__hyp_do_panic)
 
+/**
+  * void __fpsimd_prepare_fpexc32(void) -
+  *	We may be entering the guest and set CPTR_EL2.TFP to trap all floating
+  *	point register accesses to EL2, however, the ARM manual clearly states
+  *	that traps are only taken to EL2 if the operation would not otherwise
+  *	trap to EL1.  Therefore, always make sure that for 32-bit guests,
+  *	we set FPEXC.EN to prevent traps to EL1, when setting the TFP bit.
+  */
+ENTRY(__fpsimd_prepare_fpexc32)
+	mov	x2, #(1 << 30)
+	msr	fpexc32_el2, x2
+	ret
+ENDPROC(__fpsimd_prepare_fpexc32)
+
+/**
+ * void __fpsimd_save_fpexc32(void) -
+ *	This function restores guest FPEXC to its vcpu context, we call this
+ *	function from vcpu_put.
+ */
+ENTRY(__fpsimd_save_fpexc32)
+	kern_hyp_va x0
+	mrs	x2, fpexc32_el2
+	str	x2, [x0, #VCPU_FPEXC32_EL2]
+	ret
+ENDPROC(__fpsimd_save_fpexc32)
+
 .macro invalid_vector	label, target = __hyp_panic
 	.align	2
 \label:
-- 
1.9.1

