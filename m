From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 06/14] KVM: arm/arm64: Factor out VMID into struct kvm_vmid
Date: Thu, 24 Jan 2019 15:00:24 +0100
Message-ID: <20190124140032.8588-7-christoffer.dall@arm.com>
References: <20190124140032.8588-1-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E52E4A40F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 09:00:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V9KUX5P3P7TL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jan 2019 09:00:51 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73DBA4A3A7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 09:00:51 -0500 (EST)
In-Reply-To: <20190124140032.8588-1-christoffer.dall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

In preparation for nested virtualization where we are going to have more
than a single VMID per VM, let's factor out the VMID data into a
separate VMID data structure and change the VMID allocator to operate on
this new structure instead of using a struct kvm.

This also means that udate_vttbr now becomes update_vmid, and that the
vttbr itself is generated on the fly based on the stage 2 page table
base address and the vmid.

We cache the physical address of the pgd when allocating the pgd to
avoid doing the calculation on every entry to the guest and to avoid
calling into potentially non-hyp-mapped code from hyp/EL2.

If we wanted to merge the VMID allocator with the arm64 ASID allocator
at some point in the future, it should actually become easier to do that
after this patch.

Note that to avoid mapping the kvm_vmid_bits variable into hyp, we
simply forego the masking of the vmid value in kvm_get_vttbr and rely on
update_vmid to always assign a valid vmid value (within the supported
range).

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_host.h   | 13 ++++---
 arch/arm/include/asm/kvm_mmu.h    | 11 ++++++
 arch/arm/kvm/hyp/switch.c         |  2 +-
 arch/arm/kvm/hyp/tlb.c            |  4 +--
 arch/arm64/include/asm/kvm_host.h |  9 +++--
 arch/arm64/include/asm/kvm_hyp.h  |  3 +-
 arch/arm64/include/asm/kvm_mmu.h  | 11 ++++++
 virt/kvm/arm/arm.c                | 57 +++++++++++--------------------
 virt/kvm/arm/mmu.c                |  2 ++
 9 files changed, 63 insertions(+), 49 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 43e343e00fb8..8073267dc4a0 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -57,10 +57,13 @@ int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 void kvm_reset_coprocs(struct kvm_vcpu *vcpu);
 
-struct kvm_arch {
-	/* VTTBR value associated with below pgd and vmid */
-	u64    vttbr;
+struct kvm_vmid {
+	/* The VMID generation used for the virt. memory system */
+	u64    vmid_gen;
+	u32    vmid;
+};
 
+struct kvm_arch {
 	/* The last vcpu id that ran on each physical CPU */
 	int __percpu *last_vcpu_ran;
 
@@ -70,11 +73,11 @@ struct kvm_arch {
 	 */
 
 	/* The VMID generation used for the virt. memory system */
-	u64    vmid_gen;
-	u32    vmid;
+	struct kvm_vmid vmid;
 
 	/* Stage-2 page table */
 	pgd_t *pgd;
+	phys_addr_t pgd_phys;
 
 	/* Interrupt controller */
 	struct vgic_dist	vgic;
diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 3a875fc1b63c..fadbd9ad3a90 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -426,6 +426,17 @@ static inline bool kvm_cpu_has_cnp(void)
 	return false;
 }
 
+static __always_inline u64 kvm_get_vttbr(struct kvm *kvm)
+{
+	struct kvm_vmid *vmid = &kvm->arch.vmid;
+	u64 vmid_field, baddr;
+	u64 cnp = kvm_cpu_has_cnp() ? VTTBR_CNP_BIT : 0;
+
+	baddr = kvm->arch.pgd_phys;
+	vmid_field = (u64)vmid->vmid << VTTBR_VMID_SHIFT;
+	return kvm_phys_to_vttbr(baddr) | vmid_field | cnp;
+}
+
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* __ARM_KVM_MMU_H__ */
diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index acf1c37fa49c..3b058a5d7c5f 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -77,7 +77,7 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 static void __hyp_text __activate_vm(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
-	write_sysreg(kvm->arch.vttbr, VTTBR);
+	write_sysreg(kvm_get_vttbr(kvm), VTTBR);
 	write_sysreg(vcpu->arch.midr, VPIDR);
 }
 
diff --git a/arch/arm/kvm/hyp/tlb.c b/arch/arm/kvm/hyp/tlb.c
index c0edd450e104..8e4afba73635 100644
--- a/arch/arm/kvm/hyp/tlb.c
+++ b/arch/arm/kvm/hyp/tlb.c
@@ -41,7 +41,7 @@ void __hyp_text __kvm_tlb_flush_vmid(struct kvm *kvm)
 
 	/* Switch to requested VMID */
 	kvm = kern_hyp_va(kvm);
-	write_sysreg(kvm->arch.vttbr, VTTBR);
+	write_sysreg(kvm_get_vttbr(kvm), VTTBR);
 	isb();
 
 	write_sysreg(0, TLBIALLIS);
@@ -61,7 +61,7 @@ void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
 	struct kvm *kvm = kern_hyp_va(kern_hyp_va(vcpu)->kvm);
 
 	/* Switch to requested VMID */
-	write_sysreg(kvm->arch.vttbr, VTTBR);
+	write_sysreg(kvm_get_vttbr(kvm), VTTBR);
 	isb();
 
 	write_sysreg(0, TLBIALL);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f497bb31031f..444dd1cb1958 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -57,16 +57,19 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext);
 void __extended_idmap_trampoline(phys_addr_t boot_pgd, phys_addr_t idmap_start);
 
-struct kvm_arch {
+struct kvm_vmid {
 	/* The VMID generation used for the virt. memory system */
 	u64    vmid_gen;
 	u32    vmid;
+};
+
+struct kvm_arch {
+	struct kvm_vmid vmid;
 
 	/* stage2 entry level table */
 	pgd_t *pgd;
+	phys_addr_t pgd_phys;
 
-	/* VTTBR value associated with above pgd and vmid */
-	u64    vttbr;
 	/* VTCR_EL2 value for this VM */
 	u64    vtcr;
 
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index a80a7ef57325..4da765f2cca5 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -21,6 +21,7 @@
 #include <linux/compiler.h>
 #include <linux/kvm_host.h>
 #include <asm/alternative.h>
+#include <asm/kvm_mmu.h>
 #include <asm/sysreg.h>
 
 #define __hyp_text __section(.hyp.text) notrace
@@ -163,7 +164,7 @@ void __noreturn __hyp_do_panic(unsigned long, ...);
 static __always_inline void __hyp_text __load_guest_stage2(struct kvm *kvm)
 {
 	write_sysreg(kvm->arch.vtcr, vtcr_el2);
-	write_sysreg(kvm->arch.vttbr, vttbr_el2);
+	write_sysreg(kvm_get_vttbr(kvm), vttbr_el2);
 
 	/*
 	 * ARM erratum 1165522 requires the actual execution of the above
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 8af4b1befa42..189d93461d33 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -596,5 +596,16 @@ static inline bool kvm_cpu_has_cnp(void)
 	return system_supports_cnp();
 }
 
+static __always_inline u64 kvm_get_vttbr(struct kvm *kvm)
+{
+	struct kvm_vmid *vmid = &kvm->arch.vmid;
+	u64 vmid_field, baddr;
+	u64 cnp = kvm_cpu_has_cnp() ? VTTBR_CNP_BIT : 0;
+
+	baddr = kvm->arch.pgd_phys;
+	vmid_field = (u64)vmid->vmid << VTTBR_VMID_SHIFT;
+	return kvm_phys_to_vttbr(baddr) | vmid_field | cnp;
+}
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ARM64_KVM_MMU_H__ */
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 3dd240ea9e76..b77db673bb03 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -65,7 +65,6 @@ static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_arm_running_vcpu);
 /* The VMID used in the VTTBR */
 static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
 static u32 kvm_next_vmid;
-static unsigned int kvm_vmid_bits __read_mostly;
 static DEFINE_SPINLOCK(kvm_vmid_lock);
 
 static bool vgic_present;
@@ -142,7 +141,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_vgic_early_init(kvm);
 
 	/* Mark the initial VMID generation invalid */
-	kvm->arch.vmid_gen = 0;
+	kvm->arch.vmid.vmid_gen = 0;
 
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->arch.max_vcpus = vgic_present ?
@@ -472,37 +471,31 @@ void force_vm_exit(const cpumask_t *mask)
 
 /**
  * need_new_vmid_gen - check that the VMID is still valid
- * @kvm: The VM's VMID to check
+ * @vmid: The VMID to check
  *
  * return true if there is a new generation of VMIDs being used
  *
- * The hardware supports only 256 values with the value zero reserved for the
- * host, so we check if an assigned value belongs to a previous generation,
- * which which requires us to assign a new value. If we're the first to use a
- * VMID for the new generation, we must flush necessary caches and TLBs on all
- * CPUs.
+ * The hardware supports a limited set of values with the value zero reserved
+ * for the host, so we check if an assigned value belongs to a previous
+ * generation, which which requires us to assign a new value. If we're the
+ * first to use a VMID for the new generation, we must flush necessary caches
+ * and TLBs on all CPUs.
  */
-static bool need_new_vmid_gen(struct kvm *kvm)
+static bool need_new_vmid_gen(struct kvm_vmid *vmid)
 {
 	u64 current_vmid_gen = atomic64_read(&kvm_vmid_gen);
 	smp_rmb(); /* Orders read of kvm_vmid_gen and kvm->arch.vmid */
-	return unlikely(READ_ONCE(kvm->arch.vmid_gen) != current_vmid_gen);
+	return unlikely(READ_ONCE(vmid->vmid_gen) != current_vmid_gen);
 }
 
 /**
- * update_vttbr - Update the VTTBR with a valid VMID before the guest runs
- * @kvm	The guest that we are about to run
- *
- * Called from kvm_arch_vcpu_ioctl_run before entering the guest to ensure the
- * VM has a valid VMID, otherwise assigns a new one and flushes corresponding
- * caches and TLBs.
+ * update_vmid - Update the vmid with a valid VMID for the current generation
+ * @kvm: The guest that struct vmid belongs to
+ * @vmid: The stage-2 VMID information struct
  */
-static void update_vttbr(struct kvm *kvm)
+static void update_vmid(struct kvm_vmid *vmid)
 {
-	phys_addr_t pgd_phys;
-	u64 vmid, cnp = kvm_cpu_has_cnp() ? VTTBR_CNP_BIT : 0;
-
-	if (!need_new_vmid_gen(kvm))
+	if (!need_new_vmid_gen(vmid))
 		return;
 
 	spin_lock(&kvm_vmid_lock);
@@ -512,7 +505,7 @@ static void update_vttbr(struct kvm *kvm)
 	 * already allocated a valid vmid for this vm, then this vcpu should
 	 * use the same vmid.
 	 */
-	if (!need_new_vmid_gen(kvm)) {
+	if (!need_new_vmid_gen(vmid)) {
 		spin_unlock(&kvm_vmid_lock);
 		return;
 	}
@@ -536,18 +529,12 @@ static void update_vttbr(struct kvm *kvm)
 		kvm_call_hyp(__kvm_flush_vm_context);
 	}
 
-	kvm->arch.vmid = kvm_next_vmid;
+	vmid->vmid = kvm_next_vmid;
 	kvm_next_vmid++;
-	kvm_next_vmid &= (1 << kvm_vmid_bits) - 1;
-
-	/* update vttbr to be used with the new vmid */
-	pgd_phys = virt_to_phys(kvm->arch.pgd);
-	BUG_ON(pgd_phys & ~kvm_vttbr_baddr_mask(kvm));
-	vmid = ((u64)(kvm->arch.vmid) << VTTBR_VMID_SHIFT) & VTTBR_VMID_MASK(kvm_vmid_bits);
-	kvm->arch.vttbr = kvm_phys_to_vttbr(pgd_phys) | vmid | cnp;
+	kvm_next_vmid &= (1 << kvm_get_vmid_bits()) - 1;
 
 	smp_wmb();
-	WRITE_ONCE(kvm->arch.vmid_gen, atomic64_read(&kvm_vmid_gen));
+	WRITE_ONCE(vmid->vmid_gen, atomic64_read(&kvm_vmid_gen));
 
 	spin_unlock(&kvm_vmid_lock);
 }
@@ -690,7 +677,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 */
 		cond_resched();
 
-		update_vttbr(vcpu->kvm);
+		update_vmid(&vcpu->kvm->arch.vmid);
 
 		check_vcpu_requests(vcpu);
 
@@ -739,7 +726,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 */
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
-		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
+		if (ret <= 0 || need_new_vmid_gen(&vcpu->kvm->arch.vmid) ||
 		    kvm_request_pending(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			isb(); /* Ensure work in x_flush_hwstate is committed */
@@ -1417,10 +1404,6 @@ static inline void hyp_cpu_pm_exit(void)
 
 static int init_common_resources(void)
 {
-	/* set size of VMID supported by CPU */
-	kvm_vmid_bits = kvm_get_vmid_bits();
-	kvm_info("%d-bit VMID\n", kvm_vmid_bits);
-
 	kvm_set_ipa_limit();
 
 	return 0;
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index fbdf3ac2f001..bffcbc423f4c 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -921,6 +921,7 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
 		return -ENOMEM;
 
 	kvm->arch.pgd = pgd;
+	kvm->arch.pgd_phys = virt_to_phys(pgd);
 	return 0;
 }
 
@@ -1008,6 +1009,7 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
 		unmap_stage2_range(kvm, 0, kvm_phys_size(kvm));
 		pgd = READ_ONCE(kvm->arch.pgd);
 		kvm->arch.pgd = NULL;
+		kvm->arch.pgd_phys = 0;
 	}
 	spin_unlock(&kvm->mmu_lock);
 
-- 
2.18.0
