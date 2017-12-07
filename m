From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2 08/36] KVM: arm64: Slightly improve debug save/restore
 functions
Date: Thu,  7 Dec 2017 18:06:02 +0100
Message-ID: <20171207170630.592-9-christoffer.dall@linaro.org>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 071B349DCD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 12:03:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8mT9MyYCMdzo for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Dec 2017 12:03:40 -0500 (EST)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D28449D8C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 12:03:38 -0500 (EST)
Received: by mail-wm0-f65.google.com with SMTP id b76so14240470wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Dec 2017 09:06:54 -0800 (PST)
In-Reply-To: <20171207170630.592-1-christoffer.dall@linaro.org>
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

Notes:
    Changes since v1:
     - Change dot to comma in comment
     - Rename __debug_restore_spe to __debug_restore_spe_nvhe

 arch/arm64/kvm/hyp/debug-sr.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index 406829b6a43e..81b8ad44f9e0 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -65,11 +65,6 @@
 	default:	write_debug(ptr[0], reg, 0);			\
 	}
 
-static void __hyp_text __debug_save_spe_vhe(u64 *pmscr_el1)
-{
-	/* The vcpu can run. but it can't hide. */
-}
-
 static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
 {
 	u64 reg;
@@ -99,11 +94,7 @@ static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
 	dsb(nsh);
 }
 
-static hyp_alternate_select(__debug_save_spe,
-			    __debug_save_spe_nvhe, __debug_save_spe_vhe,
-			    ARM64_HAS_VIRT_HOST_EXTN);
-
-static void __hyp_text __debug_restore_spe(u64 pmscr_el1)
+static void __hyp_text __debug_restore_spe_nvhe(u64 pmscr_el1)
 {
 	if (!pmscr_el1)
 		return;
@@ -164,17 +155,24 @@ void __hyp_text __debug_cond_save_host_state(struct kvm_vcpu *vcpu)
 {
 	__debug_save_state(vcpu, &vcpu->arch.host_debug_state.regs,
 			   kern_hyp_va(vcpu->arch.host_cpu_context));
-	__debug_save_spe()(&vcpu->arch.host_debug_state.pmscr_el1);
+
+	/*
+	 * Non-VHE: Disable and flush SPE data generation
+	 * VHE: The vcpu can run, but it can't hide.
+	 */
+	if (!has_vhe())
+		__debug_save_spe_nvhe(&vcpu->arch.host_debug_state.pmscr_el1);
 }
 
 void __hyp_text __debug_cond_restore_host_state(struct kvm_vcpu *vcpu)
 {
-	__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
+	if (!has_vhe())
+		__debug_restore_spe_nvhe(vcpu->arch.host_debug_state.pmscr_el1);
+
 	__debug_restore_state(vcpu, &vcpu->arch.host_debug_state.regs,
 			      kern_hyp_va(vcpu->arch.host_cpu_context));
 
-	if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
-		vcpu->arch.debug_flags &= ~KVM_ARM64_DEBUG_DIRTY;
+	vcpu->arch.debug_flags &= ~KVM_ARM64_DEBUG_DIRTY;
 }
 
 u32 __hyp_text __kvm_get_mdcr_el2(void)
-- 
2.14.2
