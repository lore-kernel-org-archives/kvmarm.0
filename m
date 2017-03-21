From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 03/28] arm64: hyp-stub: Don't save lr in the EL1 code
Date: Tue, 21 Mar 2017 19:20:33 +0000
Message-ID: <20170321192058.9300-4-marc.zyngier@arm.com>
References: <20170321192058.9300-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F95540C90
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 15:20:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yKd-jq3hwlPM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 15:20:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF1F340C2A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 15:20:05 -0400 (EDT)
In-Reply-To: <20170321192058.9300-1-marc.zyngier@arm.com>
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

The EL2 code is not corrupting lr anymore, so don't bother preserving
it in the EL1 trampoline code.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kernel/hyp-stub.S | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index e4215ad06930..193dfb25ce2f 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -116,18 +116,14 @@ ENDPROC(\label)
  */
 
 ENTRY(__hyp_get_vectors)
-	str	lr, [sp, #-16]!
 	mov	x0, #HVC_GET_VECTORS
 	hvc	#0
-	ldr	lr, [sp], #16
 	ret
 ENDPROC(__hyp_get_vectors)
 
 ENTRY(__hyp_set_vectors)
-	str	lr, [sp, #-16]!
 	mov	x1, x0
 	mov	x0, #HVC_SET_VECTORS
 	hvc	#0
-	ldr	lr, [sp], #16
 	ret
 ENDPROC(__hyp_set_vectors)
-- 
2.11.0
