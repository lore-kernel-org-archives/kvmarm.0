From: Julien Grall <julien.grall@arm.com>
Subject: [PATCH RFC 14/14] kvm/arm: Align the VMID allocation with the arm64
 ASID one
Date: Thu, 21 Mar 2019 16:36:23 +0000
Message-ID: <20190321163623.20219-15-julien.grall@arm.com>
References: <20190321163623.20219-1-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A40C34A36C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Mar 2019 12:37:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v3egkt1s4U6c for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Mar 2019 12:37:12 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0DDA4A460
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Mar 2019 12:37:11 -0400 (EDT)
In-Reply-To: <20190321163623.20219-1-julien.grall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, Julien Grall <julien.grall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

At the moment, the VMID algorithm will send an SGI to all the CPUs to
force an exit and then broadcast a full TLB flush and I-Cache
invalidation.

This patch re-use the new ASID allocator. The
benefits are:
    - CPUs are not forced to exit at roll-over. Instead the VMID will be
    marked reserved and the context will be flushed at next exit. This
    will reduce the IPIs traffic.
    - Context invalidation is now per-CPU rather than broadcasted.

With the new algo, the code is now adapted:
    - The function __kvm_flush_vm_context() has been renamed to
    __kvm_flush_cpu_vmid_context and now only flushing the current CPU context.
    - The call to update_vttbr() will be done with preemption disabled
    as the new algo requires to store information per-CPU.
    - The TLBs associated to EL1 will be flushed when booting a CPU to
    deal with stale information. This was previously done on the
    allocation of the first VMID of a new generation.

The measurement was made on a Seattle based SoC (8 CPUs), with the
number of VMID limited to 4-bit. The test involves running concurrently 40
guests with 2 vCPUs. Each guest will then execute hackbench 5 times
before exiting.

The performance difference between the current algo and the new one are:
    - 2.5% less exit from the guest
    - 22.4% more flush, although they are now local rather than
    broadcasted
    - 0.11% faster (just for the record)

Signed-off-by: Julien Grall <julien.grall@arm.com>

----
    Looking at the __kvm_flush_vm_context, it might be possible to
    reduce more the overhead by removing the I-Cache flush for other
    cache than VIPT. This has been left aside for now.
---
 arch/arm/include/asm/kvm_asm.h    |   2 +-
 arch/arm/include/asm/kvm_host.h   |   5 +-
 arch/arm/include/asm/kvm_hyp.h    |   1 +
 arch/arm/kvm/hyp/tlb.c            |   8 +--
 arch/arm64/include/asm/kvm_asid.h |   8 +++
 arch/arm64/include/asm/kvm_asm.h  |   2 +-
 arch/arm64/include/asm/kvm_host.h |   5 +-
 arch/arm64/kvm/hyp/tlb.c          |  10 ++--
 virt/kvm/arm/arm.c                | 112 +++++++++++++-------------------------
 9 files changed, 61 insertions(+), 92 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_asid.h

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 35491af87985..ce60a4a46fcc 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -65,7 +65,7 @@ struct kvm_vcpu;
 extern char __kvm_hyp_init[];
 extern char __kvm_hyp_init_end[];
 
-extern void __kvm_flush_vm_context(void);
+extern void __kvm_flush_cpu_vmid_context(void);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
 extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 770d73257ad9..e2c3a4a7b020 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -59,8 +59,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 void kvm_reset_coprocs(struct kvm_vcpu *vcpu);
 
 struct kvm_vmid {
-	/* The VMID generation used for the virt. memory system */
-	u64    vmid_gen;
+	/* The ASID used for the ASID allocator */
+	atomic64_t asid;
 	u32    vmid;
 };
 
@@ -264,7 +264,6 @@ unsigned long __kvm_call_hyp(void *hypfn, ...);
 		ret;							\
 	})
 
-void force_vm_exit(const cpumask_t *mask);
 int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
 			      struct kvm_vcpu_events *events);
 
diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
index 87bcd18df8d5..c3d1011ca1bf 100644
--- a/arch/arm/include/asm/kvm_hyp.h
+++ b/arch/arm/include/asm/kvm_hyp.h
@@ -75,6 +75,7 @@
 #define TLBIALLIS	__ACCESS_CP15(c8, 0, c3, 0)
 #define TLBIALL		__ACCESS_CP15(c8, 0, c7, 0)
 #define TLBIALLNSNHIS	__ACCESS_CP15(c8, 4, c3, 4)
+#define TLBIALLNSNH	__ACCESS_CP15(c8, 4, c7, 4)
 #define PRRR		__ACCESS_CP15(c10, 0, c2, 0)
 #define NMRR		__ACCESS_CP15(c10, 0, c2, 1)
 #define AMAIR0		__ACCESS_CP15(c10, 0, c3, 0)
diff --git a/arch/arm/kvm/hyp/tlb.c b/arch/arm/kvm/hyp/tlb.c
index 8e4afba73635..42b9ab47fc94 100644
--- a/arch/arm/kvm/hyp/tlb.c
+++ b/arch/arm/kvm/hyp/tlb.c
@@ -71,9 +71,9 @@ void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
 	write_sysreg(0, VTTBR);
 }
 
-void __hyp_text __kvm_flush_vm_context(void)
+void __hyp_text __kvm_flush_cpu_vmid_context(void)
 {
-	write_sysreg(0, TLBIALLNSNHIS);
-	write_sysreg(0, ICIALLUIS);
-	dsb(ish);
+	write_sysreg(0, TLBIALLNSNH);
+	write_sysreg(0, ICIALLU);
+	dsb(nsh);
 }
diff --git a/arch/arm64/include/asm/kvm_asid.h b/arch/arm64/include/asm/kvm_asid.h
new file mode 100644
index 000000000000..8b586e43c094
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_asid.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ARM64_KVM_ASID_H__
+#define __ARM64_KVM_ASID_H__
+
+#include <asm/asid.h>
+
+#endif /* __ARM64_KVM_ASID_H__ */
+
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index f5b79e995f40..8d7d01ee1d03 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -62,7 +62,7 @@ extern char __kvm_hyp_init_end[];
 
 extern char __kvm_hyp_vector[];
 
-extern void __kvm_flush_vm_context(void);
+extern void __kvm_flush_cpu_vmid_context(void);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
 extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a01fe087e022..c64c9ac031df 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -60,8 +60,8 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext);
 void __extended_idmap_trampoline(phys_addr_t boot_pgd, phys_addr_t idmap_start);
 
 struct kvm_vmid {
-	/* The VMID generation used for the virt. memory system */
-	u64    vmid_gen;
+	/* The ASID used for the ASID allocator */
+	atomic64_t asid;
 	u32    vmid;
 };
 
@@ -417,7 +417,6 @@ u64 __kvm_call_hyp(void *hypfn, ...);
 		ret;							\
 	})
 
-void force_vm_exit(const cpumask_t *mask);
 void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
 
 int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index 76c30866069e..e80e922988c1 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -200,10 +200,10 @@ void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
 	__tlb_switch_to_host()(kvm, &cxt);
 }
 
-void __hyp_text __kvm_flush_vm_context(void)
+void __hyp_text __kvm_flush_cpu_vmid_context(void)
 {
-	dsb(ishst);
-	__tlbi(alle1is);
-	asm volatile("ic ialluis" : : );
-	dsb(ish);
+	dsb(nshst);
+	__tlbi(alle1);
+	asm volatile("ic iallu" : : );
+	dsb(nsh);
 }
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 99c37384ba7b..03f95fffd672 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -46,6 +46,7 @@
 #include <asm/cpufeature.h>
 #include <asm/virt.h>
 #include <asm/kvm_arm.h>
+#include <asm/kvm_asid.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_emulate.h>
@@ -62,10 +63,10 @@ static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 /* Per-CPU variable containing the currently running vcpu. */
 static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_arm_running_vcpu);
 
-/* The VMID used in the VTTBR */
-static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
-static u32 kvm_next_vmid;
-static DEFINE_SPINLOCK(kvm_vmid_lock);
+static DEFINE_PER_CPU(atomic64_t, active_vmids);
+static DEFINE_PER_CPU(u64, reserved_vmids);
+
+struct asid_info vmid_info;
 
 static bool vgic_present;
 
@@ -140,9 +141,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm_vgic_early_init(kvm);
 
-	/* Mark the initial VMID generation invalid */
-	kvm->arch.vmid.vmid_gen = 0;
-
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->arch.max_vcpus = vgic_present ?
 				kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
@@ -455,35 +453,17 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 	return vcpu_mode_priv(vcpu);
 }
 
-/* Just ensure a guest exit from a particular CPU */
-static void exit_vm_noop(void *info)
+static void vmid_flush_cpu_ctxt(void)
 {
+	kvm_call_hyp(__kvm_flush_cpu_vmid_context);
 }
 
-void force_vm_exit(const cpumask_t *mask)
+static void vmid_update_ctxt(void *ctxt)
 {
-	preempt_disable();
-	smp_call_function_many(mask, exit_vm_noop, NULL, true);
-	preempt_enable();
-}
+	struct kvm_vmid *vmid = ctxt;
+	u64 asid = atomic64_read(&vmid->asid);
 
-/**
- * need_new_vmid_gen - check that the VMID is still valid
- * @vmid: The VMID to check
- *
- * return true if there is a new generation of VMIDs being used
- *
- * The hardware supports a limited set of values with the value zero reserved
- * for the host, so we check if an assigned value belongs to a previous
- * generation, which which requires us to assign a new value. If we're the
- * first to use a VMID for the new generation, we must flush necessary caches
- * and TLBs on all CPUs.
- */
-static bool need_new_vmid_gen(struct kvm_vmid *vmid)
-{
-	u64 current_vmid_gen = atomic64_read(&kvm_vmid_gen);
-	smp_rmb(); /* Orders read of kvm_vmid_gen and kvm->arch.vmid */
-	return unlikely(READ_ONCE(vmid->vmid_gen) != current_vmid_gen);
+	vmid->vmid = asid & ((1ULL << kvm_get_vmid_bits()) - 1);
 }
 
 /**
@@ -493,48 +473,11 @@ static bool need_new_vmid_gen(struct kvm_vmid *vmid)
  */
 static void update_vmid(struct kvm_vmid *vmid)
 {
-	if (!need_new_vmid_gen(vmid))
-		return;
-
-	spin_lock(&kvm_vmid_lock);
-
-	/*
-	 * We need to re-check the vmid_gen here to ensure that if another vcpu
-	 * already allocated a valid vmid for this vm, then this vcpu should
-	 * use the same vmid.
-	 */
-	if (!need_new_vmid_gen(vmid)) {
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
+	int cpu = get_cpu();
 
-	vmid->vmid = kvm_next_vmid;
-	kvm_next_vmid++;
-	kvm_next_vmid &= (1 << kvm_get_vmid_bits()) - 1;
+	asid_check_context(&vmid_info, &vmid->asid, cpu, vmid);
 
-	smp_wmb();
-	WRITE_ONCE(vmid->vmid_gen, atomic64_read(&kvm_vmid_gen));
-
-	spin_unlock(&kvm_vmid_lock);
+	put_cpu();
 }
 
 static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
@@ -685,8 +628,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 */
 		cond_resched();
 
-		update_vmid(&vcpu->kvm->arch.vmid);
-
 		check_vcpu_requests(vcpu);
 
 		/*
@@ -696,6 +637,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 */
 		preempt_disable();
 
+		/*
+		 * The ASID/VMID allocator only tracks active VMIDs per
+		 * physical CPU, and therefore the VMID allocated may not be
+		 * preserved on VMID roll-over if the task was preempted,
+		 * making a thread's VMID inactive. So we need to call
+		 * update_vttbr in non-premptible context.
+		 */
+		update_vmid(&vcpu->kvm->arch.vmid);
+
 		kvm_pmu_flush_hwstate(vcpu);
 
 		local_irq_disable();
@@ -734,8 +684,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 */
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
-		if (ret <= 0 || need_new_vmid_gen(&vcpu->kvm->arch.vmid) ||
-		    kvm_request_pending(vcpu)) {
+		if (ret <= 0 || kvm_request_pending(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			isb(); /* Ensure work in x_flush_hwstate is committed */
 			kvm_pmu_sync_hwstate(vcpu);
@@ -1305,6 +1254,8 @@ static void cpu_init_hyp_mode(void *dummy)
 
 	__cpu_init_hyp_mode(pgd_ptr, hyp_stack_ptr, vector_ptr);
 	__cpu_init_stage2();
+
+	kvm_call_hyp(__kvm_flush_cpu_vmid_context);
 }
 
 static void cpu_hyp_reset(void)
@@ -1412,6 +1363,17 @@ static inline void hyp_cpu_pm_exit(void)
 
 static int init_common_resources(void)
 {
+	/*
+	 * Initialize the ASID allocator telling it to allocate a single
+	 * VMID per VM.
+	 */
+	if (asid_allocator_init(&vmid_info, kvm_get_vmid_bits(), 1,
+				vmid_flush_cpu_ctxt, vmid_update_ctxt))
+		panic("Failed to initialize VMID allocator\n");
+
+	vmid_info.active = &active_vmids;
+	vmid_info.reserved = &reserved_vmids;
+
 	kvm_set_ipa_limit();
 
 	return 0;
-- 
2.11.0
