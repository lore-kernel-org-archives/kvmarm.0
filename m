From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 18/25] ARM: KVM: Implement HVC_SOFT_RESTART in the init code
Date: Mon,  6 Mar 2017 14:24:51 +0000
Message-ID: <20170306142458.8875-19-marc.zyngier@arm.com>
References: <20170306142458.8875-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4D1540C4F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:25:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2SIheAan8vI9 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Mar 2017 09:25:23 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A379D40B58
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:25:23 -0500 (EST)
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
 arch/arm/kvm/init.S | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/kvm/init.S b/arch/arm/kvm/init.S
index 7335a510eee4..c92e092103b2 100644
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
