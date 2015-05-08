From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 1/2] ARM: kvm: fix a bad BSYM() usage
Date: Fri, 08 May 2015 17:08:42 +0100
Message-ID: <E1YqkpO-0006zB-QJ@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7993250E6E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 May 2015 12:00:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cufNEeLWrZZz for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 May 2015 12:00:08 -0400 (EDT)
Received: from pandora.arm.linux.org.uk (pandora.arm.linux.org.uk
 [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D25A750E50
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 May 2015 12:00:06 -0400 (EDT)
Content-Disposition: inline
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave P Martin <Dave.Martin@arm.com>, Nicolas Pitre <nico@linaro.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

BSYM() should only be used when refering to local symbols in the same
assembly file which are resolved by the assembler, and not for
linker-fixed up symbols.  The use of BSYM() with panic is incorrect as
the linker is involved in fixing up this relocation, and it knows
whether panic() is ARM or Thumb.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/kvm/interrupts.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
index 79caf79b304a..87847d2c5f99 100644
--- a/arch/arm/kvm/interrupts.S
+++ b/arch/arm/kvm/interrupts.S
@@ -309,7 +309,7 @@ ENTRY(kvm_call_hyp)
 THUMB(	orr	r2, r2, #PSR_T_BIT	)
 	msr	spsr_cxsf, r2
 	mrs	r1, ELR_hyp
-	ldr	r2, =BSYM(panic)
+	ldr	r2, =panic
 	msr	ELR_hyp, r2
 	ldr	r0, =\panic_str
 	clrex				@ Clear exclusive monitor
-- 
1.8.3.1
