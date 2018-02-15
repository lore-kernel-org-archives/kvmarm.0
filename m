From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 33/40] KVM: arm64: Configure c15, PMU, and debug register traps on cpu load/put for VHE
Date: Thu, 15 Feb 2018 22:03:25 +0100
Message-ID: <20180215210332.8648-34-christoffer.dall@linaro.org>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180215210332.8648-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andrew Jones <drjones@redhat.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Dave Martin <Dave.Martin@arm.com>, Julien Grall <julien.grall@arm.com>, Tomasz Nowicki <tn@semihalf.com>, Yury Norov <ynorov@caviumnetworks.com>
List-Id: kvmarm@lists.cs.columbia.edu

We do not have to change the c15 trap setting on each switch to/from the
guest on VHE systems, because this setting only affects EL0.

The PMU and debug trap configuration can also be done on vcpu load/put
instead, because they don't affect how the host kernel can access the
debug registers while executing KVM kernel code.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_hyp.h |  3 +++
 arch/arm64/kvm/hyp/switch.c      | 31 ++++++++++++++++++++++---------
 arch/arm64/kvm/hyp/sysreg-sr.c   |  4 ++++
 3 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 2b1fda90dde4..949f2e77ae58 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -147,6 +147,9 @@ void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
 bool __fpsimd_enabled(void);
 
+void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
+void deactivate_traps_vhe_put(void);
+
 u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
 void __noreturn __hyp_do_panic(unsigned long, ...);
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 9c40e203bd09..5e94955b89ea 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -101,6 +101,8 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
+	__activate_traps_common(vcpu);
+
 	val = CPTR_EL2_DEFAULT;
 	val |= CPTR_EL2_TTA | CPTR_EL2_TFP | CPTR_EL2_TZ;
 	write_sysreg(val, cptr_el2);
@@ -120,20 +122,12 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
 
 	__activate_traps_fpsimd32(vcpu);
-	__activate_traps_common(vcpu);
 	__activate_traps_arch()(vcpu);
 }
 
 static void __hyp_text __deactivate_traps_vhe(void)
 {
 	extern char vectors[];	/* kernel exception vectors */
-	u64 mdcr_el2 = read_sysreg(mdcr_el2);
-
-	mdcr_el2 &= MDCR_EL2_HPMN_MASK |
-		    MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT |
-		    MDCR_EL2_TPMS;
-
-	write_sysreg(mdcr_el2, mdcr_el2);
 	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
 	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
 	write_sysreg(vectors, vbar_el1);
@@ -143,6 +137,8 @@ static void __hyp_text __deactivate_traps_nvhe(void)
 {
 	u64 mdcr_el2 = read_sysreg(mdcr_el2);
 
+	__deactivate_traps_common();
+
 	mdcr_el2 &= MDCR_EL2_HPMN_MASK;
 	mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
 
@@ -166,10 +162,27 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.hcr_el2 & HCR_VSE)
 		vcpu->arch.hcr_el2 = read_sysreg(hcr_el2);
 
-	__deactivate_traps_common();
 	__deactivate_traps_arch()();
 }
 
+void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
+{
+	__activate_traps_common(vcpu);
+}
+
+void deactivate_traps_vhe_put(void)
+{
+	u64 mdcr_el2 = read_sysreg(mdcr_el2);
+
+	mdcr_el2 &= MDCR_EL2_HPMN_MASK |
+		    MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT |
+		    MDCR_EL2_TPMS;
+
+	write_sysreg(mdcr_el2, mdcr_el2);
+
+	__deactivate_traps_common();
+}
+
 static void __hyp_text __activate_vm(struct kvm *kvm)
 {
 	write_sysreg(kvm->arch.vttbr, vttbr_el2);
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index aacba4636871..b3894df6bf1a 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -254,6 +254,8 @@ void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
 	__sysreg_restore_el1_state(guest_ctxt);
 
 	vcpu->arch.sysregs_loaded_on_cpu = true;
+
+	activate_traps_vhe_load(vcpu);
 }
 
 /**
@@ -275,6 +277,8 @@ void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
 	if (!has_vhe())
 		return;
 
+	deactivate_traps_vhe_put();
+
 	__sysreg_save_el1_state(guest_ctxt);
 	__sysreg_save_user_state(guest_ctxt);
 	__sysreg32_save_state(vcpu);
-- 
2.14.2
