From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 46/85] KVM: arm64: Configure c15, PMU,
 and debug register traps on cpu load/put for VHE
Date: Wed, 28 Mar 2018 13:52:15 +0100
Message-ID: <20180328125254.31380-47-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8CF949F88
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:53:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7jCObjgHNOyt for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:52:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 073E44A087
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:48:07 -0400 (EDT)
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

We do not have to change the c15 trap setting on each switch to/from the
guest on VHE systems, because this setting only affects guest EL1/EL0
(and therefore not the VHE host).

The PMU and debug trap configuration can also be done on vcpu load/put
instead, because they don't affect how the VHE host kernel can access the
debug registers while executing KVM kernel code.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
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
index 5fbb77bd4e90..eab433fa1442 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -102,6 +102,8 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
+	__activate_traps_common(vcpu);
+
 	val = CPTR_EL2_DEFAULT;
 	val |= CPTR_EL2_TTA | CPTR_EL2_TFP | CPTR_EL2_TZ;
 	write_sysreg(val, cptr_el2);
@@ -121,20 +123,12 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
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
@@ -144,6 +138,8 @@ static void __hyp_text __deactivate_traps_nvhe(void)
 {
 	u64 mdcr_el2 = read_sysreg(mdcr_el2);
 
+	__deactivate_traps_common();
+
 	mdcr_el2 &= MDCR_EL2_HPMN_MASK;
 	mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
 
@@ -167,10 +163,27 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
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
