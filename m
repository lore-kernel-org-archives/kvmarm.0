From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 02/25] arm64: KVM: Implement HVC_RESET_VECTORS stub
 hypercall
Date: Mon,  6 Mar 2017 14:24:35 +0000
Message-ID: <20170306142458.8875-3-marc.zyngier@arm.com>
References: <20170306142458.8875-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF0D640C2A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:24:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FL6iqQrJeVCi for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Mar 2017 09:24:45 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 868AC40BE4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:24:45 -0500 (EST)
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

In order to restore HYP mode to its original condition, KVM currently
implements __kvm_hyp_reset(). As we're moving towards a hyp-stub
defined API, it becomes necessary to implement HVC_RESET_VECTORS.

This patch adds the HVC_RESET_VECTORS hypercall to the KVM init
code, which so far lacked any form of hypercall support.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp-init.S | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 6b29d3d9e1f2..6cf98ccd10f2 100644
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
@@ -133,9 +140,14 @@ ENTRY(__kvm_hyp_reset)
 	/* Install stub vectors */
 	adr_l	x0, __hyp_stub_vectors
 	msr	vbar_el2, x0
+	b	exit
 
+1:	mov	x0, #-1
+
+exit:
 	eret
 ENDPROC(__kvm_hyp_reset)
+ENDPROC(__kvm_handle_stub_hvc)
 
 	.ltorg
 
-- 
2.11.0
