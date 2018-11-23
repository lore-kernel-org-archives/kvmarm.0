From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 1/8] arm64: KVM: Make VHE Stage-2 TLB invalidation
 operations non-interruptible
Date: Fri, 23 Nov 2018 18:41:00 +0000
Message-ID: <20181123184107.39334-2-marc.zyngier@arm.com>
References: <20181123184107.39334-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FB284A318
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Nov 2018 13:41:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LbenyDNhjnp3 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Nov 2018 13:41:18 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C59C34A236
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Nov 2018 13:41:18 -0500 (EST)
In-Reply-To: <20181123184107.39334-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Contrary to the non-VHE version of the TLB invalidation helpers, the VHE
code  has interrupts enabled, meaning that we can take an interrupt in
the middle of such a sequence, and start running something else with
HCR_EL2.TGE cleared.

That's really not a good idea.

Take the heavy-handed option and disable interrupts in
__tlb_switch_to_guest_vhe, restoring them in __tlb_switch_to_host_vhe.
The latter also gain an ISB in order to make sure that TGE really has
taken effect.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/tlb.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index 4dbd9c69a96d..7fcc9c1a5f45 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -15,14 +15,19 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/irqflags.h>
+
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/tlbflush.h>
 
-static void __hyp_text __tlb_switch_to_guest_vhe(struct kvm *kvm)
+static void __hyp_text __tlb_switch_to_guest_vhe(struct kvm *kvm,
+						 unsigned long *flags)
 {
 	u64 val;
 
+	local_irq_save(*flags);
+
 	/*
 	 * With VHE enabled, we have HCR_EL2.{E2H,TGE} = {1,1}, and
 	 * most TLB operations target EL2/EL0. In order to affect the
@@ -37,7 +42,8 @@ static void __hyp_text __tlb_switch_to_guest_vhe(struct kvm *kvm)
 	isb();
 }
 
-static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm *kvm)
+static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm *kvm,
+						  unsigned long *flags)
 {
 	__load_guest_stage2(kvm);
 	isb();
@@ -48,7 +54,8 @@ static hyp_alternate_select(__tlb_switch_to_guest,
 			    __tlb_switch_to_guest_vhe,
 			    ARM64_HAS_VIRT_HOST_EXTN);
 
-static void __hyp_text __tlb_switch_to_host_vhe(struct kvm *kvm)
+static void __hyp_text __tlb_switch_to_host_vhe(struct kvm *kvm,
+						unsigned long flags)
 {
 	/*
 	 * We're done with the TLB operation, let's restore the host's
@@ -56,9 +63,12 @@ static void __hyp_text __tlb_switch_to_host_vhe(struct kvm *kvm)
 	 */
 	write_sysreg(0, vttbr_el2);
 	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
+	isb();
+	local_irq_restore(flags);
 }
 
-static void __hyp_text __tlb_switch_to_host_nvhe(struct kvm *kvm)
+static void __hyp_text __tlb_switch_to_host_nvhe(struct kvm *kvm,
+						 unsigned long flags)
 {
 	write_sysreg(0, vttbr_el2);
 }
@@ -70,11 +80,13 @@ static hyp_alternate_select(__tlb_switch_to_host,
 
 void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 {
+	unsigned long flags;
+
 	dsb(ishst);
 
 	/* Switch to requested VMID */
 	kvm = kern_hyp_va(kvm);
-	__tlb_switch_to_guest()(kvm);
+	__tlb_switch_to_guest()(kvm, &flags);
 
 	/*
 	 * We could do so much better if we had the VA as well.
@@ -117,36 +129,39 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 	if (!has_vhe() && icache_is_vpipt())
 		__flush_icache_all();
 
-	__tlb_switch_to_host()(kvm);
+	__tlb_switch_to_host()(kvm, flags);
 }
 
 void __hyp_text __kvm_tlb_flush_vmid(struct kvm *kvm)
 {
+	unsigned long flags;
+
 	dsb(ishst);
 
 	/* Switch to requested VMID */
 	kvm = kern_hyp_va(kvm);
-	__tlb_switch_to_guest()(kvm);
+	__tlb_switch_to_guest()(kvm, &flags);
 
 	__tlbi(vmalls12e1is);
 	dsb(ish);
 	isb();
 
-	__tlb_switch_to_host()(kvm);
+	__tlb_switch_to_host()(kvm, flags);
 }
 
 void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = kern_hyp_va(kern_hyp_va(vcpu)->kvm);
+	unsigned long flags;
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest()(kvm);
+	__tlb_switch_to_guest()(kvm, &flags);
 
 	__tlbi(vmalle1);
 	dsb(nsh);
 	isb();
 
-	__tlb_switch_to_host()(kvm);
+	__tlb_switch_to_host()(kvm, flags);
 }
 
 void __hyp_text __kvm_flush_vm_context(void)
-- 
2.19.1
