From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 3/3] arm64/kvm: use alternative auto-nop
Date: Wed,  7 Sep 2016 11:07:10 +0100
Message-ID: <1473242830-26246-4-git-send-email-mark.rutland@arm.com>
References: <1473242830-26246-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4448249B4C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Sep 2016 05:59:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XUAM7For0Zgk for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Sep 2016 05:59:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0B2149B6B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Sep 2016 05:59:15 -0400 (EDT)
In-Reply-To: <1473242830-26246-1-git-send-email-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, will.deacon@arm.com, dave.martin@arm.com, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Make use of the new alternative_if and alternative_else_nop_endif and
get rid of our homebew NOP sleds, making the code simpler to read.

Note that for __kvm_call_hyp the branch to __vhe_hyp_call has been moved
out of the alternative sequence, and in the default case there will be
four additional NOPs executed.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/include/asm/kvm_mmu.h | 10 +++-------
 arch/arm64/kvm/hyp.S             |  6 +-----
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index b6bb834..dff1098 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -99,14 +99,10 @@
 .macro kern_hyp_va	reg
 alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
 	and     \reg, \reg, #HYP_PAGE_OFFSET_HIGH_MASK
-alternative_else
-	nop
-alternative_endif
-alternative_if_not ARM64_HYP_OFFSET_LOW
-	nop
-alternative_else
+alternative_else_nop_endif
+alternative_if ARM64_HYP_OFFSET_LOW
 	and     \reg, \reg, #HYP_PAGE_OFFSET_LOW_MASK
-alternative_endif
+alternative_else_nop_endif
 .endm
 
 #else
diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 7ce9315..2726635 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -46,10 +46,6 @@ alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
 	hvc	#0
 	ldr     lr, [sp], #16
 	ret
-alternative_else
+alternative_else_nop_endif
 	b	__vhe_hyp_call
-	nop
-	nop
-	nop
-alternative_endif
 ENDPROC(__kvm_call_hyp)
-- 
1.9.1
