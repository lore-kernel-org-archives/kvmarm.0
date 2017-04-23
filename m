From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 48/79] ARM: soft-reboot into same mode that we entered the
 kernel
Date: Sun, 23 Apr 2017 19:08:58 +0200
Message-ID: <20170423170929.27334-49-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A905649C79
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lHw1iJbJduma for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:07:40 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A686A49CF7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:36 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id w64so46377826wma.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:23 -0700 (PDT)
In-Reply-To: <20170423170929.27334-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Russell King <rmk+kernel@armlinux.org.uk>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Russell King <rmk+kernel@armlinux.org.uk>

When we soft-reboot (eg, kexec) from one kernel into the next, we need
to ensure that we enter the new kernel in the same processor mode as
when we were entered, so that (eg) the new kernel can install its own
hypervisor - the old kernel's hypervisor will have been overwritten.

In order to do this, we need to pass a flag to cpu_reset() so it knows
what to do, and we need to modify the kernel's own hypervisor stub to
allow it to handle a soft-reboot.

As we are always guaranteed to install our own hypervisor if we're
entered in HYP32 mode, and KVM will have moved itself out of the way
on kexec/normal reboot, we can assume that our hypervisor is in place
when we want to kexec, so changing our hypervisor API should not be a
problem.

Tested-by: Keerthy <j-keerthy@ti.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm/include/asm/proc-fns.h |  4 ++--
 arch/arm/kernel/hyp-stub.S      | 13 +++++++++++++
 arch/arm/kernel/reboot.c        |  7 +++++--
 arch/arm/mm/proc-v7.S           | 12 ++++++++----
 4 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/arch/arm/include/asm/proc-fns.h b/arch/arm/include/asm/proc-fns.h
index 8877ad5..f2e1af4 100644
--- a/arch/arm/include/asm/proc-fns.h
+++ b/arch/arm/include/asm/proc-fns.h
@@ -43,7 +43,7 @@ extern struct processor {
 	/*
 	 * Special stuff for a reset
 	 */
-	void (*reset)(unsigned long addr) __attribute__((noreturn));
+	void (*reset)(unsigned long addr, bool hvc) __attribute__((noreturn));
 	/*
 	 * Idle the processor
 	 */
@@ -88,7 +88,7 @@ extern void cpu_set_pte_ext(pte_t *ptep, pte_t pte);
 #else
 extern void cpu_set_pte_ext(pte_t *ptep, pte_t pte, unsigned int ext);
 #endif
-extern void cpu_reset(unsigned long addr) __attribute__((noreturn));
+extern void cpu_reset(unsigned long addr, bool hvc) __attribute__((noreturn));
 
 /* These three are private to arch/arm/kernel/suspend.c */
 extern void cpu_do_suspend(void *);
diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
index f3e9ba5..8291523 100644
--- a/arch/arm/kernel/hyp-stub.S
+++ b/arch/arm/kernel/hyp-stub.S
@@ -24,6 +24,7 @@
 
 #define HVC_GET_VECTORS 0
 #define HVC_SET_VECTORS 1
+#define HVC_SOFT_RESTART 2
 
 #ifndef ZIMAGE
 /*
@@ -215,6 +216,10 @@ __hyp_stub_do_trap:
 	mcr	p15, 4, r1, c12, c0, 0	@ set HVBAR
 	b	__hyp_stub_exit
 
+1:	teq	r0, #HVC_SOFT_RESTART
+	bne	1f
+	bx	r3
+
 1:	mov	r0, #-1
 
 __hyp_stub_exit:
@@ -256,6 +261,14 @@ ENTRY(__hyp_set_vectors)
 	ret	lr
 ENDPROC(__hyp_set_vectors)
 
+ENTRY(__hyp_soft_restart)
+	mov	r3, r0
+	mov	r0, #HVC_SOFT_RESTART
+	__HVC(0)
+	mov	r0, r3
+	ret	lr
+ENDPROC(__hyp_soft_restart)
+
 #ifndef ZIMAGE
 .align 2
 .L__boot_cpu_mode_offset:
diff --git a/arch/arm/kernel/reboot.c b/arch/arm/kernel/reboot.c
index 3fa867a..3b2aa9a 100644
--- a/arch/arm/kernel/reboot.c
+++ b/arch/arm/kernel/reboot.c
@@ -12,10 +12,11 @@
 
 #include <asm/cacheflush.h>
 #include <asm/idmap.h>
+#include <asm/virt.h>
 
 #include "reboot.h"
 
-typedef void (*phys_reset_t)(unsigned long);
+typedef void (*phys_reset_t)(unsigned long, bool);
 
 /*
  * Function pointers to optional machine specific functions
@@ -51,7 +52,9 @@ static void __soft_restart(void *addr)
 
 	/* Switch to the identity mapping. */
 	phys_reset = (phys_reset_t)virt_to_idmap(cpu_reset);
-	phys_reset((unsigned long)addr);
+
+	/* original stub should be restored by kvm */
+	phys_reset((unsigned long)addr, is_hyp_mode_available());
 
 	/* Should never get here. */
 	BUG();
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index d00d52c..1846ca4 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -53,11 +53,15 @@ ENDPROC(cpu_v7_proc_fin)
 	.align	5
 	.pushsection	.idmap.text, "ax"
 ENTRY(cpu_v7_reset)
-	mrc	p15, 0, r1, c1, c0, 0		@ ctrl register
-	bic	r1, r1, #0x1			@ ...............m
- THUMB(	bic	r1, r1, #1 << 30 )		@ SCTLR.TE (Thumb exceptions)
-	mcr	p15, 0, r1, c1, c0, 0		@ disable MMU
+	mrc	p15, 0, r2, c1, c0, 0		@ ctrl register
+	bic	r2, r2, #0x1			@ ...............m
+ THUMB(	bic	r2, r2, #1 << 30 )		@ SCTLR.TE (Thumb exceptions)
+	mcr	p15, 0, r2, c1, c0, 0		@ disable MMU
 	isb
+#ifdef CONFIG_ARM_VIRT_EXT
+	teq	r1, #0
+	bne	__hyp_soft_restart
+#endif
 	bx	r0
 ENDPROC(cpu_v7_reset)
 	.popsection
-- 
2.9.0
