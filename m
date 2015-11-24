From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 7/8] arm64: kvm: avoid %p in __kvm_hyp_panic
Date: Tue, 24 Nov 2015 18:35:35 +0100
Message-ID: <1448386536-30118-8-git-send-email-christoffer.dall@linaro.org>
References: <1448386536-30118-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E9F5497C0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 12:34:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wuICm1hMDSPJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2015 12:34:25 -0500 (EST)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 485C4496AC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 12:34:25 -0500 (EST)
Received: by wmec201 with SMTP id c201so37092961wme.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 09:35:24 -0800 (PST)
In-Reply-To: <1448386536-30118-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

Currently __kvm_hyp_panic uses %p for values which are not pointers,
such as the ESR value. This can confusingly lead to "(null)" being
printed for the value.

Use %x instead, and only use %p for host pointers.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index ff2e038..ce70817 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -914,7 +914,7 @@ __kvm_hyp_panic:
 ENDPROC(__kvm_hyp_panic)
 
 __hyp_panic_str:
-	.ascii	"HYP panic:\nPS:%08x PC:%p ESR:%p\nFAR:%p HPFAR:%p PAR:%p\nVCPU:%p\n\0"
+	.ascii	"HYP panic:\nPS:%08x PC:%016x ESR:%08x\nFAR:%016x HPFAR:%016x PAR:%016x\nVCPU:%p\n\0"
 
 	.align	2
 
-- 
2.1.2.330.g565301e.dirty
