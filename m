From: Andrew Jones <drjones@redhat.com>
Subject: [RFC PATCH 3/3] arm/arm64: KVM: implement KVM_MEM_UNCACHED
Date: Wed, 18 Mar 2015 15:10:33 -0400
Message-ID: <1426705833-2679-4-git-send-email-drjones@redhat.com>
References: <1426705700-2564-1-git-send-email-drjones@redhat.com>
 <1426705833-2679-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 570AB491AC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Mar 2015 15:04:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HFaReqvWHnLp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Mar 2015 15:04:05 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E3EE249190
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Mar 2015 15:04:04 -0400 (EDT)
In-Reply-To: <1426705833-2679-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com
Cc: catalin.marinas@arm.com, lersek@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

When userspace tells us a memory region is uncached, then we
need to pin all its pages and set them all to be uncached.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm/include/asm/kvm_mmu.h    |  9 +++++
 arch/arm/include/uapi/asm/kvm.h   |  1 +
 arch/arm/kvm/mmu.c                | 71 +++++++++++++++++++++++++++++++++++++++
 arch/arm64/include/asm/kvm_mmu.h  |  9 +++++
 arch/arm64/include/uapi/asm/kvm.h |  1 +
 5 files changed, 91 insertions(+)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 37ca2a4c6f094..6802f6adc12bf 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -265,6 +265,15 @@ static inline void __kvm_flush_dcache_pud(pud_t pud)
 {
 }
 
+static inline void __set_page_uncached(pte_t *ptep)
+{
+	pte_t pte = *ptep;
+
+	pte = clear_pte_bit(pte, L_PTE_MT_MASK);
+	pte = set_pte_bit(pte, L_PTE_MT_UNCACHED);
+	set_pte_ext(ptep, pte, 0);
+}
+
 #define kvm_virt_to_phys(x)		virt_to_idmap((unsigned long)(x))
 
 void kvm_set_way_flush(struct kvm_vcpu *vcpu);
diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 9d6fc19acf8a2..cdd456f591882 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -109,6 +109,7 @@ struct kvm_sync_regs {
 };
 
 struct kvm_arch_memory_slot {
+	struct page **pages;
 };
 
 /* If you need to interpret the index values, here is the key: */
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 59af5ad779eb6..d4e47572d3a5d 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1697,6 +1697,54 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 		kvm_mmu_wp_memory_region(kvm, mem->slot);
 }
 
+static int set_page_uncached(pte_t *ptep, pgtable_t token,
+			     unsigned long addr, void *data)
+{
+	__set_page_uncached(ptep);
+	kvm_flush_dcache_pte(*ptep);
+	return 0;
+}
+
+static int vma_range_pin_and_set_uncached(struct vm_area_struct *vma,
+					  hva_t start, long nr_pages,
+					  struct page **pages)
+{
+	unsigned long size = nr_pages * PAGE_SIZE;
+	int ret;
+
+	down_read(&vma->vm_mm->mmap_sem);
+	ret = get_user_pages(NULL, vma->vm_mm, start, nr_pages,
+			     true, true, pages, NULL);
+	up_read(&vma->vm_mm->mmap_sem);
+
+	if (ret < 0)
+		return ret;
+
+	if (ret == nr_pages) {
+		ret = apply_to_page_range(vma->vm_mm, start, size,
+					  set_page_uncached, NULL);
+		flush_tlb_kernel_range(start, start + size);
+		return ret;
+	}
+
+	return -EFAULT;
+}
+
+static void unpin_pages(struct kvm_memory_slot *memslot)
+{
+	int i;
+
+	if (!memslot->arch.pages)
+		return;
+
+	for (i = 0; i < memslot->npages; ++i) {
+		if (memslot->arch.pages[i])
+			put_page(memslot->arch.pages[i]);
+	}
+	kfree(memslot->arch.pages);
+	memslot->arch.pages = NULL;
+}
+
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *memslot,
 				   struct kvm_userspace_memory_region *mem,
@@ -1705,6 +1753,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	hva_t hva = mem->userspace_addr;
 	hva_t reg_end = hva + mem->memory_size;
 	bool writable = !(mem->flags & KVM_MEM_READONLY);
+	struct page **pages = memslot->arch.pages;
 	int ret = 0;
 
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
@@ -1768,6 +1817,26 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 						    writable);
 			if (ret)
 				break;
+		} else if ((change != KVM_MR_FLAGS_ONLY)
+				&& (memslot->flags & KVM_MEM_UNCACHED)) {
+
+			long nr_pages = (vm_end - vm_start)/PAGE_SIZE;
+
+			if (!pages) {
+				pages = kzalloc(memslot->npages *
+					sizeof(struct page *), GFP_KERNEL);
+				if (!pages)
+					return -ENOMEM;
+				memslot->arch.pages = pages;
+			}
+
+			ret = vma_range_pin_and_set_uncached(vma, vm_start,
+							nr_pages, pages);
+			if (ret) {
+				unpin_pages(memslot);
+				break;
+			}
+			pages += nr_pages;
 		}
 		hva = vm_end;
 	} while (hva < reg_end);
@@ -1787,6 +1856,8 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 			   struct kvm_memory_slot *dont)
 {
+	if (free->flags & KVM_MEM_UNCACHED)
+		unpin_pages(free);
 }
 
 int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 6458b53731421..f4c3c56587a9f 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -300,6 +300,15 @@ static inline void __kvm_flush_dcache_pud(pud_t pud)
 	kvm_flush_dcache_to_poc(page_address(page), PUD_SIZE);
 }
 
+static inline void __set_page_uncached(pte_t *ptep)
+{
+	pte_t pte = *ptep;
+
+	pte = clear_pte_bit(pte, PTE_ATTRINDX_MASK);
+	pte = set_pte_bit(pte, PTE_ATTRINDX(MT_DEVICE_nGnRnE));
+	set_pte(ptep, pte);
+}
+
 #define kvm_virt_to_phys(x)		__virt_to_phys((unsigned long)(x))
 
 void kvm_set_way_flush(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 5553d112e405b..22b4e4a6da950 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -104,6 +104,7 @@ struct kvm_sync_regs {
 };
 
 struct kvm_arch_memory_slot {
+	struct page **pages;
 };
 
 /* If you need to interpret the index values, here is the key: */
-- 
1.8.3.1
