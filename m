From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v2 2/2] KVM/arm: enable enhanced armv7 fp/simd lazy switch
Date: Sat, 26 Sep 2015 16:43:29 -0700
Message-ID: <1443311009-4811-3-git-send-email-m.smarduch@samsung.com>
References: <1443311009-4811-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B75B48857
 for <kvmarm@lists.cs.columbia.edu>; Sat, 26 Sep 2015 19:42:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id auF0RPntvXl5 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 26 Sep 2015 19:42:53 -0400 (EDT)
Received: from usmailout2.samsung.com (mailout2.w2.samsung.com
 [211.189.100.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 17A454876C
 for <kvmarm@lists.cs.columbia.edu>; Sat, 26 Sep 2015 19:42:53 -0400 (EDT)
Received: from uscpsbgex4.samsung.com
 (u125.gpu85.samsung.co.kr [203.254.195.125]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NVB00N7W5XW0440@mailout2.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Sat, 26 Sep 2015 19:44:20 -0400 (EDT)
In-reply-to: <1443311009-4811-1-git-send-email-m.smarduch@samsung.com>
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

This patch enhances current lazy vfp/simd hardware switch. In addition to
current lazy switch, it tracks vfp/simd hardware state with a vcpu 
lazy flag. 

vcpu lazy flag is set on guest access and trap to vfp/simd hardware switch 
handler. On vm-enter if lazy flag is set skip trap enable and saving 
host fpexc. On vm-exit if flag is set skip hardware context switch
and return to host with guest context.

On vcpu_put check if vcpu lazy flag is set, and execute a hardware context 
switch to restore host.

Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
---
 arch/arm/include/asm/kvm_asm.h |  1 +
 arch/arm/kvm/arm.c             | 17 ++++++++++++
 arch/arm/kvm/interrupts.S      | 60 +++++++++++++++++++++++++++++++-----------
 arch/arm/kvm/interrupts_head.S | 12 ++++++---
 4 files changed, 71 insertions(+), 19 deletions(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 194c91b..4b45d79 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -97,6 +97,7 @@ extern char __kvm_hyp_code_end[];
 extern void __kvm_flush_vm_context(void);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
+extern void __kvm_restore_host_vfp_state(struct kvm_vcpu *vcpu);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 #endif
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index ce404a5..79f49c7 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -105,6 +105,20 @@ void kvm_arch_check_processor_compat(void *rtn)
 	*(int *)rtn = 0;
 }
 
+/**
+ * kvm_switch_fp_regs() - switch guest/host VFP/SIMD registers
+ * @vcpu:	pointer to vcpu structure.
+ *
+ */
+static void kvm_switch_fp_regs(struct kvm_vcpu *vcpu)
+{
+#ifdef CONFIG_ARM
+	if (vcpu->arch.vfp_lazy == 1) {
+		kvm_call_hyp(__kvm_restore_host_vfp_state, vcpu);
+		vcpu->arch.vfp_lazy = 0;
+	}
+#endif
+}
 
 /**
  * kvm_arch_init_vm - initializes a VM data structure
@@ -295,6 +309,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	/* Check if Guest accessed VFP registers */
+	kvm_switch_fp_regs(vcpu);
+
 	/*
 	 * The arch-generic KVM code expects the cpu field of a vcpu to be -1
 	 * if the vcpu is no longer assigned to a cpu.  This is used for the
diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
index 900ef6d..6d98232 100644
--- a/arch/arm/kvm/interrupts.S
+++ b/arch/arm/kvm/interrupts.S
@@ -96,6 +96,29 @@ ENTRY(__kvm_flush_vm_context)
 	bx	lr
 ENDPROC(__kvm_flush_vm_context)
 
+/**
+ * void __kvm_restore_host_vfp_state(struct vcpu *vcpu) - Executes a lazy
+ *     fp/simd switch, saves the guest, restores host.
+ *
+ */
+ENTRY(__kvm_restore_host_vfp_state)
+#ifdef CONFIG_VFPv3
+	push	{r3-r7}
+
+	add	r7, r0, #VCPU_VFP_GUEST
+	store_vfp_state r7
+
+	add	r7, r0, #VCPU_VFP_HOST
+	ldr	r7, [r7]
+	restore_vfp_state r7
+
+	ldr	r3, [vcpu, #VCPU_VFP_FPEXC]
+	VFPFMXR FPEXC, r3
+
+	pop	{r3-r7}
+#endif
+	bx	lr
+ENDPROC(__kvm_restore_host_vfp_state)
 
 /********************************************************************
  *  Hypervisor world-switch code
@@ -119,11 +142,15 @@ ENTRY(__kvm_vcpu_run)
 	@ If the host kernel has not been configured with VFPv3 support,
 	@ then it is safer if we deny guests from using it as well.
 #ifdef CONFIG_VFPv3
+	@ r7 must be preserved until next vfp lazy check
+	vfp_inlazy_mode r7, skip_save_host_fpexc
+
 	@ Set FPEXC_EN so the guest doesn't trap floating point instructions
 	VFPFMRX r2, FPEXC		@ VMRS
-	push	{r2}
+	str     r2, [vcpu, #VCPU_VFP_FPEXC]
 	orr	r2, r2, #FPEXC_EN
 	VFPFMXR FPEXC, r2		@ VMSR
+skip_save_host_fpexc:
 #endif
 
 	@ Configure Hyp-role
@@ -131,7 +158,14 @@ ENTRY(__kvm_vcpu_run)
 
 	@ Trap coprocessor CRx accesses
 	set_hstr vmentry
-	set_hcptr vmentry, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11))
+	set_hcptr vmentry, (HCPTR_TTA)
+
+	@ check if vfp_lazy flag set
+	cmp     r7, #1
+	beq     skip_guest_vfp_trap
+	set_hcptr vmentry, (HCPTR_TCP(10) | HCPTR_TCP(11))
+skip_guest_vfp_trap:
+
 	set_hdcr vmentry
 
 	@ Write configured ID register into MIDR alias
@@ -170,22 +204,14 @@ __kvm_vcpu_return:
 	@ Don't trap coprocessor accesses for host kernel
 	set_hstr vmexit
 	set_hdcr vmexit
-	set_hcptr vmexit, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11)), after_vfp_restore
+	set_hcptr vmexit, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11))
 
 #ifdef CONFIG_VFPv3
-	@ Switch VFP/NEON hardware state to the host's
-	add	r7, vcpu, #VCPU_VFP_GUEST
-	store_vfp_state r7
-	add	r7, vcpu, #VCPU_VFP_HOST
-	ldr	r7, [r7]
-	restore_vfp_state r7
-
-after_vfp_restore:
-	@ Restore FPEXC_EN which we clobbered on entry
-	pop	{r2}
+	vfp_inlazy_mode r2, skip_restore_host_fpexc
+	@ If vfp_lazy is not set, restore FPEXC_EN which we clobbered on entry
+	ldr     r2, [vcpu, #VCPU_VFP_FPEXC]
 	VFPFMXR FPEXC, r2
-#else
-after_vfp_restore:
+skip_restore_host_fpexc:
 #endif
 
 	@ Reset Hyp-role
@@ -485,6 +511,10 @@ switch_to_guest_vfp:
 	@ NEON/VFP used.  Turn on VFP access.
 	set_hcptr vmtrap, (HCPTR_TCP(10) | HCPTR_TCP(11))
 
+	@ set lazy mode flag, switch hardware context on vcpu_put
+	mov     r1, #1
+	str     r1, [vcpu, #VCPU_VFP_LAZY]
+
 	@ Switch VFP/NEON hardware state to the guest's
 	add	r7, r0, #VCPU_VFP_HOST
 	ldr	r7, [r7]
diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
index 702740d..4561171 100644
--- a/arch/arm/kvm/interrupts_head.S
+++ b/arch/arm/kvm/interrupts_head.S
@@ -594,7 +594,7 @@ ARM_BE8(rev	r6, r6  )
  * If a label is specified with vmexit, it is branched to if VFP wasn't
  * enabled.
  */
-.macro set_hcptr operation, mask, label = none
+.macro set_hcptr operation, mask
 	mrc	p15, 4, r2, c1, c1, 2
 	ldr	r3, =\mask
 	.if \operation == vmentry
@@ -609,13 +609,17 @@ ARM_BE8(rev	r6, r6  )
 	beq	1f
 	.endif
 	isb
-	.if \label != none
-	b	\label
-	.endif
 1:
 	.endif
 .endm
 
+/* Checks if VFP/SIMD lazy flag is set, if it is branch to label. */
+.macro vfp_inlazy_mode, reg, label
+	ldr	\reg, [vcpu, #VCPU_VFP_LAZY]
+	cmp	\reg, #1
+	beq	\label
+.endm
+
 /* Configures the HDCR (Hyp Debug Configuration Register) on entry/return
  * (hardware reset value is 0) */
 .macro set_hdcr operation
-- 
1.9.1
