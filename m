From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 10/37] KVM: arm64: Slightly improve debug save/restore
 functions
Date: Thu, 12 Oct 2017 12:41:14 +0200
Message-ID: <20171012104141.26902-11-christoffer.dall@linaro.org>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 669D849D24
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 62QpU0o1ysuP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Oct 2017 06:41:13 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4DDA849D43
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:12 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id i124so11856616wmf.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 03:41:56 -0700 (PDT)
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

The debug save/restore functions can be improved by using the has_vhe()
static key instead of the instruction alternative.  Using the static key
uses the same paradigm as we're going to use elsewhere, it makes the
code more readable, and it generates slightly better code (no
stack setups and function calls unless necessary).

We also use a static key on the restore path, because it will be
marginally faster than loading a value from memory.

Finally, we don't have to conditionally clear the debug dirty flag if
it's set, we can just clear it.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/debug-sr.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index 0fc0758..a2291b6 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -75,11 +75,6 @@
 
 #define psb_csync()		asm volatile("hint #17")
 
-static void __hyp_text __debug_save_spe_vhe(u64 *pmscr_el1)
-{
-	/* The vcpu can run. but it can't hide. */
-}
-
 static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
 {
 	u64 reg;
@@ -109,10 +104,6 @@ static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
 	dsb(nsh);
 }
 
-static hyp_alternate_select(__debug_save_spe,
-			    __debug_save_spe_nvhe, __debug_save_spe_vhe,
-			    ARM64_HAS_VIRT_HOST_EXTN);
-
 static void __hyp_text __debug_restore_spe(u64 pmscr_el1)
 {
 	if (!pmscr_el1)
@@ -174,17 +165,22 @@ void __hyp_text __debug_cond_save_host_state(struct kvm_vcpu *vcpu)
 {
 	__debug_save_state(vcpu, &vcpu->arch.host_debug_state.regs,
 			   kern_hyp_va(vcpu->arch.host_cpu_context));
-	__debug_save_spe()(&vcpu->arch.host_debug_state.pmscr_el1);
+
+	/* Non-VHE: Disable and flush SPE data generation
+	 * VHE: The vcpu can run. but it can't hide. */
+	if (!has_vhe())
+		__debug_save_spe_nvhe(&vcpu->arch.host_debug_state.pmscr_el1);
 }
 
 void __hyp_text __debug_cond_restore_host_state(struct kvm_vcpu *vcpu)
 {
-	__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
+	if (!has_vhe())
+		__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
+
 	__debug_restore_state(vcpu, &vcpu->arch.host_debug_state.regs,
 			      kern_hyp_va(vcpu->arch.host_cpu_context));
 
-	if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
-		vcpu->arch.debug_flags &= ~KVM_ARM64_DEBUG_DIRTY;
+	vcpu->arch.debug_flags &= ~KVM_ARM64_DEBUG_DIRTY;
 }
 
 u32 __hyp_text __kvm_get_mdcr_el2(void)
-- 
2.9.0
