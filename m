From: Lukas Braun <koomi@moshbit.net>
Subject: [PATCH] KVM: arm/arm64: Check memslot bounds before mapping hugepages
Date: Tue,  4 Sep 2018 18:39:36 +0200
Message-ID: <20180904163937.12759-1-koomi@moshbit.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
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
 virt/kvm/arm/mmu.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index ed162a6c57c5..bdbec1d136a1 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1504,6 +1504,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		hugetlb = true;
 		gfn = (fault_ipa & PMD_MASK) >> PAGE_SHIFT;
 	} else {
+		unsigned long pmd_fn_mask = PTRS_PER_PMD - 1;
+
 		/*
 		 * Pages belonging to memslots that don't have the same
 		 * alignment for userspace and IPA cannot be mapped using
@@ -1513,8 +1515,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		 * unmapping, updates, and splits of the THP or other pages
 		 * in the stage-2 block range.
 		 */
-		if ((memslot->userspace_addr & ~PMD_MASK) !=
-		    ((memslot->base_gfn << PAGE_SHIFT) & ~PMD_MASK))
+		int aligned = ((memslot->userspace_addr & ~PMD_MASK) ==
+			((memslot->base_gfn << PAGE_SHIFT) & ~PMD_MASK));
+
+		/*
+		 * We also can't map a huge page if it would violate the bounds
+		 * of the containing memslot.
+		 */
+		int in_bounds = ((memslot->base_gfn <= (gfn & ~pmd_fn_mask)) &&
+			((memslot->base_gfn + memslot->npages) > (gfn | pmd_fn_mask)));
+
+		if (!aligned || !in_bounds)
 			force_pte = true;
 	}
 	up_read(&current->mm->mmap_sem);
-- 
2.11.0
