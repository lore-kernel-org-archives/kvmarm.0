From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: [PATCH v6 1/6] arm64/kvm: preserve host HCR_EL2 value
Date: Tue, 19 Feb 2019 14:54:26 +0530
Message-ID: <1550568271-5319-2-git-send-email-amit.kachhap@arm.com>
References: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, Amit Daniel Kachhap <amit.kachhap@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

When restoring HCR_EL2 for the host, KVM uses HCR_HOST_VHE_FLAGS, which
is a constant value. This works today, as the host HCR_EL2 value is
always the same, but this will get in the way of supporting extensions
that require HCR_EL2 bits to be set conditionally for the host.

To allow such features to work without KVM having to explicitly handle
every possible host feature combination, this patch has KVM save/restore
for the host HCR when switching to/from a guest HCR. The saving of the
register is done once during cpu hypervisor initialization state and is
just restored after switch from guest.

For fetching HCR_EL2 during kvm initialisation, a hyp call is made using
kvm_call_hyp and is helpful in NHVE case.

For the hyp TLB maintenance code, __tlb_switch_to_host_vhe() is updated
to toggle the TGE bit with a RMW sequence, as we already do in
__tlb_switch_to_guest_vhe().

The value of hcr_el2 is now stored in struct kvm_cpu_context as both host
and guest can now use this field in a common way.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
[Added __cpu_copy_hyp_conf, hcr_el2 field in struct kvm_cpu_context]
Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm/include/asm/kvm_host.h      |  2 ++
 arch/arm64/include/asm/kvm_asm.h     |  2 ++
 arch/arm64/include/asm/kvm_emulate.h | 22 +++++++++++-----------
 arch/arm64/include/asm/kvm_host.h    | 13 ++++++++++++-
 arch/arm64/include/asm/kvm_hyp.h     |  2 +-
 arch/arm64/kvm/guest.c               |  2 +-
 arch/arm64/kvm/hyp/switch.c          | 23 +++++++++++++----------
 arch/arm64/kvm/hyp/sysreg-sr.c       | 21 ++++++++++++++++++++-
 arch/arm64/kvm/hyp/tlb.c             |  6 +++++-
 virt/kvm/arm/arm.c                   |  1 +
 10 files changed, 68 insertions(+), 26 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index ca56537..05706b4 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -273,6 +273,8 @@ static inline void __cpu_init_stage2(void)
 	kvm_call_hyp(__init_stage2_translation);
 }
 
+static inline void __cpu_copy_hyp_conf(void) {}
+
 static inline int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	return 0;
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index f5b79e9..8acd73f 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -80,6 +80,8 @@ extern void __vgic_v3_init_lrs(void);
 
 extern u32 __kvm_get_mdcr_el2(void);
 
+extern void __kvm_populate_host_regs(void);
+
 /* Home-grown __this_cpu_{ptr,read} variants that always work at HYP */
 #define __hyp_this_cpu_ptr(sym)						\
 	({								\
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 506386a..0dbe795 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -50,25 +50,25 @@ void kvm_inject_pabt32(struct kvm_vcpu *vcpu, unsigned long addr);
 
 static inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 {
-	return !(vcpu->arch.hcr_el2 & HCR_RW);
+	return !(vcpu->arch.ctxt.hcr_el2 & HCR_RW);
 }
 
 static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
+	vcpu->arch.ctxt.hcr_el2 = HCR_GUEST_FLAGS;
 	if (is_kernel_in_hyp_mode())
-		vcpu->arch.hcr_el2 |= HCR_E2H;
+		vcpu->arch.ctxt.hcr_el2 |= HCR_E2H;
 	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN)) {
 		/* route synchronous external abort exceptions to EL2 */
-		vcpu->arch.hcr_el2 |= HCR_TEA;
+		vcpu->arch.ctxt.hcr_el2 |= HCR_TEA;
 		/* trap error record accesses */
-		vcpu->arch.hcr_el2 |= HCR_TERR;
+		vcpu->arch.ctxt.hcr_el2 |= HCR_TERR;
 	}
 	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
-		vcpu->arch.hcr_el2 |= HCR_FWB;
+		vcpu->arch.ctxt.hcr_el2 |= HCR_FWB;
 
 	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
-		vcpu->arch.hcr_el2 &= ~HCR_RW;
+		vcpu->arch.ctxt.hcr_el2 &= ~HCR_RW;
 
 	/*
 	 * TID3: trap feature register accesses that we virtualise.
@@ -76,22 +76,22 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 	 * are currently virtualised.
 	 */
 	if (!vcpu_el1_is_32bit(vcpu))
-		vcpu->arch.hcr_el2 |= HCR_TID3;
+		vcpu->arch.ctxt.hcr_el2 |= HCR_TID3;
 }
 
 static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
 {
-	return (unsigned long *)&vcpu->arch.hcr_el2;
+	return (unsigned long *)&vcpu->arch.ctxt.hcr_el2;
 }
 
 static inline void vcpu_clear_wfe_traps(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.hcr_el2 &= ~HCR_TWE;
+	vcpu->arch.ctxt.hcr_el2 &= ~HCR_TWE;
 }
 
 static inline void vcpu_set_wfe_traps(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.hcr_el2 |= HCR_TWE;
+	vcpu->arch.ctxt.hcr_el2 |= HCR_TWE;
 }
 
 static inline unsigned long vcpu_get_vsesr(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7732d0b..1b2e05b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -203,6 +203,8 @@ struct kvm_cpu_context {
 		u32 copro[NR_COPRO_REGS];
 	};
 
+	/* HYP host/guest configuration */
+	u64 hcr_el2;
 	struct kvm_vcpu *__hyp_running_vcpu;
 };
 
@@ -212,7 +214,6 @@ struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 
 	/* HYP configuration */
-	u64 hcr_el2;
 	u32 mdcr_el2;
 
 	/* Exception Information */
@@ -458,6 +459,16 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 
 static inline void __cpu_init_stage2(void) {}
 
+/**
+ * __cpu_copy_hyp_conf - copy the boot hyp configuration registers
+ *
+ * It is called once per-cpu during CPU hyp initialisation.
+ */
+static inline void __cpu_copy_hyp_conf(void)
+{
+	kvm_call_hyp(__kvm_populate_host_regs);
+}
+
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index a80a7ef..6e65cad 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -151,7 +151,7 @@ void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
 bool __fpsimd_enabled(void);
 
 void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
-void deactivate_traps_vhe_put(void);
+void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu);
 
 u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
 void __noreturn __hyp_do_panic(unsigned long, ...);
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index dd436a5..e2f0268 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -345,7 +345,7 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
 			      struct kvm_vcpu_events *events)
 {
-	events->exception.serror_pending = !!(vcpu->arch.hcr_el2 & HCR_VSE);
+	events->exception.serror_pending = !!(vcpu->arch.ctxt.hcr_el2 & HCR_VSE);
 	events->exception.serror_has_esr = cpus_have_const_cap(ARM64_HAS_RAS_EXTN);
 
 	if (events->exception.serror_pending && events->exception.serror_has_esr)
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index b0b1478..006bd33 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -126,7 +126,7 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
 
 static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 {
-	u64 hcr = vcpu->arch.hcr_el2;
+	u64 hcr = vcpu->arch.ctxt.hcr_el2;
 
 	write_sysreg(hcr, hcr_el2);
 
@@ -139,10 +139,10 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 		__activate_traps_nvhe(vcpu);
 }
 
-static void deactivate_traps_vhe(void)
+static void deactivate_traps_vhe(struct kvm_cpu_context *host_ctxt)
 {
 	extern char vectors[];	/* kernel exception vectors */
-	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
+	write_sysreg(host_ctxt->hcr_el2, hcr_el2);
 
 	/*
 	 * ARM erratum 1165522 requires the actual execution of the above
@@ -155,7 +155,7 @@ static void deactivate_traps_vhe(void)
 	write_sysreg(vectors, vbar_el1);
 }
 
-static void __hyp_text __deactivate_traps_nvhe(void)
+static void __hyp_text __deactivate_traps_nvhe(struct kvm_cpu_context *host_ctxt)
 {
 	u64 mdcr_el2 = read_sysreg(mdcr_el2);
 
@@ -165,25 +165,28 @@ static void __hyp_text __deactivate_traps_nvhe(void)
 	mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
 
 	write_sysreg(mdcr_el2, mdcr_el2);
-	write_sysreg(HCR_HOST_NVHE_FLAGS, hcr_el2);
+	write_sysreg(host_ctxt->hcr_el2, hcr_el2);
 	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
 }
 
 static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *host_ctxt;
+
+	host_ctxt = vcpu->arch.host_cpu_context;
 	/*
 	 * If we pended a virtual abort, preserve it until it gets
 	 * cleared. See D1.14.3 (Virtual Interrupts) for details, but
 	 * the crucial bit is "On taking a vSError interrupt,
 	 * HCR_EL2.VSE is cleared to 0."
 	 */
-	if (vcpu->arch.hcr_el2 & HCR_VSE)
-		vcpu->arch.hcr_el2 = read_sysreg(hcr_el2);
+	if (vcpu->arch.ctxt.hcr_el2 & HCR_VSE)
+		vcpu->arch.ctxt.hcr_el2 = read_sysreg(hcr_el2);
 
 	if (has_vhe())
-		deactivate_traps_vhe();
+		deactivate_traps_vhe(host_ctxt);
 	else
-		__deactivate_traps_nvhe();
+		__deactivate_traps_nvhe(host_ctxt);
 }
 
 void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
@@ -191,7 +194,7 @@ void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
 	__activate_traps_common(vcpu);
 }
 
-void deactivate_traps_vhe_put(void)
+void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
 {
 	u64 mdcr_el2 = read_sysreg(mdcr_el2);
 
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 68d6f7c..68ddc0f 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -21,6 +21,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
 
 /*
  * Non-VHE: Both host and guest must save everything.
@@ -294,7 +295,7 @@ void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
 	if (!has_vhe())
 		return;
 
-	deactivate_traps_vhe_put();
+	deactivate_traps_vhe_put(vcpu);
 
 	__sysreg_save_el1_state(guest_ctxt);
 	__sysreg_save_user_state(guest_ctxt);
@@ -316,3 +317,21 @@ void __hyp_text __kvm_enable_ssbs(void)
 	"msr	sctlr_el2, %0"
 	: "=&r" (tmp) : "L" (SCTLR_ELx_DSSBS));
 }
+
+/**
+ * __kvm_populate_host_regs - Stores host register values
+ *
+ * This function acts as a function handler parameter for kvm_call_hyp and
+ * may be called from EL1 exception level to fetch the register value.
+ */
+void __hyp_text __kvm_populate_host_regs(void)
+{
+	struct kvm_cpu_context *host_ctxt;
+
+	if (has_vhe())
+		host_ctxt = this_cpu_ptr(&kvm_host_cpu_state);
+	else
+		host_ctxt = __hyp_this_cpu_ptr(kvm_host_cpu_state);
+
+	host_ctxt->hcr_el2 = read_sysreg(hcr_el2);
+}
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index 76c3086..c5e7144 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -86,12 +86,16 @@ static hyp_alternate_select(__tlb_switch_to_guest,
 static void __hyp_text __tlb_switch_to_host_vhe(struct kvm *kvm,
 						struct tlb_inv_context *cxt)
 {
+	u64 val;
+
 	/*
 	 * We're done with the TLB operation, let's restore the host's
 	 * view of HCR_EL2.
 	 */
 	write_sysreg(0, vttbr_el2);
-	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
+	val = read_sysreg(hcr_el2);
+	val |= HCR_TGE;
+	write_sysreg(val, hcr_el2);
 	isb();
 
 	if (cpus_have_const_cap(ARM64_WORKAROUND_1165522)) {
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 9e350fd3..8e18f7f 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1328,6 +1328,7 @@ static void cpu_hyp_reinit(void)
 		cpu_init_hyp_mode(NULL);
 
 	kvm_arm_init_debug();
+	__cpu_copy_hyp_conf();
 
 	if (vgic_present)
 		kvm_vgic_init_cpu_hardware();
-- 
2.7.4
