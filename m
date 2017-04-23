From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 59/79] ARM: KVM: Implement HVC_SOFT_RESTART in the init code
Date: Sun, 23 Apr 2017 19:09:09 +0200
Message-ID: <20170423170929.27334-60-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09A4D49D5E
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id al-c-a0hPWqn for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:07:53 -0400 (EDT)
Received: from mail-wr0-f171.google.com (mail-wr0-f171.google.com
 [209.85.128.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8151E49D0D
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:48 -0400 (EDT)
Received: by mail-wr0-f171.google.com with SMTP id z109so79246655wrb.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:34 -0700 (PDT)
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

Tested-by: Keerthy <j-keerthy@ti.com>
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm/kvm/init.S | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/kvm/init.S b/arch/arm/kvm/init.S
index fb33609..e53360d 100644
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
2.9.0
