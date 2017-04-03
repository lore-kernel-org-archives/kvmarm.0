From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 01/34] arm64: hyp-stub: Stop pointlessly clobbering lr
Date: Mon,  3 Apr 2017 19:37:34 +0100
Message-ID: <20170403183807.1620-2-marc.zyngier@arm.com>
References: <20170403183807.1620-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6980140905
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 14:36:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZKfwoikF2L2X for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Apr 2017 14:36:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4087740190
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 14:36:22 -0400 (EDT)
In-Reply-To: <20170403183807.1620-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Keerthy <j-keerthy@ti.com>
List-Id: kvmarm@lists.cs.columbia.edu

When entering the kernel hyp stub, we check whether or not we've
made it here through an HVC instruction, clobbering lr (aka x30)
in the process.

This is completely pointless, as HVC is the only way to get here
(all traps to EL2 are disabled, no interrupt override is applied).

So let's remove this bit of code whose only point is to corrupt
a valuable register.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kernel/hyp-stub.S | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index d3b5f75e652e..e4215ad06930 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -55,12 +55,6 @@ ENDPROC(__hyp_stub_vectors)
 	.align 11
 
 el1_sync:
-	mrs	x30, esr_el2
-	lsr	x30, x30, #ESR_ELx_EC_SHIFT
-
-	cmp	x30, #ESR_ELx_EC_HVC64
-	b.ne	9f				// Not an HVC trap
-
 	cmp	x0, #HVC_GET_VECTORS
 	b.ne	1f
 	mrs	x0, vbar_el2
-- 
2.11.0
