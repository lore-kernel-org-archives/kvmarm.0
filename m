From: Andrew Jones <drjones@redhat.com>
Subject: [RFC PATCH 1/6] kvm: promote KVM_MEMSLOT_INCOHERENT to uapi
Date: Fri,  6 Mar 2015 13:52:28 -0500
Message-ID: <1425667953-3566-2-git-send-email-drjones@redhat.com>
References: <1425667780-3449-1-git-send-email-drjones@redhat.com>
 <1425667953-3566-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE29347FC9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:46:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jqS8JsFBBpdj for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Mar 2015 13:46:34 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 86B5D47F41
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:46:34 -0500 (EST)
In-Reply-To: <1425667953-3566-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org
Cc: pbonzini@redhat.com, lersek@redhat.com, catalin.marinas@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm/kvm/mmu.c       | 9 +++++++--
 include/linux/kvm_host.h | 1 -
 include/uapi/linux/kvm.h | 1 +
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index bcc1b3ad2adce..a806e8cecc01b 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1260,7 +1260,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (!hugetlb && !force_pte)
 		hugetlb = transparent_hugepage_adjust(&pfn, &fault_ipa);
 
-	fault_ipa_uncached = memslot->flags & KVM_MEMSLOT_INCOHERENT;
+	fault_ipa_uncached = memslot->flags & KVM_MEM_INCOHERENT;
 
 	if (hugetlb) {
 		pmd_t new_pmd = pfn_pmd(pfn, mem_type);
@@ -1784,15 +1784,20 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 			    unsigned long npages)
 {
+#if 1
 	/*
 	 * Readonly memslots are not incoherent with the caches by definition,
 	 * but in practice, they are used mostly to emulate ROMs or NOR flashes
 	 * that the guest may consider devices and hence map as uncached.
 	 * To prevent incoherency issues in these cases, tag all readonly
 	 * regions as incoherent.
+	 *
+	 * This heuristic can be removed after userspace has been updated to
+	 * use KVM_MEM_INCOHERENT on readonly regions when necessary.
 	 */
 	if (slot->flags & KVM_MEM_READONLY)
-		slot->flags |= KVM_MEMSLOT_INCOHERENT;
+		slot->flags |= KVM_MEM_INCOHERENT;
+#endif
 	return 0;
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3b934cc94cc83..9dfb519c51e5b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -43,7 +43,6 @@
  * include/linux/kvm_h.
  */
 #define KVM_MEMSLOT_INVALID	(1UL << 16)
-#define KVM_MEMSLOT_INCOHERENT	(1UL << 17)
 
 /* Two fragments for cross MMIO pages. */
 #define KVM_MAX_MMIO_FRAGMENTS	2
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a37fd1224f363..f7f9432bcf485 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -108,6 +108,7 @@ struct kvm_userspace_memory_region {
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_INCOHERENT	(1UL << 2)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
-- 
1.8.3.1
