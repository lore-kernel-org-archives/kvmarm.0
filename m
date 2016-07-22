From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 24/55] arm/arm64: Get rid of KERN_TO_HYP
Date: Fri, 22 Jul 2016 18:28:41 +0100
Message-ID: <1469208552-4155-25-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB6F349BB3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:24:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VJ6aELf7Lk7x for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 13:24:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AEF1049BA0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:24:16 -0400 (EDT)
In-Reply-To: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: kvmarm@lists.cs.columbia.edu

We have both KERN_TO_HYP and kern_hyp_va, which do the exact same
thing. Let's standardize on the latter.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_hyp.h   |  2 --
 arch/arm/include/asm/kvm_mmu.h   |  2 +-
 arch/arm/kvm/mmu.c               | 18 +++++++++---------
 arch/arm64/include/asm/kvm_mmu.h |  1 -
 4 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
index e38fce2..6eaff28 100644
--- a/arch/arm/include/asm/kvm_hyp.h
+++ b/arch/arm/include/asm/kvm_hyp.h
@@ -25,8 +25,6 @@
 
 #define __hyp_text __section(.hyp.text) notrace
 
-#define kern_hyp_va(v) (v)
-
 #define __ACCESS_CP15(CRn, Op1, CRm, Op2)	\
 	"mrc", "mcr", __stringify(p15, Op1, %0, CRn, CRm, Op2), u32
 #define __ACCESS_CP15_64(Op1, CRm)		\
diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 73c2818..3bb803d 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -26,7 +26,7 @@
  * We directly use the kernel VA for the HYP, as we can directly share
  * the mapping (HTTBR "covers" TTBR1).
  */
-#define KERN_TO_HYP(kva)	(kva)
+#define kern_hyp_va(kva)	(kva)
 
 /*
  * KVM_MMU_CACHE_MIN_PAGES is the number of stage2 page table translation levels.
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 8a0aa37..bda27b6 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -506,9 +506,9 @@ void free_hyp_pgds(void)
 	if (hyp_pgd) {
 		unmap_hyp_range(hyp_pgd, hyp_idmap_start, PAGE_SIZE);
 		for (addr = PAGE_OFFSET; virt_addr_valid(addr); addr += PGDIR_SIZE)
-			unmap_hyp_range(hyp_pgd, KERN_TO_HYP(addr), PGDIR_SIZE);
+			unmap_hyp_range(hyp_pgd, kern_hyp_va(addr), PGDIR_SIZE);
 		for (addr = VMALLOC_START; is_vmalloc_addr((void*)addr); addr += PGDIR_SIZE)
-			unmap_hyp_range(hyp_pgd, KERN_TO_HYP(addr), PGDIR_SIZE);
+			unmap_hyp_range(hyp_pgd, kern_hyp_va(addr), PGDIR_SIZE);
 
 		free_pages((unsigned long)hyp_pgd, hyp_pgd_order);
 		hyp_pgd = NULL;
@@ -670,8 +670,8 @@ int create_hyp_mappings(void *from, void *to, pgprot_t prot)
 {
 	phys_addr_t phys_addr;
 	unsigned long virt_addr;
-	unsigned long start = KERN_TO_HYP((unsigned long)from);
-	unsigned long end = KERN_TO_HYP((unsigned long)to);
+	unsigned long start = kern_hyp_va((unsigned long)from);
+	unsigned long end = kern_hyp_va((unsigned long)to);
 
 	if (is_kernel_in_hyp_mode())
 		return 0;
@@ -705,8 +705,8 @@ int create_hyp_mappings(void *from, void *to, pgprot_t prot)
  */
 int create_hyp_io_mappings(void *from, void *to, phys_addr_t phys_addr)
 {
-	unsigned long start = KERN_TO_HYP((unsigned long)from);
-	unsigned long end = KERN_TO_HYP((unsigned long)to);
+	unsigned long start = kern_hyp_va((unsigned long)from);
+	unsigned long end = kern_hyp_va((unsigned long)to);
 
 	if (is_kernel_in_hyp_mode())
 		return 0;
@@ -1711,10 +1711,10 @@ int kvm_mmu_init(void)
 
 	kvm_info("IDMAP page: %lx\n", hyp_idmap_start);
 	kvm_info("HYP VA range: %lx:%lx\n",
-		 KERN_TO_HYP(PAGE_OFFSET), KERN_TO_HYP(~0UL));
+		 kern_hyp_va(PAGE_OFFSET), kern_hyp_va(~0UL));
 
-	if (hyp_idmap_start >= KERN_TO_HYP(PAGE_OFFSET) &&
-	    hyp_idmap_start <  KERN_TO_HYP(~0UL)) {
+	if (hyp_idmap_start >= kern_hyp_va(PAGE_OFFSET) &&
+	    hyp_idmap_start <  kern_hyp_va(~0UL)) {
 		/*
 		 * The idmap page is intersecting with the VA space,
 		 * it is not safe to continue further.
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 9226f8b..b6bb834 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -133,7 +133,6 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
 }
 
 #define kern_hyp_va(v) 	(typeof(v))(__kern_hyp_va((unsigned long)(v)))
-#define KERN_TO_HYP(v)	kern_hyp_va(v)
 
 /*
  * We currently only support a 40bit IPA.
-- 
2.8.1
