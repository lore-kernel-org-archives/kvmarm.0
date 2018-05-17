From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 3/4] KVM: arm/arm64: Remove unnecessary CMOs when creating HYP
 page tables
Date: Thu, 17 May 2018 11:35:47 +0100
Message-ID: <20180517103548.5622-4-marc.zyngier@arm.com>
References: <20180517103548.5622-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC0154A0EF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 May 2018 06:26:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PnbJPkFJ5IY7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 May 2018 06:25:50 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F40BA4A0EE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 May 2018 06:25:49 -0400 (EDT)
In-Reply-To: <20180517103548.5622-1-marc.zyngier@arm.com>
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
Cc: Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

There is no need to perform cache maintenance operations when
creating the HYP page tables if we have the multiprocessing
extensions. ARMv7 mandates them with the virtualization support,
and ARMv8 just mandates them unconditionally.

Let's remove these operations.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/mmu.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index ba66bf7ae299..acbfea09578c 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -578,7 +578,6 @@ static void create_hyp_pte_mappings(pmd_t *pmd, unsigned long start,
 		pte = pte_offset_kernel(pmd, addr);
 		kvm_set_pte(pte, pfn_pte(pfn, prot));
 		get_page(virt_to_page(pte));
-		kvm_flush_dcache_to_poc(pte, sizeof(*pte));
 		pfn++;
 	} while (addr += PAGE_SIZE, addr != end);
 }
@@ -605,7 +604,6 @@ static int create_hyp_pmd_mappings(pud_t *pud, unsigned long start,
 			}
 			pmd_populate_kernel(NULL, pmd, pte);
 			get_page(virt_to_page(pmd));
-			kvm_flush_dcache_to_poc(pmd, sizeof(*pmd));
 		}
 
 		next = pmd_addr_end(addr, end);
@@ -638,7 +636,6 @@ static int create_hyp_pud_mappings(pgd_t *pgd, unsigned long start,
 			}
 			pud_populate(NULL, pud, pmd);
 			get_page(virt_to_page(pud));
-			kvm_flush_dcache_to_poc(pud, sizeof(*pud));
 		}
 
 		next = pud_addr_end(addr, end);
@@ -675,7 +672,6 @@ static int __create_hyp_mappings(pgd_t *pgdp, unsigned long ptrs_per_pgd,
 			}
 			pgd_populate(NULL, pgd, pud);
 			get_page(virt_to_page(pgd));
-			kvm_flush_dcache_to_poc(pgd, sizeof(*pgd));
 		}
 
 		next = pgd_addr_end(addr, end);
@@ -685,6 +681,7 @@ static int __create_hyp_mappings(pgd_t *pgdp, unsigned long ptrs_per_pgd,
 		pfn += (next - addr) >> PAGE_SHIFT;
 	} while (addr = next, addr != end);
 out:
+	dsb(ishst);
 	mutex_unlock(&kvm_hyp_pgd_mutex);
 	return err;
 }
-- 
2.14.2
