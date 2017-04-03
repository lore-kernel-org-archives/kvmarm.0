From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 11/34] arm64: KVM: Implement HVC_SOFT_RESTART in the init code
Date: Mon,  3 Apr 2017 19:37:44 +0100
Message-ID: <20170403183807.1620-12-marc.zyngier@arm.com>
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

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp-init.S | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index b7a8f12293cc..0ad34fd6d2fc 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -129,21 +129,36 @@ ENTRY(__kvm_handle_stub_hvc)
 	mrs	x0, vbar_el2
 	b	exit
 
+1:	cmp	x0, #HVC_SOFT_RESTART
+	b.ne	1f
+
+	/* This is where we're about to jump, staying at EL2 */
+	msr	elr_el2, x1
+	mov	x0, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT | PSR_MODE_EL2h)
+	msr	spsr_el2, x0
+
+	/* Shuffle the arguments, and don't come back */
+	mov	x0, x2
+	mov	x1, x3
+	mov	x2, x4
+	b	reset
+
 1:	cmp	x0, #HVC_RESET_VECTORS
 	b.ne	1f
+reset:
 	/*
-	 * Reset kvm back to the hyp stub.
+	 * Reset kvm back to the hyp stub. Do not clobber x0-x4 in
+	 * case we coming via HVC_SOFT_RESTART.
 	 */
-	/* We're now in idmap, disable MMU */
-	mrs	x0, sctlr_el2
-	ldr	x1, =SCTLR_ELx_FLAGS
-	bic	x0, x0, x1		// Clear SCTL_M and etc
-	msr	sctlr_el2, x0
+	mrs	x5, sctlr_el2
+	ldr	x6, =SCTLR_ELx_FLAGS
+	bic	x5, x5, x6		// Clear SCTL_M and etc
+	msr	sctlr_el2, x5
 	isb
 
 	/* Install stub vectors */
-	adr_l	x0, __hyp_stub_vectors
-	msr	vbar_el2, x0
+	adr_l	x5, __hyp_stub_vectors
+	msr	vbar_el2, x5
 	b	exit
 
 1:	/* Bad stub call */
-- 
2.11.0
