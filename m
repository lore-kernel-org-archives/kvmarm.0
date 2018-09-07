From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PULL RESEND v2 1/4] KVM: arm/arm64: Clean dcache to PoC when changing PTE due to CoW
Date: Fri,  7 Sep 2018 15:12:53 +0200
Message-ID: <20180907131256.2412-2-christoffer.dall@arm.com>
References: <20180907131256.2412-1-christoffer.dall@arm.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180907131256.2412-1-christoffer.dall@arm.com>
Sender: stable-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, Christoffer Dall <christoffer.dall@arm.com>
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
Cc: stable@vger.kernel.org # v4.16+
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
