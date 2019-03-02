From: Zenghui Yu <yuzenghui@huawei.com>
Subject: [RFC PATCH] KVM: arm64: Force a PTE mapping when logging is enabled
Date: Sat, 2 Mar 2019 03:35:28 +0000
Message-ID: <1551497728-12576-1-git-send-email-yuzenghui@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: christoffer.dall@arm.com, marc.zyngier@arm.com
Cc: james.morse@arm.com, julien.thierry@arm.com, suzuki.poulose@arm.com, wanghaibin.wang@huawei.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>, Punit Agrawal <punit.agrawal@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The idea behind this is: we don't want to keep tracking of huge pages when
logging_active is true, which will result in performance degradation.  We
still need to set vma_pagesize to PAGE_SIZE, so that we can make use of it
to force a PTE mapping.

Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Punit Agrawal <punit.agrawal@arm.com>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>

---
Atfer looking into https://patchwork.codeaurora.org/patch/647985/ , the
"vma_pagesize = PAGE_SIZE" logic was not intended to be deleted. As far
as I can tell, we used to have "hugetlb" to force the PTE mapping, but
we have "vma_pagesize" currently instead. We should set it properly for
performance reasons (e.g, in VM migration). Did I miss something important?

---
 virt/kvm/arm/mmu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 30251e2..7d41b16 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1705,6 +1705,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	     (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm))) &&
 	    !force_pte) {
 		gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
+	} else {
+		/*
+		 * Fallback to PTE if it's not one of the stage2
+		 * supported hugepage sizes or the corresponding level
+		 * doesn't exist, or logging is enabled.
+		 */
+		vma_pagesize = PAGE_SIZE;
 	}
 	up_read(&current->mm->mmap_sem);
 
-- 
1.8.3.1
