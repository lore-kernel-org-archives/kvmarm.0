From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 34/55] KVM: arm/arm64: Abstract stage-2 MMU state into a
 separate structure
Date: Mon,  9 Jan 2017 01:24:30 -0500
Message-ID: <1483943091-1364-35-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 006AB40696
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tGYD1xIFvXrB for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:36 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4947740693
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:35 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PXCv005328
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:16 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id DB26586
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:16 -0500 (EST)
Received: from sendprodmail04.cc.columbia.edu (sendprodmail04.cc.columbia.edu
 [128.59.72.16]) by hazelnut (Postfix) with ESMTP id B416B88
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:16 -0500 (EST)
Received: from mail-qk0-f200.google.com (mail-qk0-f200.google.com
 [209.85.220.200])
 by sendprodmail04.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096QGot005382
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:16 -0500
Received: by mail-qk0-f200.google.com with SMTP id a16so37635660qkc.6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:16 -0800 (PST)
In-Reply-To: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Abstract stage-2 MMU state into a separate structure and change all
callers referring to page tables, VMIDs, and the VTTBR to use this new
indirection.

This is about to become very handy when using shadow stage-2 page
tables.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm/include/asm/kvm_asm.h    |   7 +-
 arch/arm/include/asm/kvm_host.h   |  26 ++++---
 arch/arm/kvm/arm.c                |  34 +++++----
 arch/arm/kvm/hyp/switch.c         |   5 +-
 arch/arm/kvm/hyp/tlb.c            |  18 ++---
 arch/arm/kvm/mmu.c                | 146 +++++++++++++++++++++-----------------
 arch/arm64/include/asm/kvm_asm.h  |   7 +-
 arch/arm64/include/asm/kvm_host.h |  10 ++-
 arch/arm64/kvm/hyp/switch.c       |   5 +-
 arch/arm64/kvm/hyp/tlb.c          |  20 +++---
 10 files changed, 159 insertions(+), 119 deletions(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 8ef0538..36e3856 100644
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
index d5423ab..f84a59c 100644
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
@@ -68,13 +80,6 @@ struct kvm_arch {
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
@@ -188,6 +193,9 @@ struct kvm_vcpu_arch {
 
 	/* Detect first run of a vcpu */
 	bool has_run_once;
+
+	/* Stage 2 paging state used by the hardware on next switch */
+	struct kvm_s2_mmu *hw_mmu;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 436bf5a..eb3e709 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -139,7 +139,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_timer_init(kvm);
 
 	/* Mark the initial VMID generation invalid */
-	kvm->arch.vmid_gen = 0;
+	kvm->arch.mmu.vmid_gen = 0;
 
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->arch.max_vcpus = vgic_present ?
@@ -321,6 +321,8 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 
 	kvm_arm_reset_debug_ptr(vcpu);
 
+	vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
+
 	return 0;
 }
 
@@ -335,7 +337,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	 * over-invalidation doesn't affect correctness.
 	 */
 	if (*last_ran != vcpu->vcpu_id) {
-		kvm_call_hyp(__kvm_tlb_flush_local_vmid, vcpu);
+		kvm_call_hyp(__kvm_tlb_flush_local_vmid, &vcpu->kvm->arch.mmu);
 		*last_ran = vcpu->vcpu_id;
 	}
 
@@ -423,25 +425,26 @@ void force_vm_exit(const cpumask_t *mask)
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
+ * @kvm:	The guest that we are about to run
+ * @mmu:	The stage-2 translation context to update
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
@@ -451,7 +454,7 @@ static void update_vttbr(struct kvm *kvm)
 	 * already allocated a valid vmid for this vm, then this vcpu should
 	 * use the same vmid.
 	 */
-	if (!need_new_vmid_gen(kvm)) {
+	if (!need_new_vmid_gen(mmu)) {
 		spin_unlock(&kvm_vmid_lock);
 		return;
 	}
@@ -475,16 +478,17 @@ static void update_vttbr(struct kvm *kvm)
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
@@ -611,7 +615,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 */
 		cond_resched();
 
-		update_vttbr(vcpu->kvm);
+		update_vttbr(vcpu->kvm, vcpu->arch.hw_mmu);
 
 		if (vcpu->arch.power_off || vcpu->arch.pause)
 			vcpu_sleep(vcpu);
@@ -636,7 +640,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 			run->exit_reason = KVM_EXIT_INTR;
 		}
 
-		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
+		if (ret <= 0 || need_new_vmid_gen(vcpu->arch.hw_mmu) ||
 			vcpu->arch.power_off || vcpu->arch.pause) {
 			local_irq_enable();
 			kvm_pmu_sync_hwstate(vcpu);
diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index 92678b7..6f99de1 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -73,8 +73,9 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 
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
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 57cb671..a27a204 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -63,9 +63,9 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 	kvm_call_hyp(__kvm_tlb_flush_vmid, kvm);
 }
 
-static void kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
+static void kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
 {
-	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, kvm, ipa);
+	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ipa);
 }
 
 /*
@@ -102,13 +102,14 @@ static bool kvm_is_device_pfn(unsigned long pfn)
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
 
@@ -144,31 +145,34 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
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
@@ -193,7 +197,7 @@ static void clear_stage2_pmd_entry(struct kvm *kvm, pmd_t *pmd, phys_addr_t addr
  * the corresponding TLBs, we call kvm_flush_dcache_p*() to make sure
  * the IO subsystem will never hit in the cache.
  */
-static void unmap_stage2_ptes(struct kvm *kvm, pmd_t *pmd,
+static void unmap_stage2_ptes(struct kvm_s2_mmu *mmu, pmd_t *pmd,
 		       phys_addr_t addr, phys_addr_t end)
 {
 	phys_addr_t start_addr = addr;
@@ -205,7 +209,7 @@ static void unmap_stage2_ptes(struct kvm *kvm, pmd_t *pmd,
 			pte_t old_pte = *pte;
 
 			kvm_set_pte(pte, __pte(0));
-			kvm_tlb_flush_vmid_ipa(kvm, addr);
+			kvm_tlb_flush_vmid_ipa(mmu, addr);
 
 			/* No need to invalidate the cache for device mappings */
 			if (!kvm_is_device_pfn(pte_pfn(old_pte)))
@@ -216,10 +220,10 @@ static void unmap_stage2_ptes(struct kvm *kvm, pmd_t *pmd,
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
@@ -233,22 +237,22 @@ static void unmap_stage2_pmds(struct kvm *kvm, pud_t *pud,
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
@@ -262,17 +266,17 @@ static void unmap_stage2_puds(struct kvm *kvm, pgd_t *pgd,
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
@@ -286,17 +290,18 @@ static void unmap_stage2_puds(struct kvm *kvm, pgd_t *pgd,
  * destroying the VM), otherwise another faulting VCPU may come in and mess
  * with things behind our backs.
  */
-static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
+static void unmap_stage2_range(struct kvm_s2_mmu *mmu,
+			       phys_addr_t start, u64 size)
 {
 	pgd_t *pgd;
 	phys_addr_t addr = start, end = start + size;
 	phys_addr_t next;
 
-	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
+	pgd = mmu->pgd + stage2_pgd_index(addr);
 	do {
 		next = stage2_pgd_addr_end(addr, end);
 		if (!stage2_pgd_none(*pgd))
-			unmap_stage2_puds(kvm, pgd, addr, next);
+			unmap_stage2_puds(mmu, pgd, addr, next);
 	} while (pgd++, addr = next, addr != end);
 }
 
@@ -348,7 +353,7 @@ static void stage2_flush_puds(pgd_t *pgd,
 	} while (pud++, addr = next, addr != end);
 }
 
-static void stage2_flush_memslot(struct kvm *kvm,
+static void stage2_flush_memslot(struct kvm_s2_mmu *mmu,
 				 struct kvm_memory_slot *memslot)
 {
 	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
@@ -356,7 +361,7 @@ static void stage2_flush_memslot(struct kvm *kvm,
 	phys_addr_t next;
 	pgd_t *pgd;
 
-	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
+	pgd = mmu->pgd + stage2_pgd_index(addr);
 	do {
 		next = stage2_pgd_addr_end(addr, end);
 		stage2_flush_puds(pgd, addr, next);
@@ -381,7 +386,7 @@ static void stage2_flush_vm(struct kvm *kvm)
 
 	slots = kvm_memslots(kvm);
 	kvm_for_each_memslot(memslot, slots)
-		stage2_flush_memslot(kvm, memslot);
+		stage2_flush_memslot(&kvm->arch.mmu, memslot);
 
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -733,8 +738,9 @@ int create_hyp_io_mappings(void *from, void *to, phys_addr_t phys_addr)
 int kvm_alloc_stage2_pgd(struct kvm *kvm)
 {
 	pgd_t *pgd;
+	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
 
-	if (kvm->arch.pgd != NULL) {
+	if (mmu->pgd != NULL) {
 		kvm_err("kvm_arch already initialized?\n");
 		return -EINVAL;
 	}
@@ -744,11 +750,12 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
 	if (!pgd)
 		return -ENOMEM;
 
-	kvm->arch.pgd = pgd;
+	mmu->pgd = pgd;
+
 	return 0;
 }
 
-static void stage2_unmap_memslot(struct kvm *kvm,
+static void stage2_unmap_memslot(struct kvm_s2_mmu *mmu,
 				 struct kvm_memory_slot *memslot)
 {
 	hva_t hva = memslot->userspace_addr;
@@ -783,7 +790,7 @@ static void stage2_unmap_memslot(struct kvm *kvm,
 
 		if (!(vma->vm_flags & VM_PFNMAP)) {
 			gpa_t gpa = addr + (vm_start - memslot->userspace_addr);
-			unmap_stage2_range(kvm, gpa, vm_end - vm_start);
+			unmap_stage2_range(mmu, gpa, vm_end - vm_start);
 		}
 		hva = vm_end;
 	} while (hva < reg_end);
@@ -807,7 +814,7 @@ void stage2_unmap_vm(struct kvm *kvm)
 
 	slots = kvm_memslots(kvm);
 	kvm_for_each_memslot(memslot, slots)
-		stage2_unmap_memslot(kvm, memslot);
+		stage2_unmap_memslot(&kvm->arch.mmu, memslot);
 
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -826,22 +833,25 @@ void stage2_unmap_vm(struct kvm *kvm)
  */
 void kvm_free_stage2_pgd(struct kvm *kvm)
 {
-	if (kvm->arch.pgd == NULL)
+	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
+
+	if (mmu->pgd == NULL)
 		return;
 
-	unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
+	unmap_stage2_range(mmu, 0, KVM_PHYS_SIZE);
 	/* Free the HW pgd, one page at a time */
-	free_pages_exact(kvm->arch.pgd, S2_PGD_SIZE);
-	kvm->arch.pgd = NULL;
+	free_pages_exact(mmu->pgd, S2_PGD_SIZE);
+	mmu->pgd = NULL;
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
@@ -853,13 +863,14 @@ static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
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
 	if (stage2_pud_none(*pud)) {
 		if (!cache)
 			return NULL;
@@ -871,12 +882,13 @@ static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
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
@@ -893,7 +905,7 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 	old_pmd = *pmd;
 	if (pmd_present(old_pmd)) {
 		pmd_clear(pmd);
-		kvm_tlb_flush_vmid_ipa(kvm, addr);
+		kvm_tlb_flush_vmid_ipa(mmu, addr);
 	} else {
 		get_page(virt_to_page(pmd));
 	}
@@ -902,7 +914,8 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 	return 0;
 }
 
-static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
+static int stage2_set_pte(struct kvm_s2_mmu *mmu,
+			  struct kvm_mmu_memory_cache *cache,
 			  phys_addr_t addr, const pte_t *new_pte,
 			  unsigned long flags)
 {
@@ -914,7 +927,7 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 	VM_BUG_ON(logging_active && !cache);
 
 	/* Create stage-2 page table mapping - Levels 0 and 1 */
-	pmd = stage2_get_pmd(kvm, cache, addr);
+	pmd = stage2_get_pmd(mmu, cache, addr);
 	if (!pmd) {
 		/*
 		 * Ignore calls from kvm_set_spte_hva for unallocated
@@ -928,7 +941,7 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 	 * allocate page.
 	 */
 	if (logging_active)
-		stage2_dissolve_pmd(kvm, addr, pmd);
+		stage2_dissolve_pmd(mmu, addr, pmd);
 
 	/* Create stage-2 page mappings - Level 2 */
 	if (pmd_none(*pmd)) {
@@ -948,7 +961,7 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 	old_pte = *pte;
 	if (pte_present(old_pte)) {
 		kvm_set_pte(pte, __pte(0));
-		kvm_tlb_flush_vmid_ipa(kvm, addr);
+		kvm_tlb_flush_vmid_ipa(mmu, addr);
 	} else {
 		get_page(virt_to_page(pte));
 	}
@@ -1008,7 +1021,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 		if (ret)
 			goto out;
 		spin_lock(&kvm->mmu_lock);
-		ret = stage2_set_pte(kvm, &cache, addr, &pte,
+		ret = stage2_set_pte(&kvm->arch.mmu, &cache, addr, &pte,
 						KVM_S2PTE_FLAG_IS_IOMAP);
 		spin_unlock(&kvm->mmu_lock);
 		if (ret)
@@ -1146,12 +1159,13 @@ static void  stage2_wp_puds(pgd_t *pgd, phys_addr_t addr, phys_addr_t end)
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
@@ -1190,7 +1204,7 @@ void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	phys_addr_t end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
 
 	spin_lock(&kvm->mmu_lock);
-	stage2_wp_range(kvm, start, end);
+	stage2_wp_range(kvm, &kvm->arch.mmu, start, end);
 	spin_unlock(&kvm->mmu_lock);
 	kvm_flush_remote_tlbs(kvm);
 }
@@ -1214,7 +1228,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
 	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
 
-	stage2_wp_range(kvm, start, end);
+	stage2_wp_range(kvm, &kvm->arch.mmu, start, end);
 }
 
 /*
@@ -1253,6 +1267,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	bool fault_ipa_uncached;
 	bool logging_active = memslot_is_logging(memslot);
 	unsigned long flags = 0;
+	struct kvm_s2_mmu *mmu = vcpu->arch.hw_mmu;
 
 	write_fault = kvm_is_write_fault(vcpu);
 	if (fault_status == FSC_PERM && !write_fault) {
@@ -1347,7 +1362,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			kvm_set_pfn_dirty(pfn);
 		}
 		coherent_cache_guest_page(vcpu, pfn, PMD_SIZE, fault_ipa_uncached);
-		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
+		ret = stage2_set_pmd_huge(mmu, memcache, fault_ipa, &new_pmd);
 	} else {
 		pte_t new_pte = pfn_pte(pfn, mem_type);
 
@@ -1357,7 +1372,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			mark_page_dirty(kvm, gfn);
 		}
 		coherent_cache_guest_page(vcpu, pfn, PAGE_SIZE, fault_ipa_uncached);
-		ret = stage2_set_pte(kvm, memcache, fault_ipa, &new_pte, flags);
+		ret = stage2_set_pte(mmu, memcache, fault_ipa, &new_pte, flags);
 	}
 
 out_unlock:
@@ -1385,7 +1400,7 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 
-	pmd = stage2_get_pmd(vcpu->kvm, NULL, fault_ipa);
+	pmd = stage2_get_pmd(vcpu->arch.hw_mmu, NULL, fault_ipa);
 	if (!pmd || pmd_none(*pmd))	/* Nothing there */
 		goto out;
 
@@ -1553,7 +1568,7 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 
 static int kvm_unmap_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
 {
-	unmap_stage2_range(kvm, gpa, PAGE_SIZE);
+	unmap_stage2_range(&kvm->arch.mmu, gpa, PAGE_SIZE);
 	return 0;
 }
 
@@ -1561,7 +1576,7 @@ int kvm_unmap_hva(struct kvm *kvm, unsigned long hva)
 {
 	unsigned long end = hva + PAGE_SIZE;
 
-	if (!kvm->arch.pgd)
+	if (!kvm->arch.mmu.pgd)
 		return 0;
 
 	trace_kvm_unmap_hva(hva);
@@ -1572,7 +1587,7 @@ int kvm_unmap_hva(struct kvm *kvm, unsigned long hva)
 int kvm_unmap_hva_range(struct kvm *kvm,
 			unsigned long start, unsigned long end)
 {
-	if (!kvm->arch.pgd)
+	if (!kvm->arch.mmu.pgd)
 		return 0;
 
 	trace_kvm_unmap_hva_range(start, end);
@@ -1591,7 +1606,7 @@ static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, void *data)
 	 * therefore stage2_set_pte() never needs to clear out a huge PMD
 	 * through this calling path.
 	 */
-	stage2_set_pte(kvm, NULL, gpa, pte, 0);
+	stage2_set_pte(&kvm->arch.mmu, NULL, gpa, pte, 0);
 	return 0;
 }
 
@@ -1601,7 +1616,7 @@ void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 	unsigned long end = hva + PAGE_SIZE;
 	pte_t stage2_pte;
 
-	if (!kvm->arch.pgd)
+	if (!kvm->arch.mmu.pgd)
 		return;
 
 	trace_kvm_set_spte_hva(hva);
@@ -1614,7 +1629,7 @@ static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
 	pmd_t *pmd;
 	pte_t *pte;
 
-	pmd = stage2_get_pmd(kvm, NULL, gpa);
+	pmd = stage2_get_pmd(&kvm->arch.mmu, NULL, gpa);
 	if (!pmd || pmd_none(*pmd))	/* Nothing there */
 		return 0;
 
@@ -1633,7 +1648,7 @@ static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
 	pmd_t *pmd;
 	pte_t *pte;
 
-	pmd = stage2_get_pmd(kvm, NULL, gpa);
+	pmd = stage2_get_pmd(&kvm->arch.mmu, NULL, gpa);
 	if (!pmd || pmd_none(*pmd))	/* Nothing there */
 		return 0;
 
@@ -1864,9 +1879,10 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 	spin_lock(&kvm->mmu_lock);
 	if (ret)
-		unmap_stage2_range(kvm, mem->guest_phys_addr, mem->memory_size);
+		unmap_stage2_range(&kvm->arch.mmu, mem->guest_phys_addr,
+				   mem->memory_size);
 	else
-		stage2_flush_memslot(kvm, memslot);
+		stage2_flush_memslot(&kvm->arch.mmu, memslot);
 	spin_unlock(&kvm->mmu_lock);
 	return ret;
 }
@@ -1907,7 +1923,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	phys_addr_t size = slot->npages << PAGE_SHIFT;
 
 	spin_lock(&kvm->mmu_lock);
-	unmap_stage2_range(kvm, gpa, size);
+	unmap_stage2_range(&kvm->arch.mmu, gpa, size);
 	spin_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index ec3553eb..ed8139f 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -44,6 +44,7 @@
 #ifndef __ASSEMBLY__
 struct kvm;
 struct kvm_vcpu;
+struct kvm_s2_mmu;
 
 extern char __kvm_hyp_init[];
 extern char __kvm_hyp_init_end[];
@@ -52,9 +53,9 @@
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
index ed78d73..954d6de 100644
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
@@ -326,6 +331,9 @@ struct kvm_vcpu_arch {
 
 	/* Detect first run of a vcpu */
 	bool has_run_once;
+
+	/* Stage 2 paging state used by the hardware on next switch */
+	struct kvm_s2_mmu *hw_mmu;
 };
 
 #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index b7c8c30..3207009a 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -135,8 +135,9 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 
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
index 88e2f2b..71a62ea 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -17,13 +17,14 @@
 
 #include <asm/kvm_hyp.h>
 
-void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
+void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
+					 phys_addr_t ipa)
 {
 	dsb(ishst);
 
 	/* Switch to requested VMID */
-	kvm = kern_hyp_va(kvm);
-	write_sysreg(kvm->arch.vttbr, vttbr_el2);
+	mmu = kern_hyp_va(mmu);
+	write_sysreg(mmu->vttbr, vttbr_el2);
 	isb();
 
 	/*
@@ -48,13 +49,13 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 	write_sysreg(0, vttbr_el2);
 }
 
-void __hyp_text __kvm_tlb_flush_vmid(struct kvm *kvm)
+void __hyp_text __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 {
 	dsb(ishst);
 
 	/* Switch to requested VMID */
-	kvm = kern_hyp_va(kvm);
-	write_sysreg(kvm->arch.vttbr, vttbr_el2);
+	mmu = kern_hyp_va(mmu);
+	write_sysreg(mmu->vttbr, vttbr_el2);
 	isb();
 
 	asm volatile("tlbi vmalls12e1is" : : );
@@ -64,12 +65,11 @@ void __hyp_text __kvm_tlb_flush_vmid(struct kvm *kvm)
 	write_sysreg(0, vttbr_el2);
 }
 
-void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
+void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu)
 {
-	struct kvm *kvm = kern_hyp_va(kern_hyp_va(vcpu)->kvm);
-
 	/* Switch to requested VMID */
-	write_sysreg(kvm->arch.vttbr, vttbr_el2);
+	mmu = kern_hyp_va(mmu);
+	write_sysreg(mmu->vttbr, vttbr_el2);
 	isb();
 
 	asm volatile("tlbi vmalle1" : : );
-- 
1.9.1
