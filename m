From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] ARM, arm64: kvm: get rid of the bounce page
Date: Tue, 24 Feb 2015 17:16:23 +0000
Message-ID: <1424798183-3202-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 664F446761
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 12:10:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mlg250hZAf-a for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Feb 2015 12:10:49 -0500 (EST)
Received: from mail-wg0-f49.google.com (mail-wg0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B82C446760
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 12:10:48 -0500 (EST)
Received: by wghl2 with SMTP id l2so6725184wgh.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 09:16:29 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: catalin.marinas@arm.com, will.deacon@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

The HYP init bounce page is a runtime construct that ensures that the
HYP init code does not cross a page boundary. However, this is something
we can do perfectly well at build time, by aligning the code appropriately.

For arm64, we just align to PAGE_SIZE, the rationale being that you are
either running with 4k page size, in which case the 2k vector table plus
the code size don't leave much of the page unused, or you are running with
64k page size, and you don't care about wasting memory anyway.

For ARM, the whole code is less than 256 bytes, so we tweak the linker
script to align at a power of 2 upper bound of the code size

Note that this also fixes a benign off-by-one error in the original bounce
page code, where a bounce page would be allocated unnecessarily if the code
was exactly 1 page in size.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/kernel/vmlinux.lds.S   | 12 +++++++++---
 arch/arm/kvm/init.S             | 11 +++++++++++
 arch/arm/kvm/mmu.c              | 42 +++++------------------------------------
 arch/arm64/kernel/vmlinux.lds.S | 18 ++++++++++++------
 4 files changed, 37 insertions(+), 46 deletions(-)

diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index b31aa73e8076..8179d3903dee 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -23,7 +23,7 @@
 	VMLINUX_SYMBOL(__idmap_text_start) = .;				\
 	*(.idmap.text)							\
 	VMLINUX_SYMBOL(__idmap_text_end) = .;				\
-	. = ALIGN(32);							\
+	. = ALIGN(1 << __hyp_idmap_align_order);			\
 	VMLINUX_SYMBOL(__hyp_idmap_text_start) = .;			\
 	*(.hyp.idmap.text)						\
 	VMLINUX_SYMBOL(__hyp_idmap_text_end) = .;
@@ -346,8 +346,14 @@ SECTIONS
  */
 ASSERT((__proc_info_end - __proc_info_begin), "missing CPU support")
 ASSERT((__arch_info_end - __arch_info_begin), "no machine record defined")
+
 /*
- * The HYP init code can't be more than a page long.
+ * The HYP init code can't be more than a page long,
+ * and should not cross a page boundary.
  * The above comment applies as well.
  */
-ASSERT(((__hyp_idmap_text_end - __hyp_idmap_text_start) <= PAGE_SIZE), "HYP init code too big")
+ASSERT(((__hyp_idmap_text_end - 1) & PAGE_MASK) -
+	(__hyp_idmap_text_start & PAGE_MASK) == 0,
+	"HYP init code too big or unaligned")
+ASSERT(__hyp_idmap_size <= (1 << __hyp_idmap_align_order),
+	"__hyp_idmap_size should be <= (1 << __hyp_idmap_align_order)")
diff --git a/arch/arm/kvm/init.S b/arch/arm/kvm/init.S
index 3988e72d16ff..7a279bc8e0e1 100644
--- a/arch/arm/kvm/init.S
+++ b/arch/arm/kvm/init.S
@@ -157,3 +157,14 @@ target:	@ We're now in the trampoline code, switch page tables
 __kvm_hyp_init_end:
 
 	.popsection
+
+	/*
+	 * When making changes to this file, make sure that the value of
+	 * __hyp_idmap_align_order is updated if the size of the code ends up
+	 * exceeding (1 << __hyp_idmap_align_order). This helps ensure that the
+	 * code never crosses a page boundary, without wasting too much memory
+	 * on aligning to PAGE_SIZE.
+	 */
+	.global	__hyp_idmap_size, __hyp_idmap_align_order
+	.set	__hyp_idmap_size, __kvm_hyp_init_end - __kvm_hyp_init
+	.set	__hyp_idmap_align_order, 8
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 3e6859bc3e11..42a24d6b003b 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -37,7 +37,6 @@ static pgd_t *boot_hyp_pgd;
 static pgd_t *hyp_pgd;
 static DEFINE_MUTEX(kvm_hyp_pgd_mutex);
 
-static void *init_bounce_page;
 static unsigned long hyp_idmap_start;
 static unsigned long hyp_idmap_end;
 static phys_addr_t hyp_idmap_vector;
@@ -405,9 +404,6 @@ void free_boot_hyp_pgd(void)
 	if (hyp_pgd)
 		unmap_range(NULL, hyp_pgd, TRAMPOLINE_VA, PAGE_SIZE);
 
-	free_page((unsigned long)init_bounce_page);
-	init_bounce_page = NULL;
-
 	mutex_unlock(&kvm_hyp_pgd_mutex);
 }
 
@@ -1498,39 +1494,11 @@ int kvm_mmu_init(void)
 	hyp_idmap_end = kvm_virt_to_phys(__hyp_idmap_text_end);
 	hyp_idmap_vector = kvm_virt_to_phys(__kvm_hyp_init);
 
-	if ((hyp_idmap_start ^ hyp_idmap_end) & PAGE_MASK) {
-		/*
-		 * Our init code is crossing a page boundary. Allocate
-		 * a bounce page, copy the code over and use that.
-		 */
-		size_t len = __hyp_idmap_text_end - __hyp_idmap_text_start;
-		phys_addr_t phys_base;
-
-		init_bounce_page = (void *)__get_free_page(GFP_KERNEL);
-		if (!init_bounce_page) {
-			kvm_err("Couldn't allocate HYP init bounce page\n");
-			err = -ENOMEM;
-			goto out;
-		}
-
-		memcpy(init_bounce_page, __hyp_idmap_text_start, len);
-		/*
-		 * Warning: the code we just copied to the bounce page
-		 * must be flushed to the point of coherency.
-		 * Otherwise, the data may be sitting in L2, and HYP
-		 * mode won't be able to observe it as it runs with
-		 * caches off at that point.
-		 */
-		kvm_flush_dcache_to_poc(init_bounce_page, len);
-
-		phys_base = kvm_virt_to_phys(init_bounce_page);
-		hyp_idmap_vector += phys_base - hyp_idmap_start;
-		hyp_idmap_start = phys_base;
-		hyp_idmap_end = phys_base + len;
-
-		kvm_info("Using HYP init bounce page @%lx\n",
-			 (unsigned long)phys_base);
-	}
+	/*
+	 * We rely on the linker script to ensure at build time that the HYP
+	 * init code does not cross a page boundary.
+	 */
+	BUG_ON((hyp_idmap_start ^ (hyp_idmap_end - 1)) & PAGE_MASK);
 
 	hyp_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, hyp_pgd_order);
 	boot_hyp_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, hyp_pgd_order);
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 5d9d2dca530d..a01eedbe59eb 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -23,10 +23,14 @@ jiffies = jiffies_64;
 
 #define HYPERVISOR_TEXT					\
 	/*						\
-	 * Force the alignment to be compatible with	\
-	 * the vectors requirements			\
+	 * Align to PAGE_SIZE so that			\
+	 * a) the HYP vector table is at its minimum	\
+	 *    alignment of 2048 bytes			\
+	 * b) the HYP init code will not cross a page	\
+	 *    boundary if its size does not exceed	\
+	 *    PAGE_SIZE (see related ASSERT() below)	\
 	 */						\
-	. = ALIGN(2048);				\
+	. = ALIGN(PAGE_SIZE);				\
 	VMLINUX_SYMBOL(__hyp_idmap_text_start) = .;	\
 	*(.hyp.idmap.text)				\
 	VMLINUX_SYMBOL(__hyp_idmap_text_end) = .;	\
@@ -163,10 +167,12 @@ SECTIONS
 }
 
 /*
- * The HYP init code can't be more than a page long.
+ * The HYP init code can't be more than a page long,
+ * and should not cross a page boundary.
  */
-ASSERT(((__hyp_idmap_text_start + PAGE_SIZE) > __hyp_idmap_text_end),
-       "HYP init code too big")
+ASSERT(((__hyp_idmap_text_end - 1) & PAGE_MASK) -
+	(__hyp_idmap_text_start & PAGE_MASK) == 0,
+	"HYP init code too big or unaligned")
 
 /*
  * If padding is applied before .head.text, virt<->phys conversions will fail.
-- 
1.8.3.2
