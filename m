From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v3 08/41] KVM: arm/arm64: Introduce vcpu_el1_is_32bit
Date: Fri, 12 Jan 2018 13:07:14 +0100
Message-ID: <20180112120747.27999-9-christoffer.dall@linaro.org>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D134C49DCE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 07:03:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1DxSOKLXzDeW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Jan 2018 07:03:14 -0500 (EST)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F17CD49DE1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 07:03:13 -0500 (EST)
Received: by mail-wm0-f65.google.com with SMTP id f140so11329780wmd.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 04:08:04 -0800 (PST)
In-Reply-To: <20180112120747.27999-1-christoffer.dall@linaro.org>
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

We have numerous checks around that checks if the HCR_EL2 has the RW bit
set to figure out if we're running an AArch64 or AArch32 VM.  In some
cases, directly checking the RW bit (given its unintuitive name), is a
bit confusing, and that's not going to improve as we move logic around
for the following patches that optimize KVM on AArch64 hosts with VHE.

Therefore, introduce a helper, vcpu_el1_is_32bit, and replace existing
direct checks of HCR_EL2.RW with the helper.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 7 ++++++-
 arch/arm64/kvm/hyp/switch.c          | 8 ++------
 arch/arm64/kvm/hyp/sysreg-sr.c       | 5 +++--
 arch/arm64/kvm/inject_fault.c        | 6 +++---
 4 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index b36aaa1fe332..e07bf463ac58 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -45,6 +45,11 @@ void kvm_inject_undef32(struct kvm_vcpu *vcpu);
 void kvm_inject_dabt32(struct kvm_vcpu *vcpu, unsigned long addr);
 void kvm_inject_pabt32(struct kvm_vcpu *vcpu, unsigned long addr);
 
+static inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
+{
+	return !(vcpu->arch.hcr_el2 & HCR_RW);
+}
+
 static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
@@ -58,7 +63,7 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 	 * For now this is conditional, since no AArch32 feature regs
 	 * are currently virtualised.
 	 */
-	if (vcpu->arch.hcr_el2 & HCR_RW)
+	if (!vcpu_el1_is_32bit(vcpu))
 		vcpu->arch.hcr_el2 |= HCR_TID3;
 }
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 11ec1c6f3b84..12dc647a6e5f 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -70,8 +70,6 @@ static hyp_alternate_select(__activate_traps_arch,
 
 static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 {
-	u64 val;
-
 	/*
 	 * We are about to set CPTR_EL2.TFP to trap all floating point
 	 * register accesses to EL2, however, the ARM ARM clearly states that
@@ -81,13 +79,11 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 	 * If FP/ASIMD is not implemented, FPEXC is UNDEFINED and any access to
 	 * it will cause an exception.
 	 */
-	val = vcpu->arch.hcr_el2;
-
-	if (!(val & HCR_RW) && system_supports_fpsimd()) {
+	if (vcpu_el1_is_32bit(vcpu) && system_supports_fpsimd()) {
 		write_sysreg(1 << 30, fpexc32_el2);
 		isb();
 	}
-	write_sysreg(val, hcr_el2);
+	write_sysreg(vcpu->arch.hcr_el2, hcr_el2);
 
 	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
 	write_sysreg(1 << 15, hstr_el2);
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index cbbcd6f410a8..883a6383cd36 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -19,6 +19,7 @@
 #include <linux/kvm_host.h>
 
 #include <asm/kvm_asm.h>
+#include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 
 /* Yes, this does nothing, on purpose */
@@ -141,7 +142,7 @@ void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
 {
 	u64 *spsr, *sysreg;
 
-	if (read_sysreg(hcr_el2) & HCR_RW)
+	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
 	spsr = vcpu->arch.ctxt.gp_regs.spsr;
@@ -166,7 +167,7 @@ void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 {
 	u64 *spsr, *sysreg;
 
-	if (read_sysreg(hcr_el2) & HCR_RW)
+	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
 	spsr = vcpu->arch.ctxt.gp_regs.spsr;
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 2d38ede2eff0..f4d35bb551e4 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -128,7 +128,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
  */
 void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr)
 {
-	if (!(vcpu->arch.hcr_el2 & HCR_RW))
+	if (vcpu_el1_is_32bit(vcpu))
 		kvm_inject_dabt32(vcpu, addr);
 	else
 		inject_abt64(vcpu, false, addr);
@@ -144,7 +144,7 @@ void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr)
  */
 void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr)
 {
-	if (!(vcpu->arch.hcr_el2 & HCR_RW))
+	if (vcpu_el1_is_32bit(vcpu))
 		kvm_inject_pabt32(vcpu, addr);
 	else
 		inject_abt64(vcpu, true, addr);
@@ -158,7 +158,7 @@ void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr)
  */
 void kvm_inject_undefined(struct kvm_vcpu *vcpu)
 {
-	if (!(vcpu->arch.hcr_el2 & HCR_RW))
+	if (vcpu_el1_is_32bit(vcpu))
 		kvm_inject_undef32(vcpu);
 	else
 		inject_undef64(vcpu);
-- 
2.14.2
