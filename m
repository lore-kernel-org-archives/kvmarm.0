From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 08/50] KVM: arm/arm64: Get rid of exported aliases to static
 functions
Date: Tue, 27 Sep 2016 20:05:16 +0200
Message-ID: <20160927180558.14699-9-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA63849B1A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wsl9XH7UnkQL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:56:31 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD55348531
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:31 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id w84so190343833wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:05:54 -0700 (PDT)
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

When rewriting the assembly code to C code, it was useful to have
exported aliases or static functions so that we could keep the existing
common C code unmodified and at the same time rewrite arm64 from
assembly to C code, and later do the arm part.

Now when both are done, we really don't need this level of indirection
anymore, and it's time to save a few lines and brain cells.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/hyp/switch.c       |  4 +---
 arch/arm/kvm/hyp/tlb.c          | 15 ++++-----------
 arch/arm64/kvm/hyp/debug-sr.c   |  4 +---
 arch/arm64/kvm/hyp/switch.c     |  4 +---
 arch/arm64/kvm/hyp/tlb.c        | 13 +++----------
 arch/arm64/kvm/hyp/vgic-v3-sr.c |  4 +---
 6 files changed, 11 insertions(+), 33 deletions(-)

diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index b13caa9..37b3365 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -134,7 +134,7 @@ static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-static int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
+int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
@@ -191,8 +191,6 @@ again:
 	return exit_code;
 }
 
-__alias(__guest_run) int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
-
 static const char * const __hyp_panic_string[] = {
 	[ARM_EXCEPTION_RESET]      = "\nHYP panic: RST   PC:%08x CPSR:%08x",
 	[ARM_EXCEPTION_UNDEFINED]  = "\nHYP panic: UNDEF PC:%08x CPSR:%08x",
diff --git a/arch/arm/kvm/hyp/tlb.c b/arch/arm/kvm/hyp/tlb.c
index a263600..7296528 100644
--- a/arch/arm/kvm/hyp/tlb.c
+++ b/arch/arm/kvm/hyp/tlb.c
@@ -34,7 +34,7 @@
  * As v7 does not support flushing per IPA, just nuke the whole TLB
  * instead, ignoring the ipa value.
  */
-static void __hyp_text __tlb_flush_vmid(struct kvm *kvm)
+void __hyp_text __kvm_tlb_flush_vmid(struct kvm *kvm)
 {
 	dsb(ishst);
 
@@ -50,21 +50,14 @@ static void __hyp_text __tlb_flush_vmid(struct kvm *kvm)
 	write_sysreg(0, VTTBR);
 }
 
-__alias(__tlb_flush_vmid) void __kvm_tlb_flush_vmid(struct kvm *kvm);
-
-static void __hyp_text __tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
+void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 {
-	__tlb_flush_vmid(kvm);
+	__kvm_tlb_flush_vmid(kvm);
 }
 
-__alias(__tlb_flush_vmid_ipa) void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm,
-							    phys_addr_t ipa);
-
-static void __hyp_text __tlb_flush_vm_context(void)
+void __hyp_text __kvm_flush_vm_context(void)
 {
 	write_sysreg(0, TLBIALLNSNHIS);
 	write_sysreg(0, ICIALLUIS);
 	dsb(ish);
 }
-
-__alias(__tlb_flush_vm_context) void __kvm_flush_vm_context(void);
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index 33342a7..4ba5c90 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -131,9 +131,7 @@ void __hyp_text __debug_cond_restore_host_state(struct kvm_vcpu *vcpu)
 		vcpu->arch.debug_flags &= ~KVM_ARM64_DEBUG_DIRTY;
 }
 
-static u32 __hyp_text __debug_read_mdcr_el2(void)
+u32 __hyp_text __kvm_get_mdcr_el2(void)
 {
 	return read_sysreg(mdcr_el2);
 }
-
-__alias(__debug_read_mdcr_el2) u32 __kvm_get_mdcr_el2(void);
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 5a84b45..35d2e09 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -232,7 +232,7 @@ static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-static int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
+int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
@@ -293,8 +293,6 @@ again:
 	return exit_code;
 }
 
-__alias(__guest_run) int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
-
 static const char __hyp_panic_string[] = "HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n";
 
 static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par)
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index be8177c..9cc0ea7 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -17,7 +17,7 @@
 
 #include <asm/kvm_hyp.h>
 
-static void __hyp_text __tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
+void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 {
 	dsb(ishst);
 
@@ -48,10 +48,7 @@ static void __hyp_text __tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 	write_sysreg(0, vttbr_el2);
 }
 
-__alias(__tlb_flush_vmid_ipa) void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm,
-							    phys_addr_t ipa);
-
-static void __hyp_text __tlb_flush_vmid(struct kvm *kvm)
+void __hyp_text __kvm_tlb_flush_vmid(struct kvm *kvm)
 {
 	dsb(ishst);
 
@@ -67,14 +64,10 @@ static void __hyp_text __tlb_flush_vmid(struct kvm *kvm)
 	write_sysreg(0, vttbr_el2);
 }
 
-__alias(__tlb_flush_vmid) void __kvm_tlb_flush_vmid(struct kvm *kvm);
-
-static void __hyp_text __tlb_flush_vm_context(void)
+void __hyp_text __kvm_flush_vm_context(void)
 {
 	dsb(ishst);
 	asm volatile("tlbi alle1is	\n"
 		     "ic ialluis	  ": : );
 	dsb(ish);
 }
-
-__alias(__tlb_flush_vm_context) void __kvm_flush_vm_context(void);
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 5f8f80b..ee1ea63 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -335,9 +335,7 @@ void __hyp_text __vgic_v3_init_lrs(void)
 		__gic_v3_set_lr(0, i);
 }
 
-static u64 __hyp_text __vgic_v3_read_ich_vtr_el2(void)
+u64 __hyp_text __vgic_v3_get_ich_vtr_el2(void)
 {
 	return read_gicreg(ICH_VTR_EL2);
 }
-
-__alias(__vgic_v3_read_ich_vtr_el2) u64 __vgic_v3_get_ich_vtr_el2(void);
-- 
2.9.0
