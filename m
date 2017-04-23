From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 47/79] ARM: hyp-stub: improve ABI
Date: Sun, 23 Apr 2017 19:08:57 +0200
Message-ID: <20170423170929.27334-48-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EAC149C44
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xEEK259x86Q0 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:07:36 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8428249CD0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:35 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id m123so50340219wma.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:21 -0700 (PDT)
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

Improve the hyp-stub ABI to allow it to do more than just get/set the
vectors.  We follow the example in ARM64, where r0 is used as an opcode
with the other registers as an argument.

Tested-by: Keerthy <j-keerthy@ti.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm/kernel/hyp-stub.S | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
index 15d073a..f3e9ba5 100644
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
2.9.0
