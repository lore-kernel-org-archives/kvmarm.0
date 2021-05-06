Return-Path: <SRS0=4Pzf=KB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 857D1C433B4
	for <kvmarm@archiver.kernel.org>; Thu,  6 May 2021 16:55:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 17987611AE
	for <kvmarm@archiver.kernel.org>; Thu,  6 May 2021 16:55:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17987611AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B50B84B4B5;
	Thu,  6 May 2021 12:54:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nmAgT6D7d9zz; Thu,  6 May 2021 12:54:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28C864B468;
	Thu,  6 May 2021 12:54:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F5ED4B29B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 May 2021 12:54:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rEcAVtC3-SXv for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 May 2021 12:54:55 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A04C4B2EE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 May 2021 12:54:54 -0400 (EDT)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fbfjz391HzQjt7;
 Fri,  7 May 2021 00:51:35 +0800 (CST)
Received: from A2006125610.china.huawei.com (10.47.85.115) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Fri, 7 May 2021 00:54:44 +0800
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 3/3] kvm/arm: Align the VMID allocation with the arm64
 ASID one
Date: Thu, 6 May 2021 17:52:32 +0100
Message-ID: <20210506165232.1969-4-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20210506165232.1969-1-shameerali.kolothum.thodi@huawei.com>
References: <20210506165232.1969-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.47.85.115]
X-CFilter-Loop: Reflected
Cc: jean-philippe@linaro.org, maz@kernel.org, linuxarm@huawei.com,
 catalin.marinas@arm.com, will@kernel.org
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

This patch use the new VMID allocator. The
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
 arch/arm64/include/asm/kvm_asm.h   |   4 +-
 arch/arm64/include/asm/kvm_host.h  |   5 +-
 arch/arm64/include/asm/kvm_mmu.h   |   3 +-
 arch/arm64/kvm/Makefile            |   2 +-
 arch/arm64/kvm/arm.c               | 115 ++++++++---------------------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |   6 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c      |  10 +--
 arch/arm64/kvm/hyp/vhe/tlb.c       |  10 +--
 arch/arm64/kvm/mmu.c               |   1 -
 9 files changed, 51 insertions(+), 105 deletions(-)

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
index 9d476f1f34af..c06370f387cb 100644
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
 
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 589921392cb1..717c4cbf557a 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -16,7 +16,7 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 inject_fault.o va_layout.o handle_exit.o \
 	 guest.o debug.o reset.o sys_regs.o \
 	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
-	 arch_timer.o trng.o\
+	 arch_timer.o trng.o vmid.o \
 	 vgic/vgic.o vgic/vgic-init.o \
 	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
 	 vgic/vgic-v3.o vgic/vgic-v4.o \
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7f06ba76698d..4f58db358f72 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -55,11 +55,6 @@ static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
 DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
-/* The VMID used in the VTTBR */
-static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
-static u32 kvm_next_vmid;
-static DEFINE_SPINLOCK(kvm_vmid_lock);
-
 static bool vgic_present;
 
 static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
@@ -486,85 +481,13 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
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
-{
-	u64 current_vmid_gen = atomic64_read(&kvm_vmid_gen);
-	smp_rmb(); /* Orders read of kvm_vmid_gen and kvm->arch.vmid */
-	return unlikely(READ_ONCE(vmid->vmid_gen) != current_vmid_gen);
-}
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
+	kvm_arm_update_vmid(&vmid->id, NULL);
 }
 
 static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
@@ -728,8 +651,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		cond_resched();
 
-		update_vmid(&vcpu->arch.hw_mmu->vmid);
-
 		check_vcpu_requests(vcpu);
 
 		/*
@@ -739,6 +660,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		preempt_disable();
 
+		/*
+		 * The VMID allocator only tracks active VMIDs per
+		 * physical CPU, and therefore the VMID allocated may not be
+		 * preserved on VMID roll-over if the task was preempted,
+		 * making a thread's VMID inactive. So we need to call
+		 * update_vttbr in non-premptible context.
+		 */
+		update_vmid(&vcpu->arch.hw_mmu->vmid);
+
 		kvm_pmu_flush_hwstate(vcpu);
 
 		local_irq_disable();
@@ -777,8 +707,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
-		if (ret <= 0 || need_new_vmid_gen(&vcpu->arch.hw_mmu->vmid) ||
-		    kvm_request_pending(vcpu)) {
+		if (ret <= 0 || kvm_request_pending(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			isb(); /* Ensure work in x_flush_hwstate is committed */
 			kvm_pmu_sync_hwstate(vcpu);
@@ -1460,6 +1389,8 @@ static void cpu_hyp_reset(void)
 {
 	if (!is_kernel_in_hyp_mode())
 		__hyp_reset_vectors();
+
+	kvm_call_hyp(__kvm_tlb_flush_local_all);
 }
 
 /*
@@ -1635,9 +1566,26 @@ static bool init_psci_relay(void)
 
 static int init_common_resources(void)
 {
+	int err;
+
+	/*
+	 * Initialize the VMID allocator telling it to allocate a single
+	 * VMID per VM.
+	 */
+	err = kvm_arm_vmid_alloc_init();
+	if (err) {
+		kvm_err("Failed to initialize VMID allocator.\n");
+		return err;
+	}
+
 	return kvm_set_ipa_limit();
 }
 
+static void free_common_resources(void)
+{
+	kvm_arm_vmid_alloc_free();
+}
+
 static int init_subsystems(void)
 {
 	int err = 0;
@@ -1918,7 +1866,7 @@ int kvm_arch_init(void *opaque)
 
 	err = kvm_arm_init_sve();
 	if (err)
-		return err;
+		goto out_err;
 
 	if (!in_hyp_mode) {
 		err = init_hyp_mode();
@@ -1952,6 +1900,7 @@ int kvm_arch_init(void *opaque)
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
