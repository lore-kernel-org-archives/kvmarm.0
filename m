From: Steve Capper <steve.capper@arm.com>
Subject: [PATCH 05/12] arm64: mm: Remove VMALLOC checks from
 update_mapping_prot(.)
Date: Mon,  4 Dec 2017 14:13:06 +0000
Message-ID: <20171204141313.31604-6-steve.capper@arm.com>
References: <20171204141313.31604-1-steve.capper@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E67949D78
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:10:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zJUo4WySfPmX for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Dec 2017 09:10:33 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 281F749D86
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:10:32 -0500 (EST)
In-Reply-To: <20171204141313.31604-1-steve.capper@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: catalin.marinas@arm.com, ard.biesheuvel@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

update_mapping_prot assumes that it will be used on the VA for the
kernel .text section. (Via the check virt >= VMALLOC_START)

Recent kdump patches employ this function to modify the protection of
the direct linear mapping (which is strictly speaking outside of this
area), via mark_linear_text_alias_ro(.).

We "get away" with this as the direct linear mapping currently follows
the VA for the kernel text, so the check passes.

This patch removes the check in update_mapping_prot allowing us to move
the kernel VA layout without spuriously firing the warning.

Signed-off-by: Steve Capper <steve.capper@arm.com>
---
 arch/arm64/mm/mmu.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 58b1ed6fd7ec..c8f486384fe3 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -383,12 +383,6 @@ void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
 				phys_addr_t size, pgprot_t prot)
 {
-	if (virt < VMALLOC_START) {
-		pr_warn("BUG: not updating mapping for %pa at 0x%016lx - outside kernel range\n",
-			&phys, virt);
-		return;
-	}
-
 	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL,
 			     NO_CONT_MAPPINGS);
 
-- 
2.11.0
