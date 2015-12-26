From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v6 3/6] arm/arm64: KVM: Enable armv7 fp/simd enhanced context
 switch
Date: Sat, 26 Dec 2015 13:54:57 -0800
Message-ID: <1451166900-3711-4-git-send-email-m.smarduch@samsung.com>
References: <1451166900-3711-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0F0240F90
 for <kvmarm@lists.cs.columbia.edu>; Sat, 26 Dec 2015 16:52:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m2AHrjaVKxAv for <kvmarm@lists.cs.columbia.edu>;
 Sat, 26 Dec 2015 16:52:38 -0500 (EST)
Received: from usmailout4.samsung.com (mailout4.w2.samsung.com
 [211.189.100.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DC05940C9D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 26 Dec 2015 16:52:38 -0500 (EST)
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NZZ00CQDJKQVB20@usmailout4.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Sat, 26 Dec 2015 16:55:38 -0500 (EST)
In-reply-to: <1451166900-3711-1-git-send-email-m.smarduch@samsung.com>
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

Enable armv7 enhanced fp/simd context switch. Guest and host registers are only
context switched on first access and vcpu put. 

Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
---
 arch/arm/include/asm/kvm_host.h   |  2 ++
 arch/arm/kernel/asm-offsets.c     |  1 +
 arch/arm/kvm/arm.c                | 10 +++++++++
 arch/arm/kvm/interrupts.S         | 43 ++++++++++++++-------------------------
 arch/arm64/include/asm/kvm_host.h |  2 ++
 5 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index d3ef58a..90f7f59 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -238,6 +238,8 @@ void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 
+void vcpu_restore_host_vfp_state(struct kvm_vcpu *);
+
 static inline void kvm_arch_hardware_disable(void) {}
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
index 871b826..395ecca 100644
--- a/arch/arm/kernel/asm-offsets.c
+++ b/arch/arm/kernel/asm-offsets.c
@@ -185,6 +185,7 @@ int main(void)
   DEFINE(VCPU_PC,		offsetof(struct kvm_vcpu, arch.regs.usr_regs.ARM_pc));
   DEFINE(VCPU_CPSR,		offsetof(struct kvm_vcpu, arch.regs.usr_regs.ARM_cpsr));
   DEFINE(VCPU_HCR,		offsetof(struct kvm_vcpu, arch.hcr));
+  DEFINE(VCPU_HCPTR,		offsetof(struct kvm_vcpu, arch.hcptr));
   DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
   DEFINE(VCPU_HSR,		offsetof(struct kvm_vcpu, arch.fault.hsr));
   DEFINE(VCPU_HxFAR,		offsetof(struct kvm_vcpu, arch.fault.hxfar));
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index dda1959..b16ed98 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -308,10 +308,20 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	vcpu->arch.host_cpu_context = this_cpu_ptr(kvm_host_cpu_state);
 
 	kvm_arm_set_running_vcpu(vcpu);
+
+	/* Save and enable fpexc, and enable default traps */
+	vcpu_trap_vfp_enable(vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	/* If the fp/simd registers are dirty save guest, restore host. */
+	if (vcpu_vfp_isdirty(vcpu))
+		vcpu_restore_host_vfp_state(vcpu);
+
+	/* Restore host FPEXC trashed in vcpu_load */
+	vcpu_restore_host_fpexc(vcpu);
+
 	/*
 	 * The arch-generic KVM code expects the cpu field of a vcpu to be -1
 	 * if the vcpu is no longer assigned to a cpu.  This is used for the
diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
index 900ef6d..245c11f 100644
--- a/arch/arm/kvm/interrupts.S
+++ b/arch/arm/kvm/interrupts.S
@@ -116,22 +116,15 @@ ENTRY(__kvm_vcpu_run)
 	read_cp15_state store_to_vcpu = 0
 	write_cp15_state read_from_vcpu = 1
 
-	@ If the host kernel has not been configured with VFPv3 support,
-	@ then it is safer if we deny guests from using it as well.
-#ifdef CONFIG_VFPv3
-	@ Set FPEXC_EN so the guest doesn't trap floating point instructions
-	VFPFMRX r2, FPEXC		@ VMRS
-	push	{r2}
-	orr	r2, r2, #FPEXC_EN
-	VFPFMXR FPEXC, r2		@ VMSR
-#endif
+	@ Configure trapping of access to tracing and fp/simd registers
+	ldr r1, [vcpu, #VCPU_HCPTR]
+	mcr p15, 4, r1, c1, c1, 2
 
 	@ Configure Hyp-role
 	configure_hyp_role vmentry
 
 	@ Trap coprocessor CRx accesses
 	set_hstr vmentry
-	set_hcptr vmentry, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11))
 	set_hdcr vmentry
 
 	@ Write configured ID register into MIDR alias
@@ -170,23 +163,10 @@ __kvm_vcpu_return:
 	@ Don't trap coprocessor accesses for host kernel
 	set_hstr vmexit
 	set_hdcr vmexit
-	set_hcptr vmexit, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11)), after_vfp_restore
 
-#ifdef CONFIG_VFPv3
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
-	VFPFMXR FPEXC, r2
-#else
-after_vfp_restore:
-#endif
+	@ Disable trace and fp/simd traps
+	mov r2, #0
+	mcr p15, 4, r2, c1, c1, 2
 
 	@ Reset Hyp-role
 	configure_hyp_role vmexit
@@ -482,8 +462,15 @@ guest_trap:
 switch_to_guest_vfp:
 	push	{r3-r7}
 
-	@ NEON/VFP used.  Turn on VFP access.
-	set_hcptr vmtrap, (HCPTR_TCP(10) | HCPTR_TCP(11))
+	@ fp/simd was accessed, so disable trapping and save hcptr register
+	@ which is used across exits until next vcpu_load.
+	mrc     p15, 4, r2, c1, c1, 2
+	mov     r3, #(HCPTR_TCP(10) | HCPTR_TCP(11))
+	bic     r3, r2, r3
+	mcr     p15, 4, r3, c1, c1, 2
+	str     r3, [vcpu, #VCPU_HCPTR]
+
+	isb
 
 	@ Switch VFP/NEON hardware state to the guest's
 	add	r7, r0, #VCPU_VFP_HOST
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 689d4c9..bfe4d4e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -338,6 +338,8 @@ static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 
+static inline void vcpu_restore_host_vfp_state(struct kvm_vcpu *vcpu) {}
+
 void kvm_arm_init_debug(void);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
-- 
1.9.1
