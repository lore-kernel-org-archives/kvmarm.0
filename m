From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 24/95] ARM: KVM: Remove __weak attributes
Date: Wed,  9 Mar 2016 07:30:18 +0000
Message-ID: <1457508689-19672-25-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Now that the old code is long gone, we can remove all the weak
attributes, as there is only one version of the code.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/hyp/hyp-entry.S | 4 +---
 arch/arm/kvm/hyp/switch.c    | 2 +-
 arch/arm/kvm/hyp/tlb.c       | 6 +++---
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kvm/hyp/hyp-entry.S b/arch/arm/kvm/hyp/hyp-entry.S
index 54a8d67..7809138 100644
--- a/arch/arm/kvm/hyp/hyp-entry.S
+++ b/arch/arm/kvm/hyp/hyp-entry.S
@@ -58,10 +58,8 @@
  */
 
 	.align 5
-__hyp_vector:
-	.global	__hyp_vector
 __kvm_hyp_vector:
-	.weak __kvm_hyp_vector
+	.global __kvm_hyp_vector
 
 	@ Hyp-mode exception vector
 	W(b)	hyp_reset
diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index abbe90b..f11ede1 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -191,7 +191,7 @@ again:
 	return exit_code;
 }
 
-__alias(__guest_run) int __weak __kvm_vcpu_run(struct kvm_vcpu *vcpu);
+__alias(__guest_run) int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
 static const char * const __hyp_panic_string[] = {
 	[ARM_EXCEPTION_RESET]      = "\nHYP panic: RST   PC:%08x CPSR:%08x",
diff --git a/arch/arm/kvm/hyp/tlb.c b/arch/arm/kvm/hyp/tlb.c
index aaa44bb..82958b8 100644
--- a/arch/arm/kvm/hyp/tlb.c
+++ b/arch/arm/kvm/hyp/tlb.c
@@ -50,14 +50,14 @@ static void __hyp_text __tlb_flush_vmid(struct kvm *kvm)
 	write_sysreg(0, VTTBR);
 }
 
-__alias(__tlb_flush_vmid) void __weak __kvm_tlb_flush_vmid(struct kvm *kvm);
+__alias(__tlb_flush_vmid) void __kvm_tlb_flush_vmid(struct kvm *kvm);
 
 static void __hyp_text __tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 {
 	__tlb_flush_vmid(kvm);
 }
 
-__alias(__tlb_flush_vmid_ipa) void __weak __kvm_tlb_flush_vmid_ipa(struct kvm *kvm,
+__alias(__tlb_flush_vmid_ipa) void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm,
 							    phys_addr_t ipa);
 
 static void __hyp_text __tlb_flush_vm_context(void)
@@ -67,4 +67,4 @@ static void __hyp_text __tlb_flush_vm_context(void)
 	dsb(ish);
 }
 
-__alias(__tlb_flush_vm_context) void __weak __kvm_flush_vm_context(void);
+__alias(__tlb_flush_vm_context) void __kvm_flush_vm_context(void);
-- 
2.1.4

