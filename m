From: Steve Capper <steve.capper@arm.com>
Subject: [PATCH V2 4/7] arm64: mm: Replace fixed map BUILD_BUG_ON's with
 BUG_ON's
Date: Mon, 18 Dec 2017 21:47:33 +0000
Message-ID: <20171218214736.13761-5-steve.capper@arm.com>
References: <20171218214736.13761-1-steve.capper@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A6B249DBC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 16:44:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7JYyrIKprE0l for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Dec 2017 16:44:13 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9733949DC8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 16:44:12 -0500 (EST)
In-Reply-To: <20171218214736.13761-1-steve.capper@arm.com>
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

In order to prepare for a variable VA_BITS we need to account for a
variable size VMEMMAP which in turn means the position of the fixed map
is variable at compile time.

Thus, we need to replace the BUILD_BUG_ON's that check the fixed map
position with BUG_ON's.

Signed-off-by: Steve Capper <steve.capper@arm.com>
---
 arch/arm64/mm/mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 5a16e2b9b1a2..7c04479a809a 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -760,7 +760,7 @@ void __init early_fixmap_init(void)
 	 * The boot-ioremap range spans multiple pmds, for which
 	 * we are not prepared:
 	 */
-	BUILD_BUG_ON((__fix_to_virt(FIX_BTMAP_BEGIN) >> PMD_SHIFT)
+	BUG_ON((__fix_to_virt(FIX_BTMAP_BEGIN) >> PMD_SHIFT)
 		     != (__fix_to_virt(FIX_BTMAP_END) >> PMD_SHIFT));
 
 	if ((pmd != fixmap_pmd(fix_to_virt(FIX_BTMAP_BEGIN)))
@@ -828,9 +828,9 @@ void *__init __fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot)
 	 * On 4k pages, we'll use section mappings for the FDT so we only
 	 * have to be in the same PUD.
 	 */
-	BUILD_BUG_ON(dt_virt_base % SZ_2M);
+	BUG_ON(dt_virt_base % SZ_2M);
 
-	BUILD_BUG_ON(__fix_to_virt(FIX_FDT_END) >> SWAPPER_TABLE_SHIFT !=
+	BUG_ON(__fix_to_virt(FIX_FDT_END) >> SWAPPER_TABLE_SHIFT !=
 		     __fix_to_virt(FIX_BTMAP_BEGIN) >> SWAPPER_TABLE_SHIFT);
 
 	offset = dt_phys % SWAPPER_BLOCK_SIZE;
-- 
2.11.0
