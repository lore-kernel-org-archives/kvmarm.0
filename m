From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 16/55] arm/arm64: KVM: Always have merged page tables
Date: Fri, 22 Jul 2016 18:28:33 +0100
Message-ID: <1469208552-4155-17-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Dan Carpenter <dan.carpenter@oracle.com>, Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

We're in a position where we can now always have "merged" page
tables, where both the runtime mapping and the idmap coexist.

This results in some code being removed, but there is more to come.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/mmu.c     | 74 +++++++++++++++++++++++---------------------------
 arch/arm64/kvm/reset.c | 31 +++++----------------
 2 files changed, 41 insertions(+), 64 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index f004e70..80d3737 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -492,13 +492,12 @@ void free_boot_hyp_pgd(void)
 
 	if (boot_hyp_pgd) {
 		unmap_hyp_range(boot_hyp_pgd, hyp_idmap_start, PAGE_SIZE);
-		unmap_hyp_range(boot_hyp_pgd, TRAMPOLINE_VA, PAGE_SIZE);
 		free_pages((unsigned long)boot_hyp_pgd, hyp_pgd_order);
 		boot_hyp_pgd = NULL;
 	}
 
 	if (hyp_pgd)
-		unmap_hyp_range(hyp_pgd, TRAMPOLINE_VA, PAGE_SIZE);
+		unmap_hyp_range(hyp_pgd, hyp_idmap_start, PAGE_SIZE);
 
 	mutex_unlock(&kvm_hyp_pgd_mutex);
 }
@@ -1691,7 +1690,7 @@ phys_addr_t kvm_mmu_get_boot_httbr(void)
 	if (__kvm_cpu_uses_extended_idmap())
 		return virt_to_phys(merged_hyp_pgd);
 	else
-		return virt_to_phys(boot_hyp_pgd);
+		return virt_to_phys(hyp_pgd);
 }
 
 phys_addr_t kvm_get_idmap_vector(void)
@@ -1704,6 +1703,22 @@ phys_addr_t kvm_get_idmap_start(void)
 	return hyp_idmap_start;
 }
 
+static int kvm_map_idmap_text(pgd_t *pgd)
+{
+	int err;
+
+	/* Create the idmap in the boot page tables */
+	err = 	__create_hyp_mappings(pgd,
+				      hyp_idmap_start, hyp_idmap_end,
+				      __phys_to_pfn(hyp_idmap_start),
+				      PAGE_HYP_EXEC);
+	if (err)
+		kvm_err("Failed to idmap %lx-%lx\n",
+			hyp_idmap_start, hyp_idmap_end);
+
+	return err;
+}
+
 int kvm_mmu_init(void)
 {
 	int err;
@@ -1719,27 +1734,25 @@ int kvm_mmu_init(void)
 	BUG_ON((hyp_idmap_start ^ (hyp_idmap_end - 1)) & PAGE_MASK);
 
 	hyp_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, hyp_pgd_order);
-	boot_hyp_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, hyp_pgd_order);
-
-	if (!hyp_pgd || !boot_hyp_pgd) {
+	if (!hyp_pgd) {
 		kvm_err("Hyp mode PGD not allocated\n");
 		err = -ENOMEM;
 		goto out;
 	}
 
-	/* Create the idmap in the boot page tables */
-	err = 	__create_hyp_mappings(boot_hyp_pgd,
-				      hyp_idmap_start, hyp_idmap_end,
-				      __phys_to_pfn(hyp_idmap_start),
-				      PAGE_HYP_EXEC);
+	if (__kvm_cpu_uses_extended_idmap()) {
+		boot_hyp_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+							 hyp_pgd_order);
+		if (!boot_hyp_pgd) {
+			kvm_err("Hyp boot PGD not allocated\n");
+			err = -ENOMEM;
+			goto out;
+		}
 
-	if (err) {
-		kvm_err("Failed to idmap %lx-%lx\n",
-			hyp_idmap_start, hyp_idmap_end);
-		goto out;
-	}
+		err = kvm_map_idmap_text(boot_hyp_pgd);
+		if (err)
+			goto out;
 
-	if (__kvm_cpu_uses_extended_idmap()) {
 		merged_hyp_pgd = (pgd_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
 		if (!merged_hyp_pgd) {
 			kvm_err("Failed to allocate extra HYP pgd\n");
@@ -1747,29 +1760,10 @@ int kvm_mmu_init(void)
 		}
 		__kvm_extend_hypmap(boot_hyp_pgd, hyp_pgd, merged_hyp_pgd,
 				    hyp_idmap_start);
-		return 0;
-	}
-
-	/* Map the very same page at the trampoline VA */
-	err = 	__create_hyp_mappings(boot_hyp_pgd,
-				      TRAMPOLINE_VA, TRAMPOLINE_VA + PAGE_SIZE,
-				      __phys_to_pfn(hyp_idmap_start),
-				      PAGE_HYP_EXEC);
-	if (err) {
-		kvm_err("Failed to map trampoline @%lx into boot HYP pgd\n",
-			TRAMPOLINE_VA);
-		goto out;
-	}
-
-	/* Map the same page again into the runtime page tables */
-	err = 	__create_hyp_mappings(hyp_pgd,
-				      TRAMPOLINE_VA, TRAMPOLINE_VA + PAGE_SIZE,
-				      __phys_to_pfn(hyp_idmap_start),
-				      PAGE_HYP_EXEC);
-	if (err) {
-		kvm_err("Failed to map trampoline @%lx into runtime HYP pgd\n",
-			TRAMPOLINE_VA);
-		goto out;
+	} else {
+		err = kvm_map_idmap_text(hyp_pgd);
+		if (err)
+			goto out;
 	}
 
 	return 0;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 7be24f2..8ed7e4a 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -133,30 +133,13 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	return kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq);
 }
 
-extern char __hyp_idmap_text_start[];
-
 unsigned long kvm_hyp_reset_entry(void)
 {
-	if (!__kvm_cpu_uses_extended_idmap()) {
-		unsigned long offset;
-
-		/*
-		 * Find the address of __kvm_hyp_reset() in the trampoline page.
-		 * This is present in the running page tables, and the boot page
-		 * tables, so we call the code here to start the trampoline
-		 * dance in reverse.
-		 */
-		offset = (unsigned long)__kvm_hyp_reset
-			 - ((unsigned long)__hyp_idmap_text_start & PAGE_MASK);
-
-		return TRAMPOLINE_VA + offset;
-	} else {
-		/*
-		 * KVM is running with merged page tables, which don't have the
-		 * trampoline page mapped. We know the idmap is still mapped,
-		 * but can't be called into directly. Use
-		 * __extended_idmap_trampoline to do the call.
-		 */
-		return (unsigned long)kvm_ksym_ref(__extended_idmap_trampoline);
-	}
+	/*
+	 * KVM is running with merged page tables, which don't have the
+	 * trampoline page mapped. We know the idmap is still mapped,
+	 * but can't be called into directly. Use
+	 * __extended_idmap_trampoline to do the call.
+	 */
+	return (unsigned long)kvm_ksym_ref(__extended_idmap_trampoline);
 }
-- 
2.8.1

