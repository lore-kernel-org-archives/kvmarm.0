From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 08/40] KVM: arm/arm64: Introduce vcpu_el1_is_32bit
Date: Thu, 15 Feb 2018 22:03:00 +0100
Message-ID: <20180215210332.8648-9-christoffer.dall@linaro.org>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180215210332.8648-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andrew Jones <drjones@redhat.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Dave Martin <Dave.Martin@arm.com>, Julien Grall <julien.grall@arm.com>, Tomasz Nowicki <tn@semihalf.com>, Yury Norov <ynorov@caviumnetworks.com>
List-Id: kvmarm@lists.cs.columbia.edu

We have numerous checks around that checks if the HCR_EL2 has the RW bit
set to figure out if we're running an AArch64 or AArch32 VM.  In some
cases, directly checking the RW bit (given its unintuitive name), is a
bit confusing, and that's not going to improve as we move logic around
for the following patches that optimize KVM on AArch64 hosts with VHE.

Therefore, introduce a helper, vcpu_el1_is_32bit, and replace existing
direct checks of HCR_EL2.RW with the helper.

Reviewed-by: Julien Grall <julien.grall@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---

Notes:
    Changes since v2:
     - New patch
    
    Changes since v1:
     - Reworded comments as suggested by Drew

 arch/arm64/include/asm/kvm_emulate.h |  7 ++++++-
 arch/arm64/kvm/hyp/switch.c          | 11 +++++------
 arch/arm64/kvm/hyp/sysreg-sr.c       |  5 +++--
 arch/arm64/kvm/inject_fault.c        |  6 +++---
 4 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 9ee316b962c8..3cc535591bdf 100644
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
@@ -65,7 +70,7 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 	 * For now this is conditional, since no AArch32 feature regs
 	 * are currently virtualised.
 	 */
-	if (vcpu->arch.hcr_el2 & HCR_RW)
+	if (!vcpu_el1_is_32bit(vcpu))
 		vcpu->arch.hcr_el2 |= HCR_TID3;
 }
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index b51638490d85..fbab9752a9f4 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -74,7 +74,7 @@ static hyp_alternate_select(__activate_traps_arch,
 
 static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 {
-	u64 val;
+	u64 hcr = vcpu->arch.hcr_el2;
 
 	/*
 	 * We are about to set CPTR_EL2.TFP to trap all floating point
@@ -85,17 +85,16 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
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
 
-	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN) && (val & HCR_VSE))
+	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
 		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
 
+	write_sysreg(hcr, hcr_el2);
+
 	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
 	write_sysreg(1 << 15, hstr_el2);
 	/*
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 434f0fc9cfb3..99fc60516103 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -19,6 +19,7 @@
 #include <linux/kvm_host.h>
 
 #include <asm/kvm_asm.h>
+#include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 
 /* Yes, this does nothing, on purpose */
@@ -147,7 +148,7 @@ void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
 {
 	u64 *spsr, *sysreg;
 
-	if (read_sysreg(hcr_el2) & HCR_RW)
+	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
 	spsr = vcpu->arch.ctxt.gp_regs.spsr;
@@ -172,7 +173,7 @@ void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 {
 	u64 *spsr, *sysreg;
 
-	if (read_sysreg(hcr_el2) & HCR_RW)
+	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
 	spsr = vcpu->arch.ctxt.gp_regs.spsr;
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index c1e179d34e6a..30a3f58cdb7b 100644
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
