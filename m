From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 18/37] KVM: arm64: Rewrite sysreg alternatives to static keys
Date: Thu, 12 Oct 2017 12:41:22 +0200
Message-ID: <20171012104141.26902-19-christoffer.dall@linaro.org>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10C0E49D5D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SiboRrtErVV5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Oct 2017 06:41:23 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2CF8149D3D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:23 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id q124so11980988wmb.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 03:42:07 -0700 (PDT)
In-Reply-To: <20171012104141.26902-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

As we are about to move calls around in the sysreg save/restore logic,
let's first rewrite the alternative function callers, because it is
going to make the next patches much easier to read.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/sysreg-sr.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 193c2b0..b55c4ad 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -22,9 +22,6 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 
-/* Yes, this does nothing, on purpose */
-static void __hyp_text __sysreg_do_nothing(struct kvm_cpu_context *ctxt) { }
-
 /*
  * Non-VHE: Both host and guest must save everything.
  *
@@ -73,13 +70,10 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(spsr);
 }
 
-static hyp_alternate_select(__sysreg_call_save_host_state,
-			    __sysreg_save_el1_state, __sysreg_do_nothing,
-			    ARM64_HAS_VIRT_HOST_EXTN);
-
 void __hyp_text __sysreg_save_host_state(struct kvm_cpu_context *ctxt)
 {
-	__sysreg_call_save_host_state()(ctxt);
+	if (!has_vhe())
+		__sysreg_save_el1_state(ctxt);
 	__sysreg_save_common_state(ctxt);
 	__sysreg_save_user_state(ctxt);
 }
@@ -132,13 +126,10 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 	write_sysreg_el2(ctxt->gp_regs.regs.pstate,	spsr);
 }
 
-static hyp_alternate_select(__sysreg_call_restore_host_state,
-			    __sysreg_restore_el1_state, __sysreg_do_nothing,
-			    ARM64_HAS_VIRT_HOST_EXTN);
-
 void __hyp_text __sysreg_restore_host_state(struct kvm_cpu_context *ctxt)
 {
-	__sysreg_call_restore_host_state()(ctxt);
+	if (!has_vhe())
+		__sysreg_restore_el1_state(ctxt);
 	__sysreg_restore_common_state(ctxt);
 	__sysreg_restore_user_state(ctxt);
 }
-- 
2.9.0
