From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 02/22] arm64: KVM: Implement HVC_RESET_VECTORS stub hypercall
Date: Thu, 23 Feb 2017 10:26:37 +0000
Message-ID: <20170223102657.23100-3-marc.zyngier@arm.com>
References: <20170223102657.23100-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170223102657.23100-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Russell King <linux@arm.linux.org.uk>, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
