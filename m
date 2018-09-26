From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v6 03/18] kvm: arm64: Add helper for loading the stage2 setting for a VM
Date: Wed, 26 Sep 2018 17:32:39 +0100
Message-ID: <20180926163258.20218-4-suzuki.poulose@arm.com>
References: <20180926163258.20218-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180926163258.20218-1-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, cdall@kernel.org, eric.auger@redhat.com, suzuki.poulose@arm.com, will.deacon@arm.com, dave.martin@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, julien.grall@arm.com, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

We load the stage2 context of a guest for different operations,
including running the guest and tlb maintenance on behalf of the
guest. As of now only the vttbr is private to the guest, but this
is about to change with IPA per VM. Add a helper to load the stage2
configuration for a VM, which could do the right thing with the
future changes.

Cc: Christoffer Dall <cdall@kernel.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v2:
 - New patch
---
 arch/arm64/include/asm/kvm_hyp.h | 9 +++++++++
 arch/arm64/kvm/hyp/switch.c      | 2 +-
 arch/arm64/kvm/hyp/tlb.c         | 4 ++--
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 384c34397619..d1bd1e0f14d7 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -155,5 +155,14 @@ void deactivate_traps_vhe_put(void);
 u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
 void __noreturn __hyp_do_panic(unsigned long, ...);
 
+/*
+ * Must be called from hyp code running at EL2 with an updated VTTBR
+ * and interrupts disabled.
+ */
+static __always_inline void __hyp_text __load_guest_stage2(struct kvm *kvm)
+{
+	write_sysreg(kvm->arch.vttbr, vttbr_el2);
+}
+
 #endif /* __ARM64_KVM_HYP_H__ */
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index ca46153d7915..9d5ce1a3039a 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -198,7 +198,7 @@ void deactivate_traps_vhe_put(void)
 
 static void __hyp_text __activate_vm(struct kvm *kvm)
 {
-	write_sysreg(kvm->arch.vttbr, vttbr_el2);
+	__load_guest_stage2(kvm);
 }
 
 static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index 131c7772703c..4dbd9c69a96d 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -30,7 +30,7 @@ static void __hyp_text __tlb_switch_to_guest_vhe(struct kvm *kvm)
 	 * bits. Changing E2H is impossible (goodbye TTBR1_EL2), so
 	 * let's flip TGE before executing the TLB operation.
 	 */
-	write_sysreg(kvm->arch.vttbr, vttbr_el2);
+	__load_guest_stage2(kvm);
 	val = read_sysreg(hcr_el2);
 	val &= ~HCR_TGE;
 	write_sysreg(val, hcr_el2);
@@ -39,7 +39,7 @@ static void __hyp_text __tlb_switch_to_guest_vhe(struct kvm *kvm)
 
 static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm *kvm)
 {
-	write_sysreg(kvm->arch.vttbr, vttbr_el2);
+	__load_guest_stage2(kvm);
 	isb();
 }
 
-- 
2.19.0
