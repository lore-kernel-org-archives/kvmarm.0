From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 2/5] arm64: mmu: move TLB maintenance from callers to
 create_mapping_late()
Date: Tue, 14 Feb 2017 20:52:35 +0000
Message-ID: <1487105558-21897-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1487105558-21897-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE13C40992
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Feb 2017 15:54:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WXGAtJStLgfr for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Feb 2017 15:54:07 -0500 (EST)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E99CE40A74
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Feb 2017 15:54:06 -0500 (EST)
Received: by mail-wm0-f51.google.com with SMTP id r141so26914741wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Feb 2017 12:54:51 -0800 (PST)
In-Reply-To: <1487105558-21897-1-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, labbott@fedoraproject.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, keescook@chromium.org, marc.zyngier@arm.com, andre.przywara@arm.com, kernel-hardening@lists.openwall.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

In preparation of refactoring the kernel mapping logic so that text regions
are never mapped writable, which would require adding explicit TLB
maintenance to new call sites of create_mapping_late() (which is currently
invoked twice from the same function), move the TLB maintenance from the
call site into create_mapping_late() itself, and change it from a full
TLB flush into a flush by VA, which is more appropriate here.

Also, given that create_mapping_late() has evolved into a routine that only
updates protection bits on existing mappings, rename it to
update_mapping_prot()

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/mm/mmu.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 2131521ddc24..a98419b72a09 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -345,17 +345,20 @@ void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 			     pgd_pgtable_alloc, page_mappings_only);
 }
 
-static void create_mapping_late(phys_addr_t phys, unsigned long virt,
-				  phys_addr_t size, pgprot_t prot)
+static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
+				phys_addr_t size, pgprot_t prot)
 {
 	if (virt < VMALLOC_START) {
-		pr_warn("BUG: not creating mapping for %pa at 0x%016lx - outside kernel range\n",
+		pr_warn("BUG: not updating mapping for %pa at 0x%016lx - outside kernel range\n",
 			&phys, virt);
 		return;
 	}
 
 	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot,
 			     NULL, debug_pagealloc_enabled());
+
+	/* flush the TLBs after updating live kernel mappings */
+	flush_tlb_kernel_range(virt, virt + size);
 }
 
 static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end)
@@ -428,19 +431,16 @@ void mark_rodata_ro(void)
 	unsigned long section_size;
 
 	section_size = (unsigned long)_etext - (unsigned long)_text;
-	create_mapping_late(__pa_symbol(_text), (unsigned long)_text,
+	update_mapping_prot(__pa_symbol(_text), (unsigned long)_text,
 			    section_size, PAGE_KERNEL_ROX);
 	/*
 	 * mark .rodata as read only. Use __init_begin rather than __end_rodata
 	 * to cover NOTES and EXCEPTION_TABLE.
 	 */
 	section_size = (unsigned long)__init_begin - (unsigned long)__start_rodata;
-	create_mapping_late(__pa_symbol(__start_rodata), (unsigned long)__start_rodata,
+	update_mapping_prot(__pa_symbol(__start_rodata), (unsigned long)__start_rodata,
 			    section_size, PAGE_KERNEL_RO);
 
-	/* flush the TLBs after updating live kernel mappings */
-	flush_tlb_all();
-
 	debug_checkwx();
 }
 
-- 
2.7.4
