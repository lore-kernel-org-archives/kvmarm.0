From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PULL 1/4] KVM: arm/arm64: Clean dcache to PoC when changing PTE due
 to CoW
Date: Mon,  3 Sep 2018 15:45:13 +0200
Message-ID: <20180903134516.17796-2-christoffer.dall@arm.com>
References: <20180903134516.17796-1-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B045C4A1E6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 09:45:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uAUbvKJzvgnG for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Sep 2018 09:45:23 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D690B4A1FB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 09:45:23 -0400 (EDT)
In-Reply-To: <20180903134516.17796-1-christoffer.dall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

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
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 virt/kvm/arm/mmu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 91aaf73b00df..111a660be3be 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1860,13 +1860,20 @@ static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data
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
+	 * We've moved a page around, probably through CoW, so let's treat it
+	 * just like a translation fault and clean the cache to the PoC.
+	 */
+	clean_dcache_guest_page(pfn, PAGE_SIZE);
+	stage2_pte = pfn_pte(pfn, PAGE_S2);
 	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &stage2_pte);
 }
 
-- 
2.18.0
