From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 17/25] ARM: KVM: Convert __cpu_reset_hyp_mode to using
 __hyp_reset_vectors
Date: Mon,  6 Mar 2017 14:24:50 +0000
Message-ID: <20170306142458.8875-18-marc.zyngier@arm.com>
References: <20170306142458.8875-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C0A740B58
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:25:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oYdtoUvIhLeB for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Mar 2017 09:25:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B77040C4C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:25:21 -0500 (EST)
In-Reply-To: <20170306142458.8875-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, cdall@linaro.org, james.morse@arm.com
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

We are now able to use the hyp stub to reset HYP mode. Time to
kiss __kvm_hyp_reset goodbye, and use __hyp_reset_vectors.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_asm.h  | 2 --
 arch/arm/include/asm/kvm_host.h | 2 +-
 arch/arm/kvm/init.S             | 2 --
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 8ef05381984b..7ccb6f1aac5b 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -72,8 +72,6 @@ extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
 extern void __init_stage2_translation(void);
 
-extern void __kvm_hyp_reset(unsigned long);
-
 extern u64 __vgic_v3_get_ich_vtr_el2(void);
 extern void __vgic_v3_init_lrs(void);
 #endif
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index cc495d799c67..d75638beca4e 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -274,7 +274,7 @@ static inline void __cpu_init_stage2(void)
 static inline void __cpu_reset_hyp_mode(unsigned long vector_ptr,
 					phys_addr_t phys_idmap_start)
 {
-	kvm_call_hyp((void *)virt_to_idmap(__kvm_hyp_reset), vector_ptr);
+	__hyp_reset_vectors();
 }
 
 static inline int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
diff --git a/arch/arm/kvm/init.S b/arch/arm/kvm/init.S
index 0da120b71c2e..7335a510eee4 100644
--- a/arch/arm/kvm/init.S
+++ b/arch/arm/kvm/init.S
@@ -129,7 +129,6 @@ ENTRY(__kvm_handle_stub_hvc)
 
 1:	cmp	r0, #HVC_RESET_VECTORS
 	bne	1f
-ENTRY(__kvm_hyp_reset)
 	/* We're now in idmap, disable MMU */
 	mrc	p15, 4, r1, c1, c0, 0	@ HSCTLR
 	ldr	r0, =(HSCTLR_M | HSCTLR_A | HSCTLR_C | HSCTLR_I)
@@ -151,7 +150,6 @@ ENTRY(__kvm_hyp_reset)
 exit:
 	eret
 ENDPROC(__kvm_handle_stub_hvc)
-ENDPROC(__kvm_hyp_reset)
 
 	.ltorg
 
-- 
2.11.0
