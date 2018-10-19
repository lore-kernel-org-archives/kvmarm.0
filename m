From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 22/26] KVM: arm/arm64: Ensure only THP is candidate for
 adjustment
Date: Fri, 19 Oct 2018 13:58:57 +0100
Message-ID: <20181019125901.185478-23-marc.zyngier@arm.com>
References: <20181019125901.185478-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0A5B4A2E5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 09:00:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WSScts2Flc9O for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Oct 2018 09:00:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E4B04A211
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 09:00:23 -0400 (EDT)
In-Reply-To: <20181019125901.185478-1-marc.zyngier@arm.com>
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
Cc: zhong jiang <zhongjiang@huawei.com>, kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Robin Murphy <robin.murphy@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Punit Agrawal <punit.agrawal@arm.com>

PageTransCompoundMap() returns true for hugetlbfs and THP
hugepages. This behaviour incorrectly leads to stage 2 faults for
unsupported hugepage sizes (e.g., 64K hugepage with 4K pages) to be
treated as THP faults.

Tighten the check to filter out hugetlbfs pages. This also leads to
consistently mapping all unsupported hugepage sizes as PTE level
entries at stage 2.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Reviewed-by: Suzuki Poulose <suzuki.poulose@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: stable@vger.kernel.org # v4.13+
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/mmu.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 7e477b3cae5b..c23a1b323aad 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1231,8 +1231,14 @@ static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
 {
 	kvm_pfn_t pfn = *pfnp;
 	gfn_t gfn = *ipap >> PAGE_SHIFT;
+	struct page *page = pfn_to_page(pfn);
 
-	if (PageTransCompoundMap(pfn_to_page(pfn))) {
+	/*
+	 * PageTransCompoungMap() returns true for THP and
+	 * hugetlbfs. Make sure the adjustment is done only for THP
+	 * pages.
+	 */
+	if (!PageHuge(page) && PageTransCompoundMap(page)) {
 		unsigned long mask;
 		/*
 		 * The address we faulted on is backed by a transparent huge
-- 
2.19.1
