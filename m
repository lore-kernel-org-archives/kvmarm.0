From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 12/31] KVM: arm/arm64: Handle shadow stage 2 page faults
Date: Mon,  2 Oct 2017 22:10:54 -0500
Message-ID: <1507000273-3735-10-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A716E49D3B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6n+AGgoDpS3Q for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 23:11:32 -0400 (EDT)
Received: from mail-it0-f43.google.com (mail-it0-f43.google.com
 [209.85.214.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2AAF5406BB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:32 -0400 (EDT)
Received: by mail-it0-f43.google.com with SMTP id x15so9995731itb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Oct 2017 20:11:51 -0700 (PDT)
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

If we are faulting on a shadow stage 2 translation, we first walk the
guest hypervisor's stage 2 page table to see if it has a mapping. If
not, we inject a stage 2 page fault to the virtual EL2. Otherwise, we
create a mapping in the shadow stage 2 page table.

Note that we have to deal with two IPAs when we got a showdow stage 2
page fault. One is the address we faulted on, and is in the L2 guest
phys space. The other is from the guest stage-2 page table walk, and is
in the L1 guest phys space.  To differentiate them, we rename variable
names so that fault_ipa is used for the former and ipa is used for the
latter.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---

Notes:
    v1-->v2:
    - Added a common function to inject s2 faults.
    - Align L1 IPA as well as L2 IPA in transparent_hugepage_adjust(). This will
    come in handy when creating a rmap entry with both IPAs.

 arch/arm/include/asm/kvm_emulate.h   |  7 ++++
 arch/arm/include/asm/kvm_mmu.h       |  4 ++
 arch/arm64/include/asm/kvm_emulate.h |  5 +++
 arch/arm64/include/asm/kvm_mmu.h     |  1 +
 arch/arm64/kvm/mmu-nested.c          |  8 ++++
 virt/kvm/arm/mmio.c                  | 12 +++---
 virt/kvm/arm/mmu.c                   | 75 +++++++++++++++++++++++++++++-------
 7 files changed, 92 insertions(+), 20 deletions(-)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 24a3fbf..8136464 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -297,4 +297,11 @@ static inline struct kvm_s2_vmid *vcpu_get_active_vmid(struct kvm_vcpu *vcpu)
 {
 	return &vcpu->kvm->arch.mmu.vmid;
 }
+
+/* arm architecture doesn't support the nesting */
+static inline bool kvm_is_shadow_s2_fault(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 #endif /* __ARM_KVM_EMULATE_H__ */
diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 5fab21a..6a22846 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -242,6 +242,10 @@ static inline void kvm_nested_s2_free(struct kvm *kvm) { }
 static inline void kvm_nested_s2_wp(struct kvm *kvm) { }
 static inline void kvm_nested_s2_clear(struct kvm *kvm) { }
 static inline void kvm_nested_s2_flush(struct kvm *kvm) { }
+static inline int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2)
+{
+	return 0;
+}
 
 static inline u64 kvm_get_vttbr(struct kvm_s2_vmid *vmid,
 				struct kvm_s2_mmu *mmu)
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index f476576..c66554b 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -390,4 +390,9 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
 	return data;		/* Leave LE untouched */
 }
 
+static inline bool kvm_is_shadow_s2_fault(struct kvm_vcpu *vcpu)
+{
+	return vcpu_nested_stage2_enabled(vcpu) && !is_hyp_ctxt(vcpu);
+}
+
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index c4efcd5..425e4a2 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -342,6 +342,7 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 void kvm_nested_s2_wp(struct kvm *kvm);
 void kvm_nested_s2_clear(struct kvm *kvm);
 void kvm_nested_s2_flush(struct kvm *kvm);
+int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
 
 static inline u64 kvm_get_vttbr(struct kvm_s2_vmid *vmid,
 				struct kvm_s2_mmu *mmu)
diff --git a/arch/arm64/kvm/mmu-nested.c b/arch/arm64/kvm/mmu-nested.c
index fb694b7..75570cc 100644
--- a/arch/arm64/kvm/mmu-nested.c
+++ b/arch/arm64/kvm/mmu-nested.c
@@ -60,6 +60,14 @@ static int esr_s2_fault(struct kvm_vcpu *vcpu, int level, u32 fsc)
 	return esr;
 }
 
+int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2)
+{
+	vcpu->arch.ctxt.sys_regs[FAR_EL2] = vcpu->arch.fault.far_el2;
+	vcpu->arch.ctxt.sys_regs[HPFAR_EL2] = vcpu->arch.fault.hpfar_el2;
+
+	return kvm_inject_nested_sync(vcpu, esr_el2);
+}
+
 static int check_base_s2_limits(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
 				int level, int input_size, int stride)
 {
diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
index b6e715f..a1009c2 100644
--- a/virt/kvm/arm/mmio.c
+++ b/virt/kvm/arm/mmio.c
@@ -153,7 +153,7 @@ static int decode_hsr(struct kvm_vcpu *vcpu, bool *is_write, int *len)
 }
 
 int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
-		 phys_addr_t fault_ipa)
+		 phys_addr_t ipa)
 {
 	unsigned long data;
 	unsigned long rt;
@@ -182,22 +182,22 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		data = vcpu_data_guest_to_host(vcpu, vcpu_get_reg(vcpu, rt),
 					       len);
 
-		trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, len, fault_ipa, data);
+		trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, len, ipa, data);
 		kvm_mmio_write_buf(data_buf, len, data);
 
-		ret = kvm_io_bus_write(vcpu, KVM_MMIO_BUS, fault_ipa, len,
+		ret = kvm_io_bus_write(vcpu, KVM_MMIO_BUS, ipa, len,
 				       data_buf);
 	} else {
 		trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, len,
-			       fault_ipa, 0);
+			       ipa, 0);
 
-		ret = kvm_io_bus_read(vcpu, KVM_MMIO_BUS, fault_ipa, len,
+		ret = kvm_io_bus_read(vcpu, KVM_MMIO_BUS, ipa, len,
 				      data_buf);
 	}
 
 	/* Now prepare kvm_run for the potential return to userland. */
 	run->mmio.is_write	= is_write;
-	run->mmio.phys_addr	= fault_ipa;
+	run->mmio.phys_addr	= ipa;
 	run->mmio.len		= len;
 
 	if (!ret) {
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 3143f81..25d3d73 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1098,7 +1098,8 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	return ret;
 }
 
-static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
+static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap,
+					phys_addr_t *fault_ipap)
 {
 	kvm_pfn_t pfn = *pfnp;
 	gfn_t gfn = *ipap >> PAGE_SHIFT;
@@ -1126,6 +1127,7 @@ static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
 		mask = PTRS_PER_PMD - 1;
 		VM_BUG_ON((gfn & mask) != (pfn & mask));
 		if (pfn & mask) {
+			*fault_ipap &= PMD_MASK;
 			*ipap &= PMD_MASK;
 			kvm_release_pfn_clean(pfn);
 			pfn &= ~mask;
@@ -1337,13 +1339,15 @@ static void kvm_send_hwpoison_signal(unsigned long address,
 }
 
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
-			  struct kvm_memory_slot *memslot, unsigned long hva,
-			  unsigned long fault_status)
+			  struct kvm_s2_trans *nested,
+			  struct kvm_memory_slot *memslot,
+			  unsigned long hva, unsigned long fault_status)
 {
 	int ret;
 	bool write_fault, writable, hugetlb = false, force_pte = false;
 	unsigned long mmu_seq;
-	gfn_t gfn = fault_ipa >> PAGE_SHIFT;
+	phys_addr_t ipa = fault_ipa;
+	gfn_t gfn;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
 	struct vm_area_struct *vma;
@@ -1368,9 +1372,23 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
-	if (is_vm_hugetlb_page(vma) && !logging_active) {
+	if (kvm_is_shadow_s2_fault(vcpu)) {
+		ipa = nested->output;
+
+		/*
+		 * If we're about to create a shadow stage 2 entry, then we
+		 * can only create huge mappings if the guest hypervisor also
+		 * uses a huge mapping.
+		 */
+		if (nested->block_size != PMD_SIZE)
+			force_pte = true;
+	}
+	gfn = ipa >> PAGE_SHIFT;
+
+
+	if (!force_pte && is_vm_hugetlb_page(vma) && !logging_active) {
 		hugetlb = true;
-		gfn = (fault_ipa & PMD_MASK) >> PAGE_SHIFT;
+		gfn = (ipa & PMD_MASK) >> PAGE_SHIFT;
 	} else {
 		/*
 		 * Pages belonging to memslots that don't have the same
@@ -1438,7 +1456,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		goto out_unlock;
 
 	if (!hugetlb && !force_pte)
-		hugetlb = transparent_hugepage_adjust(&pfn, &fault_ipa);
+		hugetlb = transparent_hugepage_adjust(&pfn, &ipa, &fault_ipa);
 
 	if (hugetlb) {
 		pmd_t new_pmd = pfn_pmd(pfn, mem_type);
@@ -1525,8 +1543,10 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	unsigned long fault_status;
-	phys_addr_t fault_ipa;
+	phys_addr_t fault_ipa; /* The address we faulted on */
+	phys_addr_t ipa; /* Always the IPA in the L1 guest phys space */
 	struct kvm_memory_slot *memslot;
+	struct kvm_s2_trans nested_trans;
 	unsigned long hva;
 	bool is_iabt, write_fault, writable;
 	gfn_t gfn;
@@ -1538,7 +1558,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		return 1;
 	}
 
-	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
+	ipa = fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
 
 	trace_kvm_guest_fault(*vcpu_pc(vcpu), kvm_vcpu_get_hsr(vcpu),
 			      kvm_vcpu_get_hfar(vcpu), fault_ipa);
@@ -1547,6 +1567,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
 	if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
 	    fault_status != FSC_ACCESS) {
+		/*
+		 * We must never see an address size fault on shadow stage 2
+		 * page table walk, because we would have injected an addr
+		 * size fault when we walked the nested s2 page and not
+		 * create the shadow entry.
+		 */
 		kvm_err("Unsupported FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
 			kvm_vcpu_trap_get_class(vcpu),
 			(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
@@ -1556,7 +1582,27 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 
-	gfn = fault_ipa >> PAGE_SHIFT;
+	/*
+	 * We may have faulted on a shadow stage 2 page table if we are
+	 * running a nested guest.  In this case, we have to resovle the L2
+	 * IPA to the L1 IPA first, before knowing what kind of memory should
+	 * back the L1 IPA.
+	 *
+	 * If the shadow stage 2 page table walk faults, then we simply inject
+	 * this to the guest and carry on.
+	 */
+	if (kvm_is_shadow_s2_fault(vcpu)) {
+		nested_trans.esr = 0;
+		ret = kvm_walk_nested_s2(vcpu, fault_ipa, &nested_trans);
+		if (nested_trans.esr)
+			kvm_inject_s2_fault(vcpu, nested_trans.esr);
+		if (ret)
+			goto out_unlock;
+
+		ipa = nested_trans.output;
+	}
+
+	gfn = ipa >> PAGE_SHIFT;
 	memslot = gfn_to_memslot(vcpu->kvm, gfn);
 	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
 	write_fault = kvm_is_write_fault(vcpu);
@@ -1590,13 +1636,13 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 * faulting VA. This is always 12 bits, irrespective
 		 * of the page size.
 		 */
-		fault_ipa |= kvm_vcpu_get_hfar(vcpu) & ((1 << 12) - 1);
-		ret = io_mem_abort(vcpu, run, fault_ipa);
+		ipa |= kvm_vcpu_get_hfar(vcpu) & ((1 << 12) - 1);
+		ret = io_mem_abort(vcpu, run, ipa);
 		goto out_unlock;
 	}
 
 	/* Userspace should not be able to register out-of-bounds IPAs */
-	VM_BUG_ON(fault_ipa >= KVM_PHYS_SIZE);
+	VM_BUG_ON(ipa >= KVM_PHYS_SIZE);
 
 	if (fault_status == FSC_ACCESS) {
 		handle_access_fault(vcpu, fault_ipa);
@@ -1604,7 +1650,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		goto out_unlock;
 	}
 
-	ret = user_mem_abort(vcpu, fault_ipa, memslot, hva, fault_status);
+	ret = user_mem_abort(vcpu, fault_ipa, &nested_trans,
+			     memslot, hva, fault_status);
 	if (ret == 0)
 		ret = 1;
 out_unlock:
-- 
1.9.1
