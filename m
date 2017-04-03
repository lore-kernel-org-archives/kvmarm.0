From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 32/34] arm64: hyp-stub: Zero x0 on successful stub handling
Date: Mon,  3 Apr 2017 19:38:05 +0100
Message-ID: <20170403183807.1620-33-marc.zyngier@arm.com>
References: <20170403183807.1620-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28BAC40BAC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 14:37:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jlyt9QSLoqhc for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Apr 2017 14:37:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E55D40CE4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 14:37:21 -0400 (EDT)
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

We now return HVC_STUB_ERR when a stub hypercall fails, but we
leave whatever was in x0 on success. Zeroing it on return seems
like a good idea.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kernel/hyp-stub.S | 4 +++-
 arch/arm64/kvm/hyp-init.S    | 6 +++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index d55604d91e33..e1261fbaa374 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -73,8 +73,10 @@ el1_sync:
 
 	/* Someone called kvm_call_hyp() against the hyp-stub... */
 	ldr	x0, =HVC_STUB_ERR
+	eret
 
-9:	eret
+9:	mov	x0, xzr
+	eret
 ENDPROC(el1_sync)
 
 .macro invalid_vector	label
diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 3734e6315cd7..839425c24b1c 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -154,13 +154,13 @@ reset:
 	/* Install stub vectors */
 	adr_l	x5, __hyp_stub_vectors
 	msr	vbar_el2, x5
-	b	exit
+	mov	x0, xzr
+	eret
 
 1:	/* Bad stub call */
 	ldr	x0, =HVC_STUB_ERR
-
-exit:
 	eret
+
 ENDPROC(__kvm_handle_stub_hvc)
 
 	.ltorg
-- 
2.11.0
