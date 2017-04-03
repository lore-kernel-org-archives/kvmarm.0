From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 10/34] arm64: KVM: Convert __cpu_reset_hyp_mode to using __hyp_reset_vectors
Date: Mon,  3 Apr 2017 19:37:43 +0100
Message-ID: <20170403183807.1620-11-marc.zyngier@arm.com>
References: <20170403183807.1620-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170403183807.1620-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Russell King <linux@arm.linux.org.uk>, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Keerthy <j-keerthy@ti.com>
List-Id: kvmarm@lists.cs.columbia.edu

We are now able to use the hyp stub to reset HYP mode. Time to
kiss __kvm_hyp_reset goodbye, and use __hyp_reset_vectors.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h  |  1 -
 arch/arm64/include/asm/kvm_host.h |  3 +--
 arch/arm64/kvm/hyp-init.S         |  2 --
 arch/arm64/kvm/hyp/hyp-entry.S    | 15 ---------------
 4 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 1769380a8fc0..60941c3c35f7 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -47,7 +47,6 @@ struct kvm_vcpu;
 
 extern char __kvm_hyp_init[];
 extern char __kvm_hyp_init_end[];
-extern char __kvm_hyp_reset[];
 
 extern char __kvm_hyp_vector[];
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e7705e7bb07b..0355dd109956 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -362,11 +362,10 @@ static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
 	__kvm_call_hyp((void *)pgd_ptr, hyp_stack_ptr, vector_ptr);
 }
 
-void __kvm_hyp_teardown(void);
 static inline void __cpu_reset_hyp_mode(unsigned long vector_ptr,
 					phys_addr_t phys_idmap_start)
 {
-	kvm_call_hyp(__kvm_hyp_teardown, phys_idmap_start);
+	__hyp_reset_vectors();
 }
 
 static inline void kvm_arch_hardware_unsetup(void) {}
diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index fded932ede1b..b7a8f12293cc 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -134,7 +134,6 @@ ENTRY(__kvm_handle_stub_hvc)
 	/*
 	 * Reset kvm back to the hyp stub.
 	 */
-ENTRY(__kvm_hyp_reset)
 	/* We're now in idmap, disable MMU */
 	mrs	x0, sctlr_el2
 	ldr	x1, =SCTLR_ELx_FLAGS
@@ -152,7 +151,6 @@ ENTRY(__kvm_hyp_reset)
 
 exit:
 	eret
-ENDPROC(__kvm_hyp_reset)
 ENDPROC(__kvm_handle_stub_hvc)
 
 	.ltorg
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 4f34c5996f86..5170ce1021da 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -53,21 +53,6 @@ ENTRY(__vhe_hyp_call)
 	ret
 ENDPROC(__vhe_hyp_call)
 
-/*
- * Compute the idmap address of __kvm_hyp_reset based on the idmap
- * start passed as a parameter, and jump there.
- *
- * x0: HYP phys_idmap_start
- */
-ENTRY(__kvm_hyp_teardown)
-	mov	x4, x0
-	adr_l	x3, __kvm_hyp_reset
-
-	/* insert __kvm_hyp_reset()s offset into phys_idmap_start */
-	bfi	x4, x3, #0, #PAGE_SHIFT
-	br	x4
-ENDPROC(__kvm_hyp_teardown)
-	
 el1_sync:				// Guest trapped into EL2
 	stp	x0, x1, [sp, #-16]!
 
-- 
2.11.0
