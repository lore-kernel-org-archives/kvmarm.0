From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 20/34] ARM: KVM: Implement HVC_RESET_VECTORS stub hypercall
 in the init code
Date: Mon,  3 Apr 2017 19:37:53 +0100
Message-ID: <20170403183807.1620-21-marc.zyngier@arm.com>
References: <20170403183807.1620-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1957F40625
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 14:37:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ysBOIj+Jbc6H for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Apr 2017 14:36:59 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3BA340B5B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 14:36:58 -0400 (EDT)
In-Reply-To: <20170403183807.1620-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Keerthy <j-keerthy@ti.com>
List-Id: kvmarm@lists.cs.columbia.edu

In order to restore HYP mode to its original condition, KVM currently
implements __kvm_hyp_reset(). As we're moving towards a hyp-stub
defined API, it becomes necessary to implement HVC_RESET_VECTORS.

This patch adds the HVC_RESET_VECTORS hypercall to the KVM init
code, which so far lacked any form of hypercall support.

Tested-by: Keerthy <j-keerthy@ti.com>
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/virt.h |  1 +
 arch/arm/kernel/hyp-stub.S  |  2 +-
 arch/arm/kvm/init.S         | 33 +++++++++++++++++++++++++++------
 3 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/arch/arm/include/asm/virt.h b/arch/arm/include/asm/virt.h
index c5a27570b225..663adc09c918 100644
--- a/arch/arm/include/asm/virt.h
+++ b/arch/arm/include/asm/virt.h
@@ -54,6 +54,7 @@ static inline void sync_boot_mode(void)
 
 void __hyp_set_vectors(unsigned long phys_vector_base);
 unsigned long __hyp_get_vectors(void);
+void __hyp_reset_vectors(void);
 #else
 #define __boot_cpu_mode	(SVC_MODE)
 #define sync_boot_mode()
diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
index e637854335aa..675c50f5cb5c 100644
--- a/arch/arm/kernel/hyp-stub.S
+++ b/arch/arm/kernel/hyp-stub.S
@@ -280,7 +280,7 @@ ENDPROC(__hyp_reset_vectors)
 #endif
 
 .align 5
-__hyp_stub_vectors:
+ENTRY(__hyp_stub_vectors)
 __hyp_stub_reset:	W(b)	.
 __hyp_stub_und:		W(b)	.
 __hyp_stub_svc:		W(b)	.
diff --git a/arch/arm/kvm/init.S b/arch/arm/kvm/init.S
index bf89c919efc1..86a7008e75a3 100644
--- a/arch/arm/kvm/init.S
+++ b/arch/arm/kvm/init.S
@@ -23,6 +23,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_mmu.h>
+#include <asm/virt.h>
 
 /********************************************************************
  * Hypervisor initialization
@@ -39,6 +40,10 @@
  * - Setup the page tables
  * - Enable the MMU
  * - Profit! (or eret, if you only care about the code).
+ *
+ * Another possibility is to get a HYP stub hypercall.
+ * We discriminate between the two by checking if r0 contains a value
+ * that is less than HVC_STUB_HCALL_NR.
  */
 
 	.text
@@ -58,6 +63,10 @@ __kvm_hyp_init:
 	W(b)	.
 
 __do_hyp_init:
+	@ Check for a stub hypercall
+	cmp	r0, #HVC_STUB_HCALL_NR
+	blo	__kvm_handle_stub_hvc
+
 	@ Set stack pointer
 	mov	sp, r0
 
@@ -112,19 +121,31 @@ __do_hyp_init:
 
 	eret
 
-	@ r0 : stub vectors address
+ENTRY(__kvm_handle_stub_hvc)
+	cmp	r0, #HVC_RESET_VECTORS
+	bne	1f
 ENTRY(__kvm_hyp_reset)
 	/* We're now in idmap, disable MMU */
 	mrc	p15, 4, r1, c1, c0, 0	@ HSCTLR
-	ldr	r2, =(HSCTLR_M | HSCTLR_A | HSCTLR_C | HSCTLR_I)
-	bic	r1, r1, r2
+	ldr	r0, =(HSCTLR_M | HSCTLR_A | HSCTLR_C | HSCTLR_I)
+	bic	r1, r1, r0
 	mcr	p15, 4, r1, c1, c0, 0	@ HSCTLR
 
-	/* Install stub vectors */
-	mcr	p15, 4, r0, c12, c0, 0	@ HVBAR
-	isb
+	/*
+	 * Install stub vectors, using ardb's VA->PA trick.
+	 */
+0:	adr	r0, 0b					@ PA(0)
+	movw	r1, #:lower16:__hyp_stub_vectors - 0b   @ VA(stub) - VA(0)
+	movt	r1, #:upper16:__hyp_stub_vectors - 0b
+	add	r1, r1, r0				@ PA(stub)
+	mcr	p15, 4, r1, c12, c0, 0	@ HVBAR
+	b	exit
+
+1:	ldr	r0, =HVC_STUB_ERR
 
+exit:
 	eret
+ENDPROC(__kvm_handle_stub_hvc)
 ENDPROC(__kvm_hyp_reset)
 
 	.ltorg
-- 
2.11.0
