From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2 16/36] KVM: arm64: Rewrite sysreg alternatives to static keys
Date: Thu,  7 Dec 2017 18:06:10 +0100
Message-ID: <20171207170630.592-17-christoffer.dall@linaro.org>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171207170630.592-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

As we are about to move calls around in the sysreg save/restore logic,
let's first rewrite the alternative function callers, because it is
going to make the next patches much easier to read.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/sysreg-sr.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index bbfb4d01af88..e747f2fd31be 100644
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
@@ -78,13 +75,10 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
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
@@ -142,13 +136,10 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
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
2.14.2
