From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 10/40] KVM: arm64: Slightly improve debug save/restore functions
Date: Thu, 15 Feb 2018 22:03:02 +0100
Message-ID: <20180215210332.8648-11-christoffer.dall@linaro.org>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180215210332.8648-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andrew Jones <drjones@redhat.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Dave Martin <Dave.Martin@arm.com>, Julien Grall <julien.grall@arm.com>, Tomasz Nowicki <tn@semihalf.com>, Yury Norov <ynorov@caviumnetworks.com>
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

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---

Notes:
    Changes since v1:
     - Change dot to comma in comment
     - Rename __debug_restore_spe to __debug_restore_spe_nvhe

 arch/arm64/kvm/hyp/debug-sr.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index d958cd63a547..74f71fb5e36d 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -66,11 +66,6 @@
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
@@ -103,11 +98,7 @@ static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
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
@@ -168,17 +159,24 @@ void __hyp_text __debug_cond_save_host_state(struct kvm_vcpu *vcpu)
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
