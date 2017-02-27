From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] arm64: KVM: VHE: Clear HCR_TGE when invalidating guest TLBs
Date: Mon, 27 Feb 2017 15:24:37 +0000
Message-ID: <20170227152437.26261-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5021B4092C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Feb 2017 10:23:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gbiuJ2apt-cs for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Feb 2017 10:23:47 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D908C40017
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Feb 2017 10:23:46 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Tomasz Nowicki <tnowicki@caviumnetworks.com>
List-Id: kvmarm@lists.cs.columbia.edu

When invalidating guest TLBs, special care must be taken to
actually shoot the guest TLBs and not the host ones if we're
running on a VHE system.  This is controlled by the HCR_EL2.TGE
bit, which we forget to clear before invalidating TLBs.

Address the issue by introducing two wrappers (__tlb_switch_to_guest
and __tlb_switch_to_host) that take care of both the VTTBR_EL2
and HCR_EL2.TGE switching.

Reported-by: Tomasz Nowicki <tnowicki@caviumnetworks.com>
Tested-by: Tomasz Nowicki <tnowicki@caviumnetworks.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/tlb.c | 64 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 55 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index 88e2f2b938f0..55889d057757 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -17,14 +17,62 @@
 
 #include <asm/kvm_hyp.h>
 
+static void __hyp_text __tlb_switch_to_guest_vhe(struct kvm *kvm)
+{
+	u64 val;
+
+	/*
+	 * With VHE enabled, we have HCR_EL2.{E2H,TGE} = {1,1}, and
+	 * most TLB operations target EL2/EL0. In order to affect the
+	 * guest TLBs (EL1/EL0), we need to change one of these two
+	 * bits. Changing E2H is impossible (goodbye TTBR1_EL2), so
+	 * let's flip TGE before executing the TLB operation.
+	 */
+	write_sysreg(kvm->arch.vttbr, vttbr_el2);
+	val = read_sysreg(hcr_el2);
+	val &= ~HCR_TGE;
+	write_sysreg(val, hcr_el2);
+	isb();
+}
+
+static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm *kvm)
+{
+	write_sysreg(kvm->arch.vttbr, vttbr_el2);
+	isb();
+}
+
+static hyp_alternate_select(__tlb_switch_to_guest,
+			    __tlb_switch_to_guest_nvhe,
+			    __tlb_switch_to_guest_vhe,
+			    ARM64_HAS_VIRT_HOST_EXTN);
+
+static void __hyp_text __tlb_switch_to_host_vhe(struct kvm *kvm)
+{
+	/*
+	 * We're done with the TLB operation, let's restore the host's
+	 * view of HCR_EL2.
+	 */
+	write_sysreg(0, vttbr_el2);
+	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
+}
+
+static void __hyp_text __tlb_switch_to_host_nvhe(struct kvm *kvm)
+{
+	write_sysreg(0, vttbr_el2);
+}
+
+static hyp_alternate_select(__tlb_switch_to_host,
+			    __tlb_switch_to_host_nvhe,
+			    __tlb_switch_to_host_vhe,
+			    ARM64_HAS_VIRT_HOST_EXTN);
+
 void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 {
 	dsb(ishst);
 
 	/* Switch to requested VMID */
 	kvm = kern_hyp_va(kvm);
-	write_sysreg(kvm->arch.vttbr, vttbr_el2);
-	isb();
+	__tlb_switch_to_guest()(kvm);
 
 	/*
 	 * We could do so much better if we had the VA as well.
@@ -45,7 +93,7 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 	dsb(ish);
 	isb();
 
-	write_sysreg(0, vttbr_el2);
+	__tlb_switch_to_host()(kvm);
 }
 
 void __hyp_text __kvm_tlb_flush_vmid(struct kvm *kvm)
@@ -54,14 +102,13 @@ void __hyp_text __kvm_tlb_flush_vmid(struct kvm *kvm)
 
 	/* Switch to requested VMID */
 	kvm = kern_hyp_va(kvm);
-	write_sysreg(kvm->arch.vttbr, vttbr_el2);
-	isb();
+	__tlb_switch_to_guest()(kvm);
 
 	asm volatile("tlbi vmalls12e1is" : : );
 	dsb(ish);
 	isb();
 
-	write_sysreg(0, vttbr_el2);
+	__tlb_switch_to_host()(kvm);
 }
 
 void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
@@ -69,14 +116,13 @@ void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
 	struct kvm *kvm = kern_hyp_va(kern_hyp_va(vcpu)->kvm);
 
 	/* Switch to requested VMID */
-	write_sysreg(kvm->arch.vttbr, vttbr_el2);
-	isb();
+	__tlb_switch_to_guest()(kvm);
 
 	asm volatile("tlbi vmalle1" : : );
 	dsb(nsh);
 	isb();
 
-	write_sysreg(0, vttbr_el2);
+	__tlb_switch_to_host()(kvm);
 }
 
 void __hyp_text __kvm_flush_vm_context(void)
-- 
2.11.0
