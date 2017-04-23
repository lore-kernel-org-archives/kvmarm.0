From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 42/79] arm64: KVM: Implement HVC_RESET_VECTORS stub hypercall
 in the init code
Date: Sun, 23 Apr 2017 19:08:52 +0200
Message-ID: <20170423170929.27334-43-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29D0549CD6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wKP8REs2Fy7s for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:07:33 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B543B49C67
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:29 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id w64so46376949wma.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:16 -0700 (PDT)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

In order to restore HYP mode to its original condition, KVM currently
implements __kvm_hyp_reset(). As we're moving towards a hyp-stub
defined API, it becomes necessary to implement HVC_RESET_VECTORS.

This patch adds the HVC_RESET_VECTORS hypercall to the KVM init
code, which so far lacked any form of hypercall support.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm64/kvm/hyp-init.S | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 6b29d3d..5e39ad5 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -22,6 +22,7 @@
 #include <asm/kvm_mmu.h>
 #include <asm/pgtable-hwdef.h>
 #include <asm/sysreg.h>
+#include <asm/virt.h>
 
 	.text
 	.pushsection	.hyp.idmap.text, "ax"
@@ -58,6 +59,9 @@ __invalid:
 	 * x2: HYP vectors
 	 */
 __do_hyp_init:
+	/* Check for a stub HVC call */
+	cmp	x0, #HVC_STUB_HCALL_NR
+	b.lo	__kvm_handle_stub_hvc
 
 	msr	ttbr0_el2, x0
 
@@ -119,6 +123,9 @@ __do_hyp_init:
 	eret
 ENDPROC(__kvm_hyp_init)
 
+ENTRY(__kvm_handle_stub_hvc)
+	cmp	x0, #HVC_RESET_VECTORS
+	b.ne	1f
 	/*
 	 * Reset kvm back to the hyp stub.
 	 */
@@ -133,9 +140,15 @@ ENTRY(__kvm_hyp_reset)
 	/* Install stub vectors */
 	adr_l	x0, __hyp_stub_vectors
 	msr	vbar_el2, x0
+	b	exit
 
+1:	/* Bad stub call */
+	ldr	x0, =HVC_STUB_ERR
+
+exit:
 	eret
 ENDPROC(__kvm_hyp_reset)
+ENDPROC(__kvm_handle_stub_hvc)
 
 	.ltorg
 
-- 
2.9.0
