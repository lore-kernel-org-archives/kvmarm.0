From: Andrew Jones <drjones@redhat.com>
Subject: [RFC PATCH 2/3] arm/arm64: KVM: decouple READONLY and UNCACHED
Date: Wed, 18 Mar 2015 15:10:32 -0400
Message-ID: <1426705833-2679-3-git-send-email-drjones@redhat.com>
References: <1426705700-2564-1-git-send-email-drjones@redhat.com>
 <1426705833-2679-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40B4349190
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Mar 2015 15:04:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nzULEQbvdOSJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Mar 2015 15:04:03 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D508A4918F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Mar 2015 15:04:02 -0400 (EDT)
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

KVM_MEM_UNCACHED memory will no longer need caches to be flushed
for memory as it's faulted in. Just use READONLY directly, in that
case, now.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm/kvm/mmu.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 719931e83c468..59af5ad779eb6 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1260,7 +1260,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (!hugetlb && !force_pte)
 		hugetlb = transparent_hugepage_adjust(&pfn, &fault_ipa);
 
-	fault_ipa_uncached = memslot->flags & KVM_MEM_UNCACHED;
+	/*
+	 * Readonly memslots are not incoherent with the caches by definition,
+	 * but in practice, they are used mostly to emulate ROMs or NOR flashes
+	 * that the guest may consider devices and hence map as uncached.
+	 * To prevent incoherency issues in these cases, force dcache flushes
+	 * for all pages in the region as they're faulted in.
+	 */
+	fault_ipa_uncached = (memslot->flags & KVM_MEM_READONLY) &&
+				!(memslot->flags & KVM_MEM_UNCACHED);
 
 	if (hugetlb) {
 		pmd_t new_pmd = pfn_pmd(pfn, mem_type);
@@ -1784,15 +1792,6 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 			    unsigned long npages)
 {
-	/*
-	 * Readonly memslots are not incoherent with the caches by definition,
-	 * but in practice, they are used mostly to emulate ROMs or NOR flashes
-	 * that the guest may consider devices and hence map as uncached.
-	 * To prevent incoherency issues in these cases, tag all readonly
-	 * regions as incoherent.
-	 */
-	if (slot->flags & KVM_MEM_READONLY)
-		slot->flags |= KVM_MEM_UNCACHED;
 	return 0;
 }
 
-- 
1.8.3.1
