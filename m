From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 19/55] arm/arm64: KVM: Kill free_boot_hyp_pgd
Date: Fri, 22 Jul 2016 18:28:36 +0100
Message-ID: <1469208552-4155-20-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9861F49B98
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:24:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sUVjaLLoMVmp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 13:24:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B63ED49B8A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:24:06 -0400 (EDT)
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

There is no way to free the boot PGD, because it doesn't exist
anymore as a standalone entity.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_mmu.h   |  1 -
 arch/arm/kvm/arm.c               |  4 ----
 arch/arm/kvm/mmu.c               | 30 +++++++-----------------------
 arch/arm64/include/asm/kvm_mmu.h |  1 -
 4 files changed, 7 insertions(+), 29 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 5d161d1..d5fd9fb 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -51,7 +51,6 @@
 
 int create_hyp_mappings(void *from, void *to, pgprot_t prot);
 int create_hyp_io_mappings(void *from, void *to, phys_addr_t);
-void free_boot_hyp_pgd(void);
 void free_hyp_pgds(void);
 
 void stage2_unmap_vm(struct kvm *kvm);
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 0887cc1..9b8c537 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -1323,10 +1323,6 @@ static int init_hyp_mode(void)
 		}
 	}
 
-#ifndef CONFIG_HOTPLUG_CPU
-	free_boot_hyp_pgd();
-#endif
-
 	/* set size of VMID supported by CPU */
 	kvm_vmid_bits = kvm_get_vmid_bits();
 	kvm_info("%d-bit VMID\n", kvm_vmid_bits);
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index dd4ccc7..0b36dd52 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -482,27 +482,6 @@ static void unmap_hyp_range(pgd_t *pgdp, phys_addr_t start, u64 size)
 }
 
 /**
- * free_boot_hyp_pgd - free HYP boot page tables
- *
- * Free the HYP boot page tables. The bounce page is also freed.
- */
-void free_boot_hyp_pgd(void)
-{
-	mutex_lock(&kvm_hyp_pgd_mutex);
-
-	if (boot_hyp_pgd) {
-		unmap_hyp_range(boot_hyp_pgd, hyp_idmap_start, PAGE_SIZE);
-		free_pages((unsigned long)boot_hyp_pgd, hyp_pgd_order);
-		boot_hyp_pgd = NULL;
-	}
-
-	if (hyp_pgd)
-		unmap_hyp_range(hyp_pgd, hyp_idmap_start, PAGE_SIZE);
-
-	mutex_unlock(&kvm_hyp_pgd_mutex);
-}
-
-/**
  * free_hyp_pgds - free Hyp-mode page tables
  *
  * Assumes hyp_pgd is a page table used strictly in Hyp-mode and
@@ -516,11 +495,16 @@ void free_hyp_pgds(void)
 {
 	unsigned long addr;
 
-	free_boot_hyp_pgd();
-
 	mutex_lock(&kvm_hyp_pgd_mutex);
 
+	if (boot_hyp_pgd) {
+		unmap_hyp_range(boot_hyp_pgd, hyp_idmap_start, PAGE_SIZE);
+		free_pages((unsigned long)boot_hyp_pgd, hyp_pgd_order);
+		boot_hyp_pgd = NULL;
+	}
+
 	if (hyp_pgd) {
+		unmap_hyp_range(hyp_pgd, hyp_idmap_start, PAGE_SIZE);
 		for (addr = PAGE_OFFSET; virt_addr_valid(addr); addr += PGDIR_SIZE)
 			unmap_hyp_range(hyp_pgd, KERN_TO_HYP(addr), PGDIR_SIZE);
 		for (addr = VMALLOC_START; is_vmalloc_addr((void*)addr); addr += PGDIR_SIZE)
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 390acab..b89122e 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -156,7 +156,6 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
 
 int create_hyp_mappings(void *from, void *to, pgprot_t prot);
 int create_hyp_io_mappings(void *from, void *to, phys_addr_t);
-void free_boot_hyp_pgd(void);
 void free_hyp_pgds(void);
 
 void stage2_unmap_vm(struct kvm *kvm);
-- 
2.8.1
