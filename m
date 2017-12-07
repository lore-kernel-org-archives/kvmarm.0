From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] KVM: arm/arm64: Fix HYP unmapping going off limits
Date: Thu,  7 Dec 2017 11:45:45 +0000
Message-ID: <20171207114545.23845-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42A3D49D35
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 06:42:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wm1an1cJecJV for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Dec 2017 06:42:37 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A17449D20
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 06:42:37 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

When we unmap the HYP memory, we try to be clever and unmap one
PGD at a time. If we start with a non-PGD aligned address and try
to unmap a whole PGD, things go horribly wrong in unmap_hyp_range
(addr and end can never match, and it all goes really badly as we
keep incrementing pgd and parse random memory as page tables...).

The obvious fix is to let unmap_hyp_range do what it does best,
which is to iterate over a range.

Cc: stable@vger.kernel.org
Reported-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/mmu.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index b36945d49986..b4b69c2d1012 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -509,8 +509,6 @@ static void unmap_hyp_range(pgd_t *pgdp, phys_addr_t start, u64 size)
  */
 void free_hyp_pgds(void)
 {
-	unsigned long addr;
-
 	mutex_lock(&kvm_hyp_pgd_mutex);
 
 	if (boot_hyp_pgd) {
@@ -521,10 +519,10 @@ void free_hyp_pgds(void)
 
 	if (hyp_pgd) {
 		unmap_hyp_range(hyp_pgd, hyp_idmap_start, PAGE_SIZE);
-		for (addr = PAGE_OFFSET; virt_addr_valid(addr); addr += PGDIR_SIZE)
-			unmap_hyp_range(hyp_pgd, kern_hyp_va(addr), PGDIR_SIZE);
-		for (addr = VMALLOC_START; is_vmalloc_addr((void*)addr); addr += PGDIR_SIZE)
-			unmap_hyp_range(hyp_pgd, kern_hyp_va(addr), PGDIR_SIZE);
+		unmap_hyp_range(hyp_pgd, kern_hyp_va(PAGE_OFFSET),
+				(uintptr_t)high_memory - PAGE_OFFSET);
+		unmap_hyp_range(hyp_pgd, kern_hyp_va(VMALLOC_START),
+				VMALLOC_END - VMALLOC_START);
 
 		free_pages((unsigned long)hyp_pgd, hyp_pgd_order);
 		hyp_pgd = NULL;
-- 
2.14.2
