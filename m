From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH] KVM: arm: Fix crash in free_hyp_pgds() if timer initialization
 fails
Date: Tue, 27 Oct 2015 10:40:08 +0300
Message-ID: <1445931608-8824-1-git-send-email-p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 996DC412D6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2015 03:37:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M+UgSZvpdktD for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2015 03:37:25 -0400 (EDT)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 91BA840FAB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2015 03:37:24 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NWV006WRBZ14L40@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 27 Oct 2015 07:40:13 +0000 (GMT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

After vGIC initialization succeeded, and timer initialization failed,
the following crash can be observed on ARM32:

kvm [1]: interrupt-controller@10484000 IRQ57
kvm [1]: kvm_arch_timer: can't find DT node
Unable to handle kernel paging request at virtual address 90484000
pgd = c0003000
[90484000] *pgd=80000040006003, *pmd=00000000
Internal error: Oops: 2a06 [#1] PREEMPT SMP ARM
...
[<c003b790>] (v7_flush_kern_dcache_area) from [<c001d638>] (kvm_flush_dcache_pte+0x48/0x5c)
[<c001d638>] (kvm_flush_dcache_pte) from [<c001d898>] (unmap_range+0x24c/0x460)
[<c001d898>] (unmap_range) from [<c001ea4c>] (free_hyp_pgds+0x84/0x160)
[<c001ea4c>] (free_hyp_pgds) from [<c001c85c>] (kvm_arch_init+0x254/0x41c)
[<c001c85c>] (kvm_arch_init) from [<c00122b0>] (kvm_init+0x28/0x2b4)
[<c00122b0>] (kvm_init) from [<c0009988>] (do_one_initcall+0x9c/0x200)

This happens when unmapping reaches mapped vGIC control registers. The
problem root seems to be combination of two facts:
1. vGIC control region is defined in device trees as having size of
   0x2000. But the specification defines only registers up to 0x1FC,
   therefore it is only one page, not two.
2. unmap_ptes() is expected to recognize device memory and omit cache
   flushing. However, it tests only for PAGE_S2_DEVICE, while devices
   mapped for HYP mode have PAGE_HYP_DEVICE, which is different.
   Therefore, cache flush is attempted, and it dies when hitting the
   nonexistent second page.

This patch fixes the problem by adding missing recognition of
PAGE_HYP_DEVICE protection value.

The crash can be observed on Exynos 5410 (and probably on all Exynos5
family) with stock device trees (using MCT) and CONFIG_KVM enabled.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 arch/arm/kvm/mmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 7b42012..839dd970 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -213,7 +213,10 @@ static void unmap_ptes(struct kvm *kvm, pmd_t *pmd,
 			kvm_tlb_flush_vmid_ipa(kvm, addr);
 
 			/* No need to invalidate the cache for device mappings */
-			if ((pte_val(old_pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE)
+			if (((pte_val(old_pte) & PAGE_S2_DEVICE)
+			     != PAGE_S2_DEVICE) &&
+			    ((pte_val(old_pte) & PAGE_HYP_DEVICE)
+			     != PAGE_HYP_DEVICE))
 				kvm_flush_dcache_pte(old_pte);
 
 			put_page(virt_to_page(pte));
-- 
2.4.4
