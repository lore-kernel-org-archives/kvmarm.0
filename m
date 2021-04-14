Return-Path: <SRS0=hZsu=JL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A20C433B4
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 11:25:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 29960613C3
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 11:25:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 29960613C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC1794B6E8;
	Wed, 14 Apr 2021 07:25:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 92CyabtdGGNa; Wed, 14 Apr 2021 07:25:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 446974B49C;
	Wed, 14 Apr 2021 07:25:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 921964B60D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 07:25:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PVpuPDZllEqc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Apr 2021 07:25:41 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7B71A4B352
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 07:25:41 -0400 (EDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FL0TQ5q4xz18Hbh;
 Wed, 14 Apr 2021 19:23:22 +0800 (CST)
Received: from S00345302A-PC.china.huawei.com (10.47.82.32) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Wed, 14 Apr 2021 19:25:28 +0800
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 16/16] kvm/arm: Align the VMID allocation with the arm64
 ASID one
Date: Wed, 14 Apr 2021 12:23:12 +0100
Message-ID: <20210414112312.13704-17-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20210414112312.13704-1-shameerali.kolothum.thodi@huawei.com>
References: <20210414112312.13704-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.47.82.32]
X-CFilter-Loop: Reflected
Cc: jean-philippe@linaro.org, julien@xen.org, maz@kernel.org,
 linuxarm@huawei.com, catalin.marinas@arm.com, will@kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Julien Grall <julien.grall@arm.com>

At the moment, the VMID algorithm will send an SGI to all the CPUs to
force an exit and then broadcast a full TLB flush and I-Cache
invalidation.

This patch re-use the new ASID allocator. The
benefits are:
    - CPUs are not forced to exit at roll-over. Instead the VMID will be
    marked reserved and the context will be flushed at next exit. This
    will reduce the IPIs traffic.
    - Context invalidation is now per-CPU rather than broadcasted.
    - Catalin has a formal model of the ASID allocator.

With the new algo, the code is now adapted:
    - The function __kvm_flush_vm_context() has been renamed to
    __kvm_tlb_flush_local_all() and now only flushing the current CPU
    context.
    - The call to update_vmid() will be done with preemption disabled
    as the new algo requires to store information per-CPU.
    - The TLBs associated to EL1 will be flushed when booting a CPU to
    deal with stale information. This was previously done on the
    allocation of the first VMID of a new generation.


Signed-off-by: Julien Grall <julien.grall@arm.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
Test Results:

v4:
The measurement was made on a HiSilicon D06 platform with maxcpus set
to 8 and with the number of VMID limited to 4-bit. The test involves
running concurrently 40 guests with 2 vCPUs. Each guest will then
 execute hackbench 5 times before exiting.

The performance difference between the current algo and the new one are
(avg. of 10 runs):
   - 1.9% less entry/exit from guest
   - 0.7% faster

v3:
The measurement was made on a Seattle based SoC (8 CPUs), with the
number of VMID limited to 4-bit. The test involves running concurrently 40
guests with 2 vCPUs. Each guest will then execute hackbench 5 times
before exiting.

The performance difference between the current algo and the new one are:
    - 2.5% less exit from the guest
    - 22.4% more flush, although they are now local rather than
    broadcasted
    - 0.11% faster (just for the record)

---
 arch/arm64/include/asm/kvm_asm.h   |   4 +-
 arch/arm64/include/asm/kvm_host.h  |   5 +-
 arch/arm64/include/asm/kvm_mmu.h   |   3 +-
 arch/arm64/kvm/arm.c               | 124 +++++++++++------------------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |   6 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c      |  10 +--
 arch/arm64/kvm/hyp/vhe/tlb.c       |  10 +--
 arch/arm64/kvm/mmu.c               |   1 -
 8 files changed, 65 insertions(+), 98 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index a7ab84f781f7..29697c5ab2c2 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -44,7 +44,7 @@
 
 #define __KVM_HOST_SMCCC_FUNC___kvm_hyp_init			0
 #define __KVM_HOST_SMCCC_FUNC___kvm_vcpu_run			1
-#define __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context		2
+#define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_local_all		2
 #define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa		3
 #define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid		4
 #define __KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context		5
@@ -182,7 +182,7 @@ DECLARE_KVM_NVHE_SYM(__per_cpu_end);
 DECLARE_KVM_HYP_SYM(__bp_harden_hyp_vecs);
 #define __bp_harden_hyp_vecs	CHOOSE_HYP_SYM(__bp_harden_hyp_vecs)
 
-extern void __kvm_flush_vm_context(void);
+extern void __kvm_tlb_flush_local_all(void);
 extern void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
 				     int level);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3d10e6527f7d..5309216e4a94 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -70,9 +70,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
 
 struct kvm_vmid {
-	/* The VMID generation used for the virt. memory system */
-	u64    vmid_gen;
-	u32    vmid;
+	atomic64_t id;
 };
 
 struct kvm_s2_mmu {
@@ -631,7 +629,6 @@ void kvm_arm_resume_guest(struct kvm *kvm);
 		ret;							\
 	})
 
-void force_vm_exit(const cpumask_t *mask);
 void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
 
 int handle_exit(struct kvm_vcpu *vcpu, int exception_index);
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index c3080966ef83..43e83df87e3a 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -252,7 +252,8 @@ static __always_inline u64 kvm_get_vttbr(struct kvm_s2_mmu *mmu)
 	u64 cnp = system_supports_cnp() ? VTTBR_CNP_BIT : 0;
 
 	baddr = mmu->pgd_phys;
-	vmid_field = (u64)vmid->vmid << VTTBR_VMID_SHIFT;
+	vmid_field = atomic64_read(&vmid->id) << VTTBR_VMID_SHIFT;
+	vmid_field &= VTTBR_VMID_MASK(kvm_get_vmid_bits());
 	return kvm_phys_to_vttbr(baddr) | vmid_field | cnp;
 }
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7f06ba76698d..c63242db2d42 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -31,6 +31,7 @@
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
 #include <asm/cpufeature.h>
+#include <asm/lib_asid.h>
 #include <asm/virt.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
@@ -55,10 +56,10 @@ static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
 DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
-/* The VMID used in the VTTBR */
-static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
-static u32 kvm_next_vmid;
-static DEFINE_SPINLOCK(kvm_vmid_lock);
+static DEFINE_PER_CPU(atomic64_t, active_vmids);
+static DEFINE_PER_CPU(u64, reserved_vmids);
+
+static struct asid_info vmid_info;
 
 static bool vgic_present;
 
@@ -486,85 +487,22 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 	return vcpu_mode_priv(vcpu);
 }
 
-/* Just ensure a guest exit from a particular CPU */
-static void exit_vm_noop(void *info)
-{
-}
-
-void force_vm_exit(const cpumask_t *mask)
+static void vmid_flush_cpu_ctxt(void)
 {
-	preempt_disable();
-	smp_call_function_many(mask, exit_vm_noop, NULL, true);
-	preempt_enable();
+	kvm_call_hyp(__kvm_tlb_flush_local_all);
 }
 
-/**
- * need_new_vmid_gen - check that the VMID is still valid
- * @vmid: The VMID to check
- *
- * return true if there is a new generation of VMIDs being used
- *
- * The hardware supports a limited set of values with the value zero reserved
- * for the host, so we check if an assigned value belongs to a previous
- * generation, which requires us to assign a new value. If we're the first to
- * use a VMID for the new generation, we must flush necessary caches and TLBs
- * on all CPUs.
- */
-static bool need_new_vmid_gen(struct kvm_vmid *vmid)
+static void vmid_set_reserved_bits(struct asid_info *info)
 {
-	u64 current_vmid_gen = atomic64_read(&kvm_vmid_gen);
-	smp_rmb(); /* Orders read of kvm_vmid_gen and kvm->arch.vmid */
-	return unlikely(READ_ONCE(vmid->vmid_gen) != current_vmid_gen);
+	bitmap_clear(info->map, 0, NUM_CTXT_ASIDS(info));
 }
-
 /**
  * update_vmid - Update the vmid with a valid VMID for the current generation
  * @vmid: The stage-2 VMID information struct
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
-
-	vmid->vmid = kvm_next_vmid;
-	kvm_next_vmid++;
-	kvm_next_vmid &= (1 << kvm_get_vmid_bits()) - 1;
-
-	smp_wmb();
-	WRITE_ONCE(vmid->vmid_gen, atomic64_read(&kvm_vmid_gen));
-
-	spin_unlock(&kvm_vmid_lock);
+	asid_check_context(&vmid_info, &vmid->id, NULL);
 }
 
 static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
@@ -728,8 +666,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		cond_resched();
 
-		update_vmid(&vcpu->arch.hw_mmu->vmid);
-
 		check_vcpu_requests(vcpu);
 
 		/*
@@ -739,6 +675,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		preempt_disable();
 
+		/*
+		 * The ASID/VMID allocator only tracks active VMIDs per
+		 * physical CPU, and therefore the VMID allocated may not be
+		 * preserved on VMID roll-over if the task was preempted,
+		 * making a thread's VMID inactive. So we need to call
+		 * update_vttbr in non-premptible context.
+		 */
+		update_vmid(&vcpu->arch.hw_mmu->vmid);
+
 		kvm_pmu_flush_hwstate(vcpu);
 
 		local_irq_disable();
@@ -777,8 +722,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
-		if (ret <= 0 || need_new_vmid_gen(&vcpu->arch.hw_mmu->vmid) ||
-		    kvm_request_pending(vcpu)) {
+		if (ret <= 0 || kvm_request_pending(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			isb(); /* Ensure work in x_flush_hwstate is committed */
 			kvm_pmu_sync_hwstate(vcpu);
@@ -1460,6 +1404,8 @@ static void cpu_hyp_reset(void)
 {
 	if (!is_kernel_in_hyp_mode())
 		__hyp_reset_vectors();
+
+	kvm_call_hyp(__kvm_tlb_flush_local_all);
 }
 
 /*
@@ -1635,9 +1581,32 @@ static bool init_psci_relay(void)
 
 static int init_common_resources(void)
 {
+	struct asid_info *info = &vmid_info;
+	int err;
+
+	/*
+	 * Initialize the ASID allocator telling it to allocate a single
+	 * VMID per VM.
+	 */
+	err = asid_allocator_init(info, kvm_get_vmid_bits(), false);
+	if (err) {
+		kvm_err("Failed to initialize VMID allocator.\n");
+		return err;
+	}
+
+	info->active = &active_vmids;
+	info->reserved = &reserved_vmids;
+	info->flush_cpu_ctxt_cb = vmid_flush_cpu_ctxt;
+	info->set_reserved_bits = vmid_set_reserved_bits;
+
 	return kvm_set_ipa_limit();
 }
 
+static void free_common_resources(void)
+{
+	asid_allocator_free(&vmid_info);
+}
+
 static int init_subsystems(void)
 {
 	int err = 0;
@@ -1918,7 +1887,7 @@ int kvm_arch_init(void *opaque)
 
 	err = kvm_arm_init_sve();
 	if (err)
-		return err;
+		goto out_err;
 
 	if (!in_hyp_mode) {
 		err = init_hyp_mode();
@@ -1952,6 +1921,7 @@ int kvm_arch_init(void *opaque)
 	if (!in_hyp_mode)
 		teardown_hyp_mode();
 out_err:
+	free_common_resources();
 	return err;
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 936328207bde..62027448d534 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -25,9 +25,9 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) =  __kvm_vcpu_run(kern_hyp_va(vcpu));
 }
 
-static void handle___kvm_flush_vm_context(struct kvm_cpu_context *host_ctxt)
+static void handle___kvm_tlb_flush_local_all(struct kvm_cpu_context *host_ctxt)
 {
-	__kvm_flush_vm_context();
+	__kvm_tlb_flush_local_all();
 }
 
 static void handle___kvm_tlb_flush_vmid_ipa(struct kvm_cpu_context *host_ctxt)
@@ -112,7 +112,7 @@ typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_vcpu_run),
-	HANDLE_FUNC(__kvm_flush_vm_context),
+	HANDLE_FUNC(__kvm_tlb_flush_local_all),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid),
 	HANDLE_FUNC(__kvm_flush_cpu_context),
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index 229b06748c20..3f1fc5125e9e 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -138,10 +138,10 @@ void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
 	__tlb_switch_to_host(&cxt);
 }
 
-void __kvm_flush_vm_context(void)
+void __kvm_tlb_flush_local_all(void)
 {
-	dsb(ishst);
-	__tlbi(alle1is);
+	dsb(nshst);
+	__tlbi(alle1);
 
 	/*
 	 * VIPT and PIPT caches are not affected by VMID, so no maintenance
@@ -153,7 +153,7 @@ void __kvm_flush_vm_context(void)
 	 *
 	 */
 	if (icache_is_vpipt())
-		asm volatile("ic ialluis");
+		asm volatile("ic iallu" : : );
 
-	dsb(ish);
+	dsb(nsh);
 }
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 66f17349f0c3..89f229e77b7d 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -142,10 +142,10 @@ void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
 	__tlb_switch_to_host(&cxt);
 }
 
-void __kvm_flush_vm_context(void)
+void __kvm_tlb_flush_local_all(void)
 {
-	dsb(ishst);
-	__tlbi(alle1is);
+	dsb(nshst);
+	__tlbi(alle1);
 
 	/*
 	 * VIPT and PIPT caches are not affected by VMID, so no maintenance
@@ -157,7 +157,7 @@ void __kvm_flush_vm_context(void)
 	 *
 	 */
 	if (icache_is_vpipt())
-		asm volatile("ic ialluis");
+		asm volatile("ic iallu" : : );
 
-	dsb(ish);
+	dsb(nsh);
 }
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8711894db8c2..4933fc9a13fb 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -390,7 +390,6 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 	mmu->kvm = kvm;
 	mmu->pgt = pgt;
 	mmu->pgd_phys = __pa(pgt->pgd);
-	mmu->vmid.vmid_gen = 0;
 	return 0;
 
 out_destroy_pgtable:
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
