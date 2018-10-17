From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: [PATCH v3 1/7] arm64/kvm: preserve host HCR_EL2 value
Date: Wed, 17 Oct 2018 16:17:54 +0530
Message-ID: <1539773280-4159-2-git-send-email-amit.kachhap@arm.com>
References: <1539773280-4159-1-git-send-email-amit.kachhap@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1539773280-4159-1-git-send-email-amit.kachhap@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, Amit Daniel Kachhap <amit.kachhap@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

When restoring HCR_EL2 for the host, KVM uses HCR_HOST_VHE_FLAGS, which
is a constant value. This works today, as the host HCR_EL2 value is
always the same, but this will get in the way of supporting extensions
that require HCR_EL2 bits to be set conditionally for the host.

To allow such features to work without KVM having to explicitly handle
every possible host feature combination, this patch has KVM save/restore
the host HCR when switching to/from a guest HCR. The saving of the
register is done once during cpu hypervisor initialization state and is
just restored after switch from guest.

For fetching HCR_EL2 during kvm initilisation, a hyp call is made using
kvm_call_hyp and is helpful in NHVE case.

For the hyp TLB maintenance code, __tlb_switch_to_host_vhe() is updated
to toggle the TGE bit with a RMW sequence, as we already do in
__tlb_switch_to_guest_vhe().

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm/include/asm/kvm_host.h   |  2 ++
 arch/arm64/include/asm/kvm_asm.h  |  2 ++
 arch/arm64/include/asm/kvm_host.h | 14 ++++++++++++--
 arch/arm64/kvm/hyp/switch.c       | 15 +++++++++------
 arch/arm64/kvm/hyp/sysreg-sr.c    | 11 +++++++++++
 arch/arm64/kvm/hyp/tlb.c          |  6 +++++-
 virt/kvm/arm/arm.c                |  2 ++
 7 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 3ad482d..dd32934 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -273,6 +273,8 @@ static inline void __cpu_init_stage2(void)
 	kvm_call_hyp(__init_stage2_translation);
 }
 
+static inline void __cpu_copy_host_registers(void) {}
+
 static inline int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	return 0;
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 102b5a5..181c388 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -74,6 +74,8 @@ extern u32 __kvm_get_mdcr_el2(void);
 
 extern u32 __init_stage2_translation(void);
 
+extern u64 __read_hyp_hcr_el2(void);
+
 /* Home-grown __this_cpu_{ptr,read} variants that always work at HYP */
 #define __hyp_this_cpu_ptr(sym)						\
 	({								\
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3d6d733..0c0e243 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -194,13 +194,17 @@ enum vcpu_sysreg {
 
 #define NR_COPRO_REGS	(NR_SYS_REGS * 2)
 
+struct kvm_cpu_init_host_regs {
+	u64 hcr_el2;
+};
+
 struct kvm_cpu_context {
 	struct kvm_regs	gp_regs;
 	union {
 		u64 sys_regs[NR_SYS_REGS];
 		u32 copro[NR_COPRO_REGS];
 	};
-
+	struct kvm_cpu_init_host_regs init_regs;
 	struct kvm_vcpu *__hyp_running_vcpu;
 };
 
@@ -209,7 +213,7 @@ typedef struct kvm_cpu_context kvm_cpu_context_t;
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 
-	/* HYP configuration */
+	/* Guest HYP configuration */
 	u64 hcr_el2;
 	u32 mdcr_el2;
 
@@ -448,6 +452,12 @@ static inline void __cpu_init_stage2(void)
 		  "PARange is %d bits, unsupported configuration!", parange);
 }
 
+static inline void __cpu_copy_host_registers(void)
+{
+	kvm_cpu_context_t *host_cxt = this_cpu_ptr(&kvm_host_cpu_state);
+	host_cxt->init_regs.hcr_el2 = kvm_call_hyp(__read_hyp_hcr_el2);
+}
+
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index a1c32c1..fa7dab9 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -139,15 +139,15 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 		__activate_traps_nvhe(vcpu);
 }
 
-static void deactivate_traps_vhe(void)
+static void deactivate_traps_vhe(struct kvm_cpu_context *host_ctxt)
 {
 	extern char vectors[];	/* kernel exception vectors */
-	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
+	write_sysreg(host_ctxt->init_regs.hcr_el2, hcr_el2);
 	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
 	write_sysreg(vectors, vbar_el1);
 }
 
-static void __hyp_text __deactivate_traps_nvhe(void)
+static void __hyp_text __deactivate_traps_nvhe(struct kvm_cpu_context *host_ctxt)
 {
 	u64 mdcr_el2 = read_sysreg(mdcr_el2);
 
@@ -157,12 +157,15 @@ static void __hyp_text __deactivate_traps_nvhe(void)
 	mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
 
 	write_sysreg(mdcr_el2, mdcr_el2);
-	write_sysreg(HCR_HOST_NVHE_FLAGS, hcr_el2);
+	write_sysreg(host_ctxt->init_regs.hcr_el2, hcr_el2);
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
@@ -173,9 +176,9 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcr_el2 = read_sysreg(hcr_el2);
 
 	if (has_vhe())
-		deactivate_traps_vhe();
+		deactivate_traps_vhe(host_ctxt);
 	else
-		__deactivate_traps_nvhe();
+		__deactivate_traps_nvhe(host_ctxt);
 }
 
 void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 9ce2239..26b1c63 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -288,3 +288,14 @@ void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.sysregs_loaded_on_cpu = false;
 }
+
+/**
+ * __read_hyp_hcr_el2 - Returns hcr_el2 register value
+ *
+ * This function acts as a function handler parameter for kvm_call_hyp and
+ * may be called from EL1 exception level to fetch the register value.
+ */
+u64 __hyp_text __read_hyp_hcr_el2(void)
+{
+	return read_sysreg(hcr_el2);
+}
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index 131c777..04fc75a 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -50,12 +50,16 @@ static hyp_alternate_select(__tlb_switch_to_guest,
 
 static void __hyp_text __tlb_switch_to_host_vhe(struct kvm *kvm)
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
 }
 
 static void __hyp_text __tlb_switch_to_host_nvhe(struct kvm *kvm)
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index c92053b..b3d1ee4 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1322,6 +1322,8 @@ static void cpu_hyp_reinit(void)
 
 	if (vgic_present)
 		kvm_vgic_init_cpu_hardware();
+
+	__cpu_copy_host_registers();
 }
 
 static void _kvm_arch_hardware_enable(void *discard)
-- 
2.7.4
