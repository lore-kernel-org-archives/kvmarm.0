Return-Path: <SRS0=u4Cy=NQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84CCCC4338F
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:17:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 294D26113A
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:17:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 294D26113A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1E454B23F;
	Wed, 25 Aug 2021 12:17:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zu9GTNgnn5gS; Wed, 25 Aug 2021 12:17:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6385E4B265;
	Wed, 25 Aug 2021 12:17:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3BE14B231
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:17:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6QD-YRj7IY6R for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Aug 2021 12:17:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97C554B204
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:17:17 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06BA11063;
 Wed, 25 Aug 2021 09:17:17 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AB1C33F66F;
 Wed, 25 Aug 2021 09:17:15 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 03/39] KVM: arm64: Implement the memslot lock/unlock
 functionality
Date: Wed, 25 Aug 2021 17:17:39 +0100
Message-Id: <20210825161815.266051-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210825161815.266051-1-alexandru.elisei@arm.com>
References: <20210825161815.266051-1-alexandru.elisei@arm.com>
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

Pin memory in the process address space and map it in the stage 2 tables as
a result of userspace enabling the KVM_CAP_ARM_LOCK_USER_MEMORY_REGION
capability; and unpin it from the process address space when the capability
is used with the KVM_ARM_LOCK_USER_MEMORY_REGION_FLAGS_UNLOCK flag.

The current implementation has two drawbacks which will be fixed in future
patches:

- The dcache maintenance is done when the memslot is locked, which means
  that it is possible that memory changes made by userspace after the ioctl
  completes won't be visible to a guest running with the MMU off.

- Tag scrubbing is done when the memslot is locked. If the MTE capability
  is enabled after the ioctl, the guest will be able to access unsanitised
  pages. This is prevented by forbidding userspace to enable the MTE
  capability if any memslots are locked.

Only PAGE_SIZE mappings are supported at stage 2.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/virt/kvm/api.rst    |   8 +-
 arch/arm64/include/asm/kvm_host.h |  11 ++
 arch/arm64/kvm/arm.c              |  22 ++++
 arch/arm64/kvm/mmu.c              | 211 +++++++++++++++++++++++++++++-
 4 files changed, 245 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 741327ef06b0..5aa251df7077 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6717,10 +6717,10 @@ mapped at stage 2. The permissions specified in args[1] apply to both
 mappings. The memory pinned with this capability counts towards the max
 locked memory limit for the current process.
 
-The capability must be enabled before any VCPUs have run. The virtual memory
-range described by the memslot must be mapped in the userspace process without
-any gaps. It is considered an error if write permissions are specified for a
-memslot which logs dirty pages.
+The capability must be enabled before any VCPUs have run. The entire virtual
+memory range described by the memslot must be mapped by the userspace process.
+It is considered an error if write permissions are specified for a memslot which
+logs dirty pages.
 
 7.29.2 KVM_ARM_LOCK_USER_MEMORY_REGION_FLAGS_UNLOCK
 ---------------------------------------------------
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 797083203603..97ff3ed5d4b7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -98,7 +98,18 @@ struct kvm_s2_mmu {
 	struct kvm_arch *arch;
 };
 
+#define KVM_MEMSLOT_LOCK_READ		(1 << 0)
+#define KVM_MEMSLOT_LOCK_WRITE		(1 << 1)
+#define KVM_MEMSLOT_LOCK_MASK		0x3
+
+struct kvm_memory_slot_page {
+	struct list_head list;
+	struct page *page;
+};
+
 struct kvm_arch_memory_slot {
+	struct kvm_memory_slot_page pages;
+	u32 flags;
 };
 
 struct kvm_arch {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 57ac97b30b3d..efb3501c6016 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -108,6 +108,25 @@ static int kvm_lock_user_memory_region_ioctl(struct kvm *kvm,
 	}
 }
 
+static bool kvm_arm_has_locked_memslots(struct kvm *kvm)
+{
+	struct kvm_memslots *slots = kvm_memslots(kvm);
+	struct kvm_memory_slot *memslot;
+	bool has_locked_memslots = false;
+	int idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	kvm_for_each_memslot(memslot, slots) {
+		if (memslot->arch.flags & KVM_MEMSLOT_LOCK_MASK) {
+			has_locked_memslots = true;
+			break;
+		}
+	}
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	return has_locked_memslots;
+}
+
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
@@ -123,6 +142,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	case KVM_CAP_ARM_MTE:
 		if (!system_supports_mte() || kvm->created_vcpus)
 			return -EINVAL;
+		if (kvm_arm_lock_memslot_supported() &&
+		    kvm_arm_has_locked_memslots(kvm))
+			return -EPERM;
 		r = 0;
 		kvm->arch.mte_enabled = true;
 		break;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 689b24cb0f10..59c2bfef2fd1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -72,6 +72,11 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
 	return memslot->dirty_bitmap && !(memslot->flags & KVM_MEM_READONLY);
 }
 
+static bool memslot_is_locked(struct kvm_memory_slot *memslot)
+{
+	return memslot->arch.flags & KVM_MEMSLOT_LOCK_MASK;
+}
+
 /**
  * kvm_flush_remote_tlbs() - flush all VM TLB entries for v7/8
  * @kvm:	pointer to kvm structure.
@@ -722,6 +727,10 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
 	if (map_size == PAGE_SIZE)
 		return true;
 
+	/* Allow only PAGE_SIZE mappings for locked memslots */
+	if (memslot_is_locked(memslot))
+		return false;
+
 	size = memslot->npages * PAGE_SIZE;
 
 	gpa_start = memslot->base_gfn << PAGE_SHIFT;
@@ -1244,6 +1253,159 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static int try_rlimit_memlock(unsigned long npages)
+{
+	unsigned long lock_limit;
+	bool has_lock_cap;
+	int ret = 0;
+
+	has_lock_cap = capable(CAP_IPC_LOCK);
+	if (has_lock_cap)
+		goto out;
+
+	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+
+	mmap_read_lock(current->mm);
+	if (npages + current->mm->locked_vm > lock_limit)
+		ret = -ENOMEM;
+	mmap_read_unlock(current->mm);
+
+out:
+	return ret;
+}
+
+static void unpin_memslot_pages(struct kvm_memory_slot *memslot, bool writable)
+{
+	struct kvm_memory_slot_page *entry, *tmp;
+
+	list_for_each_entry_safe(entry, tmp, &memslot->arch.pages.list, list) {
+		if (writable)
+			set_page_dirty_lock(entry->page);
+		unpin_user_page(entry->page);
+		kfree(entry);
+	}
+}
+
+static int lock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot,
+			u64 flags)
+{
+	struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
+	struct kvm_memory_slot_page *page_entry;
+	bool writable = flags & KVM_ARM_LOCK_MEM_WRITE;
+	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
+	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
+	struct vm_area_struct *vma;
+	unsigned long npages = memslot->npages;
+	unsigned int pin_flags = FOLL_LONGTERM;
+	unsigned long i, hva, ipa, mmu_seq;
+	int ret;
+
+	ret = try_rlimit_memlock(npages);
+	if (ret)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&memslot->arch.pages.list);
+
+	if (writable) {
+		prot |= KVM_PGTABLE_PROT_W;
+		pin_flags |= FOLL_WRITE;
+	}
+
+	hva = memslot->userspace_addr;
+	ipa = memslot->base_gfn << PAGE_SHIFT;
+
+	mmu_seq = kvm->mmu_notifier_seq;
+	smp_rmb();
+
+	for (i = 0; i < npages; i++) {
+		page_entry = kzalloc(sizeof(*page_entry), GFP_KERNEL);
+		if (!page_entry) {
+			unpin_memslot_pages(memslot, writable);
+			ret = -ENOMEM;
+			goto out_err;
+		}
+
+		mmap_read_lock(current->mm);
+		ret = pin_user_pages(hva, 1, pin_flags, &page_entry->page, &vma);
+		if (ret != 1) {
+			mmap_read_unlock(current->mm);
+			unpin_memslot_pages(memslot, writable);
+			ret = -ENOMEM;
+			goto out_err;
+		}
+		if (kvm_has_mte(kvm)) {
+			if (vma->vm_flags & VM_SHARED) {
+				ret = -EFAULT;
+			} else {
+				ret = sanitise_mte_tags(kvm,
+					page_to_pfn(page_entry->page),
+					PAGE_SIZE);
+			}
+			if (ret) {
+				mmap_read_unlock(current->mm);
+				goto out_err;
+			}
+		}
+		mmap_read_unlock(current->mm);
+
+		ret = kvm_mmu_topup_memory_cache(&cache, kvm_mmu_cache_min_pages(kvm));
+		if (ret) {
+			unpin_memslot_pages(memslot, writable);
+			goto out_err;
+		}
+
+		spin_lock(&kvm->mmu_lock);
+		if (mmu_notifier_retry(kvm, mmu_seq)) {
+			spin_unlock(&kvm->mmu_lock);
+			unpin_memslot_pages(memslot, writable);
+			ret = -EAGAIN;
+			goto out_err;
+		}
+
+		ret = kvm_pgtable_stage2_map(pgt, ipa, PAGE_SIZE,
+					     page_to_phys(page_entry->page),
+					     prot, &cache);
+		spin_unlock(&kvm->mmu_lock);
+
+		if (ret) {
+			kvm_pgtable_stage2_unmap(pgt, memslot->base_gfn << PAGE_SHIFT,
+						 i << PAGE_SHIFT);
+			unpin_memslot_pages(memslot, writable);
+			goto out_err;
+		}
+		list_add(&page_entry->list, &memslot->arch.pages.list);
+
+		hva += PAGE_SIZE;
+		ipa += PAGE_SIZE;
+	}
+
+
+	/*
+	 * Even though we've checked the limit at the start, we can still exceed
+	 * it if userspace locked other pages in the meantime or if the
+	 * CAP_IPC_LOCK capability has been revoked.
+	 */
+	ret = account_locked_vm(current->mm, npages, true);
+	if (ret) {
+		kvm_pgtable_stage2_unmap(pgt, memslot->base_gfn << PAGE_SHIFT,
+					 npages << PAGE_SHIFT);
+		unpin_memslot_pages(memslot, writable);
+		goto out_err;
+	}
+
+	memslot->arch.flags = KVM_MEMSLOT_LOCK_READ;
+	if (writable)
+		memslot->arch.flags |= KVM_MEMSLOT_LOCK_WRITE;
+
+	kvm_mmu_free_memory_cache(&cache);
+
+	return 0;
+
+out_err:
+	kvm_mmu_free_memory_cache(&cache);
+	return ret;
+}
+
 int kvm_mmu_lock_memslot(struct kvm *kvm, u64 slot, u64 flags)
 {
 	struct kvm_memory_slot *memslot;
@@ -1283,7 +1445,12 @@ int kvm_mmu_lock_memslot(struct kvm *kvm, u64 slot, u64 flags)
 		goto out_unlock_slots;
 	}
 
-	ret = -EINVAL;
+	if (memslot_is_locked(memslot)) {
+		ret = -EBUSY;
+		goto out_unlock_slots;
+	}
+
+	ret = lock_memslot(kvm, memslot, flags);
 
 out_unlock_slots:
 	mutex_unlock(&kvm->slots_lock);
@@ -1294,13 +1461,51 @@ int kvm_mmu_lock_memslot(struct kvm *kvm, u64 slot, u64 flags)
 	return ret;
 }
 
+static int unlock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot)
+{
+	bool writable = memslot->arch.flags & KVM_MEMSLOT_LOCK_WRITE;
+	unsigned long npages = memslot->npages;
+
+	unpin_memslot_pages(memslot, writable);
+	account_locked_vm(current->mm, npages, false);
+
+	memslot->arch.flags &= ~KVM_MEMSLOT_LOCK_MASK;
+
+	return 0;
+}
+
+static int unlock_all_memslots(struct kvm *kvm)
+{
+	struct kvm_memory_slot *memslot;
+	int err, ret;
+
+	mutex_lock(&kvm->slots_lock);
+
+	ret = 0;
+	kvm_for_each_memslot(memslot, kvm_memslots(kvm)) {
+		if (!memslot_is_locked(memslot))
+			continue;
+		err = unlock_memslot(kvm, memslot);
+		if (err) {
+			kvm_err("error unlocking memslot %u: %d\n",
+				memslot->id, err);
+			/* Continue to try unlocking the rest of the slots */
+			ret = err;
+		}
+	}
+
+	mutex_unlock(&kvm->slots_lock);
+
+	return ret;
+}
+
 int kvm_mmu_unlock_memslot(struct kvm *kvm, u64 slot, u64 flags)
 {
 	struct kvm_memory_slot *memslot;
 	int ret;
 
 	if (flags & KVM_ARM_UNLOCK_MEM_ALL)
-		return -EINVAL;
+		return unlock_all_memslots(kvm);
 
 	if (slot >= KVM_MEM_SLOTS_NUM)
 		return -EINVAL;
@@ -1313,7 +1518,7 @@ int kvm_mmu_unlock_memslot(struct kvm *kvm, u64 slot, u64 flags)
 		goto out_unlock_slots;
 	}
 
-	ret = -EINVAL;
+	ret = unlock_memslot(kvm, memslot);
 
 out_unlock_slots:
 	mutex_unlock(&kvm->slots_lock);
-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
