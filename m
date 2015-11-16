From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH] arm64: kvm: avoid %p in __kvm_hyp_panic
Date: Mon, 16 Nov 2015 13:55:51 +0000
Message-ID: <1447682151-5827-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D31E498E4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2015 08:55:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HC0gsf+rghDW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2015 08:55:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ED1B498E2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2015 08:55:34 -0500 (EST)
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
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Currently __kvm_hyp_panic uses %p for values which are not pointers,
such as the ESR value. This can confusingly lead to "(null)" being
printed for the value.

Use %x instead, and only use %p for host pointers.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 1599701..11183ce 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -914,7 +914,7 @@ __kvm_hyp_panic:
 ENDPROC(__kvm_hyp_panic)
 
 __hyp_panic_str:
-	.ascii	"HYP panic:\nPS:%08x PC:%p ESR:%p\nFAR:%p HPFAR:%p PAR:%p\nVCPU:%p\n\0"
+	.ascii	"HYP panic:\nPS:%08x PC:%016x ESR:%08x\nFAR:%016x HPFAR:%016x PAR:%016x\nVCPU:%p\n\0"
 
 	.align	2
 
-- 
1.9.1
