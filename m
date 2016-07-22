From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 21/55] arm: KVM: Allow hyp teardown
Date: Fri, 22 Jul 2016 18:28:38 +0100
Message-ID: <1469208552-4155-22-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Dan Carpenter <dan.carpenter@oracle.com>, Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

So far, KVM was getting in the way of kexec on 32bit (and the arm64
kexec hackers couldn't be bothered to fix it on 32bit...).

With simpler page tables, tearing KVM down becomes very easy, so
let's just do it.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_asm.h    |  2 ++
 arch/arm/include/asm/kvm_host.h   |  8 +++-----
 arch/arm/kvm/arm.c                |  3 ++-
 arch/arm/kvm/init.S               | 15 +++++++++++++++
 arch/arm64/include/asm/kvm_host.h |  3 ++-
 5 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 3d5a5cd..58faff5 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -66,6 +66,8 @@ extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
 extern void __init_stage2_translation(void);
+
+extern void __kvm_hyp_reset(unsigned long);
 #endif
 
 #endif /* __ARM_KVM_ASM_H__ */
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index eafbfd5..58d0b69 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -266,12 +266,10 @@ static inline void __cpu_init_stage2(void)
 	kvm_call_hyp(__init_stage2_translation);
 }
 
-static inline void __cpu_reset_hyp_mode(phys_addr_t phys_idmap_start)
+static inline void __cpu_reset_hyp_mode(unsigned long vector_ptr,
+					phys_addr_t phys_idmap_start)
 {
-	/*
-	 * TODO
-	 * kvm_call_reset(phys_idmap_start);
-	 */
+	kvm_call_hyp((void *)virt_to_idmap(__kvm_hyp_reset), vector_ptr);
 }
 
 static inline int kvm_arch_dev_ioctl_check_extension(long ext)
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 9b8c537..7cf266c 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -1074,7 +1074,8 @@ static void cpu_hyp_reinit(void)
 static void cpu_hyp_reset(void)
 {
 	if (!is_kernel_in_hyp_mode())
-		__cpu_reset_hyp_mode(kvm_get_idmap_start());
+		__cpu_reset_hyp_mode(hyp_default_vectors,
+				     kvm_get_idmap_start());
 }
 
 static void _kvm_arch_hardware_enable(void *discard)
diff --git a/arch/arm/kvm/init.S b/arch/arm/kvm/init.S
index b82a99d..bf89c91 100644
--- a/arch/arm/kvm/init.S
+++ b/arch/arm/kvm/init.S
@@ -112,6 +112,21 @@ __do_hyp_init:
 
 	eret
 
+	@ r0 : stub vectors address
+ENTRY(__kvm_hyp_reset)
+	/* We're now in idmap, disable MMU */
+	mrc	p15, 4, r1, c1, c0, 0	@ HSCTLR
+	ldr	r2, =(HSCTLR_M | HSCTLR_A | HSCTLR_C | HSCTLR_I)
+	bic	r1, r1, r2
+	mcr	p15, 4, r1, c1, c0, 0	@ HSCTLR
+
+	/* Install stub vectors */
+	mcr	p15, 4, r0, c12, c0, 0	@ HVBAR
+	isb
+
+	eret
+ENDPROC(__kvm_hyp_reset)
+
 	.ltorg
 
 	.globl __kvm_hyp_init_end
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6731d4e..69d5cc2d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -359,7 +359,8 @@ static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
 }
 
 void __kvm_hyp_teardown(void);
-static inline void __cpu_reset_hyp_mode(phys_addr_t phys_idmap_start)
+static inline void __cpu_reset_hyp_mode(unsigned long vector_ptr,
+					phys_addr_t phys_idmap_start)
 {
 	kvm_call_hyp(__kvm_hyp_teardown, phys_idmap_start);
 }
-- 
2.8.1

