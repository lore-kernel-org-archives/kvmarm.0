From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 07/25] ARM: hyp-stub: improve ABI
Date: Mon,  6 Mar 2017 14:24:40 +0000
Message-ID: <20170306142458.8875-8-marc.zyngier@arm.com>
References: <20170306142458.8875-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B51A040BDE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:24:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ge33MsYRbo+H for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Mar 2017 09:24:57 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B65140C54
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:24:57 -0500 (EST)
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
Cc: Russell King <rmk+kernel@armlinux.org.uk>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Russell King <rmk+kernel@armlinux.org.uk>

Improve the hyp-stub ABI to allow it to do more than just get/set the
vectors.  We follow the example in ARM64, where r0 is used as an opcode
with the other registers as an argument.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kernel/hyp-stub.S | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
index 15d073ae5da2..f3e9ba5fb642 100644
--- a/arch/arm/kernel/hyp-stub.S
+++ b/arch/arm/kernel/hyp-stub.S
@@ -22,6 +22,9 @@
 #include <asm/assembler.h>
 #include <asm/virt.h>
 
+#define HVC_GET_VECTORS 0
+#define HVC_SET_VECTORS 1
+
 #ifndef ZIMAGE
 /*
  * For the kernel proper, we need to find out the CPU boot mode long after
@@ -202,9 +205,19 @@ ARM_BE8(orr	r7, r7, #(1 << 25))     @ HSCTLR.EE
 ENDPROC(__hyp_stub_install_secondary)
 
 __hyp_stub_do_trap:
-	cmp	r0, #-1
-	mrceq	p15, 4, r0, c12, c0, 0	@ get HVBAR
-	mcrne	p15, 4, r0, c12, c0, 0	@ set HVBAR
+	teq	r0, #HVC_GET_VECTORS
+	bne	1f
+	mrc	p15, 4, r0, c12, c0, 0	@ get HVBAR
+	b	__hyp_stub_exit
+
+1:	teq	r0, #HVC_SET_VECTORS
+	bne	1f
+	mcr	p15, 4, r1, c12, c0, 0	@ set HVBAR
+	b	__hyp_stub_exit
+
+1:	mov	r0, #-1
+
+__hyp_stub_exit:
 	__ERET
 ENDPROC(__hyp_stub_do_trap)
 
@@ -231,10 +244,14 @@ ENDPROC(__hyp_stub_do_trap)
  * initialisation entry point.
  */
 ENTRY(__hyp_get_vectors)
-	mov	r0, #-1
+	mov	r0, #HVC_GET_VECTORS
+	__HVC(0)
+	ret	lr
 ENDPROC(__hyp_get_vectors)
-	@ fall through
+
 ENTRY(__hyp_set_vectors)
+	mov	r1, r0
+	mov	r0, #HVC_SET_VECTORS
 	__HVC(0)
 	ret	lr
 ENDPROC(__hyp_set_vectors)
-- 
2.11.0
