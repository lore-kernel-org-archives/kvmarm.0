From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 42/95] arm64: KVM: VHE: Enable minimal sysreg save/restore
Date: Wed,  9 Mar 2016 07:30:36 +0000
Message-ID: <1457508689-19672-43-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF8DE412ED
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:33:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iwFW6iym+w47 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:33:44 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AF6949B49
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:33:44 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

We're now in a position where we can introduce VHE's minimal
save/restore, which is limited to the handful of shared sysregs.

Add the required alternative function calls that result in a
"do nothing" call on VHE, and the normal save/restore for non-VHE.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/sysreg-sr.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 7d7d757..74b5f81 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -23,6 +23,9 @@
 
 #include "hyp.h"
 
+/* Yes, this does nothing, on purpose */
+static void __hyp_text __sysreg_do_nothing(struct kvm_cpu_context *ctxt) { }
+
 /*
  * Non-VHE: Both host and guest must save everything.
  *
@@ -67,9 +70,13 @@ static void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
 	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg_el1(spsr);
 }
 
+static hyp_alternate_select(__sysreg_call_save_host_state,
+			    __sysreg_save_state, __sysreg_do_nothing,
+			    ARM64_HAS_VIRT_HOST_EXTN);
+
 void __hyp_text __sysreg_save_host_state(struct kvm_cpu_context *ctxt)
 {
-	__sysreg_save_state(ctxt);
+	__sysreg_call_save_host_state()(ctxt);
 	__sysreg_save_common_state(ctxt);
 }
 
@@ -116,9 +123,13 @@ static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
 	write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],spsr);
 }
 
+static hyp_alternate_select(__sysreg_call_restore_host_state,
+			    __sysreg_restore_state, __sysreg_do_nothing,
+			    ARM64_HAS_VIRT_HOST_EXTN);
+
 void __hyp_text __sysreg_restore_host_state(struct kvm_cpu_context *ctxt)
 {
-	__sysreg_restore_state(ctxt);
+	__sysreg_call_restore_host_state()(ctxt);
 	__sysreg_restore_common_state(ctxt);
 }
 
-- 
2.1.4
