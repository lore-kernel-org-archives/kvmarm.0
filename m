From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH] KVM: ARM: updtae the VMID generation logic
Date: Thu, 29 Mar 2018 23:00:24 +0800
Message-ID: <1522335624-24332-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C58E642121
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Mar 2018 10:54:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y8-4k4gblL14 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Mar 2018 10:53:55 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 963A149F8C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Mar 2018 10:53:54 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: cdall@kernel.org, marc.zyngier@arm.com, eric.auger@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: zhaoshenglong <zhaoshenglong@huawei.com>

Currently the VMID for some VM is allocated during VCPU entry/exit
context and will be updated when kvm_next_vmid inversion. So this will
cause the existing VMs exiting from guest and flush the tlb and icache.

Also, while a platform with 8 bit VMID supports 255 VMs, it can create
more than 255 VMs and if we create e.g. 256 VMs, some VMs will occur
page fault since at some moment two VMs have same VMID.

This patch uses the bitmap to record which VMID used and available.
Initialize the VMID and vttbr during creating the VM instead of VCPU
entry/exit context. Also it will return error to user space if it wants
to create VMs more than the supporting number.

Signed-off-by: zhaoshenglong <zhaoshenglong@huawei.com>
---
 arch/arm/include/asm/kvm_asm.h    |   1 -
 arch/arm/include/asm/kvm_host.h   |   1 -
 arch/arm/kvm/hyp/tlb.c            |   7 --
 arch/arm64/include/asm/kvm_asm.h  |   1 -
 arch/arm64/include/asm/kvm_host.h |   1 -
 arch/arm64/kvm/hyp/tlb.c          |   8 --
 virt/kvm/arm/arm.c                | 150 ++++++++++++++------------------------
 7 files changed, 54 insertions(+), 115 deletions(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 36dd296..a0b7fa6 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -63,7 +63,6 @@ extern char __kvm_hyp_init_end[];
 
 extern char __kvm_hyp_vector[];
 
-extern void __kvm_flush_vm_context(void);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
 extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 248b930..4e340e2 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -214,7 +214,6 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
 int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 unsigned long kvm_call_hyp(void *hypfn, ...);
-void force_vm_exit(const cpumask_t *mask);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
diff --git a/arch/arm/kvm/hyp/tlb.c b/arch/arm/kvm/hyp/tlb.c
index c0edd45..28dca58 100644
--- a/arch/arm/kvm/hyp/tlb.c
+++ b/arch/arm/kvm/hyp/tlb.c
@@ -70,10 +70,3 @@ void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
 
 	write_sysreg(0, VTTBR);
 }
-
-void __hyp_text __kvm_flush_vm_context(void)
-{
-	write_sysreg(0, TLBIALLNSNHIS);
-	write_sysreg(0, ICIALLUIS);
-	dsb(ish);
-}
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 24961b7..53cc97b 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -50,7 +50,6 @@ extern char __kvm_hyp_init_end[];
 
 extern char __kvm_hyp_vector[];
 
-extern void __kvm_flush_vm_context(void);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
 extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 596f8e4..2adbdbd 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -345,7 +345,6 @@ void kvm_arm_resume_guest(struct kvm *kvm);
 u64 __kvm_call_hyp(void *hypfn, ...);
 #define kvm_call_hyp(f, ...) __kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__)
 
-void force_vm_exit(const cpumask_t *mask);
 void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
 
 int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index 131c777..41ac624 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -148,11 +148,3 @@ void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
 
 	__tlb_switch_to_host()(kvm);
 }
-
-void __hyp_text __kvm_flush_vm_context(void)
-{
-	dsb(ishst);
-	__tlbi(alle1is);
-	asm volatile("ic ialluis" : : );
-	dsb(ish);
-}
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 5357230..fa8cbd7 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -60,8 +60,8 @@ static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_arm_running_vcpu);
 
 /* The VMID used in the VTTBR */
-static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
-static u32 kvm_next_vmid;
+static void *kvm_vmid_bitmap;
+static unsigned int kvm_vmid_bitmap_bits;
 static unsigned int kvm_vmid_bits __read_mostly;
 static DEFINE_SPINLOCK(kvm_vmid_lock);
 
@@ -108,6 +108,40 @@ void kvm_arch_check_processor_compat(void *rtn)
 	*(int *)rtn = 0;
 }
 
+static int kvm_arm_init_vmid(struct kvm *kvm)
+{
+	phys_addr_t pgd_phys;
+	u64 vmid;
+
+	spin_lock(&kvm_vmid_lock);
+
+	vmid = find_first_zero_bit(kvm_vmid_bitmap, kvm_vmid_bitmap_bits);
+	if (vmid == kvm_vmid_bitmap_bits) {
+		kvm_err("No available VMID to create VM\n");
+		spin_unlock(&kvm_vmid_lock);
+		return -EINVAL;
+	}
+
+	kvm->arch.vmid = vmid;
+	set_bit(kvm->arch.vmid, kvm_vmid_bitmap);
+	pgd_phys = virt_to_phys(kvm->arch.pgd);
+	BUG_ON(pgd_phys & ~VTTBR_BADDR_MASK);
+	vmid = ((u64)(kvm->arch.vmid) << VTTBR_VMID_SHIFT) &
+	       VTTBR_VMID_MASK(kvm_vmid_bits);
+	kvm->arch.vttbr = kvm_phys_to_vttbr(pgd_phys) | vmid;
+
+	spin_unlock(&kvm_vmid_lock);
+	return 0;
+}
+
+static void kvm_arm_destroy_vmid(struct kvm *kvm)
+{
+	if (kvm->arch.vmid) {
+		spin_lock(&kvm_vmid_lock);
+		clear_bit(kvm->arch.vmid, kvm_vmid_bitmap);
+		spin_unlock(&kvm_vmid_lock);
+	}
+}
 
 /**
  * kvm_arch_init_vm - initializes a VM data structure
@@ -140,6 +174,11 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	/* Mark the initial VMID generation invalid */
 	kvm->arch.vmid_gen = 0;
 
+	/* Initial VMID */
+	ret = kvm_arm_init_vmid(kvm);
+	if (ret)
+		goto out_free_stage2_pgd;
+
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->arch.max_vcpus = vgic_present ?
 				kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
@@ -189,6 +228,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		}
 	}
 	atomic_set(&kvm->online_vcpus, 0);
+	kvm_arm_destroy_vmid(kvm);
 }
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
@@ -429,96 +469,6 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 	return vcpu_mode_priv(vcpu);
 }
 
-/* Just ensure a guest exit from a particular CPU */
-static void exit_vm_noop(void *info)
-{
-}
-
-void force_vm_exit(const cpumask_t *mask)
-{
-	preempt_disable();
-	smp_call_function_many(mask, exit_vm_noop, NULL, true);
-	preempt_enable();
-}
-
-/**
- * need_new_vmid_gen - check that the VMID is still valid
- * @kvm: The VM's VMID to check
- *
- * return true if there is a new generation of VMIDs being used
- *
- * The hardware supports only 256 values with the value zero reserved for the
- * host, so we check if an assigned value belongs to a previous generation,
- * which which requires us to assign a new value. If we're the first to use a
- * VMID for the new generation, we must flush necessary caches and TLBs on all
- * CPUs.
- */
-static bool need_new_vmid_gen(struct kvm *kvm)
-{
-	return unlikely(kvm->arch.vmid_gen != atomic64_read(&kvm_vmid_gen));
-}
-
-/**
- * update_vttbr - Update the VTTBR with a valid VMID before the guest runs
- * @kvm	The guest that we are about to run
- *
- * Called from kvm_arch_vcpu_ioctl_run before entering the guest to ensure the
- * VM has a valid VMID, otherwise assigns a new one and flushes corresponding
- * caches and TLBs.
- */
-static void update_vttbr(struct kvm *kvm)
-{
-	phys_addr_t pgd_phys;
-	u64 vmid;
-
-	if (!need_new_vmid_gen(kvm))
-		return;
-
-	spin_lock(&kvm_vmid_lock);
-
-	/*
-	 * We need to re-check the vmid_gen here to ensure that if another vcpu
-	 * already allocated a valid vmid for this vm, then this vcpu should
-	 * use the same vmid.
-	 */
-	if (!need_new_vmid_gen(kvm)) {
-		spin_unlock(&kvm_vmid_lock);
-		return;
-	}
-
-	/* First user of a new VMID generation? */
-	if (unlikely(kvm_next_vmid == 0)) {
-		atomic64_inc(&kvm_vmid_gen);
-		kvm_next_vmid = 1;
-
-		/*
-		 * On SMP we know no other CPUs can use this CPU's or each
-		 * other's VMID after force_vm_exit returns since the
-		 * kvm_vmid_lock blocks them from reentry to the guest.
-		 */
-		force_vm_exit(cpu_all_mask);
-		/*
-		 * Now broadcast TLB + ICACHE invalidation over the inner
-		 * shareable domain to make sure all data structures are
-		 * clean.
-		 */
-		kvm_call_hyp(__kvm_flush_vm_context);
-	}
-
-	kvm->arch.vmid_gen = atomic64_read(&kvm_vmid_gen);
-	kvm->arch.vmid = kvm_next_vmid;
-	kvm_next_vmid++;
-	kvm_next_vmid &= (1 << kvm_vmid_bits) - 1;
-
-	/* update vttbr to be used with the new vmid */
-	pgd_phys = virt_to_phys(kvm->arch.pgd);
-	BUG_ON(pgd_phys & ~VTTBR_BADDR_MASK);
-	vmid = ((u64)(kvm->arch.vmid) << VTTBR_VMID_SHIFT) & VTTBR_VMID_MASK(kvm_vmid_bits);
-	kvm->arch.vttbr = kvm_phys_to_vttbr(pgd_phys) | vmid;
-
-	spin_unlock(&kvm_vmid_lock);
-}
-
 static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -664,8 +614,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 */
 		cond_resched();
 
-		update_vttbr(vcpu->kvm);
-
 		check_vcpu_requests(vcpu);
 
 		/*
@@ -716,8 +664,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 */
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
-		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
-		    kvm_request_pending(vcpu)) {
+		if (ret <= 0 || kvm_request_pending(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			kvm_pmu_sync_hwstate(vcpu);
 			if (static_branch_unlikely(&userspace_irqchip_in_use))
@@ -1338,6 +1285,15 @@ static int init_common_resources(void)
 	/* set size of VMID supported by CPU */
 	kvm_vmid_bits = kvm_get_vmid_bits();
 	kvm_info("%d-bit VMID\n", kvm_vmid_bits);
+	kvm_vmid_bitmap_bits = 1 << kvm_vmid_bits;
+	kvm_vmid_bitmap = kzalloc((kvm_vmid_bitmap_bits + 7) / 8, GFP_KERNEL);
+	if (kvm_vmid_bitmap == NULL) {
+		kvm_err("Cannot allocate memory for VMID bitmap\n");
+		return -ENOMEM;
+	}
+
+	/* The VMID 0 is reserved for Host.  */
+	set_bit(0, kvm_vmid_bitmap);
 
 	return 0;
 }
@@ -1606,6 +1562,8 @@ int kvm_arch_init(void *opaque)
 /* NOP: Compiling as a module not supported */
 void kvm_arch_exit(void)
 {
+	kfree(kvm_vmid_bitmap);
+	kvm_vmid_bitmap = NULL;
 	kvm_perf_teardown();
 }
 
-- 
2.0.4
