From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 2/2] arm64: KVM: Switch vgic save/restore to alternative_insn
Date: Fri, 12 Jun 2015 12:06:37 +0100
Message-ID: <1434107197-4919-3-git-send-email-marc.zyngier@arm.com>
References: <1434107197-4919-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5194554E8A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jun 2015 06:56:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BYgAtpfPOpN0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Jun 2015 06:56:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB5CB54E8B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jun 2015 06:56:26 -0400 (EDT)
In-Reply-To: <1434107197-4919-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

So far, we configured the world-switch by having a small array
of pointers to the save and restore functions, depending on the
GIC used on the platform.

Loading these values each time is a bit silly (they never change),
and it makes sense to rely on the instruction patching instead.

This leads to a nice cleanup of the code.

Acked-by: Will Deacon <will.deacon@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_host.h   |  5 -----
 arch/arm64/include/asm/kvm_asm.h  |  5 -----
 arch/arm64/include/asm/kvm_host.h | 23 -----------------------
 arch/arm64/kernel/asm-offsets.c   |  1 -
 arch/arm64/kvm/hyp.S              | 18 ++++--------------
 virt/kvm/arm/vgic.c               |  3 ---
 6 files changed, 4 insertions(+), 51 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index d71607c..e896d2c 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -218,11 +218,6 @@ static inline int kvm_arch_dev_ioctl_check_extension(long ext)
 	return 0;
 }
 
-static inline void vgic_arch_setup(const struct vgic_params *vgic)
-{
-	BUG_ON(vgic->type != VGIC_V2);
-}
-
 int kvm_perf_init(void);
 int kvm_perf_teardown(void);
 
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 4f7310f..d13bc5e 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -132,11 +132,6 @@ extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
 extern u64 __vgic_v3_get_ich_vtr_el2(void);
 
-extern char __save_vgic_v2_state[];
-extern char __restore_vgic_v2_state[];
-extern char __save_vgic_v3_state[];
-extern char __restore_vgic_v3_state[];
-
 #endif
 
 #endif /* __ARM_KVM_ASM_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f0f58c9..2709db2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -221,29 +221,6 @@ struct vgic_sr_vectors {
 	void	*restore_vgic;
 };
 
-static inline void vgic_arch_setup(const struct vgic_params *vgic)
-{
-	extern struct vgic_sr_vectors __vgic_sr_vectors;
-
-	switch(vgic->type)
-	{
-	case VGIC_V2:
-		__vgic_sr_vectors.save_vgic	= __save_vgic_v2_state;
-		__vgic_sr_vectors.restore_vgic	= __restore_vgic_v2_state;
-		break;
-
-#ifdef CONFIG_ARM_GIC_V3
-	case VGIC_V3:
-		__vgic_sr_vectors.save_vgic	= __save_vgic_v3_state;
-		__vgic_sr_vectors.restore_vgic	= __restore_vgic_v3_state;
-		break;
-#endif
-
-	default:
-		BUG();
-	}
-}
-
 static inline void kvm_arch_hardware_disable(void) {}
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index da675cc..c99701a 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -127,7 +127,6 @@ int main(void)
   DEFINE(VCPU_VGIC_CPU,		offsetof(struct kvm_vcpu, arch.vgic_cpu));
   DEFINE(VGIC_SAVE_FN,		offsetof(struct vgic_sr_vectors, save_vgic));
   DEFINE(VGIC_RESTORE_FN,	offsetof(struct vgic_sr_vectors, restore_vgic));
-  DEFINE(VGIC_SR_VECTOR_SZ,	sizeof(struct vgic_sr_vectors));
   DEFINE(VGIC_V2_CPU_HCR,	offsetof(struct vgic_cpu, vgic_v2.vgic_hcr));
   DEFINE(VGIC_V2_CPU_VMCR,	offsetof(struct vgic_cpu, vgic_v2.vgic_vmcr));
   DEFINE(VGIC_V2_CPU_MISR,	offsetof(struct vgic_cpu, vgic_v2.vgic_misr));
diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 5befd01..f1f6d90 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -17,8 +17,10 @@
 
 #include <linux/linkage.h>
 
+#include <asm/alternative.h>
 #include <asm/asm-offsets.h>
 #include <asm/assembler.h>
+#include <asm/cpufeature.h>
 #include <asm/debug-monitors.h>
 #include <asm/esr.h>
 #include <asm/fpsimdmacros.h>
@@ -808,10 +810,7 @@
  * Call into the vgic backend for state saving
  */
 .macro save_vgic_state
-	adr	x24, __vgic_sr_vectors
-	ldr	x24, [x24, VGIC_SAVE_FN]
-	kern_hyp_va	x24
-	blr	x24
+	alternative_insn "bl __save_vgic_v2_state", "bl __save_vgic_v3_state", ARM64_HAS_SYSREG_GIC_CPUIF
 	mrs	x24, hcr_el2
 	mov	x25, #HCR_INT_OVERRIDE
 	neg	x25, x25
@@ -828,10 +827,7 @@
 	orr	x24, x24, #HCR_INT_OVERRIDE
 	orr	x24, x24, x25
 	msr	hcr_el2, x24
-	adr	x24, __vgic_sr_vectors
-	ldr	x24, [x24, #VGIC_RESTORE_FN]
-	kern_hyp_va	x24
-	blr	x24
+	alternative_insn "bl __restore_vgic_v2_state", "bl __restore_vgic_v3_state", ARM64_HAS_SYSREG_GIC_CPUIF
 .endm
 
 .macro save_timer_state
@@ -1062,12 +1058,6 @@ ENTRY(__kvm_flush_vm_context)
 	ret
 ENDPROC(__kvm_flush_vm_context)
 
-	// struct vgic_sr_vectors __vgi_sr_vectors;
-	.align 3
-ENTRY(__vgic_sr_vectors)
-	.skip	VGIC_SR_VECTOR_SZ
-ENDPROC(__vgic_sr_vectors)
-
 __kvm_hyp_panic:
 	// Guess the context by looking at VTTBR:
 	// If zero, then we're already a host.
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 78fb820..003ba74 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2128,9 +2128,6 @@ int kvm_vgic_hyp_init(void)
 		goto out_free_irq;
 	}
 
-	/* Callback into for arch code for setup */
-	vgic_arch_setup(vgic);
-
 	on_each_cpu(vgic_init_maintenance_interrupt, NULL, 1);
 
 	return 0;
-- 
2.1.4
