From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 23/85] KVM: arm64: Slightly improve debug save/restore
 functions
Date: Wed, 28 Mar 2018 13:51:52 +0100
Message-ID: <20180328125254.31380-24-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC0794A0BF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:49:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gi7lWRxXxeUz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:48:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A9BB49FBE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:46:30 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

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
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
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
