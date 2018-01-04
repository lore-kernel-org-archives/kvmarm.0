From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH] KVM: arm/arm64: Check pagesize when allocating a hugepage at
 Stage 2
Date: Thu,  4 Jan 2018 18:24:33 +0000
Message-ID: <20180104182433.3790-1-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02D9E49DBD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jan 2018 13:20:17 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CxW5bBe3RzBL for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Jan 2018 13:20:15 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD17049D2B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jan 2018 13:20:15 -0500 (EST)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

KVM only supports PMD hugepages at stage 2 but doesn't actually check
that the provided hugepage memory pagesize is PMD_SIZE before populating
stage 2 entries.

In cases where the backing hugepage size is smaller than PMD_SIZE (such
as when using contiguous hugepages), KVM can end up creating stage 2
mappings that extend beyond the supplied memory.

Fix this by checking for the pagesize of userspace vma before creating
PMD hugepage at stage 2.

Fixes: ad361f093c1e31d ("KVM: ARM: Support hugetlbfs backed huge pages")
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index b4b69c2d1012..9dea96380339 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1310,7 +1310,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
-	if (is_vm_hugetlb_page(vma) && !logging_active) {
+	if (vma_kernel_pagesize(vma) == PMD_SIZE && !logging_active) {
 		hugetlb = true;
 		gfn = (fault_ipa & PMD_MASK) >> PAGE_SHIFT;
 	} else {
-- 
2.15.1
