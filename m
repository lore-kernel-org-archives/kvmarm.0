From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH] KVM: arm/arm64: Skip updating page table entry if no change
Date: Fri, 10 Aug 2018 12:13:00 +0100
Message-ID: <20180810111300.17144-1-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8986A49F89
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Aug 2018 07:13:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G27xtr01dwch for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Aug 2018 07:13:11 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 522F44086E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Aug 2018 07:13:11 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Contention on updating a page table entry by a large number of vcpus
can lead to duplicate work when handling stage 2 page faults. As the
page table update follows the break-before-make requirement of the
architecture, it can lead to repeated refaults due to clearing the
entry and flushing the tlbs.

This problem is more likely when -

* there are large number of vcpus
* the mapping is large block mapping

such as when using PMD hugepages (512MB) with 64k pages.

Fix this by skipping the page table update if there is no change in
the entry being updated.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Suzuki Poulose <suzuki.poulose@arm.com>
--
Hi,

This problem was reported by a user when testing PUD hugepages. During
VM restore when all threads are running cpu intensive workload, the
refauting was causing the VM to not make any forward progress.

This patch fixes the problem for PMD and PTE page fault handling.

Thanks,
Punit

Change-Id: I04c9aa8b9fbada47deb1a171c9959f400a0d2a21
---
 virt/kvm/arm/mmu.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 1d90d79706bd..a66a5441ca2f 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1027,6 +1027,18 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 	VM_BUG_ON(pmd_present(*pmd) && pmd_pfn(*pmd) != pmd_pfn(*new_pmd));
 
 	old_pmd = *pmd;
+	/*
+	 * Multiple vcpus faulting on the same PMD entry, can lead to
+	 * them sequentially updating the PMD with the same
+	 * value. Following the break-before-make (pmd_clear()
+	 * followed by tlb_flush()) process can hinder forward
+	 * progress due to refaults generated on missing translations.
+	 *
+	 * Skip updating the page table if the entry is unchanged.
+	 */
+	if (pmd_val(old_pmd) == pmd_val(*new_pmd))
+		return 0;
+
 	if (pmd_present(old_pmd)) {
 		pmd_clear(pmd);
 		kvm_tlb_flush_vmid_ipa(kvm, addr);
@@ -1101,6 +1113,10 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 
 	/* Create 2nd stage page table mapping - Level 3 */
 	old_pte = *pte;
+	/* Skip page table update if there is no change */
+	if (pte_val(old_pte) == pte_val(*new_pte))
+		return 0;
+
 	if (pte_present(old_pte)) {
 		kvm_set_pte(pte, __pte(0));
 		kvm_tlb_flush_vmid_ipa(kvm, addr);
-- 
2.18.0
