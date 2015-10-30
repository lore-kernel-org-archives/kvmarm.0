From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH 3/3] KVM/arm64: enable enhanced armv8 fp/simd lazy switch
Date: Fri, 30 Oct 2015 14:56:33 -0700
Message-ID: <1446242193-8424-4-git-send-email-m.smarduch@samsung.com>
References: <1446242193-8424-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 677A541289
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2015 17:54:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NuE95PkyXT9s for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Oct 2015 17:54:10 -0400 (EDT)
Received: from usmailout1.samsung.com (mailout1.w2.samsung.com
 [211.189.100.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 392F541280
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2015 17:54:10 -0400 (EDT)
Received: from uscpsbgex2.samsung.com
 (u123.gpu85.samsung.co.kr [203.254.195.123]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NX1002G2ZNA2M50@mailout1.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 30 Oct 2015 17:57:10 -0400 (EDT)
In-reply-to: <1446242193-8424-1-git-send-email-m.smarduch@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch enables arm64 lazy fp/simd switch, similar to arm described in
second patch. Change from previous version - restore function is moved to
host. 

Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kernel/asm-offsets.c   |  1 +
 arch/arm64/kvm/hyp.S              | 37 +++++++++++++++++++++++++++++++------
 3 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 26a2347..dcecf92 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -251,11 +251,11 @@ static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
-static inline void kvm_restore_host_vfp_state(struct kvm_vcpu *vcpu) {}
 
 void kvm_arm_init_debug(void);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
+void kvm_restore_host_vfp_state(struct kvm_vcpu *vcpu);
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 8d89cf8..c9c5242 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -124,6 +124,7 @@ int main(void)
   DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
   DEFINE(VCPU_MDCR_EL2,	offsetof(struct kvm_vcpu, arch.mdcr_el2));
   DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
+  DEFINE(VCPU_VFP_DIRTY,	offsetof(struct kvm_vcpu, arch.vfp_dirty));
   DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
   DEFINE(VCPU_HOST_DEBUG_STATE, offsetof(struct kvm_vcpu, arch.host_debug_state));
   DEFINE(VCPU_TIMER_CNTV_CTL,	offsetof(struct kvm_vcpu, arch.timer_cpu.cntv_ctl));
diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index e583613..ed2c4cf 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -36,6 +36,28 @@
 #define CPU_SYSREG_OFFSET(x)	(CPU_SYSREGS + 8*x)
 
 	.text
+
+/**
+ * void kvm_restore_host_vfp_state(struct vcpu *vcpu) - Executes lazy
+ *	fp/simd switch, saves the guest, restores host. Called from host
+ *	mode, placed outside of hyp section.
+ */
+ENTRY(kvm_restore_host_vfp_state)
+	push    xzr, lr
+
+	add     x2, x0, #VCPU_CONTEXT
+	mov     w3, #0
+	strb    w3, [x0, #VCPU_VFP_DIRTY]
+
+	bl __save_fpsimd
+
+	ldr     x2, [x0, #VCPU_HOST_CONTEXT]
+	bl __restore_fpsimd
+
+	pop     xzr, lr
+	ret
+ENDPROC(kvm_restore_host_vfp_state)
+
 	.pushsection	.hyp.text, "ax"
 	.align	PAGE_SHIFT
 
@@ -482,7 +504,11 @@
 99:
 	msr     hcr_el2, x2
 	mov	x2, #CPTR_EL2_TTA
+
+	ldrb	w3, [x0, #VCPU_VFP_DIRTY]
+	tbnz    w3, #0, 98f
 	orr     x2, x2, #CPTR_EL2_TFP
+98:
 	msr	cptr_el2, x2
 
 	mov	x2, #(1 << 15)	// Trap CP15 Cr=15
@@ -669,14 +695,12 @@ __restore_debug:
 	ret
 
 __save_fpsimd:
-	skip_fpsimd_state x3, 1f
 	save_fpsimd
-1:	ret
+	ret
 
 __restore_fpsimd:
-	skip_fpsimd_state x3, 1f
 	restore_fpsimd
-1:	ret
+	ret
 
 switch_to_guest_fpsimd:
 	push	x4, lr
@@ -688,6 +712,9 @@ switch_to_guest_fpsimd:
 
 	mrs	x0, tpidr_el2
 
+	mov     w2, #1
+	strb    w2, [x0, #VCPU_VFP_DIRTY]
+
 	ldr	x2, [x0, #VCPU_HOST_CONTEXT]
 	kern_hyp_va x2
 	bl __save_fpsimd
@@ -763,7 +790,6 @@ __kvm_vcpu_return:
 	add	x2, x0, #VCPU_CONTEXT
 
 	save_guest_regs
-	bl __save_fpsimd
 	bl __save_sysregs
 
 	skip_debug_state x3, 1f
@@ -784,7 +810,6 @@ __kvm_vcpu_return:
 	kern_hyp_va x2
 
 	bl __restore_sysregs
-	bl __restore_fpsimd
 	/* Clear FPSIMD and Trace trapping */
 	msr     cptr_el2, xzr
 
-- 
1.9.1
