From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] KVM: arm/arm64: Clean dcache to PoC when changing PTE due to
 CoW
Date: Thu, 23 Aug 2018 16:33:42 +0100
Message-ID: <20180823153342.158230-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA0254A22B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 11:33:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NCXNhh6G2E0N for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Aug 2018 11:33:58 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F8A54A209
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 11:33:58 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Mike Galbraith <efault@gmx.de>
List-Id: kvmarm@lists.cs.columbia.edu

When triggering a CoW, we unmap the RO page via an MMU notifier
(invalidate_range_start), and then populate the new PTE using another
one (change_pte). In the meantime, we'll have copied the old page
into the new one.

The problem is that the data for the new page is sitting in the
cache, and should the guest have an uncached mapping to that page
(or its MMU off), following accesses will bypass the cache.

In a way, this is similar to what happens on a translation fault:
We need to clean the page to the PoC before mapping it. So let's just
do that.

This fixes a KVM unit test regression observed on a HiSilicon platform,
and subsequently reproduced on Seattle.

Fixes: a9c0e12ebee5 ("KVM: arm/arm64: Only clean the dcache on translation fault")
Reported-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/mmu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 1d90d79706bd..287c8e274655 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1811,13 +1811,20 @@ static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data
 void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 {
 	unsigned long end = hva + PAGE_SIZE;
+	kvm_pfn_t pfn = pte_pfn(pte);
 	pte_t stage2_pte;
 
 	if (!kvm->arch.pgd)
 		return;
 
 	trace_kvm_set_spte_hva(hva);
-	stage2_pte = pfn_pte(pte_pfn(pte), PAGE_S2);
+
+	/*
+	 * We've moved a page around, probably through CoW, so let's treat
+	 * just like a translation fault and clean the cache to the PoC.
+	 */
+	clean_dcache_guest_page(pfn, PAGE_SIZE);
+	stage2_pte = pfn_pte(pfn, PAGE_S2);
 	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &stage2_pte);
 }
 
-- 
2.18.0
