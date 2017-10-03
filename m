From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 03/31] KVM: arm/arm64: Remove unused params in mmu functions
Date: Mon,  2 Oct 2017 22:10:45 -0500
Message-ID: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
Cc: jintack@cs.columbia.edu, pbonzini@redhat.com, rkrcmar@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Jintack Lim <jintack.lim@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

stage2_flush_xxx functions take a pointer to the kvm struct as the first
parameter but they are never used. Clean this up before modifying mmu
code for nested virtualization support.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 virt/kvm/arm/mmu.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index f2d5b6c..0a5f5ca 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -315,8 +315,7 @@ static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
 	} while (pgd++, addr = next, addr != end);
 }
 
-static void stage2_flush_ptes(struct kvm *kvm, pmd_t *pmd,
-			      phys_addr_t addr, phys_addr_t end)
+static void stage2_flush_ptes(pmd_t *pmd, phys_addr_t addr, phys_addr_t end)
 {
 	pte_t *pte;
 
@@ -327,8 +326,7 @@ static void stage2_flush_ptes(struct kvm *kvm, pmd_t *pmd,
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 }
 
-static void stage2_flush_pmds(struct kvm *kvm, pud_t *pud,
-			      phys_addr_t addr, phys_addr_t end)
+static void stage2_flush_pmds(pud_t *pud, phys_addr_t addr, phys_addr_t end)
 {
 	pmd_t *pmd;
 	phys_addr_t next;
@@ -340,13 +338,12 @@ static void stage2_flush_pmds(struct kvm *kvm, pud_t *pud,
 			if (pmd_thp_or_huge(*pmd))
 				kvm_flush_dcache_pmd(*pmd);
 			else
-				stage2_flush_ptes(kvm, pmd, addr, next);
+				stage2_flush_ptes(pmd, addr, next);
 		}
 	} while (pmd++, addr = next, addr != end);
 }
 
-static void stage2_flush_puds(struct kvm *kvm, pgd_t *pgd,
-			      phys_addr_t addr, phys_addr_t end)
+static void stage2_flush_puds(pgd_t *pgd, phys_addr_t addr, phys_addr_t end)
 {
 	pud_t *pud;
 	phys_addr_t next;
@@ -358,7 +355,7 @@ static void stage2_flush_puds(struct kvm *kvm, pgd_t *pgd,
 			if (stage2_pud_huge(*pud))
 				kvm_flush_dcache_pud(*pud);
 			else
-				stage2_flush_pmds(kvm, pud, addr, next);
+				stage2_flush_pmds(pud, addr, next);
 		}
 	} while (pud++, addr = next, addr != end);
 }
@@ -374,7 +371,7 @@ static void stage2_flush_memslot(struct kvm *kvm,
 	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
 	do {
 		next = stage2_pgd_addr_end(addr, end);
-		stage2_flush_puds(kvm, pgd, addr, next);
+		stage2_flush_puds(pgd, addr, next);
 	} while (pgd++, addr = next, addr != end);
 }
 
-- 
1.9.1
