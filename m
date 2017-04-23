From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 46/79] arm64: KVM: Implement HVC_SOFT_RESTART in the init code
Date: Sun, 23 Apr 2017 19:08:56 +0200
Message-ID: <20170423170929.27334-47-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDCB649C7F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4NhJEGtIOQVH for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:07:35 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 981AF49CFA
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:34 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id u65so7505707wmu.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:20 -0700 (PDT)
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

Another missing stub hypercall is HVC_SOFT_RESTART. It turns out
that it is pretty easy to implement in terms of HVC_RESET_VECTORS
(since it needs to turn the MMU off).

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm64/kvm/hyp-init.S | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index b7a8f12..0ad34fd 100644
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
2.9.0
