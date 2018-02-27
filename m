From: Christoffer Dall <cdall@kernel.org>
Subject: [PATCH v5 18/40] KVM: arm64: Rewrite sysreg alternatives to static
 keys
Date: Tue, 27 Feb 2018 12:34:07 +0100
Message-ID: <20180227113429.637-19-cdall@kernel.org>
References: <20180227113429.637-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2035949E47
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 06:29:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qYiC-dRlNAWW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Feb 2018 06:28:54 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6AD0849E12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 06:28:05 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id q83so23500878wme.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 03:34:58 -0800 (PST)
In-Reply-To: <20180227113429.637-1-cdall@kernel.org>
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

As we are about to move calls around in the sysreg save/restore logic,
let's first rewrite the alternative function callers, because it is
going to make the next patches much easier to read.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/sysreg-sr.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index d5a5145b4e7c..51b557226170 100644
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
@@ -81,13 +78,10 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 		ctxt->sys_regs[DISR_EL1] = read_sysreg_s(SYS_VDISR_EL2);
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
@@ -148,13 +142,10 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 		write_sysreg_s(ctxt->sys_regs[DISR_EL1], SYS_VDISR_EL2);
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
