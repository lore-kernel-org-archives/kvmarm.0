From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 21/21] arm64: KVM: Remove weak attributes
Date: Mon, 16 Nov 2015 13:11:59 +0000
Message-ID: <1447679519-17888-22-git-send-email-marc.zyngier@arm.com>
References: <1447679519-17888-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A0BF49937
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2015 08:12:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3Y1KDy0ULDbu for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2015 08:12:18 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F2F149A04
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2015 08:12:17 -0500 (EST)
In-Reply-To: <1447679519-17888-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Mark Rutland <marc.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

As we've now switched to the new world switch implementation,
remove the weak attributes, as nobody is supposed to override
it anymore.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/debug-sr.c   |  5 ++---
 arch/arm64/kvm/hyp/hyp-entry.S  |  3 ---
 arch/arm64/kvm/hyp/switch.c     |  5 ++---
 arch/arm64/kvm/hyp/tlb.c        | 16 +++++++---------
 arch/arm64/kvm/hyp/vgic-v3-sr.c |  5 ++---
 5 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index c7da3ec..f8ec964 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -127,10 +127,9 @@ void __hyp_text __debug_clear_restore_state(struct kvm_vcpu *vcpu,
 	}
 }
 
-u32 __hyp_text __debug_read_mdcr_el2(void)
+static u32 __hyp_text __debug_read_mdcr_el2(void)
 {
 	return read_sysreg(mdcr_el2);
 }
 
-__alias(__debug_read_mdcr_el2)
-u32 __weak __kvm_get_mdcr_el2(void);
+__alias(__debug_read_mdcr_el2) u32 __kvm_get_mdcr_el2(void);
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 28de58f..658b9af 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -175,9 +175,7 @@ ENDPROC(\label)
 
 	.align 11
 
-	.weak	__kvm_hyp_vector
 ENTRY(__kvm_hyp_vector)
-ENTRY(__hyp_vector)
 	ventry	el2t_sync_invalid		// Synchronous EL2t
 	ventry	el2t_irq_invalid		// IRQ EL2t
 	ventry	el2t_fiq_invalid		// FIQ EL2t
@@ -197,5 +195,4 @@ ENTRY(__hyp_vector)
 	ventry	el1_irq				// IRQ 32-bit EL1
 	ventry	el1_fiq_invalid			// FIQ 32-bit EL1
 	ventry	el1_error_invalid		// Error 32-bit EL1
-ENDPROC(__hyp_vector)
 ENDPROC(__kvm_hyp_vector)
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index ef58066..a2885f5 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -84,7 +84,7 @@ static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
 	__vgic_call_restore_state()(vcpu);
 }
 
-int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
+static int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
@@ -141,8 +141,7 @@ int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
 	return exit_code;
 }
 
-__alias(__guest_run)
-int __weak __kvm_vcpu_run(struct kvm_vcpu *vcpu);
+__alias(__guest_run) int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
 static const char *__hyp_panic_string = "HYP panic:\nPS:%08x PC:%p ESR:%p\nFAR:%p HPFAR:%p PAR:%p\nVCPU:%p\n";
 
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index 2c279a8..250e06c 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -17,7 +17,7 @@
 
 #include "hyp.h"
 
-void __hyp_text __tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
+static void __hyp_text __tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 {
 	dsb(ishst);
 
@@ -47,10 +47,10 @@ void __hyp_text __tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 	write_sysreg(0, vttbr_el2);
 }
 
-__alias(__tlb_flush_vmid_ipa)
-void __weak __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
+__alias(__tlb_flush_vmid_ipa) void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm,
+							    phys_addr_t ipa);
 
-void __hyp_text __tlb_flush_vmid(struct kvm *kvm)
+static void __hyp_text __tlb_flush_vmid(struct kvm *kvm)
 {
 	dsb(ishst);
 
@@ -66,10 +66,9 @@ void __hyp_text __tlb_flush_vmid(struct kvm *kvm)
 	write_sysreg(0, vttbr_el2);
 }
 
-__alias(__tlb_flush_vmid)
-void __weak __kvm_tlb_flush_vmid(struct kvm *kvm);
+__alias(__tlb_flush_vmid) void __kvm_tlb_flush_vmid(struct kvm *kvm);
 
-void __hyp_text __tlb_flush_vm_context(void)
+static void __hyp_text __tlb_flush_vm_context(void)
 {
 	dsb(ishst);
 	asm volatile("tlbi alle1is	\n"
@@ -77,5 +76,4 @@ void __hyp_text __tlb_flush_vm_context(void)
 	dsb(ish);
 }
 
-__alias(__tlb_flush_vm_context)
-void __weak __kvm_flush_vm_context(void);
+__alias(__tlb_flush_vm_context) void __kvm_flush_vm_context(void);
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 0cf316c..9189f71 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -216,10 +216,9 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 	}
 }
 
-u64 __hyp_text __vgic_v3_read_ich_vtr_el2(void)
+static u64 __hyp_text __vgic_v3_read_ich_vtr_el2(void)
 {
 	return read_gicreg(ICH_VTR_EL2);
 }
 
-__alias(__vgic_v3_read_ich_vtr_el2)
-u64 __weak __vgic_v3_get_ich_vtr_el2(void);
+__alias(__vgic_v3_read_ich_vtr_el2) u64 __vgic_v3_get_ich_vtr_el2(void);
-- 
2.1.4
