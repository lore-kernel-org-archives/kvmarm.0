From: Lukas Braun <koomi@moshbit.net>
Subject: [PATCH v2] KVM: arm/arm64: Check memslot bounds before mapping hugepages
Date: Wed, 26 Sep 2018 17:11:35 +0200
Message-ID: <20180926151135.16083-1-koomi@moshbit.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Cc: Ralph Palutke <ralph.palutke@fau.de>, Lukas Braun <koomi@moshbit.net>
List-Id: kvmarm@lists.cs.columbia.edu

Userspace can create a memslot with memory backed by (transparent)
hugepages, but with bounds that do not align with hugepages.
In that case, we cannot map the entire region in the guest as hugepages
without exposing additional host memory to the guest and potentially
interfering with other memslots.
Consequently, this patch adds a bounds check when populating guest page
tables and forces the creation of regular PTEs if mapping an entire
hugepage would violate the memslots bounds.

Signed-off-by: Lukas Braun <koomi@moshbit.net>
---

Hi everyone,

for v2, in addition to writing the condition the way Marc suggested, I
moved the whole check so it also catches the problem when the hugepage
was allocated explicitly, not only for THPs. The second line is quite
long, but splitting it up would make things rather ugly IMO, so I left
it as it is.

Regards,
Lukas


 virt/kvm/arm/mmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index ed162a6c57c5..ba77339e23ec 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1500,7 +1500,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
-	if (vma_kernel_pagesize(vma) == PMD_SIZE && !logging_active) {
+	if ((fault_ipa & S2_PMD_MASK) < (memslot->base_gfn << PAGE_SHIFT) ||
+	    ALIGN(fault_ipa, S2_PMD_SIZE) >= ((memslot->base_gfn + memslot->npages) << PAGE_SHIFT)) {
+		/* PMD entry would map something outside of the memslot */
+		force_pte = true;
+	} else if (vma_kernel_pagesize(vma) == PMD_SIZE && !logging_active) {
 		hugetlb = true;
 		gfn = (fault_ipa & PMD_MASK) >> PAGE_SHIFT;
 	} else {
-- 
2.11.0
