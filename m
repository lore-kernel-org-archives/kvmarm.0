From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 06/25] arm64: KVM: Implement HVC_SOFT_RESTART in the init
 code
Date: Mon,  6 Mar 2017 14:24:39 +0000
Message-ID: <20170306142458.8875-7-marc.zyngier@arm.com>
References: <20170306142458.8875-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6541B40C51
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:24:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AloizzA6bTKd for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Mar 2017 09:24:55 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED25540C27
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:24:54 -0500 (EST)
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

Another missing stub hypercall is HVC_SOFT_RESTART. It turns out
that it is pretty easy to implement in terms of HVC_RESET_VECTORS
(since it needs to turn the MMU off).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp-init.S | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index b53e95efc1c5..128d6e9732b9 100644
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
 
 1:	mov	x0, #-1
-- 
2.11.0
