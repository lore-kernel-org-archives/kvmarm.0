Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2EAEC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 81C4A61BE1
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:37:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 81C4A61BE1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36E884B134;
	Wed, 17 Nov 2021 10:37:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B9MfE5LmSqjH; Wed, 17 Nov 2021 10:37:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B10234B176;
	Wed, 17 Nov 2021 10:37:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 311354B0EC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ioOm0jvOLLY1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 10:37:11 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A87194B173
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:37:09 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3DFEC1396;
 Wed, 17 Nov 2021 07:37:09 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5BD803F5A1;
 Wed, 17 Nov 2021 07:37:07 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, mark.rutland@arm.com
Subject: [RFC PATCH v5 04/38] KVM: arm64: Defer CMOs for locked memslots until
 a VCPU is run
Date: Wed, 17 Nov 2021 15:38:08 +0000
Message-Id: <20211117153842.302159-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211117153842.302159-1-alexandru.elisei@arm.com>
References: <20211117153842.302159-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

KVM relies on doing dcache maintenance on stage 2 faults to present to a
guest running with the MMU off the same view of memory as userspace. For
locked memslots, KVM so far has done the dcache maintenance when a memslot
is locked, but that leaves KVM in a rather awkward position: what userspace
writes to guest memory after the memslot is locked, but before a VCPU is
run, might not be visible to the guest.

Fix this by deferring the dcache maintenance until the first VCPU is run.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  7 ++++
 arch/arm64/include/asm/kvm_mmu.h  |  5 +++
 arch/arm64/kvm/arm.c              |  3 ++
 arch/arm64/kvm/mmu.c              | 55 ++++++++++++++++++++++++++++---
 4 files changed, 66 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7fd70ad90c16..3b4839b447c4 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -113,6 +113,10 @@ struct kvm_arch_memory_slot {
 	u32 flags;
 };
 
+/* kvm->arch.mmu_pending_ops flags */
+#define KVM_LOCKED_MEMSLOT_FLUSH_DCACHE	0
+#define KVM_MAX_MMU_PENDING_OPS		1
+
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
 
@@ -136,6 +140,9 @@ struct kvm_arch {
 	 */
 	bool return_nisv_io_abort_to_user;
 
+	/* Defer MMU operations until a VCPU is run. */
+	unsigned long mmu_pending_ops;
+
 	/*
 	 * VM-wide PMU filter, implemented as a bitmap and big enough for
 	 * up to 2^10 events (ARMv8.0) or 2^16 events (ARMv8.1+).
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 2c50734f048d..cbf57c474fea 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -219,6 +219,11 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled);
 int kvm_mmu_lock_memslot(struct kvm *kvm, u64 slot, u64 flags);
 int kvm_mmu_unlock_memslot(struct kvm *kvm, u64 slot, u64 flags);
 
+#define kvm_mmu_has_pending_ops(kvm)	\
+	(!bitmap_empty(&(kvm)->arch.mmu_pending_ops, KVM_MAX_MMU_PENDING_OPS))
+
+void kvm_mmu_perform_pending_ops(struct kvm *kvm);
+
 static inline unsigned int kvm_get_vmid_bits(void)
 {
 	int reg = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b9b8b43835e3..96ed48455cdd 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -870,6 +870,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	if (unlikely(!kvm_vcpu_initialized(vcpu)))
 		return -ENOEXEC;
 
+	if (unlikely(kvm_mmu_has_pending_ops(vcpu->kvm)))
+		kvm_mmu_perform_pending_ops(vcpu->kvm);
+
 	ret = kvm_vcpu_first_run_init(vcpu);
 	if (ret)
 		return ret;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index b0a8e61315e4..8e4787019840 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1305,6 +1305,40 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+/*
+ * It's safe to do the CMOs when the first VCPU is run because:
+ * - VCPUs cannot run until mmu_cmo_needed is cleared.
+ * - Memslots cannot be modified because we hold the kvm->slots_lock.
+ *
+ * It's safe to periodically release the mmu_lock because:
+ * - VCPUs cannot run.
+ * - Any changes to the stage 2 tables triggered by the MMU notifiers also take
+ *   the mmu_lock, which means accesses will be serialized.
+ * - Stage 2 tables cannot be freed from under us as long as at least one VCPU
+ *   is live, which means that the VM will be live.
+ */
+void kvm_mmu_perform_pending_ops(struct kvm *kvm)
+{
+	struct kvm_memory_slot *memslot;
+
+	mutex_lock(&kvm->slots_lock);
+	if (!kvm_mmu_has_pending_ops(kvm))
+		goto out_unlock;
+
+	if (test_bit(KVM_LOCKED_MEMSLOT_FLUSH_DCACHE, &kvm->arch.mmu_pending_ops)) {
+		kvm_for_each_memslot(memslot, kvm_memslots(kvm)) {
+			if (!memslot_is_locked(memslot))
+				continue;
+			stage2_flush_memslot(kvm, memslot);
+		}
+		clear_bit(KVM_LOCKED_MEMSLOT_FLUSH_DCACHE, &kvm->arch.mmu_pending_ops);
+	}
+
+out_unlock:
+	mutex_unlock(&kvm->slots_lock);
+	return;
+}
+
 static int try_rlimit_memlock(unsigned long npages)
 {
 	unsigned long lock_limit;
@@ -1345,7 +1379,8 @@ static int lock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	struct kvm_memory_slot_page *page_entry;
 	bool writable = flags & KVM_ARM_LOCK_MEM_WRITE;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
-	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
+	struct kvm_pgtable pgt;
+	struct kvm_pgtable_mm_ops mm_ops;
 	struct vm_area_struct *vma;
 	unsigned long npages = memslot->npages;
 	unsigned int pin_flags = FOLL_LONGTERM;
@@ -1363,6 +1398,16 @@ static int lock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		pin_flags |= FOLL_WRITE;
 	}
 
+	/*
+	 * Make a copy of the stage 2 translation table struct to remove the
+	 * dcache callback so we can postpone the cache maintenance operations
+	 * until the first VCPU is run.
+	 */
+	mm_ops = *kvm->arch.mmu.pgt->mm_ops;
+	mm_ops.dcache_clean_inval_poc = NULL;
+	pgt = *kvm->arch.mmu.pgt;
+	pgt.mm_ops = &mm_ops;
+
 	hva = memslot->userspace_addr;
 	ipa = memslot->base_gfn << PAGE_SHIFT;
 
@@ -1414,13 +1459,13 @@ static int lock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			goto out_err;
 		}
 
-		ret = kvm_pgtable_stage2_map(pgt, ipa, PAGE_SIZE,
+		ret = kvm_pgtable_stage2_map(&pgt, ipa, PAGE_SIZE,
 					     page_to_phys(page_entry->page),
 					     prot, &cache);
 		spin_unlock(&kvm->mmu_lock);
 
 		if (ret) {
-			kvm_pgtable_stage2_unmap(pgt, memslot->base_gfn << PAGE_SHIFT,
+			kvm_pgtable_stage2_unmap(&pgt, memslot->base_gfn << PAGE_SHIFT,
 						 i << PAGE_SHIFT);
 			unpin_memslot_pages(memslot, writable);
 			goto out_err;
@@ -1439,7 +1484,7 @@ static int lock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	 */
 	ret = account_locked_vm(current->mm, npages, true);
 	if (ret) {
-		kvm_pgtable_stage2_unmap(pgt, memslot->base_gfn << PAGE_SHIFT,
+		kvm_pgtable_stage2_unmap(&pgt, memslot->base_gfn << PAGE_SHIFT,
 					 npages << PAGE_SHIFT);
 		unpin_memslot_pages(memslot, writable);
 		goto out_err;
@@ -1449,6 +1494,8 @@ static int lock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	if (writable)
 		memslot->arch.flags |= KVM_MEMSLOT_LOCK_WRITE;
 
+	set_bit(KVM_LOCKED_MEMSLOT_FLUSH_DCACHE, &kvm->arch.mmu_pending_ops);
+
 	kvm_mmu_free_memory_cache(&cache);
 
 	return 0;
-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
