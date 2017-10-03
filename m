From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 04/31] KVM: arm/arm64: Abstract stage-2 MMU state into
 a separate structure
Date: Mon,  2 Oct 2017 22:10:46 -0500
Message-ID: <1507000273-3735-2-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40B8E49C2F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hAkCURIR-JHE for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 23:11:22 -0400 (EDT)
Received: from mail-io0-f182.google.com (mail-io0-f182.google.com
 [209.85.223.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 125D74060C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:22 -0400 (EDT)
Received: by mail-io0-f182.google.com with SMTP id i197so6443633ioe.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Oct 2017 20:11:41 -0700 (PDT)
In-Reply-To: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Abstract stage-2 MMU state into a separate structure and change all
callers referring to page tables, VMIDs, and the VTTBR to use this new
indirection.

This is about to become very handy when using shadow stage-2 page
tables.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm/include/asm/kvm_asm.h    |   7 +-
 arch/arm/include/asm/kvm_host.h   |  26 +++++---
 arch/arm/kvm/hyp/switch.c         |   5 +-
 arch/arm/kvm/hyp/tlb.c            |  18 ++---
 arch/arm64/include/asm/kvm_asm.h  |   7 +-
 arch/arm64/include/asm/kvm_host.h |  10 ++-
 arch/arm64/kvm/hyp/switch.c       |   5 +-
 arch/arm64/kvm/hyp/tlb.c          |  38 +++++------
 virt/kvm/arm/arm.c                |  34 +++++-----
 virt/kvm/arm/mmu.c                | 137 +++++++++++++++++++++-----------------
 10 files changed, 163 insertions(+), 124 deletions(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 14d68a4..71b7255 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -57,6 +57,7 @@
 #ifndef __ASSEMBLY__
 struct kvm;
 struct kvm_vcpu;
+struct kvm_s2_mmu;
 
 extern char __kvm_hyp_init[];
 extern char __kvm_hyp_init_end[];
@@ -64,9 +65,9 @@
 extern char __kvm_hyp_vector[];
 
 extern void __kvm_flush_vm_context(void);
-extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
-extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
-extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
+extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa);
+extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
+extern void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 7e9e6c8..78d826e 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -53,9 +53,21 @@
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 void kvm_reset_coprocs(struct kvm_vcpu *vcpu);
 
-struct kvm_arch {
-	/* VTTBR value associated with below pgd and vmid */
+struct kvm_s2_mmu {
+	/* The VMID generation used for the virt. memory system */
+	u64    vmid_gen;
+	u32    vmid;
+
+	/* Stage-2 page table */
+	pgd_t *pgd;
+
+	/* VTTBR value associated with above pgd and vmid */
 	u64    vttbr;
+};
+
+struct kvm_arch {
+	/* Stage 2 paging state for the VM */
+	struct kvm_s2_mmu mmu;
 
 	/* The last vcpu id that ran on each physical CPU */
 	int __percpu *last_vcpu_ran;
@@ -65,13 +77,6 @@ struct kvm_arch {
 	 * here.
 	 */
 
-	/* The VMID generation used for the virt. memory system */
-	u64    vmid_gen;
-	u32    vmid;
-
-	/* Stage-2 page table */
-	pgd_t *pgd;
-
 	/* Interrupt controller */
 	struct vgic_dist	vgic;
 	int max_vcpus;
@@ -185,6 +190,9 @@ struct kvm_vcpu_arch {
 
 	/* Detect first run of a vcpu */
 	bool has_run_once;
+
+	/* Stage 2 paging state used by the hardware on next switch */
+	struct kvm_s2_mmu *hw_mmu;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index ebd2dd4..4814671 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -75,8 +75,9 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 
 static void __hyp_text __activate_vm(struct kvm_vcpu *vcpu)
 {
-	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
-	write_sysreg(kvm->arch.vttbr, VTTBR);
+	struct kvm_s2_mmu *mmu = kern_hyp_va(vcpu->arch.hw_mmu);
+
+	write_sysreg(mmu->vttbr, VTTBR);
 	write_sysreg(vcpu->arch.midr, VPIDR);
 }
 
diff --git a/arch/arm/kvm/hyp/tlb.c b/arch/arm/kvm/hyp/tlb.c
index 6d810af..56f0a49 100644
--- a/arch/arm/kvm/hyp/tlb.c
+++ b/arch/arm/kvm/hyp/tlb.c
@@ -34,13 +34,13 @@
  * As v7 does not support flushing per IPA, just nuke the whole TLB
  * instead, ignoring the ipa value.
  */
-void __hyp_text __kvm_tlb_flush_vmid(struct kvm *kvm)
+void __hyp_text __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 {
 	dsb(ishst);
 
 	/* Switch to requested VMID */
-	kvm = kern_hyp_va(kvm);
-	write_sysreg(kvm->arch.vttbr, VTTBR);
+	mmu = kern_hyp_va(mmu);
+	write_sysreg(mmu->vttbr, VTTBR);
 	isb();
 
 	write_sysreg(0, TLBIALLIS);
@@ -50,17 +50,17 @@ void __hyp_text __kvm_tlb_flush_vmid(struct kvm *kvm)
 	write_sysreg(0, VTTBR);
 }
 
-void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
+void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
+					 phys_addr_t ipa)
 {
-	__kvm_tlb_flush_vmid(kvm);
+	__kvm_tlb_flush_vmid(mmu);
 }
 
-void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
+void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu)
 {
-	struct kvm *kvm = kern_hyp_va(kern_hyp_va(vcpu)->kvm);
-
 	/* Switch to requested VMID */
-	write_sysreg(kvm->arch.vttbr, VTTBR);
+	mmu = kern_hyp_va(mmu);
+	write_sysreg(mmu->vttbr, VTTBR);
 	isb();
 
 	write_sysreg(0, TLBIALL);
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 26a64d0..ff6244f 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -44,6 +44,7 @@
 #ifndef __ASSEMBLY__
 struct kvm;
 struct kvm_vcpu;
+struct kvm_s2_mmu;
 
 extern char __kvm_hyp_init[];
 extern char __kvm_hyp_init_end[];
@@ -51,9 +52,9 @@
 extern char __kvm_hyp_vector[];
 
 extern void __kvm_flush_vm_context(void);
-extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
-extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
-extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
+extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa);
+extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
+extern void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 373235c..e7e9f70 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -50,7 +50,7 @@
 int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext);
 void __extended_idmap_trampoline(phys_addr_t boot_pgd, phys_addr_t idmap_start);
 
-struct kvm_arch {
+struct kvm_s2_mmu {
 	/* The VMID generation used for the virt. memory system */
 	u64    vmid_gen;
 	u32    vmid;
@@ -61,6 +61,11 @@ struct kvm_arch {
 
 	/* VTTBR value associated with above pgd and vmid */
 	u64    vttbr;
+};
+
+struct kvm_arch {
+	/* Stage 2 paging state for the VM */
+	struct kvm_s2_mmu mmu;
 
 	/* The last vcpu id that ran on each physical CPU */
 	int __percpu *last_vcpu_ran;
@@ -329,6 +334,9 @@ struct kvm_vcpu_arch {
 
 	/* Detect first run of a vcpu */
 	bool has_run_once;
+
+	/* Stage 2 paging state used by the hardware on next switch */
+	struct kvm_s2_mmu *hw_mmu;
 };
 
 #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 2a64a5c..8b1b3e9 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -181,8 +181,9 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 
 static void __hyp_text __activate_vm(struct kvm_vcpu *vcpu)
 {
-	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
-	write_sysreg(kvm->arch.vttbr, vttbr_el2);
+	struct kvm_s2_mmu *mmu = kern_hyp_va(vcpu->arch.hw_mmu);
+
+	write_sysreg(mmu->vttbr, vttbr_el2);
 }
 
 static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index 73464a9..0897678 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -18,7 +18,7 @@
 #include <asm/kvm_hyp.h>
 #include <asm/tlbflush.h>
 
-static void __hyp_text __tlb_switch_to_guest_vhe(struct kvm *kvm)
+static void __hyp_text __tlb_switch_to_guest_vhe(struct kvm_s2_mmu *mmu)
 {
 	u64 val;
 
@@ -29,16 +29,16 @@ static void __hyp_text __tlb_switch_to_guest_vhe(struct kvm *kvm)
 	 * bits. Changing E2H is impossible (goodbye TTBR1_EL2), so
 	 * let's flip TGE before executing the TLB operation.
 	 */
-	write_sysreg(kvm->arch.vttbr, vttbr_el2);
+	write_sysreg(mmu->vttbr, vttbr_el2);
 	val = read_sysreg(hcr_el2);
 	val &= ~HCR_TGE;
 	write_sysreg(val, hcr_el2);
 	isb();
 }
 
-static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm *kvm)
+static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm_s2_mmu *mmu)
 {
-	write_sysreg(kvm->arch.vttbr, vttbr_el2);
+	write_sysreg(mmu->vttbr, vttbr_el2);
 	isb();
 }
 
@@ -47,7 +47,7 @@ static hyp_alternate_select(__tlb_switch_to_guest,
 			    __tlb_switch_to_guest_vhe,
 			    ARM64_HAS_VIRT_HOST_EXTN);
 
-static void __hyp_text __tlb_switch_to_host_vhe(struct kvm *kvm)
+static void __hyp_text __tlb_switch_to_host_vhe(struct kvm_s2_mmu *mmu)
 {
 	/*
 	 * We're done with the TLB operation, let's restore the host's
@@ -57,7 +57,7 @@ static void __hyp_text __tlb_switch_to_host_vhe(struct kvm *kvm)
 	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
 }
 
-static void __hyp_text __tlb_switch_to_host_nvhe(struct kvm *kvm)
+static void __hyp_text __tlb_switch_to_host_nvhe(struct kvm_s2_mmu *mmu)
 {
 	write_sysreg(0, vttbr_el2);
 }
@@ -67,13 +67,14 @@ static hyp_alternate_select(__tlb_switch_to_host,
 			    __tlb_switch_to_host_vhe,
 			    ARM64_HAS_VIRT_HOST_EXTN);
 
-void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
+void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
+					 phys_addr_t ipa)
 {
 	dsb(ishst);
 
 	/* Switch to requested VMID */
-	kvm = kern_hyp_va(kvm);
-	__tlb_switch_to_guest()(kvm);
+	mmu = kern_hyp_va(mmu);
+	__tlb_switch_to_guest()(mmu);
 
 	/*
 	 * We could do so much better if we had the VA as well.
@@ -116,36 +117,35 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 	if (!has_vhe() && icache_is_vpipt())
 		__flush_icache_all();
 
-	__tlb_switch_to_host()(kvm);
+	__tlb_switch_to_host()(mmu);
 }
 
-void __hyp_text __kvm_tlb_flush_vmid(struct kvm *kvm)
+void __hyp_text __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 {
 	dsb(ishst);
 
 	/* Switch to requested VMID */
-	kvm = kern_hyp_va(kvm);
-	__tlb_switch_to_guest()(kvm);
+	mmu = kern_hyp_va(mmu);
+	__tlb_switch_to_guest()(mmu);
 
 	__tlbi(vmalls12e1is);
 	dsb(ish);
 	isb();
 
-	__tlb_switch_to_host()(kvm);
+	__tlb_switch_to_host()(mmu);
 }
 
-void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
+void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu)
 {
-	struct kvm *kvm = kern_hyp_va(kern_hyp_va(vcpu)->kvm);
-
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest()(kvm);
+	mmu = kern_hyp_va(mmu);
+	__tlb_switch_to_guest()(mmu);
 
 	__tlbi(vmalle1);
 	dsb(nsh);
 	isb();
 
-	__tlb_switch_to_host()(kvm);
+	__tlb_switch_to_host()(mmu);
 }
 
 void __hyp_text __kvm_flush_vm_context(void)
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 0ff2997..bee27bb 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -138,7 +138,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_vgic_early_init(kvm);
 
 	/* Mark the initial VMID generation invalid */
-	kvm->arch.vmid_gen = 0;
+	kvm->arch.mmu.vmid_gen = 0;
 
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->arch.max_vcpus = vgic_present ?
@@ -334,6 +334,8 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 
 	kvm_arm_reset_debug_ptr(vcpu);
 
+	vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
+
 	return kvm_vgic_vcpu_init(vcpu);
 }
 
@@ -348,7 +350,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	 * over-invalidation doesn't affect correctness.
 	 */
 	if (*last_ran != vcpu->vcpu_id) {
-		kvm_call_hyp(__kvm_tlb_flush_local_vmid, vcpu);
+		kvm_call_hyp(__kvm_tlb_flush_local_vmid, &vcpu->kvm->arch.mmu);
 		*last_ran = vcpu->vcpu_id;
 	}
 
@@ -442,25 +444,26 @@ void force_vm_exit(const cpumask_t *mask)
  * VMID for the new generation, we must flush necessary caches and TLBs on all
  * CPUs.
  */
-static bool need_new_vmid_gen(struct kvm *kvm)
+static bool need_new_vmid_gen(struct kvm_s2_mmu *mmu)
 {
-	return unlikely(kvm->arch.vmid_gen != atomic64_read(&kvm_vmid_gen));
+	return unlikely(mmu->vmid_gen != atomic64_read(&kvm_vmid_gen));
 }
 
 /**
  * update_vttbr - Update the VTTBR with a valid VMID before the guest runs
- * @kvm	The guest that we are about to run
+ * @kvm: The guest that we are about to run
+ * @mmu: The stage-2 translation context to update
  *
  * Called from kvm_arch_vcpu_ioctl_run before entering the guest to ensure the
  * VM has a valid VMID, otherwise assigns a new one and flushes corresponding
  * caches and TLBs.
  */
-static void update_vttbr(struct kvm *kvm)
+static void update_vttbr(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 {
 	phys_addr_t pgd_phys;
 	u64 vmid;
 
-	if (!need_new_vmid_gen(kvm))
+	if (!need_new_vmid_gen(mmu))
 		return;
 
 	spin_lock(&kvm_vmid_lock);
@@ -470,7 +473,7 @@ static void update_vttbr(struct kvm *kvm)
 	 * already allocated a valid vmid for this vm, then this vcpu should
 	 * use the same vmid.
 	 */
-	if (!need_new_vmid_gen(kvm)) {
+	if (!need_new_vmid_gen(mmu)) {
 		spin_unlock(&kvm_vmid_lock);
 		return;
 	}
@@ -494,16 +497,17 @@ static void update_vttbr(struct kvm *kvm)
 		kvm_call_hyp(__kvm_flush_vm_context);
 	}
 
-	kvm->arch.vmid_gen = atomic64_read(&kvm_vmid_gen);
-	kvm->arch.vmid = kvm_next_vmid;
+	mmu->vmid_gen = atomic64_read(&kvm_vmid_gen);
+	mmu->vmid = kvm_next_vmid;
 	kvm_next_vmid++;
 	kvm_next_vmid &= (1 << kvm_vmid_bits) - 1;
 
 	/* update vttbr to be used with the new vmid */
-	pgd_phys = virt_to_phys(kvm->arch.pgd);
+	pgd_phys = virt_to_phys(mmu->pgd);
 	BUG_ON(pgd_phys & ~VTTBR_BADDR_MASK);
-	vmid = ((u64)(kvm->arch.vmid) << VTTBR_VMID_SHIFT) & VTTBR_VMID_MASK(kvm_vmid_bits);
-	kvm->arch.vttbr = pgd_phys | vmid;
+	vmid = ((u64)(mmu->vmid) << VTTBR_VMID_SHIFT) &
+	       VTTBR_VMID_MASK(kvm_vmid_bits);
+	mmu->vttbr = pgd_phys | vmid;
 
 	spin_unlock(&kvm_vmid_lock);
 }
@@ -638,7 +642,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 */
 		cond_resched();
 
-		update_vttbr(vcpu->kvm);
+		update_vttbr(vcpu->kvm, vcpu->arch.hw_mmu);
 
 		check_vcpu_requests(vcpu);
 
@@ -677,7 +681,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 */
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
-		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
+		if (ret <= 0 || need_new_vmid_gen(vcpu->arch.hw_mmu) ||
 		    kvm_request_pending(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			local_irq_enable();
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 0a5f5ca..d8ea1f9 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -64,9 +64,9 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 	kvm_call_hyp(__kvm_tlb_flush_vmid, kvm);
 }
 
-static void kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
+static void kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
 {
-	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, kvm, ipa);
+	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ipa);
 }
 
 /*
@@ -103,13 +103,14 @@ static bool kvm_is_device_pfn(unsigned long pfn)
  * Function clears a PMD entry, flushes addr 1st and 2nd stage TLBs. Marks all
  * pages in the range dirty.
  */
-static void stage2_dissolve_pmd(struct kvm *kvm, phys_addr_t addr, pmd_t *pmd)
+static void stage2_dissolve_pmd(struct kvm_s2_mmu *mmu, phys_addr_t addr,
+				pmd_t *pmd)
 {
 	if (!pmd_thp_or_huge(*pmd))
 		return;
 
 	pmd_clear(pmd);
-	kvm_tlb_flush_vmid_ipa(kvm, addr);
+	kvm_tlb_flush_vmid_ipa(mmu, addr);
 	put_page(virt_to_page(pmd));
 }
 
@@ -145,31 +146,34 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 	return p;
 }
 
-static void clear_stage2_pgd_entry(struct kvm *kvm, pgd_t *pgd, phys_addr_t addr)
+static void clear_stage2_pgd_entry(struct kvm_s2_mmu *mmu,
+				   pgd_t *pgd, phys_addr_t addr)
 {
 	pud_t *pud_table __maybe_unused = stage2_pud_offset(pgd, 0UL);
 	stage2_pgd_clear(pgd);
-	kvm_tlb_flush_vmid_ipa(kvm, addr);
+	kvm_tlb_flush_vmid_ipa(mmu, addr);
 	stage2_pud_free(pud_table);
 	put_page(virt_to_page(pgd));
 }
 
-static void clear_stage2_pud_entry(struct kvm *kvm, pud_t *pud, phys_addr_t addr)
+static void clear_stage2_pud_entry(struct kvm_s2_mmu *mmu,
+				   pud_t *pud, phys_addr_t addr)
 {
 	pmd_t *pmd_table __maybe_unused = stage2_pmd_offset(pud, 0);
 	VM_BUG_ON(stage2_pud_huge(*pud));
 	stage2_pud_clear(pud);
-	kvm_tlb_flush_vmid_ipa(kvm, addr);
+	kvm_tlb_flush_vmid_ipa(mmu, addr);
 	stage2_pmd_free(pmd_table);
 	put_page(virt_to_page(pud));
 }
 
-static void clear_stage2_pmd_entry(struct kvm *kvm, pmd_t *pmd, phys_addr_t addr)
+static void clear_stage2_pmd_entry(struct kvm_s2_mmu *mmu,
+				   pmd_t *pmd, phys_addr_t addr)
 {
 	pte_t *pte_table = pte_offset_kernel(pmd, 0);
 	VM_BUG_ON(pmd_thp_or_huge(*pmd));
 	pmd_clear(pmd);
-	kvm_tlb_flush_vmid_ipa(kvm, addr);
+	kvm_tlb_flush_vmid_ipa(mmu, addr);
 	pte_free_kernel(NULL, pte_table);
 	put_page(virt_to_page(pmd));
 }
@@ -194,7 +198,7 @@ static void clear_stage2_pmd_entry(struct kvm *kvm, pmd_t *pmd, phys_addr_t addr
  * the corresponding TLBs, we call kvm_flush_dcache_p*() to make sure
  * the IO subsystem will never hit in the cache.
  */
-static void unmap_stage2_ptes(struct kvm *kvm, pmd_t *pmd,
+static void unmap_stage2_ptes(struct kvm_s2_mmu *mmu, pmd_t *pmd,
 		       phys_addr_t addr, phys_addr_t end)
 {
 	phys_addr_t start_addr = addr;
@@ -206,7 +210,7 @@ static void unmap_stage2_ptes(struct kvm *kvm, pmd_t *pmd,
 			pte_t old_pte = *pte;
 
 			kvm_set_pte(pte, __pte(0));
-			kvm_tlb_flush_vmid_ipa(kvm, addr);
+			kvm_tlb_flush_vmid_ipa(mmu, addr);
 
 			/* No need to invalidate the cache for device mappings */
 			if (!kvm_is_device_pfn(pte_pfn(old_pte)))
@@ -217,10 +221,10 @@ static void unmap_stage2_ptes(struct kvm *kvm, pmd_t *pmd,
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
 	if (stage2_pte_table_empty(start_pte))
-		clear_stage2_pmd_entry(kvm, pmd, start_addr);
+		clear_stage2_pmd_entry(mmu, pmd, start_addr);
 }
 
-static void unmap_stage2_pmds(struct kvm *kvm, pud_t *pud,
+static void unmap_stage2_pmds(struct kvm_s2_mmu *mmu, pud_t *pud,
 		       phys_addr_t addr, phys_addr_t end)
 {
 	phys_addr_t next, start_addr = addr;
@@ -234,22 +238,22 @@ static void unmap_stage2_pmds(struct kvm *kvm, pud_t *pud,
 				pmd_t old_pmd = *pmd;
 
 				pmd_clear(pmd);
-				kvm_tlb_flush_vmid_ipa(kvm, addr);
+				kvm_tlb_flush_vmid_ipa(mmu, addr);
 
 				kvm_flush_dcache_pmd(old_pmd);
 
 				put_page(virt_to_page(pmd));
 			} else {
-				unmap_stage2_ptes(kvm, pmd, addr, next);
+				unmap_stage2_ptes(mmu, pmd, addr, next);
 			}
 		}
 	} while (pmd++, addr = next, addr != end);
 
 	if (stage2_pmd_table_empty(start_pmd))
-		clear_stage2_pud_entry(kvm, pud, start_addr);
+		clear_stage2_pud_entry(mmu, pud, start_addr);
 }
 
-static void unmap_stage2_puds(struct kvm *kvm, pgd_t *pgd,
+static void unmap_stage2_puds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
 		       phys_addr_t addr, phys_addr_t end)
 {
 	phys_addr_t next, start_addr = addr;
@@ -263,17 +267,17 @@ static void unmap_stage2_puds(struct kvm *kvm, pgd_t *pgd,
 				pud_t old_pud = *pud;
 
 				stage2_pud_clear(pud);
-				kvm_tlb_flush_vmid_ipa(kvm, addr);
+				kvm_tlb_flush_vmid_ipa(mmu, addr);
 				kvm_flush_dcache_pud(old_pud);
 				put_page(virt_to_page(pud));
 			} else {
-				unmap_stage2_pmds(kvm, pud, addr, next);
+				unmap_stage2_pmds(mmu, pud, addr, next);
 			}
 		}
 	} while (pud++, addr = next, addr != end);
 
 	if (stage2_pud_table_empty(start_pud))
-		clear_stage2_pgd_entry(kvm, pgd, start_addr);
+		clear_stage2_pgd_entry(mmu, pgd, start_addr);
 }
 
 /**
@@ -292,20 +296,21 @@ static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
 	pgd_t *pgd;
 	phys_addr_t addr = start, end = start + size;
 	phys_addr_t next;
+	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
 
 	assert_spin_locked(&kvm->mmu_lock);
-	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
+	pgd = mmu->pgd + stage2_pgd_index(addr);
 	do {
 		/*
 		 * Make sure the page table is still active, as another thread
 		 * could have possibly freed the page table, while we released
 		 * the lock.
 		 */
-		if (!READ_ONCE(kvm->arch.pgd))
+		if (!READ_ONCE(mmu->pgd))
 			break;
 		next = stage2_pgd_addr_end(addr, end);
 		if (!stage2_pgd_none(*pgd))
-			unmap_stage2_puds(kvm, pgd, addr, next);
+			unmap_stage2_puds(mmu, pgd, addr, next);
 		/*
 		 * If the range is too large, release the kvm->mmu_lock
 		 * to prevent starvation and lockup detector warnings.
@@ -360,7 +365,7 @@ static void stage2_flush_puds(pgd_t *pgd, phys_addr_t addr, phys_addr_t end)
 	} while (pud++, addr = next, addr != end);
 }
 
-static void stage2_flush_memslot(struct kvm *kvm,
+static void stage2_flush_memslot(struct kvm_s2_mmu *mmu,
 				 struct kvm_memory_slot *memslot)
 {
 	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
@@ -368,7 +373,7 @@ static void stage2_flush_memslot(struct kvm *kvm,
 	phys_addr_t next;
 	pgd_t *pgd;
 
-	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
+	pgd = mmu->pgd + stage2_pgd_index(addr);
 	do {
 		next = stage2_pgd_addr_end(addr, end);
 		stage2_flush_puds(pgd, addr, next);
@@ -393,7 +398,7 @@ static void stage2_flush_vm(struct kvm *kvm)
 
 	slots = kvm_memslots(kvm);
 	kvm_for_each_memslot(memslot, slots)
-		stage2_flush_memslot(kvm, memslot);
+		stage2_flush_memslot(&kvm->arch.mmu, memslot);
 
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -745,8 +750,9 @@ int create_hyp_io_mappings(void *from, void *to, phys_addr_t phys_addr)
 int kvm_alloc_stage2_pgd(struct kvm *kvm)
 {
 	pgd_t *pgd;
+	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
 
-	if (kvm->arch.pgd != NULL) {
+	if (mmu->pgd != NULL) {
 		kvm_err("kvm_arch already initialized?\n");
 		return -EINVAL;
 	}
@@ -756,7 +762,8 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
 	if (!pgd)
 		return -ENOMEM;
 
-	kvm->arch.pgd = pgd;
+	mmu->pgd = pgd;
+
 	return 0;
 }
 
@@ -831,19 +838,20 @@ void stage2_unmap_vm(struct kvm *kvm)
  * kvm_free_stage2_pgd - free all stage-2 tables
  * @kvm:	The KVM struct pointer for the VM.
  *
- * Walks the level-1 page table pointed to by kvm->arch.pgd and frees all
+ * Walks the level-1 page table pointed to by kvm->arch.mmu.pgd and frees all
  * underlying level-2 and level-3 tables before freeing the actual level-1 table
  * and setting the struct pointer to NULL.
  */
 void kvm_free_stage2_pgd(struct kvm *kvm)
 {
 	void *pgd = NULL;
+	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
 
 	spin_lock(&kvm->mmu_lock);
-	if (kvm->arch.pgd) {
+	if (mmu->pgd) {
 		unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
-		pgd = READ_ONCE(kvm->arch.pgd);
-		kvm->arch.pgd = NULL;
+		pgd = READ_ONCE(mmu->pgd);
+		mmu->pgd = NULL;
 	}
 	spin_unlock(&kvm->mmu_lock);
 
@@ -852,13 +860,14 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
 		free_pages_exact(pgd, S2_PGD_SIZE);
 }
 
-static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
+static pud_t *stage2_get_pud(struct kvm_s2_mmu *mmu,
+			     struct kvm_mmu_memory_cache *cache,
 			     phys_addr_t addr)
 {
 	pgd_t *pgd;
 	pud_t *pud;
 
-	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
+	pgd = mmu->pgd + stage2_pgd_index(addr);
 	if (WARN_ON(stage2_pgd_none(*pgd))) {
 		if (!cache)
 			return NULL;
@@ -870,13 +879,14 @@ static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	return stage2_pud_offset(pgd, addr);
 }
 
-static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
+static pmd_t *stage2_get_pmd(struct kvm_s2_mmu *mmu,
+			     struct kvm_mmu_memory_cache *cache,
 			     phys_addr_t addr)
 {
 	pud_t *pud;
 	pmd_t *pmd;
 
-	pud = stage2_get_pud(kvm, cache, addr);
+	pud = stage2_get_pud(mmu, cache, addr);
 	if (!pud)
 		return NULL;
 
@@ -891,12 +901,13 @@ static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	return stage2_pmd_offset(pud, addr);
 }
 
-static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
+static int stage2_set_pmd_huge(struct kvm_s2_mmu *mmu,
+			       struct kvm_mmu_memory_cache
 			       *cache, phys_addr_t addr, const pmd_t *new_pmd)
 {
 	pmd_t *pmd, old_pmd;
 
-	pmd = stage2_get_pmd(kvm, cache, addr);
+	pmd = stage2_get_pmd(mmu, cache, addr);
 	VM_BUG_ON(!pmd);
 
 	/*
@@ -913,7 +924,7 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 	old_pmd = *pmd;
 	if (pmd_present(old_pmd)) {
 		pmd_clear(pmd);
-		kvm_tlb_flush_vmid_ipa(kvm, addr);
+		kvm_tlb_flush_vmid_ipa(mmu, addr);
 	} else {
 		get_page(virt_to_page(pmd));
 	}
@@ -922,7 +933,8 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 	return 0;
 }
 
-static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
+static int stage2_set_pte(struct kvm_s2_mmu *mmu,
+			  struct kvm_mmu_memory_cache *cache,
 			  phys_addr_t addr, const pte_t *new_pte,
 			  unsigned long flags)
 {
@@ -934,7 +946,7 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 	VM_BUG_ON(logging_active && !cache);
 
 	/* Create stage-2 page table mapping - Levels 0 and 1 */
-	pmd = stage2_get_pmd(kvm, cache, addr);
+	pmd = stage2_get_pmd(mmu, cache, addr);
 	if (!pmd) {
 		/*
 		 * Ignore calls from kvm_set_spte_hva for unallocated
@@ -948,7 +960,7 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 	 * allocate page.
 	 */
 	if (logging_active)
-		stage2_dissolve_pmd(kvm, addr, pmd);
+		stage2_dissolve_pmd(mmu, addr, pmd);
 
 	/* Create stage-2 page mappings - Level 2 */
 	if (pmd_none(*pmd)) {
@@ -968,7 +980,7 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 	old_pte = *pte;
 	if (pte_present(old_pte)) {
 		kvm_set_pte(pte, __pte(0));
-		kvm_tlb_flush_vmid_ipa(kvm, addr);
+		kvm_tlb_flush_vmid_ipa(mmu, addr);
 	} else {
 		get_page(virt_to_page(pte));
 	}
@@ -1028,7 +1040,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 		if (ret)
 			goto out;
 		spin_lock(&kvm->mmu_lock);
-		ret = stage2_set_pte(kvm, &cache, addr, &pte,
+		ret = stage2_set_pte(&kvm->arch.mmu, &cache, addr, &pte,
 						KVM_S2PTE_FLAG_IS_IOMAP);
 		spin_unlock(&kvm->mmu_lock);
 		if (ret)
@@ -1166,12 +1178,13 @@ static void  stage2_wp_puds(pgd_t *pgd, phys_addr_t addr, phys_addr_t end)
  * @addr:	Start address of range
  * @end:	End address of range
  */
-static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
+static void stage2_wp_range(struct kvm *kvm, struct kvm_s2_mmu *mmu,
+			    phys_addr_t addr, phys_addr_t end)
 {
 	pgd_t *pgd;
 	phys_addr_t next;
 
-	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
+	pgd = mmu->pgd + stage2_pgd_index(addr);
 	do {
 		/*
 		 * Release kvm_mmu_lock periodically if the memory region is
@@ -1183,7 +1196,7 @@ static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 		 * the lock.
 		 */
 		cond_resched_lock(&kvm->mmu_lock);
-		if (!READ_ONCE(kvm->arch.pgd))
+		if (!READ_ONCE(mmu->pgd))
 			break;
 		next = stage2_pgd_addr_end(addr, end);
 		if (stage2_pgd_present(*pgd))
@@ -1212,7 +1225,7 @@ void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	phys_addr_t end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
 
 	spin_lock(&kvm->mmu_lock);
-	stage2_wp_range(kvm, start, end);
+	stage2_wp_range(kvm, &kvm->arch.mmu, start, end);
 	spin_unlock(&kvm->mmu_lock);
 	kvm_flush_remote_tlbs(kvm);
 }
@@ -1236,7 +1249,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
 	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
 
-	stage2_wp_range(kvm, start, end);
+	stage2_wp_range(kvm, &kvm->arch.mmu, start, end);
 }
 
 /*
@@ -1292,6 +1305,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	pgprot_t mem_type = PAGE_S2;
 	bool logging_active = memslot_is_logging(memslot);
 	unsigned long flags = 0;
+	struct kvm_s2_mmu *mmu = vcpu->arch.hw_mmu;
 
 	write_fault = kvm_is_write_fault(vcpu);
 	if (fault_status == FSC_PERM && !write_fault) {
@@ -1388,7 +1402,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			kvm_set_pfn_dirty(pfn);
 		}
 		coherent_cache_guest_page(vcpu, pfn, PMD_SIZE);
-		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
+		ret = stage2_set_pmd_huge(mmu, memcache, fault_ipa, &new_pmd);
 	} else {
 		pte_t new_pte = pfn_pte(pfn, mem_type);
 
@@ -1398,7 +1412,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			mark_page_dirty(kvm, gfn);
 		}
 		coherent_cache_guest_page(vcpu, pfn, PAGE_SIZE);
-		ret = stage2_set_pte(kvm, memcache, fault_ipa, &new_pte, flags);
+		ret = stage2_set_pte(mmu, memcache, fault_ipa, &new_pte, flags);
 	}
 
 out_unlock:
@@ -1426,7 +1440,7 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 
-	pmd = stage2_get_pmd(vcpu->kvm, NULL, fault_ipa);
+	pmd = stage2_get_pmd(vcpu->arch.hw_mmu, NULL, fault_ipa);
 	if (!pmd || pmd_none(*pmd))	/* Nothing there */
 		goto out;
 
@@ -1594,7 +1608,7 @@ int kvm_unmap_hva(struct kvm *kvm, unsigned long hva)
 {
 	unsigned long end = hva + PAGE_SIZE;
 
-	if (!kvm->arch.pgd)
+	if (!kvm->arch.mmu.pgd)
 		return 0;
 
 	trace_kvm_unmap_hva(hva);
@@ -1605,7 +1619,7 @@ int kvm_unmap_hva(struct kvm *kvm, unsigned long hva)
 int kvm_unmap_hva_range(struct kvm *kvm,
 			unsigned long start, unsigned long end)
 {
-	if (!kvm->arch.pgd)
+	if (!kvm->arch.mmu.pgd)
 		return 0;
 
 	trace_kvm_unmap_hva_range(start, end);
@@ -1625,7 +1639,7 @@ static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data
 	 * therefore stage2_set_pte() never needs to clear out a huge PMD
 	 * through this calling path.
 	 */
-	stage2_set_pte(kvm, NULL, gpa, pte, 0);
+	stage2_set_pte(&kvm->arch.mmu, NULL, gpa, pte, 0);
 	return 0;
 }
 
@@ -1635,7 +1649,7 @@ void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 	unsigned long end = hva + PAGE_SIZE;
 	pte_t stage2_pte;
 
-	if (!kvm->arch.pgd)
+	if (!kvm->arch.mmu.pgd)
 		return;
 
 	trace_kvm_set_spte_hva(hva);
@@ -1649,7 +1663,7 @@ static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 	pte_t *pte;
 
 	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE);
-	pmd = stage2_get_pmd(kvm, NULL, gpa);
+	pmd = stage2_get_pmd(&kvm->arch.mmu, NULL, gpa);
 	if (!pmd || pmd_none(*pmd))	/* Nothing there */
 		return 0;
 
@@ -1669,7 +1683,7 @@ static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *
 	pte_t *pte;
 
 	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE);
-	pmd = stage2_get_pmd(kvm, NULL, gpa);
+	pmd = stage2_get_pmd(&kvm->arch.mmu, NULL, gpa);
 	if (!pmd || pmd_none(*pmd))	/* Nothing there */
 		return 0;
 
@@ -1898,9 +1912,10 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 	spin_lock(&kvm->mmu_lock);
 	if (ret)
-		unmap_stage2_range(kvm, mem->guest_phys_addr, mem->memory_size);
+		unmap_stage2_range(kvm, mem->guest_phys_addr,
+				   mem->memory_size);
 	else
-		stage2_flush_memslot(kvm, memslot);
+		stage2_flush_memslot(&kvm->arch.mmu, memslot);
 	spin_unlock(&kvm->mmu_lock);
 out:
 	up_read(&current->mm->mmap_sem);
-- 
1.9.1
