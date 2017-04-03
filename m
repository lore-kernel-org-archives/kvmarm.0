From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 24/34] ARM: KVM: Implement HVC_SOFT_RESTART in the init code
Date: Mon,  3 Apr 2017 19:37:57 +0100
Message-ID: <20170403183807.1620-25-marc.zyngier@arm.com>
References: <20170403183807.1620-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170403183807.1620-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Russell King <linux@arm.linux.org.uk>, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Keerthy <j-keerthy@ti.com>
List-Id: kvmarm@lists.cs.columbia.edu

Another missing stub hypercall is HVC_SOFT_RESTART. It turns out
that it is pretty easy to implement in terms of HVC_RESET_VECTORS
(since it needs to turn the MMU off).

Tested-by: Keerthy <j-keerthy@ti.com>
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/init.S | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/kvm/init.S b/arch/arm/kvm/init.S
index fb336090ee9c..e53360dceb19 100644
--- a/arch/arm/kvm/init.S
+++ b/arch/arm/kvm/init.S
@@ -127,8 +127,22 @@ ENTRY(__kvm_handle_stub_hvc)
 	mrc	p15, 4, r0, c12, c0, 0	@ get HVBAR
 	b	exit
 
+1:	cmp	r0, #HVC_SOFT_RESTART
+	bne	1f
+
+	/* The target is expected in r1 */
+	msr	ELR_hyp, r1
+	mrs	r0, cpsr
+	bic	r0, r0, #MODE_MASK
+	orr	r0, r0, #HYP_MODE
+THUMB(	orr	r0, r0, #PSR_T_BIT	)
+	msr	spsr_cxsf, r0
+	b	reset
+
 1:	cmp	r0, #HVC_RESET_VECTORS
 	bne	1f
+
+reset:
 	/* We're now in idmap, disable MMU */
 	mrc	p15, 4, r1, c1, c0, 0	@ HSCTLR
 	ldr	r0, =(HSCTLR_M | HSCTLR_A | HSCTLR_C | HSCTLR_I)
-- 
2.11.0
